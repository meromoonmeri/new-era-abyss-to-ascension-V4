#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
regenerate_red_grounds.py — régénère les grounds PMD Red EN JEU (Data/Ground)
avec TOUTES les animations natives (BPA + palette + couches multiples), en
conservant entités, obstacles, marqueurs, musique, commentaire.

Usage : python3 tools/regenerate_red_grounds.py [--ids a,b] [--apply]
"""
import glob
import hashlib
import io
import json
import math
import os
import struct
import sys

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RED = '/tmp/pmd-red/data/map_bg'
sys.path.insert(0, os.path.join(ROOT, 'tools'))
from convert_red_all import (parse_bpl, parse_bpc, decode_bma, parse_bpa,
                             Renderer, png_bytes, write_tile, lcm, opaque)

XSTRIDE = 128

# ground en jeu -> (bpl, bpc, bma, [bpa...])
GROUNDS = {
    'a02p01': ('A02P01', 'A02P01c', 'A02P01m', []),
    'a02p02': ('A02P02', 'A02P02c', 'A02P02m', []),
    'a02p03': ('A02P03', 'A02P03c', 'A02P03m', []),
    'a02p04': ('A02P04', 'A02P04c', 'A02P04m', []),
    'a04p01': ('A04P01', 'A04P01c', 'A04P01m', ['A04P011']),
    'a05p03': ('A05P03', 'A05P03c', 'A05P03m', []),
    'arc_palier_celeste': ('D13P02', 'D13P02c', 'D13P02m', []),
    'arc_parvis_celeste': ('D13P01', 'D13P01c', 'D13P01m', []),
    'arc_tour_ciel_sommet': ('D13P03', 'D13P03c', 'D13P03m', []),
    'sinister_woods_clearing': ('D04P02', 'D04P02c', 'D04P02m', []),
    'gloomy_forest_entrance': ('D04P01', 'D04P01c', 'D04P01m', []),
    'd09p02': ('D09P02', 'D09P02c', 'D09P02m', []),
    'd09p03': ('D09P03', 'D09P03c', 'D09P03m', []),
    'd10p02': ('D10P02', 'D10P02c', 'D10P02m', []),
    'd10p03': ('D10P03', 'D10P03c', 'D10P03m', []),
    'd11p02': ('D11P02', 'D11P02c', 'D11P02m', []),
    'd11p03': ('D11P03', 'D11P03c', 'D11P03m', []),
    'foret_givree_oree': ('D10P01', 'D10P01c', 'D10P01m', []),
    'fosse_ardente': ('D12P04', 'D12P04c', 'D12P04m', []),
    'gloomy_forest_boss': ('D04P02', 'D04P02c', 'D04P02m', []),
    'gloomy_forest_entrance': ('D04P01', 'D04P01c', 'D04P01m', []),
    'gorge_ardente_coeur': ('D12P02', 'D12P02c', 'D12P02m', []),
    'gorge_ardente_porte': ('D12P01', 'D12P01c', 'D12P01m', []),
    'grotte_lazuli_fond': ('D08P02', 'D08P02c', 'D08P02m', []),
    'grotte_lazuli_seuil': ('D08P01', 'D08P01c', 'D08P01m', []),
    'mont_cendre_pied': ('D09P01', 'D09P01c', 'D09P01m', []),
    'mont_gele_pied': ('D11P01', 'D11P01c', 'D11P01m', []),
    'mount_windswept_guardian': ('D18P01', 'D18P01c', 'D18P01m', []),
    'palier_celeste': ('D13P02', 'D13P02c', 'D13P02m', []),
    'parvis_celeste': ('D13P01', 'D13P01c', 'D13P01m', []),
    'poisonous_forest_boss': ('H12P01', 'H12P01c', 'H12P01m', ['H12P011']),
    'pre_tonnerre': ('H17P01', 'H17P01c', 'H17P01m', []),
    'sanctuaire_voeu': ('D23P01', 'D23P01c', 'D23P01m', []),
    't01p01': ('T01P01', 'T01P01c', 'T01P01m', ['T01P011']),
    'tour_ciel_sommet': ('D13P03', 'D13P03c', 'D13P03m', []),
}


def minimal_period(seq, cap=512):
    n = len(seq)
    for p in range(1, min(n, cap + 1)):
        ok = all(seq[i] == seq[i % p] for i in range(n))
        if ok:
            return p
    return n


def regenerate(ground, apply=True):
    bpl_id, bpc_id, bma_id, bpa_list = GROUNDS[ground]
    gpath = os.path.join(ROOT, 'Data', 'Ground', ground + '.rsground')
    doc = json.load(open(gpath, encoding='utf-8-sig'))
    o = doc['Object']
    sheet = None
    for col in o['Layers'][0]['Tiles']:
        for t in col:
            for tl in t.get('Layers', []):
                for fr in tl.get('Frames', []):
                    if fr.get('Sheet'):
                        sheet = fr['Sheet']
                        break
                if sheet:
                    break
            if sheet:
                break
        if sheet:
            break
    if sheet is None:
        sheet = ground + '_Base'

    palettes, specs, anim_pals = parse_bpl(os.path.join(RED, bpl_id + '.bpl'))
    cw, chh, bpc_tiles, chunks = parse_bpc(os.path.join(RED, bpc_id + '.bpc'))
    Wt, Ht, Wc, Hc, nL, layers = decode_bma(os.path.join(RED, bma_id + '.bma'))
    bpa_slots = parse_bpa([os.path.join(RED, p + '.bpa') for p in bpa_list]) if bpa_list else []

    L = 1
    desc = []
    for i, (dur, nf) in enumerate(specs):
        if nf > 0:
            L = lcm(L, dur * nf)
            desc.append('P%d:%dx%d' % (i, dur, nf))
    bpa_nf = bpa_slots[0]['nf'] if bpa_slots else 0
    bpa_dur = bpa_slots[0]['dur'] if bpa_slots else 0
    if bpa_slots:
        for slot in bpa_slots:
            if slot['nf'] > 1 and slot['dur'] > 0:
                L = lcm(L, slot['dur'] * slot['nf'])
        desc.append('BPA:%dfx%d' % (bpa_nf, bpa_dur))

    renderer = Renderer(bpc_tiles, bpa_slots, palettes, anim_pals, specs, chunks)

    nt = len(bpc_tiles)
    anim_pal_set = set(anim_pals.keys())

    def may_anim(cids):
        for cid in cids:
            if not (0 < cid < len(chunks)):
                continue
            if bpa_slots and any((e & 0x3FF) >= nt for e in chunks[cid]):
                return True
            if anim_pal_set and any(((e >> 12) & 0xF) in anim_pal_set for e in chunks[cid]):
                return True
        return False

    n_cells = Wc * Hc
    cell_cids = [[layers[l][(ci // Wc) * 64 + ci % Wc] for l in range(nL)]
                 for ci in range(n_cells)]
    cell_anim = [may_anim(cids) for cids in cell_cids]

    # frames par tick (paresseux)
    cell_hashes = []
    static_imgs = {}
    for t in range(L):
        hs = []
        for ci in range(n_cells):
            if not cell_anim[ci]:
                if t == 0:
                    static_imgs[ci] = opaque(renderer.chunk_cell(cell_cids[ci], 0, cw, chh))
                hs.append(hashlib.md5(static_imgs[ci].tobytes()).digest())
            else:
                img = opaque(renderer.chunk_cell(cell_cids[ci], t, cw, chh))
                hs.append(hashlib.md5(img.tobytes()).digest())
        cell_hashes.append(hs)

    entries = []
    grid = [[None] * Ht for _ in range(Wt)]
    n_anim = 0
    for y in range(Hc):
        for x in range(Wc):
            ci = y * Wc + x
            seq = [cell_hashes[t][ci] for t in range(L)]
            if len(set(seq)) == 1:
                img = static_imgs.get(ci)
                if img is None:
                    img = opaque(renderer.chunk_cell(cell_cids[ci], 0, cw, chh))
                for i in range(cw):
                    for j in range(chh):
                        tx, ty = x * cw + i, y * chh + j
                        if tx >= Wt or ty >= Ht:
                            continue
                        t8 = img.crop((i * 8, j * 8, (i + 1) * 8, (j + 1) * 8))
                        png = png_bytes(t8)
                        entries.append((tx | (ty << 32), png))
                        grid[tx][ty] = {'AutoTileset': '', 'Associates': [],
                                        'NeighborCode': -1,
                                        'Layers': [{'Frames': [
                                            {'Sheet': sheet, 'TexLoc': {'X': tx, 'Y': ty}}],
                                            'FrameLength': 60}]}
            else:
                n_anim += 1
                p = minimal_period(seq)
                groups = []
                prev_h, cnt = seq[0], 1
                for t in range(1, p):
                    if seq[t] == prev_h:
                        cnt += 1
                    else:
                        groups.append((prev_h, cnt))
                        prev_h, cnt = seq[t], 1
                groups.append((prev_h, cnt))
                uniform = len({c for _, c in groups}) == 1
                if uniform:
                    fl = groups[0][1]
                    ticks = []
                    tick = 0
                    for v, (h, c) in enumerate(groups):
                        ticks.append(tick)
                        tick += c
                else:
                    g = 0
                    for _, c in groups:
                        g = math.gcd(g, c)
                    if g <= 0:
                        g = 1
                    fl = g
                    ticks = [k * g for k in range(p // g)]
                for i in range(cw):
                    for j in range(chh):
                        tx, ty = x * cw + i, y * chh + j
                        if tx >= Wt or ty >= Ht:
                            continue
                        frs = []
                        for v, t in enumerate(ticks):
                            img = opaque(renderer.chunk_cell(cell_cids[ci], t, cw, chh))
                            t8 = img.crop((i * 8, j * 8, (i + 1) * 8, (j + 1) * 8))
                            png = png_bytes(t8)
                            entries.append(((tx + v * XSTRIDE) | (ty << 32), png))
                            frs.append({'Sheet': sheet,
                                        'TexLoc': {'X': tx + v * XSTRIDE, 'Y': ty}})
                        grid[tx][ty] = {'AutoTileset': '', 'Associates': [],
                                        'NeighborCode': -1,
                                        'Layers': [{'Frames': frs, 'FrameLength': fl}]}

    if not apply:
        return {'ground': ground, 'L': L, 'desc': desc, 'anim_cells': n_anim}

    write_tile(os.path.join(ROOT, 'Content', 'Tile', sheet + '.tile'), entries)
    o['Layers'] = [{'Name': 'Base', 'Layer': 0, 'Visible': True, 'Tiles': grid}]
    o['Comment'] = (o.get('Comment', '').split(' | ANIMÉ')[0] +
                    ' | ANIMÉ (BPA+palette, %d ticks : %s).' % (L, '; '.join(desc) if desc else '—'))
    with io.open(gpath, 'w', encoding='utf-8-sig') as f:
        json.dump(doc, f, ensure_ascii=False, separators=(',', ':'))
    return {'ground': ground, 'L': L, 'desc': desc, 'anim_cells': n_anim, 'sheet': sheet}


def main():
    apply = '--apply' in sys.argv
    only = None
    if '--ids' in sys.argv:
        only = set(sys.argv[sys.argv.index('--ids') + 1].split(','))
    for g in sorted(GROUNDS):
        if only and g not in only:
            continue
        try:
            r = regenerate(g, apply)
            print('%-26s L=%4d anim_cells=%-5d %s' % (
                g, r['L'], r['anim_cells'], '; '.join(r['desc']) if r['desc'] else '—'), flush=True)
        except Exception as e:
            import traceback
            print('ERR %-26s %s' % (g, str(e)[:120]))
            traceback.print_exc()


if __name__ == '__main__':
    main()
