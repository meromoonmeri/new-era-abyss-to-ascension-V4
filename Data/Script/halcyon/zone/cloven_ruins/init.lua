--[[
    init.lua
    Ruines Tordues (Cloven Ruins) — Chapitre 7
    conception_donjons_segmentes.md : 20 etages + relais + 3F + mini-boss
    (Kaorine + Golemastoc, segment 3) + 3F + boss Regigigas (segment 5).
    Segment 6 : annexe Toupie (etage mystere).
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.ReplayEnding'
require 'halcyon.LegendZones'

local cloven_ruins = {}

function cloven_ruins.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_cloven_ruins")
  SV.TemporaryFlags.LastDungeonEntered = 'cloven_ruins'
end

function cloven_ruins.EnterSegment(zone, rescuing, segmentID, mapID)
    GeneralFunctions.CheckAllowSetRescue(zone.ID)
    if rescuing ~= true then
        COMMON.BeginDungeon(zone.ID, segmentID, mapID)
    end
end

function cloven_ruins.Rescued(zone, name, mail)
    COMMON.Rescued(zone, name, mail)
end

function cloven_ruins.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_cloven_ruins result "..tostring(result).." segment "..tostring(segmentID))

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
      -- Ruines Tordues : 15 etages
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('cloven_ruins', 7) then
          -- Go to relay checkpoint
          GAME:EnterGroundMap('cloven_ruins_midpoint', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter7.LostRuins = true
          --Au CH5 (restructuration) : un KO dans la premiere moitie des
          --Ruines ramene au CAMPEMENT devant l'entree (cloven_ruins_entrance,
          --ground 65) — l'expedition se refait a partir du bivouac, pas a la
          --steppe (l'ancien ciblage 46 = vast_steppe_entrance etait un
          --vestige du ch7). Hors ch5, comportement historique conserve.
          if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5 then
              if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
                  GAME:EndDungeonRun(result, "master_zone", -1, 65, 0, true, true)
                  GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1), "Les ruines...[pause=0] c'est trop pour nous...[pause=10] On se refait au camp.", "Pain")
                  GAME:WaitFrames(20)
                  GAME:EnterZone("master_zone", -1, 65, 0)
              else
                  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 65, 0, true, true)
              end
          else
              if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
                  GAME:EndDungeonRun(result, "master_zone", -1, 46, 0, true, true)
                  GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1), "Les ruines...[pause=0] c'est trop pour nous...", "Pain")
                  GAME:WaitFrames(20)
                  GAME:EnterZone("master_zone", -1, 46, 0)
              else
                  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 46, 0, true, true)
              end
          end
      end
  elseif segmentID == 1 then
      -- Relais
      if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:EnterGroundMap('cloven_ruins_midpoint', 'Main_Entrance_Marker')
      end
  elseif segmentID == 2 then
      -- Premier 3F des profondeurs : le mini-boss attend au bout.
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('cloven_ruins', 7) then
          PrintInfo("[NREPROBE][transition] cloven seg2 cleared -> miniboss ground")
          GAME:EnterGroundMap('cloven_ruins_miniboss', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter7.LostDepths = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              SV.Chapter7.RuinsMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, 66, 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1), "Les profondeurs...[pause=0] on n'aurait pas du...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, 66, 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 66, 0, true, true)
          end
      end
  elseif segmentID == 3 then
      -- ARENE MINI-BOSS (Kaorine + Golemastoc) : victoire ou defaite, on
      -- revient sur la ground de cinematique qui lit les flags (patron
      -- mount_windswept, segment 1).
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter7.RuinsMiniBossDefeated = true
      else
          SV.Chapter7.RuinsMiniBossLost = true
      end
      PrintInfo("[NREPROBE][transition] cloven seg3 (arene) -> miniboss ground")
      GAME:EnterGroundMap('cloven_ruins_miniboss', 'Main_Entrance_Marker')
  elseif segmentID == 4 then
      -- Second 3F des profondeurs (au-dessus du mini-boss) : le sanctuaire
      -- des titans s'ouvre au bout.
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ReplayEnding.FollowsRoute('cloven_ruins', 7) then
          PrintInfo("[NREPROBE][transition] cloven seg4 cleared -> boss ground")
          GAME:EnterGroundMap('cloven_ruins_boss', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter7.LostDepths = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              SV.Chapter7.RuinsMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, 66, 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1), "Les profondeurs...[pause=0] on n'aurait pas du...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, 66, 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 66, 0, true, true)
          end
      end
  elseif segmentID == 5 then
      -- Boss Regigigas. Ce segment sert A LA FOIS au boss d'histoire du ch7 et
      -- a la revanche vendue par Grodoudou (LegendZones 'colossus_quarry',
      -- meme zone, meme segment 5). Les deux usages doivent etre traites.
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter7.DefeatedRuinsBoss = true
          -- Marque la zone-amie comme conquise (compteur de fin de jeu et
          -- dialogue de Grodoudou). Sans effet si elle n'a jamais ete achetee.
          LegendZones.SetDefeated('colossus_quarry')
      else
          SV.Chapter7.DiedToRuinsBoss = true
      end

      -- Revanche achetee chez Grodoudou : l'histoire du ch7 est deja faite, on
      -- ne rejoue pas la cinematique de boss, on ressort simplement en ville.
      if SV.Chapter7 ~= nil and SV.Chapter7.SawAnimaCoreCorruption == true
         and SV.ChapterProgression.Chapter ~= 7 then
          GAME:WaitFrames(20)
          GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
          return
      end

      GAME:EnterGroundMap('cloven_ruins_boss', 'Main_Entrance_Marker')
  end
end

return cloven_ruins
