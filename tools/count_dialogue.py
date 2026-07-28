#!/usr/bin/env python3
"""Compte les lignes de dialogue par chapitre (quota Prompt Maitre : 7000/chapitre des le ch5).
Une 'ligne' = un appel UI:WaitShowDialogue / StartConversation / WaitShowTimedDialogue."""
import re, glob, sys, collections

# Appels bruts au moteur, PLUS les helpers locaux qui les enveloppent
# (say/think/narrate/voice dans ChapterAftermath.lua et DazzlingArc.lua).
# Sans eux, un module ecrit proprement avec des helpers paraissait vide :
# DazzlingArc affichait 3 lignes au lieu de 77.
PAT = re.compile(
    r'WaitShowDialogue|StartConversation|WaitShowTimedDialogue'
    r'|^\s*(?:say|think|narrate|voice)\(', re.M)

# Modules GLOBAUX rattaches a un chapitre precis. Sans cette table, leurs
# repliques tombaient dans « commun » et le chapitre paraissait plus pauvre
# qu'il ne l'est : DazzlingArc (ch6) pesait 77 lignes comptees nulle part.
GLOBAL_CH = {
    'DazzlingArc.lua': 6,
    'SideQuests.lua': 6,      # requetes de Metano (fiches declaratives)
    'ChapterAftermath.lua': None,   # scenes ch8+ch9+ch10, ventilees a la main
}

def count_file(path):
    t = open(path, encoding='utf-8', errors='replace').read()
    t = re.sub(r'--\[\[.*?\]\]', '', t, flags=re.S)
    t = re.sub(r'--[^\n]*', '', t)
    return len(PAT.findall(t))

per_ch = collections.Counter()
detail = collections.defaultdict(list)
for f in glob.glob('Data/Script/halcyon/**/*.lua', recursive=True):
    m = re.search(r'_ch_(\d+)\.lua$', f)
    n = count_file(f)
    if n == 0: continue
    base = f.split('/')[-1]
    forced = GLOBAL_CH.get(base)
    if base in GLOBAL_CH and forced is None:
        per_ch['multi-chapitres (ChapterAftermath)'] = per_ch.get('multi-chapitres (ChapterAftermath)', 0) + n
        continue
    if m or forced:
        ch = int(m.group(1)) if m else forced
        per_ch[ch] += n
        detail[ch].append((n, f.split('/')[-1]))
    else:
        per_ch['commun'] += n

ch = sys.argv[1] if len(sys.argv) > 1 else None
if ch:
    ch = int(ch)
    for n, f in sorted(detail[ch], reverse=True):
        print(f'{n:5d}  {f}')
    print(f'--- CHAPITRE {ch} : {per_ch[ch]} lignes scriptees (quota 7000 des ch5)')
else:
    for k in sorted([k for k in per_ch if isinstance(k, int)]):
        goal = ' / 7000' if k >= 5 else ''
        print(f'ch{k:<2} : {per_ch[k]:5d}{goal}')
    for k in per_ch:
        if isinstance(k, str) and k != 'commun':
            print(f'{k} : {per_ch[k]}')
    print(f'commun (init.lua, helpers...) : {per_ch["commun"]}')
