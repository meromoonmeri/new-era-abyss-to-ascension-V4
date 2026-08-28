#!/usr/bin/env python3
"""Analyse statistique des générations de donjons (§17/§19/§20/§36).

Entrée : /tmp/ground_gameplay_validator.jsonl produit par le mode
`dprobe:` avec PMDO_DPROBE_ASCII=1 et PMDO_DPROBE_REPS=N.

Mesures par zone :
- mobs/items/traps par étage (min/max/moyenne) vs formules ROM
  (R3 : ennemis RandRange(d/2,d) min 1 ; items RandRange(d-2,d+2) min 1 ;
   pièges RandRange(d/2,d)) ;
- variété : hash structurel du layout (positions salles/couloirs) —
  détection d'étages identiques ou quasi identiques entre reps/étages ;
- taux d'apparition d'eau/terrain secondaire.

Sortie : JSON de rapport + verdicts PASS/PARTIAL/FAIL par zone.
"""
import json, sys, hashlib, collections, argparse

def norm_layout(rows):
    """Réduit l'ASCII au squelette structurel (murs vs ouvert), pour hash."""
    out = []
    for r in rows:
        out.append(''.join('#' if c in '#X' else '.' for c in r))
    return '\n'.join(out)

def near_dup(a, b):
    """Similarité tuile/tuile entre deux squelettes de même taille."""
    if len(a) != len(b):
        return 0.0
    same = sum(1 for x, y in zip(a, b) if x == y)
    return same / max(1, len(a))

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--jsonl', default='/tmp/ground_gameplay_validator.jsonl')
    ap.add_argument('--out', default='/tmp/dungeon_generation_statistics.json')
    ap.add_argument('--near-threshold', type=float, default=0.98)
    args = ap.parse_args()

    floors = collections.defaultdict(list)   # zone -> [ {floor,mobs,items,traps} ]
    layouts = collections.defaultdict(list)  # zone -> [ (floor, skeleton) ]
    for line in open(args.jsonl):
        line = line.strip()
        if not line.startswith('{'):
            continue
        try:
            d = json.loads(line)
        except Exception:
            continue
        if d.get('event') == 'dprobe_floor':
            floors[d['zone']].append(d)
        elif d.get('event') == 'dprobe_ascii':
            layouts[d['zone']].append((d['floor'], norm_layout(d['rows'])))

    report = {'zones': {}, 'global': {}}
    total_layouts = 0
    total_dups = 0
    total_neardups = 0
    for zone in sorted(floors):
        fl = floors[zone]
        mobs = [f['mobs'] for f in fl]
        items = [f['items'] for f in fl]
        traps = [f['traps'] for f in fl]
        skels = [s for (_, s) in layouts.get(zone, [])]
        hashes = [hashlib.sha1(s.encode()).hexdigest() for s in skels]
        dups = len(hashes) - len(set(hashes))
        near = 0
        for i in range(len(skels)):
            for j in range(i + 1, len(skels)):
                if hashes[i] != hashes[j] and near_dup(skels[i], skels[j]) >= args.near_threshold:
                    near += 1
        total_layouts += len(skels)
        total_dups += dups
        total_neardups += near
        openness = []
        water = []
        for s in skels:
            flat = s.replace('\n', '')
            openness.append(flat.count('.') / max(1, len(flat)))
        # eau mesurée sur l'ASCII brut
        z = {
            'samples': len(fl),
            'mobs': {'min': min(mobs), 'max': max(mobs), 'avg': round(sum(mobs) / len(mobs), 2)},
            'items': {'min': min(items), 'max': max(items), 'avg': round(sum(items) / len(items), 2)},
            'traps': {'min': min(traps), 'max': max(traps), 'avg': round(sum(traps) / len(traps), 2)},
            'layouts': len(skels),
            'identical_layouts': dups,
            'near_identical_layouts': near,
            'open_ratio_avg': round(sum(openness) / len(openness), 3) if openness else None,
        }
        z['verdict'] = 'PASS'
        reasons = []
        if dups > 0:
            z['verdict'] = 'FAIL'
            reasons.append(f'{dups} layouts identiques')
        elif near > max(1, len(skels) // 20):
            z['verdict'] = 'PARTIAL'
            reasons.append(f'{near} paires quasi identiques (>={args.near_threshold})')
        if min(mobs) == 0 and max(mobs) == 0:
            z['verdict'] = 'FAIL'
            reasons.append('aucun mob généré')
        z['reasons'] = reasons
        report['zones'][zone] = z

    report['global'] = {
        'total_layouts': total_layouts,
        'identical': total_dups,
        'near_identical_pairs': total_neardups,
        'verdict': 'FAIL' if total_dups else ('PARTIAL' if total_neardups > total_layouts // 20 else 'PASS'),
    }
    json.dump(report, open(args.out, 'w'), indent=1, ensure_ascii=False)
    print(json.dumps(report, indent=1, ensure_ascii=False))

if __name__ == '__main__':
    main()
