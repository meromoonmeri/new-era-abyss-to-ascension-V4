import json
# Inspect the metano_town ground: how are objects layered vs base?
d=json.load(open('Data/Ground/metano_town.rsground',encoding='utf-8-sig'))
o=d['Object']
layers=o['Layers']
for i,L in enumerate(layers):
    print(f"layer[{i}] {L['Name']}")
# For an object cell (building/tree), inspect which layers carry data vs empty
# Look at the Tree building around (visible in rendered). Find a cell in Objects layer that has content
print("\n=== Object layer tile structure ===")
# Objects layer index 6
obj=layers[6]
# find a cell with Layers non-empty
found=0
for x in range(0,189,7):
    for y in range(0,189,7):
        t=obj['Tiles'][x][y]
        if t.get('Layers'):
            print(f"  Objects[{x},{y}] sheet={t['Layers'][0]['Frames'][0]['Sheet']} loc={t['Layers'][0]['Frames'][0]['TexLoc']}")
            found+=1
            if found>=5: break
    if found>=5: break
