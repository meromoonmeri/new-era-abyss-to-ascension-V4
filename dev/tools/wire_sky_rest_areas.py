#!/usr/bin/env python3
"""Câblage progression des 27 aires de repos Sky (dXXp21a) — ROM-exact.

TABLE DE VÉRITÉ (contre-épreuve exhaustive, AUCUNE devinette) :
 - Trigger d'accès : unionall.ssb coros GETOUT_SCENARIO_DUNGEON /
   GETOUT_REQUEST_CONQUEST / GETOUT_REQUEST_RETURN — switch
   $DUNGEON_ENTER_INDEX : à la VICTOIRE du segment 1 (dernier étage), la
   ROM fait main_EnterGround(LEVEL_DXXP21A, 30). Le checkpoint est donc
   déclenché par la FIN du donjon seg1 (jamais par un étage intermédiaire).
 - Reprise : scripts mXX/nXX/sXX .ssb DU ground d'aire de repos :
   main_EnterDungeon(<id seg2>, 30) — extraits un par un.
 - EVENT_DIVIDE_RESUME (switch $GROUND_ENTER) : reprise de sauvegarde dans
   l'aire => équivalent PMDO natif = save dans le ground (rien à câbler).
 - Cas particulier D38P12A (Spacial Rift Entrance) : ground d'ENTRÉE
   (ENTRANCE_SORANOSAKEME_RESUME), pas un checkpoint milieu — la sortie
   va vers spacial_rift (s21p0701.ssb: main_EnterDungeon(64)).

Implémentation native (patrons du repo, zéro hardcode par-donjon) :
 1. Data/Script/halcyon/SkyRestAreas.lua : table générée + handlers
    génériques HandleExit/ContinueFromRest (pattern mt_blaze/init.lua +
    creer_midpoints RELAY_INIT_LUA).
 2. zone/<seg1>/init.lua : stub 12 lignes délégant à SkyRestAreas
    (même rôle que zone/dusk_forest/init.lua). Refus d'écraser un init
    existant (aucun des 26 n'en a — vérifié).
 3. ground/<rest>/init.lua : stub délégant (FadeIn, statue=save natif,
    AutoContinue story -> EnterDungeon seg2).
"""
import json, os, sys, argparse

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# donjon seg1 (zone PMDO) -> (rest ground, zone seg2, preuve ROM)
TABLE = {
    # story principale — GETOUT cases $DUNGEON_ENTER_INDEX
    'steam_cave':        ('d10p21a', 'upper_steam_cave',      'GETOUT case 14 LABEL_D014_CLEAR ; m10a0601/m10a0701.ssb -> EnterDungeon(15)'),
    'amp_plains':        ('d12p21a', 'far_amp_plains',        'GETOUT case 17 LABEL_D017_CLEAR ; m12a0501.ssb -> EnterDungeon(18)'),
    'quicksand_cave':    ('d15p21a', 'quicksand_pit',         'GETOUT case 21 LABEL_D021_CLEAR ; m14a0501.ssb -> EnterDungeon(22)'),
    'brine_cave':        ('d26p21a', 'lower_brine_cave',      'GETOUT case 35 LABEL_D035_CLEAR ; m23a0402.ssb -> EnterDungeon(36)'),
    'hidden_land':       ('d28p21a', 'hidden_highland',       'GETOUT case 38 LABEL_D038_CLEAR ; m24a0601.ssb -> EnterDungeon(39)'),
    'temporal_tower':    ('d30p21a', 'temporal_spire',        'GETOUT case 41 LABEL_D041_CLEAR ; m25a0901.ssb -> EnterDungeon(42)'),
    'crevice_cave':      ('d79p21a', 'lower_crevice_cave',    'GETOUT case 47 LABEL_D047_CLEAR ; scripts -> EnterDungeon(48)'),
    'miracle_sea':       ('d35p21a', 'deep_miracle_sea',      'GETOUT case 51 LABEL_D051_CLEAR ; -> EnterDungeon(52)'),
    'spacial_rift':      ('d39p21a', 'deep_spacial_rift',     'GETOUT case 64 LABEL_D064_CLEAR ; s21p0901.ssb -> EnterDungeon(65)'),
    'dark_crater':       ('d41p21a', 'deep_dark_crater',      'GETOUT case 67 LABEL_D067_CLEAR ; s22p0901.ssb -> EnterDungeon(68)'),
    # épisodes spéciaux / postgame — GETOUT_SCENARIO_DUNGEON
    'star_cave_se1':     ('d42p21a', 'deep_star_cave_dungeon','GETOUT case 123 ; n01a1601.ssb -> EnterDungeon(124 DEEP_STAR_CAVE)'),
    'fortune_ravine':    ('d45p21a', 'fortune_ravine_depths', 'GETOUT case 130 ; n03a1301.ssb -> EnterDungeon(131)'),
    'barren_valley':     ('d46p21a', 'deep_barren_valley',    'GETOUT case 133 ; n08a0608.ssb -> EnterDungeon(134)'),
    'temporal_tower_se5':('d48p21a', 'temporal_spire_se5',    'GETOUT case 137 ; n08a1808.ssb -> EnterDungeon(138)'),
    'dark_ice_mountain': ('d51p21a', 'dark_ice_mountain_peak','GETOUT case 142 ; n09a0301.ssb -> EnterDungeon(143)'),
    'vast_ice_mountain': ('d53p21a', 'vast_ice_mountain_peak','GETOUT case 146 ; n09a1601.ssb -> EnterDungeon(147)'),
    'boulder_quarry':    ('d55p21a', 'deep_boulder_quarry',   'GETOUT case 150 ; n06a1101.ssb -> EnterDungeon(151)'),
    'limestone_cavern':  ('d56p21a', 'deep_limestone_cavern', 'GETOUT case 155 ; n06a3201.ssb -> EnterDungeon(156)'),
    'lower_spring_cave': ('d57p21a', 'spring_cave_depths',    'GETOUT case 162 ; n04a1701/n04a1901.ssb -> EnterDungeon(163)'),
    # Sky Peak — stations (col n -> station n -> col n+1)
    'first_station_pass':  ('d73p21a', 'second_station_pass',  'GETOUT case 111 LABEL_SORANOITADAKI_1GOUME ; enter01.ssb -> 112'),
    'second_station_pass': ('d73p22a', 'third_station_pass',   'GETOUT case 112 ; enter01.ssb -> 113'),
    'third_station_pass':  ('d73p23a', 'fourth_station_pass',  'GETOUT case 113 ; enter01.ssb -> 114'),
    'fourth_station_pass': ('d73p24a', 'fifth_station_pass',   'GETOUT case 114 ; enter01.ssb -> 115'),
    'sixth_station_pass':  ('d73p26a', 'seventh_station_pass', 'GETOUT case 116 ; enter01.ssb -> 117'),
    'seventh_station_pass':('d73p27a', 'eighth_station_pass',  'GETOUT case 117 ; enter01.ssb -> 118'),
    'ninth_station_pass':  ('d73p29a', 'sky_peak_summit_pass', 'GETOUT case 119 ; enter01.ssb -> 120'),
}
# ground d'ENTRÉE (pas un checkpoint) : ground -> donjon
ENTRY_GROUNDS = {
    'd38p12a': ('spacial_rift', 'ENTRANCE_SORANOSAKEME_RESUME ; s21p0701.ssb -> EnterDungeon(64)'),
}

