--[[ Crystal Sanctuary Boss — Diancie, gardienne de la réserve d'Anima cristallisée

     DECOR (refait 2026-08-04) : arene cristalline 240x312, TexSize 3,
     planche propre Arene_Diancie. Le ground empruntait auparavant
     First_Core_Location_Base, le decor d'une autre zone, en tuiles de 8 px.
     Geometrie MESUREE sur la grille d'obstacles : 67,5 % bloquant,
     368 cases atteignables, cercle de combat ouvert au centre.
       Diancie au NORD du cercle  (112,128) — elle domine l'entree
       le duo arrive par le SUD   (104,295) — 175 px les separent
     Les anciennes positions visaient une carte 240x320 : le regard de
     rejouabilite (156,132) et une particule (172,128) tombaient hors sol.
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
require 'halcyon.ChapterAftermath'
require 'halcyon.ReplayEnding'
require 'halcyon.BossMusic'
local crystal_sanctuary_boss = {}
function crystal_sanctuary_boss.Init(map) DEBUG.EnableDbgCoro() end
function crystal_sanctuary_boss.Enter(map)
  DEBUG.EnableDbgCoro()

  -- Rejouabilite : le donjon d'histoire est boucle, le gardien n'est plus la.
  -- Sans cette branche, revenir ici relancait la cinematique ET le combat.
  if ReplayEnding.IsReplay('crystal_sanctuary', 8) then
    ReplayEnding.EmptyArena({
      hero = {104, 271}, partner = {128, 271},
      camera = {120, 232}, look = {120, 152},
      walk = 40, title = true, music = 'Crystal Crossing.ogg',
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

  -- === LE TON MONTE — le cercle magique s'anime par paliers ===
  -- La couche 'Cristaux_Cercle' du ground TOURNE en permanence (78
  -- tuiles a 8 frames) : les cristaux levitent et l'onde radiale du
  -- cercle change de teinte, pendant la scene ET pendant le combat.
  -- Ce qui MONTE ici, c'est la densite d'eclats posee par-dessus :
  -- trois vagues de plus en plus rapprochees, sur le cercle puis sur
  -- les cristaux. Le decor pulse deja tout seul ; on ajoute la
  -- pression.
  -- (Il n'existe aucune API GROUND: pour changer la cadence d'une
  -- couche a chaud — verifie. La montee passe donc par les particules,
  -- pas par un reglage de FrameLength.)
  for i = 1, 3 do
    pcall(function()
      BossFX.Particle("Captivate_Sparkles", 120, 205, 3)   -- coeur du cercle
      BossFX.Particle("Captivate_Sparkles", 120 - 30 * i, 205, 2)
      BossFX.Particle("Captivate_Sparkles", 120 + 30 * i, 205, 2)
    end)
    --DUN_Power_Gem : SE atteste 5 fois dans le mod. DUN_Light_Screen,
    --employe en premier jet, n'existe NULLE PART ailleurs : c'etait une
    --invention. Un SE inconnu ne leve pas d'erreur, il ne joue
    --simplement aucun son — le bug aurait ete silencieux.
    pcall(function() SOUND:PlayBattleSE("DUN_Power_Gem") end)
    GAME:WaitFrames(34 - i * 8)
  end

  -- Couche biome (cristal) : activation — les gemmes resonnent et s'illuminent.
  local diancie = CharacterEssentials.MakeCharactersFromList({{'Diancie', 112, 128, Direction.Down}})
  GROUND:Hide('Diancie')
  BossFX.AwakenCrystal(diancie, 112, 128)

  -- Flash blanc + camera recadree pendant la coupure.
  GAME:MoveCamera(120, 152, 1, false)
  BossFX.Flash(112, 128, 2, 4, 20)
  GAME:WaitFrames(10)

  -- Couche Pokemon : Diancie en pose calme, eclats de gemmes en suspension.
  BossFX.Particle("Captivate_Sparkles", 88, 144, 4)
  BossFX.Particle("Captivate_Sparkles", 144, 144, 4)
  GROUND:CharSetAnim(diancie, "Idle", true)

  -- Titre + dialogue court : le test moral, pas un mur de HP.
  -- Chambre de Diancie — theme de boss. Cette arene n'avait AUCUNE musique : le combat le plus
  -- important du chapitre se jouait en silence complet. Le theme
  -- demarre avec le titre, comme dans les 42 arenes de gardiens.
  BossMusic.Play('crystal_sanctuary_boss')
  UI:WaitShowTitle(diancie:GetDisplayName(), 20)
  GAME:WaitFrames(40)
  UI:WaitHideTitle(20)

  UI:SetSpeaker(diancie)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSB_002']))
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSB_003']))

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("crystal_sanctuary", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end
function crystal_sanctuary_boss.Update(map, time) end
function crystal_sanctuary_boss.GameSave(map) end
function crystal_sanctuary_boss.GameLoad(map) end
return crystal_sanctuary_boss
