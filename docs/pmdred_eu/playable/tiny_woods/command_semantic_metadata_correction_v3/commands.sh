#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
destination=.runtime-cache/pmdred-tiny-woods-command-semantic-supplement-repro-v20.json
test ! -e "$destination" || { echo "create-only destination exists: $destination" >&2; exit 1; }
python3 tools/build_pmdred_tiny_woods_command_semantic_supplement_v3.py --output "$destination"
cmp "$destination" docs/pmdred_eu/playable/tiny_woods/command_semantic_supplement_v3.json
python3 tools/validate_pmdred_tiny_woods_command_semantic_supplement_v3.py --supplement "$destination"
