#!/usr/bin/env bash
# HEADLESS runtime validation: the real engine generates every floor of every
# zone of this mod, with no graphics involved.
#
#   ./run_mapgen_check.sh /path/to/PMDC /path/to/PMDO-install [iterations]
#
# * /path/to/PMDC       : a checkout of https://github.com/PMDCollab/PMDC
#                         (recursive submodules: it contains MapGenTest)
# * /path/to/PMDO-install : a full PMDO install (Base/, Data/, Content/, MODS/)
# * iterations          : how many times each floor is generated (default 5)
#
# MapGenTest is RogueEssence's own generation harness: it loads the zones with
# the engine's serializer and runs the real GenSteps.  F2 on the zone list runs
# the "stress test all" pass, which is what this script drives.
set -euo pipefail

PMDC_DIR="${1:?usage: run_mapgen_check.sh /path/to/PMDC /path/to/PMDO [iterations]}"
PMDO_DIR="${2:?usage: run_mapgen_check.sh /path/to/PMDC /path/to/PMDO [iterations]}"
ITER="${3:-5}"
MOD_NAME="new-era-abyss-to-ascension"
MOD_SRC="$(cd "$(dirname "$0")/../.." && pwd)"

echo "== 1. install the mod into the PMDO install =="
mkdir -p "$PMDO_DIR/MODS/$MOD_NAME"
rsync -a --delete --exclude '.git' --exclude 'RESERVE' --exclude 'external'       "$MOD_SRC/" "$PMDO_DIR/MODS/$MOD_NAME/"

echo "== 2. build MapGenTest (headless) =="
dotnet build -c Release "$PMDC_DIR/MapGenTest/MapGenTest.csproj"
BIN="$(find "$PMDC_DIR/MapGenTest/bin/Release" -name MapGenTest -type f | head -1)"

echo "== 3. run the generation stress test on the mod's zones =="
cd "$PMDO_DIR"
# F2 = stress test all zones; then the iteration count, then ESC to quit.
printf 'OQ%s
' "$ITER" | "$BIN" -quest "$MOD_NAME" 2>&1 | tee mapgen_stress.log

echo
echo "== 4. verdict =="
if grep -qiE "exception|error|failed" mapgen_stress.log; then
  echo "FAILURES found — see mapgen_stress.log"; exit 1
fi
echo "no generation error reported by the engine"
