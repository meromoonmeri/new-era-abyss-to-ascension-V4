#!/usr/bin/env python3
"""Run PMDO until validator ``end`` and classify its real termination status.

This runner deliberately does not hide ``wait``/``Popen.wait`` results. PMDO is
launched directly as a new process-group leader (without a ``timeout`` parent),
so the recorded return code belongs to PMDO itself. Once the fixed validator
stream contains its terminal event, the requested shutdown signal is sent only
to PMDO. SIGINT is the official default: repeated exact-runtime controls proved
it avoids the SwiftShader SIGTERM teardown race. The requested signal's direct
or managed ``128+signal`` status is accepted; SIGSEGV and all other statuses
fail the gate.

The runner is transport/lifecycle plumbing only.  It does not build, convert,
compare, install, or promote any Ground.
"""
from __future__ import annotations

import argparse
import json
import os
import signal
import subprocess
import time
from pathlib import Path
from typing import Any


def classify_returncode(returncode: int, requested_signal: int, forced_kill: bool) -> dict[str, Any]:
    """Classify a direct ``Popen.wait`` result without normalizing it away."""
    exit_signal = -returncode if returncode < 0 else None
    if forced_kill:
        kind, result = "FORCED_KILL", "FAIL"
    elif returncode == 0:
        kind, result = "NORMAL_EXIT", "PASS"
    elif returncode == -signal.SIGSEGV:
        kind, result = "SIGSEGV", "FAIL"
    elif returncode == -requested_signal:
        kind, result = f"EXPECTED_{signal.Signals(requested_signal).name}_SIGNAL", "PASS"
    elif returncode == 128 + requested_signal:
        # Some managed apphosts consume the Unix signal and exit explicitly
        # with the conventional 128+signal status.  wait(2) reports WIFEXITED,
        # not WIFSIGNALED; retain that distinction instead of rewriting 143 as
        # "-SIGTERM".
        kind, result = f"EXPECTED_{signal.Signals(requested_signal).name}_EXIT_CODE", "PASS"
    elif returncode < 0:
        kind, result = f"UNEXPECTED_{signal.Signals(-returncode).name}", "FAIL"
    else:
        kind, result = "NONZERO_EXIT", "FAIL"
    return {
        "result": result,
        "kind": kind,
        "returncode": returncode,
        "wait_state": "SIGNALED" if returncode < 0 else "EXITED",
        "normal_exit": returncode == 0,
        "exit_code": returncode if returncode >= 0 else None,
        "exit_signal": exit_signal,
        "exit_signal_name": signal.Signals(exit_signal).name if exit_signal else None,
        "segmentation_fault": exit_signal == signal.SIGSEGV,
        "forced_kill": forced_kill,
    }


def process_group_members(pgid: int) -> list[int]:
    """Return live PIDs whose Linux process-group ID equals ``pgid``."""
    members: list[int] = []
    for stat_path in Path("/proc").glob("[0-9]*/stat"):
        try:
            text = stat_path.read_text()
            # comm is parenthesized and can contain spaces; fields after it start
            # with state, ppid, pgrp.
            tail = text[text.rfind(")") + 2 :].split()
            if len(tail) >= 3 and int(tail[2]) == pgid:
                members.append(int(stat_path.parent.name))
        except (FileNotFoundError, PermissionError, ValueError):
            continue
    return sorted(members)


