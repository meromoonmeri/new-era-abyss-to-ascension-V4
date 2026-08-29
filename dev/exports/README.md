# Metano Town — Pixel Artist Package (GitHub Release)

**Date:** 2026-08-29
**Purpose:** Complete visual + technical reference for a pixel artist to create a PMD Red-style town in the style of **Metano Town**.
**Status:** Ready to download.

## How to download

This directory is pushed to GitHub at:
`https://github.com/meromoonmeri/new-era-abyss-to-ascension-V4/tree/arena/01a02f49-new-era-abyss-to-ascension-v4/dev/exports/`

Or directly:
- `metanol_brief/Metano_Brief_GoogleDoc_Package.zip` (33 MB) — full package
- `metanol_brief/MASTER_REFERENCE.png` (7.2 MB) — single mega-image
- `metanol_brief/Metano_Town_Brief.html` (6.1 MB) — open in browser, copy-paste to Google Docs
- `metanol_brief/Metano_Town_Brief.md` (29 KB) — Markdown source
- `metanol_renders/` (4.6 MB) — 13 individual PNG renders
- `metanol_atlases/` (11 MB) — 125 individual PNG tile sheets

## What's inside

1. **`metanol_brief/`** — Complete brief in multiple formats
   - `Metano_Brief_GoogleDoc_Package.zip` — full self-contained package (33 MB)
   - `MASTER_REFERENCE.png` — single image containing all renders + atlases (7.2 MB)
   - `Metano_Town_Brief.html` — HTML with all 138 images embedded (6.1 MB)
   - `Metano_Town_Brief.md` — Markdown source (29 KB, 18 sections)
   - `metano_renders_contact_sheet.png` — all 13 renders in one image
   - `metanol_atlases_contact_sheet.png` — all key tile sheets in one image
   - `README.md` — usage guide for Google Docs conversion

2. **`metanol_renders/`** — 13 PNG renders
   - `metano_town.png` (1.9 MB) — main town daytime
   - `metano_town_nuit.png` (2.0 MB) — main town night
   - `metanol_altere_transition.png`, `metanol_cafe.png`, `metanol_inn.png`, `metanol_cave.png`
   - 6 typed homes: `metano_fire_home.png`, `_water_home.png`, `_grass_home.png`, `_electric_home.png`, `_rock_home.png`, `_normal_home.png`
   - `treasure_spinda_cafe.png` (reference alternative)

3. **`metanol_atlases/`** — 125 PNG tile sheets (8×8 pixel cells, alpha-premultiplied)
   - Main town: Base/Cliffs/Objects/Animated/Fringe/River (day + night variants)
   - Café, Cave, Inn, 6 typed homes
   - Altere transition, Battle arena, Full battle, Raid
   - Each tile sheet is named after its `.tile` source file

## How to convert to Google Docs

See `metanol_brief/README.md` for 3 methods:
1. **Google Drive import** (recommended): Upload the ZIP to Drive, right-click → "Open with" → "Google Docs"
2. **Manual paste**: Open the HTML in a browser, Ctrl+A → Ctrl+C, paste into a new Google Doc
3. **API script**: `python3 tools/upload_to_google_doc.py --input Metano_Town_Brief.md`

## Quick technical summary

- **Engine:** PMDO 0.8.12 (RogueEssence)
- **Tile size:** 8×8 px
- **Main map:** 189×189 tiles = 1512×1512 px
- **Format:** .rsground (JSON) + .tile (binary) + .rsmap (entry) + .json (ZoneData) + Lua scripts
- **Color format:** RGBA with alpha pre-multiplication
- **Total sub-zones:** 12 (1 main + 1 night + 6 typed homes + café + cave + inn + transition)
- **Total NPCs in main town:** 12 (8 shopkeepers + 4 services)
- **Total ground objects:** 62
- **Total markers:** 38
- **Music:** Treasure Town.ogg (day), Goodnight.ogg (night), Spinda's Cafe.ogg (café)

## Tools to recreate or extend

```bash
# Decode a single .tile to PNG
python3 tools/decode_metano_tiles.py --sheet Content/Tile/Your_Sheet.tile

# Decode all Metano tiles
python3 tools/decode_metano_tiles.py --all

# Render a .rsground to PNG
python3 tools/render_metano_map.py --ground Data/Ground/your_ground.rsground

# Render all Metano grounds
python3 tools/render_metano_map.py --all

# Build contact sheets
python3 tools/make_metano_contact_sheet.py

# Upload to Google Docs
python3 tools/upload_to_google_doc.py --input Metano_Town_Brief.md
```

All tools are in `tools/`.
