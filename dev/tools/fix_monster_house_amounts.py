#!/usr/bin/env python3
"""LOT B — Monster Houses canoniques (règle R4.4).

Loi ROM (traçable) :
  GBA  pret dungeon_generation.c SpawnEnemies : N = RandRange(70%*T, 80%*T)
       plafonné à gMonsterHouseMaxMons(12) * 3/2 = 18   (dungeon_config.c l.22)
  NDS  dungeon-eos DungeonAlgorithm.py l.3350-3385 :
       N = max(1, randrange(7*T//10, 8*T//10)) plafonné à
       MH_NORMAL_SPAWN_ENM(30) * 3/2 = 45                (l.64)
  (T = tuiles libres de la salle)

PMDO : MobThemeNone.Amount = RandRange fixe (ne dépend pas de la salle).
Approximation data (phase 1 de MODERN_DUNGEON_RECIPE §LOT B) fondée sur la
distribution RÉELLE des tailles de salles mesurée au runtime (4492 salles,
GENERATION_STATS_BASELINE.md : P25=30, P75=42 tuiles) :
  Sky : Min = int(0.7*30) = 21 ; Max = int(0.8*42) = 33  (< cap 45)
  GBA : Min = 14 (loi sur petite salle T=20) ; Max = 18 (cap ROM)
Vanilla PMDO contient déjà des Amounts 25-32 (viabilité runtime prouvée).

Ne touche PAS : zones verrouillées CH1-CH5, Amounts 2-4 (houses spéciales
volontairement petites), zones non issues des ROMs (customs PMDO gardent
leur réglage).
"""
import json, os, sys, argparse

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(ROOT, 'dev/tools'))
from ch1_5_lockfile import LOCKED_PATHS

SKY_AMOUNT = {'Min': 21, 'Max': 33}
GBA_AMOUNT = {'Min': 14, 'Max': 18}


def walk_house_amounts(node, setter):
    """Trouve récursivement les MobThemeNone dans les SpreadHouseZoneStep/
    MonsterHouseStep et applique setter(amount_dict) -> new or None."""
    n = 0
    if isinstance(node, dict):
        t = node.get('$type', '')
        if 'MobThemeNone' in t and isinstance(node.get('Amount'), dict):
            a = node['Amount']
            if a.get('Min') == 7 and a.get('Max') == 13:
                new = setter(a)
                if new:
                    node['Amount'] = dict(new)
                    n += 1
        for v in node.values():
            n += walk_house_amounts(v, setter)
    elif isinstance(node, list):
        for v in node:
            n += walk_house_amounts(v, setter)
    return n


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    args = ap.parse_args()

    reg = json.load(open(os.path.join(ROOT, 'dev/docs/canonical/CONTENT_REGISTRY.json')))
    res = reg['resources']
    prov = {k.split('/')[1]: v.get('provider') for k, v in res.items() if k.startswith('Zone/')}

    report = {'rule': 'R4.4 MH taille canonique (GBA cap 18 / Sky cap 45, plages 70-80% des salles mesurées)',
              'sky_amount': SKY_AMOUNT, 'gba_amount': GBA_AMOUNT,
              'apply': args.apply, 'zones': []}
    tot = 0
    for zone, provider in sorted(prov.items()):
        if provider not in ('ROM:NDS', 'ROM:GBA'):
            continue
        rel = f'Data/Zone/{zone}.json'
        if rel in LOCKED_PATHS:
            report['zones'].append({'zone': zone, 'status': 'SKIP_LOCKED'})
            continue
        zpath = os.path.join(ROOT, rel)
        if not os.path.exists(zpath):
            continue
        z = json.load(open(zpath, encoding='utf-8-sig'))
        amount = SKY_AMOUNT if provider == 'ROM:NDS' else GBA_AMOUNT
        n = walk_house_amounts(z['Object'], lambda a: amount)
        if n:
            tot += n
            report['zones'].append({'zone': zone, 'provider': provider, 'changed': n,
                                    'amount': amount})
            if args.apply:
                with open(zpath, 'w', encoding='utf-8-sig') as f:
                    json.dump(z, f, indent=2, ensure_ascii=False)

    out = os.path.join(ROOT, 'dev/docs/canonical/MONSTER_HOUSE_AMOUNT_FIX_REPORT.json')
    json.dump(report, open(out, 'w'), indent=1, ensure_ascii=False)
    print(f"MobThemeNone 7-13 -> canonique : {tot} occurrences, "
          f"{len([z for z in report['zones'] if z.get('changed')])} zones, apply={args.apply}")


if __name__ == '__main__':
    main()
