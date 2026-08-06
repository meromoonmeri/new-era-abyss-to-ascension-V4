#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
build_tour_celeste_zone.py — Construit Data/Zone/tour_celeste.json
====================================================================
Aligné sur Data/Script/halcyon/zone/tour_celeste/init.lua (3 segments) :
  seg0 = étages 0-7   (Entrée -> Relais)   [GridFloorGen, tileset sky_tower]
  seg1 = étages 8-15  (Relais -> Sommet)   [GridFloorGen, tileset sky_tower]
  seg2 = Sommet/boss  (LayeredSegment -> LoadGen tour_celeste_sommet)

Tables de spawn Pokémon canoniques de la Tour Céleste (PMD Red D13/Sky Tower) :
  - étages : geodude, machop, zubat, plus roche/vol type (nosepass, aron,
    swablu, skarmory) à niveaux croissants
  - boss : Rayquaza (via LoadGen sommet + script)
Objets : baies, orbes, graines, TM roche/vol.
"""
import copy
import json

SRC = 'Data/Zone/tour_celeste.json'

# --- base : copie de la structure actuelle ---
cur = json.load(open(SRC, encoding='utf-8-sig'))
obj = cur['Object']

# en-tête
obj['Name'] = {'DefaultText': 'Tour Celeste', 'LocalTexts': {'fr': 'Tour Céleste'}}
obj['Comment'] = ('Tour Céleste PMD Red D13 (Sky Tower). 3 segments : '
                  'entrée (8F), relais (8F), sommet (9F) + boss Rayquaza.')
obj['GroundMaps'] = ['tour_celeste_entree', 'tour_celeste_relais', 'tour_celeste_sommet']

# --- helpers GenSteps (réutilise les blocs de la structure existante) ---
def gs(key, value):
    return {'Key': {'str': key}, 'Value': value}


def gensteps_floor(music, tileset, time_limit=1500):
    """GenSteps d'un étage généré (GridFloorGen)."""
    return [
        gs([-6], {'$type': 'PMDC.LevelGen.MapDataStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], PMDC',
                  'Music': music, 'TimeLimit': time_limit, 'TileSight': 0, 'CharSight': 0, 'ClampCamera': False}),
        gs([-5], {'$type': 'RogueElements.InitGridPlanStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements',
                  'CellWidth': 10, 'CellHeight': 10, 'CellX': 2, 'CellY': 3, 'CellWall': 3, 'Wrap': False}),
        gs([-4], {'$type': 'RogueElements.GridPathBranch`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements',
                  'RoomRatio': {'Min': 90, 'Max': 91}, 'BranchRatio': {'Min': 0, 'Max': 25}, 'NoForcedBranches': False,
                  'GenericRooms': {'$type': 'RogueElements.SpawnList`1[[RogueElements.RoomGen`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements]], RogueElements',
                    '$values': [{'Spawn': {'$type': 'RogueElements.RoomGenRound`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements',
                                'Width': {'Min': 5, 'Max': 10}, 'Height': {'Min': 5, 'Max': 10}}, 'Rate': 10}]},
                  'RoomComponents': [{'$type': 'PMDC.LevelGen.ConnectivityRoom, PMDC', 'Connection': 1}],
                  'GenericHalls': {'$type': 'RogueElements.SpawnList`1[[RogueElements.PermissiveRoomGen`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements]], RogueElements',
                    '$values': [{'Spawn': {'$type': 'RogueElements.RoomGenAngledHall`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements',
                                'HallTurnBias': 50, 'Brush': {'$type': 'RogueElements.DefaultHallBrush, RogueElements'},
                                'Width': {'Min': 0, 'Max': 0}, 'Height': {'Min': 0, 'Max': 0}}, 'Rate': 10}]},
                  'HallComponents': [{'$type': 'PMDC.LevelGen.ConnectivityRoom, PMDC', 'Connection': 1}]}),
        gs([-4], {'$type': 'RogueElements.ConnectGridBranchStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements',
                  'ConnectPercent': 75,
                  'Filters': [{'$type': 'RogueElements.RoomFilterComponent, RogueElements', 'Negate': True,
                              'Components': [{'$type': 'PMDC.LevelGen.NoConnectRoom, PMDC'}]}],
                  'GenericHalls': {'$type': 'RogueElements.PresetPicker`1[[RogueElements.PermissiveRoomGen`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements]], RogueElements',
                    'ToSpawn': {'$type': 'RogueElements.RoomGenAngledHall`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements',
                                'HallTurnBias': 50, 'Brush': {'$type': 'RogueElements.DefaultHallBrush, RogueElements'},
                                'Width': {'Min': 0, 'Max': 0}, 'Height': {'Min': 0, 'Max': 0}}},
                  'HallComponents': [{'$type': 'PMDC.LevelGen.ConnectivityRoom, PMDC', 'Connection': 1}]}),
        gs([-3], {'$type': 'RogueElements.DrawGridToFloorStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements'}),
        gs([-1], {'$type': 'RogueElements.DrawFloorToTileStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements', 'Padding': 1}),
        gs([0, 1], {'$type': 'RogueEssence.LevelGen.UnbreakableBorderStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueEssence', 'Thickness': 1}),
        gs([1], {'$type': 'RogueElements.FloorStairsStep`3[[RogueEssence.LevelGen.MapGenContext, RogueEssence],[RogueEssence.LevelGen.MapGenEntrance, RogueEssence],[RogueEssence.LevelGen.MapGenExit, RogueEssence]], RogueElements',
                 'MinDistance': 0,
                 'Entrances': [{'Loc': {'X': 0, 'Y': 0}, 'Dir': 0}],
                 'Exits': [{'Loc': {'X': 0, 'Y': 0}, 'Tile': {'TileLoc': {'X': 0, 'Y': 0}, 'ID': 'stairs_go_up', 'Revealed': True, 'Owner': 0, 'TileStates': []}}],
                 'Filters': [{'$type': 'PMDC.LevelGen.RoomFilterConnectivity, PMDC', 'Connection': 1},
                            {'$type': 'RogueElements.RoomFilterComponent, RogueElements', 'Negate': True,
                             'Components': [{'$type': 'PMDC.LevelGen.BossRoom, PMDC'}]}]}),
        gs([2, 2], {'$type': 'PMDC.LevelGen.MobSpawnSettingsStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], PMDC',
                    'Priority': {'str': [15]},
                    'Respawn': {'$type': 'PMDC.Dungeon.RespawnFromEligibleEvent, PMDC', 'MaxFoes': 4, 'RespawnTime': 60},
                    'MaxFoes': 4, 'RespawnTime': 60}),
        gs([4], {'$type': 'RogueEssence.LevelGen.MapTextureStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueEssence',
                 'GroundTileset': tileset + '_floor', 'BlockTileset': tileset + '_wall',
                 'WaterTileset': tileset + '_secondary', 'LayeredGround': False,
                 'IndependentGround': False, 'GroundElement': 'flying'}),
        gs([5], {'$type': 'RogueElements.TerminalSpawnStep`2[[RogueEssence.LevelGen.MapGenContext, RogueEssence],[RogueEssence.LevelGen.MoneySpawn, RogueEssence]], RogueElements',
                 'IncludeHalls': False, 'Filters': [],
                 'Spawn': {'$type': 'RogueEssence.LevelGen.MoneyDivSpawner`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueEssence',
                           'DivAmount': {'Min': 1, 'Max': 3}}}),
        gs([5, 1], {'$type': 'RogueElements.DueSpawnStep`3[[RogueEssence.LevelGen.MapGenContext, RogueEssence],[RogueEssence.Dungeon.InvItem, RogueEssence],[RogueEssence.LevelGen.MapGenEntrance, RogueEssence]], RogueElements',
                    'SuccessPercent': 25, 'IncludeHalls': False,
                    'Filters': [{'$type': 'PMDC.LevelGen.RoomFilterConnectivity, PMDC', 'Connection': 1}],
                    'Spawn': {'$type': 'RogueElements.ContextSpawner`2[[RogueEssence.LevelGen.MapGenContext, RogueEssence],[RogueEssence.Dungeon.InvItem, RogueEssence]], RogueElements',
                              'Amount': {'Min': 2, 'Max': 4}}}),
        gs([5, 2], {'$type': 'RogueEssence.LevelGen.PlaceRandomMobsStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueEssence',
                    'Filters': [{'$type': 'PMDC.LevelGen.RoomFilterConnectivity, PMDC', 'Connection': 1}],
                    'IncludeHalls': False,
                    'Spawn': {'$type': 'RogueEssence.LevelGen.TeamContextSpawner`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueEssence',
                              'Amount': {'Min': 2, 'Max': 4}}, 'Ally': False, 'ClumpFactor': 20}),
        gs([5, 3], {'$type': 'RogueElements.RandomRoomSpawnStep`2[[RogueEssence.LevelGen.MapGenContext, RogueEssence],[RogueEssence.Dungeon.EffectTile, RogueEssence]], RogueElements',
                    'SuccessPercent': 100, 'IncludeHalls': False,
                    'Filters': [{'$type': 'PMDC.LevelGen.RoomFilterConnectivity, PMDC', 'Connection': 1}],
                    'Spawn': {'$type': 'RogueElements.ContextSpawner`2[[RogueEssence.LevelGen.MapGenContext, RogueEssence],[RogueEssence.Dungeon.EffectTile, RogueEssence]], RogueElements',
                              'Amount': {'Min': 6, 'Max': 9}}}),
    ]


