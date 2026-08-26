-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m05a0802.ssb (ROM sha256 1fa39d35…).
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
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="(I should get to sleep early.)", french="(Je ferais mieux d'aller me coucher de bonne\nheure.)", german="(Ich sollte früh ins Bett gehen.)", italian="(Dovrei andare a letto presto.)", spanish="(Debería acostarme temprano.)"}) -- SwitchMonologue: branche default
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Sigh...[K] We went through a lot\ntoday, didn't we?", french="Pfff...[K] Nous en avons vu\ndes vertes et des pas mûres aujourd'hui,\npas vrai?", german="Seufz...[K] Wir haben heute einiges\nerlebt, was?", italian="Sigh...[K] È stata una giornata\ndavvero intensa oggi, vero?", spanish="Uf...[K] Hay que ver por lo que\nhemos pasado hoy, ¿a que sí?"}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="But you know what? It was\nincredibly fun for me!", french="Mais tu sais quoi? Je me suis\nbeaucoup amusée!", german="Aber weißt du was? Es hat mir\nrichtig Spaß gemacht!", italian="Ma sai una cosa? È stato\ndivertentissimo!", spanish="Pero, ¿sabes una cosa?\n¡Creo que ha sido realmente divertido!"}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(15)
  SkySceneKit.say({english="Sure, there was that huge\nletdown...", french="Bon, je dois avouer que je suis\nun peu déçue...", german="Klar, da war diese eine große\nEnttäuschung...", italian="Certo, c'è stata quella enorme\ndelusione...", spanish="Es cierto que al final nos\nhemos llevado una gran decepción..."}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(20)
  SkySceneKit.say({english="I realized I did the right thing in\nbecoming an exploration team member.", french="J'ai compris que j'ai pris\nla bonne décision en devenant membre\nd'une équipe d'exploration.", german="Mir wurde klar, dass es richtig\nwar, Mitglied in einem Erkundungsteam zu\nwerden.", italian="Mi ha fatta sentire felice di\nessere diventata membro di una squadra\nd'esplorazione.", spanish="Me he dado cuenta de que ha\nsido muy buena idea hacerme exploradora."}) -- SwitchTalk: branche default (canon générique)
  -- SetOutputAttribute(4) [neutre/état moteur]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
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
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.DownRight)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(-8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" But seriously, thanks...", french=" Du fond du cœur, merci...", german=" Aber im Ernst, danke!", italian=" Ma, sul serio, grazie...", spanish=" Pero, ahora en serio, gracias."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(...!)", french="(...!)", german="(Wow!)", italian="(...!)", spanish="(...)"}) -- SwitchMonologue: branche default
  SkySceneKit.say({english=" Yep...", french=" Oui...", german=" Ja...", italian=" Già...", spanish=" Claro."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false, 30)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
