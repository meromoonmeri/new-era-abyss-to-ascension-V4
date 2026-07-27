--[[ Celestial Peak Boss — Lugia, Gardien des Cieux
     Intro 3 couches (addendum A) :
       generique : Voix de l'Abysse -> flash blanc -> reveal + titre
       biome     : sommet/ciel -> BossFX.DescendSky (descente reelle depuis les nuages,
                   battements d'ailes, plumes, impact au sol)
       signature : Lugia deploie ses ailes (pose Attack figee) avant de juger l'equipe ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
local celestial_peak_boss = {}
function celestial_peak_boss.Init(map) DEBUG.EnableDbgCoro() end
function celestial_peak_boss.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GAME:FadeIn(60)
  GAME:WaitFrames(30)

  -- Couche generique : la Voix de l'Abysse, une derniere fois avant le sommet.
  BossFX.Voice('CPB_001')

  -- Couche biome (ciel) : le vent se leve, Lugia descend des nuages.
  local lugia = CharacterEssentials.MakeCharactersFromList({{'Lugia', 156, 140, Direction.Down}})
  GROUND:Hide('Lugia')
  GAME:MoveCamera(156, 110, 30, false)
  BossFX.DescendSky(lugia, 156, 140, 160)

  -- Recul du groupe : le souffle de l'atterrissage les repousse.
  BossFX.PushBack({hero, partner}, Direction.Down)

  -- Couche Pokemon : Lugia deploie ses ailes, fige sur l'amorce d'attaque.
  GROUND:CharSetAnim(lugia, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(lugia, "Idle", true)

  -- Titre + jugement.
  UI:WaitShowTitle(lugia:GetDisplayName(), 20)
  GAME:WaitFrames(40)
  UI:WaitHideTitle(20)

  UI:SetSpeaker(lugia)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_002']))
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CPB_003']))

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("celestial_peak", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
function celestial_peak_boss.Update(map, time) end
function celestial_peak_boss.GameSave(map) end
function celestial_peak_boss.GameLoad(map) end
return celestial_peak_boss
