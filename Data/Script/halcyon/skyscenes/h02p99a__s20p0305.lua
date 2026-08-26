-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s20p0305.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v24p08a", 15, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="(I heard that at [CS:P]Luminous Spring[CR].)", french="(C'est à la [CS:P]Source Lumineuse[CR] que j'ai\nentendu ça.)", german="(Das habe ich bei der [CS:P]Glitzerquelle[CR] gehört.)", italian="(L'ho sentito alla [CS:P]Sorgente Luccichio[CR].)", spanish="(Eso fue en el [CS:P]Manantial Luminoso[CR].)"}) -- SwitchMonologue: branche default
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  SkySceneKit.say({english="(Is that what I am here...?)", french="(Est-ce que c'est pour cela que je suis là...?)", german="(Liegt es wirklich an mir?)", italian="(Io sto causando tutto questo..?)", spanish="(¿Es eso lo que soy aquí? ¿Un peligro?)"}) -- SwitchMonologue: branche default
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(36), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Why are you daydreaming?[K]\nIt's not like you, [hero].", french="Tu es ailleurs ou quoi?[K]\nÇa ne te ressemble pas, [hero].", german="Warum bist du so\ngedankenverloren?[K] Das kenne ich gar nicht\nvon dir, [hero].", italian="Stai sognando a occhi aperti?[K]\nNon è da te, [hero].", spanish="¿Qué haces mirando a las\nmusarañas?[K] No es propio de ti, [hero]."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Come on, let's see some energy,\n[hero]!", french="Allons, un peu d'entrain,\n[hero]!", german="Komm schon, zeig etwas Elan,\n[hero]!", italian="Forza, mettici un po' di energia,\n[hero]!", spanish="Venga, ¡un poco de energía,\n[hero]!"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(I gotta cheer up!)", french="(Je dois remonter la pente!)", german="(Ich muss mich aufrappeln!)", italian="(Devo tirarmi su!)", spanish="(¡Tengo que animarme!)"}) -- SwitchMonologue: branche default
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Let's make this another big day,\n[hero]!", french="C'est parti pour une nouvelle\njournée magnifique, [hero]!", german="Machen wir auch diesen Tag zu\netwas Besonderem, [hero]!", italian="Facciamo anche oggi del nostro\nmeglio, [hero]!", spanish="¡Seguro que hoy será un\ngran día, [hero]!"}) -- SwitchTalk: branche default (canon générique)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: BGM BGM_DO_YOUR_BEST_AS_ALWAYS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
