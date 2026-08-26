-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D41P41A/s22p1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(8198) — table SE NDS→PMDO non mappée v1
  GAME:FadeOut(true, 20) -- WhiteOut
  -- back_SetGround(LEVEL_D41P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(45)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(8967) — table SE NDS→PMDO non mappée v1
  -- GAP: SetEffect EFFECT_EXCLAMATION_MARK, 3 — VFX NDS→PMDO non mappés v1
  -- GAP: SetEffect EFFECT_EXCLAMATION_MARK, 3 — VFX NDS→PMDO non mappés v1
  -- GAP: SetEffect EFFECT_EXCLAMATION_MARK, 3 — VFX NDS→PMDO non mappés v1
  -- GAP: SetEffect EFFECT_EXCLAMATION_MARK, 3 — VFX NDS→PMDO non mappés v1
  -- GAP: SetEffect EFFECT_EXCLAMATION_MARK, 3 — VFX NDS→PMDO non mappés v1
  -- GAP: SetEffect EFFECT_EXCLAMATION_MARK, 3 — VFX NDS→PMDO non mappés v1
  -- GAP: SetEffect EFFECT_EXCLAMATION_MARK, 3 — VFX NDS→PMDO non mappés v1
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" That blasted [CS:N]Cresselia[CR]!", french=" Maudite [CS:N]Cresselia[CR]!", german=" Das hat [CS:N]Cresselia[CR] umgehauen!", italian=" Quella maledetta [CS:N]Cresselia[CR]!", spanish=" ¡Esa dichosa [CS:N]Cresselia[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="She fled with [hero] and\nthat sidekick!", french="Elle s'est enfuie avec\n[hero] et son faire-valoir!", german="Sie ist mit [hero] und\ndiesem Handlanger geflohen!", italian="È scappata con [hero] e\nquell'altro Pokémon!", spanish="¡Ha huido con [hero] y su\nacompañante!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...So be it.[K] They will eventually\nhave to return here.", french="... Soit.[K] Ces trois-là finiront\nbien par revenir.", german="Sei es drum.[K] Irgendwann werden\nsie hierher zurückkehren müssen.", italian="E sia.[K] Prima o poi\ndovranno tornare qui.", spanish="Sea.[K] Tendrán que volver aquí,\ntarde o temprano."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Because they will try to\ndefeat me.", french=" Pour essayer de me vaincre.", german="Denn sie werden versuchen,\nmich zu besiegen.", italian=" Per cercare di sconfiggermi.", spanish=" Porque querrán derrotarme."})
  -- message_Close
  -- GAP: se_Play(6925) — table SE NDS→PMDO non mappée v1
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="However...[K] That will end in their\nelimination, not mine.", french="Mais...[K] ce sont ces trois-là\nqui mordront la poussière, et pas moi.", german="Das Ergebnis allerdings...[K] Das\nErgebnis wird darin bestehen, dass ich sie alle\naus dem Weg räumen werde!", italian="Tuttavia...[K] Quando torneranno\nsarò io a eliminarli, non viceversa.", spanish=" Pero...[K] no seré yo el derrotado."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" All I need to do is wait.", french="Patience, mon heure de gloire\nviendra.", german="Alles, was ich tun muss, ist\nwarten.", italian=" Devo solo aspettare.", spanish=" Solo tengo que esperar."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I look forward to their\nnext arrival.", french=" J'ai hâte de les revoir.", german="Ich freue mich auf ihr nächstes\nEintreffen.", italian=" Non vedo l'ora che tornino.", spanish=" Estaré esperando su llegada."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
