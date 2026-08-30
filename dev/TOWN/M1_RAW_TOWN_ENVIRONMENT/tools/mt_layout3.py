#!/usr/bin/env python3
"""M1 v3 — layout inspiré du croquis utilisateur, langage 100 % Metano.

Croquis de référence (image utilisateur) : falaise au NORD avec DEUX
cascades, deux rivières qui descendent en serpentant, PONTS en bois,
place circulaire centrale, réseau de chemins organiques, forêt dense.

Implémentation (aucun crop de l'image : elle sert de PLAN) :
  * bande de falaise nord (autotile falaise Metano, 89 codes) ;
  * cascade principale Metano (groupe complet crête+chute+écume,
    241 cellules, extrait pixel-perfect) + une seconde cascade ;
  * 2 rivières (autotile eau 73 codes + berges) ;
  * ponts en bois Metano (groupe 9×8 vérifié : planches praticables,
    collision native) posés sur les rivières ;
  * place centrale circulaire (chemin, densité dégressive) ;
  * chemins organiques (autotile chemin 177 codes) ;
  * forêt/objets (courbe de densité mesurée).
Zéro bâtiment. Déterministe (seed).
"""
from __future__ import annotations

import json
import math
import sys

sys.path.insert(0, '/home/user/new-era-abyss-to-ascension-V4/'
                   'dev/TOWN/M1_RAW_TOWN_ENVIRONMENT/tools')
from mt_stamp import Compo, VOC, TABLES, nearest_code, NEI8  # noqa: E402
import mt_stamp  # noqa: E402

V2 = json.load(open('/tmp/mt_vocab2.json'))
SEED = 20260831
W, H = 88, 80

# table falaise dans TABLES
TABLES['C'] = {int(c): v for c, v in V2['cliff_table'].items()}


class Compo3(Compo):
    def realize_label(self, lab, order=None):
        """réalise un label donné via sa table (comme realize mais
        pour C)."""
        m = self.mask
        table = TABLES[lab]

        def member(x, y):
            if not (0 <= x < self.W and 0 <= y < self.H):
                return True
            return m[x][y] == lab
        cells = order or [(x, y) for y in range(self.H)
                          for x in range(self.W) if m[x][y] == lab]
        for x, y in cells:
            code = 0
            for i, (dx, dy) in enumerate(NEI8):
                if member(x + dx, y + dy):
                    code |= 1 << i
            c2 = nearest_code(table, code)
            pool = [(h, n) for h, n in table[c2]
                    if mt_stamp.INFO[h]['freq'] >= 5]
            pool = pool or list(table[c2])
            cands = [h for h, n in pool if n >= 3] or \
                    [h for h, _n in pool]

            def score(h):
                s = 0
                if x > 0 and (self.p[x - 1][y], h) in mt_stamp.HP:
                    s += 2
                if y > 0 and (self.p[x][y - 1], h) in mt_stamp.VP:
                    s += 2
                s += 0.001 * dict(table[c2]).get(h, 0)
                return s
            best = max(cands, key=score)
            self.p[x][y] = best
            self.c[x][y] = mt_stamp.INFO[best]['coll']

    def stamp_group(self, g, x0, y0):
        """colle un groupe complet vérifié (cascade/pont) — pixels et
        collision natifs, jamais coupé."""
        for dx, dy, h, cl in g['cells']:
            x, y = x0 + dx, y0 + dy
            if 0 <= x < self.W and 0 <= y < self.H:
                self.p[x][y] = h
                self.c[x][y] = cl
                self.mask[x][y] = 'X'    # figé
                self.objcells.add((x, y))


