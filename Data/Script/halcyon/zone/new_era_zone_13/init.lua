--[[ Aiguille du Zéro Absolu — zone add-on (Réseau des Anciens Chemins, id origine 13).
     Progression fidèle pret/pmd-red : 16 étages + relais + 6 étages (cime).
     Aucun impact histoire : entrée/sortie via master_zone carte 1 (Metano). ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local new_era_zone_13 = {}

function new_era_zone_13.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_new_era_zone_13")
end

function new_era_zone_13.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function new_era_zone_13.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function new_era_zone_13.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end

  -- Segment 0 franchi : halte à la Station-Relais (Terminal de Sauvegarde).
  if segmentID == 0 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EnterGroundMap('new_era_zone_13_relais', 'Main_Entrance_Marker')
    return
  end


  -- Veilleur du Réseau : segment 2 = arène (froslass/glalie).
  if segmentID == 1 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:ContinueDungeon("new_era_zone_13", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end
  if segmentID == 2 then
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      if SV.Reseau == nil then SV.Reseau = { Veilleurs = {} } end
      if SV.Reseau.Veilleurs == nil then SV.Reseau.Veilleurs = {} end
      SV.Reseau.Veilleurs['new_era_zone_13'] = true
      GAME:WaitFrames(20)
      UI:SetSpeaker(GAME:GetPlayerPartyMember(1))
      UI:SetSpeakerEmotion("Happy")
      UI:WaitShowDialogue("Les deux masques de glace se dissipent.[pause=20] L'Aiguille nous laisse passer.")
    else
      GAME:WaitFrames(20)
      UI:SetSpeaker(GAME:GetPlayerPartyMember(1))
      UI:SetSpeakerEmotion("Sad")
      UI:WaitShowDialogue("Voile-Blanc et Masque-Gel veillent toujours...[pause=20] Le Zéro Absolu attendra.")
    end
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return new_era_zone_13
