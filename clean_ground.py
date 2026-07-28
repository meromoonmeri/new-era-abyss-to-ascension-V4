import json

path = 'Data/Ground/mount_windswept_entrance.rsground'
with open(path, 'r', encoding='utf-8-sig') as f:
    data = json.load(f)

# Keep only the original objects
keep = ('Kangaskhan_Rock', 'Dungeon_Entrance', 'TEAMMATE_1', 'TEAMMATE_2', 'TEAMMATE_3', 'Main_Entrance_Marker')

for lay in data['Object']['Entities']:
    if 'GroundObjects' in lay:
        lay['GroundObjects'] = [o for o in lay['GroundObjects'] if o['EntName'] in keep]
    if 'Spawners' in lay:
        lay['Spawners'] = [o for o in lay['Spawners'] if o['EntName'] in keep]
    if 'Markers' in lay:
        lay['Markers'] = [o for o in lay['Markers'] if o['EntName'] in keep]

with open(path, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=1)
print("Ground file cleaned. Returning to baseline.")
