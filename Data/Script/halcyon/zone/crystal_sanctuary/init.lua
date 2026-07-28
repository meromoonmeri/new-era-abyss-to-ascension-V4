--[[
    init.lua
    Sanctuaire de Cristal (Crystal Sanctuary) — Chapitre 8
    18 etages en 4 segments : 12 cristallins + relais + 6 glyphes + boss Diancie
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.ChapterAftermath'
require 'halcyon.ReplayEnding'

local crystal_sanctuary = {}

function crystal_sanctuary.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_crystal_sanctuary")
  SV.TemporaryFlags.LastDungeonEntered = 'crystal_sanctuary'
end

function crystal_sanctuary.EnterSegment(zone, rescuing, segmentID, mapID)
    GeneralFunctions.CheckAllowSetRescue(zone.ID)
    if rescuing ~= true then
        COMMON.BeginDungeon(zone.ID, segmentID, mapID)
    end
end

function crystal_sanctuary.Rescued(zone, name, mail)
    COMMON.Rescued(zone, name, mail)
end

function crystal_sanctuary.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_crystal_sanctuary result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false

  if exited == true then
      return
  end
  if segmentID == 4 then
    -- Annexe de la Toupie (etage mystere) : sortie douce.
    GAME:WaitFrames(10)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
    return
  end

  if segmentID == 0 then
      -- Galerie Cristalline : 12 etages
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('crystal_sanctuary', 8) then
          SV.Chapter8.ReachedCrystalRelay = true
          GAME:EnterGroundMap('crystal_sanctuary_relay', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter8.LostCrystalGallery = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              GAME:EndDungeonRun(result, "master_zone", -1, 46, 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
                  "Les cristaux...[pause=0] ils emprisonnent tout...[pause=15] meme la lumiere...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, 46, 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 46, 0, true, true)
          end
      end
  elseif segmentID == 1 then
      -- Relais
      if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:EnterGroundMap('crystal_sanctuary_relay', 'Main_Entrance_Marker')
      end
  elseif segmentID == 2 then
      -- Salles des Glyphes : 6 etages
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('crystal_sanctuary', 8) then
          SV.Chapter8.ReachedDiancieChamber = true
          GAME:EnterGroundMap('crystal_sanctuary_boss', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter8.LostGlyphHalls = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              SV.Chapter8.SanctuaryMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, 71, 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
                  "Les runes...[pause=0] elles parlent...[pause=20] mais on ne comprend pas...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, 71, 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 71, 0, true, true)
          end
      end
  elseif segmentID == 3 then
      -- Boss Diancie
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter8.DefeatedDiancie = true
          SV.Chapter8.ObtainedCrystalFragment = true
          SV.Chapter8.CrystalSanctuaryComplete = true
          --Scene d'apres-boss : la consequence se joue AVANT le retour a la
          --guilde. Sans elle, le combat le plus important du chapitre se
          --terminait par un simple fondu vers la fin de journee.
          ChapterAftermath.CrystalVictory()
          --Fin de chapitre : on rentre dormir a la guilde pour la veillee
          --(guild_heros_room_ch_8). Sans ces drapeaux la scene de chambre ne se
          --declenchait JAMAIS, et sans la carte 2 on ressortait au relais du donjon.
          SV.TemporaryFlags.Dinnertime = true
          SV.TemporaryFlags.Bedtime = true
          SV.TemporaryFlags.MorningWakeup = true
          SV.TemporaryFlags.MorningAddress = true
          GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 2, 0, true, true)
      else
          SV.Chapter8.DiedToDiancie = true
          SV.Chapter8.SanctuaryMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, 71, 0, true, true)
          GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1),
              "Diancie...[pause=0] sa puissance...[pause=15] trop eclatante...", "Pain")
          GAME:WaitFrames(20)
          GAME:EnterZone("master_zone", -1, 71, 0)
      end
  end
end

return crystal_sanctuary
