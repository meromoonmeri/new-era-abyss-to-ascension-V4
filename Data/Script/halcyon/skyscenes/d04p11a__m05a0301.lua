-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D04P11A/m05a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D04P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_RAIN2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(90)
  pcall(function() GAME:MoveCamera(252, 224, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 268, 236, false, 2)
  GROUND:MoveToPosition(partner, 236, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  SkySceneKit.say({english="So this is the waterfall that's\nsupposed to have a secret...", french="Voici donc la cascade censée\nreceler un secret...", german="Das ist also der Wasserfall, der\nein Geheimnis bergen soll.", italian="Quindi questa è la cascata\nche dovrebbe celare un segreto...", spanish="Así que dicen que esta cascada\noculta un secreto..."}) -- SwitchTalk: branche default (canon générique)
  GROUND:MoveToPosition(partner, 236, 204, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(3)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  GROUND:MoveToPosition(partner, 236, 236, false, 2) -- SlidePositionMark (glissement)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GROUND:EntTurn(hero, Direction.Left)
  SkySceneKit.say({english=" Waah!", french=" Waouh!", german=" Waah!", italian=" Wow!", spanish=" ¡Ay!"}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.Right)
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" The water's pounding down!", french="L'eau tombe avec une violence\ninouïe!", german="Das Wasser rast nur so\nherunter!", italian="L'acqua scorre\ndavvero impetuosa!", spanish="¡El agua cae con muchísima\nfuerza!"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="Try getting close to the\nwaterfall, [hero].", french="Essaie de te rapprocher de la\ncascade, [hero].", german="Versuch du mal, näher\nheranzugehen, [hero].", italian="Proviamo ad avvicinarci alla\ncascata, [hero].", spanish="Intenta acercarte a la cascada,\n[hero]."}) -- SwitchTalk: branche default (canon générique)
  GROUND:MoveToPosition(hero, 268, 212, false, 2)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="(I can barely stay standing near this deluge!)", french="(J'ai du mal à rester à côté de la cascade!)", german="(Ich kann neben diesen Wassermassen kaum\nstehen!)", italian="(Quant'acqua scende qui!)", spanish="(¡Apenas puedo tenerme en pie cerca de este\naluvión!)"}) -- SwitchMonologue: branche default
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(3)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  GROUND:MoveToPosition(hero, 268, 236, false, 2) -- SlidePositionMark (glissement)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GROUND:EntTurn(partner, Direction.Right)
  SkySceneKit.say({english="(Waaah!)", french="(Aaah!)", german="(Waaah!)", italian="(Waaah!)", spanish="(¡Ayyy!)"}) -- SwitchMonologue: branche default
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  SkySceneKit.say({english=" See? It's awesome.", french=" Tu as vu? Quelle intensité!", german=" Siehst du? Es ist atemberaubend.", italian=" Vedi? È incredibile!", spanish=" ¿Lo ves? Es asombroso."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Where should we even start\nlooking?", french="Je ne sais même pas où on doit\ncommencer à chercher!", german="Wo sollen wir überhaupt\nanfangen zu suchen?", italian=" Da dove iniziamo a cercare?", spanish="No sé ni por dónde podemos\nempezar a buscar."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  SkySceneKit.say({english="(Hmm...)", french="(Hum...)", german="(Hmm...)", italian="(Mmm...)", spanish="(Hum...)"}) -- SwitchMonologue: branche default
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  SkySceneKit.say({english="(It's that dizziness I felt before.)", french="(C'est cette même sensation de vertige que\nj'ai ressentie l'autre fois.)", german="(Es ist wieder dieses Schwindelgefühl.)", italian="(Un altro capogiro, come quello di prima.)", spanish="(Es ese mareo que sentí antes.)"}) -- SwitchMonologue: branche default
  GAME:FadeOut(false, 5)
end
