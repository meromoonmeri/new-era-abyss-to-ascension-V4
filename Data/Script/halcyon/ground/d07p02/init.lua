-- [dungeon_builder] scène canonique PMD Red — scène d07p02 (end).
--[[ d07p02 — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d07p02.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D07P02_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local d07p02 = {}

local SCENE = 'd07p02'
local LINES = {'SCENE_D07P02_001', 'SCENE_D07P02_002', 'SCENE_D07P02_003', 'SCENE_D07P02_004', 'SCENE_D07P02_005', 'SCENE_D07P02_006', 'SCENE_D07P02_007', 'SCENE_D07P02_008', 'SCENE_D07P02_009', 'SCENE_D07P02_010', 'SCENE_D07P02_011', 'SCENE_D07P02_012', 'SCENE_D07P02_013', 'SCENE_D07P02_014', 'SCENE_D07P02_015', 'SCENE_D07P02_016', 'SCENE_D07P02_017', 'SCENE_D07P02_018', 'SCENE_D07P02_019', 'SCENE_D07P02_020', 'SCENE_D07P02_021', 'SCENE_D07P02_022', 'SCENE_D07P02_023', 'SCENE_D07P02_024', 'SCENE_D07P02_025', 'SCENE_D07P02_026', 'SCENE_D07P02_027', 'SCENE_D07P02_028', 'SCENE_D07P02_029', 'SCENE_D07P02_030', 'SCENE_D07P02_031', 'SCENE_D07P02_032', 'SCENE_D07P02_033', 'SCENE_D07P02_034', 'SCENE_D07P02_035', 'SCENE_D07P02_036', 'SCENE_D07P02_037', 'SCENE_D07P02_038', 'SCENE_D07P02_039', 'SCENE_D07P02_040', 'SCENE_D07P02_041', 'SCENE_D07P02_042', 'SCENE_D07P02_043', 'SCENE_D07P02_044', 'SCENE_D07P02_045', 'SCENE_D07P02_046', 'SCENE_D07P02_047', 'SCENE_D07P02_048', 'SCENE_D07P02_049', 'SCENE_D07P02_050', 'SCENE_D07P02_051', 'SCENE_D07P02_052', 'SCENE_D07P02_053', 'SCENE_D07P02_054', 'SCENE_D07P02_055', 'SCENE_D07P02_056', 'SCENE_D07P02_057', 'SCENE_D07P02_058', 'SCENE_D07P02_059', 'SCENE_D07P02_060', 'SCENE_D07P02_061', 'SCENE_D07P02_062', 'SCENE_D07P02_063', 'SCENE_D07P02_064', 'SCENE_D07P02_065', 'SCENE_D07P02_066', 'SCENE_D07P02_067', 'SCENE_D07P02_068', 'SCENE_D07P02_069', 'SCENE_D07P02_070', 'SCENE_D07P02_071', 'SCENE_D07P02_072', 'SCENE_D07P02_073', 'SCENE_D07P02_074', 'SCENE_D07P02_075', 'SCENE_D07P02_076', 'SCENE_D07P02_077', 'SCENE_D07P02_078', 'SCENE_D07P02_079', 'SCENE_D07P02_080', 'SCENE_D07P02_081', 'SCENE_D07P02_082', 'SCENE_D07P02_083', 'SCENE_D07P02_084', 'SCENE_D07P02_085', 'SCENE_D07P02_086', 'SCENE_D07P02_087', 'SCENE_D07P02_088', 'SCENE_D07P02_089', 'SCENE_D07P02_090', 'SCENE_D07P02_091', 'SCENE_D07P02_092', 'SCENE_D07P02_093', 'SCENE_D07P02_094', 'SCENE_D07P02_095', 'SCENE_D07P02_096', 'SCENE_D07P02_097', 'SCENE_D07P02_098', 'SCENE_D07P02_099', 'SCENE_D07P02_100', 'SCENE_D07P02_101'}
local MUSIC = 'In the Depths of the Pit'

function d07p02.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d07p02.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, LINES, MUSIC)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['great_canyon'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function d07p02.Update(map) end
function d07p02.GameSave(map) end
function d07p02.GameLoad(map)
  GAME:FadeIn(20)
end

return d07p02
