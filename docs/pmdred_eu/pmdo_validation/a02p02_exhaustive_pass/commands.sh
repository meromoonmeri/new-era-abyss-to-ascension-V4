#!/usr/bin/env bash
# Exact create-only recovery and reproduction recipe for the a02p02 milestone.
# Run from the repository root. Existing worktree assets are never removed or
# overwritten. PMDO's validator stream has a fixed /tmp path in engine 0.8.12.
set -euo pipefail

ROOT=$PWD
PYTHON="$ROOT/.runtime-cache/test-venv/bin/python"
BUNDLE="$ROOT/.runtime-cache/pmdo-headless-bundle"
DOTNET_EXTRACT="$ROOT/.runtime-cache/dotnet-headless"
CANONICAL="$ROOT/.runtime-cache/pmdred-eu-remaining-regenerated-v201"
MIGRATED="$ROOT/.runtime-cache/pmdred-eu-a02p02-reproduction-entity-migration"
PLAN="$ROOT/.runtime-cache/pmdred-eu-reference-plan-v2.json"
SOURCE="$ROOT/.runtime-cache/pmdred-eu-ground"
FIX="$ROOT/.runtime-cache/pmdred-eu-a02p02-reproduction-fixture"
COMPARE="$ROOT/.runtime-cache/pmdred-eu-a02p02-reproduction-comparison"
POST_CANDIDATE="$ROOT/.runtime-cache/pmdred-eu-a02p02-reproduction-promoted-candidate"
POST_FIX="$ROOT/.runtime-cache/pmdred-eu-a02p02-reproduction-promoted-fixture"
EVENTS=/tmp/pmdred_eu_ground_validator.jsonl

# Authenticated create-only restoration. Existing components are verified and a
# mismatching path aborts; the script never replaces it.
bash tools/restore_pmdred_eu_validation_runtime.sh

# Direct authority and exact-subject gates.
SDL_PATCHED=$(find "$DOTNET_EXTRACT/PMDO" -type f -name libSDL2-2.0.so.0 -print -quit)
test "$(sha256sum "$BUNDLE/PMDO" | cut -d' ' -f1)" = faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327
test "$(sha256sum "$SDL_PATCHED" | cut -d' ' -f1)" = 2cec7b5f9603a8a856a94b3a5e4fb5bd5e93e3ed0d04b85431625d5acb14e71f
test "$(sha256sum .runtime-cache/downloads/pmdred-eu.gba | cut -d' ' -f1)" = 0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd
test "$(sha256sum "$PLAN" | cut -d' ' -f1)" = dcf498ae5f8970e15e44e044d000b6f28b342eae5e23f401516a9bb2738c0cb0
test "$(sha256sum "$CANONICAL/conversion_report.json" | cut -d' ' -f1)" = 91f3b460b3e3b7689bc608ece2006cb6103d653bcdc22ad028f4172c3a1b0fdc
test "$(sha256sum "$CANONICAL/grounds/a02p02.rsground" | cut -d' ' -f1)" = 4aa76d598b3171a513f6a4ba8d17b71ef5403f725278c24c49ff9e02d41bba82
test ! -e "$MIGRATED"
"$PYTHON" tools/build_pmdred_eu_entity_migration.py --ground a02p02 --output "$MIGRATED"
test "$(sha256sum "$MIGRATED/grounds/a02p02.rsground" | cut -d' ' -f1)" = f9aac6971906cbb93eab368bcd91bb4a9723180bd854d17b19811474c3484a3c
test "$(sha256sum "$CANONICAL/tiles/a02p02_Base.tile" | cut -d' ' -f1)" = 9b195f5e9eb12ad6e7b4a162b555e37a4e13ac7e4a73fac4cec66e17a1f9e904
test "$(sha256sum RESERVE/red_grounds/a02p02.rsground | cut -d' ' -f1)" = 6b373ccc45b65ffabfb3d8df2fda372d96bd0f8afca3516aaf7c713faee4fd31
test "$(sha256sum RESERVE/red_tiles/a02p02_Base.tile | cut -d' ' -f1)" = 9b195f5e9eb12ad6e7b4a162b555e37a4e13ac7e4a73fac4cec66e17a1f9e904
"$PYTHON" - <<'PYID'
import json
from pathlib import Path
entry=next(x for x in json.loads(Path('docs/pmdred_eu/ground_manifest.json').read_text())['ground_conversion_table']['entries'] if x['stable_ground_id']=='a02p02')
assert entry == {'canonical_debug_id': 174, 'conversion_type': 1, 'debug_string': '__ground_amd_conversion_00174', 'debug_string_address': '0x0827A61C', 'ground_place_id': 35, 'map_file_id': 175, 'map_id': 166, 'stable_ground_id': 'a02p02', 'weather_id': 13}
header=Path('.runtime-cache/pmd-red-reference/include/constants/ground_map.h').read_text()
assert 'MAP_FUGITIVES_LAPIS_CAVE' in header
print('A02P02_IDENTITY_PASS map_file_id=175 symbol=MAP_FUGITIVES_LAPIS_CAVE')
PYID

