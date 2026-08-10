--[[
    init.lua — Passage du Temps (D55, arc du futur)
    Donjon de 3 étages (D55P11A → D55P21A → D55P41A), zone PMDO NATIVE.

    Structure : Zone → Segments → Floors → Map (Data/Zone/passage_temps.json).
    Hooks natifs RogueEssence : Init / EnterSegment / Rescued / ExitSegment.

    - L'entrée depuis l'arc (P08P01A, main_EnterDungeon(140) → étage 3) passe
      par GAME:EnterDungeon('passage_temps', 2, ...) via FutureArc.EnterDungeon55.
    - La progression d'étage (3 → 2 → 1) est gérée par le MOTEUR (escaliers),
      pas par un runner custom.
    - La sortie vers P09P01A (climax) passe par le résultat de donjon natif
      (EndDungeonRun → master_zone/p09p01a) quand l'arc est actif ; sinon
      comportement standard de donjon secondaire (retour Metano).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.future_arc.dungeon55_events'

local passage_temps = {}

function passage_temps.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_passage_temps")
  SV.TemporaryFlags.LastDungeonEntered = 'passage_temps'
end

function passage_temps.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function passage_temps.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function passage_temps.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_passage_temps result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Sortie de l'arc du futur : le donjon est terminé -> climax (P09P01A).
  -- Le résultat du donjon est géré par le système natif (EndDungeonRun).
  if SV.FutureArc ~= nil and SV.FutureArc.Active then
    SV.FutureArc.Active = false
    Dungeon55Events.ExitToClimax(result)
    return
  end

  -- Donjon secondaire : retour à Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return passage_temps
