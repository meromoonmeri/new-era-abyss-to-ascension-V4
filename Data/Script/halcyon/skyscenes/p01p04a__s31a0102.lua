-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/s31a0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_togepii = SkySceneKit.spawn_npc("togepi", 320, 216, Direction.DownLeft, "NPC_TOGEPII")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_yamikarasu = SkySceneKit.spawn_npc("murkrow", 424, 232, Direction.Up, "NPC_YAMIKARASU")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_okutan = SkySceneKit.spawn_npc("octillery", 408, 200, Direction.UpLeft, "NPC_OKUTAN")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_sandopan = SkySceneKit.spawn_npc("sandslash", 296, 248, Direction.DownRight, "NPC_SANDOPAN")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_jiguzaguma = SkySceneKit.spawn_npc("zigzagoon", 352, 216, Direction.Right, "NPC_JIGUZAGUMA")
  -- SetAnimation(4) [anim idle native]
  -- GAP: se_Play(6669) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 368, 292, false, 2)
  GROUND:MoveToPosition(partner, 332, 292, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wow, there's quite a crowd.", french=" Oh, une foule s'est rassemblée.", german=" Wow, ganz schön viel los.", italian=" Wow, c'è una bella folla.", spanish=" Caray, qué gentío."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wow, there's a crowd.", french=" Oh, une foule s'est rassemblée.", german=" Wow, ganz schön viel los.", italian=" Wow, che folla.", spanish=" Caramba, cuánta gente."})
  else
  SkySceneKit.say({english=" Wow, there's a crowd.", french=" Oh, une foule s'est rassemblée.", german=" Wow, ganz schön viel los.", italian=" Wow, che folla.", spanish=" Vaya, qué gentío."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(348, 220, 60, false) end) -- performer/caméra
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(16), p.Y+(-16), false, 2) end -- waypoint MovePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-32), false, 2) end -- waypoint MovePositionOffset
  GAME:WaitFrames(7)
  GROUND:MoveToPosition(hero, 368, 232, false, 2)
  GROUND:MoveToPosition(partner, 332, 232, false, 2)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(30)
  local npc_npc_patchiiru = SkySceneKit.spawn_npc("spinda", 352, 176, Direction.Down, "NPC_PATCHIIRU")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="May I have everyone's attention,\nplease! First of all, I'd like to thank you for\ntaking time out of your busy schedules!", french="Mes amis, votre attention,\ns'il vous plaît! Tout d'abord, merci à tous\nd'avoir pris un peu de votre temps pour venir.", german="Ich grüße euch alle zusammen!\nErst einmal danke, dass ihr euch Zeit\nfür diese Ansprache genommen habt!", italian="Posso avere la vostra attenzione\nper favore? Innanzitutto vi ringrazio di\nessere qui nonostante i vostri impegni!", spanish="¡Atención! ¡Atención, por favor!\nEn primer lugar, muchas gracias a todos por\nsacar tiempo de vuestras apretadas agendas."})
  -- se_FadeOut(6669, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_herakurosu = SkySceneKit.spawn_npc("heracross", 376, 216, Direction.Left, "NPC_HERAKUROSU")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_nyorotono = SkySceneKit.spawn_npc("politoed", 288, 232, Direction.UpRight, "NPC_NYOROTONO")
  pcall(function() GROUND:CharSetEmote(npc_npc_nyorotono, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, nil, 0) end) -- EFFECT_NONE
  local npc_npc_sutoraiku = SkySceneKit.spawn_npc("scyther", 328, 248, Direction.DownLeft, "NPC_SUTORAIKU")
  GROUND:MoveToPosition(npc_npc_sutoraiku, 392, 252, false, 2)
  GAME:WaitFrames(5)
  local npc_npc_zanguusu = SkySceneKit.spawn_npc("zangoose", 312, 272, Direction.Up, "NPC_ZANGUUSU")
  GROUND:MoveToPosition(npc_npc_zanguusu, 348, 248, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_sandopan, 308, 252, false, 2)
  local npc_npc_nyuura = SkySceneKit.spawn_npc("sneasel", 272, 192, Direction.Up, "NPC_NYUURA")
  GROUND:EntTurn(npc_npc_nyuura, Direction.UpRight)
  local npc_npc_bariyaado = SkySceneKit.spawn_npc("mr_mime", 296, 208, Direction.UpRight, "NPC_BARIYAADO")
  GROUND:EntTurn(npc_npc_bariyaado, Direction.UpRight)
  GAME:WaitFrames(3)
  local npc_npc_rediba = SkySceneKit.spawn_npc("ledyba", 264, 224, Direction.UpRight, "NPC_REDIBA")
  GROUND:EntTurn(npc_npc_rediba, Direction.UpRight)
  GROUND:EntTurn(npc_npc_nyorotono, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_sandopan, Direction.Up)
  GROUND:EntTurn(npc_npc_togepii, Direction.Up)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_jiguzaguma, Direction.Up)
  GROUND:EntTurn(npc_npc_herakurosu, Direction.Up)
  GROUND:EntTurn(npc_npc_zanguusu, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_sutoraiku, Direction.Up)
  GROUND:EntTurn(npc_npc_okutan, Direction.UpLeft)
  GAME:WaitFrames(3)
  local npc_npc_pachirisu = SkySceneKit.spawn_npc("pachirisu", 424, 192, Direction.UpLeft, "NPC_PACHIRISU")
  GROUND:EntTurn(npc_npc_pachirisu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_yamikarasu, Direction.UpLeft)
  local npc_npc_kagebouzu = SkySceneKit.spawn_npc("shuppet", 440, 216, Direction.DownLeft, "NPC_KAGEBOUZU")
  GROUND:EntTurn(npc_npc_kagebouzu, Direction.UpLeft)
  do local p=npc_npc_jiguzaguma.Position; GROUND:MoveToPosition(npc_npc_jiguzaguma, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(60)
  -- GAP: BGM BGM_SPINDAS_CAFE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="I've got some happy news for\neveryone today!", french="J'ai une excellente nouvelle\npour vous, aujourd'hui!", german="Heute habe ich großartige\nNeuigkeiten für alle!", italian=" Ho buone notizie per tutti voi!", spanish="¡Tengo buenísimas noticias\npara todos vosotros!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Has anyone here ever heard of a\nmountain called [CS:P]Sky Peak[CR]?", french="Est-ce que quelqu'un parmi vous\na déjà entendu parler du [CS:P]Pic Céleste[CR]?", german="Hat jemand von euch schon mal\netwas über den [CS:P]Himmelsgipfel[CR] gehört?", italian="Qualcuno ha mai sentito parlare\ndi una montagna chiamata [CS:P]Picco del Cielo[CR]?", spanish="¿Alguien ha oído hablar alguna\nvez de una montaña llamada la [CS:P]Cumbre[CR]\n[CS:P]del Cielo[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_okutan, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english=" [CS:P]Sky Peak[CR]?", french=" Le [CS:P]Pic Céleste[CR]?", german=" [CS:P]Himmelsgipfel[CR]?", italian=" [CS:P]Picco del Cielo[CR]?", spanish=" ¿La [CS:P]Cumbre del Cielo[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bariyaado, npc_npc_okutan, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english=" I've heard of it.", french=" Oui, j'en ai entendu parler.", german=" Das sagt mir etwas.", italian=" Io sì.", spanish=" Sí, me suena."})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_nyuura, npc_npc_bariyaado, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_rediba, npc_npc_bariyaado, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_nyorotono, npc_npc_bariyaado, 4) end)
  GROUND:EntTurn(npc_npc_sutoraiku, Direction.UpLeft)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_togepii, npc_npc_bariyaado, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_jiguzaguma, npc_npc_bariyaado, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_herakurosu, npc_npc_bariyaado, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zanguusu, npc_npc_bariyaado, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sandopan, npc_npc_bariyaado, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_okutan, npc_npc_bariyaado, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pachirisu, npc_npc_bariyaado, 4) end)
  GAME:WaitFrames(2)
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamikarasu, npc_npc_bariyaado, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kagebouzu, npc_npc_bariyaado, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
