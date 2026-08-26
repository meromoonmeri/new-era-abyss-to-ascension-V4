-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D24P31A/m20a0706.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_D24P31B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="That they would return the\nTime Gears to their rightful places?", french="Ils ont dit qu'ils remettraient\nles Rouages du Temps en place.", german="Dass sie die Zahnräder der Zeit\nwieder an die vorgesehenen Stellen bringen?", italian="Ovvero che avrebbero riportato\ngli Ingranaggi del Tempo al loro posto?", spanish="¿No dijeron que devolverían\nlos Engranajes del Tiempo al lugar que\nles correspondía?"}) -- SwitchTalk: branche default (canon générique)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 256, 232, Direction.Up, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" But time remains stopped here...", french="Et pourtant, le temps est\ntoujours à l'arrêt ici...", german="Aber die Zeit steht hier noch\nimmer still...", italian="Ma il tempo qui è ancora\nfermo...", spanish="Pero el tiempo aquí sigue sin\nfluir..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="The Time Gears may not have\nbeen put back in their rightful places yet.", french="... que les Rouages du Temps\nn'ont pas encore été remis à leur place.", german="Die Zahnräder der Zeit wurden\nnoch nicht an die für sie vorgesehenen Stellen\nzurückgebracht.", italian="Significa che gli Ingranaggi del\nTempo potrebbero non essere ancora al loro\nposto.", spanish="Puede que todavía no hayan\ndevuelto los Engranajes del Tiempo a\nsu sitio."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We'll see about that. The\nforest's Time Gear was over here.", french="On va bien voir. Le Rouage du\nTemps de cette forêt se trouvait\npar là, autrefois.", german="Das werden wir feststellen.\nDas Zahnrad der Zeit dieses Waldes war an\ndieser Stelle.", italian="Lo scopriremo. L'Ingranaggio del\nTempo della foresta era da queste parti.", spanish="Ahora lo comprobaremos.\nEl Engranaje del Tiempo estaba por aquí."})
  -- message_Close
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-160), false, 2) end
  GAME:WaitFrames(5)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-160), false, 2) end
  GAME:WaitFrames(5)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-160), false, 2) end
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
