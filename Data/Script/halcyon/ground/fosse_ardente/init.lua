-- [dungeon_builder] scène canonique PMD Red — scène d12p04 (end).
--[[ fosse_ardente — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d12p04.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D12P04_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local fosse_ardente = {}

local SCENE = 'd12p04'
local LINES = {'SCENE_D12P04_001', 'SCENE_D12P04_002', 'SCENE_D12P04_003', 'SCENE_D12P04_004', 'SCENE_D12P04_005', 'SCENE_D12P04_006', 'SCENE_D12P04_007', 'SCENE_D12P04_008', 'SCENE_D12P04_009', 'SCENE_D12P04_010', 'SCENE_D12P04_011', 'SCENE_D12P04_012', 'SCENE_D12P04_013', 'SCENE_D12P04_014', 'SCENE_D12P04_015'}
local MUSIC = 'In the Depths of the Pit'

function fosse_ardente.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function fosse_ardente.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, LINES, MUSIC)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['magma_cavern_pit'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function fosse_ardente.Update(map) end
function fosse_ardente.GameSave(map) end
function fosse_ardente.GameLoad(map)
  GAME:FadeIn(20)
end

return fosse_ardente
