--[[ Caverne du Silence Occidental — zone add-on (Réseau des Anciens Chemins, id origine 23).
     Progression fidèle pret/pmd-red : 100 étages.
     Aucun impact histoire : entrée/sortie via master_zone carte 1 (Metano). ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local new_era_zone_23 = {}

function new_era_zone_23.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_new_era_zone_23")
end

function new_era_zone_23.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function new_era_zone_23.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function new_era_zone_23.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end


  -- Veilleur du Réseau : segment 1 = arène (dusknoir).
  if segmentID == 0 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- Veilleur : passage par le ground partage, qui enchaine vers l'arene (seg 1).
    GAME:EnterGroundMap('antre_occident', 'Main_Entrance_Marker')
    return
  end
  if segmentID == 1 then
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      if SV.Reseau == nil then SV.Reseau = { Veilleurs = {} } end
      if SV.Reseau.Veilleurs == nil then SV.Reseau.Veilleurs = {} end
      SV.Reseau.Veilleurs['new_era_zone_23'] = true
      GAME:WaitFrames(20)
      UI:SetSpeaker(GAME:GetPlayerPartyMember(1))
      UI:SetSpeakerEmotion("Happy")
      UI:WaitShowDialogue("Le Portier-du-Vide s'écarte.[pause=20] Étrange...[pause=10] il semblait presque nous ATTENDRE.")
    else
      GAME:WaitFrames(20)
      UI:SetSpeaker(GAME:GetPlayerPartyMember(1))
      UI:SetSpeakerEmotion("Sad")
      UI:WaitShowDialogue("Ce silence...[pause=20] il nous a engloutis. Le Portier garde bien sa caverne.")
    end
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return new_era_zone_23
