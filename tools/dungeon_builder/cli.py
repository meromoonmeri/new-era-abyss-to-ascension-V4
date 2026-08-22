"""Command line interface of the Dungeon Builder.

    python3 tools/dungeon_builder.py audit
    python3 tools/dungeon_builder.py preview sinister_woods --floor 7 --count 10
    python3 tools/dungeon_builder.py validate sinister_woods --count 10
    python3 tools/dungeon_builder.py generate sinister_woods
    python3 tools/dungeon_builder.py generate-all --chapters 6-32
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import List, Optional, Sequence

from .definitions import (DefinitionError, DungeonDefinition, find_definition, list_definitions,
                          load_definition)
from .dtef import DtefError, available_packages, resolve as resolve_dtef
from .grounds import check_grounds
from .profiles import BUILTIN_PROFILES, customize
from .report import build_report, write_report
from .rng import DungeonRng
from .validation import Thresholds, validate_floor
from .zone_export import build_zone, write_zone

ROOT = Path(__file__).resolve().parents[2]


def _profiles_for_floor(definition: DungeonDefinition, floor: int):
    segment = definition.segment_for_floor(floor)
    choices = definition.profiles_for(segment)
    return [customize(choice.name, choice.overrides) for choice in choices], segment


def cmd_audit(args) -> int:
    print("Architecture profiles (all built from native RogueElements steps):")
    for name, profile in sorted(BUILTIN_PROFILES.items()):
        print(f"  - {name:12s} path={profile.path:9s} connect={profile.connect_percent:3d}% "
              f"combine={profile.combine_rate:3d}% tags={','.join(profile.tags)}")
    print()
    packages = available_packages()
    print(f"DTEF packages imported in Data/AutoTile: {len(packages)}")
    for name, package in sorted(packages.items()):
        print(f"  - {name}: {package.floor} / {package.wall} / {package.secondary}")
    print()
    definitions = list_definitions()
    print(f"Dungeon definitions in DungeonDefs/canonical: {len(definitions)}")
    for path in definitions:
        try:
            definition = load_definition(path)
            print(f"  - {definition.id:20s} ch.{definition.chapter:<3d} "
                  f"{definition.floors:>3d} floors, {len(definition.segments)} segments")
        except DefinitionError as exc:
            print(f"  - {path.name}: INVALID ({exc})")
    return 0


def cmd_prototype(args) -> int:
    from .prototype import run_prototype, markdown, write_prototype_report
    if args.report:
        path = write_prototype_report(args.per_profile, args.seed)
        print(f"prototype report: {path}")
        return 0
    metrics, samples, rng, rejects = run_prototype(args.per_profile, args.seed)
    total = sum(len(v) for v in metrics.values())
    print(f"{total} floors generated (root debug seed {rng.seed})")
    for name, values in metrics.items():
        if not values:
            continue
        print(f"  {name:12s} rooms={min(m.rooms for m in values)}-{max(m.rooms for m in values):<3d} "
              f"halls~{round(sum(m.halls for m in values)/len(values),1):<5} "
              f"branches~{round(sum(m.branches for m in values)/len(values),1):<4} "
              f"loops~{round(sum(m.loops for m in values)/len(values),1):<4} "
              f"deadends~{round(sum(m.dead_ends for m in values)/len(values),1):<4} "
              f"rejected={rejects[name]} distinct={len({m.signature for m in values})}/{len(values)}")
    return 0


def cmd_preview(args) -> int:
    definition = load_definition(find_definition(args.dungeon))
    profiles, segment = _profiles_for_floor(definition, args.floor)
    rng = DungeonRng(seed=args.seed, label=f"preview:{definition.id}:{args.floor}")
    report, results = validate_floor(args.floor, profiles, rng, args.count,
                                     Thresholds(), keep_results=True)
    print(f"# preview {definition.id} floor {args.floor} (segment '{segment.name}')")
    print(f"root seed (debug): {rng.seed}")
    for variant, result in zip(report.accepted(), results):
        m = variant.metrics
        print(f"\n--- variant seed={variant.seed} profile={variant.profile} "
              f"rooms={m.rooms} halls={m.halls} branches={m.branches} dead_ends={m.dead_ends} "
              f"loops={m.loops} size={m.width}x{m.height} stairs_dist={m.stair_distance} "
              f"reachable={m.reachable_ratio}")
        if args.ascii:
            print(result.ascii_art())
    print(f"\naccepted={len(report.accepted())}/{args.count} rejected={report.rejected} "
          f"distinct_signatures={report.distinct_signatures} "
          f"max_similarity={report.max_pair_similarity}")
    return 0 if report.ok else 1


def _validate_all_floors(definition: DungeonDefinition, count: int, rng: DungeonRng,
                         thresholds: Optional[Thresholds] = None):
    validations = []
    for floor in range(1, definition.floors + 1):
        segment = definition.segment_for_floor(floor)
        if floor in segment.fixed_floors:
            continue
        profiles, _ = _profiles_for_floor(definition, floor)
        validation, _ = validate_floor(floor, profiles, rng, count, thresholds)
        validations.append(validation)
    return validations


def cmd_validate(args) -> int:
    definition = load_definition(find_definition(args.dungeon))
    rng = DungeonRng(seed=args.seed, label=f"validate:{definition.id}")
    validations = _validate_all_floors(definition, args.count, rng)
    failures = [v for v in validations if not v.ok]
    for validation in validations:
        status = "OK " if validation.ok else "FAIL"
        print(f"[{status}] floor {validation.floor:>2d} profile={validation.profile:12s} "
              f"accepted={len(validation.accepted())} rejected={validation.rejected} "
              f"signatures={validation.distinct_signatures} "
              f"max_sim={validation.max_pair_similarity}")
        for note in validation.notes:
            print(f"        {note}")
    grounds = check_grounds(definition)
    print(f"\nfixed grounds: {'OK' if grounds.ok else 'PROBLEMS'}")
    for note in grounds.notes:
        print(f"  - {note}")
    for problem in grounds.problems:
        print(f"  ! {problem}")
    return 0 if not failures and grounds.ok else 1


def cmd_generate(args) -> int:
    definition = load_definition(find_definition(args.dungeon))
    rng = DungeonRng(seed=args.seed, label=f"generate:{definition.id}")
    try:
        export = build_zone(definition, rng, strict_dtef=not args.no_dtef_check)
    except DtefError as exc:
        print(f"DTEF error: {exc}", file=sys.stderr)
        return 2
    grounds = check_grounds(definition)
    validations = _validate_all_floors(definition, args.count, rng)
    failures = [v for v in validations if not v.ok]

    if failures and not args.force:
        print(f"{len(failures)} floors failed validation; nothing written "
              f"(use --force to override)", file=sys.stderr)
        for validation in failures:
            print(f"  floor {validation.floor}: {validation.notes}", file=sys.stderr)
        return 1
    if not grounds.ok and not args.force:
        print("fixed Ground/boss scene problems; nothing written:", file=sys.stderr)
        for problem in grounds.problems:
            print(f"  {problem}", file=sys.stderr)
        return 1

    if args.dry_run:
        print(f"[dry-run] would write {export.zone_path}")
    else:
        path = write_zone(export, update_index=not args.no_index, definition=definition)
        print(f"wrote {path}")

    report = build_report(definition, export, validations, grounds, rng.debug_info())
    if not args.dry_run or args.report:
        for path in write_report(report):
            print(f"report: {path}")
    return 0


def cmd_generate_all(args) -> int:
    lo, hi = (int(x) for x in args.chapters.split("-"))
    exit_code = 0
    for path in list_definitions():
        definition = load_definition(path)
        if not (lo <= definition.chapter <= hi):
            continue
        print(f"\n=== {definition.id} (chapter {definition.chapter})")
        sub = argparse.Namespace(dungeon=str(path), seed=None, count=args.count,
                                 force=args.force, dry_run=args.dry_run, report=True,
                                 no_index=args.no_index, no_dtef_check=False)
        exit_code |= cmd_generate(sub)
    return exit_code


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="dungeon_builder",
                                     description="Configuration-driven dungeon builder on top of RogueElements")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("audit", help="list profiles, DTEF packages and definitions").set_defaults(func=cmd_audit)

    proto = sub.add_parser("prototype", help="isolated RogueElements capability prototype")
    proto.add_argument("--per-profile", type=int, default=6)
    proto.add_argument("--seed", type=int, default=None)
    proto.add_argument("--report", action="store_true", help="write docs/dungeon_builder/PROTOTYPE_METRICS.md")
    proto.set_defaults(func=cmd_prototype)

    preview = sub.add_parser("preview", help="generate variants of one floor without writing anything")
    preview.add_argument("dungeon")
    preview.add_argument("--floor", type=int, required=True)
    preview.add_argument("--count", type=int, default=10)
    preview.add_argument("--seed", type=int, default=None, help="debug only; never used in production")
    preview.add_argument("--ascii", action="store_true", help="print the layouts")
    preview.set_defaults(func=cmd_preview)

    validate = sub.add_parser("validate", help="validate every floor of a dungeon")
    validate.add_argument("dungeon")
    validate.add_argument("--count", type=int, default=10)
    validate.add_argument("--seed", type=int, default=None)
    validate.set_defaults(func=cmd_validate)

    generate = sub.add_parser("generate", help="write Data/Zone/<id>.json for one dungeon")
    generate.add_argument("dungeon")
    generate.add_argument("--count", type=int, default=10)
    generate.add_argument("--seed", type=int, default=None)
    generate.add_argument("--force", action="store_true")
    generate.add_argument("--dry-run", action="store_true")
    generate.add_argument("--report", action="store_true")
    generate.add_argument("--no-index", action="store_true")
    generate.add_argument("--no-dtef-check", action="store_true")
    generate.set_defaults(func=cmd_generate)

    batch = sub.add_parser("generate-all", help="batch build a chapter range")
    batch.add_argument("--chapters", default="6-32")
    batch.add_argument("--count", type=int, default=10)
    batch.add_argument("--force", action="store_true")
    batch.add_argument("--dry-run", action="store_true")
    batch.add_argument("--no-index", action="store_true")
    batch.set_defaults(func=cmd_generate_all)
    return parser


def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    try:
        return args.func(args)
    except (DefinitionError, DtefError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2
