#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
convert_red_all.py — Les 245 maps PMD Red avec TOUTES leurs animations.

Sources : pret/pmd-red (data/map_bg) + map_dependencies.json du port officiel
(PMD-RED-PMDO-PORT : triplets bpl/bpc/bma/bpa exacts pour chacune des 245 maps).

Animations natives PMD Red (ground_bg.c) :
  1. BPA  : tuiles animées (eau, lave, cascades…). Plusieurs slots possibles,
            CHAQUE slot a son propre compteur (numFrames, durationPerFrame).
  2. BPL  : animation de PALETTE (scintillement d'eau, braises, aurores…).
            Chaque palette i animée a (durationPerFrame, numFrames) et une
            table de numFrames×15 couleurs.
  3. BMA  : plusieurs couches (nL) possibles, composées dans l'ordre inverse
            (couche nL-1 = fond, couche 0 = dessus).

Rendu EXACT : par cellule, on rend sa propre période (lcm des périodes des
palettes utilisées + slots BPA utilisés), on compresse les ticks consécutifs
identiques en frames avec FrameLength = longueur de la série ; si les séries
sont inégales, repli EXACT par pas de g = pgcd des runs (1 image par pas de
g ticks, FL = g).

Sortie : RESERVE/red_grounds/<id>.rsground + RESERVE/red_tiles/<id>_Base.tile
+ RESERVE/red_manifest.json.

Usage : python3 tools/convert_red_all.py [--ids A,B] [--apply] [--serial]
"""
import glob
import hashlib
import io
import json
import math
import os
import struct
import sys
import time

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RED = '/tmp/pmd-red/data/map_bg'
PORT = '/tmp/pmdred-main'
OUT_G = os.path.join(ROOT, 'RESERVE', 'red_grounds')
OUT_T = os.path.join(ROOT, 'RESERVE', 'red_tiles')

XSTRIDE = 128


def lcm(a, b):
    return a * b // math.gcd(a, b) if a and b else (a or b)


def parse_bpl(p):
    """(palettes, specs, anim_pals) — specs seulement si hasPalAnimations."""
    d = open(p, 'rb').read()
    npal = struct.unpack_from('<h', d, 0)[0]
    has = struct.unpack_from('<h', d, 2)[0]
    palettes = []
    off = 4
    for _ in range(npal):
        cols = [(0, 0, 0, 0)]
        for c in range(15):
            cols.append((d[off], d[off + 1], d[off + 2], 255))
            off += 4
        palettes.append(cols)
    specs = [(0, 0)] * npal
    anim_pals = {}
    if has:
        try:
            for i in range(npal):
                dur, nf = struct.unpack_from('<hh', d, off)
                off += 4
                specs[i] = (dur, nf)
            for i, (dur, nf) in enumerate(specs):
                if nf > 0:
                    frs = []
                    for f in range(nf):
                        cols = [(0, 0, 0, 0)]
                        for c in range(15):
                            cols.append((d[off], d[off + 1], d[off + 2], 255))
                            off += 4
                        frs.append(cols)
                    anim_pals[i] = frs
        except struct.error:
            anim_pals = {}
    return palettes, specs, anim_pals


def parse_bpc(p):
    d = open(p, 'rb').read()
    cw, chh, nt = struct.unpack_from('<HHH', d, 0)
    nc, = struct.unpack_from('<H', d, 14)
    tiles = [bytes(32)] + [d[16 + i * 32:16 + (i + 1) * 32] for i in range(nt - 1)]
    off = 16 + (nt - 1) * 32
    n = cw * chh
    chunks = [[0] * n]
    for i in range(nc - 1):
        chunks.append(list(struct.unpack_from('<%dH' % n, d, off)))
        off += n * 2
    return cw, chh, tiles, chunks


def decode_bma(p):
    d = open(p, 'rb').read()
    Wt, Ht, tw, th, Wc, Hc = d[:6]
    nL, hD, hC = struct.unpack_from('<HhH', d, 6)
    src = 12
    STRIDE = 64
    layers = []
    for li in range(nL):
        dst = []
        for j in range(Hc):
            row = []
            prev = dst[(j - 1) * STRIDE:j * STRIDE] if j > 0 else [0] * STRIDE
            k = 0
            while k < Wc:
                cmd = d[src]
                src += 1
                if cmd >= 0xC0:
                    for l in range(cmd - 0xC0 + 1):
                        v = d[src] | (d[src + 1] << 8) | (d[src + 2] << 16)
                        src += 3
                        a, b = v & 0xFFF, (v >> 12) & 0xFFF
                        if j > 0 and len(row) < STRIDE:
                            a ^= prev[len(row)]
                            b ^= prev[len(row) + 1]
                        row += [a, b]
                    k += (cmd - 0xBF) * 2
                elif cmd >= 0x80:
                    v = d[src] | (d[src + 1] << 8) | (d[src + 2] << 16)
                    src += 3
                    for l in range(cmd - 0x80 + 1):
                        a, b = v & 0xFFF, (v >> 12) & 0xFFF
                        if j > 0 and len(row) < STRIDE:
                            a ^= prev[len(row)]
                            b ^= prev[len(row) + 1]
                        row += [a, b]
                    k += (cmd - 0x7F) * 2
                else:
                    for l in range(cmd + 1):
                        if j > 0 and len(row) < STRIDE:
                            row += [prev[len(row)], prev[len(row) + 1]]
                        else:
                            row += [0, 0]
                    k += (cmd + 1) * 2
            row = row[:STRIDE] + [0] * (STRIDE - len(row))
            dst += row
        layers.append(dst)
    return Wt, Ht, Wc, Hc, nL, layers


def parse_bpa(paths):
    """Tuiles BPA par fichier (ordre des slots VRAM). Chaque slot a SON
    compteur (ground_bg.c sub3E0Ptr) : nf, dur, frames."""
    slots = []
    for p in paths:
        d = open(p, 'rb').read()
        nt = d[0]
        nf = struct.unpack_from('<h', d, 2)[0]
        durs = list(struct.unpack_from('<%di' % nf, d, 4))
        off = 4 + nf * 4
        frs = []
        for f in range(nf):
            frs.append([d[off + (f * nt + k) * 32: off + (f * nt + k + 1) * 32]
                        for k in range(nt)])
        slots.append({'nt': nt, 'nf': nf, 'dur': durs[0] if durs else 0,
                      'frames': frs})
    return slots


def tile_image(td, pal, hf, vf):
    im = Image.new('RGBA', (8, 8), (0, 0, 0, 0))
    px = im.load()
    for y in range(8):
        for x in range(4):
            b = td[y * 4 + x]
            for k2, ci in enumerate((b & 0xF, b >> 4)):
                if ci == 0:
                    continue
                xx = x * 2 + k2
                yy = y
                if hf:
                    xx = 7 - xx
                if vf:
                    yy = 7 - yy
                px[xx, yy] = pal[ci]
    return im


class Renderer:
    def __init__(self, bpc_tiles, bpa_slots, palettes, anim_pals, specs, chunks):
        self.bpc_tiles = bpc_tiles
        self.bpa_slots = bpa_slots
        self.bpa_offsets = []
        off = len(bpc_tiles)
        for slot in bpa_slots:
            self.bpa_offsets.append(off)
            off += slot['nt']
        self.palettes = palettes
        self.anim_pals = anim_pals
        self.specs = specs
        self.chunks = chunks
        self.cache = {}

    def pal_at(self, pi, tick):
        if pi in self.anim_pals and self.specs[pi][0] > 0:
            dur, nf = self.specs[pi]
            return self.anim_pals[pi][(tick // dur) % nf]
        return self.palettes[pi % len(self.palettes)]

    def bpa_frame_at(self, slot_idx, tick):
        slot = self.bpa_slots[slot_idx]
        if slot['nf'] <= 1 or slot['dur'] <= 0:
            return 0
        return (tick // slot['dur']) % slot['nf']

    def tile(self, ti, pi, tick):
        bf = 0
        if ti >= len(self.bpc_tiles) and self.bpa_slots:
            for fidx, off in enumerate(self.bpa_offsets):
                if ti < off + self.bpa_slots[fidx]['nt']:
                    bf = self.bpa_frame_at(fidx, tick)
                    break
        key = (ti, pi, self.pal_frame_key(pi, tick), bf)
        im = self.cache.get(key)
        if im is not None:
            return im
        if ti < len(self.bpc_tiles):
            td = self.bpc_tiles[ti]
        elif self.bpa_slots:
            fidx = 0
            for f, off in enumerate(self.bpa_offsets):
                if ti < off + self.bpa_slots[f]['nt']:
                    fidx = f
                    break
            base = self.bpa_offsets[fidx]
            k = ti - base
            td = self.bpa_slots[fidx]['frames'][bf][k]
        else:
            td = bytes(32)
        pal = self.pal_at(pi, tick)
        im = tile_image(td, pal, False, False)
        if len(self.cache) < 400000:
            self.cache[key] = im
        return im

    def pal_frame_key(self, pi, tick):
        if pi in self.anim_pals and self.specs[pi][0] > 0:
            dur, nf = self.specs[pi]
            return (tick // dur) % nf
        return -1

    def chunk_cell(self, cids, tick, cw, chh):
        """Compose une cellule depuis TOUTES les couches BMA (cids par couche).
        Ordre : couche nL-1 d'abord (fond), couche 0 en dernier (dessus)."""
        cell = Image.new('RGBA', (cw * 8, chh * 8), (0, 0, 0, 0))
        for cid in reversed(cids):
            if not (0 < cid < len(self.chunks)):
                continue
            for i, ent in enumerate(self.chunks[cid]):
                ti = ent & 0x3FF
                hf = (ent >> 10) & 1
                vf = (ent >> 11) & 1
                pi = (ent >> 12) & 0xF
                if ti == 0:
                    continue
                tx, ty = (i % cw) * 8, (i // cw) * 8
                im = self.tile(ti, pi, tick)
                if hf or vf:
                    if hf:
                        im = im.transpose(Image.FLIP_LEFT_RIGHT)
                    if vf:
                        im = im.transpose(Image.FLIP_TOP_BOTTOM)
                cell.paste(im, (tx, ty), im)
        return cell


def minimal_period(seq, cap=512):
    n = len(seq)
    for p in range(1, min(n, cap + 1)):
        ok = all(seq[i] == seq[i % p] for i in range(n))
        if ok:
            return p
    return n


def opaque(cell):
    """Compose sur fond noir opaque (patron du port officiel : bg noir
    255 + alpha_composite) — les pixels vides deviennent (0,0,0,255)."""
    bg = Image.new('RGBA', cell.size, (0, 0, 0, 255))
    bg.alpha_composite(cell)
    return bg


def png_bytes(im):
    buf = io.BytesIO()
    im.save(buf, 'PNG', optimize=True)
    return buf.getvalue()


def write_tile(path, entries):
    uniq, order = {}, []
    for key, png in entries:
        if png not in uniq:
            uniq[png] = None
            order.append(png)
    header = 8 + len(entries) * 16
    offsets, pos = {}, header
    for h in order:
        offsets[h] = pos
        pos += 8 + len(h)
    out = bytearray()
    out += struct.pack('<II', 8, len(entries))
    for key, png in entries:
        out += struct.pack('<QQ', key, offsets[png])
    for h in order:
        out += struct.pack('<Q', len(h)) + h
    open(path, 'wb').write(bytes(out))


def convert(asset_id, bpl, bpc, bma, bpa_list, apply=True, dep_key=''):
    t0 = time.time()
    palettes, specs, anim_pals = parse_bpl(os.path.join(RED, bpl + '.bpl'))
    cw, chh, bpc_tiles, chunks = parse_bpc(os.path.join(RED, bpc + '.bpc'))
    Wt, Ht, Wc, Hc, nL, layers = decode_bma(os.path.join(RED, bma + '.bma'))
    bpa_slots = parse_bpa([os.path.join(RED, p + '.bpa') for p in bpa_list]) if bpa_list else []

    L = 1
    anim_desc = []
    for i, (dur, nf) in enumerate(specs):
        if nf > 0:
            L = lcm(L, dur * nf)
            anim_desc.append('P%d:%dx%d' % (i, dur, nf))
    bpa_dur = bpa_slots[0]['dur'] if bpa_slots else 0
    bpa_nf = bpa_slots[0]['nf'] if bpa_slots else 0
    if bpa_slots:
        for slot in bpa_slots:
            if slot['nf'] > 1 and slot['dur'] > 0:
                L = lcm(L, slot['dur'] * slot['nf'])
        anim_desc.append('BPA:%dt x %df x %d' % (sum(s['nt'] for s in bpa_slots), bpa_nf, bpa_dur))
    has_anim = L > 1 or bool(anim_desc)
    if not has_anim:
        L = 1

    renderer = Renderer(bpc_tiles, bpa_slots, palettes, anim_pals, specs, chunks)

    # --- cellules potentiellement animées (toutes couches) ---
    nt = len(bpc_tiles)
    anim_pal_set = set(anim_pals.keys())

    def cell_info(cids):
        per = 1
        uses_bpa = False
        pals = set()
        for cid in cids:
            if not (0 < cid < len(chunks)):
                continue
            for ent in chunks[cid]:
                ti = ent & 0x3FF
                pi = (ent >> 12) & 0xF
                if ti >= nt:
                    uses_bpa = True
                if pi in anim_pal_set:
                    pals.add(pi)
        if uses_bpa and bpa_slots:
            for slot in bpa_slots:
                if slot['nf'] > 1 and slot['dur'] > 0:
                    per = lcm(per, slot['dur'] * slot['nf'])
        for pi in pals:
            dur, nf = specs[pi]
            per = lcm(per, dur * nf)
        return bool(uses_bpa or pals), per

    n_cells = Wc * Hc
    cell_cids = [[layers[l][(ci // Wc) * 64 + ci % Wc] for l in range(nL)]
                 for ci in range(n_cells)]
    cell_infos = [cell_info(cids) for cids in cell_cids]

    # --- rendu PAR CELLULE à sa propre période, découpé en tuiles 8x8 ---
    # Chaque cellule (cw*8 x chh*8) est découpée en cw*chh tuiles 8x8, une
    # par position de GRILLE (tx,ty) — format exact du port officiel
    # (write_tile_file découpe l'image complète en tuiles 8x8, clés
    # (tx | ty<<32), chaque tuile de grille référence TexLoc (tx,ty)).
    entries = []       # (key, png) — PNG 8x8
    grid = [[None] * Ht for _ in range(Wt)]
    n_anim_cells = 0
    for y in range(Hc):
        for x in range(Wc):
            ci = y * Wc + x
            can_anim, per = cell_infos[ci]
            cids = cell_cids[ci]
            if not can_anim or per <= 1:
                cell_img = opaque(renderer.chunk_cell(cids, 0, cw, chh))
                for i in range(cw):
                    for j in range(chh):
                        tx, ty = x * cw + i, y * chh + j
                        if tx >= Wt or ty >= Ht:
                            continue
                        t8 = cell_img.crop((i * 8, j * 8, (i + 1) * 8, (j + 1) * 8))
                        png = png_bytes(t8)
                        entries.append((tx | (ty << 32), png))
                        grid[tx][ty] = {'AutoTileset': '', 'Associates': [],
                                        'NeighborCode': -1,
                                        'Layers': [{'Frames': [
                                            {'Sheet': asset_id + '_Base',
                                             'TexLoc': {'X': tx, 'Y': ty}}],
                                            'FrameLength': 60}]}
                continue
            n_anim_cells += 1
            seq = []
            imgs = []
            for t in range(per):
                img = opaque(renderer.chunk_cell(cids, t, cw, chh))
                imgs.append(img)
                seq.append(hashlib.md5(img.tobytes()).digest())
            p = minimal_period(seq)
            seq = seq[:p]
            imgs = imgs[:p]
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
                        t8 = imgs[t].crop((i * 8, j * 8, (i + 1) * 8, (j + 1) * 8))
                        png = png_bytes(t8)
                        entries.append(((tx + v * XSTRIDE) | (ty << 32), png))
                        frs.append({'Sheet': asset_id + '_Base',
                                    'TexLoc': {'X': tx + v * XSTRIDE, 'Y': ty}})
                    grid[tx][ty] = {'AutoTileset': '', 'Associates': [],
                                    'NeighborCode': -1,
                                    'Layers': [{'Frames': frs, 'FrameLength': fl}]}

    if not apply:
        return {'asset': asset_id, 'anim': has_anim, 'desc': anim_desc,
                'L': L, 'cells_animees': n_anim_cells, 'dims': (Wt, Ht),
                'time': time.time() - t0}

    write_tile(os.path.join(OUT_T, asset_id + '_Base.tile'), entries)

    # collision
    try:
        from skytemple_files.common.types.file_types import FileType
        bma_obj = FileType.BMA.deserialize(open(os.path.join(RED, bma + '.bma'), 'rb').read())
        coll = bma_obj.collision
        per_tile = coll is not None and len(coll) == Wt * Ht
    except Exception:
        coll, per_tile = None, False
    obstacles = []
    for x in range(Wt):
        col = []
        for y in range(Ht):
            blocked = False
            if coll is None:
                blocked = (x <= 0 or y <= 0 or x >= Wt - 1 or y >= Ht - 1)
            elif per_tile:
                blocked = bool(coll[y * Wt + x])
            else:
                cx, cy = x // 3, y // 3
                if cx < Wc and cy < Hc:
                    blocked = bool(coll[cy * Wc + cx])
            col.append({'Bounds': {'X': x * 8, 'Y': y * 8, 'Width': 8, 'Height': 8},
                        'Tags': 1 if blocked else 0})
        obstacles.append(col)

    entry = None
    for y in range(Ht // 2 - 2, Ht):
        for x in range(Wt // 2 - 2, Wt):
            if obstacles[x][y]['Tags'] == 0:
                entry = (x * 8 + 4, y * 8 + 4)
                break
        if entry:
            break
    if entry is None:
        entry = (Wt * 4, Ht * 4)

    doc = {
        'Version': '0.8.9.0',
        'Object': {
            '$type': 'RogueEssence.Ground.GroundMap, RogueEssence',
            'TexSize': 1,
            'Name': {'DefaultText': asset_id, 'LocalTexts': {}},
            'Released': True,
            'Comment': ('PMD Red (pret/pmd-red) — %s (%s). Rendu EXACT par tick '
                        '(%d ticks), BPA+palette animées incluses, collision BMA '
                        'source, sans overlay. Animations: %s' %
                        (dep_key, bpl, L, '; '.join(anim_desc) if anim_desc else 'aucune')),
            'obstacles': obstacles,
            'rand': {'$type': 'RogueElements.ReRandom, RogueElements', 's': [0, 0, 0, 0]},
            'Status': {},
            'Background': {'$type': 'RogueEssence.Dungeon.MapBG, RogueEssence',
                           'MapLoc': {'X': 0, 'Y': 0},
                           'BGAnim': {'AnimIndex': '', 'FrameTime': 1, 'StartFrame': -1,
                                      'EndFrame': -1, 'AnimDir': -1, 'Alpha': 255,
                                      'AnimFlip': 0},
                           'BGMovement': {'X': 0, 'Y': 0}, 'Parallax': '0, 0',
                           'RepeatX': False, 'RepeatY': False},
            'BlankBG': {'AutoTileset': '', 'Associates': [], 'Layers': [], 'NeighborCode': -1},
            'Layers': [{'Name': 'Base', 'Layer': 0, 'Visible': True, 'Tiles': grid}],
            'AssetName': asset_id,
            'Music': '',
            'EdgeView': 0, 'NoSwitching': False,
            'ViewCenter': None, 'ViewOffset': {'X': 0, 'Y': 0},
            'ActiveChar': None,
            'Decorations': [{'Name': 'New Deco', 'Layer': 0, 'Visible': True, 'Anims': []}],
            'Entities': [{'Name': 'New EntLayer', 'Visible': True,
                          'MapChars': [], 'GroundObjects': [], 'Spawners': [],
                          'Markers': [{'EntName': 'Main_Entrance_Marker',
                                       'Direction': 4, 'EntEnabled': True,
                                       'Collider': {'X': entry[0] - 8, 'Y': entry[1] - 8,
                                                    'Width': 16, 'Height': 16}}]}],
        },
    }
    with io.open(os.path.join(OUT_G, asset_id + '.rsground'), 'w', encoding='utf-8-sig') as f:
        json.dump(doc, f, ensure_ascii=False, separators=(',', ':'))

    return {'asset': asset_id, 'anim': has_anim, 'desc': anim_desc,
            'L': L, 'cells_animees': n_anim_cells, 'dims': (Wt, Ht),
            'time': time.time() - t0}


def _worker(job):
    key, v = job
    try:
        r = convert(v['bpl'].lower(), v['bpl'], v['bpc'], v['bma'], v.get('bpa') or [], True, key)
        return ('OK', r)
    except Exception as e:
        return ('ERR', (v['bpl'].lower(), str(e)[:120]))


def main():
    apply = '--apply' in sys.argv
    only = None
    if '--ids' in sys.argv:
        only = set(sys.argv[sys.argv.index('--ids') + 1].split(','))
    dep = json.load(open(os.path.join(PORT, 'map_dependencies.json')))
    jobs = [(key, v) for key, v in sorted(dep.items())
            if not only or v['bpl'].lower() in only]
    done = set(os.path.basename(f)[:-9] for f in glob.glob(os.path.join(OUT_G, '*.rsground')))
    jobs = [j for j in jobs if j[1]['bpl'].lower() not in done]
    print('à convertir:', len(jobs), flush=True)
    report = []
    ok = fail = 0
    if '--serial' in sys.argv:
        results = [_worker(j) for j in jobs]
    else:
        import multiprocessing as mp
        with mp.Pool(max(1, min(8, os.cpu_count() or 4))) as pool:
            results = pool.map(_worker, jobs, chunksize=1)
    for status, r in results:
        if status == 'OK':
            report.append(r)
            ok += 1
            print('OK  %-28s %-34s L=%4d anim=%s' % (
                r['asset'], (r['desc'][0][:32] if r['desc'] else '—'), r['L'], r['anim']), flush=True)
        else:
            print('ERR %-28s %s' % (r[0], r[1]), flush=True)
            fail += 1
    print('TERMINÉ : %d OK, %d échecs' % (ok, fail))
    json.dump(report, open(os.path.join(ROOT, 'RESERVE', 'red_manifest.json'), 'w'),
              indent=1, ensure_ascii=False)


if __name__ == '__main__':
    main()
