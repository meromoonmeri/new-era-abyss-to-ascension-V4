# STATISTIQUES DE GÉNÉRATION — BASELINE RUNTIME (preuve réelle, pas simulation)

Protocole : mode `dprobe:` du validateur + `PMDO_DPROBE_ASCII=1` (dump du layout tuile/tuile) + `PMDO_DPROBE_REPS=25` (reseed `Save.Rand` entre passes → 25 seeds distincts). 4 zones × 4 étages × 25 seeds = **400 étages réellement générés par le moteur PMDO** (runtime headless, pas JSON statique). Analyse : `dev/tools/analyze_dungeon_generation_stats.py` → `dungeon_generation_statistics.json`.

## Verdict variété (§17/§19)
| Zone | Layouts | Identiques | Quasi-identiques (≥98 %) | Verdict |
|---|---|---|---|---|
| beach_cave (Sky d01) | 100 | 0 | 0 | PASS |
| apple_woods (Sky) | 100 | 0 | 0 | PASS |
| dusk_forest (Sky d32/d139) | 100 | 0 | 0 | PASS |
| amp_plains (Sky) | 100 | 0 | 0 | PASS |
| **GLOBAL** | **400** | **0** | **0** | **PASS** |
Hash structurel murs/ouvert : aucune paire d'étages identique ni quasi identique sur 400 générations. La génération est réellement procédurale et le seed est reproductible (ReRandom.FirstSeed).

## Densités mesurées vs formules ROM (R3)
Séparation escaliers/pièges faite sur l'ASCII (`>` vs `^`) ; `map.Items` inclut l'argent (les « items » mesurés = items+piles, d'où l'écart au-dessus d'item_density seul).
| Zone | ROM enemy d → attendu RandRange(d/2,d) | mesuré | ROM trap d → attendu | mesuré (hors escaliers) |
|---|---|---|---|---|
| beach_cave | 4 → 2–3 (borne sup exclusive) | 2–3, avg 2.42 ✔ | 3 → 1–3 | 1–3, avg 2.52 ✔ |
| apple_woods | — | 2–3, avg ~2.5 ✔ | — | 1–3, avg ~2.5 ✔ |
| dusk_forest | 4 → 2–3 | 2–3, avg 2.54 ✔ | 6 → 3–6 | 4–8, avg 6.35 ⚠ |
| amp_plains | — | conforme | — | 3–7, avg 5.6 |
⚠ dusk_forest/amp_plains : pièges mesurés légèrement AU-DESSUS de la plage ROM stricte (max 8 vs 6). Cause à instruire au LOT de vérification : tuiles Wonder/spéciales comptées comme `^` dans l'ASCII (elles sont des EffectTile non-escalier) — à séparer avant tout ajustement de data. AUCUNE correction « à l'œil » appliquée.

## Escaliers
1,00 escalier/étage sur 399/400 étages (1 étage dusk_forest à 0 → escalier caché derrière un mob au moment du scan ASCII ou tuile déjà comptée `M` ; le journey global prouve la descente systématique). Pas d'étage sans sortie détecté par DetectIsolatedStairsStep.

## Prochaines mesures (avec les LOTs de la recette)
- Monster Houses : taux d'apparition sur 100 gén. de zones à SpreadHouse (nécessite plages plus longues d'étages).
- Kecleon : idem sur les 43 zones à ShopStep.
- Après LOT B : vérifier MH 10–18 mobs runtime (§37).
