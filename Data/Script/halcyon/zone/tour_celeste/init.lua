--[[
  tour_celeste/init.lua
  Zone Tour Céleste — PMD Red D13 authentique
  Donjon : 25 étages (D13P01 8F + D13P02 8F + D13P03 9F) — GridFloorGen (RogueElements) remplace dungeon_generator.c
  Boss : Rayquaza L40 — VFX PMDRed D13P03 + A04P03 (Ultralaser / Météorite)
  Grounds : tour_celeste_entree (36x27), tour_celeste_relais (57x57), tour_celeste_sommet (69x75) — PMD-5 1:1
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.ReplayEnding'

local tour_celeste = {}

local MASTER_FALLBACK = 1

local function GROUND_IDX(name)
  local ok, idx = pcall(function()
    local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("master_zone")
    for i=0, zone.Grounds.Count-1 do
      if zone.Grounds[i]==name then return i end
    end
    return -1
  end)
  if not ok or idx<0 then return MASTER_FALLBACK end
  return idx
end

function tour_celeste.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered='tour_celeste'
end

function tour_celeste.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function tour_celeste.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function tour_celeste.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief=false
  if exited then return end

  -- Segment 0 : Entree -> Relais
  if segmentID==0 then
    if result==RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('tour_celeste',10) then
      GAME:EnterGroundMap('tour_celeste_relais','Main_Entrance_Marker')
    elseif result~=RogueEssence.Data.GameProgress.ResultType.Cleared then
      if result~=RogueEssence.Data.GameProgress.ResultType.Escaped then
        GAME:EndDungeonRun(result,"master_zone",-1,GROUND_IDX('tour_celeste_entree'),0,true,true)
        GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(0),"Le vent...[pause=0] trop violent...","Pain")
        GAME:WaitFrames(20)
        GAME:EnterZone("master_zone",-1,GROUND_IDX('tour_celeste_entree'),0)
      else
        GeneralFunctions.EndDungeonRun(result,"master_zone",-1,GROUND_IDX('tour_celeste_entree'),0,true,true)
      end
    end
  -- Segment 1 : Relais -> Sommet (pre-boss)
  elseif segmentID==1 then
    if result==RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('tour_celeste',10) then
      GAME:EnterGroundMap('tour_celeste_sommet','Main_Entrance_Marker')
    elseif result~=RogueEssence.Data.GameProgress.ResultType.Cleared then
      GAME:EnterGroundMap('tour_celeste_relais','Main_Entrance_Marker')
    end
  -- Segment 2 : Sommet — Boss Rayquaza — VICTOIRE = ULTRALASER + METEORITE
  elseif segmentID==2 then
    if result==RogueEssence.Data.GameProgress.ResultType.Cleared then
      -- Flags victoire
      pcall(function() SV.TourCeleste = SV.TourCeleste or {}; SV.TourCeleste.DefeatedRayquaza=true end)
      pcall(function() SV.ChapterProgression.Chapter=11 end)
      -- Cinématique POST-VICTOIRE : Rayquaza Ultralaser détruit la météorite (A04P03)
      -- On entre sur la ground du sommet qui lira le flag et jouera PlayPostVictory (ultra laser)
      -- La ground se chargera elle-même du EndDungeonRun après la scène
      SV.TemporaryFlags.TourCelestePostVictory=true
      GAME:EnterGroundMap('tour_celeste_sommet','Main_Entrance_Marker')
    else
      pcall(function() SV.TourCeleste = SV.TourCeleste or {}; SV.TourCeleste.LostToRayquaza=true end)
      GAME:EndDungeonRun(result,"master_zone",-1,GROUND_IDX('tour_celeste_relais'),0,true,true)
      GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(0),"Rayquaza...[pause=0] sa tempête...","Pain")
      GAME:WaitFrames(20)
      GAME:EnterZone("master_zone",-1,GROUND_IDX('tour_celeste_relais'),0)
    end
  else
    -- Fallback
    if result~=RogueEssence.Data.GameProgress.ResultType.Cleared then GAME:WaitFrames(20) end
    pcall(function() SV.TemporaryFlags.LastDungeonResult=result end)
    GeneralFunctions.EndDungeonRun(result,"master_zone",-1,1,0,true,true)
  end
end

return tour_celeste
