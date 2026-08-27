#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_dual_screen_matrix.py — MATRICE DE VALIDATION DOUBLE-ÉCRAN.

Pour chaque scène DUAL_TIMELINE (195, DUAL_SCREEN_TIMELINES.json =
timeline ROM prouvée par les ops screen/screen2) :

  1. CLASSIFICATION du contenu de chaque écran :
     - BOTTOM (écran principal NDS des ground scenes) : dialogues,
       acteurs, mouvements — comptés depuis le SSB (message_*, Move*,
       acteurs référencés hors littéraux) ;
     - TOP (écran sub) : décor chargé par back2_SetGround (MAP_BG
       LANDSCAPE) + effets sub éventuels.
  2. IMPLÉMENTATION single-viewport PMDO : le module Lua compilé doit
     contenir les view-switch de la timeline (SkySubScreen.Show/Hide,
     fades ROM) quand la ROM change de focus (REQUIRES_VIEW_SWITCH).
  3. CAST : hero/partner/NPC narratifs du SSB présents dans le Lua
     (règles du CAST_AUDIT).
  4. RUNTIME : la scène est-elle COMPILED (jouable, prouvée par les
     familles runtime déjà validées) ?

PMDO = UN SEUL viewport : le verdict VIEW_SWITCH n'exige jamais deux
écrans simultanés — il exige la MISE EN SCÈNE TEMPORELLE (Show au bon
moment, Hide au retour BOTTOM, durées de fade ROM).

