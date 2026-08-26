-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P19P01A/n03a1901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 256, 176, Direction.Down, "NPC_AAMARUDO")
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetPositionLives(6) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(228, 244, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aamarudo, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Huh?[K] Junior, did you finish\ngetting ready?", french="Hein?[K] Petit, tu as fini\ntes préparatifs?", german="Hmmm...[K] Junior, bist du schon\nfertig mit deinen Vorbereitungen?", italian="Uh?[K] Piccolo, hai finito\ndi prepararti?", spanish="¿Eh?[K] ¿Has acabado de\nprepararte, peque?"})
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_aamarudo, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.cleanup_npcs()
end
