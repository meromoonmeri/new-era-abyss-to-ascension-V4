--[[ Autel des Cieux — arene Lugia (ch10) et transition Loaklass (ch11)
     Ground importe 1:1 de pmd-red D13P03 (Sky Tower Summit, github.com/pret/pmd-red).
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.ChapterAftermath'
require 'halcyon.ReplayEnding'
require 'halcyon.BossMusic'

local autel_celeste = {}

function autel_celeste.Init(map)
  pcall(function() GAME:FadeOut(false, 1) end)
  pcall(function() GAME:CutsceneMode(true) end)
  COMMON.RespawnAllies(true)
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)
  
  pcall(function()
    local sceneAVenir = false
    if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 11 then
      sceneAVenir = not SV.Chapter11.FinishedTreasureTownIntro
    end
    if not sceneAVenir then GAME:CutsceneMode(false) end
  end)
end

function autel_celeste.Enter(map)
  DEBUG.EnableDbgCoro()

  -- Rejouabilite : l'histoire est bouclee, l'Autel est desert. Positions
  -- d'origine gs209 conservees (heros 296,296 / partenaire 256,296).
  if ReplayEnding.IsReplay('celestial_peak', 10) then
    ReplayEnding.EmptyArena({
      hero = {296, 296}, partner = {256, 296},
      camera = {276, 280}, look = {276, 248},
      walk = 48, title = true, music = 'Rainbow Peak.ogg',
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

  -- Positions d'origine du script gs209 (tuiles GBA * 8 px) — inchangees.
  GROUND:TeleportTo(hero, 296, 296, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 256, 296, Direction.Up) end
  GAME:MoveCamera(276, 280, 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(30)

  -- Couche generique : la Voix de l'Abysse.
  BossFX.Voice('CPB_001', STRINGS.MapStrings)

  -- Couche biome (ciel) : Lugia descend sur la position d'origine de Rayquaza.
  local lugia = CharacterEssentials.MakeCharactersFromList({{'Lugia', 272, 272, Direction.Down}})
  GROUND:Hide('Lugia')
  BossFX.DescendSky(lugia, 272, 272, 160)

  -- Recul du groupe : le souffle les repousse (position/trigger d'origine 34,35).
  BossFX.PushBack({hero, partner}, Direction.Down)

  -- Couche Pokemon : deploiement d'ailes, pose figee.
  GROUND:CharSetAnim(lugia, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(lugia, "Idle", true)

  -- Autel de Lugia — theme de boss. Cette arene n'avait AUCUNE musique : le combat le plus
  -- important du chapitre se jouait en silence complet. Le theme
  -- demarre avec le titre, comme dans les 42 arenes de gardiens.
  BossMusic.Play('autel_celeste')

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

function autel_celeste.Update(map, time) end
function autel_celeste.GameSave(map) end
function autel_celeste.GameLoad(map) end

return autel_celeste
