-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m11a0704.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="(And the Time Gears being stolen...[K] No, there's\nno connection at all.)", french="(Et la disparition des Rouages du Temps...[K] Non,\nça n'a rien à voir.)", german="(Und dass die Zahnräder der Zeit gestohlen\nwerden...[K] Nein, es gibt keinen Zusammenhang.)", italian="(... e il fatto che gli Ingranaggi del Tempo\nsiano stati rubati.[K] No, non c'è alcun\ncollegamento.)", spanish="(Y ahora los Engranajes del Tiempo están\ndesapareciendo...[K] No, no creo que haya\nninguna relación.)"}) -- SwitchMonologue: branche default
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="I get this feeling that our\nexpedition to [CS:P]Fogbound Lake[CR] took place a long\ntime ago.", french="J'ai l'impression que ça fait\nune éternité qu'on est tous partis en\nexpédition au [CS:P]Lac des Brumes[CR].", german="Es kommt mir so vor, als wäre\ndie Expedition zum [CS:P]Nebelsee[CR] schon sehr lange\nher.", italian="È come se la spedizione al\n[CS:P]Lago Foschia[CR] fosse avvenuta molto tempo fa.", spanish="Es como si hubiera pasado mucho\ntiempo desde la expedición al [CS:P]Lago Velado[CR]."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" I wonder if he's well?", french=" Tu crois qu'il va bien?", german=" Ob es ihm wohl gut geht?", italian=" Spero che stia bene.", spanish=" ¿Estará bien?"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:FadeOut(false, 60)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Hmm...", french=" Hum...", german=" Hmm...", italian=" Mmm...", spanish=" Hum."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" I knew it...", french=" Je le savais...", german=" Ich wusste es...", italian=" Lo sapevo...", spanish=" Lo sabía."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="I knew I shouldn't have\ntrusted them.", french="Je savais bien que je n'aurais\npas dû leur faire confiance.", german="Ich wusste, ich hätte ihnen nicht\ntrauen sollen.", italian="Sapevo che non avrei dovuto\nfidarmi di loro.", spanish="Sabía que no tenía que haberme\nfiado de ellos."})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(0)
  GAME:FadeOut(true, 5) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(5)
  GAME:FadeOut(false, 0)
  GAME:WaitFrames(2) -- join WaitSe
end
