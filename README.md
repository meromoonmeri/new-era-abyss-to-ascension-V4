# Metano Town — Pixel-Art Resource Pack

Everything a pixel artist needs to work on **Metano Town (New Era / PMDO)**:
ground renders **limited to Metano Town locations as in the original Halcyon mod**
(https://github.com/Palikadude/Halcyon), the exact tileset sheets they use, format
notes, and the PMUniverse / RawAsset house & furniture asset lists.

This pack is extracted from `meromoonmeri/new-era-abyss-to-ascension-V4`
(branch `arena/01a02f1c-new-era-abyss-to-ascension-v4`) on 2026-08-29.
It is a read-only reference — do not edit game data here; final assets live
in the mod repository.

## Layout

```
renders/        one PNG per ground (31 images / 29 grounds) + contact_sheet.png
                SCOPE = Halcyon original only: the New Era sky-network grounds
                (carrefour_*, bourg_comptoir, cap_dents_mer, plage_lucioles,
                colline_sans_lumiere, vast_steppe_entrance, dojo_ossatueur,
                guilde_parvis, guild_hut/path) are intentionally excluded.
                - the town itself, day and night (1512x1512 px)
                - all 3 guild floors, 10 guild annexes (bedrooms, dining,
                  storage, master office, hero's room, hallway)
                - public buildings: cafe, inn, ledian dojo, post office, cave
                - 6 elemental houses (fire/water/grass/electric/normal/rock)
                - Halcyon entrances: altere transition & pond, relic forest,
                  illuminant riverbed entrance
tilesets/       the 141 `.tile` sheet files (and their raw `.png` atlases)
                actually referenced by those grounds — 8px grid, do not rescale
specs/
  ground_inventory.csv   per ground: grid, px size, layers, music, solid %,
                         npcs/objects/markers counts, tileset count
  ground_tilesets.md     ground -> exact sheet names
  format_rsground.md     the map JSON format + editing rules (BOM, obstacles,
                         markers as entry points, night = geometry clone)
  format_tile.md         the .tile container format (decoded, round-trip proven)
  pmu_assets.md          PMUniverse qualified object list + RawAsset building
                         manifest summary
  requirements.md         full project brief/plan the pack was built for
pmu_assets/
  manifest.json, qualified_small_objects_contact_sheet.png,
  isolated_candidates/   83 qualified standalone PMU furniture objects
                         (byte-exact source PNGs, 16px, categories: containers,
                         furniture, wall art, books, plants, lighting, tools)
  buildings/             3 qualified complete PMD houses (House_Normal, tent,
                         plain tent) + manifest with sha256 provenance
  BUILDINGS_INDEX.md     per-archive building index: Tiles7 (467) / Tiles8 (285)
                         / Tiles9 (174) isolated building records + where to
                         triage them
  pmu_extraction/        full extraction reports from the PMU client .dat
                         (2 001 canonical maps, per-map tileset usage,
                         map connection graph, contact renders of 3 critical
                         village maps, tileset geometry audit)
```

## Hard rules (from the project, verified)

1. **1 tile = 8×8 px.** Characters occupy 16 px (2×2 tiles). Never upscale,
   downscale, or blur source tiles — pixel-art scale is fixed.
2. Buildings are drawn on `Base`/`Objects*` layers as **baked tiles**;
   furniture added to a room = new tiles on an `Objects` layer + solid
   `obstacles` cells underneath only.
3. Collision grid: `obstacles[x][y].Tags` — `0` walkable, `1` solid. Every
   added solid footprint must keep all markers connected and create **zero**
   isolated walkable cells.
4. Night variants are geometry clones: same tiles at same positions, only
   `*_Night` sheets. If a day map changes, the night map must follow.
5. Reuse before creating: check `tilesets/` (and `pmu_assets/`) first; a new
   sheet is authored at 8px with the neighbors' palette, packed as `.tile`
   (format in `specs/format_tile.md`).
6. PMU objects are `WHOLE_EMBEDDED_PNG_BYTE_EXACT` — extraction only, no
   editing; previews are rendered 2× nearest **for viewing**, never for
   submission.

buildings/            186 extracted building records across 5 libraries:
                      pmuniverse_buildings (143 PMU village houses/props,
                      byte-exact), metano_origins_structure_library (18 actual
                      Metano buildings day/night), pmd_structure_library,
                      waves_nostalgia_structures, pmdo_isolated_structures —
                      each with contact_sheet.png; ALL_BUILDINGS_sheet.png is
                      the combined overview. See buildings/README.md.

## Where things plug into the engine

- Ground file: `Data/Ground/<id>.rsground`
- Zone registration: `Data/Zone/<zone>.json` `GroundMaps` list + `index.idx`
- Entry points = named markers (`Main_Entrance_Marker`, `<X>_Entrance_Marker`,
  `<X>_Entrance_Marker_Partner`)
- NPCs: `MapChars` with `AIEnabled`/`movementSpeed`; wandering paths scripted
  per map (`CreateWalkArea` in `metano_town/init.lua`)

## Provenance & license

- Metano renders/tilesets: New Era mod data (RogueEssence ecosystem, MIT).
- PMU assets: PMUniverse (https://github.com/PMUniverse) — reference only.
- RawAsset buildings: PMDCollab/RawAsset — reference only.
- Pokémon content belongs to its rightsholders; this pack is a fan-work
  production reference, not redistributable game content.
