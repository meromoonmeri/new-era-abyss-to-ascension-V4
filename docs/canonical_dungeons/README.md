# Reconstruction canonique des donjons — Ch. 6 à 32

Ce dossier suit le **livrable unique** demandé après la purge contrôlée des
substituts Ch. 6–32 (`docs/pmdred_eu/chapter6_32_dungeon_purge_manifest.json`).
Le périmètre choisi fusionne les routes principales de la Master Timeline et
le roster des 51 donjons PMD Red.

## Contrat commun

1. **Aucun layout procédural mis en cache.** Chaque exploration emploie trois
   familles RogueElements runtime : réseau branché, grille étagée et réseau à
   boucles. Aucune seed de production n'est sérialisée.
2. **Grounds fixes par intention.** Toute zone physique possède
   `[zone]_entrance`, `[zone]_mid`, `[zone]_boss`. Les transitions graphiques
   viennent de l'AutoTile PMDO, jamais d'une peinture de raccord manuelle.
3. **DTEF sans convertisseur maison.** Les sources RawAsset XML-less sont
   répliquées sous `Content/TileDtef/canonical/`; l'import est le workflow natif
   **PMDO / Import DTEF**.
4. **Données adaptées, non copiées.** Les poids PMDO et les tranches de spawn
   sont dérivés des sources par étage ; les tableaux wiki ne sont pas recopiés
   dans les fichiers de jeu.
5. **Déduplication des lieux.** Sinister Woods, Magma Cavern/Pit et Sky
   Tower/Summit partagent une zone canonique au lieu d'être dupliqués.

## État du bundle

| Ensemble | Entrées | Zones physiques |
|---|---:|---:|
| Routes principales Ch. 6–32 | 27 | 27, dont `gloomy_forest` détaillé à la main |
| Roster PMD Red | 51 | 46 nouvelles + 5 alias de lieux partagés |
| **Total** | **78** | **73 zones canoniques actives** |

Les listes, mappings DTEF, tables normalisées et alias sont dans
[`complete_bundle_registry.json`](complete_bundle_registry.json). Voir aussi :

- [COMPLETE_BUNDLE.md](COMPLETE_BUNDLE.md) — contrat, sources et limites ;
- [complete_dtef_bindings.json](complete_dtef_bindings.json) — 78 bindings ;
- [SINISTER_WOODS.md](SINISTER_WOODS.md) — fiche détaillée Ch. 6.

## Commandes de contrôle

```bash
python3 tools/build_complete_canonical_bundle.py --write --check
python3 tools/fetch_canonical_dtef_sources.py --check
python3 tools/test_complete_canonical_bundle.py
python3 tools/validate_complete_canonical_variation.py
python3 tools/validate_sinister_woods_variation.py --passes 10
```

Un smoke-test PMDO reste requis avant publication : le binaire moteur n'est pas
présent dans ce sandbox. Il faut notamment faire 5–10 entrées réelles dans
chaque famille de génération et tester les relais, défaites et finales.