def mob(species, lvl_min, lvl_max, skills=(), tactic='wander', form=0, skin=''):
    return {
        'Spawn': {
            'BaseForm': {'Species': species, 'Form': form, 'Skin': skin, 'Gender': -1},
            'Level': {'Min': lvl_min, 'Max': lvl_max},
            'SpecifiedSkills': list(skills),
            'Intrinsic': '', 'Tactic': tactic, 'SpawnConditions': [], 'SpawnFeatures': [],
        },
        'Rate': 10,
    }


def build_seg0():
    """seg0 : étages 0-7 (Entrée -> Relais). 2 tranches (0-3, 4-7)."""
    item = {'$type': 'RogueEssence.LevelGen.GridFloorGen, RogueEssence', 'GenSteps': gensteps_floor('Sky Tower.ogg', 'sky_tower')}
    return {
        '$type': 'RogueEssence.LevelGen.RangeDictSegment, RogueEssence',
        'Floors': {'nodes': [
            {'Item': copy.deepcopy(item), 'Range': {'Min': 0, 'Max': 3}},
            {'Item': copy.deepcopy(item), 'Range': {'Min': 4, 'Max': 7}},
        ]},
        'ZoneSteps': [],
        'IsRelevant': True,
        'Comment': 'Tour Céleste — étages 0-7 : montée depuis l\'entrée vers le relais.',
    }


