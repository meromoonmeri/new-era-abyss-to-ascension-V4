import os, json
OUT='CONVERSION_WS/tilesets'
man=json.load(open(f'{OUT}/manifest.json'))
man['structures_demandees']={
  'count':4,'atlas':'_atlas_structures4.png',
  'sprites':['shop_awning_railstall','statue_bluewing_x','house_bearhead_redmat','totem_teal_boss']
}
json.dump(man,open(f'{OUT}/manifest.json','w'),indent=1)
print("manifest updated:", list(man))
