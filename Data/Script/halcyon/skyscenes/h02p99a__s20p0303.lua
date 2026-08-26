-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s20p0303.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Am nächsten Morgen...", italian="[CN]La mattina dopo...", spanish="[CN]Al día siguiente..."})
  -- message_Close
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(60)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Come on, [hero].", french=" Allez, [hero].", german=" Komm schon, [hero].", italian=" Forza, [hero].", spanish=" Vamos, [hero]."}) -- SwitchTalk: branche default (canon générique)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(62) [anim idle native]
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.say({english=" Wake up, [hero].", french=" Réveille-toi, [hero].", german=" Aufwachen, [hero].", italian=" Svegliati, [hero].", spanish=" Despierta, [hero]."}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(76) [anim idle native]
  SkySceneKit.say({english=" It's morning.", french=" C'est le matin.", german=" Es ist Morgen.", italian=" È già mattina.", spanish=" Ya es de día."}) -- SwitchTalk: branche default (canon générique)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="(Uh...[K] Uh-huh...)", french="(Hum...[K] Hum...)", german="(Mh...[K] Hm-mmm...)", italian="(Eh...[K] Uh-huh...)", spanish="(¿Eh?[K] Esto...)"}) -- SwitchMonologue: branche default
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(partner, 224, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Come look at this![K] The weather's\ngreat again!", french="Viens voir![K] Il fait encore\nbeau aujourd'hui!", german="Hey, sieh dir das an![K] Das Wetter\nist wieder super!", italian="Ehi, dai un'occhiata![K] C'è di\nnuovo bel tempo!", spanish=" ¡Mira![K] ¡Hace muy buen tiempo!"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(If the distortion in the fabric of space\nexpands...[K]the world will be ruined.)", french="(... que si cette distorsion de la trame\nde l'espace venait à s'étendre...[K] le monde\nserait dévasté.)", german="(Sie sagte, dass eine weitere Ausdehnung der\nVerzerrung im Raumgefüge...[K] die Welt\nzerstören würde.)", italian="(Ha detto che se la distorsione nella struttura\ndello spazio continua...[K] il mondo sarà\nspacciato.)", spanish="([CS:N]Cresselia[CR] me dijo que si la deformación\ndel espacio sigue aumentando...[K] el mundo\nacabaría por destruirse.)"}) -- SwitchMonologue: branche default
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="(Oh! The distortion of space![K] We heard that\nsomewhere before!)", french="(Oh! La distorsion de l'espace![K] On a déjà\nentendu ça quelque part!)", german="(Oh! Die Verzerrung des Raumes![K] Das haben\nwir irgendwo schon einmal gehört!)", italian="(Oh! La distorsione dello spazio![K] Ne abbiamo\ngià sentito parlare!)", spanish="(¡Ahora que recuerdo...![K] ¡Ya habíamos oído\nhablar de la deformación del espacio!)"}) -- SwitchMonologue: branche default
  pcall(function() SOUND:FadeOutBGM(160) end)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
