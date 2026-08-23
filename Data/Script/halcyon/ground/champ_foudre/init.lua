-- [dungeon_builder] scène canonique PMD Red — scène d17p01 (end).
--[[ champ_foudre — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d17p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D17P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local champ_foudre = {}

local SCENE = 'd17p01'
local LINES = {'SCENE_D17P01_001', 'SCENE_D17P01_002', 'SCENE_D17P01_003', 'SCENE_D17P01_004', 'SCENE_D17P01_005', 'SCENE_D17P01_006', 'SCENE_D17P01_007', 'SCENE_D17P01_008', 'SCENE_D17P01_009', 'SCENE_D17P01_010', 'SCENE_D17P01_011', 'SCENE_D17P01_012', 'SCENE_D17P01_013', 'SCENE_D17P01_014', 'SCENE_D17P01_015', 'SCENE_D17P01_016'}
local MUSIC = 'In the Depths of the Pit'

function champ_foudre.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function champ_foudre.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, LINES, MUSIC)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['lightning_field'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function champ_foudre.Update(map) end
function champ_foudre.GameSave(map) end
function champ_foudre.GameLoad(map)
  GAME:FadeIn(20)
end

return champ_foudre
