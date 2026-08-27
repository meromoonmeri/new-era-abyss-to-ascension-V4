#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_fixed_arenas_vs_rom.py — Comparaison cellule-par-cellule des
arènes boss .rsmap vs les sources ROM.

SKY : BALANCE/fixed.bin EU (skytemple FIXED_BIN) — chaque action est
classée en terrain {floor, wall, secondary} : FLOOR_* -> floor,
WALL_* -> wall/unbreakable, SECONDARY_* -> water(secondary),
EntityRule/LEADER/ATTENDANT*/spawns -> floor (une entité repose sur du
sol). Comparaison aux Tiles[x][y].Data.ID du rsmap (floor/wall/
unbreakable/water) : wall==unbreakable équivalents (choix moteur PMDO,
les bords des salles fixes sont infranchissables dans la ROM aussi).

RED : data/dungeon/fixedmap.inc pret (RLE décodé, même décodeur que
red_build_gba_fixed_arenas.py) — actions 0/9/11/15=sol, 1/2/13/14=mur,
4=spawn joueur(sol), 5/6=secondaire, 8=escalier(sol), >=16 entités(sol),
0x3c/0x42 sols d'entité vides.

Sortie : dev/docs/canonical/FIXED_ARENA_VS_ROM_AUDIT.json + verdict par
arène (dims + % cellules identiques + liste des divergences).
"""
import glob
import json
import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
PRET = os.path.join(REPO, ".runtime-cache", "pmd-red-reference")
SKY_ROM = glob.glob(os.path.join(
    REPO, ".runtime-cache", "sky-rom", "*.nds"))[0]


def sky_fixed_floors():
    from ndspy.rom import NintendoDSRom
    from skytemple_files.common.types.file_types import FileType
    rom = NintendoDSRom.fromFile(SKY_ROM)
    return FileType.FIXED_BIN.deserialize(
        rom.getFileByName('BALANCE/fixed.bin')).fixed_floors


def sky_terrain(action):
    """action fixed.bin -> classe terrain attendue."""
    tn = type(action).__name__
    if tn == 'EntityRule':
        return 'floor'
    name = action.tr_type.name if hasattr(action.tr_type, 'name') \
        else str(action.tr_type)
    if name.startswith('FLOOR') or 'SPAWN' in name or 'STAIRS' in name \
            or name.startswith('LEADER') or name.startswith('ATTENDANT') \
            or 'ITEM' in name or 'TRAP' in name or 'ENEMY' in name \
            or 'WARP_ZONE' in name:
        return 'floor'
    if name.startswith('WALL'):
        return 'wall'
    if name.startswith('SECONDARY') or name.startswith('CHASM') \
            or 'VOID' in name:
        return 'secondary'
    return 'floor'  # défaut prudent, signalé si divergence


def red_decode(idx):
    txt = open(os.path.join(PRET, "data", "dungeon", "fixedmap.inc")).read()
    ptrs = re.findall(r"^\.4byte (gUnknown_\w+)$",
                      txt.split("gUnknown_84A03BC:")[1], re.M)
    label = ptrs[idx]
    m = re.search(rf"\.global {label}\n{label}:\n((?:\.byte [^\n]+\n)+)",
                  txt)
    bs = []
    for line in m.group(1).splitlines():
        bs += [int(x, 16) for x in re.findall(r"0x([0-9a-fA-F]{2})", line)]
    w, h = bs[0], bs[1]
    data = bs[3:]
    out = []
    i = 0
    while len(out) < w * h and i < len(data):
        b = data[i]
        i += 1
        if b == 0x0E:
            out.append(data[i])
            i += 1
        else:
            out += [(b & 0xF0) >> 4] * ((b & 0x0F) + 1)
    return w, h, [out[r * w:(r + 1) * w] for r in range(h)]


def red_terrain(v):
    if v in (1, 2, 13, 14):
        return 'wall'
    if v in (5, 6, 0x42):
        return 'secondary'
    return 'floor'  # 0/9/11/15 sol, 4 joueur, 8 escalier, entités >=16


def rsmap_terrain_grid(path):
    d = json.load(open(path, encoding='utf-8-sig'))
    T = d['Object'].get('Tiles') or []
    W, H = len(T), (len(T[0]) if T else 0)
    grid = []
    for x in range(W):
        col = []
        for y in range(H):
            tid = (T[x][y].get('Data') or {}).get('ID', '')
            if tid in ('wall', 'unbreakable'):
                col.append('wall')
            elif tid in ('water', 'pit', 'lava', 'water_poison'):
                col.append('secondary')
            else:
                col.append('floor')
        grid.append(col)
    return W, H, grid


def compare(rom_w, rom_h, rom_grid_rows, map_path):
    """rom_grid_rows: [h][w] classes ; rsmap: [W][H]."""
    W, H, mg = rsmap_terrain_grid(map_path)
    rep = {"rom_dims": [rom_w, rom_h], "rsmap_dims": [W, H]}
    if (W, H) != (rom_w, rom_h):
        rep["verdict"] = "DIM_MISMATCH"
        return rep
    diffs = []
    total = rom_w * rom_h
    for y in range(rom_h):
        for x in range(rom_w):
            want = rom_grid_rows[y][x]
            got = mg[x][y]
            if want != got:
                diffs.append({"x": x, "y": y, "rom": want, "pmdo": got})
    rep["cells"] = total
    rep["identical"] = total - len(diffs)
    rep["diff_count"] = len(diffs)
    rep["diffs_sample"] = diffs[:20]
    rep["verdict"] = "PASS" if not diffs else (
        "PASS_MINOR" if len(diffs) <= max(2, total // 100) else "FAIL")
    return rep


def main():
    report = {}
    ffs = sky_fixed_floors()
    # rsmap -> fixed floor id (depuis les Comments)
    for p in sorted(glob.glob(os.path.join(REPO, 'Data', 'Map',
                                           '*.rsmap'))):
        d = json.load(open(p, encoding='utf-8-sig'))
        cmt = d['Object'].get('Comment') or ''
        name = os.path.basename(p)[:-6]
        m = re.search(r'fixed floor (\d+)', cmt)
        m2 = re.search(r'fixed room (\d+)', cmt)
        if m:
            ffid = int(m.group(1))
            ff = ffs[ffid]
            rows = []
            for y in range(ff.height):
                rows.append([sky_terrain(ff.actions[y * ff.width + x])
                             for x in range(ff.width)])
            rep = compare(ff.width, ff.height, rows, p)
            rep["source"] = f"sky fixed.bin ff{ffid}"
            report[name] = rep
        elif m2:
            frid = int(m2.group(1))
            w, h, rows_v = red_decode(frid)
            rows = [[red_terrain(v) for v in row] for row in rows_v]
            rep = compare(w, h, rows, p)
            rep["source"] = f"red fixedmap.inc fr{frid}"
            report[name] = rep

    counts = {}
    for r in report.values():
        counts[r["verdict"]] = counts.get(r["verdict"], 0) + 1
    out = os.path.join(REPO, 'dev', 'docs', 'canonical',
                       'FIXED_ARENA_VS_ROM_AUDIT.json')
    json.dump({"summary": counts, "arenas": report}, open(out, 'w'),
              ensure_ascii=False, indent=1)
    print("verdicts:", counts)
    for n, r in sorted(report.items()):
        if r["verdict"] != "PASS":
            print(" ", n, r["verdict"], r.get("rom_dims"),
                  r.get("rsmap_dims"), "diffs:", r.get("diff_count"))
    print("rapport:", out)


if __name__ == '__main__':
    main()
