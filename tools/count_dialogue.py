#!/usr/bin/env python3
"""Compte les lignes de dialogue par chapitre (quota Prompt Maitre : 7000/chapitre des le ch5).
Une 'ligne' = un appel UI:WaitShowDialogue / StartConversation / WaitShowTimedDialogue."""
import re, glob, sys, collections

PAT = re.compile(r'WaitShowDialogue|StartConversation|WaitShowTimedDialogue')

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
    if m:
        ch = int(m.group(1))
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
    for k in sorted([k for k in per_ch if k != 'commun']):
        goal = ' / 7000' if k >= 5 else ''
        print(f'ch{k:<2} : {per_ch[k]:5d}{goal}')
    print(f'commun (init.lua, helpers...) : {per_ch["commun"]}')
