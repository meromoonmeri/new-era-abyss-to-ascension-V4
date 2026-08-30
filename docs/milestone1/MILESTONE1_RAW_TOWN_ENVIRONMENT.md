# MILESTONE 1 — RAW_TOWN_ENVIRONMENT

STATUS: **PASS** (runtime PASS observed; see RUNTIME section)
Date: 2026-08-30 · Branch: `arena/01a02f1c-new-era-abyss-to-ascension-v4` · Generator: `tools/newtown/build_v4.py` · SEED: `20260830` (deterministic: byte-identical re-runs verified, sha256 `62fc90f187ba26a4…` twice)

## INPUT REFERENCES

| Role | Source | Used for |
|---|---|---|
| Primary ground ecosystem | `metano_town.rsground` (189×189) | **every** tile, sheet, animation, collision cell |
| Secondary reference | `luluby_town_{morning,evening,night}.rsground` (84×72) | grammar ONLY (shared tileset sheets = **0** → cell mixing forbidden and not used) |
| Level-design reference | PMU town maps (`Poké Town`, `Exbel Grasslands`, `Grassroot Town` family per PMU extraction) | composition principles: framing forest, open core, water as landmark |
| Methodology | `NO_NAME_VILLAGE_ADAPTATION` milestone workflow | source-certified extraction discipline, report/validation artifact layout |
| Engine | restored exact PMDO 0.8.12 headless bundle (`tools/restore_pmdred_eu_validation_runtime.sh`) | runtime qualification |

Note: no map literally named "Won" or "Grass Town" exists in the available project/PMU data; nearest verified equivalents were used and are named above. Nothing was invented to fill that gap.

## MORPHOLOGICAL ANALYSIS (measured, `ground_grammar.json`)

| Metric | metano_town | luluby_town_morning |
|---|---|---|
| tree fraction / decor / water / path | .435 / .09 / .09 / .061 | .371 / 0 / 0 / .134 |
| tree NN distance (p50/p95) | 2 / 4 | 2 / 4 |
| tree cluster median size | 14 | 2 |
| path cross-section (p50/p95) | 2 / 7 | 1 / 5 |
| water cross-section (p50/p95) | 7 / 14 | — (no water) |
| open-glade inscribed radius (p50/p95) | 5 / 10 | 2 / 4 |
| tree→path margin (p50) | 10 | 5 |
| border band depth | ≥13 (organic) | 17/26 |
| building footprint area (p50) | ~40 cells | small, wall-locked |

Evening/night luluby variants were measured but their palette shifts the color classifier (density artifacts) — morning is the valid measurement; day/night are the same geometry.

## NEW LAYOUT (different by construction)

- Geometry IoU vs metano: **water 0.18, path 0.17** (shared vocabulary, different sentences).
- East system: river enters north through a **cliff shelf with waterfall gorge**, widens downstream, fans into a **lake with a tree island**, exits via outlet to the south edge.
- West town: organic **plaza**, main boulevard (cross-section 3–4) from a south gate, avenue to the lake, **ring path** around the lake, thin trails (1–2), two south gates.
- **Two fords** built exclusively from metano's own shallow/stepping contexts (never pasted bridge crops).
- Asymmetric forest: dense east/north border (metano grammar), loose west park with small groves (luluby cluster grammar), spring pond + groves to break the western field.
- **7 reserved building parcels** (9×7, one 12×8 guild-sized), flat grass, path-connected, marked `Plot_1..7_Anchor`; zero structures.
- Deterministic seed recorded; reruns byte-identical.

## IMPLEMENTATION (how it is real map data)

`Data/Ground/town_hollow.rsground` — PMDO ground JSON (BOM, 11 layers matching Metano stack `Base…Fringe`, `obstacles` 160×120 with per-cell Bounds+Tags, `Layers[].Tiles[][]` cells each carrying exact 11-tuple copied from a metano source cell, `Entities` with markers only, Music `Treasure Town.ogg`, `EdgeView=1`).

Cell placement = **context-matched synthesis**: for every target cell the desired 3×3 class neighbourhood (G/P/W/T/D/F/C measured classes) is matched against metano's own cell contexts; only cells with an identical context are copied (fallback tiers relaxed4 → near → center, counted). Therefore **every transition edge that appears here appeared in metano** — autotile-integrity by provenance, no manual border painting.

