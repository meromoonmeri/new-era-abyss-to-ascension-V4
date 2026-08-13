#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
fixture=.runtime-cache/pmdred-tiny-woods-command-complete-repro-v1
evidence=.runtime-cache/pmdred-tiny-woods-command-complete-evidence-repro-v1
test ! -e "$fixture"
test ! -e "$evidence"
python3 tools/build_pmdred_tiny_woods_command_complete_overlay.py --output "$fixture"
python3 tools/run_pmdred_tiny_woods_command_complete.py \
  --fixture "$fixture" \
  --evidence-dir "$evidence" \
  --seed 424242 \
  --timeout-seconds 240
