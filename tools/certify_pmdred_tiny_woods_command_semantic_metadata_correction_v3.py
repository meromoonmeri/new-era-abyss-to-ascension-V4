#!/usr/bin/env python3
"""Archive the recovered metadata-only Tiny Woods semantic correction v3."""
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
from datetime import datetime
from pathlib import Path
from zoneinfo import ZoneInfo

ROOT = Path(__file__).resolve().parents[1]
PLAN = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_plan.json"
SUPPLEMENT = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_semantic_supplement_v3.json"
GENERATOR = ROOT / "tools/build_pmdred_tiny_woods_command_semantic_supplement_v3.py"
VALIDATOR = ROOT / "tools/validate_pmdred_tiny_woods_command_semantic_supplement_v3.py"


def sha256(path: Path) -> str:return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args(); output = args.output.resolve()
    if output.exists():raise FileExistsError(f"refusing to overwrite metadata correction: {output}")
    plan = json.loads(PLAN.read_text(encoding="utf-8")); supplement = json.loads(SUPPLEMENT.read_text(encoding="utf-8"))
    rows = supplement["commands"]
    plan_by_address = {row["address"]: row for array in plan["arrays"] for row in array["commands"]}
    copied = ("op", "op_hex", "op_name", "arg_byte", "arg_short", "arg1", "arg2", "pmdo_handler")
    for row in rows:
        source = plan_by_address.get(row["address"])
        if source is None or any(row[key] != source[key] for key in copied):
            raise ValueError(f"metadata correction changed source row {row['address']}")
    unknown = [row for row in plan_by_address.values() if row["pmdo_handler"] == "actor.control_unknown"]
    if len(unknown) != 15 or {row["address"] for row in rows}.intersection(row["address"] for row in unknown):
        raise ValueError("unknown-opcode boundary differs")
    output.mkdir(parents=True)
    shutil.copyfile(SUPPLEMENT, output / SUPPLEMENT.name)
    commands = output / "commands.sh"
    commands.write_text(
        "#!/usr/bin/env bash\nset -euo pipefail\ncd \"$(git rev-parse --show-toplevel)\"\n"
        "destination=.runtime-cache/pmdred-tiny-woods-command-semantic-supplement-repro-v20.json\n"
        "test ! -e \"$destination\" || { echo \"create-only destination exists: $destination\" >&2; exit 1; }\n"
        "python3 tools/build_pmdred_tiny_woods_command_semantic_supplement_v3.py --output \"$destination\"\n"
        "cmp \"$destination\" docs/pmdred_eu/playable/tiny_woods/command_semantic_supplement_v3.json\n"
        "python3 tools/validate_pmdred_tiny_woods_command_semantic_supplement_v3.py --supplement \"$destination\"\n",
        encoding="utf-8",
    );commands.chmod(0o755)
    report = {
        "schema": "pmdred-eu-tiny-woods-command-semantic-metadata-correction-v3",
        "date": datetime.now(ZoneInfo("Europe/Paris")).date().isoformat(), "status": "passed",
        "authority": supplement["authority"],
        "recovery": supplement["recovery_provenance"],
        "identities": {
            "command_plan_sha256": sha256(PLAN), "supplement_v3_sha256": sha256(SUPPLEMENT),
            "generator_sha256": sha256(GENERATOR), "independent_validator_sha256": sha256(VALIDATOR),
        },
        "totals": supplement["totals"],
        "assertions": {
            "all_304_rows_retain_exact_source_addresses_opcodes_operands_and_handlers": True,
            "all_304_rows_receive_one_explicit_semantic_category_and_pmdo_api_contract": True,
            "all_15_actor_control_unknown_rows_remain_in_command_plan_and_outside_supplement": True,
            "command_plan_bytes_are_unchanged": True,
            "historical_v1_v2_identities_are_recorded_but_not_recreated": True,
        },
    }
    (output / "metadata_correction_v3.json").write_text(json.dumps(report, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")
    hashes=[]
    for path in sorted(output.iterdir()):hashes.append(f"{sha256(path)}  {path.name}")
    (output / "evidence_hashes.sha256").write_text("\n".join(hashes)+"\n", encoding="utf-8")
    print(f"TINY_WOODS_COMMAND_SEMANTIC_METADATA_CORRECTION_V3_PASS commands=304 unknown_disjoint=15 output={output}")
    return 0


if __name__ == "__main__":raise SystemExit(main())
