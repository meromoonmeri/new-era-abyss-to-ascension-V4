#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
FIXTURE=.runtime-cache/tiny-woods-route-facing-fixture-repro
EVIDENCE=.runtime-cache/tiny-woods-route-facing-evidence-repro
test ! -e "$FIXTURE"
test ! -e "$EVIDENCE"
.runtime-cache/test-venv/bin/python tools/build_pmdred_tiny_woods_route_fixture.py --output "$FIXTURE"
.runtime-cache/test-venv/bin/python tools/run_pmdred_tiny_woods_route.py \
  --fixture "$FIXTURE" \
  --evidence-dir "$EVIDENCE" \
  --seed 424242 \
  --timeout-seconds 180
