--[[
    bourg_comptoir_ch_11.lua
    Bourg du Comptoir — Chapitre 11 : Arrivée à Treasure Town
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

bourg_comptoir_ch_11 = {}

function bourg_comptoir_ch_11.ArrivalCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- Spawner Loaklass (Lapras) au bord de la plage (dans l'eau)
  local lapras = CharacterEssentials.MakeCharactersFromList({
    {'Lapras', 216, 360, Direction.Right}
  })
  GROUND:CharSetAnim(lapras, "Idle", true)

  -- Téléporter le duo sur le sable de la plage
  GROUND:TeleportTo(hero, 280, 368, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 256, 368, Direction.Left) end
  GAME:MoveCamera(248, 364, 1, false)

  -- L'écran s'éclaire doucement sur la Plage des Lucioles au lever du jour
  GAME:FadeIn(60)
  SOUND:PlayBGM('At the End of the Day.ogg', true)
  GAME:WaitFrames(40)

  -- Le partenaire s'émerveille
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Joyous")
  UI:WaitShowDialogue("C'est... c'est magnifique ! L'odeur de l'océan, ces bulles d'écume...[pause=15] Nous y sommes vraiment, {0} !", hero:GetDisplayName())
  GAME:WaitFrames(15)

  GeneralFunctions.HeroDialogue(hero, "(C'est immense...[pause=15] Une toute autre région s'ouvre à nous.)", "Inspired")
  GAME:WaitFrames(20)

  -- Loaklass s'adresse au duo
  GROUND:CharTurnToCharAnimated(lapras, partner, 4)
  UI:SetSpeaker(lapras)
  UI:WaitShowDialogue("Voici la célèbre plage de Treasure Town, mes petits.[pause=15] Vous avez bien mérité cette découverte.")
  UI:WaitShowDialogue("Je vais rester ancrée près du récif pour me reposer.[pause=15] Quand vous aurez fini d'explorer la ville, faites-moi signe pour rentrer à Metano Town.")
  GAME:WaitFrames(15)

  -- Remerciements du partenaire
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue("Merci mille fois, Loaklass ![pause=10] Nous serons prudents, c'est promis !")
  GAME:WaitFrames(15)

  -- Loaklass approuve
  UI:SetSpeaker(lapras)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Que les vents marins guident vos pas.[pause=15] Allez maintenant,[pause=10] la grande cité vous attend !")
  GAME:WaitFrames(20)

  -- Départ du duo vers la ville (le haut de la falaise)
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(partner, 256, 320, false, 1)
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    GROUND:MoveToPosition(hero, 280, 320, false, 1)
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
  end)
  local coro_cam = TASK:BranchCoroutine(function()
    GAME:MoveCamera(268, 310, 80, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro_cam})
  GAME:WaitFrames(15)

  -- Pensée finale du héros avant de prendre les commandes
  GeneralFunctions.HeroDialogue(hero, "(Alors voilà à quoi ressemble l'autre capitale du monde de l'exploration... Un nouveau départ commence ici.)", "Normal")
  GAME:WaitFrames(20)

  -- Fin de la cinématique
  SV.Chapter11.FinishedTreasureTownIntro = true
  
  pcall(function()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
end

function bourg_comptoir_ch_11.SetupGround()
  -- Placer Loaklass (Lapras) au bord de la plage pour les futurs allers-retours
  local lapras = CharacterEssentials.MakeCharactersFromList({
    {'Lapras', 216, 360, Direction.Right}
  })
  GROUND:CharSetAnim(lapras, "Idle", true)
  
  -- Le joueur commence au milieu de la place de Treasure Town
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GROUND:TeleportTo(hero, 272, 360, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 256, 368, Direction.Up) end
  GAME:MoveCamera(264, 364, 1, false)
  
  GAME:FadeIn(20)
end

return bourg_comptoir_ch_11
