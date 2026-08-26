#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""red_compile_cinematics.py — compilateur cinématiques PMD Red EU → Lua
PMDO (modèle sky_compile_scenes.py, FAIL-CLOSED).

Sources canoniques (jamais approximées) :
  * Cinematics/dialogues/<ground>.json.gz — dialogue_ops décodés octet par
    octet de la ROM EU (69 stations), ordonnés par (script, command_index) :
    C'EST LE SEUL ORDRE PROUVÉ. Textes 5 langues ROM embarqués.
  * Cinematics/<ground>.cif.json — couche Audio/Effect/Camera/Animation.
    L'entrelacement exact avec les dialogues n'est PAS décodé : seule la
    piste BGM d'OUVERTURE (premier Audio SWITCH) est jouée, via la table
    STRICTE MUS_→ogg issue des extractions ROM (status PASS uniquement).
    Toutes les autres ops du cif sont comptées PARTIAL_OPS — jamais
    traduites en chorégraphie inventée, jamais ignorées silencieusement.

Règle fail-closed :
  * ground sans dialogue_ops → NOT_COMPILED_NO_DIALOGUE (pas de scène vide).
  * op de dialogue non-MSG inconnue → la scène reste compilée mais l'op est
    listée dans PARTIAL_OPS avec son opcode.
  * MUS_ hors table ROM → GAP tracé en commentaire, pas de piste substituée.

Sortie : Data/Script/halcyon/redscenes/<ground>__station.lua
         (signature function(hero, partner), kit partagé skyscenes.kit)
