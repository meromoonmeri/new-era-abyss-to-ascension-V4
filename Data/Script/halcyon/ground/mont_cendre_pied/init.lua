-- [dungeon_builder] scène canonique PMD Red — scène d09p01 (entrance).
--[[ mont_cendre_pied — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d09p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D09P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : entrée du donjon — aucun combat (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     Aucun boss ici : dans PMD Red les combats de gardien se jouent à la
     scène de fin du donjon ou dans le donjon lui-même.
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local mont_cendre_pied = {}

local SCENE = 'd09p01'
local LINES = {'SCENE_D09P01_001', 'SCENE_D09P01_002', 'SCENE_D09P01_003', 'SCENE_D09P01_004', 'SCENE_D09P01_005', 'SCENE_D09P01_006', 'SCENE_D09P01_007', 'SCENE_D09P01_008', 'SCENE_D09P01_009', 'SCENE_D09P01_010', 'SCENE_D09P01_011', 'SCENE_D09P01_012', 'SCENE_D09P01_013', 'SCENE_D09P01_014', 'SCENE_D09P01_015', 'SCENE_D09P01_016', 'SCENE_D09P01_017', 'SCENE_D09P01_018', 'SCENE_D09P01_019', 'SCENE_D09P01_020', 'SCENE_D09P01_021', 'SCENE_D09P01_022', 'SCENE_D09P01_023', 'SCENE_D09P01_024', 'SCENE_D09P01_025', 'SCENE_D09P01_026', 'SCENE_D09P01_027', 'SCENE_D09P01_028', 'SCENE_D09P01_029', 'SCENE_D09P01_030', 'SCENE_D09P01_031', 'SCENE_D09P01_032'}
local MUSIC = 'Mt. Blaze'

function mont_cendre_pied.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function mont_cendre_pied.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, LINES, MUSIC)
  GAME:CutsceneMode(false)
  GAME:FadeOut(false, 30)
  GAME:EnterDungeon('mt_blaze', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function mont_cendre_pied.Update(map) end
function mont_cendre_pied.GameSave(map) end
function mont_cendre_pied.GameLoad(map)
  GAME:FadeIn(20)
end

return mont_cendre_pied
