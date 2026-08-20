#!/usr/bin/env python3
"""Run one isolated PMD Red EU fixture through PMDO's native unload path.

A PASS from this runner is deliberately narrower than merely observing the
validator's final capture.  PMDO itself must request and observe
``GameBase.LoadPhase.Unload``, publish data/graphics unload callbacks, return 0
without a signal, and leave no member of its process group behind.  A bounded
watchdog exists only to preserve a failed run; any watchdog action makes the
run ineligible for certification.
"""

from __future__ import annotations

import argparse
import fcntl
import hashlib
import json
import os
import shutil
import signal
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
BUNDLE = ROOT / ".runtime-cache/pmdo-headless-bundle"
PMDO = BUNDLE / "PMDO"
DOTNET = ROOT / ".runtime-cache/dotnet-headless"
DEFAULT_EVENTS = Path("/tmp/pmdred_eu_ground_validator.jsonl")
LOCK = ROOT / ".runtime-cache/recovery/pmdred_eu_native_runtime.lock"


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat(timespec="milliseconds")


def dump(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + ".tmp")
    temporary.write_text(json.dumps(value, indent=2) + "\n", encoding="utf-8")
    os.replace(temporary, path)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def pmdo_env(
    validator_mode: str = "pmdred_eu_native_fixture",
    overrides: dict[str, str] | None = None,
) -> dict[str, str]:
    """Return the complete exact-runtime environment for one native probe.

    The Ground campaign remains the default.  Narrow later gameplay validators
    may select a different opt-in service and add explicit environment values
    without copying this security- and termination-sensitive runner.
    """
    exact_runtime = {
        "DOTNET_BUNDLE_EXTRACT_BASE_DIR": str(DOTNET),
        "LD_LIBRARY_PATH": str(BUNDLE),
        "SDL_VIDEODRIVER": "offscreen",
        "SDL_AUDIODRIVER": "dummy",
        "SDL_VIDEO_GL_DRIVER": str(BUNDLE / "libGLESv2.so"),
        "SDL_VIDEO_EGL_DRIVER": str(BUNDLE / "libEGL.so"),
        "PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY": "1",
        "PMDO_HEADLESS_DISMISS_SPLASH": "1",
        "FNA3D_FORCE_DRIVER": "OpenGL",
        "FNA3D_OPENGL_FORCE_ES3": "1",
        "ANGLE_DEFAULT_PLATFORM": "vulkan",
        "VK_ICD_FILENAMES": str(BUNDLE / "vk_swiftshader_icd.absolute.json"),
        "PMDO_GROUND_VALIDATOR": validator_mode,
    }
    overrides = overrides or {}
    protected = sorted(set(exact_runtime).intersection(overrides))
    if protected:
        raise ValueError(
            "validator environment may not override exact-runtime values: "
            + ", ".join(protected)
        )
    env = dict(os.environ)
    env.update(exact_runtime)
    env.update(overrides)
    return env


def parse_environment(values: list[str] | None) -> dict[str, str]:
    result: dict[str, str] = {}
    for value in values or []:
        if "=" not in value:
            raise ValueError(f"--environment requires NAME=VALUE, got {value!r}")
        name, item = value.split("=", 1)
        if not name or not all(char.isalnum() or char == "_" for char in name):
            raise ValueError(f"invalid environment name: {name!r}")
        result[name] = item
    return result


def read_events(path: Path, *, strict: bool = False) -> list[dict[str, Any]]:
    if not path.is_file():
        return []
    result: list[dict[str, Any]] = []
    for number, line in enumerate(path.read_text(errors="replace").splitlines(), 1):
        if not line.strip():
            continue
        try:
            value = json.loads(line)
        except json.JSONDecodeError:
            if strict:
                raise RuntimeError(f"invalid validator JSON at line {number}")
            continue
        if not isinstance(value, dict):
            if strict:
                raise RuntimeError(f"non-object validator JSON at line {number}")
            continue
        result.append(value)
    return result


def process_group_members(pgid: int) -> list[dict[str, Any]]:
    members: list[dict[str, Any]] = []
    for stat_path in Path("/proc").glob("[0-9]*/stat"):
        try:
            raw = stat_path.read_text()
            close = raw.rfind(")")
            values = raw[close + 2 :].split()
            # Values after the command are: state, ppid, pgrp, session, ...
            if int(values[2]) != pgid:
                continue
            members.append(
                {
                    "pid": int(stat_path.parent.name),
                    "state": values[0],
                    "ppid": int(values[1]),
                    "process_group": int(values[2]),
                    "session": int(values[3]),
                }
            )
        except (FileNotFoundError, PermissionError, ValueError, IndexError):
            continue
    return sorted(members, key=lambda item: item["pid"])


