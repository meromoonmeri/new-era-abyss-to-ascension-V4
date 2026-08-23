-- [dungeon_builder] scène canonique PMD Red — scène d24p01 (end).
--[[ caverne_trouble_fond — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d24p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D24P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local caverne_trouble_fond = {}

local SCENE = 'd24p01'
local LINES = {'SCENE_D24P01_001', 'SCENE_D24P01_002', 'SCENE_D24P01_003', 'SCENE_D24P01_004', 'SCENE_D24P01_005', 'SCENE_D24P01_006', 'SCENE_D24P01_007', 'SCENE_D24P01_008', 'SCENE_D24P01_009', 'SCENE_D24P01_010', 'SCENE_D24P01_011', 'SCENE_D24P01_012', 'SCENE_D24P01_013', 'SCENE_D24P01_014', 'SCENE_D24P01_015', 'SCENE_D24P01_016', 'SCENE_D24P01_017', 'SCENE_D24P01_018', 'SCENE_D24P01_019', 'SCENE_D24P01_020', 'SCENE_D24P01_021', 'SCENE_D24P01_022', 'SCENE_D24P01_023', 'SCENE_D24P01_024', 'SCENE_D24P01_025', 'SCENE_D24P01_026', 'SCENE_D24P01_027', 'SCENE_D24P01_028', 'SCENE_D24P01_029', 'SCENE_D24P01_030', 'SCENE_D24P01_031', 'SCENE_D24P01_032', 'SCENE_D24P01_033', 'SCENE_D24P01_034', 'SCENE_D24P01_035', 'SCENE_D24P01_036', 'SCENE_D24P01_037', 'SCENE_D24P01_038', 'SCENE_D24P01_039', 'SCENE_D24P01_040', 'SCENE_D24P01_041', 'SCENE_D24P01_042', 'SCENE_D24P01_043', 'SCENE_D24P01_044', 'SCENE_D24P01_045', 'SCENE_D24P01_046', 'SCENE_D24P01_047', 'SCENE_D24P01_048', 'SCENE_D24P01_049', 'SCENE_D24P01_050', 'SCENE_D24P01_051', 'SCENE_D24P01_052', 'SCENE_D24P01_053', 'SCENE_D24P01_054', 'SCENE_D24P01_055', 'SCENE_D24P01_056', 'SCENE_D24P01_057', 'SCENE_D24P01_058', 'SCENE_D24P01_059', 'SCENE_D24P01_060', 'SCENE_D24P01_061', 'SCENE_D24P01_062', 'SCENE_D24P01_063', 'SCENE_D24P01_064', 'SCENE_D24P01_065', 'SCENE_D24P01_066', 'SCENE_D24P01_067', 'SCENE_D24P01_068', 'SCENE_D24P01_069', 'SCENE_D24P01_070', 'SCENE_D24P01_071', 'SCENE_D24P01_072', 'SCENE_D24P01_073', 'SCENE_D24P01_074', 'SCENE_D24P01_075', 'SCENE_D24P01_076', 'SCENE_D24P01_077', 'SCENE_D24P01_078', 'SCENE_D24P01_079', 'SCENE_D24P01_080'}
local MUSIC = 'In the Depths of the Pit'

function caverne_trouble_fond.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function caverne_trouble_fond.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, LINES, MUSIC)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['murky_cave'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function caverne_trouble_fond.Update(map) end
function caverne_trouble_fond.GameSave(map) end
function caverne_trouble_fond.GameLoad(map)
  GAME:FadeIn(20)
end

return caverne_trouble_fond
