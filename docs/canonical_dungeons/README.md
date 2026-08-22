# Reconstruction canonique des donjons — Ch. 6 à 32

Ce dossier est la source de suivi de la reconstruction demandée après la purge
contrôlée des substituts Ch. 6–32 (`docs/pmdred_eu/chapter6_32_dungeon_purge_manifest.json`).

## Règles de production

1. **Un chapitre à la fois.** Le premier lot actif est le chapitre 6,
   **Sinister Woods**. Les autres zones ne sont pas recréées par remplissage
   automatique.
2. **Aucun layout procédural mis en cache.** Chaque étage d'exploration doit
   contenir plusieurs `ChanceFloorGen` avec des familles RogueElements distinctes
   (grid branché, grille étagée, grille à boucles), sans seed de production.
3. **Les Grounds restent fixes par intention.** Entrée, relais et boss sont les
   seules cartes non régénérées. Leur transition graphique est produite par
   l'AutoTile PMDO, jamais peinte cellule par cellule.
4. **DTEF sans convertisseur maison.** Les dossiers source restent sous
   `Content/TileDtef/`. Le format XML-less est celui de RawAsset et peut être
   ouvert par **Import DTEF** de PMDO. Les bindings de runtime sont consignés
   dans `dtef_bindings.json`.
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

## Commandes de contrôle — Ch. 6

```bash
python3 tools/build_chapter6_sinister_woods.py --write --check
python3 tools/validate_sinister_woods_variation.py --passes 10
python3 tools/mapgen/gen_map.py check --cible Data/Ground/sinister_woods_mid.rsground
python3 tools/verify_zone_index.py .
```

Un test PMDO en jeu reste requis après chaque changement de moteur ou de version
PMDO : il doit parcourir les 12 étages, valider le relais Kangourex, la défaite
après le relais et le combat fixe du 13e étage.
