# Reconstruction canonique des donjons — Ch. 6 à 32

Ce dossier est la source de suivi de la reconstruction demandée après la purge
contrôlée des substituts Ch. 6–32 (`docs/pmdred_eu/chapter6_32_dungeon_purge_manifest.json`).

## Règles de production

1. **Inventaire avant reconstruction.** Le périmètre et les assets sont lus
   dans [`INVENTORY_CH6_CH32.md`](INVENTORY_CH6_CH32.md) avant toute écriture.
   Aucun donjon n'est rempli automatiquement avec une salle carrée placeholder.
2. **Aucun layout procédural mis en cache.** Chaque étage d'exploration doit
   contenir plusieurs `ChanceFloorGen` avec des familles RogueElements distinctes
   (grid branché, grille étagée, grille à boucles), sans seed de production.
3. **Les Grounds restent fixes par intention.** Entrée, relais et boss sont les
   seules cartes non régénérées. Leur transition graphique est produite par
   l'AutoTile PMDO, jamais peinte cellule par cellule.
4. **DTEF sans approximation.** Les dossiers source restent sous
   `Content/TileDtef/`. Le format XML-less RawAsset est importé par le port
   fidèle de `RogueEssence.Dev.DtefImportHelper` dans
   `tools/import_rawasset_dtef.py` ; les 47 cas `AutoTileAdjacent`, les
   variantes et les animations sont conservés. Le résultat importé est inventorié
   dans [`dtef_import_manifest.json`](dtef_import_manifest.json).
5. **Données canonique adaptées.** Les tables de jeu sont des poids et plages
   PMDO, pas un copier-coller d'un tableau wiki. Chaque fiche cite la source,
   énumère ce qui est conservé et les éventuelles adaptations nécessaires.

## État du lot

| Chapitre | Zone technique | Donjon public | État |
|---:|---|---|---|
| 6 | `gloomy_forest` | Sinister Woods / Forêt Sinistre | **construit et validé statiquement** |
| 7–32 | — | liste canonique du projet | à traiter chapitre par chapitre |

Le nom technique `gloomy_forest` est conservé pour la compatibilité des
sauvegardes. Les noms de Grounds suivent en revanche la convention neuve :
`sinister_woods_entrance`, `sinister_woods_mid`, `sinister_woods_boss`.

## Commandes de contrôle

```bash
# Inventaire sans écriture destructive
python3 tools/inventory_canonical_dungeons.py

# Import DTEF RawAsset dans un namespace PMDO privé
python3 tools/import_rawasset_dtef.py Content/TileDtef/sinister_woods/TreeshroudForest1 --id canon_treeshroud
python3 tools/test_rawasset_dtef_import.py

# Ch. 6 réellement jouable
python3 tools/build_chapter6_sinister_woods.py --write --check
python3 tools/validate_sinister_woods_variation.py --passes 10
python3 tools/mapgen/gen_map.py check --cible Data/Ground/sinister_woods_mid.rsground
python3 tools/verify_zone_index.py .
python3 tools/verify_tile_index.py --quiet
```

Un test PMDO en jeu reste requis après chaque changement de moteur ou de version
PMDO : il doit parcourir les 12 étages, valider le relais Kangourex, la défaite
après le relais et le combat fixe du 13e étage.
