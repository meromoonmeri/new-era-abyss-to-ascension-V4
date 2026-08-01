--[[
    autel_celeste_ch_11.lua
    Autel Céleste — Chapitre 11 : Le départ vers Treasure Town via Loaklass
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

autel_celeste_ch_11 = {}

function autel_celeste_ch_11.LoaklassTransitionCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- Le doyen Penticus (Tropius) attend près du bord nord de l'Autel
  local tropius = CharacterEssentials.MakeCharactersFromList({
    {'Tropius', 272, 240, Direction.Down}
  })
  GROUND:CharSetAnim(tropius, "Idle", true)

  -- Teleportation de l'équipe
  GROUND:TeleportTo(hero, 296, 296, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 256, 296, Direction.Up) end
  GAME:MoveCamera(276, 260, 1, false)

  GAME:FadeIn(40)
  SOUND:PlayBGM('Mt. Travail.ogg', true)
  GAME:WaitFrames(30)

  -- L'équipe s'approche du doyen
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(hero, 288, 260, false, 1)
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    if partner ~= nil then
      GROUND:MoveToPosition(partner, 256, 260, false, 1)
      GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
    end
  end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(20)

  -- Échange de dialogues
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Doyen Penticus ! Vous êtes toujours là-haut ?")
  GAME:WaitFrames(15)

  GROUND:CharTurnToCharAnimated(tropius, hero, 4)
  UI:SetSpeaker(tropius)
  UI:WaitShowDialogue("Ah, vous voilà ! Le vent est enfin calme aujourd'hui.[pause=15] J'observais cette magnifique mer de nuages.")
  UI:WaitShowDialogue("La décharge d'énergie de Lugia a ouvert un passage stable dans les courants aériens...[pause=20] C'est l'occasion idéale.")
  GAME:WaitFrames(15)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue("Une occasion de quoi ?")
  GAME:WaitFrames(15)

  UI:SetSpeaker(tropius)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("De traverser vers de nouveaux horizons. J'ai fait appel à une vieille voyageuse d'exception.")
  GAME:WaitFrames(10)

  -- Son clapotis / grondement de nuages
  SOUND:PlayBattleSE("EVT_Water_Splash")
  BossFX.ShakeScreen(3, 20)
  GAME:WaitFrames(20)

  local coro_look1 = TASK:BranchCoroutine(function()
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
    GeneralFunctions.EmoteAndPause(partner, "Shock", true)
  end)
  local coro_look2 = TASK:BranchCoroutine(function()
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
    GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  end)
  TASK:JoinCoroutines({coro_look1, coro_look2})

  -- Une immense ombre glisse à travers les nuages...
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue("Une immense silhouette fend doucement la mer de nuages...")
  UI:SetCenter(false)
  GAME:WaitFrames(20)

  -- Spawner Loaklass (Lapras)
  local lapras = CharacterEssentials.MakeCharactersFromList({
    {'Lapras', 272, 190, Direction.Down}
  })
  GROUND:CharSetAnim(lapras, "Idle", true)

  -- Dialogue de Loaklass (Pas de portrait avant qu'elle n'apparaisse - résolu par le fait qu'elle est déjà là !)
  SOUND:PlayBGM('Rainbow Peak.ogg', true)
  GAME:WaitFrames(30)

  UI:SetSpeaker(lapras)
  UI:WaitShowDialogue("Bonjour, jeunes gens.[pause=15] J'ai entendu dire que de talentueux explorateurs cherchaient un passage au-delà de l'horizon.")
  UI:WaitShowDialogue("Je suis Loaklass. Je connais les courants secrets de la mer de nuages, là où aucun navire ordinaire ne peut s'aventurer.")
  GAME:WaitFrames(15)

  -- Clin d'œil de lore
  UI:WaitShowDialogue("Vos regards... Ils me rappellent un certain duo d'explorateurs que j'ai transporté il y a quinze ans... avant qu'ils ne sauvent le temps.")
  GAME:WaitFrames(15)

  UI:SetSpeaker(partner)
  pcall(function()
    GROUND:CharSetEmote(partner, "sweatdrop", 1)
    GROUND:CharTurnToCharAnimated(partner, hero, 4)
  end)
  GeneralFunctions.SetEmotion("Sigh")
  UI:WaitShowDialogue("(Sauver le temps ?[pause=10] Eh bien... Je crois que je sais TRÈS bien de qui elle parle...)")
  GAME:WaitFrames(15)

  GROUND:CharTurnToCharAnimated(partner, lapras, 4)
  UI:SetSpeaker(lapras)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Si votre cœur est prêt à voir de nouvelles terres, mon dos est à vous.[pause=15] Direction : le Bourg du Comptoir, la grande capitale historique de l'exploration !")
  GAME:WaitFrames(15)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Joyous")
  UI:WaitShowDialogue("Le Bourg du Comptoir ?! C'est incroyable ! Allez, {0}, en route !", hero:GetDisplayName())
  GAME:WaitFrames(20)

  -- Traversée
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  -- Écran noir de transition
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue("Portés par les vagues célestes de la mer de nuages... nous avons quitté le continent de Metano, prêts à découvrir de nouveaux horizons.")
  UI:SetCenter(false)
  GAME:WaitFrames(40)

  -- Débloquer Treasure Town et transférer
  SV.Chapter11.FinishedTreasureTownIntro = true
  pcall(function() GAME:UnlockDungeon("bourg_comptoir") end)
  GAME:EnterGroundMap("bourg_comptoir", "Main_Entrance_Marker")
end

return autel_celeste_ch_11
