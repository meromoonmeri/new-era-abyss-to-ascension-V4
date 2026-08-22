# Livrable unique — bundle canonique Ch. 6 à 32

Ce livrable applique le périmètre choisi : **les deux listes** du projet sont
assemblées dans le même pack.

1. les 27 entrées principales de
   [`MASTER_TIMELINE_CH5_CH32.json`](../canonical/MASTER_TIMELINE_CH5_CH32.json) ;
2. les 51 donjons PMD Red de
   [`ROSTER_IMPORT_DONJONS_PMD_RED_CH7_CH32.md`](../ROSTER_IMPORT_DONJONS_PMD_RED_CH7_CH32.md).

Le registre machine complet est
[`complete_bundle_registry.json`](complete_bundle_registry.json). Il contient
les URLs Bulbapedia, les données normalisées `pret/pmd-red` par étage pour le
roster Red, les mappings DTEF RawAsset et les décisions de déduplication.

## Déduplication explicite

Un même lieu canonique ne reçoit pas deux implémentations concurrentes :

| Entrée Red | Zone réellement utilisée |
|---|---|
| Sinister Woods | `gloomy_forest` (Ch. 6, bundle détaillé) |
| Magma Cavern + Magma Cavern Pit | `magma_cavern` (route principale Ch. 7) |
| Sky Tower + Sky Tower Summit | `sky_tower` (route principale Ch. 10) |

Les autres entrées PMD Red portent le préfixe technique `red_` afin de ne pas
écraser les zones de l'arc principal tout en gardant le nom public canonique.

## Ce qui est généré pour chaque zone physique

- `Data/Zone/<id>.json` ;
- `<id>_entrance`, `<id>_mid`, `<id>_boss` ;
- `Data/Map/<id>_boss.rsmap` lorsqu'un boss canonique est défini ;
- scripts de zone et Grounds ;
- entrée synchronisée dans `Data/Zone/index.idx` et `master_zone.json` ;
- une liaison DTEF `floor/wall/secondary` sans transition manuelle.

Les étages d'exploration possèdent trois familles RogueElements à sélection
runtime : réseau branché, progression étagée, réseau à boucles. Aucune seed de
production ni layout statique ne sont sérialisés.

## Sources DTEF

Les 23 biomes RawAsset utilisés sont répliqués sous
`Content/TileDtef/canonical/`. Chaque dossier garde les PNG DTEF XML-less sans
modification et un `RAWASSET_PROVENANCE.json` avec le hash de chaque fichier.
Le lien exact des 78 entrées vers ces familles et leurs triplets runtime est
publié dans [`complete_dtef_bindings.json`](complete_dtef_bindings.json).
Le script `tools/fetch_canonical_dtef_sources.py` les vérifie et les met à jour
sans créer de convertisseur maison ; l'import runtime reste le workflow natif
**PMDO / Import DTEF**.

## Commandes de reproduction et de contrôle

```bash
# Recrée les zones/Grounds/maps/scripts depuis le registre déjà versionné
python3 tools/build_complete_canonical_bundle.py --write --check

# Vérifie les hashes de toutes les sources DTEF RawAsset
python3 tools/fetch_canonical_dtef_sources.py --check

# Vérifie la non-répétition structurale de toutes les zones physiques
python3 tools/validate_complete_canonical_variation.py

# Vérifie le lot détaillé Ch. 6 sur 10 passages
python3 tools/validate_sinister_woods_variation.py --passes 10

# Vérifie index et GroundMaps synchronisés
python3 tools/verify_zone_index.py .
```

## Contrat de données

- Pour les 51 zones Red, les espèces, niveaux et poids sont dérivés des tables
  `pokemon_found.json` associées à chaque `floor_id.json` du dépôt `pret/pmd-red`.
  Le bundle agrège ces lignes en poids PMDO par tranche de segment ; il ne copie
  pas le tableau de Bulbapedia.
- Les objets sont convertis de catégories `dungeon_item_data.json` vers les IDs
  PMDO disponibles ; les entrées non représentables sont écartées au lieu d'être
  remplacées par du butin hors-thème.
- Les routes principales sans répertoire PMD Red équivalent conservent un pool
  thématique explicitement identifié dans le registre. Elles doivent être
  rejouées dans PMDO avant toute publication de build.

## Limite de validation

Le bundle passe les contrôles structurels, index, références de fichiers,
matériaux et absence de seeds statiques. L'exécutable PMDO n'est pas présent
dans ce sandbox : le test final exigé reste une campagne de smoke-test PMDO,
avec au moins 5–10 entrées sur chaque famille de génération avant diffusion.
