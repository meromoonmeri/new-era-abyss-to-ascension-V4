# Metano District — complete measurements & new-map authoring guide

Auto-generated from the mod data (units: 1 tile = 8 px; character step = 16 px).

## 1. Ground dimensions (all Halcyon-scope maps)

| ground | grid (tiles) | size (px) | layers | solid % | npcs | objects | markers | music |
|---|---|---|---:|---:|---:|---:|---:|---|
| altere_pond | 116x96 | 928x768 | 8 | 14.1 | 1 | 2 | 2 | File Select.ogg |
| guild_bedroom_hallway | 60x32 | 480x256 | 4 | 58.0 | 0 | 6 | 11 | Wigglytuff's Guild.ogg |
| guild_bottom_left_bedroom | 44x44 | 352x352 | 6 | 13.7 | 0 | 1 | 1 | Wigglytuff's Guild.ogg |
| guild_bottom_right_bedroom | 44x44 | 352x352 | 6 | 16.7 | 0 | 4 | 1 | Wigglytuff's Guild.ogg |
| guild_dining_room | 56x36 | 448x288 | 7 | 13.7 | 0 | 14 | 13 | Wigglytuff's Guild.ogg |
| guild_first_floor | 40x30 | 320x240 | 2 | 54.9 | 0 | 2 | 4 | Wigglytuff's Guild.ogg |
| guild_guildmasters_room | 48x48 | 384x384 | 6 | 18.6 | 1 | 2 | 1 | Wigglytuff's Guild.ogg |
| guild_heros_room | 44x44 | 352x352 | 6 | 12.3 | 0 | 3 | 4 | Wigglytuff's Guild.ogg |
| guild_second_floor | 84x56 | 672x448 | 8 | 10.4 | 1 | 5 | 27 | Wigglytuff's Guild.ogg |
| guild_storage_hallway | 44x48 | 352x384 | 4 | 5.8 | 0 | 3 | 3 | Wigglytuff's Guild.ogg |
| guild_storage_room | 44x44 | 352x352 | 8 | 19.8 | 0 | 1 | 1 | Wigglytuff's Guild.ogg |
| guild_third_floor_lobby | 100x56 | 800x448 | 8 | 13.6 | 0 | 6 | 21 | Wigglytuff's Guild.ogg |
| guild_top_left_bedroom | 44x44 | 352x352 | 5 | 9.2 | 0 | 1 | 1 | Wigglytuff's Guild.ogg |
| guild_top_right_bedroom | 44x44 | 352x352 | 5 | 10.0 | 0 | 1 | 3 | Wigglytuff's Guild.ogg |
| illuminant_riverbed_entrance | 40x30 | 320x240 | 4 | 39.9 | 0 | 0 | 1 |  |
| ledian_dojo | 51x39 | 408x312 | 6 | 24.1 | 2 | 2 | 1 | Wigglytuff's Guild Remix.ogg |
| metano_altere_transition | 64x38 | 512x304 | 5 | 26.7 | 0 | 2 | 4 | Treasure Town.ogg |
| metano_cafe | 57x40 | 456x320 | 5 | 25.1 | 2 | 3 | 18 | Spinda's Cafe.ogg |
| metano_cave | 52x46 | 416x368 | 2 | 85.6 | 1 | 1 | 2 | Treasure Town.ogg |
| metano_electric_home | 43x34 | 344x272 | 2 | 25.6 | 0 | 1 | 2 | Treasure Town.ogg |
| metano_fire_home | 43x34 | 344x272 | 2 | 67.0 | 0 | 1 | 2 | Treasure Town.ogg |
| metano_grass_home | 46x35 | 368x280 | 2 | 25.7 | 0 | 1 | 2 | Treasure Town.ogg |
| metano_inn | 56x44 | 448x352 | 5 | 19.4 | 0 | 3 | 3 | Treasure Town.ogg |
| metano_normal_home | 45x35 | 360x280 | 2 | 14.8 | 0 | 1 | 2 | Treasure Town.ogg |
| metano_rock_home | 44x34 | 352x272 | 2 | 16.0 | 0 | 1 | 2 | Treasure Town.ogg |
| metano_town | 189x189 | 1512x1512 | 11 | 41.9 | 12 | 62 | 38 | Treasure Town.ogg |
| metano_water_home | 43x34 | 344x272 | 2 | 67.0 | 0 | 2 | 2 | Treasure Town.ogg |
| post_office | 48x39 | 384x312 | 1 | 80.3 | 2 | 3 | 5 | Treasure Town.ogg |
| relic_forest | 75x75 | 600x600 | 4 | 14.1 | 0 | 0 | 3 | In the Depths of the Pit.ogg |

