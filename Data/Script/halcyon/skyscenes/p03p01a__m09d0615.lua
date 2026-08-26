-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P03P01A/m09d0615.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_P03P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="(What did I just pick up on?)", french="(Qu'est-ce que je viens de voir?)", german="(Was habe ich da gerade wahrgenommen?)", italian="(Cosa sta succedendo?)", spanish="(¿Qué acabo de ver?)"}) -- SwitchMonologue: branche default
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySceneKit.say({english="(But it still bugs me for some reason...)", french="(Mais pour une raison inconnue, ça me\ntracasse...)", german="(Aber aus irgendeinem Grund lässt sie mich\nnicht los...)", italian="(Ma per qualche motivo mi ricorda\ncomunque qualcosa...)", spanish="(Pero por algún motivo, eso me irrita.)"}) -- SwitchMonologue: branche default
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  SkySceneKit.say({english=" Did you see something?", french=" Tu as vu quelque chose?", german=" Hast du etwas gesehen?", italian=" Hai visto qualcosa?", spanish=" ¿Has podido ver algo?"}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  SkySceneKit.say({english="(\\\"That lifts the fog!\\\")", french="(\\\"Le brouillard se lève!\\\")", german="([F:S2]Das löst den Nebel auf![F:E2])", italian="(\\\"Così la nebbia si alzerà!\\\")", spanish="(\\\"¡Eso disipará la niebla!\\\")"}) -- SwitchMonologue: branche default
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="(Is that maybe...)", french="(Peut-être que...)", german="(Ist das vielleicht...)", italian="(Che si tratti...)", spanish="(¿Tal vez se refiera...?)"}) -- SwitchMonologue: branche default
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
