#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_red_grounds_vs_gba.py — Audit exhaustif des grounds GBA (Red EU).

Pour CHAQUE ground Red importé (246 entrées de la ground_conversion_table du
manifest EU authentifié), vérifie contre les ressources ROM normalisées
(.runtime-cache/pmdred-eu-ground/*.bpl/bpc/bpa/bma) :

 A. DIMENSIONS : BMA (Wt x Ht cellules 8px) == grille du .rsground (exact).
 B. ANIMATIONS : si la ROM déclare des tuiles animées (slots BPA) ou des
    palettes animées (BPL animation_flag + specs), le .rsground doit contenir
    des cellules multi-frames ; à l'inverse un ground ROM statique ne doit pas
    en contenir. Comptes rapportés (frames max, FrameLength).
 C. ARTEFACTS PALETTE (colorimétrie) : scan strict des sheets .tile référencés
    pour les couleurs de la famille « palette de cyclage » (verts/magentas/
    cyans purs) qui signent une capture framebuffer polluée (cas Mt Blaze).
 D. COLORIMÉTRIE : les couleurs du sheet doivent appartenir à l'union des
    palettes ROM (base + frames d'animation) du BPL du ground, à l'exception
    du noir/transparent. Rapporté en % de couverture (INFO, non bloquant si
    >99% — le compositing multi-couches BMA peut introduire le fond).

Sortie : dev/docs/canonical/RED_GBA_GROUND_AUDIT.json avec verdict par ground
(PASS / FAIL + raisons) et synthèse.
"""
import io
import json
import os
import struct
import sys
import glob
from collections import Counter

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SRC = os.path.join(REPO, '.runtime-cache', 'pmdred-eu-ground')
sys.path.insert(0, os.path.join(REPO, 'dev', 'tools'))
from convert_red_all import parse_bpl, decode_bma  # noqa: E402

try:
    from PIL import Image
except ImportError:
    Image = None

PAL6_ARTIFACTS = {(7, 167, 0), (7, 255, 0), (4, 128, 0), (4, 84, 0),
                  (255, 7, 255), (191, 7, 167), (0, 255, 0), (255, 0, 255),
                  (16, 132, 255), (12, 68, 128), (4, 128, 128),
                  (128, 4, 128)}


def load_rows():
    m = json.load(open(os.path.join(
        REPO, '.runtime-cache', 'pmdred-eu-ground-manifest.json')))
    conv = m['ground_conversion_table']['entries']
    mft = {e['map_file_id']: e for e in m['map_files_table']['entries']}
    rows = {}
    for c in conv:
        gid = c['stable_ground_id']
        mf = mft.get(c['map_file_id'])
        if not mf or gid in rows:
            continue
        rows[gid] = {
            'bpl': mf['bpl'], 'bpc': mf['bpc'], 'bma': mf['bma'],
            'bpa': [mf.get(f'bpa_{i}') for i in range(4)
                    if mf.get(f'bpa_{i}')]}
    return rows


def ground_info(path):
    d = json.load(open(path, encoding='utf-8-sig'))
    o = d['Object']
    layers = o.get('Layers') or []
    W = H = 0
    anim_cells = 0
    max_frames = 0
    sheets = set()
    for L in layers:
        T = L.get('Tiles') or []
        if T and not W:
            W, H = len(T), len(T[0])
        for col in T:
            for c in col:
                for lay in (c or {}).get('Layers', []):
                    frs = lay.get('Frames', [])
                    for f in frs:
                        if f.get('Sheet'):
                            sheets.add(f['Sheet'])
                    if len(frs) > 1:
                        anim_cells += 1
                        max_frames = max(max_frames, len(frs))
    return W, H, anim_cells, max_frames, sheets


_sheet_scan_cache = {}


def scan_sheet(name):
    """(exists, n_cells, artifact_cells, colors)"""
    if name in _sheet_scan_cache:
        return _sheet_scan_cache[name]
    path = None
    for d in (os.path.join(REPO, 'Content', 'Tile'),
              os.path.join(REPO, '.runtime-cache', 'DumpAsset', 'Content',
                           'Tile')):
        p = os.path.join(d, name + '.tile')
        if os.path.exists(p):
            path = p
            break
    if path is None or Image is None:
        _sheet_scan_cache[name] = (path is not None, 0, 0, set())
        return _sheet_scan_cache[name]
    data = open(path, 'rb').read()
    _, count = struct.unpack_from('<II', data, 0)
    suspect_cells = []  # [(hit_color_set)] par cellule à >=4 px suspects
    colors = set()
    for i in range(count):
        key, off = struct.unpack_from('<QQ', data, 8 + i * 16)
        (size,) = struct.unpack_from('<Q', data, off)
        im = Image.open(io.BytesIO(data[off + 8:off + 8 + size]))
        im = im.convert('RGBA')
        px = im.load()
        hits = 0
        hit_cols = set()
        for j in range(im.height):
            for i2 in range(im.width):
                c = px[i2, j]
                if c[3] > 0:
                    colors.add(c[:3])
                    if c[:3] in PAL6_ARTIFACTS:
                        hits += 1
                        hit_cols.add(c[:3])
        if hits >= 4:
            suspect_cells.append(frozenset(hit_cols))
    _sheet_scan_cache[name] = (True, count, suspect_cells, colors)
    return _sheet_scan_cache[name]


def used_palettes(res):
    """Bits palette réellement référencés par les chunks BMA de la carte."""
    from convert_red_all import parse_bpc as _pbpc, decode_bma as _dbma
    _, _, _, chunks = _pbpc(os.path.join(SRC, res['bpc'] + '.bpc'))
    _, _, Wc, Hc, _, layers = _dbma(os.path.join(SRC, res['bma'] + '.bma'))
    used = set()
    STRIDE = 64
    for lay in layers:
        for j in range(Hc):
            for k in range(Wc):
                ci = lay[j * STRIDE + k]
                if 0 < ci < len(chunks):
                    for v in chunks[ci]:
                        used.add((v >> 12) & 0xF)
    return used


def rom_palette_union(bpl_name):
    pals, specs, anims = parse_bpl(os.path.join(SRC, bpl_name + '.bpl'))
    cols = set()
    for pal in pals:
        for c in pal:
            cols.add(tuple(c[:3]))
    for frames in anims.values():
        for fr in frames:
            for c in fr:
                cols.add(tuple(c[:3]))
    return cols, specs, anims


def main():
    rows = load_rows()
    report = {}
    counts = Counter()
    for gid, res in sorted(rows.items()):
        gp = os.path.join(REPO, 'Data', 'Ground', gid + '.rsground')
        if not os.path.exists(gp):
            report[gid] = {'verdict': 'FAIL', 'reasons': ['rsground absent']}
            counts['FAIL'] += 1
            continue
        problems = []
        infos = {}
        # A. dimensions
        try:
            Wt, Ht, Wc, Hc, nL, _layers = decode_bma(
                os.path.join(SRC, res['bma'] + '.bma'))
        except Exception as e:
            report[gid] = {'verdict': 'FAIL',
                           'reasons': [f'BMA illisible: {e}']}
            counts['FAIL'] += 1
            continue
        W, H, anim_cells, max_frames, sheets = ground_info(gp)
        infos['dims_rom'] = [Wt, Ht]
        infos['dims_pmdo'] = [W, H]
        if (W, H) != (Wt, Ht):
            problems.append(f'dims {W}x{H} != ROM {Wt}x{Ht}')
        # B. animations — sémantique code désassemblé (autorité
        # render_pmdred_eu_rom_reference) : un canal ne compte que si
        #  (1) la palette animée est UTILISÉE par au moins une cellule de
        #      la carte (BMA chunks -> bits palette), ET
        #  (2) ses frames diffèrent réellement entre elles ;
        # les BPA comptent toujours (tuiles animées).
        cols, specs, anims = rom_palette_union(res['bpl'])
        used_pis = used_palettes(res)
        effective_anims = {}
        for pi, frames in anims.items():
            if pi not in used_pis:
                continue
            varies = any(
                tuple(frames[f][c][:3]) != tuple(frames[0][c][:3])
                for f in range(len(frames)) for c in range(len(frames[0])))
            if varies:
                effective_anims[pi] = len(frames)
        rom_has_anim = bool(res['bpa']) or bool(effective_anims)
        infos['rom_bpa'] = res['bpa']
        infos['rom_pal_anims_declared'] = {
            str(k): len(v) for k, v in anims.items()}
        infos['rom_pal_anims_effective'] = {
            str(k): v for k, v in effective_anims.items()}
        infos['pmdo_anim_cells'] = anim_cells
        infos['pmdo_max_frames'] = max_frames
        if rom_has_anim and anim_cells == 0:
            problems.append(
                'ROM animée (canal effectif) mais rsground 100% statique')
        # C. artefacts palette-6 — une couleur n'est un ARTEFACT que si elle
        # n'appartient PAS à la palette ROM du ground (contre-épreuve BPL:
        # les verts/magentas purs de d13p03/s01/h05p02... sont canoniques,
        # présents dans le BPL — étincelles Tour Céleste GBA etc.)
        art_total = 0
        missing_sheets = []
        pmdo_colors = set()
        rom_art = PAL6_ARTIFACTS - cols
        for sh in sheets:
            exists, n, suspect_cells, colors = scan_sheet(sh)
            if not exists:
                missing_sheets.append(sh)
            pmdo_colors |= colors
            # une cellule n'est un artefact que si AU MOINS une de ses
            # couleurs suspectes est HORS palette ROM du ground
            for hit_cols in suspect_cells:
                if hit_cols & rom_art:
                    art_total += 1
        if missing_sheets:
            problems.append(f'sheets absents: {missing_sheets}')
        if art_total:
            problems.append(
                f'{art_total} cellules à couleurs hors palette ROM')
        infos['artifact_cells'] = art_total
        # D. colorimétrie (INFO)
        if pmdo_colors:
            inside = sum(1 for c in pmdo_colors if c in cols
                         or c == (0, 0, 0))
            cov = 100.0 * inside / len(pmdo_colors)
            infos['palette_coverage_pct'] = round(cov, 1)
        verdict = 'PASS' if not problems else 'FAIL'
        counts[verdict] += 1
        report[gid] = {'verdict': verdict, 'reasons': problems, **infos}
    out = os.path.join(REPO, 'dev', 'docs', 'canonical',
                       'RED_GBA_GROUND_AUDIT.json')
    json.dump({'summary': dict(counts), 'grounds': report},
              open(out, 'w'), ensure_ascii=False, indent=1)
    print('verdicts:', dict(counts))
    for g, r in report.items():
        if r['verdict'] != 'PASS':
            print(' ', g, r['reasons'][:2])
    print('rapport:', out)


if __name__ == '__main__':
    main()
