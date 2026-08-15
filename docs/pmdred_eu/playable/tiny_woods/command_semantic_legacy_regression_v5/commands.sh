#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
PY=.runtime-cache/test-venv/bin/python
SEM=.runtime-cache/pmdred-tiny-woods-palette-semantics-repro-v1.json
FIX=.runtime-cache/pmdred-tiny-woods-palette-repro-v1
EVD=.runtime-cache/pmdred-tiny-woods-palette-evidence-repro-v1
$PY tools/build_pmdred_tiny_woods_palette_semantics.py --output "$SEM"
cmp "$SEM" docs/pmdred_eu/playable/tiny_woods/secondary_palette_semantics_v1.json
$PY tools/build_pmdred_tiny_woods_palette_overlay.py --output "$FIX"
PYTHONPATH=tools $PY tools/run_pmdred_tiny_woods_palette_certification.py --fixture "$FIX" --evidence-dir "$EVD" --timeout-seconds 300
$PY tools/certify_pmdred_tiny_woods_palette_semantics.py --fixture "$FIX" --evidence-dir "$EVD" --output .runtime-cache/pmdred-tiny-woods-palette-archive-repro-v1
