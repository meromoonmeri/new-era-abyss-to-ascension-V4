#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""build_crystal_sanctuary.py — peuple le Sanctuaire de Cristal.

CONSTAT DE DEPART (mesure, pas supposition)
===========================================
    crystal_sanctuary.json : 0 espece, 0 TeamSpawnZoneStep.
Le donjon du chapitre 8 etait VIDE : aucun Pokemon sauvage sur les
25 etages. Le joueur traversait des couloirs deserts jusqu'au boss.

FORMAT REPRIS DE vast_steppe.json (donjon du mod qui fonctionne,
13 especes) : RogueEssence.LevelGen.TeamSpawnZoneStep, Priority
{"str":[2,2]}, cles Spawns / TeamSizes / SpecificSpawns.

STRUCTURE DEMANDEE
==================
    segment 0  Galerie Cristalline   etages 1-20   avant le point median
    segment 1  Relais                point median  (template creuset)
    segment 2  Salles des Glyphes    etages 21-23  apres le median
    segment 3  Mini-boss
    segment 4  Salles des Glyphes    etages 24-25
    segment 5  Chambre de Diancie

    20 + 5 = 25 etages jouables. Les 5 derniers sont bien APRES le
    point median, repartis 3 + 2 autour du mini-boss.

MUSIQUE (les deux fichiers existent dans Content/Music)
    avant le median : Crystal Cave.ogg
    apres le median : Crystal Crossing.ogg