ZONE_STUB = '''--[[ {zid} — donjon Sky segment 1 ({rest} = aire de repos canonique).
     Câblage ROM : unionall GETOUT ({proof}).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local {zid} = {{}}

function {zid}.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = '{zid}'
end

function {zid}.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function {zid}.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function {zid}.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return {zid}
'''

GROUND_STUB = '''--[[ {gid} — aire de repos Sky ({desc}).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : {proof}).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local {gid} = {{}}

function {gid}.Init(map) end

function {gid}.Enter(map)
  SkyRestAreas.OnRestAreaEnter('{gid}')
end

function {gid}.Update(map) end
function {gid}.GameSave(map) end
function {gid}.GameLoad(map) GAME:FadeIn(20) end

function {gid}.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return {gid}
'''

MODULE_HEADER = '''--[[ SkyRestAreas.lua — aires de repos canoniques PMD Sky (dXXp21a).
     TABLE GÉNÉRÉE depuis la ROM EU (unionall.ssb GETOUT_* : $DUNGEON_ENTER_INDEX
     -> main_EnterGround(LEVEL_DXXP21A) à la victoire du segment 1 ;
     scripts mXX/nXX/sXX du ground : main_EnterDungeon(<seg2>)).
     Préuves détaillées : dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables/SKY_REST_AREAS.json.
     Handlers génériques — AUCUN code spécifique par donjon (§13). ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

SkyRestAreas = SkyRestAreas or {}

-- seg1 zone -> { rest = ground, next = zone seg2 }
SkyRestAreas.BY_DUNGEON = {
'''

