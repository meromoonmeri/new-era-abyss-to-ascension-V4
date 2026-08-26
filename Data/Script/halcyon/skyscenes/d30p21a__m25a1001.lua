-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D30P21A/m25a1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  SkySceneKit.say({english=" Ugh...[K] We didn't do so well...", french=" Argh...[K] Quel échec retentissant!", german=" Uff...[K] Wir waren nicht gut...", italian="Uff...[K] Non è andata molto\nbene...", spanish=" Uf...[K] No hemos dado la talla."}) -- SwitchTalk: branche default (canon générique)
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D30P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_TEMPORAL_SPIRE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  SkySceneKit.say({english=" Urk![K] We have to get moving.", french="Argh![K] Dépêchons-nous d'y\nretourner.", german="Umpf![K] Wir müssen\nvorankommen.", italian=" Uh![K] Dobbiamo far presto.", spanish="Pero...[K] tenemos que darnos\nprisa."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="We're so close now...[K] We can't\ngive up now, [hero]!", french="On se rapproche...[K]\nTiens bon, [hero]!", german="Wir sind so nah dran...[K] Wir\nkönnen jetzt nicht aufgeben, [hero]!", italian="Ci siamo quasi...[K] Diamoci\ndentro, [hero]!", spanish="Estamos tan cerca ya...[K]\n¡No podemos rendirnos ahora, [hero]!"}) -- SwitchTalk: branche default (canon générique)
end
