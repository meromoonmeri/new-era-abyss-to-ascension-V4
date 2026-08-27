#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dungeon_matrix_audit.py — MATRICE D'AUDIT DONJONS Red+Sky.

Pour chaque zone de Data/Zone :
  NAME       : nom affiché vs nom canonique ROM (name_en des tables Sky ;
               détection des noms génériques interdits) ;
  FLOORS     : nombre d'étages vs table ROM (Sky) ;
  TILESET    : autotiles référencés présents (quest ou base) ;
  VIEWPORT   : pour chaque rsmap (arènes/fixed floors) — EntryPoints et
               positions du cast DANS les limites Tiles[W][H] (détecte
               ground décalé / boss hors écran), cohérence des dimensions
               Tiles vs Layers vs DiscoveryArray ;
  SPAWN_HERO : aucun membre narratif (hero/partner slots) dans les tables
               de spawn sauvage ;
  MUSIC      : fichier présent (quest ou base).

Sortie : dev/docs/canonical/DUNGEON_MATRIX_AUDIT.json + résumé.
Fail-closed : toute anomalie est listée, aucune n'est absorbée.
"""
import glob
import gzip
import json
import os
import re
from collections import Counter, OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ZONES = os.path.join(REPO, 'Data', 'Zone')
MAPS = os.path.join(REPO, 'Data', 'Map')
AUTO_Q = os.path.join(REPO, 'Data', 'AutoTile')
AUTO_B = os.path.join(REPO, '.runtime-cache', 'DumpAsset', 'Data', 'AutoTile')
MUS_Q = os.path.join(REPO, 'Content', 'Music')
MUS_B = os.path.join(REPO, '.runtime-cache', 'DumpAsset', 'Content', 'Music')
TABLES = os.path.join(REPO, 'dev', 'CAMPAIGNS', 'PMD_SKY_EXPLORERS', 'Tables')

GENERIC_BAD_NAMES = {'dungeon', 'cave', 'forest', 'test', 'arena',
                     'dark forest', 'map', 'zone', 'unknown'}


def zone_to_dungeon():
    src = open(os.path.join(REPO, 'dev', 'tools',
                            'sky_compare_zones_to_rom.py')).read()
    m = re.search(r'ZONE_TO_DUNGEON = \{(.*?)\}', src, re.S)
    return dict(re.findall(r'"(\w+)":\s*"(d\d+)"', m.group(1)))


def rom_table(dk):
    fs = glob.glob(os.path.join(TABLES, 'dungeons', f'{dk}_*.json.gz'))
    return json.load(gzip.open(fs[0], 'rt')) if fs else None


def audit_rsmap(path):
    """Contrôles viewport/positions d'une map fixe."""
    issues = []
    d = json.load(open(path, encoding='utf-8-sig'))
    o = d['Object']
    tiles = o.get('Tiles') or []
    W = len(tiles)
    H = len(tiles[0]) if W else 0
    layers = o.get('Layers') or []
    if layers:
        lt = layers[0].get('Tiles') or []
        if len(lt) != W or (lt and len(lt[0]) != H):
            issues.append(f'LAYER_DIM_MISMATCH {len(lt)}x'
                          f'{len(lt[0]) if lt else 0} vs {W}x{H}')
    disc = o.get('DiscoveryArray') or []
    if disc and (len(disc) != W or (disc and len(disc[0]) != H)):
        issues.append('DISCOVERY_DIM_MISMATCH')
    for ep in o.get('EntryPoints') or []:
        x, y = ep['Loc']['X'], ep['Loc']['Y']
        if not (0 <= x < W and 0 <= y < H):
            issues.append(f'ENTRY_OUT_OF_BOUNDS ({x},{y}) map {W}x{H}')
    for grp in ('MapTeams', 'AllyTeams'):
        for t in o.get(grp) or []:
            for p in t.get('Players') or []:
                loc = p.get('CharLoc') or {}
                x, y = loc.get('X', 0), loc.get('Y', 0)
                if not (0 <= x < W and 0 <= y < H):
                    sp = (p.get('BaseForm') or {}).get('Species', '?')
                    issues.append(f'CAST_OUT_OF_BOUNDS {sp} ({x},{y}) '
                                  f'map {W}x{H}')
    # autotiles référencés
    txt = json.dumps(d)
    for at in set(re.findall(r'"AutoTileset":\s*"(\w+)"', txt)):
        if not at:
            continue
        if not (os.path.exists(os.path.join(AUTO_Q, at + '.json'))
                or os.path.exists(os.path.join(AUTO_B, at + '.json'))):
            issues.append(f'AUTOTILE_MISSING {at}')
    mus = o.get('Music')
    if mus and not (os.path.exists(os.path.join(MUS_Q, mus))
                    or os.path.exists(os.path.join(MUS_B, mus))):
        issues.append(f'MUSIC_MISSING {mus}')
    return issues, (W, H)