def has_terminal_event(path: Path) -> bool:
    try:
        return any(json.loads(line).get("event") == "end" for line in path.read_text().splitlines())
    except (FileNotFoundError, json.JSONDecodeError):
        return False


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--pmdo", type=Path, required=True)
    parser.add_argument("--asset", type=Path, required=True)
    parser.add_argument("--appdata", type=Path, required=True)
    parser.add_argument("--quest", required=True)
    parser.add_argument("--events", type=Path, default=Path("/tmp/pmdred_eu_ground_validator.jsonl"))
    parser.add_argument("--runtime-log", type=Path, required=True)
    parser.add_argument("--event-copy", type=Path, required=True)
    parser.add_argument("--status-json", type=Path, required=True)
    parser.add_argument("--terminal-timeout", type=float, default=1800.0)
    parser.add_argument("--shutdown-timeout", type=float, default=15.0)
    parser.add_argument("--post-end-delay", type=float, default=0.1)
    parser.add_argument("--shutdown-signal", choices=("TERM", "INT"), default="INT")
    parser.add_argument("--reset-events", action="store_true")
    args = parser.parse_args()

    for output in (args.runtime_log, args.event_copy, args.status_json):
        if output.exists():
            raise SystemExit(f"refusing existing output: {output}")
        output.parent.mkdir(parents=True, exist_ok=True)
    if args.events.exists():
        if not args.reset_events:
            raise SystemExit(f"validator stream already exists: {args.events}")
        args.events.unlink()

    shutdown_signal = getattr(signal, f"SIG{args.shutdown_signal}")
    command = [
        str(args.pmdo.resolve()),
        "-asset", str(args.asset.resolve()) + "/",
        "-appdata", str(args.appdata.resolve()) + "/",
        "-quest", args.quest,
    ]
    started = time.monotonic()
    with args.runtime_log.open("wb") as runtime_log:
        process = subprocess.Popen(
            command,
            stdout=runtime_log,
            stderr=subprocess.STDOUT,
            start_new_session=True,
        )
        pgid = process.pid
        terminal_seen = False
        terminal_seen_at: float | None = None
        deadline = started + args.terminal_timeout
        while time.monotonic() < deadline:
            if has_terminal_event(args.events):
                terminal_seen = True
                terminal_seen_at = time.monotonic()
                break
            if process.poll() is not None:
                break
            time.sleep(0.02)

        requested_signal_sent = False
        if terminal_seen and process.poll() is None:
            time.sleep(args.post_end_delay)
            os.kill(process.pid, shutdown_signal)
            requested_signal_sent = True

        forced_kill = False
        try:
            returncode = process.wait(timeout=args.shutdown_timeout)
        except subprocess.TimeoutExpired:
            forced_kill = True
            os.killpg(pgid, signal.SIGKILL)
            returncode = process.wait()

    # The leader has been reaped. Any remaining member is an orphan for this
    # bounded run and is removed only after being recorded as a gate failure.
    time.sleep(0.2)
    residual_members = process_group_members(pgid)
    if residual_members:
        try:
            os.killpg(pgid, signal.SIGKILL)
        except ProcessLookupError:
            pass
        time.sleep(0.1)
    residual_after_cleanup = process_group_members(pgid)

    event_bytes = args.events.read_bytes() if args.events.is_file() else b""
    args.event_copy.write_bytes(event_bytes)
    event_lines = event_bytes.decode(errors="replace").splitlines()
    parsed_events: list[dict[str, Any]] = []
    parse_error: str | None = None
    try:
        parsed_events = [json.loads(line) for line in event_lines]
    except json.JSONDecodeError as exc:
        parse_error = str(exc)

    termination = classify_returncode(returncode, shutdown_signal, forced_kill)
    if not terminal_seen or not requested_signal_sent or residual_members or residual_after_cleanup:
        termination["result"] = "FAIL"
    result = {
        "schema": "new-era.pmdred-eu-pmdo-termination-gate.v1",
        "command": command,
        "pmdo_pid": pgid,
        "requested_signal": int(shutdown_signal),
        "requested_signal_name": signal.Signals(shutdown_signal).name,
        "requested_signal_sent": requested_signal_sent,
        "terminal_seen": terminal_seen,
        "terminal_to_signal_seconds": None if terminal_seen_at is None else args.post_end_delay,
        "elapsed_seconds": round(time.monotonic() - started, 6),
        "event_count": len(event_lines),
        "event_parse_error": parse_error,
        "last_event": parsed_events[-1] if parsed_events else None,
        "residual_processes_before_cleanup": residual_members,
        "residual_processes_after_cleanup": residual_after_cleanup,
        "termination": termination,
    }
    args.status_json.write_text(json.dumps(result, indent=2) + "\n")
    print(
        "PMDO_TERMINATION_GATE_{} kind={} returncode={} signal={} terminal={} residual={}".format(
            termination["result"], termination["kind"], returncode,
            termination["exit_signal_name"], terminal_seen, len(residual_members)
        )
    )
    return 0 if termination["result"] == "PASS" else 3


if __name__ == "__main__":
    raise SystemExit(main())
