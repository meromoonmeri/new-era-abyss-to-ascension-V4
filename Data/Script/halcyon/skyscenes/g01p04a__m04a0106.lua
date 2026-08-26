-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m04a0106.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 168, 296, Direction.DownRight, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Look, all you two have to do is\ninspect the footprints of visitors, then tell me\nwhat Pokémon they are.", french="Tout ce que vous avez à faire,\nc'est inspecter les empreintes des visiteurs\net me dire de quel Pokémon il s'agit.", german="Also, ihr müsst nur die\nFußabdrücke der Besucher inspizieren und mir\nsagen, was für Pokémon sie sind.", italian="Tutto ciò che dovete fare è\nispezionare le zampe dei visitatori e dirmi\na quali Pokémon appartengono.", spanish="Lo único que tenéis que hacer\nes inspeccionar las huellas de los visitantes,\ny luego decirme de qué Pokémon se trata."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" All right? Understood?", french=" C'est bon? Vous avez compris?", german=" In Ordnung? Verstanden?", italian=" Va bene? Tutto chiaro?", spanish=" ¿Entendido?"})
  SkySceneKit.cleanup_npcs()
end
