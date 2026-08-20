#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

music=.runtime-cache/pmdred-tiny-woods-scene-music-repro-v4
fanfares=.runtime-cache/pmdred-tiny-woods-fanfares-repro-v4
fixture=.runtime-cache/pmdred-tiny-woods-command-complete-repro-v2
evidence=.runtime-cache/pmdred-tiny-woods-command-complete-evidence-repro-v2
for destination in "$music" "$fanfares" "$fixture" "$evidence"; do
  test ! -e "$destination" || {
    echo "create-only destination exists; select a fresh suffix: $destination" >&2
    exit 1
  }
done

python3 tools/render_pmdred_scene_music.py \
  --rom .runtime-cache/downloads/pmdred-eu.gba \
  --output-dir "$music" \
  --m4play-source .runtime-cache/M4plAy-source \
  --ogg-source .runtime-cache/libogg-source \
  --vorbis-source .runtime-cache/libvorbis-source
python3 tools/render_pmdred_scene_fanfares.py \
  --rom .runtime-cache/downloads/pmdred-eu.gba \
  --output-dir "$fanfares" \
  --m4play-source .runtime-cache/M4plAy-source \
  --ogg-source .runtime-cache/libogg-source \
  --vorbis-source .runtime-cache/libvorbis-source
python3 tools/build_pmdred_tiny_woods_command_complete_overlay.py \
  --output "$fixture" \
  --music-source "$music" \
  --fanfare-source "$fanfares"
python3 tools/run_pmdred_tiny_woods_command_complete.py \
  --fixture "$fixture" \
  --evidence-dir "$evidence" \
  --seed 424242 \
  --timeout-seconds 240