"""
import json, copy, urllib.request, base64, os, sys

# ---------------------------------------------------------------
# TABLE DES POKEMON — 26 especes, niveaux 15 -> 33
# ---------------------------------------------------------------
# Logique du biome : cristal / roche / gemme / lumiere. Chaque espece
# a une raison d'etre la. Les niveaux montent avec la profondeur.
#
# (espece, lvl_min, lvl_max, etage_min, etage_max, taux, capacites, tactique)
POKEMON = [
    # --- Galerie Cristalline, etages 1-8 : la roche et les petits cristaux
    ('roggenrola',  15, 17,  0,  8, 12, ['tackle','harden','sand_attack','rock_blast'], 'wander_dumb'),
    ('geodude',     15, 17,  0,  8, 12, ['tackle','defense_curl','rock_polish','rollout'], 'wander_dumb'),
    ('zubat',       15, 17,  0,  7, 10, ['leech_life','supersonic','astonish','bite'], 'wander_normal'),
    ('cleffa',      15, 16,  0,  6,  6, ['pound','charm','encore','sing'], 'wander_dumb'),
    ('sableye',     16, 18,  2, 10,  8, ['scratch','leer','night_shade','fury_swipes'], 'wander_normal'),
    ('nosepass',    16, 18,  2, 10,  8, ['tackle','harden','rock_throw','thunder_wave'], 'wander_dumb'),
    ('aron',        16, 18,  1,  9,  9, ['tackle','harden','mud_slap','headbutt'], 'wander_normal'),
    ('carbink',     17, 19,  3, 12,  7, ['tackle','harden','rock_throw','reflect'], 'wander_dumb'),

    # --- Galerie Cristalline, etages 8-16 : la lumiere et le prisme
    ('boldore',     19, 22,  8, 18, 10, ['headbutt','mud_slap','rock_blast','iron_defense'], 'wander_normal'),
    ('graveler',    19, 22,  8, 18, 10, ['rollout','magnitude','rock_throw','defense_curl'], 'wander_normal'),
    ('golbat',      19, 22,  8, 18,  9, ['bite','confuse_ray','wing_attack','air_cutter'], 'wander_normal'),
    ('lairon',      20, 23, 10, 20,  8, ['headbutt','iron_defense','rock_tomb','metal_claw'], 'wander_normal'),
    ('clefairy',    19, 22,  8, 18,  7, ['disarming_voice','sing','metronome','minimize'], 'wander_normal'),
    ('spheal',      19, 21,  8, 16,  6, ['powder_snow','water_gun','rollout','aurora_beam'], 'wander_dumb'),
    ('snorunt',     19, 22,  9, 18,  7, ['powder_snow','double_team','bite','icy_wind'], 'wander_normal'),
    ('sneasel',     20, 23, 11, 20,  6, ['scratch','quick_attack','icy_wind','feint_attack'], 'wander_normal'),

    # --- Galerie profonde, etages 14-20 : les gardiens de gemmes
    ('mawile',      21, 24, 14, 20,  8, ['bite','fairy_wind','iron_defense','crunch'], 'wander_normal'),
    ('sigilyph',    22, 25, 15, 20,  6, ['gust','confusion','air_cutter','light_screen'], 'wander_normal'),
    ('beheeyem',    22, 25, 15, 20,  5, ['confusion','psybeam','miracle_eye','recover'], 'wander_normal'),
    ('solrock',     22, 25, 15, 20,  6, ['tackle','confusion','rock_throw','cosmic_power'], 'wander_normal'),
    ('lunatone',    22, 25, 15, 20,  6, ['tackle','confusion','rock_throw','hypnosis'], 'wander_normal'),

    # --- Salles des Glyphes, etages 21-25 : APRES le point median
    ('sabl_deep',   26, 29, 20, 25,  0, [], 'wander_normal'),   # placeholder retire plus bas
    ('probopass',   27, 30, 20, 25,  8, ['rock_slide','thunder_wave','magnet_bomb','block'], 'wander_normal'),
    ('aggron',      28, 31, 21, 25,  6, ['iron_head','rock_slide','metal_claw','protect'], 'wander_normal'),
    ('gigalith',    29, 32, 21, 25,  6, ['rock_blast','iron_defense','stealth_rock','smack_down'], 'wander_normal'),
    ('golem',       28, 31, 20, 25,  7, ['rollout','magnitude','rock_blast','earthquake'], 'wander_normal'),
    ('weavile',     29, 32, 22, 25,  5, ['ice_shard','feint_attack','metal_claw','night_slash'], 'wander_normal'),
    ('mr_mime',     28, 31, 20, 25,  6, ['confusion','light_screen','reflect','psybeam'], 'wander_normal'),
    ('bronzong',    29, 32, 22, 25,  6, ['confusion','gyro_ball','extrasensory','iron_defense'], 'wander_normal'),
    ('glalie',      30, 33, 23, 25,  5, ['ice_beam','crunch','icy_wind','protect'], 'wander_normal'),
]
POKEMON = [p for p in POKEMON if p[5] > 0]   # retire le placeholder


def mob(species, lmin, lmax, skills, tactic, rate, fmin, fmax):
    """Un spawn au format exact de vast_steppe.json."""
    return {
        "Spawn": {
            "Spawn": {
                "BaseForm": {"Species": species, "Form": 0, "Skin": "", "Gender": -1},
                "Level": {"Min": lmin, "Max": lmax},
                "SpecifiedSkills": skills,
                "Intrinsic": "",
                "Tactic": tactic,
                "SpawnConditions": [],
                "SpawnFeatures": [
                    {"$type": "PMDC.LevelGen.MobSpawnWeak, PMDC"},
                    {"$type": "PMDC.LevelGen.MobSpawnExclFamily, PMDC",
                     "Rarity": {"Min": 1, "Max": 2}, "Box": "box_glittery",
                     "MapStartOnly": False,
                     "Chance": {"Numerator": 2, "Denominator": 100}},
                ],
            },
            "Role": 3,
        },
        "Rate": rate,
        "Range": {"Min": fmin, "Max": fmax},
    }


def team_step(spawns, fmin, fmax):
    return {
        "$type": "RogueEssence.LevelGen.TeamSpawnZoneStep, RogueEssence",
        "Priority": {"str": [2, 2]},
        "Spawns": spawns,
        "TeamSizes": [
            {"Spawn": 1, "Rate": 12, "Range": {"Min": fmin, "Max": fmax}},
            {"Spawn": 2, "Rate": 5,  "Range": {"Min": fmin, "Max": fmax}},
        ],
        "SpecificSpawns": [],
    }


# ---------------------------------------------------------------
# CONSTRUCTION
# ---------------------------------------------------------------
SRC = sys.argv[1] if len(sys.argv) > 1 else '/tmp/cs.json'
DST = sys.argv[2] if len(sys.argv) > 2 else '/tmp/cs_out.json'

raw = open(SRC, 'rb').read()
bom = raw[:3] == b'\xef\xbb\xbf'
doc = json.loads(raw.decode('utf-8-sig'))
S = doc['Object']['Segments']
assert len(S) == 6, 'structure inattendue : %d segments' % len(S)

# --- 1. ETAGES -------------------------------------------------
# segment 0 : 20 etages (Range 0-20, decoupe en deux paliers d'ambiance)
# segment 2 : 3 etages   (21-23)
# segment 4 : 2 etages   (24-25)
S[0]['Floors']['nodes'][0]['Range'] = {"Min": 0,  "Max": 10}
S[0]['Floors']['nodes'][1]['Range'] = {"Min": 10, "Max": 20}
S[2]['Floors']['nodes'][0]['Range'] = {"Min": 0, "Max": 3}
S[4]['Floors']['nodes'][0]['Range'] = {"Min": 0, "Max": 2}

S[0]['Comment'] = ("Galerie Cristalline : 20 etages, cristal rose clair, "
                   "veines lumineuses. Avant le point median.")
S[2]['Comment'] = ("Salles des Glyphes : 3 etages, cristal rose profond. "
                   "APRES le point median (etages 21-23).")
S[4]['Comment'] = ("Salles des Glyphes : 2 derniers etages avant Diancie "
                   "(etages 24-25). APRES le mini-boss.")

# --- 2. MUSIQUE ------------------------------------------------
# MapDataStep porte la cle "Music" ; on la reecrit par segment.
def set_music(seg, music):
    n = 0
    def walk(o):
        nonlocal n
        if isinstance(o, dict):
            if 'MapDataStep' in str(o.get('$type', '')) and 'Music' in o:
                o['Music'] = music; n += 1
            for v in o.values(): walk(v)
        elif isinstance(o, list):
            for v in o: walk(v)
    walk(seg)
    return n

AVANT = 'Crystal Cave.ogg'       # etages 1-20, avant le median
APRES = 'Crystal Crossing.ogg'   # etages 21-25, apres le median
n0 = set_music(S[0], AVANT)
n2 = set_music(S[2], APRES)
n4 = set_music(S[4], APRES)

# --- 3. POKEMON ------------------------------------------------
# Les Range des spawns sont exprimes dans le referentiel DU SEGMENT.
# On convertit donc l'etage global (1-25) en index local.
def spawns_pour(seg_lo, seg_hi, seg_len):
    """Retourne les spawns dont la plage globale croise ce segment."""
    out = []
    for sp, lmin, lmax, fmin, fmax, rate, skills, tactic in POKEMON:
        lo = max(fmin, seg_lo); hi = min(fmax, seg_hi)
        if lo >= hi: continue
        out.append(mob(sp, lmin, lmax, skills, tactic, rate,
                       max(0, lo - seg_lo), min(seg_len, hi - seg_lo)))
    return out

sp0 = spawns_pour(0, 20, 20)
sp2 = spawns_pour(20, 23, 3)
sp4 = spawns_pour(23, 25, 2)

def poser_spawns(seg, spawns, lo, hi):
    seg.setdefault('ZoneSteps', [])
    seg['ZoneSteps'] = [z for z in seg['ZoneSteps']
                        if 'TeamSpawnZoneStep' not in z.get('$type', '')]
    seg['ZoneSteps'].append(team_step(spawns, lo, hi))

poser_spawns(S[0], sp0, 0, 20)
poser_spawns(S[2], sp2, 0, 3)
poser_spawns(S[4], sp4, 0, 2)

# --- 4. ECRITURE ----------------------------------------------
txt = json.dumps(doc, ensure_ascii=False, indent=1, separators=(',', ': '))
open(DST, 'w', encoding='utf-8-sig' if bom else 'utf-8').write(txt)

# --- 5. RAPPORT ------------------------------------------------
print('ETAGES   segment0 0-20 (20) | segment2 0-3 (3) | segment4 0-2 (2)  = 25')
print('MUSIQUE  seg0 %-22s x%d' % (AVANT, n0))
print('         seg2 %-22s x%d' % (APRES, n2))
print('         seg4 %-22s x%d' % (APRES, n4))
print('POKEMON  seg0 %2d spawns | seg2 %2d | seg4 %2d' % (len(sp0), len(sp2), len(sp4)))
esp = sorted({p[0] for p in POKEMON})
lv = [(p[1], p[2]) for p in POKEMON]
print('         %d especes distinctes, niveaux %d a %d'
      % (len(esp), min(a for a, b in lv), max(b for a, b in lv)))
print('         ', ' '.join(esp))
d2 = json.loads(open(DST, 'rb').read().decode('utf-8-sig'))
print('RELECTURE OK, %d segments' % len(d2['Object']['Segments']))
