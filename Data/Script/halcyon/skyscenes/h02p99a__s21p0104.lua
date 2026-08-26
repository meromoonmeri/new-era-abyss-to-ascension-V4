-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s21p0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="Why are you daydreaming?[K]\nIt's not like you, [hero].", french="Tu es ailleurs ou quoi?[K]\nÇa ne te ressemble pas, [hero].", german="Warum bist du so\ngedankenverloren?[K] Das kenne ich gar nicht\nvon dir, [hero].", italian="Stai sognando a occhi aperti?[K]\nNon è da te, [hero].", spanish="¿Qué haces mirando a las\nmusarañas?[K] No es propio de ti, [hero]."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Come on, let's see some energy,\n[hero]!", french="Allons, un peu d'entrain,\n[hero]!", german="Komm schon, zeig etwas Elan,\n[hero]!", italian="Forza, mettici un po' di energia,\n[hero]!", spanish="Venga, ¡un poco de energía,\n[hero]!"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(But...[K][partner] could be right.)", french="(Mais...[K] [partner] a sûrement raison.)", german="(Aber...[K] [partner] könnte recht haben.)", italian="(Ma...[K] [partner] forse ha ragione.)", spanish="(Aunque...[K] [partner] tal vez tenga razón.)"}) -- SwitchMonologue: branche default
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
end
