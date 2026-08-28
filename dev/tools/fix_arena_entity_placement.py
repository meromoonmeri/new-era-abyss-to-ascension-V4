#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""fix_arena_entity_placement.py — Placement/orientation canoniques des
entités dans les arènes boss .rsmap.

PROBLÈMES (audit) :
 1. Sur ~15 rsmaps Sky, tous les mobs étaient empilés en (5,1) sur du mur
    (positions ROM jamais appliquées).
 2. Orientation : les boss ne FONT PAS FACE au héros/partenaire (ex. Team
    Meanies de la clairière des Bois Sinistres orientée dos aux joueurs).

SOURCES ROM :
 - Sky : BALANCE/fixed.bin (positions EntityRule) × overlay29
   ENTITY_SPAWN_TABLE + MONSTER_SPAWN_LIST (entity_rule -> monster_id ->
   md_idx) × MD_INDEX_TO_NATDEX × NATDEX_TO_PMDO -> (x, y, espèce).
   LEADER_SPAWN / ATTENDANT*_SPAWN = points d'entrée héros/équipiers.
 - Red : fixedmap.inc pret (action 4 = spawn joueur, >=16 = entités).

RÈGLES :
 - chaque mob rsmap est replacé sur la cellule ROM de son espèce ;
 - serializationDir = octant qui pointe vers le LEADER_SPAWN (le boss
   fait face à l'arrivée du héros) ;
 - EntryPoints[0] = LEADER_SPAWN, suivants = ATTENDANT (partenaire) ;
 - jamais de modification des espèces/niveaux/stats (canon intact).
"""
import glob
import json
import math
import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(REPO, "dev", "tools"))
from audit_fixed_arenas_vs_rom import red_decode  # noqa: E402

TABLES = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS",
                      "Tables")
SKY_ROM = glob.glob(os.path.join(REPO, ".runtime-cache", "sky-rom",
                                 "*.nds"))[0]

# rsmaps Red contreparties de grounds (positions mobs = ground canonique,
# on ne corrige QUE l'orientation + rien d'autre)
RED_GROUND_BOSSES = {"mt_steel_boss", "gloomy_forest_boss",
                     "mt_blaze_peak_boss", "mt_freeze_peak_boss",
                     "mt_thunder_peak_boss", "frosty_forest_summit",
                     "mt_blaze_summit", "wish_cave_jirachi",
                     "magma_pit_groudon", "sky_summit_rayquaza",
                     "cloven_ruins_regice", "cloven_ruins_regirock",
                     "cloven_ruins_registeel", "buried_relic_arena",
                     "meteor_cave_arena", "sanctuaire_titans"}
LOCKED = {"mount_windswept_guardian", "vast_steppe_guardian"}
# contenu Halcyon/NNV (hors campagnes Red/Sky) — ne pas toucher
SKIP_PREFIX = ("beginner_lesson", "boss_", "nnv_", "pattern_", "special_",
               "room_", "relic_forest_blob", "metano", "annexe_toupie",
               "sanctuaire_voeu", "foret_embuscade", "bois_ronces",
               "carriere_cuivre", "petit_tunnel", "vallee_fertile",
               "grotte_echoue", "searing_crucible", "chapter_3")


def octant(dx, dy):
    """Vecteur -> Dir8 RogueElements (0=Down=+Y, 4=Up=-Y, 2=Left, 6=Right)."""
    if dx == 0 and dy == 0:
        return 0
    ang = math.atan2(dy, dx)  # y vers le bas
    # Dir8: Down(0)=(0,1) ang=90°; Left(2)=(-1,0)=180°; Up(4)=270°; Right(6)=0°
    deg = (math.degrees(ang) + 360) % 360
    table = [(90, 0), (135, 1), (180, 2), (225, 3), (270, 4), (315, 5),
             (0, 6), (45, 7)]
    best, bd = 0, 999
    for tdeg, d in table:
        diff = min(abs(deg - tdeg), 360 - abs(deg - tdeg))
        if diff < bd:
            bd, best = diff, d
    return best


def sky_rom_data():
    from ndspy.rom import NintendoDSRom
    from skytemple_files.common.types.file_types import FileType
    from skytemple_files.common.util import get_ppmdu_config_for_rom
    from skytemple_files.hardcoded.fixed_floor import \
        HardcodedFixedFloorTables
    rom = NintendoDSRom.fromFile(SKY_ROM)
    cfg = get_ppmdu_config_for_rom(rom)
    fbin = FileType.FIXED_BIN.deserialize(
        rom.getFileByName('BALANCE/fixed.bin'))
    ov29 = rom.loadArm9Overlays([29])[29].data
    ents = HardcodedFixedFloorTables.get_entity_spawn_table(ov29, cfg)
    mons = HardcodedFixedFloorTables.get_monster_spawn_list(ov29, cfg)
    md2nat = json.load(open(os.path.join(TABLES,
                                         'MD_INDEX_TO_NATDEX.json')))
    nat2p = json.load(open(os.path.join(TABLES, 'NATDEX_TO_PMDO.json')))

    def species_of_entity(rule_id):
        if rule_id >= len(ents):
            return None
        e = ents[rule_id]
        if e.monster_id <= 0 or e.monster_id >= len(mons):
            return None
        md = mons[e.monster_id].md_idx
        base = md if md < 600 else md - 600
        nat = md2nat.get(str(base))
        return nat2p.get(str(nat)) if nat else None

    return fbin.fixed_floors, species_of_entity


def sky_layout(ff, species_of_entity):
    leader = None
    attendants = []
    mobs = []  # (x, y, species)
    for i, a in enumerate(ff.actions):
        x, y = i % ff.width, i // ff.width
        if type(a).__name__ == 'EntityRule':
            sp = species_of_entity(a.entity_rule_id)
            if sp:
                mobs.append((x, y, sp))
        else:
            nm = a.tr_type.name
            if nm == 'LEADER_SPAWN':
                leader = (x, y)
            elif nm.startswith('ATTENDANT'):
                attendants.append((x, y))
    return leader, attendants, mobs


def red_layout(fr_idx):
    w, h, rows = red_decode(fr_idx)
    leader = None
    mobs = []
    for y in range(h):
        for x in range(w):
            v = rows[y][x]
            if v == 4:
                leader = (x, y)
            elif v == 35:
                mobs.append((x, y, 'groudon'))
            elif v == 36:
                mobs.append((x, y, 'rayquaza'))
    return leader, [], mobs


def main():
    ffs, species_of = sky_rom_data()
    report = {}
    for p in sorted(glob.glob(os.path.join(REPO, 'Data', 'Map',
                                           '*.rsmap'))):
        name = os.path.basename(p)[:-6]
        if name in LOCKED or any(name.startswith(s) for s in SKIP_PREFIX):
            continue
        d = json.load(open(p, encoding='utf-8-sig'))
        o = d['Object']
        teams = o.get('MapTeams') or []
        players = [pl for t in teams for pl in (t.get('Players') or [])]
        if not players:
            continue
        cmt = o.get('Comment') or ''
        m = re.search(r'fixed floor (\d+)', cmt)
        m2 = re.search(r'fixed room (\d+)', cmt)
        leader = attendants = rom_mobs = None
        if m:
            leader, attendants, rom_mobs = sky_layout(
                ffs[int(m.group(1))], species_of)
        elif m2:
            leader, attendants, rom_mobs = red_layout(int(m2.group(1)))

        rep = {"moved": 0, "turned": 0, "entry": 0}
        T = o.get('Tiles') or []

        # 1) reposition sur les cellules ROM (par espèce, ordre ROM)
        if rom_mobs:
            pool = list(rom_mobs)
            for pl in players:
                sp = (pl.get('BaseForm') or {}).get('Species')
                hit = next((i for i, (x, y, s) in enumerate(pool)
                            if s == sp), None)
                if hit is None:
                    continue
                x, y, _ = pool.pop(hit)
                loc = pl.get('serializationLoc') or {}
                if (loc.get('X'), loc.get('Y')) != (x, y):
                    pl['serializationLoc'] = {"X": x, "Y": y}
                    rep['moved'] += 1

        # 2) EntryPoints = LEADER_SPAWN (+ attendants)
        if leader:
            eps = o.get('EntryPoints') or []
            want = [leader] + list(attendants)
            for i, ep in enumerate(eps):
                tgt = want[i] if i < len(want) else want[0]
                if (ep['Loc']['X'], ep['Loc']['Y']) != tgt:
                    ep['Loc'] = {"X": tgt[0], "Y": tgt[1]}
                    rep['entry'] += 1
                # orientation du héros vers le boss principal
                if players:
                    bl = players[0].get('serializationLoc') or {}
                    ep['Dir'] = octant(bl.get('X', tgt[0]) - tgt[0],
                                       bl.get('Y', tgt[1]) - tgt[1])

        # 3) orientation des mobs vers l'entrée du héros
        eps = o.get('EntryPoints') or []
        if eps:
            ex = sum(e['Loc']['X'] for e in eps) / len(eps)
            ey = sum(e['Loc']['Y'] for e in eps) / len(eps)
            for pl in players:
                loc = pl.get('serializationLoc') or {}
                x, y = loc.get('X'), loc.get('Y')
                if x is None:
                    continue
                want = octant(ex - x, ey - y)
                if pl.get('serializationDir') != want:
                    pl['serializationDir'] = want
                    rep['turned'] += 1

        # 4) garde-fou : personne sur du mur
        for pl in players:
            loc = pl.get('serializationLoc') or {}
            x, y = loc.get('X'), loc.get('Y')
            if x is None or not T:
                continue
            if T[x][y]['Data']['ID'] in ('wall', 'unbreakable'):
                rep.setdefault('still_on_wall', []).append(
                    (pl.get('BaseForm', {}).get('Species'), x, y))

        if rep['moved'] or rep['turned'] or rep['entry']:
            with open(p, 'w', encoding='utf-8-sig') as fh:
                json.dump(d, fh, ensure_ascii=False, indent=2)
            report[name] = rep

    print(json.dumps(report, ensure_ascii=False, indent=1))
    out = os.path.join(REPO, 'dev', 'docs', 'canonical',
                       'ARENA_ENTITY_PLACEMENT_FIX.json')
    json.dump(report, open(out, 'w'), ensure_ascii=False, indent=1)
    print("rapport:", out)


if __name__ == '__main__':
    main()
