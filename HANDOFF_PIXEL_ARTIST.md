# Metano Town — Pixel Artist Briefing

Hi! Below is everything you need to start. The whole pack lives in one repo —
read it top to bottom once, it answers 90% of the questions you'd ask later.

## 1. Where the pack lives

- Branch:
  https://github.com/meromoonmeri/new-era-abyss-to-ascension-V4/tree/resource-pack/metano-pixel-art
- One-click ZIP of everything:
  https://github.com/meromoonmeri/new-era-abyss-to-ascension-V4/archive/refs/heads/resource-pack/metano-pixel-art.zip

## 2. Folder map (what's what)

```
renders/              31 ground renders (day + night town, all guild floors &
                      annexes, cafe, inn, dojo, post office, cave, 6 elemental
                      homes, altere pond & transition, relic forest, riverbed).
                      contact_sheet.png = one-image overview.
                      → THESE are the visual ground truth of the current town.

tilesets/             141 .tile sheet files + their raw .png atlases — the exact
                      tile sources the renders are made of. If a tile exists
                      here, reuse it, don't repaint it.

buildings/            186 building records from 5 extraction libraries:
                      - pmuniverse_buildings/   143 PMUniverse houses/props
                        (byte-exact PNGs, manifest.json maps id → source
                        archive + record + density; contact_sheet.png to skim)
                      - metano_origins_structure_library/  18 = the town's own
                        buildings (cafe, kecleon shop, houses... day+night) —
                        the style you must match
                      - pmd_structure_library/, waves_nostalgia_structures/,
                        pmdo_isolated_structures/ — canonical PMD + other-mod
                        references
                      ALL_BUILDINGS_sheet.png = everything at a glance.

halcyon_original/     The ORIGINAL mod this town comes from (Palikadude/Halcyon):
                      - renders/       34 of its 37 maps, as they looked upstream
                      - structures/    5 building sprites + a full transparent
                        1512x1512 "all object layers" composite you can crop
                        any structure out of (inn, dojo, well, market...)
                      → diff between halcyon_original and renders/ = what was
                        restyled since. Useful to stay coherent, not to copy.

specs/                THE TECHNICAL RULES — read before touching pixels:
                      - NEW_MAP_GUIDE.md      complete measurements: every map's
                        grid size (tiles and px), layer stacks, solid %, marker
                        counts, music; palette of the town; sizing guidance for
                        new interiors; a 7-step authoring checklist; collision
                        semantics; a "what NOT to do" list from past incidents.
                      - format_rsground.md    the map JSON (BOM, layers, tiles,
                        obstacles, markers = entry points, night = geometry clone)
                      - format_tile.md        the .tile container (8px grid, one
                        embedded PNG per tile, dedupe rule) — how to pack new
                        tiles if we ever must
                      - ground_inventory.csv  the same numbers, machine-readable

pmu_assets/           Furniture/small-object raw material:
                      - isolated_candidates/  1189 whole embedded 32x32 records
                        extracted byte-exact from PMU (per-archive contact
                        sheets for triage)
                      - buildings/            3 fully-qualified complete PMD
                        houses with sha256 provenance
                      - manifest / qualified_small_objects_contact_sheet.png
                        83 records already vetted as clean standalone objects
                      ⚠ extraction-level "qualified" ≠ engine-approved: these
                        are reference material; final placement is validated in
                        the game by us, not at draw time.
```

## 3. The Guild job — context

The guild already exists in-engine as 3 floors + ~11 annex maps:

- `guild_first_floor` (320×240 px) — the entrance hall. It was an empty box;
  it now has berry baskets + supply crates on a new `Objects` layer (see the
  before/after pair in `renders/`). That's the pattern for anything you add.
- `guild_second_floor` (672×448) — corridor, bedrooms access, dining entry
- `guild_third_floor_lobby` (800×448) — top lobby
- annexes: `guild_dining_room`, `guild_guildmasters_room`, 4 bedrooms, hallway,
  storage ×2, `guild_heros_room`, plus exterior `guilde_parvis`

Goal of the assignment: make the guild feel **lived-in** across the 3 floors —
reception/desk zone on floor 1, corridors that read as used space on floor 2,
a lobby with real gathering spots on floor 3 — using the existing guild tile
sheets (`tilesets/Guild_*`, `EoN_Guild*`) first, PMU records when the sheets
don't cover it.

## 4. Hard technical rules (violating these = rejected)

1. **1 tile = 8×8 px. Never 16. Never scaled/filtered/blurry.** Characters are
   16 px wide (2×2 tiles); door openings must be 2 tiles or people soft-lock.
2. Work on the provided sheets' **palette** (town base palette is section 4 of
   `NEW_MAP_GUIDE.md`). New tiles must be indistinguishable from their
   neighbours at 1× zoom. No new hues for wood/roof/path.
3. Furniture = **tiles on an `Objects` layer** (not entities), and every drawn
   furniture tile must be **solid in `obstacles`** (Tags 1). A table you can
   walk through is a bug.
4. **Connectivity:** after adding anything, every walkable cell must still be
   reachable from `Main_Entrance_Marker`, no isolated pockets (a past 3×3
   basket trapped 4 cells → it was re-anchored, not shipped).
5. Day changes propagate to the night map (`*_Night` sheets, geometry clone).
6. Reuse > create: 141 sheets + 186 building records + 1189 PMU records exist
   before any new pixel is painted.

## 5. Delivery format

For each map you touch, deliver:
- the edited `.rsground` JSON (keep formatting: UTF-8 BOM, one key per line,
  everything not intended to change stays byte-identical),
- any new/edited `.tile` sheets (or a PNG atlas we pack with the project's
  `png2tileset` tool),
- a 1:1 render of the result (we run the render tool; you can eyeball with the
  same tool before sending),
- a one-line note per change: what, why, which reference was used
  (e.g. "added guild reception counter from tiles7 #4650, matches
  EoN_GuildmasterRoomNight palette").

We validate in the actual PMDO engine (index + runtime probes) before merge —
if something fails there, we come back to you with the render diff, not
vibes.

## 6. Quick start

1. Open `renders/contact_sheet.png` → understand the town's layout and mood.
2. Open `specs/NEW_MAP_GUIDE.md` sections 1, 6, 7, 8 → sizes, checklist,
   collision, forbidden moves.
3. Open `buildings/pmuniverse_buildings/contact_sheet.png` → pick the pieces
   you want for the guild (ids like `tiles7_4650` = source archive + record).
4. Start with `guild_first_floor`: propose a reception desk + notice board +
   two seating spots on the existing 40×30 grid — small, cheap, proves the
   pipeline. Then floor 2 corridor, then the lobby.

Everything is yours to improve, but nothing on this list is optional.
Questions → me. Let's make this guild feel inhabited. 🧱✨
