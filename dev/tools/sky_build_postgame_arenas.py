#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_build_postgame_arenas.py — arènes de boss POST-GAME Sky depuis
fixed.bin (généralisation de sky_build_d45_clearing, mêmes preuves).

Sources canoniques par arène :
  * BALANCE/fixed.bin ffNN : géométrie exacte, spawns LEADER/ATTENDANT,
    entités M (ordre des EntityRule) ;
  * arm9 ov29 entity/monster tables : rule -> md_idx -> espèce (entid%600) ;
  * niveaux/espèces contre-épreuve : table mappa du donjon (le boss y est
    listé en monster house/fixed spawn au même niveau) ;
  * tileset/musique : layout mappa du donjon parent (mêmes tables que les
    zones déjà construites).
HP=0 -> stats natives moteur (jamais l'approximation).
"""
import copy
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

REPO = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TPL_MAP = os.path.join(REPO, 'Data', 'Map', 'magma_pit_groudon.rsmap')
TPL_ZONE = os.path.join(REPO, 'Data', 'Zone', 'magma_pit_groudon.json')

# (zone_id, ffk, nom EN, nom FR, autotile base, musique, cast:[(species,
#  level)]) — espèces = entid%600 ov29 (PROUVÉ), niveaux = table mappa du donjon parent (spawn du boss, poids 10000)
ARENAS = [
    ('regigigas_chamber_boss', 17, 'Regigigas Chamber',
     'Chambre de Regigigas', 'rock_aegis_cave', 'Aegis Cave.ogg',
     [('regigigas', 45), ('hitmonlee', 45), ('bronzong', 45)]),
    ('spacial_rift_bottom', 18, 'Spacial Rift Bottom',
     'Fond de la Faille Spatiale', 'spacial_rift_2',
     'Random Dungeon Theme 1.ogg', [('palkia', 53)]),
    ('dark_crater_pit', 19, 'Dark Crater Pit',
     'Puits du Cratère Obscur', 'dark_crater_2', 'Deep Dark Crater.ogg',
     [('darkrai', 53), ('arbok', 49), ('magmortar', 49),
      ('magcargo', 49), ('aggron', 49), ('camerupt', 49)]),
    ('giant_volcano_peak', 20, 'Giant Volcano Peak',
     'Sommet du Volcan Géant', 'giant_volcano',
     'Random Dungeon Theme 1.ogg', [('heatran', 46)]),
    ('shimmer_desert_pit', 21, 'Shimmer Desert Pit',
     'Puits du Désert Chatoyant', 'shimmer_desert',
     'Random Dungeon Theme 1.ogg', [('groudon', 44)]),
    ('mt_avalanche_peak', 22, 'Mt. Avalanche Peak',
     'Pic du Mont Avalanche', 'mt_avalanche',
     'Random Dungeon Theme 1.ogg', [('articuno', 46)]),
    ('bottomless_sea_depths', 23, 'Bottomless Sea Depths',
     'Profondeurs de la Mer sans Fond', 'bottomless_sea',
     'Random Dungeon Theme 1.ogg', [('kyogre', 51)]),
    ('world_abyss_pit', 24, 'World Abyss Pit',
     'Puits du Gouffre du Monde', 'world_abyss_1',
     'Random Dungeon Theme 1.ogg', [('giratina', 48)]),
    ('deep_mystery_jungle', 25, 'Deep Mystery Jungle',
     'Cœur de la Jungle Mystère', 'mystery_jungle_1',
     'Random Dungeon Theme 1.ogg', [('mew', 48)]),
    ('sky_stairway_apex', 26, 'Sky Stairway Apex',
     'Apogée de l\'Escalier Céleste', 'sky_stairway',
     'Random Dungeon Theme 1.ogg', [('rayquaza', 50)]),
]


def rows_from_ff(ff, EntityRule):
    W, H = ff.width, ff.height
    rows = []
    row = ''
    i = 0
    ent_i = 0
    for a in ff.actions:
        if isinstance(a, EntityRule):
            row += chr(ord('A') + ent_i)
            ent_i += 1
        else:
            n = a.tr_type.name
            if n == 'LEADER_SPAWN':
                row += 'P'
            elif n.startswith('ATTENDANT'):
                row += 'p'
            elif 'WALL' in n:
                row += '#'
            elif 'SECONDARY' in n or 'WATER' in n:
                row += '~'
            else:
                row += '.'
        i += 1
        if i % W == 0:
            rows.append(row)
            row = ''
    return rows


def main():
    from ndspy.rom import NintendoDSRom
    from skytemple_files.common.util import get_ppmdu_config_for_rom
    from skytemple_files.common.types.file_types import FileType
    from skytemple_files.dungeon_data.fixed_bin.model import EntityRule
    rom = NintendoDSRom.fromFile(os.path.join(
        REPO, '.runtime-cache', 'sky-rom',
        'Pokemon Mystery Dungeon - Explorers of Sky (Europe) '
        '(En,Fr,De,Es,It).nds'))
    cfg = get_ppmdu_config_for_rom(rom)
    fixed = FileType.FIXED_BIN.deserialize(
        rom.getFileByName('BALANCE/fixed.bin'), static_data=cfg)

    idx_zone_p = os.path.join(REPO, 'Data', 'Zone', 'index.idx')
    idx_zone = json.load(open(idx_zone_p, encoding='utf-8-sig'))
    idx_map_p = os.path.join(REPO, 'Data', 'Map', 'index.idx')
    idx_map = json.load(open(idx_map_p, encoding='utf-8-sig')) \
        if os.path.exists(idx_map_p) else None

    for zone_id, ffk, en, fr, base, music, cast in ARENAS:
        ff = fixed.fixed_floors[ffk]
        rows = rows_from_ff(ff, EntityRule)
        W, H = len(rows[0]), len(rows)
        tpl = json.load(open(TPL_MAP, encoding='utf-8-sig'))
        obj = tpl['Object']
        model_team = copy.deepcopy(obj['MapTeams'][0])
        model_player = copy.deepcopy(model_team['Players'][0])
        comment = (f'PMD Sky EU fixed floor {ffk} — géométrie exacte '
                   f'fixed.bin {W}x{H}, cast ov29 (espèces entid%600 '
                   f'prouvées), niveaux mappa du donjon parent, HP=0 '
                   f'stats natives.')

        def tex(kind):
            suf = ('wall' if kind == '#'
                   else 'secondary' if kind == '~' else 'floor')
            return {'AutoTileset': f'{base}_{suf}', 'Associates': [],
                    'Layers': [], 'NeighborCode': -1}

        def tile(kind):
            tid = ('unbreakable' if kind == '#'
                   else 'floor')
            return {'Data': {'ID': tid, 'TileTex': tex(kind),
                             'StableTex': False},
                    'Effect': {'TileLoc': {'X': 0, 'Y': 0}, 'ID': '',
                               'Revealed': False, 'Owner': 0,
                               'TileStates': []}}
        obj['Name'] = {'DefaultText': en, 'LocalTexts': {'fr': fr}}
        obj['Comment'] = comment
        obj['AssetName'] = zone_id + '_map'
        obj['Music'] = music
        obj['Tiles'] = [[tile(rows[y][x]) for y in range(H)]
                        for x in range(W)]
        obj['DiscoveryArray'] = [[True] * H for _ in range(W)]
        obj['Layers'][0]['Tiles'] = [[tex(rows[y][x]) for y in range(H)]
                                     for x in range(W)]
        px = py = None
        for y, r in enumerate(rows):
            for x, c in enumerate(r):
                if c == 'P':
                    px, py = x, y
        if px is None:  # certains ff n'ont pas de LEADER: centre
            px, py = W // 2, H - 2
        obj['EntryPoints'] = [{'Loc': {'X': px, 'Y': py}, 'Dir': 8}]
        teams = []
        ent_i = 0
        for y, r in enumerate(rows):
            for x, c in enumerate(r):
                if 'A' <= c <= 'Z' and c != 'P':
                    sp, lv = cast[min(ent_i, len(cast) - 1)]
                    ent_i += 1
                    team = copy.deepcopy(model_team)
                    pl = copy.deepcopy(model_player)
                    pl['BaseForm']['Species'] = sp
                    pl['Level'] = lv
                    pl['CharLoc'] = {'X': x, 'Y': y}
                    pl['MaxHPBonus'] = 0
                    if 'BaseSkills' in pl:
                        for s in pl['BaseSkills']:
                            s['SkillNum'] = ''
                    team['Players'] = [pl]
                    teams.append(team)
        obj['MapTeams'] = teams
        out_map = os.path.join(REPO, 'Data', 'Map', zone_id + '_map.rsmap')
        json.dump(tpl, open(out_map, 'w', encoding='utf-8-sig'),
                  ensure_ascii=False, indent=1)
        # zone
        z = json.load(open(TPL_ZONE, encoding='utf-8-sig'))
        z['Object']['Name'] = {'DefaultText': en, 'LocalTexts': {'fr': fr}}
        z['Object']['Comment'] = comment
        zs = json.dumps(z, ensure_ascii=False, indent=1) \
            .replace('magma_pit_groudon', zone_id + '_map')
        json.dump(json.loads(zs), open(
            os.path.join(REPO, 'Data', 'Zone', zone_id + '.json'), 'w',
            encoding='utf-8-sig'), ensure_ascii=False, indent=1)
        # index
        o = idx_zone['Object']
        if zone_id not in o:
            e = json.loads(json.dumps(o['magma_pit_groudon'])
                           .replace('magma_pit_groudon', zone_id + '_map'))
            e['Name'] = {'DefaultText': en, 'LocalTexts': {}}
            o[zone_id] = e
        if idx_map is not None:
            mo = idx_map.get('Object', idx_map)
            if zone_id + '_map' not in mo and 'magma_pit_groudon' in mo:
                me = json.loads(json.dumps(mo['magma_pit_groudon']))
                if isinstance(me, dict) and 'Name' in me:
                    me['Name'] = {'DefaultText': en, 'LocalTexts': {}}
                mo[zone_id + '_map'] = me
        print(f'{zone_id}: ff{ffk} {W}x{H}, {len(teams)} combattants '
              f'({cast[0][0]} L{cast[0][1]}...)')
    json.dump(idx_zone, open(idx_zone_p, 'w', encoding='utf-8-sig'),
              ensure_ascii=False, indent=1)
    if idx_map is not None:
        json.dump(idx_map, open(idx_map_p, 'w', encoding='utf-8-sig'),
                  ensure_ascii=False, indent=1)
    print('index mis à jour')


if __name__ == '__main__':
    main()
