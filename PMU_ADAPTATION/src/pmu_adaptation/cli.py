from __future__ import annotations

import argparse
import json
import os
from pathlib import Path

from .planner import build_plans


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Strict PMU phase-2 PMDO adaptation pipeline")
    parser.add_argument("command", choices=("plan",))
    parser.add_argument("--repo-root", default=os.getcwd())
    parser.add_argument("--source-root")
    parser.add_argument("--output-root")
    parser.add_argument("--seed", type=int, default=20260814)
    args = parser.parse_args(argv)
    repo = Path(args.repo_root).resolve()
    source = Path(args.source_root).resolve() if args.source_root else repo / ".runtime-cache/pmu-extraction"
    output = Path(args.output_root).resolve() if args.output_root else repo / ".runtime-cache/pmu-adaptation"
    if args.command == "plan":
        report = build_plans(repo, source, output, repo / "PMU_ADAPTATION/reports", args.seed)
        print(json.dumps({
            "step": "plan", "status": report["status"], "map_count": report["map_count"],
            "ground_count": report["ground_count"], "certified_count": report["certified_count"],
        }, sort_keys=True))
    return 0