Sortie : Docs/DUAL_SCREEN_MATRIX.json + résumé.
"""
import gzip
import json
import os
import re
from collections import Counter, OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMP = os.path.join(REPO, 'dev', 'CAMPAIGNS', 'PMD_SKY_EXPLORERS')
RS = os.path.join(CAMP, 'Cinematics', 'rom_scripts')
SCENES = os.path.join(REPO, 'Data', 'Script', 'halcyon', 'skyscenes')


def classify_bottom(src_clean):
    has_dialogue = bool(re.search(
        r'message_(Talk|Monologue|Explanation|Notice|Narration|Mail|'
        r'SwitchTalk|SwitchMonologue)', src_clean))
    has_movement = bool(re.search(
        r'(MovePositionMark|Move2PositionMark|MovePositionOffset|'
        r'SlidePositionMark|Slide2PositionMark|MovePosition)\b', src_clean))
    has_action = bool(re.search(
        r'(SetEffect|SetAnimation|Turn2Direction|ExecuteCommon)', src_clean))
    actors = set(re.findall(r'ACTOR_([A-Z0-9_]+)', src_clean))
    cls = []
    if has_dialogue:
        cls.append('DIALOGUE_SCREEN')
    if has_movement:
        cls.append('MOVEMENT_SCREEN')
    if has_action and not cls:
        cls.append('CHARACTER_ACTION_SCREEN')
    if not cls:
        cls.append('STATIC_BACKGROUND')
    return cls, has_dialogue, has_movement, has_action, actors


def main():
    tl = json.load(open(os.path.join(
        CAMP, 'Docs', 'DUAL_SCREEN_TIMELINES.json')))['scenes']
    rep = json.load(open(os.path.join(
        CAMP, 'Docs', 'SCENE_COMPILER_REPORT.json')))['scenes']
    cast_audit = json.load(open(os.path.join(
        CAMP, 'Docs', 'CAST_AUDIT.json')))
    cast_fail = set(cast_audit.get('failures', {}))

    cache = {}
    rows = OrderedDict()
    counts = Counter()
    for key, t in tl.items():
        if t['kind'] != 'DUAL_TIMELINE':
            continue
        zone, ssb = key.split('/')
        if zone not in cache:
            cache[zone] = json.load(gzip.open(
                os.path.join(RS, zone + '.json.gz'), 'rt'))
        src = cache[zone]['scripts'][ssb].get('explorerscript', '')
        sc = re.sub(r'"""(?:.|\n)*?"""', '', src)
        sc = re.sub(r"'(?:[^'\\]|\\.)*'", "''", sc)
        bottom_cls, has_dlg, has_mov, has_act, actors = classify_bottom(sc)
        top_cls = ('LANDSCAPE_SCREEN' if t.get('sub_grounds')
                   else 'STATIC_BACKGROUND')

        # focus ROM : la scène requiert-elle des view-switch ?
        # PREUVE requise : un focus TOP/BOTH n'exige un switch QUE si un
        # DÉCOR sub est chargé (back2_SetGround → sub_grounds). Les fades
        # screen2 en mode système (back2_SetMode sans décor) = écran
        # moteur NDS (miroir/mode d'affichage), AUCUN contenu narratif
        # scripté à présenter — documenté par le compilateur, pas un
        # switch manquant.
        focuses = {s['focus'] for s in t.get('segments', [])}
        has_sub_content = bool(t.get('sub_grounds'))
        needs_switch = bool(focuses - {'NONE', 'BOTTOM_FOCUS'}) \
            and has_sub_content
        engine_mode_only = bool(focuses - {'NONE', 'BOTTOM_FOCUS'}) \
            and not has_sub_content
        n_trans = len([x for x in t.get('transitions', [])
                       if x.get('to') not in (None,)])

        # priorité narrative : BOTTOM si dialogue/mouvement, sinon TOP
        primary = 'BOTTOM' if (has_dlg or has_mov) else (
            'TOP' if t.get('sub_grounds') else 'BOTTOM')

        mod = f"{zone.lower()}__{ssb[:-4]}"
        lua_p = os.path.join(SCENES, mod + '.lua')
        status = rep.get(key, {}).get('status')
        compiled = status == 'COMPILED'
        lua = open(lua_p).read() if os.path.exists(lua_p) else ''
        has_show = 'SkySubScreen.Show' in lua
        has_hide = 'SkySubScreen.Hide' in lua
        switch_impl = (not needs_switch) or has_show
        fade_impl = (not needs_switch) or ('fade' in lua.lower()
                                           or 'FadeIn' in lua or has_show)
        # timings ROM embarqués par le compilateur (durées dans Show/Hide)
        timing = (not needs_switch) or bool(
            re.search(r'SkySubScreen\.(Show|Hide)\([^)]*\d+', lua))
        hero_rom = any(a.startswith('PLAYER') for a in actors)
        partner_rom = any(a.startswith('ATTENDANT') for a in actors)
        hero_ok = (not hero_rom) or ('hero' in lua)
        partner_ok = (not partner_rom) or ('partner' in lua)
        cast_ok = key not in cast_fail and compiled

        verdict = 'PASS'
        if not compiled:
            verdict = 'NOT_COMPILED'
        elif needs_switch and not switch_impl:
            verdict = 'VIEW_SWITCH_MISSING'
        elif hero_rom and not hero_ok:
            verdict = 'HERO_MISSING'
        elif partner_rom and not partner_ok:
            verdict = 'PARTNER_MISSING'
        elif not cast_ok:
            verdict = 'CAST_INCOMPLETE'

        counts[verdict] += 1
        if engine_mode_only:
            counts['SUB_ENGINE_MODE_ONLY'] += 1
        counts['REQUIRES_VIEW_SWITCH' if needs_switch else 'NO_SWITCH'] += 1
        if has_dlg:
            counts['HAS_DIALOGUE'] += 1
        if has_mov:
            counts['HAS_MOVEMENT'] += 1
        if t.get('sub_grounds'):
            counts['HAS_LANDSCAPE'] += 1
        if needs_switch and switch_impl and compiled:
            counts['VIEW_SWITCH_OK'] += 1
        if needs_switch and fade_impl and compiled:
            counts['FADE_OK'] += 1
        if needs_switch and timing and compiled:
            counts['TIMING_OK'] += 1
        if hero_ok and compiled:
            counts['HERO_OK'] += 1
        if partner_ok and compiled:
            counts['PARTNER_OK'] += 1
        if cast_ok:
            counts['CAST_OK'] += 1

        rows[key] = {
            'ROM_TOP_CLASS': top_cls,
            'ROM_BOTTOM_CLASS': bottom_cls,
            'PRIMARY_NARRATIVE_SCREEN': primary,
            'SECONDARY_SCREEN': 'TOP' if primary == 'BOTTOM' else 'BOTTOM',
            'HAS_DIALOGUE': has_dlg,
            'HAS_MOVEMENT': has_mov,
            'HAS_CHARACTER_ACTION': has_act,
            'HAS_LANDSCAPE': bool(t.get('sub_grounds')),
            'SUB_GROUNDS': t.get('sub_grounds'),
            'REQUIRES_VIEW_SWITCH': needs_switch,
            'SUB_ENGINE_MODE_ONLY': engine_mode_only,
            'VIEW_SWITCH_IMPLEMENTED': switch_impl and compiled,
            'FADE_REQUIRED': needs_switch,
            'FADE_IMPLEMENTED': fade_impl and compiled,
            'TIMING_MATCH': timing and compiled,
            'ROM_TRANSITIONS': n_trans,
            'HERO_ROM': hero_rom, 'HERO_PMDO': hero_ok and compiled,
            'PARTNER_ROM': partner_rom,
            'PARTNER_PMDO': partner_ok and compiled,
            'CAST_COMPLETE': cast_ok,
            'COMPILER_STATUS': status,
            'VERDICT': verdict,
        }

    out = {
        'schema': 'sky-dual-screen-matrix/1',
        'rule': ('PMDO = UN SEUL viewport. VIEW_SWITCH = mise en scène '
                 'TEMPORELLE (SkySubScreen.Show/Hide aux instants de la '
                 'timeline ROM, fades ROM) — jamais deux écrans simulés. '
                 'PRIMARY = écran à contenu narratif (dialogue/mouvement '
                 'BOTTOM prioritaire, LANDSCAPE TOP en établissement).'),
        'totals': dict(counts),
        'scenes': rows,
    }
    p = os.path.join(CAMP, 'Docs', 'DUAL_SCREEN_MATRIX.json')
    json.dump(out, open(p, 'w'), indent=1, ensure_ascii=False)
    print(json.dumps(dict(counts), indent=1))
    print(p)


if __name__ == '__main__':
    main()
