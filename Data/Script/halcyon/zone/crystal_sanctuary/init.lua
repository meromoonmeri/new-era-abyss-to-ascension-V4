--[[
    init.lua
    Sanctuaire de Cristal (Crystal Sanctuary) — Chapitre 8
    conception_donjons_segmentes.md : etages + relais + 3F + mini-boss
    (Strassie + Momartik, segment 3) + 3F + boss Diancie (segment 5).
    Segment 6 : annexe Toupie (etage mystere).
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
  if segmentID == 6 then
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
      else
          --FILET DE SECURITE. Cleared mais FollowsRoute faux (visite de
          --rejouabilite, ou SV.ChapterProgression.Chapter bloque a 6 comme
          --l'explique ReplayEnding.lua:100) : les deux branches ci-dessus
          --etaient fausses et AUCUNE sortie n'etait appelee -> ecran noir.
          GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 46, 0, true, true)
      end
  elseif segmentID == 1 then
      -- Relais. Toute issue ramene sur la ground du relais : sans la
      -- branche Cleared, une sortie reussie de ce segment ne declenchait
      -- AUCUN EnterGroundMap et laissait le joueur sur un ecran noir.
      SV.Chapter8.SanctuaryMidReturn = true
      GAME:EnterGroundMap('crystal_sanctuary_relay', 'Main_Entrance_Marker')
  elseif segmentID == 2 then
      -- Premier 3F des Salles des Glyphes : le mini-boss attend au bout.
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('crystal_sanctuary', 8) then
          PrintInfo("[NREPROBE][transition] crystal seg2 cleared -> miniboss ground")
          GAME:EnterGroundMap('crystal_sanctuary_miniboss', 'Main_Entrance_Marker')
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
      else
          --FILET DE SECURITE (meme cas qu'au segment 0) : Cleared avec
          --FollowsRoute faux ne declenchait aucune sortie.
          GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 71, 0, true, true)
      end
  elseif segmentID == 3 then
      -- ARENE MINI-BOSS (Strassie + Momartik) : victoire ou defaite, on
      -- revient sur la ground de cinematique qui lit les flags.
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter8.CrystalMiniBossDefeated = true
      else
          SV.Chapter8.CrystalMiniBossLost = true
      end
      PrintInfo("[NREPROBE][transition] crystal seg3 (arene) -> miniboss ground")
      GAME:EnterGroundMap('crystal_sanctuary_miniboss', 'Main_Entrance_Marker')
  elseif segmentID == 4 then
      -- Second 3F des Salles des Glyphes : la chambre de Diancie s'ouvre.
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('crystal_sanctuary', 8) then
          SV.Chapter8.ReachedDiancieChamber = true
          PrintInfo("[NREPROBE][transition] crystal seg4 cleared -> boss ground")
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
      else
          --FILET DE SECURITE (meme cas qu'au segment 0) : Cleared avec
          --FollowsRoute faux ne declenchait aucune sortie.
          GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 71, 0, true, true)
      end
  elseif segmentID == 5 then
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
