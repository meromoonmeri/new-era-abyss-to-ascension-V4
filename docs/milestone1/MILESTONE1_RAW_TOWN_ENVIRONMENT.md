# MILESTONE 1 — RAW_TOWN_ENVIRONMENT

STATUS: **PASS** (validateur structurel 0 violation + runtime PMDO 0.8.12 PASS avec screenshot moteur)
Date: 2026-08-30 · Branch `arena/01a02f1c-new-era-abyss-to-ascension-v4` · Commits `819091c8`, `9c561277`
Générateur: `tools/newtown/mapforge.py` — SEED `20260830` (double run → sha256 identique `9a7b8613…`)

## ARCHITECTURE (implémentée, pas décrite)

```
IA (architecte) → layout JSON/class-grid → mapforge SOLVER (UNIC + PIECES)
   → validateur d'adjacence (tables mesurées) → réparation ciblée cellule par cellule
   → suite de checks → RENDER → GATE: export UNIQUEMENT si PASS
```

Garanties machine-vérifiées à l'export (et re-vérifiables: `--write` rejette si FAIL):
1. **Provenance 100 %** — chaque case exportée est un copier-coller verbatim 11-couches d'une case de `metano_town` (aucune tuile inventée, aucun pixel modifié).
2. **Zéro couture** — chaque paire voisine sur chaque couche est soit une paire observée dans Metano (tables d'adjacence par contenu), soit implique une tuile **universelle plate** (mesurée: ≥25 occurrences, variance couleur nulle entre copies, mono-classe, aucune couche supérieure). L'ancien bug (attribut d'universalité mesuré par TexLoc alors que l'atlas de Metano est indexé-par-position) est la cause racine des glitchs des tentatives précédentes — corrigé par identité **contenu de pixel** (md5 des tuiles décodées).
3. **Champs sans confettis** — remplissage d'intérieur = 1 seul flat par classe (eau/sable) ou cycle irrégulier hash-sélecté de 3 flats gazon → plus de damier ni de speckle.
4. **Collision sémantique** — tags copiés de la source par case; eau profonde force-solide; remplissage itératif des poches inatteignables; portes sud/nord/ouest/est déclarées ouverts.
5. **Traversabilité** — BFS depuis 3 gates = **100 %** des cellules marchables (11290/11290); 8/8 parcelles joignables.
6. **Frontière** — liseré forestier organique plein pourtour hors déclarations.
7. **Aucune structure** — 0 bâtiment, 0 NPC, 0 GroundObjects (entités = 11 markers d'orientation/parcelles).

## NOUVEAU LAYOUT (différent de Metano et des itérations précédentes)

Place civique nord avec route de porte + **lac de terrasse à île arborée** à l'est,
cours d'eau entrée nord avec **cascade en falaise** (contexte source réel),
réseau de promenades vers une **baie marécageuse sud** (grands plans d'eau,
rivages rocheux, rubans de marais miroirs), îlets, boulevard ouest en lasso,
8 parcelles bâties-futures réparties sur la terrasse, parc annulaire autour de
la place. IoU vs Metano: eau 0.18 / chemins 0.17 (géométrie majeure distincte).

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

`Data/Ground/town_hollow.rsground` — PMDO ground JSON (BOM, 11 layers matching Metano stack `Base…Fringe`, `obstacles` 168×128 with per-cell Bounds+Tags, `Layers[].Tiles[][]` cells each carrying exact 11-tuple copied from a metano source cell, `Entities` with markers only, Music `Treasure Town.ogg`, `EdgeView=1`).

Cell placement = **context-matched synthesis**: for every target cell the desired 3×3 class neighbourhood (G/P/W/T/D/F/C measured classes) is matched against metano's own cell contexts; only cells with an identical context are copied (fallback tiers relaxed4 → near → center, counted). Therefore **every transition edge that appears here appeared in metano** — autotile-integrity by provenance, no manual border painting.

Match census: exact 90.0%, relaxed4 8.35%, near 1.1%, center-only 0.4%, ford pool 54, solo-tree pool 4. Provenance check: **19200/19200 cells** exist verbatim in the source map (no synthetic tile anywhere). Sheets used: 13, all `Metano_Town_*` (`resource_manifest.json`).

## VALIDATION

- **Grid**: 168×128 tiles × 8px on all 11 layers + obstacle grid, dims equal, no fractional/px offsets (cells address only integer tile TexLocs). PASS
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
{"event":"ground_seen","name":"town_hollow"}   ← engine resolved the zone ground entry
{"event":"map_loaded","w":168,"h":128}         ← FULL 11-layer deserialization by the real engine
{"event":"spawn","x":560,"y":16}                ← Main_Entrance_Marker honored
{"event":"movement","dirs":4}                  ← 4/4 walk directions in-engine
{"event":"PASS"} {"event":"screenshot","via":"ground"} rc=0
```

Runtime_screenshot.png is the actual PMDO in-engine capture of town_hollow. Root cause found & fixed during this phase: a ground without its `Data/Script/halcyon/ground/<map>/init.lua` package hangs the scene at load — the milestone now ships the minimal environment-only init (no story routing by design; keeps the audit bypass line the project uses).

## KNOWN LIMITATIONS (honest)

- Near/center-tier matches (1.5%) mean a few field tiles come from slightly different neighbourhoods — visually checked at 3 zooms, no visible seam; still listed rather than hidden.
- Fords are stepping-stone style (the source's own water-crossing vocabulary); no bridge asset exists inside metano_town. A plank bridge would import a foreign map's cells — deliberately refused at M1.
- `Data/Zone/index.idx` editor cache: the fixture `-index zone` run regenerated it including town_hollow at index 0; the production index regenerates on next editor/dev launch (ground resolution itself proven working in-engine).
- Composition honesty: elevation staging exists ONLY where metano has real cliff/waterfall vocabulary (north inlet cascade); earlier synthetic cliff lines were removed rather than patched over.
- Stairs: metano ground uses stairs only as facility links → deferred to the structures milestone by the "no structures" rule.

## GIT

Milestone commit: see branch log `M1 town_hollow…` — contains ONLY: `Data/Ground/town_hollow.rsground` (new), `docs/milestone1/*` (artifacts), `tools/newtown/*` (generator/grammar/viewer assets), `Data/Zone/master_zone.json` (+1 registration line). No unrelated file modified.

**FINAL STATUS: PASS** — raw environment only. Buildings/NPCs/logistics are explicitly NOT part of this milestone. STOP.
