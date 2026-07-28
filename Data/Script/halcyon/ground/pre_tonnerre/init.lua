--[[ Zeraora, le Courant Sauvage — cinématique d'Ancrage (Livre II, ch25).
     Ground template d'origine conservé 1:1 ; dialogues New Era.
     Grammaire Rescue Team : signal -> irruption -> recul -> flash -> reveal
     -> titre -> ligne courte. Rematch : intro raccourcie. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.LegendZones'
require 'halcyon.BossMusic'

local pre_tonnerre = {}

function pre_tonnerre.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function pre_tonnerre.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 224, 328, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 200, 328, Direction.Up) end
  local zeraora = CharacterEssentials.MakeCharactersFromList({{'Zeraora', 224, 192, Direction.Down}})
  GROUND:Hide('Zeraora')
  GAME:MoveCamera(224, 184, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('wild_current') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Zeraora')
    UI:SetSpeaker(zeraora)
    UI:WaitShowDialogue("Enfin des concurrents ![pause=20] Règle unique :[pause=10] le premier à terre a perdu !")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("piste_fulgurante", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("IL A DISTANCÉ L'ORAGE QUI L'A CRÉÉ.[pause=20] DEPUIS, IL CHERCHE UNE COURSE DIGNE.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption — ELECTRIQUE : vitesse pure, la decharge precede le corps.
  --    Avant ce lot : un BossFX.Flash generique, identique a 10 autres
  --    arenes. Toutes les particules employees sont attestees.
  BossFX.StrikeThunder(zeraora, 224, 192)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Zeraora')
  GROUND:CharSetAnim(zeraora, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(zeraora, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('pre_tonnerre')
  UI:WaitShowTitle("Zeraora, le Courant Sauvage", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format("Cette trace d'herbe brûlée...[pause=10] UN SEUL trait, du pied de la piste jusqu'ici ![pause=20] Il nous a devancés en s'AMUSANT.", hero:GetDisplayName()))
  UI:SetSpeaker(zeraora)
  UI:WaitShowDialogue("Enfin des concurrents ![pause=20] Règle unique :[pause=10] le premier à terre a perdu !")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("piste_fulgurante", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function pre_tonnerre.Update(map, time) end
function pre_tonnerre.GameSave(map) end
function pre_tonnerre.GameLoad(map) end

return pre_tonnerre