## 2. Tileset sheets (.tile) — format facts per sheet

| sheet | tile px | index refs | distinct tiles | sample tile size |
|---|---:|---:|---:|---|
| Altere_Pond_Base | 8 | 11044 | 1239 | (8, 8)x400 |
| Altere_Pond_Cliffs | 8 | 1840 | 238 | (8, 8)x238 |
| Altere_Pond_Fringe | 8 | 2075 | 997 | (8, 8)x400 |
| Altere_Pond_Objects | 8 | 4601 | 1558 | (8, 8)x400 |
| Altere_Pond_Objects_Over | 8 | 144 | 144 | (8, 8)x144 |
| Altere_Pond_Objects_Under | 8 | 841 | 346 | (8, 8)x346 |
| Altere_Pond_River_Animations | 8 | 4236 | 1208 | (8, 8)x400 |
| Altere_Pond_Shadows | 8 | 56 | 45 | (8, 8)x45 |
| Metano_Town_Animation_Tileset | 8 | 4367 | 2083 | (8, 8)x400 |
| Guild_Bedroom_Hallway_Floor | 8 | 1920 | 62 | (8, 8)x62 |
| Guild_Bedroom_Hallway_Objects | 8 | 182 | 66 | (8, 8)x66 |
| Guild_Bedroom_Hallway_Supports | 8 | 940 | 144 | (8, 8)x144 |
| Guild_Bedroom_Hallway_Walls | 8 | 773 | 228 | (8, 8)x228 |
| Guild_Bottom_Left_Bedroom_Floor | 8 | 1936 | 58 | (8, 8)x58 |
| Guild_Bottom_Left_Bedroom_Objects | 8 | 219 | 136 | (8, 8)x136 |
| Guild_Bottom_Left_Bedroom_Objects_Over | 8 | 9 | 9 | (8, 8)x9 |
| Guild_Bottom_Left_Bedroom_Shadows | 8 | 46 | 44 | (8, 8)x44 |
| Guild_Bottom_Left_Bedroom_Supports | 8 | 1240 | 146 | (8, 8)x146 |
| Guild_Bottom_Left_Bedroom_Walls | 8 | 386 | 241 | (8, 8)x241 |
| Guild_Bottom_Right_Bedroom_Floor | 8 | 1936 | 44 | (8, 8)x44 |
| Guild_Bottom_Right_Bedroom_Objects | 8 | 234 | 160 | (8, 8)x160 |
| Guild_Bottom_Right_Bedroom_Shadows | 8 | 23 | 22 | (8, 8)x22 |
| Guild_Bottom_Right_Bedroom_Supports | 8 | 1240 | 146 | (8, 8)x146 |
| Guild_Bottom_Right_Bedroom_Walls | 8 | 385 | 241 | (8, 8)x241 |
| Guild_Dining_Room_Floor | 8 | 752 | 29 | (8, 8)x29 |
| Guild_Dining_Room_Fringe | 8 | 10 | 10 | (8, 8)x10 |
| Guild_Dining_Room_Objects | 8 | 440 | 194 | (8, 8)x194 |
| Guild_Dining_Room_Objects_Over | 8 | 196 | 157 | (8, 8)x157 |
| Guild_Dining_Room_Shadows | 8 | 49 | 41 | (8, 8)x41 |
| Guild_Dining_Room_Supports | 8 | 1144 | 153 | (8, 8)x153 |
| Guild_Dining_Room_Walls | 8 | 631 | 228 | (8, 8)x228 |
| Guild_First_Floor | 8 | 1200 | 908 | (8, 8)x400 |
| Guild_Guildmasters_Room_Floor | 8 | 1312 | 72 | (8, 8)x72 |
| Guild_Guildmasters_Room_Objects | 8 | 667 | 531 | (8, 8)x400 |
| Guild_Guildmasters_Room_Objects_Over | 8 | 82 | 81 | (8, 8)x81 |
| Guild_Guildmasters_Room_Shadows | 8 | 162 | 124 | (8, 8)x124 |
| Guild_Guildmasters_Room_Supports | 8 | 1012 | 193 | (8, 8)x193 |
| Guild_Guildmasters_Room_Walls | 8 | 548 | 298 | (8, 8)x298 |
| Guild_Heros_Room_Floor | 8 | 1936 | 53 | (8, 8)x53 |
| Guild_Heros_Room_Objects | 8 | 305 | 218 | (8, 8)x218 |
| Guild_Heros_Room_Objects_Over | 8 | 12 | 12 | (8, 8)x12 |
| Guild_Heros_Room_Shadows | 8 | 37 | 36 | (8, 8)x36 |
| Guild_Heros_Room_Supports | 8 | 1102 | 163 | (8, 8)x163 |
| Guild_Heros_Room_Walls | 8 | 538 | 272 | (8, 8)x272 |
| Guild_Second_Floor_Floor | 8 | 2464 | 44 | (8, 8)x44 |
| Guild_Second_Floor_Fringe | 8 | 9 | 9 | (8, 8)x9 |
| Guild_Second_Floor_Objects | 8 | 747 | 537 | (8, 8)x400 |
| Guild_Second_Floor_Objects_Over | 8 | 30 | 30 | (8, 8)x30 |
| Guild_Second_Floor_Objects_Under | 8 | 18 | 17 | (8, 8)x17 |
| Guild_Second_Floor_Shadows | 8 | 43 | 42 | (8, 8)x42 |
| Guild_Second_Floor_Supports | 8 | 2596 | 202 | (8, 8)x202 |
| Guild_Second_Floor_Walls | 8 | 987 | 367 | (8, 8)x367 |
| Guild_Storage_Hallway_Floor | 8 | 1408 | 29 | (8, 8)x29 |
| Guild_Storage_Hallway_Objects | 8 | 124 | 80 | (8, 8)x80 |
| Guild_Storage_Hallway_Supports | 8 | 1484 | 87 | (8, 8)x87 |
| Guild_Storage_Hallway_Walls | 8 | 560 | 225 | (8, 8)x225 |
| Guild_Storage_Room_Floor | 8 | 1936 | 44 | (8, 8)x44 |
| Guild_Storage_Room_Fringe | 8 | 24 | 16 | (8, 8)x16 |
| Guild_Storage_Room_Objects | 8 | 278 | 248 | (8, 8)x248 |
| Guild_Storage_Room_Objects_Over | 8 | 127 | 125 | (8, 8)x125 |
| Guild_Storage_Room_Objects_Under | 8 | 58 | 52 | (8, 8)x52 |
| Guild_Storage_Room_Shadows | 8 | 167 | 120 | (8, 8)x120 |
| Guild_Storage_Room_Supports | 8 | 1080 | 156 | (8, 8)x156 |
| Guild_Storage_Room_Walls | 8 | 530 | 228 | (8, 8)x228 |
| Guild_Third_Floor_Lobby_Floor | 8 | 2960 | 44 | (8, 8)x44 |
| Guild_Third_Floor_Lobby_Fringe | 8 | 31 | 31 | (8, 8)x31 |
| Guild_Third_Floor_Lobby_Objects | 8 | 780 | 487 | (8, 8)x400 |
| Guild_Third_Floor_Lobby_Objects_Over | 8 | 39 | 38 | (8, 8)x38 |
| Guild_Third_Floor_Lobby_Shadows | 8 | 68 | 59 | (8, 8)x59 |
| Guild_Third_Floor_Lobby_Supports | 8 | 2926 | 221 | (8, 8)x221 |
| Guild_Third_Floor_Lobby_Walls | 8 | 1395 | 380 | (8, 8)x380 |
| Guild_Top_Left_Bedroom_Floor | 8 | 1408 | 53 | (8, 8)x53 |
| Guild_Top_Left_Bedroom_Objects | 8 | 269 | 194 | (8, 8)x194 |
| Guild_Top_Left_Bedroom_Shadows | 8 | 41 | 37 | (8, 8)x37 |
| Guild_Top_Left_Bedroom_Supports | 8 | 1172 | 155 | (8, 8)x155 |
| Guild_Top_Left_Bedroom_Walls | 8 | 373 | 220 | (8, 8)x220 |
| Guild_Top_Right_Bedroom_Floor | 8 | 1936 | 66 | (8, 8)x66 |
| Guild_Top_Right_Bedroom_Objects | 8 | 272 | 179 | (8, 8)x179 |
| Guild_Top_Right_Bedroom_Shadows | 8 | 40 | 35 | (8, 8)x35 |
| Guild_Top_Right_Bedroom_Supports | 8 | 1172 | 155 | (8, 8)x155 |
| Guild_Top_Right_Bedroom_Walls | 8 | 373 | 220 | (8, 8)x220 |
| Illuminant_Riverbed_Base | 8 | 1002 | 238 | (8, 8)x238 |
| Illuminant_Riverbed_Objects | 8 | 543 | 325 | (8, 8)x325 |
| Illuminant_Riverbed_Objects_Under | 8 | 134 | 108 | (8, 8)x108 |
| Illuminant_Riverbed_River_Animations | 8 | 1248 | 536 | (8, 8)x400 |
| Ledian_Dojo_Animated | 8 | 114 | 83 | (8, 8)x83 |
| Ledian_Dojo_Ceiling | 8 | 1293 | 564 | (8, 8)x400 |
| Ledian_Dojo_Floor | 8 | 923 | 817 | (8, 8)x400 |
| Ledian_Dojo_Objects | 8 | 179 | 139 | (8, 8)x139 |
| Ledian_Dojo_Objects_Over | 8 | 46 | 45 | (8, 8)x45 |
| Ledian_Dojo_Objects_Under | 8 | 64 | 36 | (8, 8)x36 |
| Ledian_Dojo_Shadows | 8 | 105 | 72 | (8, 8)x72 |
| Metano_Altere_Transition_Base | 8 | 2248 | 454 | (8, 8)x400 |
| Metano_Altere_Transition_Objects | 8 | 1115 | 218 | (8, 8)x218 |
| Metano_Altere_Transition_Objects_Over | 8 | 228 | 76 | (8, 8)x76 |
| Metano_Altere_Transition_Objects_Under | 8 | 157 | 79 | (8, 8)x79 |
| Metano_Altere_Transition_River_Animations | 8 | 1112 | 458 | (8, 8)x400 |
| Metano_Town_Cafe_Base | 8 | 2280 | 598 | (8, 8)x400 |
| Metano_Town_Cafe_Objects | 8 | 629 | 477 | (8, 8)x400 |
| Metano_Town_Cafe_Objects_Fringe | 8 | 7 | 7 | (8, 8)x7 |
| Metano_Town_Cafe_Objects_Over | 8 | 148 | 132 | (8, 8)x132 |
| Metano_Town_Cafe_Objects_Under | 8 | 138 | 114 | (8, 8)x114 |
| Metano_Town_Cave_Base | 8 | 2392 | 970 | (8, 8)x400 |
| Metano_Town_Cave_Objects | 8 | 101 | 97 | (8, 8)x97 |
| Metano_Town_Electric_Home_Base | 8 | 1462 | 996 | (8, 8)x400 |
| Metano_Town_Electric_Home_Objects | 8 | 100 | 96 | (8, 8)x96 |
| Metano_Town_Fire_Home_Animated | 8 | 414 | 126 | (8, 8)x126 |
| Metano_Town_Fire_Home_Base | 8 | 1462 | 1093 | (8, 8)x400 |
| Metano_Town_Fire_Home_Objects | 8 | 74 | 60 | (8, 8)x60 |
| Metano_Town_Grass_Home_Base | 8 | 1610 | 1197 | (8, 8)x400 |
| Metano_Town_Grass_Home_Objects | 8 | 86 | 74 | (8, 8)x74 |
| Metano_Inn_Base | 8 | 2464 | 983 | (8, 8)x400 |
| Metano_Inn_Floor_Decor | 8 | 167 | 52 | (8, 8)x52 |
| Metano_Inn_Objects | 8 | 398 | 322 | (8, 8)x322 |
| Metano_Inn_Objects_Over | 8 | 69 | 60 | (8, 8)x60 |
| Metano_Inn_Shadows | 8 | 89 | 77 | (8, 8)x77 |
| Metano_Town_Normal_Home_Base | 8 | 1575 | 1059 | (8, 8)x400 |
| Metano_Town_Normal_Home_Objects | 8 | 98 | 98 | (8, 8)x98 |
| Metano_Town_Rock_Home_Base | 8 | 1496 | 1037 | (8, 8)x400 |
| Metano_Town_Rock_Home_Objects | 8 | 82 | 78 | (8, 8)x78 |
| Metano_Town_Animated | 8 | 2198 | 457 | (8, 8)x400 |
| Metano_Town_Animated_Under | 8 | 472 | 91 | (8, 8)x91 |
| Metano_Town_Base | 8 | 35646 | 3929 | (8, 8)x400 |
| Metano_Town_Cliffs | 8 | 2169 | 381 | (8, 8)x381 |
| Metano_Town_Fringe | 8 | 135 | 135 | (8, 8)x135 |
| Metano_Town_Objects | 8 | 16766 | 4008 | (8, 8)x400 |
| Metano_Town_Objects_Over | 8 | 233 | 213 | (8, 8)x213 |
| Metano_Town_Objects_Under | 8 | 1076 | 448 | (8, 8)x400 |
| Metano_Town_River_Animation_1 | 8 | 3204 | 771 | (8, 8)x400 |
| Metano_Town_River_Animation_2 | 8 | 3204 | 789 | (8, 8)x400 |
| Metano_Town_River_Animation_3 | 8 | 3204 | 800 | (8, 8)x400 |
| Metano_Town_River_Animation_4 | 8 | 3204 | 793 | (8, 8)x400 |
| Metano_Town_River_Sparkles | 8 | 128 | 60 | (8, 8)x60 |
| Metano_Town_Water_Home_Base | 8 | 1462 | 991 | (8, 8)x400 |
| Metano_Town_Water_Home_Base_Animated | 8 | 3423 | 896 | (8, 8)x400 |
| Metano_Town_Water_Home_Objects | 8 | 79 | 70 | (8, 8)x70 |
| PostOffice | 24 | 208 | 178 | (24, 24)x178 |
| Relic_Forest_Base | 8 | 5625 | 970 | (8, 8)x400 |
| Relic_Forest_Fringe | 8 | 79 | 79 | (8, 8)x79 |
| Relic_Forest_Objects | 8 | 3107 | 2581 | (8, 8)x400 |
| Relic_Forest_Objects_Under | 8 | 95 | 95 | (8, 8)x95 |

