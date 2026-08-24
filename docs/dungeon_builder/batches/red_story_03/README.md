# red_story_03 — Mt. Steel

Third PMD Red story batch. Introduces canonical **fixed-room boss** support to
the shared `red_story_batch` engine: the ROM's `fixed_room=1`
(`FIXED_ROOM_MT_STEEL_SKARMORY`) on floor 9 is materialised as a dedicated
`fixed_segments` entry pointing at a **pixel-exact `.rsmap` counterpart** of
the canonical Ground `d03p02.rsground`.

## Canonical provenance chain

| Aspect | Source | Evidence |
| --- | --- | --- |
| Dungeon name | PMD Red ROM | `Mt. Steel` / `Pic Ferreux` |
| Music | PMD Red EU ROM extraction | `Content/Music/Mt Steel.ogg` |
| Floors 1–8 (procedural) | PMD Red ROM manifest | `docs/canonical/red/mt_steel_rom_manifest.json` |
| Floor 9 (fixed) | PMD Red ROM manifest + `include/constants/fixed_rooms.h` | `FIXED_ROOM_MT_STEEL_SKARMORY` |
| DTEF (floors 1–5) | PMDO base + ROM tileset 39 | `mt_steel_1_floor/wall/secondary` |
| DTEF (floors 6–8) | PMDO base + ROM tileset 40 | `mt_steel_2_*` (available as override) |
| Boss species | PMD Red ROM manifest | Skarmory level 10 |
| Boss `.rsmap` layout | Canonical Ground `d03p02.rsground` | `tools/make_ground_arena.py --ground d03p02 --name mt_steel_boss` |
| Post-battle scene | PMD Red ROM cinematic extraction | `Data/Script/halcyon/ground/d03p02/init.lua` (`SCENE_D03P02_*` keys) |
| Entrance Ground | PMD Red ROM | `pic_ferreux_pied` |
| Final Ground | PMD Red ROM | `d03p02` |

## Runtime state

* **Configuration gate**: PASS (`canonical_gate.inspect` → `config_ready: true`)
* **Native RogueElements mapgen**: PASS 90 / 90 iterations, 0 failures, 0
  non-traversable, 0 invalid. 8 procedural floors × 10 iterations show real
  structural variety (rooms 11–22, halls 15–48, branches 3–10, loops 0–37),
  autotile confirmed `mt_steel_1_floor/wall`. Boss LoadGen floor validates
  with `entry_ok=true, traversable=true, mobs=1` (Skarmory attached).
* **Route runtime** (real PMDO 0.8.12 headless):
  * ✓ entrance canonical Ground `pic_ferreux_pied` loaded
  * ✓ 8 procedural floors traversed with distinct `map_seed`s and stairs
  * ✓ `segment_clear` on segment 0
  * ✓ Boss segment map loaded with `boss_species=skarmory` matching
    `expected_boss_species=skarmory` (ROM fidelity proof)
  * ✗ **Boss transition to `d03p02` blocked by PMDO 0.8.12 quirk**

## Open blocker: `DungeonFloorEnter` not published for LoadGen in headless

The `EngineServiceEvents.DungeonFloorEnter` service event fires for every
procedural floor in this repository (confirmed with an instrumented
`floor_enter_debug` tracer in `red_story_route_validator/init.lua`: floors 0..7
of segment 0 all emit it in every run). It never fires for the LoadGen boss
floor (segment 1, floor 0). Consequently the canonical `EndSegment(Cleared)`
call sinister proved works from `OnDungeonFloorEnter` cannot be reused: at
the earlier `OnDungeonMapInit` fire, the map init coroutine still holds
control and the `SceneOutcome` reflection assignment is discarded when it
returns; `OnUpdate` is never ticked while the boss coroutine holds control.

Multiple mitigations were tested:
* `SceneOutcome` reflection assignment from `OnDungeonMapInit` → outcome
  discarded when map init coroutine returns.
* Direct `GAME:EnterZone(zone, -1, ground_idx, 0)` from `OnDungeonMapInit`
  → runtime remains stalled on the boss map.
* `HP=0` + `Dead=true` on every enemy team member from `OnDungeonMapInit`
  → boss dies logically but no gameplay tick runs to detect it.
