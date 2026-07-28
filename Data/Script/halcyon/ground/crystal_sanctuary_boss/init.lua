--[[ Crystal Sanctuary Boss — Diancie, gardienne de la réserve d'Anima cristallisée
     Intro 3 couches (addendum A) :
       generique : Voix de l'Abysse -> flash blanc -> reveal + titre
       biome     : ruines/cristal -> BossFX.AwakenCrystal (revelation par ACTIVATION,
                   pas de surgissement : les cristaux s'illuminent, Diancie s'eveille)
       signature : Diancie apparait en meditation, entouree d'eclats de gemmes ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.ReplayEnding'
local crystal_sanctuary_boss = {}
function crystal_sanctuary_boss.Init(map) DEBUG.EnableDbgCoro() end
function crystal_sanctuary_boss.Enter(map)
  DEBUG.EnableDbgCoro()

  -- Rejouabilite : le donjon d'histoire est boucle, le gardien n'est plus la.
  -- Sans cette branche, revenir ici relancait la cinematique ET le combat.
  if ReplayEnding.IsReplay('crystal_sanctuary', 8) then
    ReplayEnding.EmptyArena({
      hero = {172, 180}, partner = {140, 180},
      camera = {156, 156}, look = {156, 132},
      walk = 40, title = true, music = 'Boss Battle!.ogg',
      lines = {
        { spk='partner', emo='Normal', key='CSB_R01', wait=10 },
        { spk='hero',    emo='Normal', key='CSB_R02', wait=10 },
        { spk='partner', emo='Normal', key='CSB_R03' },
        { spk='narrator',              key='CSB_R04' },
      },
    })
    return
  end
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GAME:FadeIn(40)
  GAME:WaitFrames(20)

  -- Couche generique : la Voix de l'Abysse.
  BossFX.Voice('CSB_001')

  -- Couche biome (cristal) : activation — les gemmes resonnent et s'illuminent.
  local diancie = CharacterEssentials.MakeCharactersFromList({{'Diancie', 156, 140, Direction.Down}})
  GROUND:Hide('Diancie')
  BossFX.AwakenCrystal(diancie, 156, 140)

  -- Flash blanc + camera recadree pendant la coupure.
  GAME:MoveCamera(156, 140, 1, false)
  BossFX.Flash(156, 140, 2, 4, 20)
  GAME:WaitFrames(10)

  -- Couche Pokemon : Diancie en pose calme, eclats de gemmes en suspension.
  BossFX.Particle("Captivate_Sparkles", 140, 128, 4)
  BossFX.Particle("Captivate_Sparkles", 172, 128, 4)
  GROUND:CharSetAnim(diancie, "Idle", true)

  -- Titre + dialogue court : le test moral, pas un mur de HP.
  UI:WaitShowTitle(diancie:GetDisplayName(), 20)
  GAME:WaitFrames(40)
  UI:WaitHideTitle(20)

  UI:SetSpeaker(diancie)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSB_002']))
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSB_003']))

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("crystal_sanctuary", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
function crystal_sanctuary_boss.Update(map, time) end
function crystal_sanctuary_boss.GameSave(map) end
function crystal_sanctuary_boss.GameLoad(map) end
return crystal_sanctuary_boss