Sheets used across the district: **141**.

## 3. Layer stacks (draw order = array order)

- `altere_pond`: Base → River → Cliffs → Shadows → Objects Under → Objects → Objects Over → Fringe
- `guild_bedroom_hallway`: Floor → Walls → Objects → Supports
- `guild_bottom_left_bedroom`: Floor → Walls → Shadows → Objects → Objects Over → Supports
- `guild_bottom_right_bedroom`: Floor → Walls → Shadows → Objects → Objects Over → Supports
- `guild_dining_room`: Floor → Walls → Shadows → Objects → Objects Over → Fringe → Supports
- `guild_first_floor`: New Layer → Objects
- `guild_guildmasters_room`: Floor → Walls → Shadows → Objects → Objects Over → Supports
- `guild_heros_room`: Floor → Walls → Shadows → Objects → Objects Over → Supports
- `guild_second_floor`: Floor → Walls → Objects Under → Objects → Objects Over → Shadows → Fringe → Supports
- `guild_storage_hallway`: Floor → Walls → Objects → Supports
- `guild_storage_room`: Floor → Walls → Shadows → Objects Under → Objects → Objects Over → Fringe → Supports
- `guild_third_floor_lobby`: Floor → Walls → Shadows → Objects Under → Objects → Objects Over → Fringe → Supports
- `guild_top_left_bedroom`: Floors → Walls → Shadows → Objects → Supports
- `guild_top_right_bedroom`: Floor → Walls → Shadows → Objects → Supports
- `illuminant_riverbed_entrance`: Base → River → Objects Under → Objects
- `ledian_dojo`: Floor → Objects Under → Objects → Objects Over → Shadows → Ceiling
- `metano_altere_transition`: Layer 3 → River → Objects Under → Objects → Objects Over
- `metano_cafe`: Base → Objects Under → Objects → Objects Over → Fringe
- `metano_cave`: Base → Objects
- `metano_electric_home`: Base → Objects
- `metano_fire_home`: Base → Objects
- `metano_grass_home`: Base → Objects
- `metano_inn`: Base → Floor Decor → Shadows → Objects → Objects Over
- `metano_normal_home`: Base → Objects
- `metano_rock_home`: Base → Objects
- `metano_town`: Base → Cliffs → River → Layer 4 → Objects Under → Objects Under Anim → Objects → Objects Anim → Objects Over → Objects Over Anim → Fringe
- `metano_water_home`: Base → Objects
- `post_office`: New Layer
- `relic_forest`: Base → Objects Under → Objects → Fringe


