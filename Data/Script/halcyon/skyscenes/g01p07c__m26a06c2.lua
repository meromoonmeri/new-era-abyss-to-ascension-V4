-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m26a06c2.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_MEMORIES_RETURNED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="I realized I did the right thing in\nbecoming an exploration team member.", french="J'ai compris que j'ai pris\nla bonne décision en devenant membre\nd'une équipe d'exploration.", german="Mir wurde klar, dass es richtig\nwar, Mitglied in einem Erkundungsteam zu\nwerden.", italian="Mi ha fatta sentire felice di\nessere diventata membro di una squadra\nd'esplorazione.", spanish="Me he dado cuenta de que ha\nsido muy buena idea hacerme exploradora."}) -- SwitchTalk: branche default (canon générique)
  -- SetOutputAttribute(4) [neutre/état moteur]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(-8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  SkySceneKit.say({english="If it ever came true, I'd surely\nfaint from sheer happiness!", french="S'il devenait réalité, je pense\nque j'en tomberais à la renverse tellement\nje serais heureuse!", german="Wenn er jemals wahr wird,\nfalle ich vor lauter Freude bestimmt in\nOhnmacht!", italian="Se riuscissi a realizzarlo, sono\nsicura che sverrei dalla gioia!", spanish="Si consiguiera resolver el\nmisterio, ¡creo que me desmayaría de\nla felicidad!"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  SkySceneKit.say({english=" Ha ha ha ha!", french=" Ha ha ha ha!", german=" Hahahaha!", italian=" Ah ah ah ah!", spanish=" ¡Ja, ja, ja!"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(90)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
end