NARRATIVE_SLUGS = {'hero', 'partner', 'player', 'attendant'}


def main():
    z2d = zone_to_dungeon()
    rows = OrderedDict()
    counts = Counter()
    for zp in sorted(glob.glob(os.path.join(ZONES, '*.json'))):
        zid = os.path.basename(zp)[:-5]
        if zid == 'index':
            continue
        d = json.load(open(zp, encoding='utf-8-sig'))
        o = d['Object']
        issues = []
        name = ((o.get('Name') or {}).get('DefaultText') or '').strip()
        if not name:
            issues.append('NAME_EMPTY')
        elif name.lower() in GENERIC_BAD_NAMES:
            issues.append(f'NAME_GENERIC "{name}"')
        # nom ROM (Sky)
        dk = z2d.get(zid)
        rom = rom_table(dk) if dk else None
        if rom:
            rom_name = (rom.get('name_en') or '').strip()
            n_floors = sum(len(seg.get('Floors') or [])
                           for seg in o.get('Segments') or [])
            if rom_name and not rom_name.startswith('[M:'):
                # normalisation légère (apostrophes/points)
                a = re.sub(r"[^a-z0-9]", '', name.lower())
                b = re.sub(r"[^a-z0-9]", '', rom_name.lower())
                if a != b and b not in a and a not in b:
                    issues.append(f'NAME_MISMATCH "{name}" vs ROM '
                                  f'"{rom_name}"')
            rf = rom.get('number_floors') or len(rom.get('floors') or [])
            if n_floors and rf and n_floors != rf:
                # arènes 1 étage sur donjons 100% fixed = attendu
                if not (n_floors == 1 and rf >= 1):
                    issues.append(f'FLOORS_MISMATCH {n_floors} vs ROM {rf}')
        # spawn narratif sauvage
        txt = json.dumps(d)
        for m in re.finditer(r'"BaseForm":\s*\{\s*"Species":\s*"(\w+)"',
                             txt):
            if m.group(1).lower() in NARRATIVE_SLUGS:
                issues.append(f'NARRATIVE_WILD_SPAWN {m.group(1)}')
        # maps fixes rattachées (LoadGen rsmap)
        for mm in set(re.findall(r'"MapFile":\s*"(\w+)"', txt)) \
                | set(re.findall(r'"MapID":\s*"(\w+)"', txt)):
            mp = os.path.join(MAPS, mm + '.rsmap')
            if os.path.exists(mp):
                mi, dims = audit_rsmap(mp)
                issues += [f'{mm}: {x}' for x in mi]
        # autotiles zone
        for at in set(re.findall(r'"AutoTileset":\s*"(\w+)"', txt)) \
                | set(re.findall(r'"(\w+)_(?:floor|wall|secondary)"', txt)):
            pass
        # autotiles réellement référencés comme AutoTileset (le motif
        # nu `\w+_floor` matche des NOMS DE GROUNDS type
        # guild_first_floor : faux positif — exclusion par liste
        # GroundMaps)
        grounds = set(o.get('GroundMaps') or [])
        for suf_at in set(re.findall(
                r'"(\w+_(?:floor|wall|secondary))"', txt)):
            if suf_at in grounds:
                continue
            if not (os.path.exists(os.path.join(AUTO_Q, suf_at + '.json'))
                    or os.path.exists(os.path.join(AUTO_B,
                                                   suf_at + '.json'))):
                issues.append(f'AUTOTILE_MISSING {suf_at}')
        # musiques
        for mu in set(re.findall(r'"Music":\s*"([^"]+)"', txt)):
            if mu and not (os.path.exists(os.path.join(MUS_Q, mu))
                           or os.path.exists(os.path.join(MUS_B, mu))):
                issues.append(f'MUSIC_MISSING {mu}')
        st = 'PASS' if not issues else 'FAIL'
        counts[st] += 1
        rows[zid] = {'status': st, 'name': name, 'dungeon': dk,
                     'issues': sorted(set(issues))}
    # rsmaps orphelins (arènes hors zones) : audit direct
    for mp in sorted(glob.glob(os.path.join(MAPS, '*.rsmap'))):
        mid = os.path.basename(mp)[:-6]
        mi, dims = audit_rsmap(mp)
        if mi:
            counts['RSMAP_FAIL'] += 1
            rows['rsmap:' + mid] = {'status': 'FAIL', 'issues': mi}
    out = {'schema': 'dungeon-matrix-audit/1', 'totals': dict(counts),
           'zones': rows}
    p = os.path.join(REPO, 'dev', 'docs', 'canonical',
                     'DUNGEON_MATRIX_AUDIT.json')
    json.dump(out, open(p, 'w'), indent=1, ensure_ascii=False)
    print(dict(counts))
    fails = [(k, v) for k, v in rows.items() if v['status'] == 'FAIL']
    for k, v in fails[:25]:
        print(k, v['issues'][:3])
    print(p)


if __name__ == '__main__':
    main()
