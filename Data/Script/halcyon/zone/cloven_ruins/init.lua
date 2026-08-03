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
  -- ==================================================================
  -- OSSATURE AEGIS CAVE — 8 secteurs (Lot 1)
  --   0 GLACE B1-B3      1 Chambre de Regice
  --   2 ROCHE B1-B3      3 Chambre de Regirock
  --   4 ACIER B1-B4      5 Chambre de Registeel
  --   6 LE PUITS B1-B5   7 Chambre de Regigigas
  --
  -- MECANIQUE CENTRALE, fidele a Explorers of Sky : un labyrinthe ne
  -- debouche PAS sur la chambre. Il BOUCLE : arrive au bout, l'equipe se
  -- retrouve a l'entree. La chambre ne s'ouvre que lorsque le mot du
  -- secteur est epele avec les pierres de Zarbi (systeme du Lot 2).
  -- Tant que RuinesMot[n] est faux, on reboucle sur le camp d'entree.
  -- ==================================================================
  local MOTS = { [0] = 'Glace', [2] = 'Roche', [4] = 'Acier' }

  -- Le mot du secteur est-il complet ? (pose par le Lot 2 ; par defaut
  -- faux, donc le secteur boucle — comportement d'origine du donjon.)
  local function motComplet(seg)
    local cle = MOTS[seg]
    if cle == nil then return true end
    local ok = false
    pcall(function()
      ok = (SV.Ruines ~= nil) and (SV.Ruines['Mot' .. cle] == true)
    end)
    return ok
  end

  -- Retour au camp d'entree : boucle de secteur OU echec.
  local function retourCamp(result, motif)
    GAME:WaitFrames(20)
    if motif ~= nil then SV.Chapter7.LostRuins = true end
    if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped
       and motif == 'echec' then
      GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('cloven_ruins_entrance'), 0, true, true)
      GAME:WaitFrames(20)
      GAME:EnterZone("master_zone", -1, GROUND_IDX('cloven_ruins_entrance'), 0)
    else
      GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('cloven_ruins_entrance'), 0, true, true)
    end
  end

  -- --- LABYRINTHES : 0 (Glace), 2 (Roche), 4 (Acier) -----------------
  if segmentID == 0 or segmentID == 2 or segmentID == 4 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ruinsActive() then
          if motComplet(segmentID) then
              -- Le mot est epele : l'escalier vers la chambre s'ouvre.
              -- Le mot est epele : on passe par le ground de cinematique du
              -- gardien, qui joue l'eveil PUIS lance le combat. Une apparition
              -- instantanee est interdite par les regles du projet.
              local GROUND_GARDIEN = { [0] = 'cloven_ruins_regice',
                                       [2] = 'cloven_ruins_regirock',
                                       [4] = 'cloven_ruins_registeel' }
              PrintInfo("[Ruines] secteur "..tostring(segmentID).." : mot complet -> "..GROUND_GARDIEN[segmentID])
              GAME:EnterGroundMap(GROUND_GARDIEN[segmentID], 'Main_Entrance_Marker')
          else
              -- Mot incomplet : le donjon boucle, comme dans EoS.
              PrintInfo("[Ruines] secteur "..tostring(segmentID).." : mot incomplet -> retour au camp")
              SV.Ruines = SV.Ruines or {}
              SV.Ruines.BoucleSecteur = segmentID
              retourCamp(result, nil)
          end
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          retourCamp(result, 'echec')
      end

  -- --- CHAMBRES DES REGI : 1, 3, 5 -----------------------------------
  elseif segmentID == 1 or segmentID == 3 or segmentID == 5 then
      local NOM = { [1] = 'Regice', [3] = 'Regirock', [5] = 'Registeel' }
      local qui = NOM[segmentID]
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Ruines = SV.Ruines or {}
          SV.Ruines['Vaincu' .. qui] = true
          PrintInfo("[Ruines] " .. qui .. " vaincu")
      else
          SV.Ruines = SV.Ruines or {}
          SV.Ruines['Perdu' .. qui] = true
      end
      -- Victoire comme defaite : on repasse par le ground du gardien, qui
      -- lit les flags et joue la scene d'apres-combat (patron mount_windswept).
      local RETOUR = { [1] = 'cloven_ruins_regice',
                       [3] = 'cloven_ruins_regirock',
                       [5] = 'cloven_ruins_registeel' }
      GAME:EnterGroundMap(RETOUR[segmentID], 'Main_Entrance_Marker')

  -- --- LE PUITS : 6 (5 etages, aucun puzzle) -------------------------
  elseif segmentID == 6 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared and ruinsActive() then
          PrintInfo("[Ruines] Puits franchi -> chambre de Regigigas")
          GAME:EnterGroundMap('cloven_ruins_boss', 'Main_Entrance_Marker')
      elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
          GAME:WaitFrames(20)
          SV.Chapter7.LostDepths = true
          if result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then
              SV.Chapter7.RuinsMidState = 'DeathArrival'
              GAME:EndDungeonRun(result, "master_zone", -1, GROUND_IDX('cloven_ruins_midpoint'), 0, true, true)
              GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1), "Le puits...[pause=0] il n'en finissait pas...", "Pain")
              GAME:WaitFrames(20)
              GAME:EnterZone("master_zone", -1, GROUND_IDX('cloven_ruins_midpoint'), 0)
          else
              GeneralFunctions.EndDungeonRun(result, "master_zone", -1, GROUND_IDX('cloven_ruins_midpoint'), 0, true, true)
          end
      end

  -- --- REGIGIGAS : 7 (boss final) ------------------------------------
  elseif segmentID == 7 then
      if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
          SV.Chapter7.DefeatedRuinsBoss = true
          -- Marque la victoire pour la scene de revelation jouee au camp
          -- (sortie d'Aegis Cave : la Tour des Reliques s'ouvre).
          SV.Ruines = SV.Ruines or {}
          SV.Ruines.VaincuRegigigas = true
          LegendZones.SetDefeated('colossus_quarry')
      else
          SV.Chapter7.DiedToRuinsBoss = true
      end

      -- Revanche achetee chez Grodoudou : l'histoire du ch7 est deja faite,
      -- on ne rejoue pas la cinematique, on ressort en ville.
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
