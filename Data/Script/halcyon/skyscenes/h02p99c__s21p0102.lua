-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99C/s21p0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_H02P99C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" How could I say that about us?", french="Je n'ai pas pu leur annoncer\nune chose pareille!", german="Wie hätte ich das über uns\nsagen sollen?", italian="Come faccio a dire una cosa\ndel genere?", spanish=" ¿Cómo iba a decir algo así?"}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(20)
  SkySceneKit.say({english="Should I have told everyone?\nIs that the right thing to do?", french="Est-ce que j'aurais vraiment dû\nen parler à tout le monde?", german="Hätte ich es allen erzählen\nsollen? Wäre das richtig gewesen?", italian="Dovrei dirlo a tutti?\nÈ la cosa giusta da fare?", spanish="A lo mejor debería habérselo\ncontado a todos..."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(...............)", french="(...............)", german="(...............)", italian="(...............)", spanish="(...)"}) -- SwitchMonologue: branche default
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  SkySceneKit.say({english=" Would the world be saved?", french=" ... le monde serait sauvé?", german=" Ob die Welt dann gerettet wäre?", italian="... pensi che il mondo si\nsalverebbe?", spanish=" ¿Se salvará el mundo?"}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  SkySceneKit.say({english="...[K]In that case...[K]maybe that's\nthe best thing to do...", french="...[K] Dans ce cas...[K] c'est peut-être\nla meilleure chose à faire...", german="...[K]In diesem Fall...[K] wäre es\nvielleicht das Beste, was wir tun könnten...", italian="...[K] In tal caso...[K] forse sarebbe\nla cosa migliore da fare...", spanish="Entonces...[K] De ser así...[K] quizás\nsea la mejor opción..."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="(Oh, [partner]!)", french="(Oh, [partner]!)", german="(Oh, [partner]!)", italian="(Oh, [partner]!)", spanish="(¡Lo siento, [partner]!)"}) -- SwitchMonologue: branche default
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Let's get some sleep,\n[hero].", french=" Reposons-nous, [hero].", german="Legen wir uns schlafen,\n[hero].", italian="È meglio andare a dormire,\n[hero].", spanish="Durmamos un rato,\n[hero]."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
