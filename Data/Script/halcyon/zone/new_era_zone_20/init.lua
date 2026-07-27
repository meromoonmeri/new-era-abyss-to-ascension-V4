--[[ Fosse d'Argent Abyssale — zone add-on (Réseau des Anciens Chemins, id origine 20).
     Progression fidèle pret/pmd-red : 100 étages.
     Aucun impact histoire : entrée/sortie via master_zone carte 1 (Metano). ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local new_era_zone_20 = {}

function new_era_zone_20.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_new_era_zone_20")
end

function new_era_zone_20.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function new_era_zone_20.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function new_era_zone_20.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end


  -- Veilleur du Réseau : segment 1 = arène (jellicent/dhelmise).
  if segmentID == 0 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:ContinueDungeon("new_era_zone_20", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end
  if segmentID == 1 then
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      if SV.Reseau == nil then SV.Reseau = { Veilleurs = {} } end
      if SV.Reseau.Veilleurs == nil then SV.Reseau.Veilleurs = {} end
      SV.Reseau.Veilleurs['new_era_zone_20'] = true
      GAME:WaitFrames(20)
      UI:SetSpeaker(GAME:GetPlayerPartyMember(1))
      UI:SetSpeakerEmotion("Happy")
      UI:WaitShowDialogue("La Lanterne s'éteint, l'Ancre se pose.[pause=20] La Fosse d'Argent nous accepte.")
    else
      GAME:WaitFrames(20)
      UI:SetSpeaker(GAME:GetPlayerPartyMember(1))
      UI:SetSpeakerEmotion("Sad")
      UI:WaitShowDialogue("Deux Veilleurs, une seule nuit sans fond...[pause=20] Remontons.")
    end
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return new_era_zone_20
