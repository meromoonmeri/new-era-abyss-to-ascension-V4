-- [dungeon_builder] scène canonique PMD Red — scène d20p01 (end).
--[[ antre_occident — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d20p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D20P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local antre_occident = {}

local SCENE = 'd20p01'
local LINES = {'SCENE_D20P01_001', 'SCENE_D20P01_002', 'SCENE_D20P01_003', 'SCENE_D20P01_004', 'SCENE_D20P01_005', 'SCENE_D20P01_006', 'SCENE_D20P01_007', 'SCENE_D20P01_008', 'SCENE_D20P01_009', 'SCENE_D20P01_010', 'SCENE_D20P01_011', 'SCENE_D20P01_012', 'SCENE_D20P01_013', 'SCENE_D20P01_014', 'SCENE_D20P01_015', 'SCENE_D20P01_016', 'SCENE_D20P01_017', 'SCENE_D20P01_018', 'SCENE_D20P01_019', 'SCENE_D20P01_020', 'SCENE_D20P01_021', 'SCENE_D20P01_022', 'SCENE_D20P01_023', 'SCENE_D20P01_024', 'SCENE_D20P01_025', 'SCENE_D20P01_026', 'SCENE_D20P01_027', 'SCENE_D20P01_028', 'SCENE_D20P01_029', 'SCENE_D20P01_030', 'SCENE_D20P01_031', 'SCENE_D20P01_032', 'SCENE_D20P01_033', 'SCENE_D20P01_034'}
local MUSIC = nil

function antre_occident.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function antre_occident.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, LINES, MUSIC)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['western_cave'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function antre_occident.Update(map) end
function antre_occident.GameSave(map) end
function antre_occident.GameLoad(map)
  GAME:FadeIn(20)
end

return antre_occident
