#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Detecte les MICRO-DEPLACEMENTS qui font sautiller les sprites.

POURQUOI CET OUTIL
==================
Retour de jeu : « les mouvements de Ganlon manquent de precision et ne
semblent pas naturels ».

Mesure : son dernier segment allait de (268,208) a (268,200), soit HUIT
pixels — la moitie d'une case de 16. EightWayMove recalcule sa direction
a chaque appel ; sur une distance plus courte qu'un pas de marche, le
sprite pivote et sautille sur place au lieu d'arriver proprement. Deux
autres cas identiques existaient (Kino et Reinier a leur arrivee au camp).

Ce defaut est invisible a la lecture — chaque appel est correct pris
isolement — et tres visible manette en main.

LE SEUIL
========
16 px = une case. En dessous, le deplacement est plus court qu'un pas et
ne peut pas s'animer correctement. La correction consiste presque
toujours a FUSIONNER le micro-segment avec le precedent : le personnage
vise directement sa destination finale.

TeleportTo n'est pas concerne : il fixe une position sans animation.

REFERENCE : 0 sur mount_windswept_entrance_ch_5.lua.

Usage : python3 tools/audit_micro_moves.py [fichier.lua]
"""
import re
import sys

DEFAULT = ('Data/Script/halcyon/ground/mount_windswept_entrance/'
           'mount_windswept_entrance_ch_5.lua')

MOVE = re.compile(r'(MoveToPosition|EightWayMove\w*|TeleportTo)'
                  r'\(\s*([\w.\[\]]+)\s*,\s*(\d+)\s*,\s*(\d+)')
FUNC = re.compile(r'^function\s+[\w.]+')
STEP = 16


def main(path=DEFAULT):
    lines = open(path, encoding='utf-8').read().split('\n')
    pos = {}
    found = []
    for i, line in enumerate(lines, 1):
        # chaque fonction est une scene distincte : on repart a zero
        if FUNC.match(line):
            pos = {}
            continue
        if line.strip().startswith('--'):
            continue
        m = MOVE.search(line)
        if not m:
            continue
        fn, who = m.group(1), m.group(2)
        x, y = int(m.group(3)), int(m.group(4))
        if fn == 'TeleportTo':
            pos[who] = (x, y)
            continue
        src = pos.get(who)
        pos[who] = (x, y)
        if src is None:
            continue
        dist = max(abs(x - src[0]), abs(y - src[1]))
        if dist < STEP:
            found.append((i, who, src, (x, y), dist))

    print('MICRO-DEPLACEMENTS (moins de %d px, soit moins d une case) :'
          % STEP)
    for i, who, src, dst, dist in found:
        print('  L%-5d %-14s %s -> %s   %d px' % (i, who, src, dst, dist))
    print()
    print('-> %d micro-deplacement(s)' % len(found))
    return 1 if found else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1] if len(sys.argv) > 1 else DEFAULT))
