#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_detours.py — DETECTE LES TRAJECTOIRES QUI N'ONT PAS DE RAISON D'ETRE.

Pourquoi cet outil existe
-------------------------
Retour de test : « Coco effectue un detour inutile avant de rejoindre le
groupe. Ce comportement parait artificiel car rien dans l'environnement ne
justifie cette trajectoire. » C'etait exact — et c'est un defaut que j'avais
introduit moi-meme, en contournant un obstacle imaginaire.

Le trajet mesurait 356 px pour rejoindre un point situe a 192 px : la
cuisiniere redescendait plein sud, contournait par l'extreme est, puis
revenait. Aucun obstacle ne le justifiait, et le detour traversait malgre
tout le foyer.

Regle du projet : « Chaque deplacement doit avoir un objectif narratif ou
fonctionnel. Un personnage ne doit jamais effectuer un detour, revenir sur
ses pas, contourner inutilement un obstacle [...]. Si un chemin plus direct
est possible et coherent, il doit etre privilegie. »

Ce que l'outil mesure
---------------------
Pour chaque suite d'appels de deplacement consecutifs sur un meme
personnage, il compare :

    distance PARCOURUE (somme des segments)
    distance DIRECTE   (du depart a l'arrivee, distance de Chebyshev)

Le rapport des deux est le RATIO DE DETOUR. Un ratio de 1.0 signifie une
trajectoire droite ; 1.85 signifiait, pour Coco, presque le double du chemin
necessaire.

Un ratio eleve n'est PAS automatiquement une faute : contourner un dormeur
ou un foyer est legitime. L'outil ne peut pas lire l'intention, il signale
donc les candidats et laisse l'humain trancher — mais il donne l'element
decisif : le detour evite-t-il quelque chose de reel ?

Il verifie donc en plus, quand la carte est identifiable :
  * le trajet DIRECT est-il praticable (sol libre sur toute la ligne) ?
  * si oui, le detour est TRES probablement gratuit -> signale en dur.

Faux positifs connus, et pourquoi ils sont tolerables
-----------------------------------------------------
  * un personnage qui fait volontairement les cent pas (vie de camp) ;
  * une ronde de garde, ou le detour EST le propos ;
  * un contournement d'un personnage MOBILE, que l'analyse statique ne voit
    pas puisqu'il a bouge entre-temps.
Ces cas restent rares et se reconnaissent d'un coup d'oeil dans le rapport.

Usage :
    python3 tools/audit_detours.py [racine]
Sortie : liste triee par ratio decroissant, code 0 (l'outil informe, il ne
bloque pas — c'est un outil de revue, pas une barriere).
"""
import os, re, sys, json, glob, collections

R = sys.argv[1] if len(sys.argv) > 1 else '.'

# Seuil a partir duquel un trajet merite d'etre regarde. 1.6 a ete choisi
# apres mesure sur la carte du Mont Venteux : les detours legitimes
# (contournement de Hyko, du foyer) plafonnaient a 1.31, celui de Coco
# atteignait 1.85. Le seuil separe donc proprement les deux familles.
SEUIL = 1.6

# Un segment plus court qu'une case (16 px) fait pivoter le sprite sur place
# au lieu de le faire marcher : audit_micro_moves s'en occupe deja, on ne
# double pas le signalement ici.
MOVE = re.compile(
    r'(?:GeneralFunctions\.EightWayMove(?:RS)?|GROUND:MoveToPosition)'
    r'\(\s*([A-Za-z_][\w.]*)\s*,\s*(-?\d+)\s*,\s*(-?\d+)')

def cheb(a, b):
    return max(abs(a[0] - b[0]), abs(a[1] - b[1]))

def load_map(path):
    """Grille d'obstacles de la carte associee au script, si on la trouve."""
    try:
        import io
        d = json.load(io.open(path, encoding='utf-8-sig'))['Object']
        return d['obstacles']
    except Exception:
        return None

def free(ob, px, py):
    tx, ty = px // 8, py // 8
    if tx < 0 or ty < 0 or tx >= len(ob) or ty >= len(ob[0]):
        return False
    return ob[tx][ty]['Tags'] == 0

def walkable(ob, px, py):
    return all(free(ob, px + dx, py + dy)
               for dx in (0, 4, 8, 12, 15) for dy in (0, 4, 8, 12, 15))

def line_clear(ob, a, b, n=120):
    """Le trajet direct est-il praticable de bout en bout ?"""
    for i in range(n + 1):
        p = (a[0] + (b[0] - a[0]) * i // n, a[1] + (b[1] - a[1]) * i // n)
        if not walkable(ob, *p):
            return False
    return True

def map_for(script_path):
    """Carte correspondant a un script ground/<nom>/<nom>_ch_N.lua."""
    parts = script_path.replace('\\', '/').split('/')
    if 'ground' not in parts:
        return None
    name = parts[parts.index('ground') + 1]
    cand = os.path.join(R, 'Data', 'Ground', name + '.rsground')
    return cand if os.path.isfile(cand) else None

rows = []
for f in sorted(glob.glob(os.path.join(R, 'Data/Script/**/*.lua'), recursive=True)):
    src = open(f, encoding='utf-8', errors='replace').read()
    lines = src.split('\n')
    ob = None
    loaded = False

    runs = []            # [(ligne, personnage, [(x,y), ...])]
    cur_who = None
    cur_pts = []
    cur_line = 0
    last_line = -99

    # FRONTIERES DE FONCTION. Sans ce garde-fou, l'outil agrege les
    # deplacements de DEUX fonctions voisines en un seul trajet et invente
    # un detour qui n'existe pas. Cas reel : les quatre helpers
    # ApprenticeLeave* du hall de guilde, qui se suivent dans le fichier,
    # etaient lus comme une trajectoire unique de ratio 13.38 — alors que
    # chacun fait deux segments parfaitement droits, et qu'ils ne sont
    # jamais joues a la suite.
    BOUNDARY = re.compile(r'^\s*(?:local\s+)?function\b|^\s*end\s*$')

    for i, l in enumerate(lines, 1):
        # un commentaire pur ne casse pas une serie de deplacements
        stripped = l.strip()
        if stripped.startswith('--'):
            continue
        if BOUNDARY.match(l):
            if cur_who and len(cur_pts) >= 3:
                runs.append((cur_line, cur_who, cur_pts))
            cur_who, cur_pts = None, []
            continue
        m = MOVE.search(l)
        if m:
            who, x, y = m.group(1), int(m.group(2)), int(m.group(3))
            # meme personnage et pas trop loin dans le fichier => meme trajet
            if who == cur_who and i - last_line <= 8:
                cur_pts.append((x, y))
            else:
                if cur_who and len(cur_pts) >= 3:
                    runs.append((cur_line, cur_who, cur_pts))
                cur_who, cur_pts, cur_line = who, [(x, y)], i
            last_line = i
    if cur_who and len(cur_pts) >= 3:
        runs.append((cur_line, cur_who, cur_pts))

    for line, who, pts in runs:
        parcouru = sum(cheb(a, b) for a, b in zip(pts, pts[1:]))
        direct = cheb(pts[0], pts[-1])
        if direct < 24:          # trajet trop court pour parler de detour
            continue
        ratio = parcouru / direct

        # DEMI-TOUR : un axe parcouru dans un sens PUIS dans l'autre.
        #
        # Le seul ratio ne suffit pas. La position de depart reelle d'un
        # personnage n'est presque jamais ecrite dans le trajet (elle vient
        # d'un TeleportTo pose ailleurs, ou de la scene precedente) : le
        # premier waypoint EST deja souvent le debut du detour, ce qui
        # ecrase le ratio. Mesure sur le cas Coco : 1.85 avec le vrai
        # depart, mais seulement 1.45 avec les waypoints ecrits — sous le
        # seuil, donc invisible.
        #
        # Un demi-tour, lui, se lit dans les waypoints seuls : le
        # personnage descend puis remonte (ou va a droite puis a gauche)
        # sur le meme axe. C'est la signature d'un contournement, et si le
        # decor ne l'impose pas, c'est un detour gratuit.
        demi_tour = None
        for axe, nom in ((1, 'vertical'), (0, 'horizontal')):
            deltas = [b[axe] - a[axe] for a, b in zip(pts, pts[1:])]
            deltas = [d for d in deltas if abs(d) >= 16]
            for d1, d2 in zip(deltas, deltas[1:]):
                if d1 * d2 < 0 and min(abs(d1), abs(d2)) >= 24:
                    demi_tour = nom
                    break
            if demi_tour:
                break

        # Un demi-tour n'est un defaut que si le trajet est AUSSI rallonge.
        # Contre-exemple mesure : ModifiedApprenticeLeaveBottom du hall de
        # guilde ("path around shuca and ganlon") fait un crochet vertical
        # pour eviter deux personnages, mais son ratio vaut exactement 1.00
        # — le crochet ne coute pas un pixel de plus que la ligne droite,
        # parce qu'il se fait en diagonale. C'est du contournement propre,
        # pas un detour. On exige donc un allongement reel (5 %) en plus du
        # demi-tour.
        if ratio < SEUIL and not (demi_tour and ratio >= 1.05):
            continue

        # Le direct est-il praticable ? On ne charge la carte que si besoin.
        verdict = 'a verifier'
        if not loaded:
            mp = map_for(f)
            ob = load_map(mp) if mp else None
            loaded = True
        if ob is not None:
            verdict = ('DETOUR GRATUIT (le direct passe)'
                       if line_clear(ob, pts[0], pts[-1])
                       else 'contournement justifie par le decor')

        if demi_tour:
            verdict += ' | DEMI-TOUR ' + demi_tour
        rows.append((ratio, os.path.relpath(f, R), line, who,
                     len(pts), parcouru, direct, verdict))

rows.sort(reverse=True)

print('=' * 78)
print(' AUDIT DES DETOURS — trajectoires sans justification'.center(78))
print('=' * 78)
print()
if not rows:
    print('  Aucun trajet au-dessus du seuil de %.1f.' % SEUIL)
else:
    print('  %-46s %5s %6s %6s' % ('fichier:ligne  personnage', 'ratio', 'parc.', 'direct'))
    print('  ' + '-' * 74)
    for ratio, f, line, who, n, parc, direct, verdict in rows:
        tag = os.path.basename(f) + ':' + str(line) + '  ' + who
        print('  %-46s %5.2f %6d %6d' % (tag[:46], ratio, parc, direct))
        print('      %d segments — %s' % (n, verdict))
print()
print('-' * 78)
gratuits = [r for r in rows if 'GRATUIT' in r[7] or 'DEMI-TOUR' in r[7]]
print('RESULTAT : %d trajet(s) au-dessus du seuil, dont %d sans justification'
      % (len(rows), len(gratuits)))
print('-' * 78)
