--[[ Lugia, le Chœur Englouti — cinématique d'Ancrage (Livre II, ch19).
     Ground template d'origine conservé 1:1 ; dialogues New Era.
     Grammaire Rescue Team : signal -> irruption -> recul -> flash -> reveal
     -> titre -> ligne courte. Rematch : intro raccourcie. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.LegendZones'

local fosse_argentee = {}

function fosse_argentee.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function fosse_argentee.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 272, 336, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 248, 336, Direction.Up) end
  local lugia = CharacterEssentials.MakeCharactersFromList({{'Lugia', 272, 296, Direction.Down}})
  GROUND:Hide('Lugia')
  GAME:MoveCamera(272, 288, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('sunken_choir') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Lugia')
    UI:SetSpeaker(lugia)
    UI:WaitShowDialogue("Le fond de la mer n'oublie pas.[pause=20] Encore une fois, donc.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("fosse_abysses", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("IL Y A UN SECOND CIEL SOUS LA MER.[pause=20] JE SUIS SON SEUL OISEAU.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.EmergeWater(lugia, 272, 296)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Lugia')
  GROUND:CharSetAnim(lugia, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(lugia, "Idle", true)
  -- 6. Titre + thème.
  SOUND:PlayBGM('Boss Battle!.ogg', true)
  UI:WaitShowTitle("Lugia, le Chœur Englouti", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("C'est... le même chant qu'au Pic Céleste ![pause=20] Mais... plus profond. Plus ancien. Plus TRISTE.", hero:GetDisplayName()))
  UI:SetSpeaker(lugia)
  UI:WaitShowDialogue("Tu m'as déjà rencontré là-haut.[pause=20] Ici, en bas, je ne juge pas :[pause=10] je pèse.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("fosse_abysses", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function fosse_argentee.Update(map, time) end
function fosse_argentee.GameSave(map) end
function fosse_argentee.GameLoad(map) end

return fosse_argentee
