-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m22a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetBanner2(LEVEL_V22P01A, 0, 160, 72, 18,) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03C) [décor sub chargé: Sub_v01p03c]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(432, 180, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 532, 196, false, 2)
  GROUND:MoveToPosition(hero, 532, 196, false, 2)
  SkySubScreen.Show("v01p03c", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GROUND:MoveToPosition(partner, 412, 172, false, 2)
  GROUND:MoveToPosition(hero, 456, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  SkySceneKit.say({english="I was hoping to see [CS:N]Grovyle[CR]\nhere.", french="J'espérais tant que [CS:N]Massko[CR]\nserait là.", german="Ich hatte gehofft, [CS:N]Reptain[CR] hier\nzu treffen.", italian="Speravo di incontrare [CS:N]Grovyle[CR]\nqui.", spanish="Tenía la esperanza de que\n[CS:N]Grovyle[CR] estuviera aquí."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  SkySceneKit.say({english=" I guess he's not here after all...", french=" On dirait que ce n'est pas le cas.", german="Ich denke, er ist doch nicht\nhier.", italian=" Non mi sembra che sia qui.", spanish=" Pero supongo que no está..."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  SkySceneKit.say({english="They always come out to blow\nbubbles here in the evening.", french="D'habitude, ils sont toujours là\nle soir, à faire des bulles.", german="Die kommen abends immer\nhierher, um Blasen in die Luft zu pusten.", italian="Di sera sono sempre qui intorno\na fare le bolle.", spanish="Antes del anochecer siempre\nsalen a soplar pompitas."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  SkySceneKit.say({english="I love seeing their bubbles go\nfloating away in the evening sky.", french="J'adore regarder leurs bulles\nemportées par le vent.", german="Ich liebe es, wie ihre Blasen\nin den Abendhimmel davonschweben.", italian="Adoro guardare le loro bolle\nvolare al tramonto.", spanish="Me encanta ver cómo cambian\nde color con los rayos del sol."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  SkySceneKit.say({english="Well, that's too bad.[K] It's a\nletdown, but...", french="Ah, c'est vraiment dommage.[K]\nJe suis déçue, mais...", german="Wirklich schade.[K] Es ist eine\nEnttäuschung, aber...", italian="Beh, che peccato.[K] È una\ndelusione, ma...", spanish="Vaya, qué pena.[K]\nEs una decepción, pero..."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  SkySceneKit.say({english=" The sunset is sure pretty.", french="Le coucher de soleil est\nmagnifique, comme d'habitude.", german="Der Sonnenuntergang ist wirklich\nhübsch.", italian=" Il tramonto è così bello...", spanish="La puesta de sol sigue siendo\npreciosa."}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  SkySceneKit.say({english=" You know...", french=" Tu sais...", german=" Weißt du...", italian=" Sai...", spanish=" ¿Sabes una cosa...?"}) -- SwitchTalk: branche default (canon générique)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(-8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  SkySceneKit.say({english="It was here, wasn't it? Where\n[CS:N]Koffing[CR] and his sidekick stole my Relic\nFragment?", french="C'est ici que [CS:N]Smogo[CR] et\nson acolyte m'ont volé mon Fragment\nde Relique.", german="Es war hier, wo [CS:N]Smogon[CR] und\nsein Handlanger mein Reliktfragment gestohlen\nhaben.", italian="È qui che [CS:N]Koffing[CR] e il suo\nscagnozzo mi hanno rubato il Frammento\nAntico.", spanish="Fue aquí donde [CS:N]Koffing[CR] y su\ncompinche me robaron la Reliquia de Piedra."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:FadeOutBGM(60) end)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
