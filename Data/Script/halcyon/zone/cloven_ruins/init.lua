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

--------------------------------------------------------------------
-- INDEX DES GROUNDS DE master_zone — resolus PAR NOM
--
-- Correctif du 2026-08-02. Les sorties de ce fichier ciblaient des
-- index ecrits en dur qui ne correspondaient pas aux cartes voulues :
--
--   ecrit 65 (« cloven_ruins_entrance » selon le commentaire d'origine)
--     -> master_zone.GroundMaps[65] = vast_steppe_midpoint
--   ecrit 66 (relais des Ruines attendu)
--     -> master_zone.GroundMaps[66] = mount_windswept_midpoint
--
-- Consequence en jeu : apres un KO ou un abandon dans les Ruines, le
-- joueur etait depose au relais de la Grande Steppe. La cinematique du
-- Camp des Ruines ne se lancait donc jamais — non parce que ses flags
-- etaient faux (SV.Chapter5.PlayTempRuinsScene etait bien pose), mais
-- parce que le joueur n'arrivait pas sur la carte qui les lit.
--
-- Les vrais index sont 67 (entrance) et 69 (midpoint). Plutot que de
-- corriger deux nombres qui rederiveront au prochain ajout de ground,
-- on les resout par NOM a l'execution. GROUND_IDX rend l'index reel ou
-- une valeur de repli sure (la ville) si le nom disparait.
--------------------------------------------------------------------
local MASTER_FALLBACK = 1  -- metano_town

local function GROUND_IDX(name)
  local ok, idx = pcall(function()
    local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("master_zone")
    for ii = 0, zone.Grounds.Count - 1, 1 do
      if zone.Grounds[ii] == name then return ii end
    end
    return -1
  end)
  if not ok or idx == nil or idx < 0 then
    PrintInfo("[cloven_ruins] ground introuvable dans master_zone : " .. tostring(name)
              .. " — repli sur " .. tostring(MASTER_FALLBACK))
    return MASTER_FALLBACK
  end
  return idx
end

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

--LES RUINES FENDUES se jouent au ch5 (climax de l'expedition,
--restructuration validee) et, pour les sauvegardes existantes, encore
--au ch7 (tant que l'arc Groudon n'a pas remplace le donjon d'histoire
--du ch7). En rejouabilite, la zone terminee reste jouable.
local function ruinsActive()
  if SV.ChapterProgression ~= nil then
    local ch = SV.ChapterProgression.Chapter
    if ch == 5 or ch == 7 then return true end
  end
  return ReplayEnding.IsCleared('cloven_ruins')
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
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ruinsActive() then
          -- Go to relay checkpoint
          GAME:EnterGroundMap('cloven_ruins_midpoint', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter7.LostRuins = true
          --Au CH5 (restructuration) : un KO ou un abandon dans la premiere
          --moitie des Ruines ramene au CAMPEMENT devant l'entree
          --(cloven_ruins_entrance, resolu par nom) — l'expedition se refait a
          --partir du bivouac, pas a la steppe (l'ancien ciblage 46 etait un
          --vestige du ch7). Le camp joue la cinematique de retour : reveil
          --(KO, 'Died') ou repli (abandon, 'Retreated'), patron du Mont.
          --Hors ch5, comportement historique conserve.
          if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5 then
              SV.Chapter5.PlayTempRuinsScene = true
              if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
                  SV.Chapter5.RuinsLastExitReason = 'Died'
                  GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('cloven_ruins_entrance'), 0, true, true)
                  GAME:WaitFrames(20)
                  GAME:EnterZone("master_zone", -1, GROUND_IDX('cloven_ruins_entrance'), 0)
              else
                  SV.Chapter5.RuinsLastExitReason = 'Retreated'
                  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('cloven_ruins_entrance'), 0, true, true)
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
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ruinsActive() then
          PrintInfo("[NREPROBE][transition] cloven seg2 cleared -> miniboss ground")
          GAME:EnterGroundMap('cloven_ruins_miniboss', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter7.LostDepths = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              SV.Chapter7.RuinsMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('cloven_ruins_midpoint'), 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1), "Les profondeurs...[pause=0] on n'aurait pas du...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, GROUND_IDX('cloven_ruins_midpoint'), 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('cloven_ruins_midpoint'), 0, true, true)
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
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ruinsActive() then
          PrintInfo("[NREPROBE][transition] cloven seg4 cleared -> boss ground")
          GAME:EnterGroundMap('cloven_ruins_boss', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter7.LostDepths = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              SV.Chapter7.RuinsMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('cloven_ruins_midpoint'), 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1), "Les profondeurs...[pause=0] on n'aurait pas du...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, GROUND_IDX('cloven_ruins_midpoint'), 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('cloven_ruins_midpoint'), 0, true, true)
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
