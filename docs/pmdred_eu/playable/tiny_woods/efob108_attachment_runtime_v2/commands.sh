#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
PY=.runtime-cache/test-venv/bin/python
FIX=.runtime-cache/pmdred-efob108-attachment-repro-v1
EVD=.runtime-cache/pmdred-efob108-attachment-evidence-repro-v1
$PY tools/build_pmdred_efob108_particle.py \
  --verify-existing \
  --output Content/Particle/PMDRed_Efob108.dir \
  --manifest docs/pmdred_eu/playable/tiny_woods/efob108_particle_manifest.json
$PY tools/build_pmdred_efob108_attachment_fixture.py --output "$FIX"
$PY tools/run_pmdred_efob108_attachment_certification.py \
  --fixture "$FIX" --evidence-dir "$EVD" --seed 424242 --timeout-seconds 180
