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
require 'halcyon.ReplayEnding'
require 'halcyon.BossMusic'
local celestial_peak_boss = {}
function celestial_peak_boss.Init(map) DEBUG.EnableDbgCoro() end
function celestial_peak_boss.Enter(map)
  DEBUG.EnableDbgCoro()

  -- Rejouabilite : le donjon d'histoire est boucle, le gardien n'est plus la.
  -- Sans cette branche, revenir ici relancait la cinematique ET le combat.
  if ReplayEnding.IsReplay('celestial_peak', 10) then
    ReplayEnding.EmptyArena({
      hero = {172, 180}, partner = {140, 180},
      camera = {156, 156}, look = {156, 132},
      walk = 40, title = true, music = 'Summit.ogg',
      lines = {
        { spk='partner', emo='Normal', key='CPB_R01', wait=10 },
        { spk='hero',    emo='Normal', key='CPB_R02', wait=10 },
        { spk='partner', emo='Normal', key='CPB_R03' },
        { spk='narrator',              key='CPB_R04' },
      },
    })
    return
  end
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
  -- Sommet du Pic — theme de boss. Cette arene n'avait AUCUNE musique : le combat le plus
  -- important du chapitre se jouait en silence complet. Le theme
  -- demarre avec le titre, comme dans les 42 arenes de gardiens.
  BossMusic.Play('celestial_peak_boss')
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
