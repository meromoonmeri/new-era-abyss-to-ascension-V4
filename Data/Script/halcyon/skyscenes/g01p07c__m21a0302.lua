-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m21a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  GAME:WaitFrames(60)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(60)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="You know...[K] I'm glad everyone\nbelieved our story.", french="Tu sais...[K] je suis soulagée que\ntout le monde ait fini par nous croire.", german="Weißt du...[K] Ich bin froh, dass\nalle unsere Geschichte geglaubt haben.", italian="Sai,[K] sono contenta che abbiano\ncreduto tutti alla nostra storia.", spanish="¿Sabes...?[K] Me alegro muchísimo\nde que todos hayan creído nuestra historia."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  SkySceneKit.say({english=" I got a little emotional over it!", french=" J'en avais les larmes aux yeux!", german="Ich bin fast ein bisschen\nsentimental geworden!", italian=" Mi sono un po' emozionata!", spanish=" ¡La verdad es que me emocioné!"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Let's get back at it tomorrow,\n[hero]!", french="Demain, on s'y remet,\n[hero]!", german="Machen wir morgen weiter,\n[hero]!", italian="Ma ci penseremo domani,\n[hero]!", spanish="Mejor será que volvamos\nmañana, [hero]."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(90)
  GAME:WaitFrames(30)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
