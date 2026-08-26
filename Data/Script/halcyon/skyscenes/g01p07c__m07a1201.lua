-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m07a1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  SkySceneKit.say({english=" I'm famished...", french=" Je meurs de faim...", german=" Ich verhungere...", italian=" Adesso sono proprio affamata...", spanish=" Estoy muerta de hambre..."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Staying awake doesn't help.\nLet's get some sleep.", french="Rester debout ne va pas\narranger les choses. Allons nous coucher.", german="Es bringt auch nichts, wenn wir\nwach bleiben. Lass uns schlafen.", italian="Stare in piedi non migliorerà le\ncose. Andiamo a dormire.", spanish="Quedarnos sin dormir no va\na solucionar nada. Descansemos mejor."}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(45)
  -- SetAnimation(76) [anim idle native]
  GAME:WaitFrames(30)
  SkySceneKit.say({english=" Good night, [hero].", french=" Bonne nuit, [hero].", german=" Gute Nacht, [hero].", italian=" Buonanotte, [hero].", spanish=" Buenas noches, [hero]."}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(45)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.Right)
  -- SetAnimation(76) [anim idle native]
  GAME:WaitFrames(50)
  GAME:FadeIn(60) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Let's keep at it tomorrow.", french=" Nous ferons mieux demain.", german=" Morgen geht es weiter.", italian="Continuiamo a fare del nostro\nmeglio, domani.", spanish=" Mañana más."}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(30)
  -- SetAnimation(62) [anim idle native]
  -- SetAnimation(62) [anim idle native]
  GAME:WaitFrames(120)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
end
