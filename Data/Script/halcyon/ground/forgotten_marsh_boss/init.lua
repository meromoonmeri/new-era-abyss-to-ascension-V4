--[[ Forgotten Marsh Boss — Laggron, gardien du Cœur du Marais
     Intro 3 couches (addendum A) :
       generique : Voix de l'Abysse -> flash blanc -> reveal + titre
       biome     : marais/eau -> BossFX.EmergeWater (clapotis, gerbe, onde de choc)
       signature : Laggron mime l'amorce de Telluriforce (pose Attack figee) ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
local forgotten_marsh_boss = {}
function forgotten_marsh_boss.Init(map) DEBUG.EnableDbgCoro() end
function forgotten_marsh_boss.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GAME:FadeIn(40)
  GAME:WaitFrames(20)

  -- Couche generique : la Voix de l'Abysse, toujours avant l'apparition.
  BossFX.Voice('FMB_001')

  -- Couche biome (eau) : le marais fremit, puis le gardien jaillit de la vase.
  local boss = CharacterEssentials.MakeCharactersFromList({{'Swampert', 156, 140, Direction.Down}})
  GROUND:Hide('Swampert')
  BossFX.EmergeWater(boss, 156, 140)

  -- Recul du groupe : l'onde de choc les repousse vers le sud.
  BossFX.PushBack({hero, partner}, Direction.Down)

  -- Flash blanc : bascule dramatique, camera deja recadree au reveal.
  GAME:MoveCamera(156, 140, 1, false)
  BossFX.Flash(156, 140, 2, 4, 20)
  GAME:WaitFrames(10)

  -- Couche Pokemon : Laggron se fige sur l'amorce de son attaque signature.
  GROUND:CharSetAnim(boss, "Attack", false)
  GAME:WaitFrames(16)
  GROUND:CharSetAnim(boss, "Idle", true)

  -- Titre + ligne courte : l'intensite vient du rythme, pas du texte.
  UI:WaitShowTitle(boss:GetDisplayName(), 20)
  GAME:WaitFrames(40)
  UI:WaitHideTitle(20)

  UI:SetSpeaker(boss)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['FMB_002']))

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("forgotten_marsh", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
function forgotten_marsh_boss.Update(map, time) end
function forgotten_marsh_boss.GameSave(map) end
function forgotten_marsh_boss.GameLoad(map) end
return forgotten_marsh_boss
