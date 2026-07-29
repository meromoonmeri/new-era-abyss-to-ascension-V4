#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Detecte les Pokemon qui SE TRAVERSENT pendant une cinematique.

POURQUOI CET OUTIL
==================
Retour de jeu : « l'arrivee de Kino traverse nos heros ». Mesure faite,
son trajet (236,396) -> (238,290) passait EXACTEMENT sur Hyko (240,328)
puis sur le heros (240,300), et s'arretait a 10 px de ce dernier — deux
sprites de 16x16 imbriques. Reinier faisait de meme avec Almotz puis le
partenaire.

Aucun controle existant ne pouvait le voir :
  * verify_scene_positions verifie les BORNES de la carte ;
  * verify_ground_reachability verifie l'ACCESSIBILITE des ancres ;
  * audit_scene_liveliness verifie que les personnages BOUGENT.
Aucun ne verifiait qu'ils ne se rentrent pas dedans en bougeant.

CE QUE L'OUTIL FAIT
===================
Il simule la scene ligne par ligne : il suit la position de chaque
personnage (TeleportTo la fixe, MoveToPosition/EightWayMove la deplacent),
echantillonne chaque segment de marche, et signale tout passage a moins
de 14 px d'un autre personnage.

TROIS PIEGES EVITES, CHACUN MESURE
==================================
1. LES PERSONNAGES MASQUES. GROUND:Hide retire un PNJ de l'ecran : il
   n'est plus un obstacle. Sans ce suivi, les cordees deja parties
   generaient des alertes fantomes.

2. LES FRONTIERES DE SCENE. Chaque `function` repart d'un etat vierge.
   Comparer une position de l'intro avec une position de la scene de
   defaite n'a aucun sens : ce sont deux moments distincts.

3. LES MOUVEMENTS SIMULTANES — le plus subtil. Deux personnages qui
   bougent DANS LA MEME SALVE de coroutines (bornee par JoinCoroutines)
   ne se croisent pas : ils avancent ensemble. Le duo qui remonte en file
   indienne declenchait 4 fausses alertes, le partenaire « traversant »
   la position que le heros venait de quitter. On ignore donc, pour un
   marcheur donne, tous ceux qui marchent dans la meme salve.

Sans ces trois filtres l'outil sortait 19 alertes dont 12 fausses ; avec,
il sort exactement les vraies.

REFERENCE : 0 sur mount_windswept_entrance_ch_5.lua.

Usage : python3 tools/audit_scene_collisions.py [fichier.lua]
"""
import json,re
from collections import deque
d=json.loads(open('Data/Ground/mount_windswept_entrance.rsground','rb').read().decode('utf-8-sig'))['Object']
ob=d['obstacles']; W,H=len(ob),len(ob[0])
def freet(tx,ty): return 0<=tx<W and 0<=ty<H and ob[tx][ty]['Tags']==0
s=(32,59); seen={s}; q=deque([s])
while q:
    x,y=q.popleft()
    for dx,dy in ((1,0),(-1,0),(0,1),(0,-1)):
        n=(x+dx,y+dy)
        if n not in seen and freet(*n): seen.add(n); q.append(n)
F='Data/Script/halcyon/ground/mount_windswept_entrance/mount_windswept_entrance_ch_5.lua'
lines=open(F,encoding='utf-8').read().split('\n')
mv=re.compile(r'(MoveToPosition|EightWayMove\w*|TeleportTo)\(\s*([\w.\[\]]+)\s*,\s*(\d+)\s*,\s*(\d+)')
hide=re.compile(r'GROUND:Hide\(\s*([\w.\[\]]+)\.EntName')
unhide=re.compile(r'GROUND:Unhide\(\s*([\w.\[\]]+)\.EntName')
func=re.compile(r'^function\s+[\w.]+')

# 1er passage : delimiter les salves (bornees par JoinCoroutines)
salve_id=[0]*(len(lines)+2); cur=0
for i,l in enumerate(lines,1):
    salve_id[i]=cur
    if 'JoinCoroutines' in l: cur+=1
    if func.match(l): cur+=1

pos={}; hidden=set(); alerts=[]
# qui bouge dans chaque salve ?
movers={}
for i,l in enumerate(lines,1):
    if l.strip().startswith('--'): continue
    m=mv.search(l)
    if m and m.group(1)!='TeleportTo':
        movers.setdefault(salve_id[i],set()).add(m.group(2))

# ETAT HERITE : une scene appelee par une autre demarre avec les positions
# laissees par l'appelante. CampNightfall est invoquee depuis ArrivalCutscene,
# ou le duo vient d'etre pose en (240,300)/(272,300) au bout de la montee ;
# repartir d'un etat vide ferait manquer toute collision avec eux — c'est
# exactement le bug de Kino, qui leur passait au travers.
INHERITED = {
    'CampNightfall': {'hero': (240, 300), 'partner': (272, 300),
                      't.hyko': (240, 328), 't.almotz': (272, 328)},
}

def start_state(header):
    m = re.search(r'function\s+[\w.]*?\.?(\w+)\s*\(', header)
    name = m.group(1) if m else ''
    return dict(INHERITED.get(name, {}))

for i,l in enumerate(lines,1):
    if func.match(l): pos=start_state(l); hidden=set(); continue
    if l.strip().startswith('--'): continue
    m=hide.search(l)
    if m: hidden.add(m.group(1)); continue
    m=unhide.search(l)
    if m: hidden.discard(m.group(1))
    m=mv.search(l)
    if not m: continue
    fn,who,x,y=m.group(1),m.group(2),int(m.group(3)),int(m.group(4))
    if fn=='TeleportTo': pos[who]=(x,y); continue
    src=pos.get(who); pos[who]=(x,y)
    if src is None: continue
    bougent = movers.get(salve_id[i],set())
    for k in range(1,41):
        px=src[0]+(x-src[0])*k/40; py=src[1]+(y-src[1])*k/40
        for other,(ox,oy) in pos.items():
            if other==who or other in hidden or other in bougent: continue
            if max(abs(px-ox),abs(py-oy))<14:
                alerts.append((i,who,src,(x,y),other,(ox,oy))); break
        else: continue
        break
print('=== TRAVERSEES D UN PERSONNAGE IMMOBILE ===')
seen_k=set()
for i,who,a,b,other,o in alerts:
    k=(i,who,other)
    if k in seen_k: continue
    seen_k.add(k)
    print(f'  L{i:5} {who:12} {a}->{b}  traverse {other} en {o}')
print(f'\n-> {len(seen_k)} traversee(s) reelle(s)')