## 5. Measured stats to imitate when sizing a new map

From `specs/ground_inventory.csv` (29 maps): interiors range 128x104 px (post office)
to 672x504 px (market); the town is 1512x1512 px; guild floors 320x240 → 800x448.
Solid ratio clusters at ~40–55 % for open circular rooms, ~13–25 % for halls with
wide floors. Practical targets for a new building:

- small shop/healer: 40x30 tiles (320x240 px), one Base + one Objects + Fringe
- medium interior (cafe/inn class): 56–72 x 40–50 tiles
- keep a 1-tile wall ring (8 px) and 1-tile Fringe band; door openings exactly
  2 tiles (16 px) wide — the character step is 16 px, narrower = soft-lock

## 6. New-map checklist (artist procedure)

1. **Canvas**: PNG at 8 px tile grid. Work flat (no lighting pass in tiles; the
   engine handles night via a separate `_Night` sheet clone).
2. **Palette**: reuse the district palettes (section 4). No new hues for
   roofs/paths; new tiles must read as part of the existing atlas.
3. **Sheets**: author one sheet per layer role: `MyMap_Base`, `MyMap_Objects`,
   `MyMap_Objects_Under`, `MyMap_Objects_Over`, `MyMap_Fringe` (8 px grid, RGBA,
   transparent = `Layers: []`). Pack with the project `.tile` layout
   (`specs/format_tile.md`); dedupe identical tiles like `Metano_Town_Base`
   (35 646 refs / 3 929 distinct).
