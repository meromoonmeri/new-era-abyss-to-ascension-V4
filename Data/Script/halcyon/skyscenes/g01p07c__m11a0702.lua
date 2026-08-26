-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m11a0702.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
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
  SkySceneKit.say({english="What would anyone want with\nthe Time Gears anyway?", french="Qu'est-ce qu'on peut bien\nen faire de toute façon?", german="Was sollte irgendwer überhaupt\nmit Zahnrädern der Zeit anstellen wollen?", italian="A che scopo rubare gli\nIngranaggi del Tempo?", spanish="¿Para qué querría nadie\nllevarse los Engranajes del Tiempo?"}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(30)
  SkySceneKit.say({english=" I just can't figure it out...", french=" Ça me dépasse...", german=" Ich kapiere es einfach nicht...", italian=" Non riesco proprio a capire...", spanish=" No lo entiendo..."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  SkySceneKit.say({english="(But when I was at [CS:P]Fogbound Lake[CR] and saw a\nTime Gear for the first time...)", french="(Mais au [CS:P]Lac des Brumes[CR], quand j'ai vu\nun Rouage du Temps pour la première fois...)", german="(Aber als ich am [CS:P]Nebelsee[CR] zum ersten Mal ein\nZahnrad der Zeit sah...)", italian="(Ma quella volta al [CS:P]Lago Foschia[CR], quando ho\nvisto l'Ingranaggio del Tempo per la prima\nvolta...)", spanish="(Pero cuando estuve en el [CS:P]Lago Velado[CR] y vi\nun Engranaje del Tiempo por primera vez...)"}) -- SwitchMonologue: branche default
  GAME:FadeOut(false, 30)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
