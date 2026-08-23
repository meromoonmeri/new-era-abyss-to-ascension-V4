-- [dungeon_builder] scène canonique PMD Red — scène d03p02 (end).
--[[ d03p02 — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d03p02.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D03P02_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local d03p02 = {}

local SCENE = 'd03p02'
local LINES = {'SCENE_D03P02_001', 'SCENE_D03P02_002', 'SCENE_D03P02_003', 'SCENE_D03P02_004', 'SCENE_D03P02_005', 'SCENE_D03P02_006', 'SCENE_D03P02_007', 'SCENE_D03P02_008', 'SCENE_D03P02_009', 'SCENE_D03P02_010', 'SCENE_D03P02_011', 'SCENE_D03P02_012'}
local MUSIC = 'In the Depths of the Pit'

function d03p02.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function d03p02.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, LINES, MUSIC)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['mt_steel'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function d03p02.Update(map) end
function d03p02.GameSave(map) end
function d03p02.GameLoad(map)
  GAME:FadeIn(20)
end

return d03p02
