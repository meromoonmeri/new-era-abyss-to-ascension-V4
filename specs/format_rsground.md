# PMDO `.rsground` format — artist-facing notes

Source: reverse-engineered and round-trip-verified in the New Era project
(`docs/metano_nuit.md`, `tools/furnish_guild_hall.py` guards).

A ground map is one JSON document, **UTF-8 with BOM**, serialized by
Newtonsoft (`indent=0`, one key per line). Top level:

```json
{ "Version": "0.8.12.0", "Object": {
    "$type": "RogueEssence.Ground.GroundMap, RogueEssence",
    "TexSize": 1, "Name": {...}, "Music": "...ogg", "obstacles": [...],
    "Layers": [...], "Decorations": [...], "Entities": [...], "EdgeView": 1, ...
} }
```

## Units

- **1 tile = 8×8 px.** A 189×189-tile map = 1512×1512 px (Metano Town).
- Character footprint = 16 px = 2×2 tiles; walking steps are 16 px.
- Entity `Collider` / `serializationLoc` are in **pixels**.
- `obstacles` grid = same W×H as the layer tiles; each cell `{"Bounds": px rect, "Tags": N}`,
  `Tags: 0` walkable, `Tags: 1` solid.

## Layers

`Layers` is an ordered list (draw order). Metano Town uses 11:
`Base, Cliffs, River, Layer 4, Objects Under, Objects Under Anim, Objects,
Objects Anim, Objects Over, Objects Over Anim, Fringe`.
Interiors usually have 5–8 (Base/Objects Under/Objects/Objects Over/Fringe …).

Each layer holds a full W×H tile grid. A tile:

```json
{"AutoTileset": "", "Associates": [],
 "Layers": [{"Frames": [{"Sheet": "Metano_Town_Base", "TexLoc": {"X": 12, "Y": 3}}],
             "FrameLength": 60}],
 "NeighborCode": -1}
```

- Empty tile = `"Layers": []`.
- `TexLoc` is in **tile coordinates (8 px)** inside the named sheet.
- Animation = more entries in `Frames` and a `FrameLength` in ticks (60 fps engine).
- Sheets are referenced **by name**, per frame — a layer may mix sheets.

## Entities

Single entity layer with four lists:

- `MapChars` — full serialized `Character` objects (species via `CurrentForm`,
  `movementSpeed`, `AIEnabled`); wandering NPCs use these.
- `GroundObjects` — interactable/triggers (`EntName`, `Collider`, optional `ObjAnim`).
- `Markers` — named 16×16 points; **ground entry points are markers**
  (`Main_Entrance_Marker`, plus `<Building>_Entrance_Marker` and a `_Partner` twin).
- `Spawners` — runtime party spawns (`NPCName: "Teammate1"` for the partner).

## Editing rules that keep the engine happy

1. Edit only what you need to add; **never reformat** unrelated content
   (the whole file is one parse; a stray re-flow makes 75k-line diffs).
2. `Entities` and untouched layers must stay byte-identical (guard used in
   `tools/furnish_guild_hall.py`).
3. Collision must match visuals: solidify exactly the cells under solid
   furniture, then re-check connectivity (all markers reachable, no isolated
   walkable cells).
4. Night variants are **geometry clones** of the day map (same `obstacles`,
   same tile positions) — only sheets differ (`*_Night` suffix).
5. A ground is loadable only when: file exists in `Data/Ground/`, its name is
   in the zone's `GroundMaps`, and `Data/Zone/index.idx` is consistent.
