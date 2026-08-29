#!/usr/bin/env python3
"""LOT O — Secret Bazaar Sky (dernier reste PORTED_APPROXIMATED).

CONTRE-ÉPREUVE ROM (pmdsky-debug, adresses EU) :
- enum hidden_stairs_type : 1=SECRET_BAZAAR, 2=SECRET_ROOM,
  255=RANDOM_BAZAAR_OR_ROOM (enums.h l.149-154). Le TYPE est tiré au spawn
  de l'escalier caché — nos hidden stairs (LOT C) couvrent le flux ;
  le bazar est la VARIANTE marchande de la salle secrète.
- 5 PNJ behaviors 16-20 : KIRLIA (sortie), MIME_JR (soin), SWALOT (vente
  grab bag GetRandomBazaarItem EU 0x22E8568), LICKILICKY (décolle les
  objets collants), SHEDINJA (?) — table du grab bag non publiée.

IMPLÉMENTATION NATIVE (aucun code C# requis — primitives éprouvées) :
Sur le segment « salles secrètes » (LOT C), 1 étage sur 2 (pair) devient
BAZAR — approx assumée du tirage 50/50 type 255 :
  * ShopStep (Swalot marchand, mécanique voleur/sécurité native, mêmes
    champs que Kecleon LOT E) — vente = rôle canonique de Swalot ;
  * items gratuits du grab bag : le segment garde ses ItemSpawn x3 (LOT C) ;
  * Lickilicky/Mime Jr./Kirlia : services de dialogue non portables sans
    les textes ROM (non extraits) — documentés PORTED_APPROXIMATED ;
    le soin est partiellement couvert par les items du bazar.
Étages impairs : salle secrète au trésor (déjà en place). Statut global :
mécanique hidden stairs EXACTE, contenu bazar APPROXIMÉ (marchand + loot).
"""
import json, os, sys, argparse, copy, importlib.util

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(ROOT, 'dev/tools'))
from ch1_5_lockfile import LOCKED_PATHS

spec2 = importlib.util.spec_from_file_location(
    'ksky', os.path.join(ROOT, 'dev/tools/add_kecleon_shops_sky.py'))
ksky = importlib.util.module_from_spec(spec2)
spec2.loader.exec_module(ksky)

MGC = 'RogueEssence.LevelGen.MapGenContext, RogueEssence'


def swalot_spawn():
    sp = ksky.kecleon_spawn()
    sp['BaseForm']['Species'] = 'swalot'
    sp['SpecifiedSkills'] = ['toxic', 'sludge_bomb', 'body_slam', 'yawn']
    sp['Intrinsic'] = 'sticky_hold'
    return sp


def bazaar_shop_step(items):
    return {'Key': {'str': [5, 4]}, 'Value': {
        '$type': f'PMDC.LevelGen.ShopStep`1[[{MGC}]], PMDC',
        'Items': items,
        'ItemThemes': [],
        'Mobs': [{'Spawn': swalot_spawn(), 'Rate': 10}],
        'StartMob': swalot_spawn(),
        'Filters': [{'$type': 'PMDC.LevelGen.RoomFilterConnectivity, PMDC', 'Connection': 1}],
        'SecurityStatus': 'shop_security',
        'Personality': 0,
    }}


def grab_items(zobj):
    """Items 'grab bag' approx : premières entrées non-shop de la zone."""
    out = []

    def walk(node):
        if out or not isinstance(node, (dict, list)):
            return
        if isinstance(node, dict):
            if 'ItemSpawnZoneStep' in node.get('$type', ''):
                sp = node.get('Spawns')
                pools = sp.values() if isinstance(sp, dict) else [sp]
                for p in pools:
                    for e in (p or {}).get('Spawns', [])[:6]:
                        s = e.get('Spawn', {})
                        if s.get('Price', 0) > 0 or s.get('IsMoney') or s.get('Cursed'):
                            continue
                        out.append({'Spawn': {'IsMoney': False, 'Cursed': False,
                                              'Value': s.get('Value') or s.get('ID'),
                                              'HiddenValue': '', 'Amount': 0, 'Price': 0,
                                              'TileLoc': {'X': 0, 'Y': 0}},
                                    'Rate': 10})
                    if out:
                        return
            for v in node.values():
                walk(v)
        else:
            for v in node:
                walk(v)
    walk(zobj)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    args = ap.parse_args()

    rep_c = json.load(open(os.path.join(ROOT, 'dev/docs/canonical/HIDDEN_STAIRS_SKY_REPORT.json')))
    report = {'rule': 'Secret Bazaar (hidden_stairs_type 1/255, behaviors 16-20 pmdsky-debug) -> ShopStep Swalot sur les étages PAIRS du segment secret (approx 50/50 type 255)',
              'status': 'PORTED_APPROXIMATED (services PNJ dialogue non portables sans textes ROM)',
              'apply': args.apply, 'zones': []}
    tot = 0
    for r in rep_c['zones']:
        zone = r.get('zone')
        if not zone or not (r.get('floors') or r.get('status') == 'DEJA_EQUIPPE'):
            continue
        rel = f'Data/Zone/{zone}.json'
        if rel in LOCKED_PATHS or not os.path.exists(os.path.join(ROOT, rel)):
            continue
        zpath = os.path.join(ROOT, rel)
        raw = open(zpath, encoding='utf-8-sig').read()
        z = json.loads(raw)
        segs = z['Object']['Segments']
        # segment secret = celui avec le Comment R11
        tseg = None
        for s in segs:
            if 'R11 salles secretes' in (s.get('Comment') or ''):
                tseg = s
                break
        if tseg is None:
            continue
        if 'swalot' in json.dumps(tseg):
            report['zones'].append({'zone': zone, 'status': 'DEJA_EQUIPPE'})
            continue
        items = grab_items(z['Object'])
        if not items:
            report['zones'].append({'zone': zone, 'status': 'SANS_ITEMS'})
            continue
        n = 0
        for fi, fl in enumerate(tseg.get('Floors', [])):
            if fi % 2 != 0:
                continue  # étages pairs (0-based) = bazar
            pools = [fl['GenSteps']] if 'GenSteps' in fl else \
                    [sp['Spawn']['GenSteps'] for sp in fl.get('Spawns', [])
                     if 'GenSteps' in sp.get('Spawn', {})]
            for gs in pools:
                if any('ShopStep' in g['Value'].get('$type', '') for g in gs):
                    continue
                gs.append(bazaar_shop_step(copy.deepcopy(items)))
                n += 1
        if n:
            tot += n
            report['zones'].append({'zone': zone, 'bazaar_floors': n})
            if args.apply:
                with open(zpath, 'w', encoding='utf-8-sig') as f:
                    json.dump(z, f, indent=2, ensure_ascii=False)

    out = os.path.join(ROOT, 'dev/docs/canonical/SECRET_BAZAAR_REPORT.json')
    json.dump(report, open(out, 'w'), indent=1, ensure_ascii=False)
    nz = len([r for r in report['zones'] if r.get('bazaar_floors')])
    print(f"bazars: {tot} étages / {nz} zones, apply={args.apply}")


if __name__ == '__main__':
    main()
