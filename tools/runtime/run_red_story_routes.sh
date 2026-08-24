#!/usr/bin/env bash
# Validate staged Tiny Woods / Thunderwave Cave routes in real PMDO.
set -euo pipefail
WORK="${1:?usage: run_red_story_routes.sh <prepared-runtime-workdir> <staging-mod-root> [zones]}"
MOD_SRC="${2:?staging mod root required}"
ZONES="${3:-tiny_woods,thunderwave_cave}"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MOD_NAME="red-story-route"
BUNDLE="$WORK/pmdo-headless-bundle"
ASSET="$WORK/asset"
APPDATA="$WORK/appdata"
EXTRACT="$WORK/dotnet-bundle"

[ -x "$BUNDLE/PMDO" ] || {
  echo "runtime stack absent; prepare it with run_engine_mapgen.sh" >&2; exit 2;
}
ln -sfn "$MOD_SRC" "$APPDATA/MODS/$MOD_NAME"
mkdir -p "$WORK/red_story_routes"
IFS=',' read -ra IDS <<< "$ZONES"
for ZONE in "${IDS[@]}"; do
  OUT="$WORK/red_story_routes/${ZONE}.jsonl"
  LOG="$WORK/red_story_routes/${ZONE}.log"
  rm -f "$OUT" "$LOG"
  env DOTNET_BUNDLE_EXTRACT_BASE_DIR="$EXTRACT" \
      LD_LIBRARY_PATH="$BUNDLE" \
      SDL_VIDEODRIVER=offscreen SDL_AUDIODRIVER=dummy \
      PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY=1 SDL_OPENGL_ES_DRIVER=1 \
      SDL_VIDEO_GL_DRIVER="$BUNDLE/libGLESv2.so" SDL_VIDEO_EGL_DRIVER="$BUNDLE/libEGL.so" \
      FNA3D_FORCE_DRIVER=OpenGL FNA3D_OPENGL_FORCE_ES3=1 \
      ANGLE_DEFAULT_PLATFORM=vulkan VK_ICD_FILENAMES="$BUNDLE/vk_swiftshader_icd.absolute.json" \
      PMDO_RED_STORY_ROUTE_VALIDATOR="$ZONE" PMDO_RED_STORY_ROUTE_OUT="$OUT" \
      "$BUNDLE/PMDO" -asset "$ASSET/" -appdata "$APPDATA/" -quest "$MOD_NAME" \
      > "$LOG" 2>&1 &
  PID=$!
  for _ in $(seq 1 "${PMDO_ROUTE_TIMEOUT:-180}"); do
    grep -q '"event":"end"\|"event":"fatal"' "$OUT" 2>/dev/null && break
    kill -0 "$PID" 2>/dev/null || break
    sleep 1
  done
  kill "$PID" 2>/dev/null || true
  wait "$PID" 2>/dev/null || true
  python3 - "$ZONE" "$OUT" <<'PY'
import json,sys
from pathlib import Path
zone,path=sys.argv[1],Path(sys.argv[2])
if not path.is_file(): raise SystemExit(f'{zone}: route output missing')
rows=[json.loads(line) for line in path.read_text().splitlines() if line.strip()]
fatals=[row for row in rows if row.get('event')=='fatal']
maps=[row['floor'] for row in rows if row.get('event')=='map']
# We now key on GroundMapInit (event='ground_init') instead of GroundMapEnter
# because GroundMapEnter is not guaranteed to fire on the canonical final
# Ground: if Ground.Enter calls EndDungeonRun (the canonical PMD Red rescue
# scene pattern), PMDO transitions away from that Ground before OnGroundMapEnter
# is published. See docs/dungeon_builder/RUNTIME_VALIDATION_ARCHITECTURE.md
# for the RogueEssence source references.
grounds=[row['id'] for row in rows if row.get('event')=='ground_init']
expected_floors={'tiny_woods':3,'thunderwave_cave':5,'silent_chasm':9,'great_canyon':12}[zone]
expected_finals={'tiny_woods':'d01p02','thunderwave_cave':'d02p02',
                 'silent_chasm':'d05p02','great_canyon':'d07p02'}
expected_final=expected_finals[zone]
end=next((row for row in rows if row.get('event')=='end'),None)
canonical=next((row for row in rows if row.get('event')=='canonical_end'),None)
summary={'zone':zone,'events':len(rows),'maps':maps,'grounds':grounds,
         'canonical_end':canonical,'fatals':fatals,'end':end}
print(json.dumps(summary,indent=2))
# Validation: floors 0..N-1 traversed, entrance seen, canonical final Ground
# reached, canonical_end emitted for that Ground, end emitted with success.
if fatals: raise SystemExit(1)
if maps != list(range(expected_floors)): raise SystemExit(1)
if len(grounds) < 2 or expected_final not in grounds: raise SystemExit(1)
if not canonical or canonical.get('id') != expected_final: raise SystemExit(1)
if not end or not end.get('canonical_complete'): raise SystemExit(1)
if any(not row.get('map_seed') or row.get('stairs',0)<1
       for row in rows if row.get('event')=='map'):
    raise SystemExit(1)
PY
  ! grep -Eq 'Missing Data|Could not deserialize|KeyNotFoundException|NullReferenceException|Lua Trace' "$LOG"
  echo "$ZONE route PASS: $OUT"
done