* `OnDungeonSegmentStart` → fires with `_ZONE.CurrentMapID.Segment=-1` (the
  segment is not yet set), so it cannot distinguish the boss segment.
* Adding a stairs tile to `mt_steel_boss.rsmap` to make PMDO treat it like
  a regular navigable floor → does not change the DungeonFloorEnter behavior.

The mt_steel definition stays fail-closed at
`ROUTE_VALIDATED_BOSS_TRANSITION_PENDING`: mapgen and ROM-species fidelity
are proven, but the canonical Ground transition after the boss segment is
not, and per the project rules we do NOT promote a dungeon whose full end
sequence has not been observed in real PMDO 0.8.12 runtime.

The four previously-promoted dungeons (tiny_woods, thunderwave_cave,
silent_chasm, great_canyon) are re-verified end-to-end after every change to
the shared validator and remain PROMOTED_RUNTIME_VALIDATED with no regression.

## What was actually built and preserved

* `tools/dungeon_builder/red_story_batch_03.py` — Mt. Steel CONFIG,
  procedural profiles (`steel_branch`, `steel_lattice`), and canonical
  `fixed_segments` declaration.
* Engine extension in `tools/dungeon_builder/red_story_batch.py`:
  `reconcile()` now accepts `fixed_floors` declared in `fixed_segments`,
  emits `procedural_only` `definition_floor_mode`, attaches the fixed
  segment to `raw.fixed_segments` with full ROM provenance
  (`source_pokemon`, `source_fixed_room`, `provenance=PMD_RED_ROM`),
  and populates `scenes.canonical_layout_source`, `scenes.rsmap_source`,
  `scenes.battle_ground` per the project rules.
* `Data/Map/mt_steel_boss.rsmap`: pixel-exact contrepartie of
  `Data/Ground/d03p02.rsground`, 19×23 tiles at 24 px (57×69 cells × 8 px),
  1 canonical layer preserved from d03p02. Skarmory level 10 placed at
  the chamber centre. Entry points at the corridor entrance.
* `Content/Tile/mt_steel_boss_Base_canonique.tile` (+ `index.idx`
  re-injected) — the tile package for the boss map's canonical layer.
* `Data/Script/halcyon/services/red_story_route_validator/init.lua`:
  generic boss-clear infrastructure (CONFIG entry with `boss = {segment,
  map, species, source_floor, source_fixed_room, provenance}`, boss species
  inspection at DungeonMapInit, boss_clear + segment_clear emission at
  DungeonFloorEnter for the boss segment).
* `Data/Script/halcyon/ground/d03p02/init.lua`: `SV.CanonicalDungeons`
  marker moved to head of `Enter`, matching the pattern used by all other
  canonical final Grounds (d01p02, d02p02, d05p02, d07p02).
* `Data/Script/halcyon/zone/mt_steel/init.lua`: `ExitSegment` routes
  segment 0 → segment 1 (boss), segment 1 → canonical final Ground
  `d03p02`. No env-var gate, no per-Ground hack.
* `Data/Zone/mt_steel.json`: 2 segments (8 procedural + 1 LoadGen boss).
* `Data/Zone/index.idx`: rebuilt via `update_zone_index()` so the runtime's
  `ZoneEntrySummary.SegLocValid` accepts the 2-segment layout (`CountedFloors=8`,
  `Maps=[[0..7],[0]]`).
* `DungeonDefs/canonical/mt_steel.json`: canonical definition
  regenerated. `boss.mode=canonical_ground`, `boss.ground=d03p02`,
  `boss.map=mt_steel_boss`, `boss.source_floor=9`,
  `boss.source_fixed_room=1`, `boss.provenance=PMD_RED_ROM`.

## Runtime artifacts

* `docs/dungeon_builder/batches/red_story_03/runtime/native_mapgen.jsonl`
  — 90 real PMDO 0.8.12 mapgen outcomes.
* `docs/dungeon_builder/batches/red_story_03/runtime/routes/mt_steel.jsonl`
  — real PMDO 0.8.12 route trace stopping at boss segment loaded.
* `docs/dungeon_builder/batches/red_story_03/runtime/routes/mt_steel.log`
  — raw PMDO stderr/stdout showing `DungeonSegmentStart → DungeonMapInit
  map=mt_steel_boss (foes=1 = Skarmory)` and the absence of the subsequent
  `DungeonFloorEnter`.
