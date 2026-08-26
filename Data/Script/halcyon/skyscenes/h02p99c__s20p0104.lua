-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99C/s20p0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_H02P99C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="(Time is back to normal...[K]but maybe some\nthings are still out of whack.)", french="(Le temps a repris son cours normal...[K] mais\npeut-être que quelque chose cloche\nencore.)", german="(Die Zeit läuft wieder normal...[K] Aber eventuell\nsind noch andere Dinge aus der Balance\ngeraten.)", italian="(Il tempo è tornato alla normalità...[K] ma forse\nalcune cose non sono ancora tornate a posto.)", spanish="(El tiempo ha vuelto a la normalidad...[K] pero\nquizás aún haya otras alteraciones.)"}) -- SwitchMonologue: branche default
  GAME:FadeIn(128) -- WhiteChange
  GAME:WaitFrames(2)
  GAME:FadeIn(256) -- WhiteChange
  GAME:FadeIn(128) -- WhiteChange
  GAME:WaitFrames(5)
  GAME:FadeIn(2) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- GAP: se_Play(6425) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" Waah! Lightning!", french=" Ouah! Un éclair!", german=" Aaaah! Blitze!", italian=" Aaah! Fulmini!", spanish=" ¡Aah! ¡Un relámpago!"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" We should get some sleep now.", french=" Il est temps d'aller se coucher.", german="Wir sollten versuchen, noch\neine Runde zu schlafen.", italian=" Cerchiamo di dormire, adesso.", spanish=" Deberíamos irnos a dormir."}) -- SwitchTalk: branche default (canon générique)
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  SkySceneKit.say({english=" Good night, [hero].", french=" Bonne nuit, [hero].", german=" Gute Nacht, [hero].", italian=" Buonanotte, [hero].", spanish=" Buenas noches, [hero]."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(30)
end
