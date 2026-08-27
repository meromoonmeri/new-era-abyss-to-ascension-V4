-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P27A/s31a2802.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D73P27A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_nyuura = SkySceneKit.spawn_npc("sneasel", 176, 192, Direction.Down, "NPC_NYUURA")
  -- SetAnimation(22) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_HEAVY_WIND3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_denryuu = SkySceneKit.spawn_npc("ampharos", 232, 56, Direction.Down, "NPC_DENRYUU")
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end) -- message_SetActor(ACTOR_NPC_DENRYUU)
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english=" Hey! I'm here to help!", french="Hé! Quelqu'un a besoin\nde mon aide?", german=" Hey! Ich bin da, um zu helfen!", italian=" Ehi! Sono venuto ad aiutarvi!", spanish=" ¡Buenas! He venido a ayudar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  local npc_npc_kuchiito = SkySceneKit.spawn_npc("mawile", 192, 168, Direction.DownLeft, "NPC_KUCHIITO")
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "exclaim", 1) end)
  GAME:WaitFrames(5)
  local npc_npc_kinogassa = SkySceneKit.spawn_npc("breloom", 152, 216, Direction.UpRight, "NPC_KINOGASSA")
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, "exclaim", 1) end)
  GAME:WaitFrames(3)
  local npc_npc_goorikii = SkySceneKit.spawn_npc("machoke", 184, 216, Direction.Up, "NPC_GOORIKII")
  pcall(function() GROUND:CharSetEmote(npc_npc_goorikii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kuchiito, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_kinogassa, Direction.UpRight)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_goorikii, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" Oh! Over here!", french=" Ohé! Par ici!", german=" Oh! Dort drüben!", italian=" Oh! Quaggiù!", spanish=" ¡Estupendo, ven por aquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_denryuu, 228, 140, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kuchiito, Direction.DownLeft)
  do local p=npc_npc_denryuu.Position; GROUND:MoveToPosition(npc_npc_denryuu, p.X+(0), p.Y+(32), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_denryuu.Position; GROUND:MoveToPosition(npc_npc_denryuu, p.X+(-16), p.Y+(16), false, 2) end -- waypoint MovePositionOffset
  do local p=npc_npc_denryuu.Position; GROUND:MoveToPosition(npc_npc_denryuu, p.X+(-16), p.Y+(0), false, 2) end -- waypoint MovePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="Hmm. It seems as though\nI'm barely in time.", french="Mmh. On dirait que j'arrive\njuste à temps.", german="Hmm. Anscheinend komme ich\ngerade noch rechtzeitig.", italian="Mmmh. Sembra che sia arrivato\nappena in tempo.", spanish="Hum. Parece que llego\njusto a tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_denryuu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kuchiito, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="Well, let's carry him to the\n8th Station Clearing.", french="Très bien, transportons-le\njusqu'à la trouée du 8[F:E] Relais.", german="Okay, lasst ihn uns zusammen\nzur 8. Zwischenlagerlichtung tragen.", italian="Forza, portiamolo\nal Bivacco 8.", spanish="Venga, vamos a llevarlo a la\nBase del Octavo Puerto."})
  -- message_Close
  GROUND:EntTurn(npc_npc_denryuu, Direction.Left)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(90)
  SkySceneKit.cleanup_npcs()
end
