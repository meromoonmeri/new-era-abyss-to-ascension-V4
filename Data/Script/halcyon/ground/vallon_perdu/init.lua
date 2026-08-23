-- [dungeon_builder] scène canonique PMD Red — scène d22p01 (end).
--[[ vallon_perdu — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d22p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D22P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : scène de fin / arène du donjon (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local vallon_perdu = {}

local SCENE = 'd22p01'
local LINES = {'SCENE_D22P01_001', 'SCENE_D22P01_002', 'SCENE_D22P01_003', 'SCENE_D22P01_004', 'SCENE_D22P01_005'}
local MUSIC = nil

function vallon_perdu.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function vallon_perdu.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, LINES, MUSIC)
  GAME:CutsceneMode(false)
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  SV.CanonicalDungeons['pitfall_valley'] = true
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function vallon_perdu.Update(map) end
function vallon_perdu.GameSave(map) end
function vallon_perdu.GameLoad(map)
  GAME:FadeIn(20)
end

return vallon_perdu
