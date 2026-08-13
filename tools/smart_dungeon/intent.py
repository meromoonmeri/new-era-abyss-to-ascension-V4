#!/usr/bin/env python3
"""Translate natural French/English dungeon intentions into an explicit brief."""
from __future__ import annotations
import hashlib,re,unicodedata
from pathlib import Path
from .model import DesignBrief
THEMES={
 'ancien':['ancien','antique','ruine','ancestral','forgotten','old'],'majestueux':['majestueux','royal','grandiose','sacré','majestic'],
 'inquiétant':['inquiétant','angoissant','sombre','oppressant','sinistre','creepy','dark'],
 'forêt':['forêt','forest','bois','jungle','végétal'],'grotte':['grotte','caverne','mine','cave','souterrain'],
 'eau':['eau','rivière','lac','mer','water','river'],'feu':['feu','volcan','lave','fire','lava'],
 'glace':['glace','neige','gelé','ice','snow'],'céleste':['céleste','étoile','ciel','cosmique','sky','star'],
 'mécanique':['machine','mécanique','usine','industrial','mechanical']}
def norm(s):return ''.join(c for c in unicodedata.normalize('NFKD',s.casefold()) if not unicodedata.combining(c))
def _number(text,patterns,default):
 for p in patterns:
  m=re.search(p,text)
  if m:return int(m.group(1))
 return default
def slugify(name):return re.sub(r'[^a-z0-9]+','_',norm(name)).strip('_') or 'dungeon'
def parse_intent(name:str,intent:str,floors:int|None=None,difficulty:str|None=None,boss:bool|None=None,mini_bosses:int|None=None,relays:int|None=None,seed:int|None=None):
 t=norm(intent);count_text=t
 for word,value in {'un':'1','une':'1','deux':'2','trois':'3','quatre':'4','cinq':'5','six':'6','seven':'7','two':'2','three':'3','four':'4','five':'5','six':'6'}.items():count_text=re.sub(rf'\b{word}\b',value,count_text)
 floors=floors or _number(count_text,[r'(\d+)\s*(?:etages|floors|niveaux)'],20);mini=mini_bosses if mini_bosses is not None else _number(count_text,[r'(\d+)\s*mini[- ]?boss'],0);relay=relays if relays is not None else _number(count_text,[r'(\d+)\s*(?:relais|refuges|rest stops?)'],0);has_boss=boss if boss is not None else bool(re.search(r'\bboss\b|gardien final|final guardian',t));diff=difficulty or ('extrême' if any(x in t for x in ('extreme','brutal','tres difficile')) else 'difficile' if any(x in t for x in ('difficile','dangereux','hard')) else 'facile' if any(x in t for x in ('facile','calme','easy')) else 'normal');tokens=[k for k,words in THEMES.items() if any(norm(w) in t for w in words)]
 topo_start='open' if re.search(r'(debut|premiers?).{0,30}(ouvert|open)|(ouvert|open).{0,20}(debut|premiers?)',t) else 'linear' if 'lineaire' in t else 'balanced';topo_end='labyrinth' if re.search(r'(devien|fin|progress).{0,45}(labyrinth|complex)',t) or 'labyrinth' in t else 'open' if 'reste ouvert' in t else 'complex';mood_start='majestueux' if 'majestueux' in tokens else 'calme' if 'calme' in t else 'lisible';mood_end='inquiétant' if 'inquiétant' in tokens or 'progressivement inquietant' in t else 'spectaculaire' if 'spectacul' in t else 'intense';deco=.78 if 'forte densite' in t or 'tres decore' in t else .28 if 'epure' in t or 'peu decore' in t else .52;danger=.82 if diff in ('difficile','extrême') else .28 if diff=='facile' else .55;water='forbid' if re.search(r'sans eau|no water',t) else 'required' if re.search(r'beaucoup d eau|aquatique|water',t) else 'auto';constraints=[]
 for pattern,label in [(r'immense salle centrale|grande salle centrale','central_landmark'),(r'tres labyrinthique','strong_labyrinth'),(r'etage plus ouvert','open_floor'),(r'calme avant le boss|refuge avant le boss','preboss_calm'),(r'zone secrete|raccourci','secrets_and_shortcuts'),(r'sans eau|no water','no_water')]:
  if re.search(pattern,t):constraints.append(label)
 specials=[]
 if has_boss:specials.append({'kind':'boss','count':1})
 if mini:specials.append({'kind':'mini_boss','count':mini})
 if relay:specials.append({'kind':'relay','count':relay})
 if seed is None:seed=int.from_bytes(hashlib.sha256((name+'\0'+intent).encode()).digest()[:8],'little')&0x7fffffff
 return DesignBrief(name,slugify(name),intent,max(3,min(200,floors)),diff,has_boss,max(0,mini),max(0,relay),int(seed),tokens,mood_start,mood_end,topo_start,topo_end,water,deco,danger,constraints,specials)
