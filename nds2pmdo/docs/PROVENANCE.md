# Provenance — règles d'étiquetage du pipeline

## Catégories

| Tag | Définition | Exemple |
|---|---|---|
| `SOURCE_NDS` | Octets lus directement dans la ROM APHP (seule référence : `meromoonmeri/POKEMON-ROM`) | `FloorProperties[17].bytes_hex` |
| `SOURCE_NDS_DECODED` | Octets ROM décompressés/décodés par le pipeline | `b41fon.dec.bin` |
| `CROSS_REFERENCE` | Valeur provenant d'un autre projet (pmd-red, SkyTemple…) — **jamais** présentée comme extraite | noms d'espèces, noms de champs |
| `DERIVED_MAPPING` | Règle de correspondance dérivée et documentée | tileset N → blobs `b{N:02d}*` |
| `PMDO_VALUE` | État actuel du mod New Era — jamais une preuve NDS | `gloomy_forest.json` |
| `UNKNOWN` | Non décodé — aucune valeur inventée | mapping bgMusic → SEQ |
| `MISSING` / `NOT_DECODED` | Ressource absente / présente mais non décodée | scripts ground B10P01 |
| `ADAPTATION_REQUIRED` | Fonctionnalité NDS sans équivalent direct PMDO ; stratégie documentée dans `docs/NDS_TO_PMDO_CORRESPONDENCE.md` | layout/roomDensity → GenSteps |

## Interdictions absolues

1. Remplir un champ avec une valeur supposée « parce qu'elle semble plausible ».
2. Présenter un cross-check comme une donnée extraite de la ROM.
3. Remplacer une texture/palette/frame manquante par du noir ou un placeholder.
4. Déclarer une conversion « complète » tant que l'audit dit `PARTIAL/UNKNOWN`.
5. Modifier New Era pour masquer une limitation du convertisseur.

## Chaîne de traçabilité d'un élément généré

Chaque élément PMDO généré devra référencer :
`source_id` (NDS) → `source_file`/`source_offset` (ROM) → `decoder` (module nds2pmdo)
→ `converter_version` → `tests` ayant validé l'intégrité → `statut` (DIRECT /
ADAPTATION / EMULATION / UNKNOWN).
