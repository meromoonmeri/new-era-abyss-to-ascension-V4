#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
supplement=.runtime-cache/pmdred-tiny-woods-command-semantic-supplement-repro-v3.json
fixture=.runtime-cache/pmdred-tiny-woods-command-semantic-fixture-repro-v19
evidence=.runtime-cache/pmdred-tiny-woods-command-semantic-evidence-repro-v19
archive=.runtime-cache/pmdred-tiny-woods-command-semantic-archive-repro-v19
for destination in "$supplement" "$fixture" "$evidence" "$archive"; do test ! -e "$destination" || { echo "create-only destination exists: $destination" >&2; exit 1; }; done
python3 tools/build_pmdred_tiny_woods_command_semantic_supplement_v3.py --output "$supplement"
cmp "$supplement" docs/pmdred_eu/playable/tiny_woods/command_semantic_supplement_v3.json
python3 tools/validate_pmdred_tiny_woods_command_semantic_supplement_v3.py --supplement "$supplement"
python3 tools/build_pmdred_tiny_woods_command_semantic_overlay_v3.py --output "$fixture" --music-source .runtime-cache/pmdred-tiny-woods-scene-music-v13 --fanfare-source .runtime-cache/pmdred-tiny-woods-fanfares-v13
python3 tools/run_pmdred_tiny_woods_command_semantic_v3.py --fixture "$fixture" --evidence-dir "$evidence" --timeout-seconds 240
python3 tools/certify_pmdred_tiny_woods_command_semantic_v3.py --fixture "$fixture" --evidence-dir "$evidence" --output "$archive"
