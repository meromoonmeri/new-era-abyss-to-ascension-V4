--[[ SkyRestAreas.lua — aires de repos canoniques PMD Sky (dXXp21a).
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
  amp_plains = { rest = 'd12p21a', next = 'far_amp_plains' },
  barren_valley = { rest = 'd46p21a', next = 'deep_barren_valley' },
  boulder_quarry = { rest = 'd55p21a', next = 'deep_boulder_quarry' },
  brine_cave = { rest = 'd26p21a', next = 'lower_brine_cave' },
  crevice_cave = { rest = 'd79p21a', next = 'lower_crevice_cave' },
  dark_crater = { rest = 'd41p21a', next = 'deep_dark_crater' },
  dark_ice_mountain = { rest = 'd51p21a', next = 'dark_ice_mountain_peak' },
  first_station_pass = { rest = 'd73p21a', next = 'second_station_pass' },
  fortune_ravine = { rest = 'd45p21a', next = 'fortune_ravine_depths' },
  fourth_station_pass = { rest = 'd73p24a', next = 'fifth_station_pass' },
  hidden_land = { rest = 'd28p21a', next = 'hidden_highland' },
  limestone_cavern = { rest = 'd56p21a', next = 'deep_limestone_cavern' },
  lower_spring_cave = { rest = 'd57p21a', next = 'spring_cave_depths' },
  miracle_sea = { rest = 'd35p21a', next = 'deep_miracle_sea' },
  ninth_station_pass = { rest = 'd73p29a', next = 'sky_peak_summit_pass' },
  quicksand_cave = { rest = 'd15p21a', next = 'quicksand_pit' },
  second_station_pass = { rest = 'd73p22a', next = 'third_station_pass' },
  seventh_station_pass = { rest = 'd73p27a', next = 'eighth_station_pass' },
  sixth_station_pass = { rest = 'd73p26a', next = 'seventh_station_pass' },
  spacial_rift = { rest = 'd39p21a', next = 'deep_spacial_rift' },
  star_cave_se1 = { rest = 'd42p21a', next = 'deep_star_cave_dungeon' },
  steam_cave = { rest = 'd10p21a', next = 'upper_steam_cave' },
  temporal_tower = { rest = 'd30p21a', next = 'temporal_spire' },
  temporal_tower_se5 = { rest = 'd48p21a', next = 'temporal_spire_se5' },
  third_station_pass = { rest = 'd73p23a', next = 'fourth_station_pass' },
  vast_ice_mountain = { rest = 'd53p21a', next = 'vast_ice_mountain_peak' },
}

-- rest ground -> { next = zone seg2, from = seg1 }
SkyRestAreas.BY_GROUND = {
  d12p21a = { next = 'far_amp_plains', from = 'amp_plains' },
  d46p21a = { next = 'deep_barren_valley', from = 'barren_valley' },
  d55p21a = { next = 'deep_boulder_quarry', from = 'boulder_quarry' },
  d26p21a = { next = 'lower_brine_cave', from = 'brine_cave' },
  d79p21a = { next = 'lower_crevice_cave', from = 'crevice_cave' },
  d41p21a = { next = 'deep_dark_crater', from = 'dark_crater' },
  d51p21a = { next = 'dark_ice_mountain_peak', from = 'dark_ice_mountain' },
  d73p21a = { next = 'second_station_pass', from = 'first_station_pass' },
  d45p21a = { next = 'fortune_ravine_depths', from = 'fortune_ravine' },
  d73p24a = { next = 'fifth_station_pass', from = 'fourth_station_pass' },
  d28p21a = { next = 'hidden_highland', from = 'hidden_land' },
  d56p21a = { next = 'deep_limestone_cavern', from = 'limestone_cavern' },
  d57p21a = { next = 'spring_cave_depths', from = 'lower_spring_cave' },
  d35p21a = { next = 'deep_miracle_sea', from = 'miracle_sea' },
  d73p29a = { next = 'sky_peak_summit_pass', from = 'ninth_station_pass' },
  d15p21a = { next = 'quicksand_pit', from = 'quicksand_cave' },
  d73p22a = { next = 'third_station_pass', from = 'second_station_pass' },
  d73p27a = { next = 'eighth_station_pass', from = 'seventh_station_pass' },
  d73p26a = { next = 'seventh_station_pass', from = 'sixth_station_pass' },
  d39p21a = { next = 'deep_spacial_rift', from = 'spacial_rift' },
  d42p21a = { next = 'deep_star_cave_dungeon', from = 'star_cave_se1' },
  d10p21a = { next = 'upper_steam_cave', from = 'steam_cave' },
  d30p21a = { next = 'temporal_spire', from = 'temporal_tower' },
  d48p21a = { next = 'temporal_spire_se5', from = 'temporal_tower_se5' },
  d73p23a = { next = 'fourth_station_pass', from = 'third_station_pass' },
  d53p21a = { next = 'vast_ice_mountain_peak', from = 'vast_ice_mountain' },
  d38p12a = { next = 'spacial_rift', from = 'entrance' },
}

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
    PrintInfo('[SkyRestAreas] exit '..zone.ID..' -> '..entry.rest..' (idx '..tostring(gi)..')')
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
  PrintInfo('[SkyRestAreas] OnRestAreaEnter '..tostring(gid))
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
