-- [dungeon_builder] scène canonique PMD Red — scène d01p01 (entrance).
--[[ foret_tendre_oree — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d01p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D01P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : entrée du donjon — aucun combat (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     Aucun boss ici : dans PMD Red les combats de gardien se jouent à la
     scène de fin du donjon ou dans le donjon lui-même.
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local foret_tendre_oree = {}

local SCENE = 'd01p01'
local LINES = {'SCENE_D01P01_001', 'SCENE_D01P01_002', 'SCENE_D01P01_003', 'SCENE_D01P01_004', 'SCENE_D01P01_005', 'SCENE_D01P01_006', 'SCENE_D01P01_007', 'SCENE_D01P01_008', 'SCENE_D01P01_009', 'SCENE_D01P01_010', 'SCENE_D01P01_011', 'SCENE_D01P01_012', 'SCENE_D01P01_013', 'SCENE_D01P01_014', 'SCENE_D01P01_015', 'SCENE_D01P01_016', 'SCENE_D01P01_017', 'SCENE_D01P01_018', 'SCENE_D01P01_019', 'SCENE_D01P01_020', 'SCENE_D01P01_021', 'SCENE_D01P01_022', 'SCENE_D01P01_023', 'SCENE_D01P01_024', 'SCENE_D01P01_025', 'SCENE_D01P01_026', 'SCENE_D01P01_027', 'SCENE_D01P01_028', 'SCENE_D01P01_029', 'SCENE_D01P01_030', 'SCENE_D01P01_031', 'SCENE_D01P01_032', 'SCENE_D01P01_033', 'SCENE_D01P01_034', 'SCENE_D01P01_035', 'SCENE_D01P01_036', 'SCENE_D01P01_037', 'SCENE_D01P01_038', 'SCENE_D01P01_039', 'SCENE_D01P01_040', 'SCENE_D01P01_041', 'SCENE_D01P01_042', 'SCENE_D01P01_043', 'SCENE_D01P01_044', 'SCENE_D01P01_045', 'SCENE_D01P01_046', 'SCENE_D01P01_047', 'SCENE_D01P01_048', 'SCENE_D01P01_049', 'SCENE_D01P01_050', 'SCENE_D01P01_051', 'SCENE_D01P01_052', 'SCENE_D01P01_053', 'SCENE_D01P01_054', 'SCENE_D01P01_055', 'SCENE_D01P01_056', 'SCENE_D01P01_057', 'SCENE_D01P01_058', 'SCENE_D01P01_059', 'SCENE_D01P01_060', 'SCENE_D01P01_061', 'SCENE_D01P01_062', 'SCENE_D01P01_063'}
local MUSIC = nil

function foret_tendre_oree.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function foret_tendre_oree.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, LINES, MUSIC)
  GAME:CutsceneMode(false)
  GAME:FadeOut(false, 30)
  GAME:EnterDungeon('tiny_woods', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function foret_tendre_oree.Update(map) end
function foret_tendre_oree.GameSave(map) end
function foret_tendre_oree.GameLoad(map)
  GAME:FadeIn(20)
end

return foret_tendre_oree
