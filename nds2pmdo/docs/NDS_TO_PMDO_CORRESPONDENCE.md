# Correspondance NDS → PMDO 0.8.12 — stratégie par format

Règle : aucune correspondance n'est codée en dur sans documentation. Ce document
est la spécification de référence ; les manifests (`manifest/`) portent l'état
exact par élément.

## Légende

| Classe | Sens |
|---|---|
| DIRECT | transposable tel quel (structure équivalente) |
| ADAPTATION | pas d'équivalent direct : mapping documenté vers un mécanisme PMDO natif |
| EMULATION | émulation par script/coroutine PMDO |
| UNKNOWN | non décodé côté NDS — rien n'est généré |

## 1. Donjons (mapparam → Data/Zone/*.json)

| Donnée NDS | Source | Cible PMDO | Classe |
|---|---|---|---|
| FloorProperties.layout / roomDensity / enemyDensity / … | SOURCE_NDS | GenSteps (GridFloorGen, MapDataStep) | ADAPTATION (mapping documenté) |
| floor_id (8 tables/étage) | SOURCE_NDS | références internes des étapes | DIRECT (indices) |
| SpawnPokemonData (species, level, poids) | SOURCE_NDS | étapes de spawn PMDO (species+level) | ADAPTATION (formule poids → % à documenter) |
| Tables d'items (catégories + poids) | SOURCE_NDS (IDs UNKNOWN) | étapes d'items PMDO | ADAPTATION/UNKNOWN |
| Tables de pièges | SOURCE_NDS (noms UNKNOWN) | étapes de pièges PMDO | ADAPTATION/UNKNOWN |
| bgMusic → SEQ | SOURCE_NDS (index SEQ UNKNOWN) | `Music` du segment | UNKNOWN |
| Géométrie (tileset id → blob bNN) | SOURCE_NDS | tileset PMDO correspondant | ADAPTATION |
| Maisons de monstres, boutiques, objets enterrés | SOURCE_NDS (champs) | GenSteps dédiés PMDO | ADAPTATION |

## 2. Tilesets (bNNfon/cel/cex/canm/pal → Content/Tile/ + Data/Tile/)

| Blob NDS | Rôle | Cible PMDO | Classe |
|---|---|---|---|
| fon | motifs de tiles 8×8 4bpp | feuille de tiles PNG | ADAPTATION (reconstruction exacte, pas de ré-échantillonnage) |
| pal | 3 palettes BGR555 | palettes du tileset | DIRECT (conversion 555→888 exacte) |
| cel/cex | cellules/comportements | données de terrain PMDO | ADAPTATION |
| canm | animations de tileset | animations PMDO (tiles animés, eau/lave…) | UNKNOWN (sémantique) |

## 3. Grounds (ground.sbin → Data/Ground/*.rsground)

| Package NDS | Cible | Classe |
|---|---|---|
| AXXPYY (zones) | Ground PMDO | UNKNOWN (format du package non décodé) |
| B10P01A/B/C, B10P02A/B/C (cinématiques SW) | Grounds de cinématique | UNKNOWN |

## 4. Sons (sound.sbin SDAT → Content/Music/ + Content/Sound/)

| Donnée | Statut | Cible |
|---|---|---|
| Noms SEQ/ME/SE | SOURCE_NDS (validé) | inventaire de mapping |
| Fichiers SSEQ + boucles | UNKNOWN | OGG avec boucles PMDO |
| Mapping bgMusic → SEQ | UNKNOWN (code ARM9) | champ Music des zones |

## 5. Scripts / événements

| Source NDS | Statut |
|---|---|
| Scripts de ground (B10P01…) | UNKNOWN |
| Événements de donjon | UNKNOWN |
| Dialogues (message_*.bin/.str) | PARTIAL — format identifié, frontières à documenter |
| Cinématiques | UNKNOWN (dépendent des scripts) |

## 6. Convention de nommage PMDO (Phase 1)

Les identifiants NDS (`b41`, `B10P01`, `mapparam`) restent dans les manifests de
provenance (`source_id`, `source_file`, `source_floor`) ; le contenu PMDO généré
utilise des noms logiques :

| NDS | PMDO (convention) |
|---|---|
| dungeon #3, tileset 41 | `SinisterWoods01` … `SinisterWoods13` (étages) |
| ground B10P01A/B/C | `SinisterWoodsCutscene01A/B/C` (ou nom de scène canonique) |
| musique SEQ 15 (candidat) | `SinisterWoodsBGM` (une fois le lien démontré) |

Le manifest `manifest/sinister_woods_mapping.json` porte le mapping exact et sa
provenance.
