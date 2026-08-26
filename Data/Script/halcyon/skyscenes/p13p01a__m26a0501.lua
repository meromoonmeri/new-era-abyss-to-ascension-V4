-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P13P01A/m26a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_HAVE_TO_GET_HOME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P13P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(512) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(480), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(4.0,0.0) px/frame -> caméra continue (pilote scroll)
  GAME:FadeIn(60)
  GAME:WaitFrames(120)
  SkySceneKit.say({english=" It's [hero]'s...[K]last wish...", french="C'est la dernière volonté...[K]\nde [hero]...", german="Es war der letzte Wunsch\nvon...[K] [hero]...", italian="Perché è l'ultimo...[K] desiderio di\n[hero]...", spanish="Lo que [hero]...[K] me pidió\nque hiciera."}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(160)
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:WaitFrames(140)
  -- GAP: BGM BGM_FARTHER_AWAY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetBackScrollSpeed(0,0): arrêt du défilement
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  -- message_SetWaitMode(160, 90) [neutre/état moteur]
  SkySceneKit.say({english=" Th-there's...", french=" C'est...", german=" D-da ist...", italian=" E-Ecco...", spanish=" Allí está..."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english=" There's the Rainbow Stoneship...", french=" C'est le Vaisseau Arc-en-Ciel...", german="Da ist das\nRegenbogen-Steinschiff...", italian=" Ecco il Vascello Arcobaleno...", spanish=" La Barca Arcoiris..."}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(20)
  -- SetAnimation(768) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(24), p.Y+(8), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(32), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(24), p.Y+(8), false, 2) end -- Move2PositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(80), p.Y+(4), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
end