def signal_group(pgid: int, requested: int) -> bool:
    try:
        os.killpg(pgid, requested)
        return True
    except ProcessLookupError:
        return False


def one_event(events: list[dict[str, Any]], kind: str) -> dict[str, Any] | None:
    found = [event for event in events if event.get("event") == kind]
    return found[0] if len(found) == 1 else None


def run(args: argparse.Namespace) -> int:
    fixture = args.fixture.resolve()
    if not (fixture / "asset").is_dir() or not (fixture / "appdata").is_dir():
        raise FileNotFoundError(f"incomplete fixture: {fixture}")
    if not PMDO.is_file():
        raise FileNotFoundError(PMDO)

    LOCK.parent.mkdir(parents=True, exist_ok=True)
    with LOCK.open("a+") as lock_stream:
        try:
            fcntl.flock(lock_stream, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError as exc:
            raise RuntimeError("another PMDO Ground runtime owns the isolation lock") from exc

        events_path = args.events
        if events_path.exists():
            preserved = fixture / "preexisting-validator-events.jsonl"
            if preserved.exists():
                raise FileExistsError(preserved)
            shutil.copyfile(events_path, preserved)
            events_path.unlink()

        runtime_log = fixture / "runtime.log"
        events_copy = fixture / "events.jsonl"
        termination_path = fixture / "termination.json"
        for output in (runtime_log, events_copy, termination_path):
            if output.exists():
                raise FileExistsError(output)

        command = [
            str(PMDO),
            "-asset",
            str(fixture / "asset") + "/",
            "-appdata",
            str(fixture / "appdata") + "/",
            "-quest",
            "pmdred_eu_fixture",
        ]
        started_at = utc_now()
        start = time.monotonic()
        watchdog = False
        requested_signal: str | None = None
        forced_kill = False
        watchdog_reason: str | None = None

        print(
            f"RUNTIME_START ground={args.ground} expected_screenshots={args.expected_screenshots} "
            f"deadline={args.timeout_seconds}s",
            flush=True,
        )
        validator_mode = getattr(args, "validator_mode", "pmdred_eu_native_fixture")
        environment_overrides = parse_environment(getattr(args, "environment", None))
        with runtime_log.open("wb") as stream:
            proc = subprocess.Popen(
                command,
                cwd=ROOT,
                env=pmdo_env(validator_mode, environment_overrides),
                stdout=stream,
                stderr=subprocess.STDOUT,
                start_new_session=True,
            )
            pgid = proc.pid
            last_progress = -10
            while proc.poll() is None:
                elapsed = int(time.monotonic() - start)
                if elapsed >= args.timeout_seconds:
                    watchdog = True
                    watchdog_reason = "deadline_exceeded"
                    requested_signal = "SIGTERM"
                    signal_group(pgid, signal.SIGTERM)
                    try:
                        proc.wait(timeout=5)
                    except subprocess.TimeoutExpired:
                        forced_kill = True
                        requested_signal = "SIGKILL"
                        signal_group(pgid, signal.SIGKILL)
                        proc.wait()
                    break
                if elapsed - last_progress >= 10:
                    last_progress = elapsed
                    events = read_events(events_path)
                    terminal = any(event.get("event") == "end" for event in events)
                    screenshots = len(list((fixture / "appdata/SCREENSHOT").glob("*.png")))
                    try:
                        cpu = subprocess.check_output(
                            ["ps", "-o", "%cpu=", "-p", str(proc.pid)], text=True
                        ).strip()
                    except subprocess.SubprocessError:
                        cpu = "exited"
                    print(
                        f"RUNTIME_PROGRESS ground={args.ground} seconds={elapsed} cpu={cpu} "
                        f"events={len(events)} screenshots={screenshots} terminal={str(terminal).lower()}",
                        flush=True,
                    )
                time.sleep(0.25)
            return_code = proc.wait()

        # Native success leaves an empty process group. A residual member makes
        # the run FAIL; bounded cleanup prevents a failed fixture leaking into
        # a later isolated run and is explicitly recorded as signal use.
        time.sleep(0.1)
        group_before_cleanup = process_group_members(pgid)
        if group_before_cleanup:
            watchdog = True
            watchdog_reason = "orphan_process_group"
            requested_signal = "SIGTERM"
            signal_group(pgid, signal.SIGTERM)
            time.sleep(1)
            if process_group_members(pgid):
                forced_kill = True
                requested_signal = "SIGKILL"
                signal_group(pgid, signal.SIGKILL)
                time.sleep(0.1)
        group_after_cleanup = process_group_members(pgid)

        if events_path.is_file():
            shutil.copyfile(events_path, events_copy)
        else:
            events_copy.write_text("", encoding="utf-8")
        try:
            events = read_events(events_copy, strict=True)
            event_parse_error = None
        except RuntimeError as exc:
            events = read_events(events_copy)
            event_parse_error = str(exc)

        unload = one_event(events, "load_phase_unload_requested")
        deinit = one_event(events, "native_deinit")
        graphics_unload = one_event(events, "native_graphics_unload")
        terminal_event = one_event(events, "end")
        screenshots = len(list((fixture / "appdata/SCREENSHOT").glob("*.png")))
        runtime_text = runtime_log.read_text(errors="replace")
        sigsegv = return_code == -signal.SIGSEGV or any(
            token in runtime_text.lower() for token in ("sigsegv", "segmentation fault")
        )
        normal_exit = return_code == 0
        lifecycle_order_ok = bool(
            unload
            and deinit
            and graphics_unload
            and terminal_event
            and events.index(unload) < events.index(deinit)
            < events.index(graphics_unload) < events.index(terminal_event)
            and events.index(terminal_event) == len(events) - 1
        )
        load_phase_ok = bool(
            lifecycle_order_ok
            and unload.get("requested") == "Unload"
            and unload.get("readback") == "Unload"
            and deinit.get("load_phase") == "Unload"
            and graphics_unload.get("load_phase") == "Unload"
        )
        terminal = bool(
            terminal_event
            and terminal_event.get("terminal") is True
            and terminal_event.get("graceful") is True
            and terminal_event.get("load_phase") == "Unload"
        )
        orphan = bool(group_before_cleanup or group_after_cleanup)
        graceful = bool(
            normal_exit
            and terminal
            and load_phase_ok
            and not watchdog
            and requested_signal is None
            and not forced_kill
            and not sigsegv
            and not orphan
            and event_parse_error is None
            and screenshots == args.expected_screenshots
        )
        result = "PASS" if graceful else "FAIL"
        ended_at = utc_now()
        record = {
            "schema": "new-era.pmdred-eu-native-termination.v1",
            "ground": args.ground,
            "result": result,
            "command": command,
            "validator_mode": validator_mode,
            "environment_overrides": environment_overrides,
            "started_at": started_at,
            "ended_at": ended_at,
            "duration_seconds": round(time.monotonic() - start, 3),
            "pid": proc.pid,
            "process_group": pgid,
            "pmdo_executable_sha256": sha256(PMDO),
            "load_phase_unload": {
                "requested": bool(unload),
                "request_event": unload,
                "deinit_event": deinit,
                "graphics_unload_event": graphics_unload,
                "terminal_event": terminal_event,
                "ordered_and_terminal_last": lifecycle_order_ok,
                "pass": load_phase_ok,
            },
            "exit_classification": "NORMAL_EXIT" if normal_exit else (
                f"SIGNAL_{-return_code}" if return_code < 0 else "NONZERO_EXIT"
            ),
            "return_code": return_code,
            "terminal": terminal,
            "graceful": graceful,
            "watchdog": watchdog,
            "watchdog_reason": watchdog_reason,
            "requested_signal": requested_signal,
            "sigsegv": sigsegv,
            "forced_kill": forced_kill,
            "orphan_process": orphan,
            "process_group_members_before_cleanup": group_before_cleanup,
            "process_group_members_after_cleanup": group_after_cleanup,
            "event_parse_error": event_parse_error,
            "event_count": len(events),
            "event_stream_sha256": sha256(events_copy),
            "expected_screenshot_count": args.expected_screenshots,
            "actual_screenshot_count": screenshots,
            "runtime_log_sha256": sha256(runtime_log),
        }
        dump(termination_path, record)
        print(
            f"RUNTIME_{result} ground={args.ground} rc={return_code} terminal={str(terminal).lower()} "
            f"graceful={str(graceful).lower()} watchdog={str(watchdog).lower()} "
            f"signal={requested_signal or 'none'} orphan={str(orphan).lower()}",
            flush=True,
        )
        if not graceful:
            raise RuntimeError(
                f"native PMDO termination gate failed for {args.ground}; evidence: {termination_path}"
            )
        return 0


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser()
    result.add_argument("--fixture", type=Path, required=True)
    result.add_argument("--ground", required=True)
    result.add_argument("--expected-screenshots", type=int, required=True)
    result.add_argument("--timeout-seconds", type=int, default=1800)
    result.add_argument("--events", type=Path, default=DEFAULT_EVENTS)
    result.add_argument(
        "--validator-mode", default="pmdred_eu_native_fixture",
        help="exact opt-in value exported as PMDO_GROUND_VALIDATOR",
    )
    result.add_argument(
        "--environment", action="append", default=[], metavar="NAME=VALUE",
        help="additional explicit validator environment value; repeat as needed",
    )
    return result


def main() -> int:
    return run(parser().parse_args())


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"ERROR: {type(exc).__name__}: {exc}", file=sys.stderr, flush=True)
        raise
