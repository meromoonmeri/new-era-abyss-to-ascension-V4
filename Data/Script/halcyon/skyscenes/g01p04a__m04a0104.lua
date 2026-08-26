-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m04a0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="OK, so we should climb down\nthis hole. And then what?", french="D'accord, on doit descendre dans\nce trou, et après?", german="Okay, wir sollen also in dieses\nLoch steigen. Und weiter?", italian="Ok, quindi dobbiamo scendere di\nqui. Cosa facciamo dopo?", spanish="Vale, entonces bajamos\npor este agujero. ¿Y luego qué?"}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 168, 296, Direction.DownRight, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="The tunnel down there leads to\nthe sentry post.", french="Le tunnel conduit au poste de\nguet.", german="Der Tunnel da unten führt zum\nWachposten.", italian="Il tunnel sul fondo conduce\nal posto di guardia.", spanish=" Este túnel lleva al puesto vigía."})
  -- message_Close
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
