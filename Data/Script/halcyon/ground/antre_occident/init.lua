--[[ Mewtwo, le Silence Occidental — cinématique d'Ancrage (Livre II, ch21).
     Ground template d'origine conservé 1:1 ; dialogues New Era.
     Grammaire Rescue Team : signal -> irruption -> recul -> flash -> reveal
     -> titre -> ligne courte. Rematch : intro raccourcie. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.LegendZones'

local antre_occident = {}

function antre_occident.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function antre_occident.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 176, 168, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 152, 168, Direction.Up) end
  local mewtwo = CharacterEssentials.MakeCharactersFromList({{'Mewtwo', 160, 264, Direction.Down}})
  GROUND:Hide('Mewtwo')
  GAME:MoveCamera(160, 256, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('western_silence') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Mewtwo')
    UI:SetSpeaker(mewtwo)
    UI:WaitShowDialogue("Je ne garde pas ce lieu.[pause=20] C'est ce lieu qui me garde.[pause=20] Viens.[pause=10] Aide-moi à vérifier lequel de nous deux a raison.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("forteresse_abandonnee", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("ILS M'ONT FAIT.[pause=30] PUIS ILS ONT EU PEUR.[pause=30] PUIS ILS SONT PARTIS.[pause=30] PAS MOI.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  SOUND:StopBGM()
  GAME:WaitFrames(60)
  BossFX.Flash(160, 264, 8, 10, 20)
  GROUND:Unhide('Mewtwo')
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Mewtwo')
  GROUND:CharSetAnim(mewtwo, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(mewtwo, "Idle", true)
  -- 6. Titre + thème.
  SOUND:PlayBGM('Boss Battle!.ogg', true)
  UI:WaitShowTitle("Mewtwo, le Silence Occidental", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Cet Ancrage est... artificiel ?[pause=20] Quelqu'un a CONSTRUIT une faille... et l'a abandonnée ?!", hero:GetDisplayName()))
  UI:SetSpeaker(mewtwo)
  UI:WaitShowDialogue("Je ne garde pas ce lieu.[pause=20] C'est ce lieu qui me garde.[pause=20] Viens.[pause=10] Aide-moi à vérifier lequel de nous deux a raison.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("forteresse_abandonnee", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function antre_occident.Update(map, time) end
function antre_occident.GameSave(map) end
function antre_occident.GameLoad(map) end

return antre_occident
