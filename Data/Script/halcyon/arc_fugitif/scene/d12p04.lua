--[[ d12p04 — Fosse ardente : GROUDON (canon PMD Red gs206).
     Le duo rejoint les profondeurs où l'équipe ACT veille sur Groudon.
     Groudon se réveille (EmergeFire + VFX flamme), secousse, puis le
     combat s'engage. Dialogues canoniques (clés SCENE_D12P04_*). ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

local d12p04 = {}

function d12p04.Cutscene()
  DEBUG.EnableDbgCoro()
  GAME:CutsceneMode(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- Positions canoniques (markers fosse_ardente) : héros (272,232), Groudon (240,176)
  pcall(function() GROUND:TeleportTo(hero, 272, 232, Direction.Up) end)
  if partner then pcall(function() GROUND:TeleportTo(partner, 216, 232, Direction.Up) end) end
  GAME:MoveCamera(240, 208, 1, false)
  GAME:FadeIn(25)

  -- Le duo avance vers le cœur
  if partner then GeneralFunctions.MoveCharAndCamera(partner, 216, 200, false, 12, 40) end
  if hero then GeneralFunctions.MoveCharAndCamera(hero, 272, 200, false, 12, 40) end
  GAME:WaitFrames(30)

  ------------------------------------------------------------------
  -- ÉQUIPE ACT — continuité canonique Rescue Team
  ------------------------------------------------------------------
  -- Le joueur ne tombe pas directement sur Groudon : Alakazam,
  -- Charizard et Tyranitar l'ont affronté avant lui et gisent autour du
  -- cratère. C'est le battement narratif essentiel qui manquait.
  local alakazam,charizard,tyranitar = CharacterEssentials.MakeCharactersFromList({
    {'Alakazam', 208, 184, Direction.DownRight},
    {'Charizard',272,184,Direction.DownLeft},
    {'Tyranitar',240,224,Direction.Down}})
  for _,c in ipairs({alakazam,charizard,tyranitar}) do
    pcall(function()
      GROUND:CharSetAction(c,RogueEssence.Ground.PoseGroundAction(
        c.Position,c.Direction,RogueEssence.Content.GraphicsManager.GetAnimIndex('Faint')))
    end)
  end
  GAME:MoveCamera(240,196,35,false);GAME:WaitFrames(25)
  UI:ResetSpeaker(false);UI:SetCenter(true)
  UI:WaitShowDialogue("Trois silhouettes sont étendues autour du cratère.[pause=20] L'Équipe ACT est arrivée avant vous.")
  UI:SetCenter(false)
  if partner then
    UI:SetSpeaker(partner);GeneralFunctions.SetEmotion('Shock')
    UI:WaitShowDialogue("Alakazam ![pause=10] Dracaufeu ! Tyranocif ![pause=20] Ils ont tous été balayés...")
  end
  pcall(function()
    GROUND:CharSetAnim(alakazam,'Hurt',true)
    GROUND:CharSetEmote(alakazam,'sweatdrop',1)
  end)
  UI:SetSpeaker(alakazam);GeneralFunctions.SetEmotion('Pain')
  UI:WaitShowDialogue("N'approchez pas...[pause=15] Groudon ne dormait pas.[pause=20] Il nous attendait sous la roche.")
  UI:WaitShowDialogue("Nous avons tenu aussi longtemps que possible.[pause=15] Maintenant...[pause=20] c'est à vous.")
  GeneralFunctions.HeroDialogue(hero,"(Même l'Équipe ACT n'a pas pu l'arrêter.[pause=20] Mais nous ne pouvons pas les abandonner ici.)",'Determined')
  if partner then
    UI:SetSpeaker(partner);GeneralFunctions.SetEmotion('Determined')
    UI:WaitShowDialogue("On va ouvrir un chemin.[pause=15] Restez conscients. On revient vous chercher.")
  end
  GAME:WaitFrames(20)

  -- Groudon se réveille dans les flammes (apparition progressive)
  local groudon = CharacterEssentials.MakeCharactersFromList({{'Groudon', 240, 176, Direction.Down}})
  if groudon then
    pcall(function() GROUND:Hide('Groudon') end)
    pcall(function()
      local flame = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData('VFX_Groudon_Awakening_Flame', 4))
      GROUND:PlayVFX(flame, 240, 176)
    end)
    BossFX.EmergeFire(groudon, 240, 176)
    BossFX.Flash(240, 176, 3, 8, 35)
    BossFX.ShakeScreen(8, 40)
  end

  -- GROUDON se dresse (pas de dialogue : le combat parle)
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P04_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P04_002"))
  if partner then pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P04_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P04_004"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P04_005"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P04_006"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P04_007"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P04_008"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P04_009"))

  -- La secousse finale, Groudon s'éveille vraiment
  BossFX.ShakeScreen(8, 30)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P04_010"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P04_011"))

  -- Pensées du duo : le moment est venu
  UI:SetSpeaker(hero)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P04_012"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P04_013"))
  if partner then UI:SetSpeaker(partner) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P04_014"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D12P04_015"))

  GAME:CutsceneMode(false)
end

return d12p04
