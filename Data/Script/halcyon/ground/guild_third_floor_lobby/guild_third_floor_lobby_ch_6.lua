--[[
    guild_third_floor_lobby_ch_6.lua
    Chapitre 6 : Rassemblement matinal et vie de guilde (Le Réveil de Metano)
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_third_floor_lobby_ch_6 = {}

function guild_third_floor_lobby_ch_6.SetupGround()
  local audino = CharacterEssentials.MakeCharactersFromList({
    {"Audino", 168, 184, Direction.Down}
  })
  if audino[1] then
    GAME:GetCurrentGround():AddTempChar(audino[1])
  end
end

function guild_third_floor_lobby_ch_6.FirstMorningAddress()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(partner)
  UI:ResetSpeaker()

  -- Positionnement esthétique devant le pupitre
  local npcs = CharacterEssentials.MakeCharactersFromList({
    {"Tropius", 232, 136, Direction.Down},
    {"Noctowl", 192, 144, Direction.DownRight},
    {"Flygon",  168, 208, Direction.UpRight},
    {"Altaria", 200, 208, Direction.Up},
    {"Shinx",   232, 208, Direction.Up},
    {"Phanpy",  264, 208, Direction.Up},
    {"Vulpix",  296, 208, Direction.UpLeft},
    {"Mareep",  184, 240, Direction.Up},
    {"Zorua",   216, 240, Direction.Up},
    {"Growlithe", 248, 240, Direction.Up},
    {"Zigzagoon", 280, 240, Direction.Up}
  })
  local penticus = npcs[1]
  local phileas = npcs[2]
  local hyko = npcs[3]
  local almotz = npcs[4]
  local shuca = npcs[5]
  local kino = npcs[6]
  local rin = npcs[7]
  local coco = npcs[8]
  local reinier = npcs[9]
  local ganlon = npcs[10]
  local zigzag = npcs[11]

  for _, c in ipairs(npcs) do
    GAME:GetCurrentGround():AddTempChar(c)
  end

  GROUND:TeleportTo(hero, 200, 272, Direction.Up)
  GROUND:TeleportTo(partner, 232, 272, Direction.Up)

  GAME:MoveCamera(232, 200, 1, false)
  GAME:FadeIn(40)
  SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
  GAME:WaitFrames(30)

  -- Étape 1 : Constat sensoriel (retour au calme, l'air de la guilde)
  UI:SetSpeaker(penticus)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Bonjour à tous ![pause=15] Quel plaisir de voir nos rangs à nouveau complets.")
  UI:WaitShowDialogue("L'air frais de Metano fait du bien après les vents brûlants du Mont Venteux,[pause=10] n'est-ce pas ?")
  GAME:WaitFrames(15)

  -- Réactivité systématique : regards et hochements en cascade
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:CharTurnToCharAnimated(partner, hero, 4)
    GAME:WaitFrames(20)
    GeneralFunctions.DoAnimation(partner, "Nod")
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    GROUND:CharTurnToCharAnimated(hero, partner, 4)
    GAME:WaitFrames(15)
    GeneralFunctions.DoAnimation(hero, "Nod")
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
  end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(10)

  -- Étape 2 : Réaction affective & rumeurs en ville (Escouade Fulgur)
  UI:SetSpeaker(penticus)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue("Cependant,[pause=10] l'expédition nous a révélé des phénomènes préoccupants.")
  UI:WaitShowDialogue("Le Cœur du Mont Venteux était agité...[pause=15] Et en ville,[pause=10] les rumeurs vont bon train.")
  GAME:WaitFrames(10)

  UI:SetSpeaker(phileas)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("En effet.[pause=15] Des témoins affirment qu'une équipe aux yeux d'or pose trop de questions sur les Cœurs régionaux.")
  UI:WaitShowDialogue("Nous devons rester prudents et vigilants sur le terrain.")
  GAME:WaitFrames(15)

  -- Étape 3 : Décision d'agir (Mission Forêt Lugubre / Zarude)
  UI:SetSpeaker(penticus)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue("C'est pourquoi nous reprenons nos inspections ![pause=15] Aujourd'hui,[pause=10] nous nous tournons vers la Forêt Lugubre.")
  UI:WaitShowDialogue("Soyez attentifs : son gardien,[pause=10] Zarude,[pause=10] défend farouchement son territoire.")
  GAME:WaitFrames(10)

  -- Cri de ralliement
  UI:SetSpeaker(penticus)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue("Faites de votre mieux,[pause=10] comme toujours !")
  GAME:WaitFrames(15)

  local cheer = {}
  for i, c in ipairs({partner, hero, rin, shuca, kino, almotz, hyko}) do
    cheer[#cheer+1] = TASK:BranchCoroutine(function()
      GAME:WaitFrames(i * 3)
      GeneralFunctions.Hop(c, "Idle", 8, 20, 0, false)
    end)
  end
  TASK:JoinCoroutines(cheer)
  GAME:WaitFrames(30)

  GAME:FadeOut(false, 40)
  for _, c in ipairs(npcs) do
    GAME:GetCurrentGround():RemoveTempChar(c)
  end
  GAME:MoveCamera(0, 0, 1, false)

  SV.Chapter6.FinishedFirstAddress = true
  SV.TemporaryFlags.MorningAddress = false

  guild_third_floor_lobby_ch_6.SetupGround()
  GAME:FadeIn(40)
  GAME:CutsceneMode(false)
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
end

return guild_third_floor_lobby_ch_6
