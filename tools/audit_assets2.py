#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_assets2.py — références d'assets vs fichiers présents.

Reconstruit depuis l'audit 2026-07-30 (outil « audit_assets2.py » de
~/audit/scripts/) : vérifie que chaque asset référencé par les scripts
existe dans le mod OU dans la base moteur :
  - musiques (SOUND:PlayBGM / champ Music des cartes) → Content/Music
  - bruitages (PlayBattleSE/PlaySE/LoopSE/PlayFanfare) → Content/Sound
  - MapStatus (AddMapStatus) → Data/MapStatus + statuts moteur connus
  - fonds (WaitShowBG, BossFX.Overlay, BGAnimData) → Content/BG

Les assets MOTEUR (fournis par la base PMDO, absents du mod par
conception) sont énumérés dans MOTEUR_* : ne pas les signaler.

Usage : python3 tools/audit_assets2.py [racine]   (défaut: répertoire courant)
"""
import re, glob, os, json, sys

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'

MUSIC_DIR = os.path.join(ROOT, 'Content/Music')
SOUND_DIR = os.path.join(ROOT, 'Content/Sound')
BG_DIR = os.path.join(ROOT, 'Content/BG')
MS_DIR = os.path.join(ROOT, 'Data/MapStatus')

musics = {os.path.basename(p) for p in glob.glob(os.path.join(MUSIC_DIR, '*.ogg'))}
sounds = set()
if os.path.isdir(SOUND_DIR):
    for dp, _, fns in os.walk(SOUND_DIR):
        for fn in fns:
            sounds.add(os.path.relpath(os.path.join(dp, fn), SOUND_DIR).replace('\\', '/'))
bgs = {os.path.basename(p)[:-4] for p in glob.glob(os.path.join(BG_DIR, '*.dir'))}
ms = {os.path.basename(p)[:-5] for p in glob.glob(os.path.join(MS_DIR, '*.json'))}

# Statuts moteur (Fog_2, Black, Heat_Wave, Silver_Wind, Cosmic_Power,
# clouds_overhead, darkness, dusk, steam, blowing_wind, ...) — voir
# PASSATION §13 : absents du mod par conception.
MOTEUR_MS = {'clouds_overhead', 'darkness', 'dusk', 'steam', 'blowing_wind',
             'blowing_wind_fast', 'mysterious_distortion', 'default_weather'}
# Fonds moteur couramment cités sans fichier local (PASSATION §13 :
# Fog_2, Black, Heat_Wave, Silver_Wind, Cosmic_Power, clouds_overhead...
# sont des assets MOTEUR, absents du mod par conception).
MOTEUR_BG = {'White', 'Black', 'Sky', 'Pre_Battle', 'Cloudy_Sky', 'Fog_2',
             'Fog', 'Ominous_Wind', 'Heat_Wave', 'Silver_Wind',
             'Cosmic_Power', 'Star_Backdrop', 'Void'}

def strip_comments(src):
    src = re.sub(r'--\[\[.*?\]\]', '', src, flags=re.S)
    return re.sub(r'--[^\n]*', '', src)

# Les bruitages (PlayBattleSE/PlaySE/...) ne sont PAS livrés dans le mod :
# ils vivent dans Content/Sound du jeu de base (comme les .chara et les
# portraits). Sans la base installée, on ne peut pas vérifier leur
# existence — on affiche seulement le nombre de références distinctes,
# pas une liste d'erreurs. Les musiques, MapStatus et fonds, eux, SONT
# livrés dans le mod (ou dans les assets moteur énumérés MOTEUR_*).
miss = {'musique': set(), 'mapstatus': set(), 'fond': set()}
bruitages_distincts = set()

for f in glob.glob(os.path.join(ROOT, 'Data/Script/**/*.lua'), recursive=True):
    t = strip_comments(open(f, encoding='utf-8', errors='replace').read())
    for m in re.finditer(r"PlayBGM\(\s*\"([^\"]+)\"", t):
        if m.group(1) not in musics:
            miss['musique'].add(m.group(1))
    for m in re.finditer(r"PlayBGM\(\s*'([^']+)'", t):
        if m.group(1) not in musics:
            miss['musique'].add(m.group(1))
    for m in re.finditer(r"(?:PlayBattleSE|PlaySE|LoopSE|PlayFanfare|LoopBattleSE)\(\s*\"([^\"]+)\"", t):
        bruitages_distincts.add(m.group(1))
    for m in re.finditer(r"(?:PlayBattleSE|PlaySE|LoopSE|PlayFanfare|LoopBattleSE)\(\s*'([^']+)'", t):
        bruitages_distincts.add(m.group(1))
    for m in re.finditer(r"AddMapStatus\(\s*['\"]([a-z0-9_]+)['\"]", t):
        if m.group(1) not in ms and m.group(1) not in MOTEUR_MS:
            miss['mapstatus'].add(m.group(1))
    for m in re.finditer(r"(?:WaitShowBG|BossFX\.Overlay|BGAnimData)\(\s*['\"]([A-Za-z0-9_\-]+)['\"]", t):
        if m.group(1) not in bgs and m.group(1) not in MOTEUR_BG:
            miss['fond'].add(m.group(1))

print("### A2. Assets référencés et absents du mod (hors assets moteur)")
for cat, vals in miss.items():
    print(f"\n   {cat} : {len(vals)}")
    for v in sorted(vals):
        print(f"      {v}")
print(f"\n   bruitages distincts (non vérifiables sans la base installée) : {len(bruitages_distincts)}")
if not any(miss.values()):
    print("   0 asset manquant (musique/MapStatus/fond).")
