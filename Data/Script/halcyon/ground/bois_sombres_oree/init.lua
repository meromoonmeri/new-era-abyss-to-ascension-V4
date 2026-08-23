-- [dungeon_builder] scène canonique PMD Red — scène d04p01 (entrance).
--[[ bois_sombres_oree — cinématique canonique de Pokémon Mystery Dungeon: Red Rescue Team.

     Structure reprise du squelette extrait de la ROM
     (RESERVE/red_scene_reference/d04p01.lua) : musique, ordre et nombre de
     répliques, actions. Aucune réplique inventée : chaque ligne est la clé de
     texte canonique `SCENE_D04P01_nnn`. Les clés absentes des Strings du mod
     sont sautées — importer le texte de la ROM avec
     `tools/audit_pmdred_eu_rom.py` les fera apparaître.

     Rôle canonique : entrée du donjon — aucun combat (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md).
     Aucun boss ici : dans PMD Red les combats de gardien se jouent à la
     scène de fin du donjon ou dans le donjon lui-même.
     Regénérer : python3 tools/dungeon_builder.py canon-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.RedCanonScene'

local bois_sombres_oree = {}

local SCENE = 'd04p01'
local LINES = {'SCENE_D04P01_001', 'SCENE_D04P01_002'}
local MUSIC = 'Sinister Woods'

function bois_sombres_oree.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
end

function bois_sombres_oree.Enter(map)
  DEBUG.EnableDbgCoro()
  GAME:FadeIn(20)
  RedCanonScene.Play(SCENE, LINES, MUSIC)
  -- aucune suite câblée : la scène rend la main au jeu
  GAME:CutsceneMode(false)
end

function bois_sombres_oree.Update(map) end
function bois_sombres_oree.GameSave(map) end
function bois_sombres_oree.GameLoad(map)
  GAME:FadeIn(20)
end

return bois_sombres_oree
