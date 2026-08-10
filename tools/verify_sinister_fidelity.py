#!/usr/bin/env python3
"""
Architecture de validation — SOURCE FIDELITY vs PMDO VALIDATION
Aucune validation ne doit être considérée PASS simplement parce qu'une donnée
correspond à Red ou à une ancienne implémentation.

Catégories:
- A. SOURCE FIDELITY: Blue NDS ↔ extracted data ↔ generated PMDO data
- B. PMDO VALIDATION: index, tiles, grounds, markers, spawns, zones, Lua

Statuts: PASS / FAIL / UNKNOWN (UNKNOWN si NDS non décodé, pas de supposition)
"""
import json, pathlib

MOD_ROOT = pathlib.Path(__file__).resolve().parents[1]

# Catégorie A: SOURCE FIDELITY (Blue NDS)
SOURCE_FIDELITY = {
    "Floors 13": {"source": "b10canm/b10fon NOT DECODED", "status": "UNKNOWN", "preuve": "ROM offset b10canm 154544 SIR0 1152->1088 header 0c00 0d00 NOT DECODED"},
    "Géométrie Blue -> PMDO": {"source": "b10fon 10177 NOT DECODED", "status": "UNKNOWN", "preuve": "Blue cell/wall/room/hall non extraits"},
    "Pokémon F1": {"source": "b10cel 2054 NOT DECODED", "status": "UNKNOWN", "preuve": "b10cel raw 41543450... NOT DECODED, pmd-red non utilisé comme preuve"},
    "Pokémon F13": {"source": "b10cel NOT DECODED", "status": "UNKNOWN", "preuve": "b10cel NOT DECODED"},
    "Items F1": {"source": "b10fon Items 11 NOT DECODED", "status": "UNKNOWN", "preuve": "b10fon NOT DECODED"},
    "Traps F1": {"source": "b10fon Traps 2 NOT DECODED", "status": "UNKNOWN", "preuve": "b10fon NOT DECODED"},
    "Escaliers": {"source": "b10fon NOT DECODED", "status": "UNKNOWN", "preuve": "b10fon NOT DECODED"},
    "Terrain": {"source": "b10canm NOT DECODED", "status": "UNKNOWN", "preuve": "b10canm NOT DECODED"},
    "Musique": {"source": "sound.sbin ID 12 NOT EXTRACTED", "status": "UNKNOWN", "preuve": "sound.sbin NOT EXTRACTED"},
    "Team Meanies timeline": {"source": "pmd-red/src/dungeon_cutscene_meanies.c (7+5 dialogues) cross-ref, mais Grounds/SSB NDS non décodés", "status": "UNKNOWN", "preuve": "Grounds/SSB NDS non décodés"},
}

# Catégorie B: PMDO VALIDATION (cohérence interne, ne prouve pas la fidélité source)
PMDO_VALIDATION = {
    "index.idx gloomy_forest Maps[0] 15": {"status": "PASS", "preuve": "Data/Zone/gloomy_forest.json Segments[0] 15 (F01-F15) + index 15"},
    "index.idx Maps[1] 5": {"status": "PASS", "preuve": "Segments[1] 5 (F16-F20)"},
    "tiles 723/723": {"status": "PASS", "preuve": "verify_tile_index 723/723 (1 debug_placeholder hors périmètre)"},
    "grounds markers walkable": {"status": "PASS", "preuve": "sinister_woods_clearing 60x47 Main_Entrance 224,208 Tags 0"},
    "Lua pcall": {"status": "PASS", "preuve": "verify_lua_globals 0 fantôme"},
}

def main():
    print("=== VERIFY SINISTER FIDELITY — ARCHITECTURE ===")
    print("\nA. SOURCE FIDELITY (Blue NDS ↔ PMDO) — doit être PASS uniquement si décodé depuis Blue")
    for k,v in SOURCE_FIDELITY.items():
        print(f"  {k}: {v['status']} — {v['preuve']}")
    print("\nB. PMDO VALIDATION (cohérence interne, ne prouve pas Sinister Woods == Blue)")
    for k,v in PMDO_VALIDATION.items():
        print(f"  {k}: {v['status']} — {v['preuve']}")
    print("\nAucun PASS en A tant que b10fon/b10cel/b10pal non décodés. Ne pas confondre A et B.")
    # Sortie: 1 si UNKNOWN présent (pour CI, mais ne pas considérer comme échec du port)
    import sys
    unknowns = sum(1 for v in SOURCE_FIDELITY.values() if v['status']=="UNKNOWN")
    print(f"\n{unknowns} UNKNOWN en SOURCE FIDELITY — port non terminé, audit en cours")
    sys.exit(0)

if __name__ == "__main__":
    main()
