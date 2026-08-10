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
  -- ÉQUIPE ACT — chorégraphie Rescue Team (MagmaCavernMidDialogue)
  ------------------------------------------------------------------
  -- Dans la source, seuls Dracaufeu et Tyranocif sont retrouvés ici.
  -- Alakazam combat encore Groudon plus loin : il ne doit donc pas être
  -- couché avec eux avant que le duo ne se précipite vers le nord.
  local charizard,tyranitar = CharacterEssentials.MakeCharactersFromList({
    {'Charizard',208,184,Direction.DownRight},
    {'Tyranitar',272,184,Direction.DownLeft}})
  for _,c in ipairs({charizard,tyranitar}) do
    pcall(function() GROUND:CharSetAction(c,RogueEssence.Ground.PoseGroundAction(
      c.Position,c.Direction,RogueEssence.Content.GraphicsManager.GetAnimIndex('Faint'))) end)
  end

  -- Look-around, arrêt de la musique, séisme, puis retour au calme : même
  -- ordre dramatique que dungeon_cutscene_magma_cavern.c.
  if partner then pcall(function() GROUND:CharSetEmote(partner,'question',1) end) end
  UI:SetSpeaker(partner);GeneralFunctions.SetEmotion('Worried')
  UI:WaitShowDialogue("Voyons voir...[pause=15] Jusqu'où sommes-nous descendus ?")
  SOUND:FadeOutBGM(20);GAME:WaitFrames(10)
  SOUND:PlayBattleSE('DUN_Earthquake');BossFX.ShakeScreen(7,40);GAME:WaitFrames(40)
  if partner then GROUND:CharSetEmote(partner,'shock',1) end
  UI:WaitShowDialogue("Ouah ![pause=10] Un séisme !")
  GAME:WaitFrames(35)
  UI:WaitShowDialogue("C'est fini...[pause=15] Attends, regarde là-bas !")

  GAME:MoveCamera(240,196,32,false);GAME:WaitFrames(30)
  UI:SetSpeaker(partner);GeneralFunctions.SetEmotion('Shock')
  UI:WaitShowDialogue("Dracaufeu ! Tyranocif ![pause=20] Réveillez-vous !")
  pcall(function() GROUND:CharSetAnim(charizard,'Hurt',true) end)
  UI:SetSpeaker(charizard);GeneralFunctions.SetEmotion('Pain')
  UI:WaitShowDialogue("Nous avons défié Groudon...[pause=20] Il nous a écrasés...")
  UI:SetSpeaker(partner);GeneralFunctions.SetEmotion('Worried')
  UI:WaitShowDialogue("Et Alakazam ?[pause=15] Où est-il ?")
  UI:SetSpeaker(tyranitar);GeneralFunctions.SetEmotion('Pain')
  UI:WaitShowDialogue("Il combat encore Groudon...[pause=20] Plus loin...")
  UI:SetSpeaker(partner);GeneralFunctions.SetEmotion('Determined')
  UI:WaitShowDialogue("Il faut se dépêcher !")
  UI:SetSpeaker(charizard);GeneralFunctions.SetEmotion('Pain')
  UI:WaitShowDialogue("Soyez prudents...")

  -- La source fait courir le duo hors de la scène vers le combat. Ici le
  -- même déplacement mène à la moitié nord du Ground, puis la caméra révèle
  -- Alakazam tombé devant Groudon.
  local rush1=TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero,272,160,false,2) end)
  local rush2=TASK:BranchCoroutine(function() if partner then GROUND:MoveToPosition(partner,216,160,false,2) end end)
  TASK:JoinCoroutines({rush1,rush2});GAME:FadeOut(false,20)
  local alakazam=CharacterEssentials.MakeCharactersFromList({{'Alakazam',208,152,Direction.DownRight}})
  pcall(function() GROUND:CharSetAction(alakazam,RogueEssence.Ground.PoseGroundAction(
    alakazam.Position,alakazam.Direction,RogueEssence.Content.GraphicsManager.GetAnimIndex('Faint'))) end)
  GAME:MoveCamera(240,168,1,false);GAME:FadeIn(20);GAME:WaitFrames(20)
  UI:ResetSpeaker(false);UI:SetCenter(true)
  UI:WaitShowDialogue("Alakazam gît devant le cratère.[pause=20] Derrière lui, la roche commence à respirer.")
  UI:SetCenter(false)
  GeneralFunctions.HeroDialogue(hero,"(L'Équipe ACT a tenu jusqu'ici.[pause=15] À nous d'ouvrir le chemin du retour.)",'Determined')

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