# Create an isolated fixture. Refuse to touch a prior reproduction directory.
test ! -e "$FIX" && test ! -e "$COMPARE"
"$PYTHON" tools/build_pmdred_eu_runtime_fixture.py \
  --conversion-set remaining \
  --candidate-root "$MIGRATED" \
  --canonical-baseline-root "$CANONICAL" \
  --entity-integrated-ids a02p02 \
  --plan "$PLAN" \
  --ids a02p02 \
  --output "$FIX"

PMDO_ENV=(
  DOTNET_BUNDLE_EXTRACT_BASE_DIR="$DOTNET_EXTRACT"
  LD_LIBRARY_PATH="$BUNDLE"
  SDL_VIDEODRIVER=offscreen
  SDL_AUDIODRIVER=dummy
  SDL_VIDEO_GL_DRIVER="$BUNDLE/libGLESv2.so"
  SDL_VIDEO_EGL_DRIVER="$BUNDLE/libEGL.so"
  PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY=1
  PMDO_HEADLESS_DISMISS_SPLASH=1
  FNA3D_FORCE_DRIVER=OpenGL
  FNA3D_OPENGL_FORCE_ES3=1
  ANGLE_DEFAULT_PLATFORM=vulkan
  VK_ICD_FILENAMES="$BUNDLE/vk_swiftshader_icd.absolute.json"
)
env "${PMDO_ENV[@]}" timeout --signal=TERM --kill-after=5 300 "$BUNDLE/PMDO" \
  -asset "$FIX/asset/" -appdata "$FIX/appdata/" \
  -quest pmdred_eu_fixture -index zone >"$FIX/index.log" 2>&1
test "$(sha256sum "$FIX/index.log" | cut -d' ' -f1)" = 3df47e3be040b124c5768b076c89fb586ff4b807890f154b22387667069c8ab8

# Preserve any pre-existing fixed-path stream before starting this independent
# run, then reset only that temporary stream (never a repository asset).
if [[ -e $EVENTS ]]; then
  cp "$EVENTS" "$FIX/preexisting-validator-events.jsonl"
  rm "$EVENTS"
fi
"$PYTHON" tools/run_pmdred_eu_native_fixture.py \
  --fixture "$FIX" --ground a02p02 --expected-screenshots 145 \
  --timeout-seconds 1800
"$PYTHON" - "$FIX/termination.json" <<'PYTERM'
import json, sys
from pathlib import Path
t=json.loads(Path(sys.argv[1]).read_text())
assert t['result']=='PASS' and t['exit_classification']=='NORMAL_EXIT'
assert t['return_code']==0 and t['terminal'] and t['graceful']
assert not t['watchdog'] and t['requested_signal'] is None
assert not t['sigsegv'] and not t['forced_kill'] and not t['orphan_process']
assert t['load_phase_unload']['pass']
print('A02P02_NATIVE_TERMINATION_PASS rc=0 phase=Unload')
PYTERM
test "$(wc -l < "$FIX/events.jsonl")" -eq 457
test "$(find "$FIX/appdata/SCREENSHOT" -maxdepth 1 -type f -name '*.png' | wc -l)" -eq 145