MODULE_BODY = '''}

-- rest ground -> { next = zone seg2, from = seg1 }
SkyRestAreas.BY_GROUND = {
'''

MODULE_FOOTER = '''}

-- index d'un ground DANS la zone courante (pattern zone/mt_blaze
-- ZONE_GROUND_IDX : l'aire de repos appartient à la zone seg1).
local function zone_ground_idx(zone, name)
  -- Zone RUNTIME : la liste s'appelle GroundMaps (cf. zone/mt_blaze
  -- ZONE_GROUND_IDX) — PAS .Grounds (ça, c'est le ZoneEntrySummary).
  for gi = 0, zone.GroundMaps.Count - 1 do
    if zone.GroundMaps[gi] == name then return gi end
  end
  return -1
end

-- ExitSegment générique des donjons seg1 (pattern zone/mt_blaze).
function SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  if COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID) then return end
  SV.adventure.Thief = false
  local entry = SkyRestAreas.BY_DUNGEON[zone.ID]
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared
      and segmentID == 0 and entry ~= nil then
    -- ROM : GETOUT -> main_EnterGround(LEVEL_DXXP21A, 30). Le ground est
    -- rattaché à la zone seg1 (GroundMaps) : transition INTRA-zone, comme
    -- mt_blaze -> d09p02.
    local gi = zone_ground_idx(zone, entry.rest)
    PrintInfo('[SkyRestAreas] exit '..zone.ID..' -> '..entry.rest..' (idx '..gi..')')
    if gi >= 0 then
      SV.SkyRestAreas = SV.SkyRestAreas or {}
      SV.SkyRestAreas.Pending = entry.rest
      GAME:EnterZone(zone.ID, -1, gi, 0)
      return
    end
    PrintInfo('[SkyRestAreas] ground absent de '..zone.ID..': ' .. tostring(entry.rest))
  end
  -- échec / fuite / autre segment : fin de run standard (retour hub).
  GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true)
end

-- Entrée d'une aire de repos (appelée par ground/<rest>/init.lua Enter()).
function SkyRestAreas.OnRestAreaEnter(gid)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  local entry = SkyRestAreas.BY_GROUND[gid]
  if entry == nil then return end
  SV.SkyRestAreas = SV.SkyRestAreas or {}
  if SV.SkyRestAreas.Pending ~= gid then return end  -- visite libre : rien
  SV.SkyRestAreas.Pending = nil
  SV.SkyRestAreas.LastCheckpoint = gid                -- checkpoint atteint
  -- ROM : le joueur repart via la cinématique (main_EnterDungeon seg2).
  -- Équivalent jouable : proposition immédiate ; refus = rester dans l'aire
  -- (statue Kangourex = sauvegarde), la sortie reste proposée au rechargement.
  -- Harnais headless (PMDO_GROUND_VALIDATOR) : auto-continue sans menu.
  if os.getenv('PMDO_GROUND_VALIDATOR') ~= nil then
    -- Harnais headless : le validateur (restflow) pilote la transition
    -- lui-même après vérification du ground — aucun menu ici.
    return
  end
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo(STRINGS:Format('Continuer vers la suite du donjon ?'), true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 40)
    GAME:EnterDungeon(entry.next, 0, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  else
    SV.SkyRestAreas.Pending = gid  -- l'offre reste ouverte
  end
end

return SkyRestAreas
'''


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    args = ap.parse_args()

    report = {'rule': 'Câblage aires de repos : unionall GETOUT_* + mXX.ssb main_EnterDungeon (ROM EU)',
              'apply': args.apply, 'wired': [], 'entry_grounds': [], 'skipped': []}

    # sanity : zones + grounds existent, aucun doublon
    rests = [v[0] for v in TABLE.values()] + list(ENTRY_GROUNDS)
    assert len(rests) == len(set(rests)) == 27, f"doublon/mapping manquant: {len(set(rests))}"
    for z1, (rest, z2, proof) in TABLE.items():
        for z in (z1, z2):
            assert os.path.exists(os.path.join(ROOT, f'Data/Zone/{z}.json')), f'zone absente {z}'
        assert os.path.exists(os.path.join(ROOT, f'Data/Ground/{rest}.rsground')), f'ground absent {rest}'

    # 1. module
    lines = [MODULE_HEADER]
    for z1, (rest, z2, proof) in sorted(TABLE.items()):
        lines.append(f"  {z1} = {{ rest = '{rest}', next = '{z2}' }},\n")
    lines.append(MODULE_BODY)
    for z1, (rest, z2, proof) in sorted(TABLE.items()):
        lines.append(f"  {rest} = {{ next = '{z2}', from = '{z1}' }},\n")
    for g, (nxt, proof) in sorted(ENTRY_GROUNDS.items()):
        lines.append(f"  {g} = {{ next = '{nxt}', from = 'entrance' }},\n")
    lines.append(MODULE_FOOTER)
    module = ''.join(lines)

    if args.apply:
        open(os.path.join(ROOT, 'Data/Script/halcyon/SkyRestAreas.lua'), 'w',
             encoding='utf-8').write(module)

    # 2. zone stubs
    for z1, (rest, z2, proof) in sorted(TABLE.items()):
        zdir = os.path.join(ROOT, f'Data/Script/halcyon/zone/{z1}')
        init = os.path.join(zdir, 'init.lua')
        fresh = not os.path.exists(init)
        if fresh and args.apply:
            os.makedirs(zdir, exist_ok=True)
            open(init, 'w', encoding='utf-8').write(
                ZONE_STUB.format(zid=z1, rest=rest, proof=proof))
        elif not fresh and 'wire_sky_rest_areas' not in open(init).read():
            report['skipped'].append({'zone': z1, 'reason': 'init.lua étranger (non écrasé)'})
            continue
        report['wired'].append({'seg1': z1, 'rest': rest, 'seg2': z2, 'proof': proof})

    # 3. ground stubs
    for z1, (rest, z2, proof) in sorted(TABLE.items()):
        gdir = os.path.join(ROOT, f'Data/Script/halcyon/ground/{rest}')
        init = os.path.join(gdir, 'init.lua')
        if os.path.exists(init):
            report['skipped'].append({'ground': rest, 'reason': 'init.lua existant'})
            continue
        if args.apply:
            os.makedirs(gdir, exist_ok=True)
            open(init, 'w', encoding='utf-8').write(GROUND_STUB.format(
                gid=rest, desc=f'checkpoint {z1} -> {z2}', proof=proof))
    for g, (nxt, proof) in sorted(ENTRY_GROUNDS.items()):
        gdir = os.path.join(ROOT, f'Data/Script/halcyon/ground/{g}')
        init = os.path.join(gdir, 'init.lua')
        if not os.path.exists(init) and args.apply:
            os.makedirs(gdir, exist_ok=True)
            open(init, 'w', encoding='utf-8').write(GROUND_STUB.format(
                gid=g, desc=f'entrée de {nxt}', proof=proof))
        report['entry_grounds'].append({'ground': g, 'next': nxt, 'proof': proof})

    out = os.path.join(ROOT, 'dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables/SKY_REST_AREAS.json')
    json.dump(report, open(out, 'w'), indent=1, ensure_ascii=False)
    print(f"câblés: {len(report['wired'])} checkpoints + {len(report['entry_grounds'])} entrées, "
          f"skips: {len(report['skipped'])}, apply={args.apply}")


if __name__ == '__main__':
    main()