def build_seg1():
    """seg1 : étages 8-15 (Relais -> Sommet)."""
    item = {'$type': 'RogueEssence.LevelGen.GridFloorGen, RogueEssence', 'GenSteps': gensteps_floor('Sky Tower.ogg', 'sky_tower')}
    return {
        '$type': 'RogueEssence.LevelGen.RangeDictSegment, RogueEssence',
        'Floors': {'nodes': [
            {'Item': copy.deepcopy(item), 'Range': {'Min': 0, 'Max': 3}},
            {'Item': copy.deepcopy(item), 'Range': {'Min': 4, 'Max': 7}},
        ]},
        'ZoneSteps': [
            money_zone_step(),
            item_zone_step(copy.deepcopy(TOUR_ITEMS)),
            team_zone_step(TOUR_POKEMON_SEG1),
        ],
        'IsRelevant': True,
        'Comment': 'Tour Céleste — étages 8-15 : dernière ascension avant le sommet.',
    }


def build_seg2():
    """seg2 : sommet — LoadGen tour_celeste_sommet (boss Rayquaza)."""
    return {
        '$type': 'RogueEssence.LevelGen.LayeredSegment, RogueEssence',
        'Floors': [{
            '$type': 'RogueEssence.LevelGen.LoadGen, RogueEssence',
            'GenSteps': [gs([-1], {'$type': 'RogueEssence.LevelGen.MappedRoomStep`1[[RogueEssence.LevelGen.MapLoadContext, RogueEssence]], RogueEssence',
                                   'MapID': 'tour_celeste_sommet'})],
            'Comment': 'Sommet — arène de Rayquaza (climax ch10).',
        }],
        'ZoneSteps': [],
        'IsRelevant': True,
        'Comment': 'Sommet de la Tour Céleste — arène de Rayquaza (climax ch10).',
    }




def team_spawn(species, lvl_min, lvl_max, skills=(), tactic='wander', rate=10, rmin=0, rmax=10):
    """Un spawn d'équipe sauvage dans le format TeamSpawnZoneStep."""
    return {
        'Spawn': {
            'Spawn': {
                'BaseForm': {'Species': species, 'Form': 0, 'Skin': '', 'Gender': -1},
                'Level': {'Min': lvl_min, 'Max': lvl_max},
                'SpecifiedSkills': list(skills),
                'Intrinsic': '', 'Tactic': tactic, 'SpawnConditions': [], 'SpawnFeatures': [],
            },
            'Role': 0,
        },
        'Rate': rate,
        'Range': {'Min': rmin, 'Max': rmax},
    }


