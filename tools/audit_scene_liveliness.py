#!/usr/bin/env python3
"""Mesure le STATISME des cinematiques : qui parle sans que personne ne bouge.

POURQUOI CET OUTIL EXISTE
=========================
Aucun controle du depot ne regardait la mise en scene. On verifiait que les
positions etaient valides (verify_scene_positions), que les ancres etaient
atteignables (verify_ground_reachability), que les cles existaient
(audit_integrite) — mais rien ne disait si les personnages BOUGEAIENT.

Mesure faite sur mount_windswept_entrance_ch_5.lua avant correction :

    ArrivalCutscene          18 repliques, 17 statiques  (94 %)
    CampNightfall            66 repliques, 15 statiques  (22 %)
    WindSecretScene           8 repliques,  4 statiques  (50 %)
    LegendOfTheSkyArbiter     2 repliques,  2 statiques (100 %)
    -------------------------------------------------------------
    TOTAL                    99 repliques, 40 statiques  (40 %)

Quarante pour cent des boites de dialogue de la carte s'affichaient devant
des sprites parfaitement immobiles, qui ne se tournaient meme pas vers celui
qui parlait. C'est invisible pour un lecteur du code — chaque replique est
correcte prise isolement — et flagrant manette en main.

CE QUE L'OUTIL CONSIDERE COMME UNE REACTION
===========================================
Dans les 7 lignes qui precedent un UI:SetSpeaker, il cherche l'un de :
rotation (CharTurnToChar*, CharAnimateTurnTo, EntTurn, FaceMovingCharacter),
emote (CharSetEmote, EmoteAndPause), animation (CharSetAnim, DoAnimation,
Hop, Shake, LookAround), deplacement (MoveToPosition, EightWayMove), effet
d'ecran (MoveScreen, Nausea), ou un helper de mise en scene (Listen, Says).

FAUX POSITIFS CONNUS, ET POURQUOI ON LES LAISSE
===============================================
Le compte ne descend pas a zero, et c'est normal. Restent legitimement :

  * les repliques jouees SOUS UN ECRAN NOIR (entre un FadeOut et un FadeIn) :
    aucun sprite n'est visible, aucun geste n'aurait de sens. C'est le cas
    de l'ouverture de mount_windswept (MWE5_001/002) ;
  * les VOIX OFF sans locuteur (la Voix anonyme \\uE040, les pensees du
    heros en UI:SetCenter) : il n'y a personne a l'ecran a faire bouger ;
  * les DEFINITIONS de helpers locaux qui contiennent un SetSpeaker dans
    leur corps — l'outil les compte une fois, la reaction est chez
    l'appelant.

Reference apres correction sur mount_windswept_entrance_ch_5.lua :
89 repliques, 9 statiques (10 %), toutes verifiees appartenir aux trois
categories ci-dessus. Le fichier ne figure plus dans le classement des
25 pires.

ETAT DU RESTE DU MOD — MESURE, NON TRAITE
=========================================
Passe sur tout Data/Script/halcyon, l'outil sort au 2026-07-29 :

    TOTAL : 1947 repliques, 987 statiques (50 %)

La moitie des dialogues du mod s'affiche donc devant des sprites qui ne
reagissent pas. Les pires :

    vast_steppe_midpoint_ch_5        33 repliques, 28 statiques (84 %)
    mount_windswept_midpoint_ch_5    27 repliques, 26 statiques (96 %)
    vast_steppe_guardian_ch_5        17 repliques, 14 statiques (82 %)
    searing_tunnel_entrance_ch_5     98 repliques, 41 statiques (41 %)
    vast_steppe_entrance_ch_5        72 repliques, 36 statiques (50 %)

C'est une DETTE CONNUE, pas une regression : ces chiffres sont anterieurs
au travail en cours. Le patron de correction est etabli (helpers Listen /
Says, cf. mount_windswept_entrance_ch_5.lua) et se transpose tel quel.
Traiter par lots, carte par carte, en re-mesurant a chaque fois.

Usage :
    python3 tools/audit_scene_liveliness.py [racine] [--details]
"""
import glob
import os
import re
import sys

REACT = re.compile(
    r'TurnToChar|CharAnimateTurnTo|EntTurn|FaceMovingCharacter'
    r'|CharSetEmote|EmoteAndPause'
    r'|CharSetAnim|DoAnimation|Hop\(|Shake\(|LookAround'
    r'|MoveToPosition|EightWayMove'
    r'|MoveScreen|Nausea'
    r'|Listen\(|ListenA\(|Says\(|SaysA\('
)
SPEAKER = re.compile(r'UI:SetSpeaker\(')
FUNC = re.compile(r'^function\s+([\w.]+)')
WINDOW = 7


def scan(path):
    """Renvoie {fonction: (total, statiques, [lignes])} pour un fichier."""
    try:
        lines = open(path, encoding='utf-8').read().split('\n')
    except Exception:
        return {}

    # bornes de chaque fonction
    marks = [(i, m.group(1)) for i, l in enumerate(lines)
             for m in [FUNC.match(l)] if m]
    if not marks:
        marks = [(0, os.path.basename(path))]
    marks.append((len(lines), None))

    out = {}
    for (start, name), (end, _) in zip(marks, marks[1:]):
        body = lines[start:end]
        total = static = 0
        where = []
        for i, l in enumerate(body):
            code = l.split('--')[0]
            if not SPEAKER.search(code) or 'ResetSpeaker' in code:
                continue
            total += 1
            lo = max(0, i - WINDOW)
            ctx = '\n'.join(x.split('--')[0] for x in body[lo:i + 3])
            if not REACT.search(ctx):
                static += 1
                where.append(start + i + 1)
        if total:
            out[name] = (total, static, where)
    return out


def main(root='.', details=False):
    pattern = os.path.join(root, 'Data/Script/halcyon/**/*.lua')
    rows = []
    gt = gs = 0
    for path in sorted(glob.glob(pattern, recursive=True)):
        res = scan(path)
        ft = sum(v[0] for v in res.values())
        fs = sum(v[1] for v in res.values())
        if ft == 0:
            continue
        gt += ft
        gs += fs
        if fs:
            rows.append((fs, ft, os.path.relpath(path, root), res))

    rows.sort(reverse=True)
    print('%-58s %8s %9s %6s' % ('fichier', 'repliq.', 'statiques', '%'))
    print('-' * 85)
    for fs, ft, rel, res in rows[:25]:
        print('%-58s %8d %9d %5d%%' % (rel[-58:], ft, fs, 100 * fs // ft))
        if details:
            for name, (t, s, where) in sorted(res.items(),
                                              key=lambda x: -x[1][1]):
                if s:
                    print('      %-46s %3d/%-3d  lignes %s'
                          % (name, s, t, where[:8]))
    print('-' * 85)
    print('TOTAL : %d repliques, %d statiques (%d%%)'
          % (gt, gs, 100 * gs // gt if gt else 0))
    print()
    print('Rappel : un reste non nul est ATTENDU (ecran noir, voix off,')
    print('definitions de helpers). Voir l en-tete du fichier.')
    return 0


if __name__ == '__main__':
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    sys.exit(main(args[0] if args else '.', '--details' in sys.argv))
