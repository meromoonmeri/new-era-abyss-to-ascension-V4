-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P04P01C/m10a1204.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_TIME_GEAR non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P04P01C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english=" This couldn't be more dazzling!", french=" Quel spectacle éblouissant!", german=" Das ist einfach umwerfend!", italian=" È bellissimo!", spanish=" ¡Qué hermoso!"}) -- SwitchTalk: branche default (canon générique)
  local npc_npc_yukushii = SkySceneKit.spawn_npc("uxie", 160, 352, Direction.Up, "NPC_YUKUSHII")
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="Water constantly wells up from\nfar below this place.", french="Un puits d'eau très profond\nalimente constamment le lac.", german="Unter diesem Ort quillt\nunablässig Wasser nach oben.", italian="L'acqua sgorga incessantemente\ndalle profondità di questo luogo...", spanish="El agua brota con fuerza bajo\neste lugar."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="It flows up so heavily that it\nhas long formed this enormous lake.", french="La source est si abondante\nqu'elle a fini par créer un lac immense.", german="Sein Strom ist so stark, dass es\nschon vor langer Zeit diesen riesigen See\nbildete.", italian="... creando il lago che state\nosservando.", spanish="Brota de forma ininterrumpida,\npor lo que hace mucho tiempo se formó\neste enorme lago."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yukushii, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="Now cast your eyes to the\nglowing area at the lake's center.", french="Maintenant, tournez votre\nregard vers le point lumineux en son centre.", german="Nun richtet euren Blick auf die\nleuchtende Stelle in der Mitte des Sees.", italian="Adesso, vi prego di volgere il\nvostro sguardo alla luce che si trova al centro.", spanish="Ahora mirad con atención\nel resplandor del centro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english=" The bluish green radiance, right?", french="C'est cette lumière bleu-vert,\nc'est ça?", german="Das bläulich grüne Strahlen,\noder?", italian="Quella luce tra il blu e il\nverde, giusto?", spanish="Te refieres a esa especie\nde resplandor azul verdoso, ¿no?"}) -- SwitchTalk: branche default (canon générique)
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" Step forward for a closer look.", french="Approchez-vous pour la voir\nde plus près.", german="Geht näher heran und seht\ngenauer hin.", italian=" Avvicinatevi.", spanish="Dad un paso al frente para poder\nverlo mejor."})
  -- message_Close
  GROUND:EntTurn(npc_npc_yukushii, Direction.Up)
  GROUND:MoveToPosition(partner, 136, 368, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(hero, 176, 368, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
