-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99E/s21p0204.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_IN_THE_HANDS_OF_FATE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_H01P99E) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english=" I really don't know...", french=" Je n'en ai aucune idée...", german=" Ich weiß es wirklich nicht...", italian=" Non lo so davvero...", spanish=" La verdad es que no lo sé..."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="Maybe it was because\n[hero] stood by me.", french="Peut-être que c'est grâce à\nla présence de [hero] à mes côtés.", german="Vielleicht war es, weil\n[hero] mir beigestanden hat.", italian="Forse perché [hero] era\nal mio fianco.", spanish="Tal vez se debió a que\n[hero] estaba allí conmigo."}) -- SwitchTalk: branche default (canon générique)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 224, 168, Direction.UpLeft, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [hero]...?", french=" [hero]...?", german=" [hero]?", italian=" [hero]?", spanish=" ¿[hero]?"})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
