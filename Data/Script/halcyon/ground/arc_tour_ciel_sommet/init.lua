-- [dungeon_builder] scène canonique PMD Red — scène d13p03 (end).
--[[ arc_tour_ciel_sommet — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d13p03.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D13P03_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local arc_tour_ciel_sommet = {}

local SCENE = 'd13p03'
local LINES = {'SCENE_D13P03_001', 'SCENE_D13P03_002', 'SCENE_D13P03_003', 'SCENE_D13P03_004', 'SCENE_D13P03_005', 'SCENE_D13P03_006', 'SCENE_D13P03_007', 'SCENE_D13P03_008', 'SCENE_D13P03_009', 'SCENE_D13P03_010', 'SCENE_D13P03_011', 'SCENE_D13P03_012', 'SCENE_D13P03_013', 'SCENE_D13P03_014', 'SCENE_D13P03_015', 'SCENE_D13P03_016', 'SCENE_D13P03_017', 'SCENE_D13P03_018', 'SCENE_D13P03_019'}
local MUSIC = nil

function arc_tour_ciel_sommet.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function arc_tour_ciel_sommet.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, LINES, MUSIC)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['sky_tower_summit'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function arc_tour_ciel_sommet.Update(map) end
function arc_tour_ciel_sommet.GameSave(map) end
function arc_tour_ciel_sommet.GameLoad(map)
  GAME:FadeIn(20)
end

return arc_tour_ciel_sommet
