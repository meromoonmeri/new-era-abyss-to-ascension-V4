#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Detecte les cartes qui peuvent AFFICHER LEUR DECOR avant leur cinematique.

POURQUOI CET OUTIL
==================
Retour de jeu, deux fois de suite : « le fond noir n'est pas maintenu, on
revoit le ground du tunnel avant d'arriver au Mont ».

La premiere correction (poser le FadeOut en tete de la cinematique) n'a
pas suffi, et la lecture du moteur explique pourquoi.

SEQUENCE DU MOTEUR (RogueCollab/RogueEssence, lue dans la source)
------------------------------------------------------------------
    GameManager.moveToZoneInit:770-775
        GroundScene.EnterGround(entryPoint)   <- GSceneZone.cs:22
            -> ResetGround()                  <- ViewCenter = null,
                                                 la camera SAUTE
        InitGround()   -> appelle Init(map) du script
        // « no fade; the script handles that itself »
        BeginGround()  -> appelle Enter(map) -> PlotScripting
                          -> seulement ICI la cinematique

Trois consequences :
  1. la carte est chargee et la camera repositionnee AVANT Enter() ;
  2. le moteur ne pose AUCUN fondu de lui-meme — il laisse a l'ecran ce
     que le script precedent y avait laisse ;
  3. tout FadeOut ecrit dans la cinematique arrive donc APRES le premier
     rendu possible.

Autrement dit : une carte dont la cinematique commence par un FadeIn
SUPPOSE un ecran noir a l'arrivee. Si rien ne le garantit dans Init(map),
le joueur voit le decor et le saut de camera pendant une poignee
d'images. C'est exactement le symptome decrit.

CE QUE L'OUTIL VERIFIE
======================
Pour chaque ground/<carte>/init.lua :
  * PlotScripting route-t-il vers des scenes qui ouvrent par un FadeIn
    (donc qui supposent le noir) ?
  * si oui, Init(map) pose-t-il GAME:FadeOut avant tout le reste ?

LE CORRECTIF TYPE
=================
    function <carte>.Init(map)
      ...
      if <la scene qui va suivre commence dans le noir> then
        pcall(function() GAME:FadeOut(false, 1) end)
      end
      COMMON.RespawnAllies()
      ...
    end

FadeOut(false, 1) est instantane et idempotent : si l'ecran est deja
noir — le cas normal, la carte precedente l'a laisse ainsi — il ne
produit rien de visible.

CONDITIONNER EST OBLIGATOIRE : noircir une entree normale (retour de
donjon, promenade) dont PlotScripting ne fait qu'un FadeIn(20) laisserait
l'ecran noir une demi-seconde sans raison.

ETAT AU 2026-08-02 : 23 cartes signalees, DETTE PREEXISTANTE
=============================================================
Les deux cartes de la transition signalee en jeu sont corrigees :

    searing_crucible            protege
    mount_windswept_entrance    protege (et son ArrivalCutscene pose
                                deja son propre FadeOut en tete)

Les 23 autres portent le meme defaut latent depuis l'origine du projet.
Les plus exposees sont celles qui enchainent une transition scenarisee :

    searing_tunnel_entrance   DiedCutscene, EscapedCutscene, Retreat...
    vast_steppe_entrance      ArrivalCutscene, FailedCutscene
    relic_forest              Intro_Cutscene, PartnerFindsHeroCutscene
    guild_third_floor_lobby   BeforeFirstDinner, GoToGuildmasterRoom
    *_midpoint (x4)           FirstArrival, WipedCutscene

Ce n'est PAS une regression : ces cartes n'ont jamais eu de garde-fou.
Le defaut ne se voit que si la carte precedente a laisse l'ecran clair,
ce qui depend du chemin emprunte. A traiter par lots, en appliquant le
correctif type ci-dessus et en re-mesurant.

Usage : python3 tools/verify_scene_fades.py [racine]
"""
import glob
import os
import re
import sys


def strip_comments(src):
    src = re.sub(r'--\[\[.*?\]\]', '', src, flags=re.S)
    return '\n'.join(l.split('--')[0] for l in src.split('\n'))


def body_of(src, name):
    """Corps d'une fonction Lua de premier niveau, ou ''."""
    m = re.search(r'^function\s+[\w.]*\.?%s\s*\(' % re.escape(name),
                  src, re.M)
    if not m:
        return ''
    start = m.end()
    nxt = re.search(r'^function\s', src[start:], re.M)
    return src[start:start + nxt.start()] if nxt else src[start:]


def main(root='.'):
    rows = []
    for init in sorted(glob.glob(
            os.path.join(root, 'Data/Script/halcyon/ground/*/init.lua'))):
        ground = os.path.basename(os.path.dirname(init))
        raw = open(init, encoding='utf-8', errors='replace').read()
        src = strip_comments(raw)

        plot = body_of(src, 'PlotScripting')
        if not plot:
            continue

        # Les scenes appelees par PlotScripting, dans le fichier de chapitre.
        called = set(re.findall(r'_ch_\d+\.(\w+)\s*\(', plot))
        if not called:
            continue

        opens_dark = []
        for scene_file in glob.glob(os.path.join(
                os.path.dirname(init), '*_ch_*.lua')):
            ssrc = strip_comments(
                open(scene_file, encoding='utf-8', errors='replace').read())
            for name in called:
                b = body_of(ssrc, name)
                if not b:
                    continue
                fi = b.find('GAME:FadeIn')
                fo = b.find('GAME:FadeOut')
                # Il faut un FadeIn non precede d'un FadeOut...
                if fi < 0 or (0 <= fo < fi):
                    continue
                head = b[:fi]

                # ...MAIS ce n'est pas suffisant. Faux positif mesure :
                # la quasi-totalite des SetupGround se terminent par un
                # FadeIn(20) apres avoir simplement pose leurs PNJ. C'est
                # le fonctionnement NORMAL d'une entree de carte, pas une
                # cinematique — l'ecran n'a aucune raison d'etre noir
                # avant. Sans ce filtre l'outil sortait 38 alertes dont
                # l'immense majorite legitimes.
                #
                # Une VRAIE cinematique se reconnait a ceci : elle joue du
                # contenu (dialogue, camera, deplacement scenarise) AVANT
                # de lever le fondu. C'est ce contenu-la que le joueur
                # verrait se derouler sur un decor visible.
                if not re.search(r'WaitShowDialogue|WaitShowVoiceOver'
                                 r'|MoveCamera|MoveToPosition|EightWayMove',
                                 head):
                    continue
                opens_dark.append(name)

        if not opens_dark:
            continue

        init_body = body_of(src, 'Init')
        guarded = 'GAME:FadeOut' in init_body
        rows.append((ground, sorted(set(opens_dark)), guarded))

    print('%-34s %-9s %s' % ('carte', 'Init', 'scenes qui supposent le noir'))
    print('-' * 88)
    bad = 0
    for ground, scenes, guarded in rows:
        flag = 'protege' if guarded else '*** NON ***'
        if not guarded:
            bad += 1
        print('%-34s %-9s %s' % (ground[:34], flag, ', '.join(scenes)[:38]))
    print('-' * 88)
    if bad:
        print('RESULTAT : %d carte(s) peuvent afficher leur decor avant la '
              'cinematique' % bad)
        return 1
    print('RESULTAT : TOUTES LES CARTES CONCERNEES POSENT LE NOIR DANS Init')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1] if len(sys.argv) > 1 else '.'))
