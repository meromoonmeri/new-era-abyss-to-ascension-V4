--[[
    init.lua — Zone de combat et d'ascension : Mont Windsep (mount_windsep)

    Cette zone permet de grimper les 10 étages du Mont Windsep
    pour affronter Tornadus à son sommet (Segment 1).
    
    Pour éviter les erreurs d'IndexOutOfRangeException de la boucle de combat du moteur (DungeonScene),
    le script décharge immédiatement le donjon après le combat et charge la carte au sol du Sommet 
    (mount_windswept_guardian) restaurée et valide pour y jouer toute la partie narrative et cinématique avec la Guilde.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local mount_windsep = {}

function mount_windsep.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mount_windsep")
  SV.TemporaryFlags.LastDungeonEntered = 'mount_windsep'
end

function mount_windsep.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function mount_windsep.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function mount_windsep.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_mount_windsep result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
    return
  end

  -- Victoire contre le boss au sommet (segmentID == 1)
  if segmentID == 1 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- On active le flag pour déclencher la cinématique de victoire officielle de la Guilde
    SV.Chapter5.MountGuardianDefeated = true
    
    -- On quitte immédiatement la scène de combat et on charge la carte au sol du sommet restaurée
    PrintInfo("[transition] mount_windsep -> Victoire ! Transition vers mount_windswept_guardian")
    GAME:EnterGroundMap('mount_windswept_guardian', 'Main_Entrance_Marker')
    return
  end

  -- Défaite contre le boss au sommet (segmentID == 1)
  if segmentID == 1 and result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- On active le flag pour déclencher la cinématique de retour de défaite
    SV.Chapter5.MountGuardianLost = true
    
    -- Transition vers la carte au sol du sommet pour la scène d'échec
    PrintInfo("[transition] mount_windsep -> Défaite ! Transition vers mount_windswept_guardian")
    GAME:EnterGroundMap('mount_windswept_guardian', 'Main_Entrance_Marker')
    return
  end

  -- Échec durant la montée (Segment 0) : retour standard à Metano Town (carte 1)
  if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:WaitFrames(20)
    UI:ResetSpeaker()
    UI:WaitShowDialogue("Vous avez succombé lors de l'ascension du Mont Windsep...")
    GAME:WaitFrames(20)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
    return
  end

  -- Par défaut : retour à Metano Town
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return mount_windsep
