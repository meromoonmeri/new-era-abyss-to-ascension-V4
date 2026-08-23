-- [dungeon_builder] scène canonique PMD Red — scène d10p03 (end).
--[[ d10p03 — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d10p03.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D10P03_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local d10p03 = {}

local SCENE = 'd10p03'
local LINES = {'SCENE_D10P03_001', 'SCENE_D10P03_002', 'SCENE_D10P03_003', 'SCENE_D10P03_004', 'SCENE_D10P03_005', 'SCENE_D10P03_006', 'SCENE_D10P03_007', 'SCENE_D10P03_008', 'SCENE_D10P03_009', 'SCENE_D10P03_010', 'SCENE_D10P03_011', 'SCENE_D10P03_012', 'SCENE_D10P03_013', 'SCENE_D10P03_014', 'SCENE_D10P03_015', 'SCENE_D10P03_016', 'SCENE_D10P03_017', 'SCENE_D10P03_018', 'SCENE_D10P03_019', 'SCENE_D10P03_020', 'SCENE_D10P03_021', 'SCENE_D10P03_022', 'SCENE_D10P03_023', 'SCENE_D10P03_024', 'SCENE_D10P03_025', 'SCENE_D10P03_026', 'SCENE_D10P03_027', 'SCENE_D10P03_028', 'SCENE_D10P03_029', 'SCENE_D10P03_030', 'SCENE_D10P03_031', 'SCENE_D10P03_032', 'SCENE_D10P03_033', 'SCENE_D10P03_034', 'SCENE_D10P03_035', 'SCENE_D10P03_036', 'SCENE_D10P03_037', 'SCENE_D10P03_038', 'SCENE_D10P03_039', 'SCENE_D10P03_040', 'SCENE_D10P03_041', 'SCENE_D10P03_042', 'SCENE_D10P03_043', 'SCENE_D10P03_044', 'SCENE_D10P03_045', 'SCENE_D10P03_046', 'SCENE_D10P03_047', 'SCENE_D10P03_048', 'SCENE_D10P03_049', 'SCENE_D10P03_050', 'SCENE_D10P03_051', 'SCENE_D10P03_052', 'SCENE_D10P03_053', 'SCENE_D10P03_054'}
local MUSIC = 'In the Depths of the Pit'

function d10p03.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d10p03.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, LINES, MUSIC)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['frosty_grotto'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function d10p03.Update(map) end
function d10p03.GameSave(map) end
function d10p03.GameLoad(map)
  GAME:FadeIn(20)
end

return d10p03
