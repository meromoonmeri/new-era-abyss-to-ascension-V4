#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
clean_comments.py — allege les commentaires d'un script de cinematique.

POURQUOI
========
Le fichier du Mont Venteux comptait 4744 lignes, dont 1741 de commentaires
(36 %). L'essentiel n'etait pas de la documentation utile, mais un JOURNAL
DE BUGS accumule au fil des sessions : « BUG VU EN JEU : ... », suivi de
vingt lignes d'analyse du moteur, de numeros de ligne C#, et du
raisonnement ayant mene au correctif.

Cette matiere a sa place dans les messages de commit et dans docs/, pas
dans le corps d'une scene. A comparer avec Halcyon : leurs cinematiques
commentent l'INTENTION NARRATIVE en une ou deux lignes, jamais l'historique
des corrections.

CE QUI EST SUPPRIME
  - les blocs de separation faits de tirets (--------)
  - les blocs de post-mortem : un commentaire qui ouvre sur BUG, CORRIGE,
    CAUSE, PREUVE, VERIFIE, ERREUR... et tout son paragraphe
  - les references au code du moteur (fichier.cs:123)
  - les commentaires vides

CE QUI EST CONSERVE
  - toute ligne de CODE, sans exception
  - les commentaires narratifs et d'intention
  - les commentaires de tete de fichier (les 12 premieres lignes)
  - toute ligne contenant du code commente (pour ne rien perdre)

GARANTIE
  Le script ne touche JAMAIS a une ligne de code. La verification se fait
  avec tools/dialogue_signature.py : l'empreinte du rythme doit rester
  strictement identique avant et apres.

Usage
-----
    python3 tools/clean_comments.py <fichier.lua> [--ecrire]
Sans --ecrire, affiche seulement ce qui serait retire.
"""
import re
import sys

# Un commentaire dont la premiere ligne contient un de ces marqueurs ouvre
# un bloc de post-mortem : on retire le bloc entier.
MARQUEURS = re.compile(
    r'\b(BUG|CORRIGE|CORRIGÉ|CAUSE|PREUVE|PROUVE|PROUVÉ|VERIFIE|VÉRIFIÉ|'
    r'ERREUR|POURQUOI CE|CE QUI NE MARCHAIT|AVANT, |Origine de l|'
    r'BLOQUANT|piege|PIEGE|PIÈGE|regression|RÉGRESSION|'
    r'signale en jeu|SIGNALE|VU EN JEU|constate en jeu)\b',
    re.IGNORECASE)

# Reference a un fichier source du moteur : GroundScene.cs:165
REF_MOTEUR = re.compile(r'\b\w+\.cs:\d+')

# Ligne de separation : --- ou ==== etc.
SEPARATEUR = re.compile(r'^\s*--[-=]{4,}\s*$')

# Du code Lua mis en commentaire : on garde, ca peut resservir.
CODE_COMMENTE = re.compile(
    r'--\s*(GAME:|GROUND:|UI:|SOUND:|TASK:|AI:|local |function |if |for )')

TETE = 12  # les premieres lignes decrivent le fichier : on n'y touche pas


def nettoyer(chemin):
    lignes = open(chemin, encoding='utf-8').read().split('\n')
    garder = [True] * len(lignes)

    i = 0
    while i < len(lignes):
        nu = lignes[i].strip()
        if i < TETE or not nu.startswith('--'):
            i += 1
            continue

        if CODE_COMMENTE.search(nu):
            i += 1
            continue

        # Separateur seul
        if SEPARATEUR.match(nu):
            garder[i] = False
            i += 1
            continue

        # Reference au moteur : ligne retiree isolement
        if REF_MOTEUR.search(nu):
            garder[i] = False
            i += 1
            continue

        # Ouverture d'un bloc de post-mortem : on prend tout le paragraphe
        # de commentaire consecutif.
        if MARQUEURS.search(nu):
            j = i
            while j < len(lignes):
                s = lignes[j].strip()
                if not s.startswith('--'):
                    break
                if CODE_COMMENTE.search(s):
                    break
                garder[j] = False
                j += 1
            i = j
            continue

        i += 1

    # Commentaires devenus vides (-- seul) laisses par le passage ci-dessus
    for k, l in enumerate(lignes):
        if garder[k] and k >= TETE and re.match(r'^\s*--\s*$', l):
            garder[k] = False

    resultat = [l for k, l in enumerate(lignes) if garder[k]]

    # Compacte les series de plus de deux lignes vides
    compact = []
    vides = 0
    for l in resultat:
        if not l.strip():
            vides += 1
            if vides > 1:
                continue
        else:
            vides = 0
        compact.append(l)

    return lignes, compact


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    chemin = sys.argv[1]
    avant, apres = nettoyer(chemin)

    def stats(L):
        c = sum(1 for l in L if l.strip().startswith('--'))
        v = sum(1 for l in L if not l.strip())
        return len(L), c, v, len(L) - c - v

    ta, ca, va, coda = stats(avant)
    tb, cb, vb, codb = stats(apres)

    print('%s' % chemin)
    print('  avant : %5d lignes  (%d commentaires, %d vides, %d code)'
          % (ta, ca, va, coda))
    print('  apres : %5d lignes  (%d commentaires, %d vides, %d code)'
          % (tb, cb, vb, codb))
    print('  retire: %5d lignes de commentaire' % (ca - cb))
    if coda != codb:
        print('  !! ALERTE : le nombre de lignes de CODE a change '
              '(%d -> %d). Rien n a ete ecrit.' % (coda, codb))
        return 1

    if '--ecrire' in sys.argv:
        open(chemin, 'w', encoding='utf-8').write('\n'.join(apres))
        print('  -> ecrit')
    else:
        print('  (essai a blanc ; ajouter --ecrire pour appliquer)')
    return 0


if __name__ == '__main__':
    sys.exit(main())