mkdir "$COMPARE"
"$PYTHON" tools/compare_pmdred_eu_pmdo_renders.py \
  --events "$FIX/events.jsonl" \
  --screenshots "$FIX/appdata/SCREENSHOT" \
  --reference-plan "$PLAN" \
  --source-dir "$SOURCE" \
  --conversion-report "$CANONICAL/conversion_report.json" \
  --output "$COMPARE" \
  --report "$COMPARE/report.json" \
  --workers 2 2>&1 | tee "$COMPARE/comparison.log"

# Machine-check the entire result, not only the selected durable PNGs.
"$PYTHON" - "$COMPARE/report.json" <<'PY'
import json, sys
from pathlib import Path
r=json.loads(Path(sys.argv[1]).read_text())
rt=r['runtime']; primary=[s for s in r['samples'] if s['phase']=='primary']
validations={(v['ground'],v['phase']):v for v in rt['validations']}
assert r['grounds']==['a02p02'] and r['sample_count']==145 and len(primary)==144
assert r['exact_sample_count']==145 and r['fully_opaque_sample_count']==145
assert len({s['actual_rgba_sha256'] for s in primary})==30
assert r['all_exact'] and r['all_fully_opaque']
assert rt['all_runtime_safe'] and rt['runtime_sequence_consistent']
assert rt['native_lifecycle_order']['pass'] and rt['all_cleanups_pass']
assert rt['end_event_seen'] and rt['same_ground_reentry_count']==1
assert validations[('a02p02','primary')]['movement_probe']=='PASS'
assert validations[('a02p02','primary')]['blocked_probe']=='PASS'
assert validations[('a02p02','reload')]['load']=='LOAD_PASS'
assert all(s['mismatched_pixels']==0 and s['maximum_channel_delta']==0 for s in r['samples'])
print('A02P02_EXHAUSTIVE_PASS samples=145 unique_rgba=30')
PY

# Post-promotion readback and exact-engine indexing. These are create-only
# ignored fixtures; installed canonical bytes and historical reserve stay intact.
test "$(sha256sum Data/Ground/a02p02.rsground | cut -d' ' -f1)" = f9aac6971906cbb93eab368bcd91bb4a9723180bd854d17b19811474c3484a3c
test "$(sha256sum Content/Tile/a02p02_Base.tile | cut -d' ' -f1)" = 9b195f5e9eb12ad6e7b4a162b555e37a4e13ac7e4a73fac4cec66e17a1f9e904
test ! -e "$POST_CANDIDATE" && test ! -e "$POST_FIX"
mkdir -p "$POST_CANDIDATE/grounds" "$POST_CANDIDATE/tiles"
cp Data/Ground/a02p02.rsground "$POST_CANDIDATE/grounds/"
cp Content/Tile/a02p02_Base.tile "$POST_CANDIDATE/tiles/"
cp "$CANONICAL/conversion_report.json" "$POST_CANDIDATE/"
"$PYTHON" tools/build_pmdred_eu_runtime_fixture.py \
  --conversion-set remaining --candidate-root "$POST_CANDIDATE" --plan "$PLAN" \
  --ids a02p02 --entity-integrated-ids a02p02 --canonical-baseline-root "$CANONICAL" --output "$POST_FIX"
env "${PMDO_ENV[@]}" timeout --signal=TERM --kill-after=5 300 "$BUNDLE/PMDO" \
  -asset "$POST_FIX/asset/" -appdata "$POST_FIX/appdata/" \
  -quest pmdred_eu_fixture -index zone >"$POST_FIX/post_promotion_index.log" 2>&1
test "$(sha256sum "$POST_FIX/post_promotion_index.log" | cut -d' ' -f1)" = 3df47e3be040b124c5768b076c89fb586ff4b807890f154b22387667069c8ab8

# Add --montage-all to the comparator invocation when all 145 comparative PNGs,
# rather than the three durable representative captures, are desired.
test "$(sha256sum RESERVE/pmdred_pre_promotion/a02p02/a02p02.rsground | cut -d' ' -f1)" = dc60ccc9b2d714a91a725a86397b6af3b4aadd6dfe40aaef981423794c7d6083
test "$(sha256sum RESERVE/pmdred_pre_promotion/a02p02/A02p02_Base.tile | cut -d' ' -f1)" = 9b195f5e9eb12ad6e7b4a162b555e37a4e13ac7e4a73fac4cec66e17a1f9e904
