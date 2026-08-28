#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""fix_monster_house_chances.py — Maisons de Monstres : chance ROM PAR
ÉTAGE (fin du 5% générique).

CONSTAT : les SpreadHouseZoneStep posés précédemment utilisent
SpreadPlanChance avec un % unique (souvent 5) sur toute la plage, alors
que mappa_s.bin donne monster_house_chance PAR ÉTAGE (souvent 0 sur une
partie du donjon, ex. beach_cave_pit=0, crystal_cave=[0,5],
destiny_tower=[0,5,6,50]).

CORRECTIF (fidélité ROM, mécanisme natif PMDO) :
 - pour chaque segment porteur d'un SpreadHouseZoneStep en
   SpreadPlanChance : regrouper les étages ROM par valeur de chance
   contiguë et produire UN SpreadHouseZoneStep par plage (clone du step
   existant, seule SpreadPlan change) ; plages à 0 -> aucune MH ;
 - si tout le donjon est à 0 -> retirer le step (contenu ROM: pas de MH) ;
 - zones verrouillées CH1-5 et zones sans table ROM Sky (Red utilise déjà
   SpreadPlanQuota ou du contenu Halcyon) : intouchées.
Le mapping des étages ROM suit l'ordre global des segments (comme
fix_red_dungeon_population).
"""
import glob
import gzip
import json
import os
import re

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TABLES = os.path.join(REPO, 'dev', 'CAMPAIGNS', 'PMD_SKY_EXPLORERS',
                      'Tables')

LOCKED = {
    "relic_forest", "illuminant_riverbed", "crooked_cavern",
    "apricorn_grove", "vast_steppe", "searing_tunnel", "mount_windswept",
    "cloven_ruins", "beginner_lesson", "petit_tunnel", "bosquet_voile",
    "grotte_mystere", "vallee_fertile", "grotte_repos", "bois_ronces",
    "antre_enigme", "carriere_cuivre", "grotte_echoue", "halles_royales",
    "jardin_secret", "foret_embuscade", "bois_filou", "normal_maze",
    "bug_maze", "electric_maze", "fire_maze", "flying_maze", "grass_maze",
    "rock_maze", "water_maze", "master_zone",
}


def rom_mh_chances():
    cmp_ = json.load(open(os.path.join(
        TABLES, 'ZONE_VS_ROM_COMPARISON.json')))['zones']
    tables = {}
    for g in glob.glob(os.path.join(TABLES, 'dungeons', '*.json.gz')):
        m = re.match(r'(d\d+)_dungeon_(.+)\.json\.gz', os.path.basename(g))
        if m:
            tables[m.group(2)] = g
    out = {}
    for zn in set(list(cmp_.keys()) + list(tables.keys())):
        g = None
        if zn in cmp_:
            gl = glob.glob(os.path.join(
                TABLES, 'dungeons', f"{cmp_[zn]['dungeon']}_*.json.gz"))
            g = gl[0] if gl else None
        if not g:
            g = tables.get(zn)
        if not g:
            continue
        t = json.load(gzip.open(g))
        out[zn] = [f['layout']['monster_house_chance']
                   for f in t['floors']]
    return out


def ranges_by_value(vals, offset, count):
    """[(chance, lo, hi_exclusive)] au sein du segment (0-based local)."""
    seg_vals = vals[offset:offset + count]
    if len(seg_vals) < count:  # table plus courte: étendre dernière valeur
        seg_vals = seg_vals + [seg_vals[-1] if seg_vals else 0] * (
            count - len(seg_vals))
    res = []
    i = 0
    while i < count:
        v = seg_vals[i]
        j = i
        while j + 1 < count and seg_vals[j + 1] == v:
            j += 1
        res.append((v, i, j + 1))
        i = j + 1
    return res


def main():
    mh = rom_mh_chances()
    changed = {}
    for p in sorted(glob.glob(os.path.join(REPO, 'Data', 'Zone',
                                           '*.json'))):
        zn = os.path.basename(p)[:-5]
        if zn in LOCKED or zn not in mh:
            continue
        doc = json.load(open(p, encoding='utf-8-sig'))
        obj = doc['Object']
        vals = mh[zn]
        goffset = 0
        zone_changed = False
        for seg in obj.get('Segments', []):
            floors = seg.get('Floors')
            nf = len(floors) if isinstance(floors, list) else 0
            zsteps = seg.get('ZoneSteps', [])
            idxs = [i for i, s in enumerate(zsteps)
                    if 'SpreadHouseZoneStep' in s.get('$type', '')
                    and 'SpreadPlanChance' in
                    (s.get('SpreadPlan') or {}).get('$type', '')]
            if idxs and nf:
                template = zsteps[idxs[0]]
                cur = [(zsteps[i].get('SpreadPlan') or {}).get('Chance')
                       for i in idxs]
                rngs = ranges_by_value(vals, goffset, nf)
                want = [(v, lo, hi) for (v, lo, hi) in rngs if v > 0]
                # déjà exact ? (1 step par plage avec la bonne chance)
                have = []
                for i in idxs:
                    sp = zsteps[i]['SpreadPlan']
                    have.append((sp.get('Chance'),
                                 sp['FloorRange']['Min'],
                                 sp['FloorRange']['Max']))
                want_cmp = [(v, lo, hi) for (v, lo, hi) in want]
                if sorted(have) != sorted(want_cmp):
                    for i in reversed(idxs):
                        zsteps.pop(i)
                    for (v, lo, hi) in want:
                        st = json.loads(json.dumps(template))
                        st['SpreadPlan'] = {
                            "$type": "RogueEssence.LevelGen."
                                     "SpreadPlanChance, RogueEssence",
                            "Chance": v,
                            "FloorRange": {"Min": lo, "Max": hi}}
                        zsteps.append(st)
                    changed.setdefault(zn, []).append(
                        {"had": have, "now": want})
                    zone_changed = True
            goffset += nf
        if zone_changed:
            with open(p, 'w', encoding='utf-8-sig') as fh:
                json.dump(doc, fh, ensure_ascii=False, indent=2)
    print(f"zones corrigées: {len(changed)}")
    for zn, r in list(changed.items())[:15]:
        print(" ", zn, r)
    out = os.path.join(REPO, 'dev', 'docs', 'canonical',
                       'MONSTER_HOUSE_CHANCE_FIX_REPORT.json')
    json.dump(changed, open(out, 'w'), ensure_ascii=False, indent=1)
    print("rapport:", out)


if __name__ == '__main__':
    main()
