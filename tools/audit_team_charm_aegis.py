#!/usr/bin/env python3
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];errors=[]
chars=(ROOT/'Data/Script/halcyon/CharacterEssentials.lua').read_text();mod=(ROOT/'Data/Script/halcyon/TeamCharmAegis.lua').read_text();init=(ROOT/'Data/Script/halcyon/ground/cloven_ruins_entrance/init.lua').read_text();sv=(ROOT/'Data/Script/halcyon/scriptvars.lua').read_text()
for key in ('TeamCharmLopunny','TeamCharmGardevoir','TeamCharmMedicham'):
 if key not in chars:errors.append(f'personnage absent: {key}')
 if key not in mod:errors.append(f'spawn absent: {key}')
 if key+'_Action' not in init:errors.append(f'interaction absente: {key}')
for token in ('GLACE','ROCHE','ACIER','trente ans','Team Charme'):
 if token not in mod:errors.append(f'contrat narratif absent: {token}')
if 'SV.TeamCharm' not in sv:errors.append('état Team Charm non déclaré')
if "TeamCharmAegis.Arrival()" not in init:errors.append('arrivée non branchée au camp')
print('AUDIT TEAM CHARME / AEGIS CAVE')
print(f'3/3 membres; arrivée + interactions; {len(errors)} erreur(s)')
for e in errors:print('ERREUR:',e)
raise SystemExit(bool(errors))