4. **Ground JSON**: copy the smallest interior (`post_office` 16x13, or
   `metano_inn`) as skeleton: keep keys, replace `AssetName`, `Name`, `Music`,
   rebuild `Layers[].Tiles`, and regenerate `obstacles` from the art (solid under
   walls/furniture; `Tags` 0/1; bounds per cell in px).
5. **Entry points**: add markers `Main_Entrance_Marker`,
   `MyMap_Entrance_Marker_Partner` (16x16 collider, px coords) — markers ARE the
   entry-point names used by `GAME:EnterGroundMap`.
6. **Registration**: `Data/Ground/<id>.rsground` + name in
   `Data/Zone/master_zone.json → GroundMaps` + `index.idx` — all three or the
   engine crashes on load (project rule L5/L15).
7. **Validation loop before handoff**:
   `python3 tools/render_ground_png.py --ground-dir ... --tile-dir ... <id>` →
   check the PNG; run the connectivity guard (all markers reachable from entry,
   zero isolated walkable cells — see `tools/furnish_guild_hall.py` guards);
   confirm `Entities`/base untouched if editing an existing map.

## 7. Collision semantics (verified in-repo)

- `obstacles[x][y].Tags: 0` walkable / `1` solid; grid = same W×H as tiles
  (cell `Bounds` in px).
- Furniture placed on `Objects` layers must solidify exactly its drawn cells
  (30 furniture tiles → 30 solid cells in the guild hall case) — no over-solid,
  no walkable art.
- Night map must keep `obstacles` byte-identical to day (geometry clone rule).

## 8. What NOT to do (past incidents, do not repeat)

- do not rescale the atlas to 16 px "for detail" (breaks TexLoc addressing)
- do not hand-paint DTEF auto-tile borders (engine auto-codes neighbors)
- do not reformat the whole JSON editor-style when patching (diff floods; use
  indent=0 single-line objects as generated)
- do not create a second arena for a boss when a canonical final Ground exists
- do not add isolated walkable pockets behind props (the guild-hall basket case:
  a 3x3 prop at the wrong anchor isolated 4 cells → re-anchor, never ship)
