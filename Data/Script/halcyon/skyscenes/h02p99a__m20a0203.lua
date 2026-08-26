-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/m20a0203.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  pcall(function() GAME:MoveCamera(276, 196, 60, false) end) -- performer/caméra
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 276, 204, false, 1)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 224, 208, Direction.Left, "NPC_JUPUTORU")
  GROUND:EntTurn(npc_npc_juputoru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I see...[K] This is a hollow chamber\nin the face of the cliff.", french="Je vois...[K] C'est une cavité\ncreusée dans la falaise.", german="Ich verstehe...[K] Das ist ein\nHohlraum auf der Vorderseite der Klippe.", italian="Capisco...[K] È una specie di\ncavità naturale all'interno della scogliera.", spanish="Ya veo...[K] Hay una especie de\nestancia natural en la ladera del acantilado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 276, 164, false, 1)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  GAME:WaitFrames(60)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  SkySceneKit.say({english="It may be better if we stay\nhere for a while.", french="On ferait mieux de rester ici\npendant quelque temps.", german="Es wäre vielleicht besser, wenn\nwir hier eine Weile bleiben würden.", italian="È meglio se restiamo qui per un\npo'.", spanish="Por el momento, podemos vivir\naquí."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Agreed.", french=" C'est d'accord.", german=" Abgemacht.", italian=" D'accordo.", spanish=" Estoy de acuerdo."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
