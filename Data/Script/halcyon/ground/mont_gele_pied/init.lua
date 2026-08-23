-- [dungeon_builder] scène canonique PMD Red — scène d11p01 (entrance).
--[[ mont_gele_pied — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d11p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D11P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : entrée du donjon — aucun combat (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     Aucun boss ici : dans PMD Red les combats de gardien se jouent à la
     scène de fin du donjon ou dans le donjon lui-même.
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local mont_gele_pied = {}

local SCENE = 'd11p01'
local LINES = {'SCENE_D11P01_001', 'SCENE_D11P01_002', 'SCENE_D11P01_003', 'SCENE_D11P01_004', 'SCENE_D11P01_005', 'SCENE_D11P01_006', 'SCENE_D11P01_007', 'SCENE_D11P01_008', 'SCENE_D11P01_009', 'SCENE_D11P01_010', 'SCENE_D11P01_011', 'SCENE_D11P01_012', 'SCENE_D11P01_013', 'SCENE_D11P01_014', 'SCENE_D11P01_015', 'SCENE_D11P01_016', 'SCENE_D11P01_017', 'SCENE_D11P01_018', 'SCENE_D11P01_019', 'SCENE_D11P01_020', 'SCENE_D11P01_021', 'SCENE_D11P01_022', 'SCENE_D11P01_023'}
local MUSIC = nil

function mont_gele_pied.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function mont_gele_pied.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, LINES, MUSIC)
  GAME:CutsceneMode(false)
  GAME:FadeOut(false, 30)
  GAME:EnterDungeon('mt_freeze', 0, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function mont_gele_pied.Update(map) end
function mont_gele_pied.GameSave(map) end
function mont_gele_pied.GameLoad(map)
  GAME:FadeIn(20)
end

return mont_gele_pied
