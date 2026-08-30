# PMDO / SkyTemple Map Renders & Quality Gate Manifest

This document indexes all validated PMD ground maps generated and verified via the **SkyTemple PMD Level Designer & Map Builder** pipeline.

---

## 1. Map Directory & Technical Matrix

| Map ID | Display Name | Grid (Cells) | PMD Tiles | Resolution | Layers | Connectivity | Visual Score | Status |
|---|---|---|---|---|---|---|---|---|
| `pixellab_altere_transition` | Altere Transition (Metano -> Altere Pond) | 64x38 | 21x12 | 1536x912 px | 5 | **100.0%** | **97.2/100** | **READY** |
| `pixellab_metano_sanctuary` | Metano Sanctuary (PixelLab Native) | 189x189 | 63x63 | 1512x1512 px | 11 | **100.0%** | **96.5/100** | **READY** |
| `skytemple_metano_outskirts` | Metano Outskirts (Clairière de Metano) | 189x189 | 63x63 | 1512x1512 px | 11 | **100.0%** | **95.9/100** | **READY** |
| `metano_waterfall_haven` | Metano Waterfall Haven | 192x192 | 64x64 | 1536x1536 px | 11 | **100.0%** | **97.7/100** | **READY** |
| `metano_town_recreated` | Metano Town (Recreated) | 189x189 | 63x63 | 1512x1512 px | 11 | **100.0%** | **97.5/100** | **READY** |

---

## 2. Quality Gate Workflow (Mandatory Standard)

Every map in the New Era project adheres strictly to the 8-stage Quality Gate:

1. **DISCOVERY**: Extracting source metrics, tilesets, and palette definitions using SkyTemple (`skytemple-files` / `skytemple-rust`).
2. **ANALYSIS**: Formalizing visual grammar (elevation tiers, cliff shadows, stair connections, natural waterways).
3. **DESIGN**: Priority to Ground & Terrain topology first (heightmap, cliffs, stairs, rivers, roads) before building placement.
4. **BUILD**: District zoning, clearance solver, structure footprints, and multi-frame animated assets (`.dir`).
5. **COLLISION**: Sub-cell 8x8 tagging ($3\times 3$ cells per PMD tile) with `Tags: 0` (Walkable) / `Tags: 1` (Blocked).
6. **RENDER**: Multi-pass rendering (`final.png`, `layout.png`, `elevation.png`, `cliffs.png`, `collision.png`, `navigation.png`).
7. **VALIDATION**: Automated pathfinding solver (BFS/A*) validating 100% reachability to all POIs, doors, and stairs.
8. **EXPORT**: Compiling native RogueEssence `.rsground` metadata, `.tile` atlas binaries, and Lua ground scripts.

---

## 3. Render Previews

### Altere Transition (`pixellab_altere_transition`)
- **Render Output**: `docs/pmu_maps/renders/pixellab_altere_transition/final.png`
- **Data Ground**: `Data/Ground/pixellab_altere_transition.rsground`
- **Tile Atlas**: `Content/Tile/pixellab_altere_transition_Base.tile`
- **Lua Script**: `Data/Script/halcyon/ground/pixellab_altere_transition/init.lua`

### Metano Outskirts (`skytemple_metano_outskirts`)
- **Render Output**: `docs/pmu_maps/renders/skytemple_metano_outskirts/final.png`
- **Data Ground**: `Data/Ground/skytemple_metano_outskirts.rsground`
- **Tile Atlas**: `Content/Tile/skytemple_metano_outskirts_Base.tile`
- **Lua Script**: `Data/Script/halcyon/ground/skytemple_metano_outskirts/init.lua`
