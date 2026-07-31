#!/usr/bin/env bash
# =============================================================================
# run_validations.sh — LA MÉTHODE DE TRAVAIL EN UNE COMMANDE
# -----------------------------------------------------------------------------
# Encapsule la séquence de validation exigée avant chaque commit
# (docs/PASSATION_AGENT_ARENA.md §9.5 + audits récupérés de l'ancien agent).
#
# Usage :
#   bash tools/run_validations.sh            # suite complète
#   bash tools/run_validations.sh fast       # sans les audits lourds (bruit)
#   bash tools/run_validations.sh full       # y compris audits exploratoires
#
# Baselines attendues (mesurées le 2026-07-31, commit 4fee26a) :
#   - compilation Lua        : 0 erreur (673 fichiers)
#   - audit_bugs.py          : 9  (faux positifs documentés, PASSATION §11)
#   - audit_integrite.py     : 849 (dette de clés orphelines, tendance ↓)
#   - count_dialogue ch5     : 1618 (cible 7000)
# Les outils récupérés de ~/audit/scripts (audit_2026-07-30 §7) sont marqués
# [RÉCUPÉRÉ] : audit_text_tags / audit_cutscene_exit / audit_chapter_gaps
# (3 commités mais cassés, réparés) + audit_api / audit_markers / audit_zones /
# audit_assets2 / audit_resx / audit_serial / audit_fade2 / audit_dispatch3 /
# audit_sv2 / audit_plot (reconstruits depuis la description de l'audit).
# =============================================================================
set -u
cd "$(dirname "$0")/.."
MODE="${1:-full}"
PY="python3"

echo "============================================================"
echo " NEW ERA — SUITE DE VALIDATION ($MODE)"
echo "============================================================"
FAIL=0
run() {
  local label="$1"; shift
  echo ""
  echo "----- $label -----"
  if ! "$@" > /tmp/nea_val_$$.log 2>&1; then
    echo "  ❌ ÉCHEC — voir ci-dessous (dernières lignes) :"
    tail -15 /tmp/nea_val_$$.log | sed 's/^/    /'
    FAIL=1
  else
    tail -3 /tmp/nea_val_$$.log | sed 's/^/    /'
    echo "  ✅ OK"
  fi
}

# --- 1. Compilation Lua de TOUS les fichiers -------------------------------
run "Compilation Lua (673 fichiers)" $PY -c "
import lupa, glob
L = lupa.LuaRuntime()
errs = []
for f in glob.glob('Data/Script/**/*.lua', recursive=True):
    try: L.compile(open(f, encoding='utf-8').read())
    except Exception as e: errs.append((f, str(e)[:100]))
print(f'compilés: {len(glob.glob(\"Data/Script/**/*.lua\", recursive=True))}, erreurs: {len(errs)}')
for f,e in errs[:5]: print('ERR', f, e)
raise SystemExit(1 if errs else 0)
"

# --- 2. Vérificateurs pré-commit (baselines) --------------------------------
run "audit_bugs.py (baseline 9)"          $PY tools/audit_bugs.py .
run "verify_legend.py"                    $PY tools/verify_legend.py .
run "verify_scene_positions.py"           $PY tools/verify_scene_positions.py .
run "verify_bg_format.py"                 $PY tools/verify_bg_format.py .
run "validate_all.py (9 salles)"          $PY tools/validate_all.py .
run "verify_ground_registration.py"       $PY tools/verify_ground_registration.py .
run "verify_lua_globals.py"               $PY tools/verify_lua_globals.py .
run "verify_spawner_enabled.py"           $PY tools/verify_spawner_enabled.py .
run "verify_cutscene_guard.py"            $PY tools/verify_cutscene_guard.py .
run "verify_emotions.py"                  $PY tools/verify_emotions.py .
run "verify_midpoint_template.py"         $PY tools/verify_midpoint_template.py .
run "audit_dialogues.py (0 anglais)"      $PY tools/audit_dialogues.py .
run "audit_integrite.py (baseline 849)"   $PY tools/audit_integrite.py .
run "count_dialogue.py"                   $PY tools/count_dialogue.py

# --- 3. Outils récupérés de l'ancien agent [RÉCUPÉRÉ] -----------------------
run "audit_text_tags.py [RÉCUPÉRÉ]"       $PY tools/audit_text_tags.py .
run "audit_cutscene_exit.py [RÉCUPÉRÉ]"   $PY tools/audit_cutscene_exit.py .
run "audit_chapter_gaps.py [RÉCUPÉRÉ]"    $PY tools/audit_chapter_gaps.py .
run "audit_api.py [RÉCUPÉRÉ]"             $PY tools/audit_api.py .
run "audit_markers.py [RÉCUPÉRÉ]"         $PY tools/audit_markers.py .
run "audit_assets2.py [RÉCUPÉRÉ]"         $PY tools/audit_assets2.py .
run "audit_resx.py [RÉCUPÉRÉ]"            $PY tools/audit_resx.py .
run "audit_serial.py [RÉCUPÉRÉ]"          $PY tools/audit_serial.py .
run "audit_fade2.py [RÉCUPÉRÉ]"           $PY tools/audit_fade2.py .
run "audit_dispatch3.py [RÉCUPÉRÉ]"       $PY tools/audit_dispatch3.py .
run "audit_sv2.py [RÉCUPÉRÉ]"             $PY tools/audit_sv2.py .
run "audit_plot.py [RÉCUPÉRÉ]"            $PY tools/audit_plot.py .

if [ "$MODE" = "full" ]; then
  # --- 4. Audits exploratoires (bruit documenté, INFORMATIFS — ne
  #      bloquent jamais le commit : leur sortie non-zéro est un signal
  #      de dette à trier, pas une erreur). -----------------------------
  echo ""
  echo "----- Audits exploratoires (informatifs, non bloquants) -----"
  info() {
    local label="$1"; shift
    echo "--- $label ---"
    "$@" > /tmp/nea_info_$$.log 2>&1 || true
    tail -12 /tmp/nea_info_$$.log | sed 's/^/    /'
  }
  info "audit_zones.py [RÉCUPÉRÉ]"           $PY tools/audit_zones.py .
  info "audit_spatial.py"                     $PY tools/audit_spatial.py .
  info "audit_causalite.py"                   $PY tools/audit_causalite.py .
  info "audit_boss_cinematics.py"             $PY tools/audit_boss_cinematics.py .
  info "audit_fade_leaks.py"                  $PY tools/audit_fade_leaks.py .
  rm -f /tmp/nea_info_$$.log
fi

rm -f /tmp/nea_val_$$.log
echo ""
echo "============================================================"
if [ "$FAIL" -eq 0 ]; then
  echo " ✅ SUITE DE VALIDATION AU VERT — commit possible"
else
  echo " ❌ AU MOINS UNE VALIDATION A ÉCHOUÉ — corriger avant commit"
fi
echo "============================================================"
exit $FAIL
