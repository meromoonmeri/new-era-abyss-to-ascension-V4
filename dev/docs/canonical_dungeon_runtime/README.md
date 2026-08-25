# canonical-dungeon — validation runtime par étage

Outil : `dev/tools/canonical_dungeon.py` (manifest | test | validate | report),
correcteur de convergence : `dev/tools/canonical_dungeon_fix.py`,
campagne par lots : `dev/tools/canonical_dungeon_batch.sh`.

## Campagne 2026-08-25 — 85 zones, 1814 étages, moteur PMDO 0.8.12 réel

Le service moteur `mapgen_validator` exécute la génération RogueElements
réelle (`structure:GetMap(context)`) et la traversabilité pour CHAQUE étage.
Preuves brutes : mapgen_*.jsonl. Matrice agrégée : matrix.json.

État courant : 47/85 zones CANONICAL_RUNTIME_PASS (dont wish_cave 99 ét.,
magma_cavern, sky_tower, buried_relic partiel...). ~70 étages restent
REVIEW_REQUIRED : flakys topologiques épars (contrats stricts sur seeds
défavorables) + 1 crash NRE résiduel — le correcteur de convergence les
resserre itérativement, aucune zone n'est déclarée PASS sans exécution.

## Vrais bugs identifiés PAR le moteur et corrigés à la racine

1. **Autotiles inexistants** (KeyNotFoundException MapTextureStep) :
   chasm_cave/dark_hill/dusk_forest/sealed_ruin_pit/spiritomb_room
   référençaient `<biome>_floor` au lieu des autotiles canoniques du jeu
   de base (`<biome>_1_floor`…). Re-mappés (114 références).
2. **PickerSpawner malformés** (NRE PickerSpawner.ToString) : 45 steps
   avec `Spawns` + EffectTile `ID:""` au lieu du schéma canonique
   `Picker`/LoopedRand + `tile_wonder` (forme du jeu de base). Réparés.
3. **RoomGen non canoniques** (0 salle générée) : 62 RoomGen avec
   `RoomTerrain`/`Size`/`Resizable` (schéma inexistant en 0.8.12) au lieu
   de `Width`/`Height` RandRange. Normalisés.
4. **TerrainHallBrush avec terrain inexistant `hall`** (SIGABRT
   TileBlocked) : 45 pinceaux -> DefaultHallBrush canonique.
5. **.rsmap corrompus** (clé `""` au lieu de `$type`) :
   mount_windswept_guardian, frosty_forest_summit, mt_blaze_summit,
   vast_steppe_guardian, wish_cave_jirachi. Réparés.
6. **GetPlayerPartyMember crash sur save vierge** : le validateur crée
   désormais l'équipe de test canonique (turtwig/piplup/growlithe/
   zigzagoon, mêmes espèces que le save debug du projet).
7. **Escaliers `stairs_exit*` non reconnus** + **vaults scellés**
   (sealed_block/sealed_door) comptés comme cellules isolées : le
   validateur les traite selon la sémantique réelle du jeu.
8. **RandRange Min>Max** introduits par une passe de durcissement (57)
   puis interdits par construction dans le correcteur.

Les 12 donjons protégés n'ont reçu AUCUNE modification.

## Reproduire

    bash dev/tools/canonical_dungeon_batch.sh 1
    python3 dev/tools/canonical_dungeon.py validate all
    python3 dev/tools/canonical_dungeon.py report
