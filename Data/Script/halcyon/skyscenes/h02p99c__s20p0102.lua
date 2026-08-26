-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99C/s20p0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_H02P99C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(60) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(30)
  SkySceneKit.say({english=" It sounds like a storm is coming.", french=" On dirait qu'un orage se prépare.", german="Klingt, als würde sich da ein\nSturm zusammenbrauen.", italian="Dal rumore si direbbe che sta\nper arrivare una tempesta.", spanish=" Parece que va a haber tormenta."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="It already feels like it happened\nlong ago.", french="... j'ai l'impression que c'était\nil y a une éternité.", german="Es scheint so weit in der\nVergangenheit zu liegen.", italian="Sembra che sia successo\ntanto tempo fa!", spanish=" Parece ya tan lejano..."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(Now that time has returned to normal...[K]\nand peace has come to the world...)", french="(Maintenant que le temps a repris son cours\nnormal...[K] et que le monde a retrouvé la paix...)", german="(Jetzt, da die Zeit wieder normal fließt...[K]\nUnd wieder Frieden in diese Welt eingekehrt\nist...)", italian="(Adesso che il tempo è tornato alla\nnormalità...[K] e la pace regna di\nnuovo sul mondo...)", spanish="(Todo ha vuelto a la normalidad...[K]\nY la paz reina en este mundo...)"}) -- SwitchMonologue: branche default
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="(I remember it clearly...)", french="(Je m'en souviens très bien...)", german="(Ich erinnere mich noch genau.)", italian="(Mi ricordo bene...)", spanish="(Lo recuerdo perfectamente...)"}) -- SwitchMonologue: branche default
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(false, 30)
end