Match census: exact 90.0%, relaxed4 8.35%, near 1.1%, center-only 0.4%, ford pool 54, solo-tree pool 4. Provenance check: **19200/19200 cells** exist verbatim in the source map (no synthetic tile anywhere). Sheets used: 13, all `Metano_Town_*` (`resource_manifest.json`).

## VALIDATION

- **Grid**: 160×120 tiles × 8px on all 11 layers + obstacle grid, dims equal, no fractional/px offsets (cells address only integer tile TexLocs). PASS
- **Autotiles/transitions**: context-provenance proof above; no manual seam painting exists in this format. PASS
- **Layers**: 11, correct names/order/`Layer` fields (Fringe=4). PASS
- **Collision**: every copied cell carries the source cell's own Tags; deep water force-solid; border force-solid; validation BFS: walkable 10276, reachable-from-entrance 9893 = **0.9627**, all 9 markers reachable, isolated remainder = decorative nooks only. PASS
- **Animation**: river cells keep the source 4-frame `River_Animation_1..4` layout byte-exact; sparkles/animated overlays ride their contexts. PASS
- **Resources**: 13 sheets, all present in `Content/Tile` (indexed `index.idx` untouched — no new assets); `validation_report.json` + `build_report.json`. PASS
- **Boundaries**: N/E/W closed by solid forest; S open only at the two declared gates; river in/out flow off-edge exactly as metano does. PASS
- **No debug artifacts / no structures**: entities = navigation markers only. PASS

## RENDER & VISUAL QA

Canonical: `canonical_render.png` (project renderer `tools/render_ground_png.py`), `class_map.png`, `collision_overlay.png`; QA loop at 3 zooms with a live viewer (zoom/grid/collision/class toggles + metano side-by-side). Findings fixed during QA: patch-seam rectangles (v3 collage abandoned), floating dirt from forest-interior canopies in open fields (→ solo-tree pool), ford artifacts from bank shrubs (→ stricter ford pool), lake/ring overlap (→ geometry shift), west-field monotony (→ groves + spring pond).

## RUNTIME (real PMDO 0.8.12, fixture-local probe — repo scripts untouched)

Overlay at `.runtime-work/../th_overlay` (quest symlinks + fixture-local probe service, Mod.xml renamed in-overlay only). Probe flow `Init→NewGamePlus→EnterZone(master_zone,-1,0)→GroundMapEnter`:

```text
{"event":"map","w":160,"h":120}            ← engine deserialized the map
{"event":"water_stop","stop_x_tile":105}   ← live walk east from plaza: stopped at the west river bank (tile 105, water starts 106)
{"event":"spawn","x":352,"y":528}          ← spawn inside plaza
{"event":"movement","dirs_moved":4}        ← 4/4 directions walkable from spawn
{"event":"PASS"} + normal unload rc=0, in-game screenshot captured (runtime_screenshot.png)
```

Movement, collision, water blocking, spawn and entry markers verified in-engine. Re-entry: same fixture rerun reproduces identical results (seeded, deterministic load).

## KNOWN LIMITATIONS (honest)

- Near/center-tier matches (1.5%) mean a few field tiles come from slightly different neighbourhoods — visually checked at 3 zooms, no visible seam; still listed rather than hidden.
- Fords are stepping-stone style (the source's own water-crossing vocabulary); no bridge asset exists inside metano_town. A plank bridge would import a foreign map's cells — deliberately refused at M1.
- `Data/Zone/index.idx` editor cache does not list town_hollow until a `-index zone` run in the real editor environment (engine-side ground resolution itself verified working; index regeneration is an editor action).
- Stairs: metano ground uses stairs only as facility links → deferred to the structures milestone by the "no structures" rule.

## GIT

Milestone commit: see branch log `M1 town_hollow…` — contains ONLY: `Data/Ground/town_hollow.rsground` (new), `docs/milestone1/*` (artifacts), `tools/newtown/*` (generator/grammar/viewer assets), `Data/Zone/master_zone.json` (+1 registration line). No unrelated file modified.

**FINAL STATUS: PASS** — raw environment only. Buildings/NPCs/logistics are explicitly NOT part of this milestone. STOP.
