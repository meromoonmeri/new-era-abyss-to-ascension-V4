-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m05a0804.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_GOODNIGHT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="And it was all because you were\nwith me, [hero].", french="Et tout ça parce que tu étais à\nmes côtés, [hero].", german="Und das alles nur, weil du dabei\nwarst, [hero].", italian="Ed è stato grazie al fatto che tu\neri con me, [hero].", spanish="Y eso es porque estabas\nconmigo, [hero]."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english=" Seriously, [hero], thanks!", french="Je te remercie de tout cœur,\n[hero]!", german=" Wirklich, [hero], danke!", italian=" Grazie davvero, [hero]!", spanish="De verdad, [hero].\n¡Muchas gracias!"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(60)
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="They always seem to happen\nwhen you're touching something.", french="On dirait qu'ils se produisent\ntoujours quand tu touches quelque chose.", german="Anscheinend berührst du immer\ngerade irgendetwas, wenn sie kommen.", italian="Mi pare che si siano verificati\nsempre mentre toccavi qualcosa.", spanish="Parece que siempre se producen\ncuando tocas algo."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="(When I heard [CS:N]Azurill[CR]'s scream...)", french="(Quand j'ai entendu crier [CS:N]Azurill[CR]...)", german="(Als ich [CS:N]Azurill[CR] schreien hörte...)", italian="(Quando ho sentito [CS:N]Azurill[CR] gridare...)", spanish="(Cuando escuché el grito de [CS:N]Azurill[CR]...)"}) -- SwitchMonologue: branche default
  GAME:FadeOut(false, 30)
end
