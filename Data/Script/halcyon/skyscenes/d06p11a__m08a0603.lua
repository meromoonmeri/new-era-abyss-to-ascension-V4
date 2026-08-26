-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D06P11A/m08a0603.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Craggy Coast.ogg", true) end)
  -- back_SetGround(LEVEL_D06P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(partner, 368, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 368, 196, false, 2)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 344, 240, Direction.Up, "NPC_BIPPA")
  GROUND:MoveToPosition(npc_npc_bippa, 368, 220, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(hero, 344, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(4) [anim idle native]
  SkySceneKit.say({english="(It must be the excitement from exploring\nthat's bringing it out...)", french="(C'est sûrement la joie de faire partie de\nl'expédition qui lui donne des ailes...)", german="(Das kommt sicher von der Aufregung über\ndie Expedition.)", italian="(Dev'essere l'entusiasmo che fa emergere\nquesto suo lato...)", spanish="(Debe de ser por la emoción que le produce\neste viaje.)"}) -- SwitchMonologue: branche default
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.say({english="(Yes, [partner] is getting stronger and\nmore confident bit by bit...)", french="(Oui, petit à petit, [partner] s'améliore\net prend confiance...)", german="(Ja, [partner] wird nach und nach immer\nselbstbewusster.)", italian="(Sì, [partner] sta diventando più forte\npoco a poco...)", spanish="(Exacto. [partner] confía cada vez\nmás en sus aptitudes y es más fuerte.)"}) -- SwitchMonologue: branche default
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  SkySceneKit.say({english=" Oh... Huh?", french=" Oh... Quoi?", german=" Oh... Äh?", italian=" Oh... Eh?", spanish=" Vaya."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Huh? Problem?", french=" Heiiin? Un problème?", german=" Ähem? Gibt es ein Problem?", italian=" Eh? C'è qualche problema?", spanish=" ¿Qué pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="If you look closely here, there\nare two entrances.", french="Regarde bien, il y a deux\nentrées ici.", german="Wenn man genau hinsieht, gibt\nes zwei Eingänge.", italian="Se guardi bene, qui ci sono\ndue ingressi.", spanish=" Si os fijáis, hay dos caminos."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Huh? Now, that is mighty vexing.", french="Heiiin? Mais c'est vachement\nembêtant, ça.", german=" Hmm... Das ist aber verwirrend.", italian=" Eh? Questa sì che è una bega.", spanish=" ¡Vaya! ¡Qué mala pata!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.cleanup_npcs()
end
