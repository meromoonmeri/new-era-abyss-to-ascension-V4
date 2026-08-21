#!/usr/bin/env python3
"""Inventory PMD Red legendary dungeon/ground/intro/arena packages without promoting candidates."""
from pathlib import Path
import json, re
R=Path(__file__).resolve().parents[1]
P=[
 ('zapdos','mt_thunder','d06p03','mt_thunder_zapdos'),
 ('moltres','mt_blaze','d09p03','mt_blaze_summit'),
 ('articuno','frosty_forest','d10p03','frosty_forest_summit'),
 ('groudon','magma_cavern','fosse_ardente','magma_cavern_pit'),
 ('rayquaza','sky_tower','tour_ciel_sommet',None),
 ('kyogre','stormy_sea','abime_tempetes',None),
 ('regirock','buried_relic',None,None),('regice','buried_relic',None,None),('registeel','buried_relic',None,None),('mew','buried_relic',None,None),
 ('entei','fiery_field','champ_braises',None),('raikou','lightning_field','porte_plaines_foudre',None),('suicune','northwind_field','champ_vent_boreal',None),
 ('ho_oh','mt_faraway','sommet_aurore',None),('lugia','silver_trench','fosse_argentee',None),
 ('mewtwo','western_cave','antre_occident',None),('latios','northern_range','cretes_boreales',None),('latias','pitfall_valley','vallon_perdu',None),
 ('jirachi','wish_cave','sanctuaire_voeu','wish_cave_jirachi'),('celebi','purity_forest',None,None),('deoxys','meteor_cave',None,None),
]
def exists(rel): return bool(rel) and (R/rel).exists()
def text(rel):
 try:return (R/rel).read_text(encoding='utf-8-sig').lower()
 except:return ''
rows=[]
for boss,zone,ground,arena in P:
 zone_active=exists(f'Data/Zone/{zone}.json'); zone_staged=exists(f'RESERVE/zones/{zone}.json')
 ground_active=exists(f'Data/Ground/{ground}.rsground') if ground else False
 script_active=exists(f'Data/Script/halcyon/ground/{ground}/init.lua') if ground else False
 arena_active=exists(f'Data/Map/{arena}.rsmap') if arena else False
 blob=' '.join([text(f'Data/Script/halcyon/ground/{ground}/init.lua') if ground else '',text(f'Data/Script/halcyon/zone/{zone}/init.lua'),text(f'Data/Map/{arena}.rsmap') if arena else ''])
 boss_wired=boss in blob
 intro_wired=script_active and boss_wired and any(k in blob for k in ('bosstransition','continuedungeon','enterdungeon'))
 complete=zone_active and ground_active and script_active and boss_wired and intro_wired and (arena_active if arena else True)
 rows.append(dict(boss=boss,zone=zone,ground=ground,arena=arena,zone_active=zone_active,zone_staged=zone_staged,ground_active=ground_active,script_active=script_active,arena_active=arena_active,boss_wired=boss_wired,intro_wired=intro_wired,static_package_complete=complete))
out={'scope':'static inventory only; runtime certification is separate','packages':rows,'counts':{'total':len(rows),'static_complete':sum(x['static_package_complete'] for x in rows),'active_zones':sum(x['zone_active'] for x in rows),'staged_zones':sum(x['zone_staged'] for x in rows)}}
p=R/'docs/pmdred_eu/LEGENDARY_PACKAGE_AUDIT_2026-08-21.json';p.write_text(json.dumps(out,indent=2,ensure_ascii=False)+'\n')
md=['# Audit des packages légendaires PMD Red — 2026-08-21','', '> Inventaire statique. Un statut statique ne constitue pas une certification runtime.','',f"- Packages examinés : **{out['counts']['total']}**",f"- Packages statiquement complets : **{out['counts']['static_complete']}**",f"- Zones actives : **{out['counts']['active_zones']}**",f"- Zones disponibles en staging : **{out['counts']['staged_zones']}**",'','| Boss | Zone | Ground | Zone active | Ground/script | Boss + intro | Arène | Statut |','|---|---|---|---:|---:|---:|---:|---|']
for x in rows:
 md.append(f"| {x['boss']} | `{x['zone']}` | `{x['ground'] or 'absent'}` | {'oui' if x['zone_active'] else 'non'} | {'oui' if x['ground_active'] and x['script_active'] else 'non'} | {'oui' if x['intro_wired'] else 'non'} | {'oui' if (x['arena_active'] or x['arena'] is None) else 'non'} | {'COMPLET STATIQUE' if x['static_package_complete'] else 'À PORTER'} |")
(R/'docs/pmdred_eu/LEGENDARY_PACKAGE_AUDIT_2026-08-21.md').write_text('\n'.join(md)+'\n')
print(json.dumps(out['counts'],sort_keys=True))
