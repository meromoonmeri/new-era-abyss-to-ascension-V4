-- [dungeon_builder] scène canonique PMD Red — scène d06p03 (end).
--[[ d06p03 — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d06p03.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D06P03_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local d06p03 = {}

local SCENE = 'd06p03'
local LINES = {'SCENE_D06P03_001', 'SCENE_D06P03_002', 'SCENE_D06P03_003', 'SCENE_D06P03_004', 'SCENE_D06P03_005', 'SCENE_D06P03_006', 'SCENE_D06P03_007', 'SCENE_D06P03_008', 'SCENE_D06P03_009', 'SCENE_D06P03_010', 'SCENE_D06P03_011', 'SCENE_D06P03_012', 'SCENE_D06P03_013', 'SCENE_D06P03_014', 'SCENE_D06P03_015', 'SCENE_D06P03_016', 'SCENE_D06P03_017', 'SCENE_D06P03_018', 'SCENE_D06P03_019', 'SCENE_D06P03_020', 'SCENE_D06P03_021', 'SCENE_D06P03_022', 'SCENE_D06P03_023', 'SCENE_D06P03_024', 'SCENE_D06P03_025', 'SCENE_D06P03_026', 'SCENE_D06P03_027', 'SCENE_D06P03_028', 'SCENE_D06P03_029', 'SCENE_D06P03_030', 'SCENE_D06P03_031', 'SCENE_D06P03_032', 'SCENE_D06P03_033', 'SCENE_D06P03_034', 'SCENE_D06P03_035', 'SCENE_D06P03_036', 'SCENE_D06P03_037', 'SCENE_D06P03_038', 'SCENE_D06P03_039', 'SCENE_D06P03_040', 'SCENE_D06P03_041', 'SCENE_D06P03_042', 'SCENE_D06P03_043', 'SCENE_D06P03_044', 'SCENE_D06P03_045', 'SCENE_D06P03_046', 'SCENE_D06P03_047', 'SCENE_D06P03_048', 'SCENE_D06P03_049'}
local MUSIC = 'In the Depths of the Pit'

function d06p03.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d06p03.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, LINES, MUSIC)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['mt_thunder_peak'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function d06p03.Update(map) end
function d06p03.GameSave(map) end
function d06p03.GameLoad(map)
  GAME:FadeIn(20)
end

return d06p03