def item_spawn(item_id, rate, rmin=0, rmax=10):
    return {
        'Spawn': {'ID': item_id, 'Cursed': False, 'HiddenValue': '', 'Amount': 0, 'Price': 0},
        'Rate': rate, 'Range': {'Min': rmin, 'Max': rmax},
    }


def team_zone_step(spawns, priority=(2, 2)):
    return {
        '$type': 'RogueEssence.LevelGen.TeamSpawnZoneStep, RogueEssence',
        'Priority': {'str': list(priority)}, 'Spawns': spawns,
    }


def item_zone_step(categories, priority=(2, 1)):
    return {
        '$type': 'RogueEssence.LevelGen.ItemSpawnZoneStep, RogueEssence',
        'Priority': {'str': list(priority)}, 'Spawns': categories,
    }


def money_zone_step(priority=(2, 0)):
    return {
        '$type': 'RogueEssence.LevelGen.MoneySpawnZoneStep, RogueEssence',
        'Priority': {'str': list(priority)},
    }


# --- Tables canoniques Tour Céleste (PMD Red D13 / Sky Tower) ---
# Pokémon : géodude, machop, zubat (canon), + nosepass/aron/swablu/skarmory (vol/roche)
TOUR_POKEMON_SEG0 = [
    team_spawn('geodude', 22, 24, ['tackle', 'defense_curl', 'rock_throw'], 'wander'),
    team_spawn('machop', 22, 24, ['karate_chop', 'low_kick', 'leer'], 'wander'),
    team_spawn('zubat', 23, 25, ['leech_life', 'supersonic', 'bite'], 'wander'),
    team_spawn('nosepass', 24, 26, ['tackle', 'harden', 'rock_throw'], 'wander'),
    team_spawn('aron', 24, 26, ['tackle', 'harden', 'mud_slap'], 'wander'),
    team_spawn('swablu', 23, 25, ['peck', 'growl', 'astonish'], 'wander'),
]
TOUR_POKEMON_SEG1 = [
    team_spawn('geodude', 26, 28, ['tackle', 'rock_throw', 'magnitude'], 'wander'),
    team_spawn('machop', 26, 28, ['karate_chop', 'low_kick', 'seismic_toss'], 'wander'),
    team_spawn('zubat', 27, 29, ['leech_life', 'bite', 'wing_attack'], 'wander'),
    team_spawn('graveler', 27, 29, ['tackle', 'rock_throw', 'magnitude'], 'wander'),
    team_spawn('skarmory', 28, 30, ['peck', 'steel_wing', 'agility'], 'wander'),
    team_spawn('golbat', 28, 30, ['leech_life', 'bite', 'wing_attack'], 'wander'),
]

TOUR_ITEMS = {
    'necessities': {
        'Spawns': [
            item_spawn('berry_leppa', 15), item_spawn('berry_oran', 15),
            item_spawn('food_apple', 15), item_spawn('berry_rawst', 15),
            item_spawn('berry_pecha', 10), item_spawn('berry_sitrus', 10),
        ]
    },
    'exclusive': {
        'Spawns': [
            item_spawn('orb_slumber', 8), item_spawn('orb_foe_hold', 8),
            item_spawn('orb_one_shot', 6), item_spawn('orb_escape', 6),
            item_spawn('seed_heal', 8), item_spawn('seed_reviver', 6),
            item_spawn('seed_blinker', 6), item_spawn('seed_warp', 6),
        ]
    },
    'treasure': {
        'Spawns': [
            item_spawn('gem_rock', 8), item_spawn('gem_dragon', 6),
            item_spawn('thief_rock_slide', 5), item_spawn('thief_aerial_ace', 5),
            item_spawn('thief_steel_wing', 5), item_spawn('thief_dragon_claw', 5),
        ]
    },
}

# --- assemblage ---
obj['Segments'] = [build_seg0(), build_seg1(), build_seg2()]

with open(SRC, 'w', encoding='utf-8-sig') as f:
    json.dump(cur, f, ensure_ascii=False, indent=1)

print('tour_celeste.json réécrit :', len(obj['Segments']), 'segments')
for i, s in enumerate(obj['Segments']):
    print(f'  seg{i}: {s["$type"].split(",")[0].split(".")[-1]}')
