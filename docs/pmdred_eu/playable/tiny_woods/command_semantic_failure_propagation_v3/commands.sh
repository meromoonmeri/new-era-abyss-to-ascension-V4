#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
fixture=.runtime-cache/pmdred-tiny-woods-command-semantic-fixture-negative-repro-v20
evidence=.runtime-cache/pmdred-tiny-woods-command-semantic-negative-evidence-repro-v20
rejected=.runtime-cache/pmdred-tiny-woods-command-semantic-negative-rejected-repro-v20
for destination in "$fixture" "$evidence" "$rejected"; do test ! -e "$destination" || { echo "create-only destination exists: $destination" >&2; exit 1; }; done
python3 tools/build_pmdred_tiny_woods_command_semantic_overlay_v3.py \
  --output "$fixture" \
  --music-source .runtime-cache/pmdred-tiny-woods-scene-music-v13 \
  --fanfare-source .runtime-cache/pmdred-tiny-woods-fanfares-v13 \
  --fault-ordinal 0
PYTHONPATH=tools python3 tools/run_pmdred_tiny_woods_command_semantic_negative_v3.py \
  --fixture "$fixture" \
  --evidence-dir "$evidence" \
  --certifier-output "$rejected" \
  --timeout-seconds 240
