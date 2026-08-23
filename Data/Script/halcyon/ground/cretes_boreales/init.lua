-- [dungeon_builder] scène canonique PMD Red — scène d21p01 (end).
--[[ cretes_boreales — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d21p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D21P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local cretes_boreales = {}

local SCENE = 'd21p01'
local LINES = {'SCENE_D21P01_001', 'SCENE_D21P01_002', 'SCENE_D21P01_003', 'SCENE_D21P01_004'}
local MUSIC = 'In the Depths of the Pit'

function cretes_boreales.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function cretes_boreales.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, LINES, MUSIC)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['northern_range'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function cretes_boreales.Update(map) end
function cretes_boreales.GameSave(map) end
function cretes_boreales.GameLoad(map)
  GAME:FadeIn(20)
end

return cretes_boreales
