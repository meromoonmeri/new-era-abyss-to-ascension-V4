# Buildings — complete extracted libraries (PNG renders + source records)

Everything here is a **whole, byte-exact asset record** (no crops of sheets beyond
the documented atlas bounding boxes, no rescaling). Sizes are native;
`contact_sheet.png` in each folder is the one-image overview.

| library | count | what it is | status |
|---|---:|---|---|
| `pmuniverse_buildings/` | 143 | PMUniverse village buildings composited from PMU `Tiles*.tile` archives (bbox-trimmed, with source component ids + density in `manifest.json`) — the main raw material for new houses | EXTRACTED, not placement-approved |
| `metano_origins_structure_library/` | 18 | Actual Metano Town buildings re-assembled from the town map data (cafe, inn, elemental homes, guild pieces...) — day/night variants, ground-truth of the current style | source-verified renders |
| `pmd_structure_library/` | 5 | Canonical PMD structures (merchant stand etc.) from pret/PMD map authorities | extracted per source rules |
| `pmdo_isolated_structures/` | 16 | Isolated structures as currently rendered by the PMDO engine | engine views |
| `waves_nostalgia_structures/` | 4 | Waves Nostalgia (PMU fork) adapted building structures | adapted |

## How to use

- Pick from `pmuniverse_buildings/buildings/` (ids like `tiles0_0357` = source
  archive + component index — full metadata in `manifest.json`).
- Match style against `metano_origins_structure_library` (what Metano currently
  uses, so new houses blend in) and `pmd_structure_library` for canonical PMD
  silhouettes.
- Native scale: PMU building records are authored for 8 px ground tiles; do not
  rescale them. Compose new buildings from records, not by painting at a
  different zoom.
- `waves_nostalgia_structures` / `pmdo_isolated_structures` show how other mods
  place the same records — useful for proportions and shadow/layer conventions.

