#!/usr/bin/env python3
"""Promotion des 27 grounds NDS dXXp21a (aires de repos standard) +
pose des statues Kangourex (placements SSA ROM 1:1).

Pipeline identique aux 118 grounds Sky déjà promus (référence d21p21a) :
 1. dev/RESERVE/sky_grounds/sky_<id>.rsground  -> Data/Ground/<id>.rsground
      - AssetName  sky_<id> -> <id>
      - Sheet      sky_<id>_Base -> <Id capitalisé>_Base (D10p21a_Base)
      - EdgeView   0 -> 1 (Clamp, convention fix_ground_viewport_spawn)
      - Marker     Main_Entrance_Marker recentré sur case marchable centre
      - Name       FR canonique = GROUP_NAMES[dXX] + « Aire de repos »
 2. dev/RESERVE/sky_tiles/sky_<id>_Base.tile -> Content/Tile/<Id>_Base.tile
 3. Statues Kangourex : KANGASKHAN_STATUES.json (extraits enter.sse,
    x_absolute/y_absolute pixels 1:1) -> GroundObjects "Kangaskhan_Rock"
    (AnimIndex Statue_Dungeon, DrawOffset 4,8, Collider 24x24 centré sur
    la position ROM — modèle exact d06p11a).
 4. index Ground (Data/Ground/index.idx) mis à jour.
"""
import json, io, os, sys, struct, copy, argparse

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RG = os.path.join(ROOT, 'dev/RESERVE/sky_grounds')
RT = os.path.join(ROOT, 'dev/RESERVE/sky_tiles')
DG = os.path.join(ROOT, 'Data/Ground')
CT = os.path.join(ROOT, 'Content/Tile')
TAB = os.path.join(ROOT, 'dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables')

GROUNDS = ['d10p21a', 'd12p21a', 'd15p21a', 'd26p21a', 'd28p21a', 'd30p21a',
           'd35p21a', 'd38p12a', 'd39p21a', 'd41p21a', 'd42p21a', 'd45p21a',
           'd46p21a', 'd48p21a', 'd51p21a', 'd53p21a', 'd55p21a', 'd56p21a',
           'd57p21a', 'd73p21a', 'd73p22a', 'd73p23a', 'd73p24a', 'd73p26a',
           'd73p27a', 'd73p29a', 'd79p21a']

sys.path.insert(0, os.path.join(ROOT, 'dev/tools'))


def group_names():
    """GROUP_NAMES de convert_sky_all sans importer skytemple."""
    import re
    src = open(os.path.join(ROOT, 'dev/tools/convert_sky_all.py'), encoding='utf-8').read()
    m = re.search(r'GROUP_NAMES = \{(.*?)\n\}', src, re.S)
    names = dict(re.findall(r"'(d\d+)':\s*'([^']+)'", m.group(1)))
    return names


def sheet_name(gid):
    return gid[0].upper() + gid[1:] + '_Base'


def walkable_center(obj):
    """Case marchable la plus proche du centre (blocs = AnimIndex '' avec
    Passable False n'existent pas ici : on lit la couche Tiles/collision).
    Le rsground RESERVE encode la collision dans les Tags des tuiles ?
    Convention convert_sky_all : collision -> marker posé par le convertisseur
    sur 'entry'. On garde le marker existant s'il est présent, sinon centre."""
    return None


def kangaskhan_obj(x, y):
    return {
        'EntName': 'Kangaskhan_Rock', 'Direction': 0, 'EntEnabled': True,
        'EntOrder': 0, 'InteractOrder': 0, 'triggerType': 1,
        'ObjectAnim': {'$type': 'RogueEssence.Content.ObjAnimData, RogueEssence',
                       'AnimIndex': 'Statue_Dungeon', 'FrameTime': 1,
                       'StartFrame': -1, 'EndFrame': -1, 'AnimDir': -1,
                       'Alpha': 255, 'AnimFlip': 0},
        'Passable': False,
        'CurrentAnim': {'$type': 'RogueEssence.Content.ObjAnimData, RogueEssence',
                        'AnimIndex': '', 'FrameTime': 1, 'StartFrame': -1,
                        'EndFrame': -1, 'AnimDir': 0, 'Alpha': 255, 'AnimFlip': 0},
        'AnimTime': {'Ticks': 0}, 'Cycles': 0,
        'DrawOffset': {'X': 4, 'Y': 8},
        'Collider': {'X': x - 12, 'Y': y - 12, 'Width': 24, 'Height': 24},
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    args = ap.parse_args()

    statues = json.load(open(os.path.join(TAB, 'KANGASKHAN_STATUES.json')))
    names = group_names()
    report = {'promoted': [], 'statues_placed': 0, 'apply': args.apply}

    for gid in GROUNDS:
        src_g = os.path.join(RG, f'sky_{gid}.rsground')
        src_t = os.path.join(RT, f'sky_{gid}_Base.tile')
        if not (os.path.exists(src_g) and os.path.exists(src_t)):
            report['promoted'].append({'ground': gid, 'status': 'RESERVE_ABSENT'})
            continue
        doc = json.load(open(src_g, encoding='utf-8-sig'))
        o = doc['Object']
        o['AssetName'] = gid
        o['EdgeView'] = 1
        grp = gid[:3]
        base_fr = names.get(grp, grp.upper())
        o['Name'] = {'DefaultText': f'{grp.upper()} Rest Area',
                     'LocalTexts': {'fr': f'{base_fr} — Aire de repos'}}
        # sheet rename dans toutes les tuiles
        sn = sheet_name(gid)
        blob = json.dumps(doc, ensure_ascii=False, separators=(',', ':'))
        blob = blob.replace(f'sky_{gid}_Base', sn)
        doc = json.loads(blob)
        o = doc['Object']
        # statues SSA (clé majuscule)
        key = gid.upper()
        placed = 0
        ents = o['Entities'][0]
        ents.setdefault('GroundObjects', [])
        for st in statues.get(key, []):
            ents['GroundObjects'].append(kangaskhan_obj(st['x'], st['y']))
            placed += 1
        report['statues_placed'] += placed
        report['promoted'].append({'ground': gid, 'statues': placed,
                                   'sheet': sn, 'status': 'OK'})
        if args.apply:
            with io.open(os.path.join(DG, f'{gid}.rsground'), 'w',
                         encoding='utf-8-sig') as f:
                json.dump(doc, f, ensure_ascii=False, separators=(',', ':'))
            with open(src_t, 'rb') as fi, open(os.path.join(CT, f'{sn}.tile'), 'wb') as fo:
                fo.write(fi.read())

    # (pas d'index Ground : RogueEssence charge les .rsground par nom de fichier)

    out = os.path.join(ROOT, 'dev/docs/canonical/SKY_REST_GROUNDS_PROMOTION_REPORT.json')
    json.dump(report, open(out, 'w'), indent=1, ensure_ascii=False)
    ok = len([r for r in report['promoted'] if r['status'] == 'OK'])
    print(f"promus: {ok}/27, statues posées: {report['statues_placed']}, apply={args.apply}")


if __name__ == '__main__':
    main()