Rapport : PMD_RED_RESCUE_TEAM/Docs/RED_SCENE_COMPILER_REPORT.json
"""
import gzip
import json
import os
import re

ROOT = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CIN = os.path.join(ROOT, 'dev', 'CAMPAIGNS', 'PMD_RED_RESCUE_TEAM',
                   'Cinematics')
OUT_DIR = os.path.join(ROOT, 'Data', 'Script', 'halcyon', 'redscenes')
REPORT = os.path.join(ROOT, 'dev', 'CAMPAIGNS', 'PMD_RED_RESCUE_TEAM',
                      'Docs', 'RED_SCENE_COMPILER_REPORT.json')
AUDIO_DIR = os.path.join(ROOT, 'dev', 'docs', 'canonical', 'red', 'audio')
MUSIC_DIR = os.path.join(ROOT, 'Content', 'Music')

# table STRICTE MUS_ -> ogg : uniquement les extractions ROM PASS
MUS_MAP = {}
for f in ('pmdred_eu_music_extraction.json',
          'pmdred_eu_music_extraction_wave2.json'):
    p = os.path.join(AUDIO_DIR, f)
    if not os.path.exists(p):
        continue
    for r in json.load(open(p))['results']:
        if r.get('status') == 'PASS' and r.get('output_ogg_name'):
            ogg = r['output_ogg_name'][:-4]
            if os.path.exists(os.path.join(MUSIC_DIR, ogg + '.ogg')):
                MUS_MAP[r['music_name']] = ogg

# opcodes dialogues (décodage EU) : D0/D1 = boîtes de message par variantes,
# D3 = question (menu oui/non NDS — rendu: dialogue simple, choix non
# simulé => compté PARTIAL), D9 = message standard.
MSG_OPS = {'0xD0', '0xD1', '0xD9'}
QUESTION_OPS = {'0xD3'}


def _unmark(m):
    # ~XX = octet littéral échappé par l'extracteur : caractère imprimable
    # restitué tel quel (ex. ~27 = apostrophe) ; contrôles → espace.
    b = int(m.group(1), 16)
    return chr(b) if 0x20 <= b < 0x7F else ' '


def clean_text(s):
    if s is None:
        return None
    s = re.sub(r'~([0-9A-Fa-f]{2})', _unmark, s)
    # #W = pause GBA (wait), #C/#R = contrôles couleur/reset → retirés
    s = s.replace('#W', ' ').replace('#C', '').replace('#R', '')
    # $n0 = héros, $n1.. = interlocuteurs (résolution runtime kit) :
    # $n0 → [hero], autres → retirés (PARTIAL, noms de cast non résolus ici)
    s = s.replace('$n0', '[hero]')
    s = re.sub(r'\$[a-z][0-9]?', '', s)
    s = s.replace('\\n', ' ').replace('\n', ' ')
    s = re.sub(r'\s+', ' ', s).strip()
    return s


def lua_str(s):
    return '"' + (s or '').replace('\\', '\\\\').replace('"', '\\"') + '"'


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    grounds = sorted(f[:-8] for f in os.listdir(os.path.join(
        CIN, 'dialogues')) if f.endswith('.json.gz'))
    report = {'schema': 'red_scene_compiler.v1',
              'rule': ('FAIL-CLOSED: ordre = (script, command_index) ROM ; '
                       'ops cif non ordonnancées = PARTIAL_OPS, jamais '
                       'chorégraphie inventée ; MUS_ hors table ROM = GAP'),
              'mus_map_size': len(MUS_MAP),
              'totals': {}, 'scenes': {}}
    n_comp = n_skip = 0
    for gid in grounds:
        dp = os.path.join(CIN, 'dialogues', gid + '.json.gz')
        dj = json.load(gzip.open(dp))
        ops = dj.get('dialogue_ops') or []
        if not ops:
            report['scenes'][gid] = {'status': 'NOT_COMPILED_NO_DIALOGUE'}
            n_skip += 1
            continue
        # ordre prouvé : script puis command_index
        ops = sorted(ops, key=lambda o: (o['script'], o['command_index']))
        partial = []
        lines = []
        lines.append('-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — '
                     'NE PAS ÉDITER À LA MAIN.')
        lines.append(f'-- Station canonique PMD Red EU : ground {gid} '
                     f'(dialogues ROM {dj.get("header_address")}).')
        lines.append('-- Ordre = (script, command_index) ROM. Textes 5 '
                     'langues ROM. Ops cif non ordonnancées: voir rapport.')
        lines.append("local SkySceneKit = require 'halcyon.skyscenes.kit'")
        lines.append('return function(hero, partner)')
        # BGM d'ouverture depuis le cif (table stricte)
        cifp = os.path.join(CIN, gid + '.cif.json')
        bgm_note = None
        cif_ops = []
        if os.path.exists(cifp):
            cif = json.load(open(cifp))
            cif_ops = cif.get('raw_sequence') or []
            first_sw = next((o for o in cif_ops
                             if o.get('type') == 'Audio'
                             and o.get('action') == 'SWITCH'), None)
            if first_sw:
                tr = first_sw.get('track')
                if tr in MUS_MAP:
                    lines.append('  pcall(function() SOUND:PlayBGM('
                                 + lua_str(MUS_MAP[tr])
                                 + ', true) end)')
                    bgm_note = f'{tr} -> {MUS_MAP[tr]}.ogg (extraction ROM)'
                else:
                    bgm_note = f'GAP: {tr} hors table ROM stricte'
                    lines.append(f'  -- BGM {tr}: GAP (pas d\'ogg extrait '
                                 'ROM vérifié) — aucune piste substituée')
        lines.append('  pcall(function() UI:ResetSpeaker() end)')
        n_msgs = 0
        for o in ops:
            op = o.get('op')
            blk = o.get('block') or {}
            langs = blk.get('languages') or {}
            texts = {k: clean_text(v.get('text'))
                     for k, v in langs.items() if v.get('text')}
            if not texts:
                partial.append(f'{op}@{o.get("command_address")} sans texte')
                continue
            if op in MSG_OPS or op in QUESTION_OPS:
                t = ('{english=' + lua_str(texts.get('en', ''))
                     + ', french=' + lua_str(texts.get('fr', ''))
                     + ', german=' + lua_str(texts.get('de', ''))
                     + ', italian=' + lua_str(texts.get('it', ''))
                     + ', spanish=' + lua_str(texts.get('es', '')) + '}')
                lines.append(f'  SkySceneKit.say({t})')
                n_msgs += 1
                if op in QUESTION_OPS:
                    partial.append(
                        f'{op} question: menu oui/non NDS non simulé '
                        '(texte affiché, choix par défaut)')
            else:
                partial.append(f'{op} opcode dialogue non traduit')
        lines.append('end')
        # ops cif restantes = non ordonnancées
        for o in cif_ops:
            ty, ac = o.get('type'), o.get('action')
            if ty == 'Audio' and ac == 'SWITCH':
                continue  # première déjà traitée; suivantes ↓
            partial.append(f'cif {ty}:{ac or o.get("anim_id")} '
                           'non ordonnancée vs dialogues')
        if n_msgs == 0:
            report['scenes'][gid] = {'status': 'NOT_COMPILED_NO_TEXT'}
            n_skip += 1
            continue
        with open(os.path.join(OUT_DIR, f'{gid}__station.lua'), 'w',
                  encoding='utf-8') as f:
            f.write('\n'.join(lines) + '\n')
        report['scenes'][gid] = {
            'status': 'COMPILED',
            'messages': n_msgs,
            'bgm': bgm_note,
            'partial_ops': partial,
        }
        n_comp += 1
    report['totals'] = {'COMPILED': n_comp, 'SKIPPED': n_skip,
                        'grounds_with_dialogues': len(grounds)}
    os.makedirs(os.path.dirname(REPORT), exist_ok=True)
    with open(REPORT, 'w', encoding='utf-8') as f:
        json.dump(report, f, ensure_ascii=False, indent=1)
    print(f'COMPILED={n_comp} SKIPPED={n_skip} '
          f'(sur {len(grounds)} grounds à dialogues) ; '
          f'table MUS stricte: {len(MUS_MAP)} pistes')


if __name__ == '__main__':
    main()
