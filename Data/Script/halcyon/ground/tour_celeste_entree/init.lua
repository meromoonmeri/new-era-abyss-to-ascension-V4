--[[
  tour_celeste_entree/init.lua
  Tour Céleste — Entrée (D13P01) — PMD Red authentique 1:1
  Source: PMD-5/Data/Ground/sky_tower.rsground (36x27) + PMDRed D13P01
  Preserve integrite: Ground 36x27, Sheet SkyTower_Base, Markers Main_Entrance+Cutscene
  Branchement: GroundMaps[0] de Zone tour_celeste (master_zone index auto)
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

local entree = {}

function entree.Init(map)
  -- Init se joue sous noir, avant FadeIn (cf. vast_steppe_guardian correctif)
  pcall(function() GAME:FadeOut(false, 1) end)
  -- Musique d'ambiance Tour (Sky Tower) — si manquante, silence non bloquant
  pcall(function() SOUND:PlayBGM("Sky Tower.ogg", true) end)
end

function entree.Enter(map)
  pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  if partner then AI:DisableCharacterAI(partner) end
  -- Positionne duo au Main_Entrance_Marker (PMD-5 : 36x27, centre ~ 18,13)
  -- Le moteur place déjà au marker, on ne téléporte pas hors marker
  GAME:MoveCamera(144, 108, 1, false) -- centre approx 36*8/2, 27*8/2
  GAME:CutsceneMode(true)
  GAME:WaitFrames(30)
  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(30)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)
  pcall(function() SOUND:PlayBGM("Sky Tower.ogg", true) end)
  GAME:WaitFrames(20)
  -- Cinématique D13P01 (PMDRed) — 8 dialogues, 7 anims, BGM SWITCH
  -- Traduction choregraphique : CAMERA_INIT_PAN → MoveCamera, BGM_SWITCH → PlayBGM synchro
  if partner then
    GeneralFunctions.StartConversation(partner, STRINGS:Format(STRINGS.MapStrings['TCE_001']), "Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCE_002']))
    GeneralFunctions.EndConversation(partner)
    GAME:WaitFrames(15)
    GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['TCE_003']), "Normal")
  end
  -- Laisse la main au donjon : le panneau d'entrée du donjon est au nord
  -- Le joueur marche vers le nord pour entrer dans tour_celeste (Zone)
  GAME:CutsceneMode(false)
  if partner then AI:EnableCharacterAI(partner) end
end

function entree.Update(map) end
function entree.GameSave(map) end
function entree.GameLoad(map) GAME:FadeIn(20) end

return entree