def build():
    c = Compo3(W, H, SEED)

    # ---- ceinture de forêt
    c.rect('F', 0, 0, W - 1, 3)
    c.rect('F', 0, H - 5, W - 1, H - 1)
    c.rect('F', 0, 0, 4, H - 1)
    c.rect('F', W - 5, 0, W - 1, H - 1)
    c.disk('F', 10, 30, 5)
    c.disk('F', 78, 26, 6)
    c.disk('F', 12, 66, 6)
    c.disk('F', 76, 66, 6)
    c.disk('F', 44, 8, 4)

    # ---- falaise nord HAUTE (comme le croquis) : y=8..18 ; les
    # groupes cascade (dont les flancs falaise donneurs) s'y alignent
    c.rect('C', 5, 8, W - 6, 18)
    c.rect('G', 39, 7, 48, 19)         # brèche du col (marge herbe)


    # ---- rivière OUEST : de la cascade O vers le sud, serpente
    c.ribbon('W', [(20, 0), (20, 22), (17, 28), (19, 34),
                   (19, 48), (18, 58), (16, 68), (17, H - 6)], 2)
    # ---- rivière EST : de la cascade E, descend et oblique SE
    c.ribbon('W', [(62, 0), (62, 22), (66, 28), (63, 34),
                   (63, 50), (65, 58), (68, 64), (70, H - 6)], 2)

    # ---- place circulaire centrale
    c.disk('P', 43, 44, 8)
    # anneau interne (respiration : centre en herbe pour la fontaine
    # future ? non : place pleine, croquis = dallage circulaire)
    # ---- chemins organiques
    c.ribbon('P', [(43, 52), (42, 62), (44, 70), (43, H - 4)], 2)  # sud
    c.ribbon('P', [(43, 36), (44, 26), (42, 16), (43, 11)], 2)     # nord
    c.ribbon('P', [(35, 44), (28, 42), (24, 40)], 1)   # ouest -> pont O
    c.ribbon('P', [(51, 44), (56, 44), (59, 44)], 1)   # est -> pont E
    c.ribbon('P', [(13, 40), (9, 38)], 1)              # rive O
    c.ribbon('P', [(67, 44), (74, 46), (79, 50)], 1)   # rive E
    c.ribbon('P', [(44, 26), (52, 22), (58, 18)], 1)   # sentier NE
    c.ribbon('P', [(42, 62), (34, 64), (26, 66)], 1)   # sentier SO

    return c


def main():
    c = build()
    # ordre : falaise d'abord (contexte), puis le reste
    stats = c.realize()          # P/W/F + berges
    c.realize_label('C')

    # ---- cascades : groupe rectangulaire complet (flancs falaise
    # donneurs INCLUS), aligné pour que ses rangées falaise coïncident
    # avec la bande C (donneur : crête à dy=5) -> stamp y = 8-5 = 3
    wf = V2['waterfall_main']
    c.stamp_group(wf, 20 - 7, 3)
    c.stamp_group(wf, 62 - 7, 3)

    # ---- ponts en bois : platelage praticable seul (les cellules
    # eau du cadre donneur sont exclues : notre rivière continue)
    br = dict(V2['wooden_bridge'])
    import copy as _copy
    br = _copy.deepcopy(br)
    from mt_stamp import INFO as _INFO
    br['cells'] = [cell for cell in br['cells']
                   if _INFO[cell[2]]['cls'] != 'W']
    c.stamp_group(br, 19 - 4, 38)     # pont rivière ouest (x centre 19)
    c.stamp_group(br, 63 - 4, 40)     # pont rivière est (x centre 63)

    # ---- objets végétaux (courbe de densité mesurée)
    import random
    rng = random.Random(SEED)
    objs = VOC['objects']
    keep = [i for i, o in enumerate(objs) if o['blocked'] >= 1]
    order = sorted(keep, key=lambda i: -objs[i]['n'])
    specs = []
    for oi in order:
        o = objs[oi]
        tries = 30 if o['n'] >= 6 else 120
        for _ in range(tries):
            x = rng.randrange(5, W - 7)
            y = rng.randrange(10, H - 7)
            d = min(x, y, W - 1 - x, H - 1 - y)
            pkeep = 0.9 if d < 12 else (0.3 if d < 20 else 0.10)
            if rng.random() > pkeep:
                continue
            specs.append((x, y, oi))
    placed = c.place_objects(specs)

    tot, bad = c.pair_report()
    print(f'realize: {stats} | objets: {placed}')
    print(f'paires: {tot}, hors-corpus {bad} '
          f'({100*(tot-bad)/tot:.2f}% observées)')
    json.dump({'W': W, 'H': H, 'p': c.p, 'c': c.c,
               'mask': [''.join(c.mask[x][y] for x in range(W))
                        for y in range(H)],
               'params': {'seed': SEED, 'layout': 'mt_layout3.py/1'}},
              open('/tmp/m1_metano_composed.json', 'w'))
    c.render('/tmp/m1_metano_composed.png')
    print(f'{W}x{H} -> /tmp/m1_metano_composed.png')


if __name__ == '__main__':
    main()
