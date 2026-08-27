-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/s30a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SkyProg.set(7, 3) -- $SCENARIO_MAIN = scn[7,3] (ROM)
  -- back_SetGround(LEVEL_P01P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- supervision_StationCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1)
  local npc_npc_soonansu = SkySceneKit.spawn_npc("wobbuffet", 232, 208, Direction.Up, "NPC_SOONANSU")
  do local p=npc_npc_soonansu.Position; GROUND:MoveToPosition(npc_npc_soonansu, p.X+(22), p.Y+(0), false, 1) end
  local npc_npc_soonano = SkySceneKit.spawn_npc("wynaut", 208, 224, Direction.Up, "NPC_SOONANO")
  -- SetAnimation(4) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  do local p=npc_npc_soonansu.Position; GROUND:MoveToPosition(npc_npc_soonansu, p.X+(-22), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_soonansu.Position; GROUND:MoveToPosition(npc_npc_soonansu, p.X+(22), p.Y+(0), false, 1) end -- waypoint MovePositionOffset
  do local p=npc_npc_soonansu.Position; GROUND:MoveToPosition(npc_npc_soonansu, p.X+(-22), p.Y+(0), false, 1) end -- waypoint MovePositionOffset
  GROUND:MoveToPosition(hero, 204, 164, false, 2)
  GROUND:MoveToPosition(partner, 232, 164, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(4)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_soonano, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(npc_npc_soonansu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Oh! A customer, is it not?", french=" Oh! Un client? O.K.!", german=" Oh! Ein Kunde, isses nich so?", italian=" Oh! Un cliente, vero no?", spanish=" ¡Anda! Clientes, ¿no es así?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(216, 184, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_soonansu, 232, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_soonano, 204, 188, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Good day, is it not?", french=" Belle journée, non?", german=" Ein schöner Tag, isses nich so?", italian=" Bella giornata, vero no?", spanish=" Buenos días..."})
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="The new shop, [CS:K]Spinda[CR]'s Café, is\nnow open!", french="Le [CS:K]Café Spinda[CR],\nvotre nouveau magasin, est à présent ouvert!", german="Der neue Laden, [CS:K]Pandir-Café[CR],\nhat jetzt geöffnet!", italian="Il nuovo locale Caffè di [CS:K]Spinda[CR]\nè ufficialmente aperto!", spanish="¡Queda inaugurada la nueva\ntienda, la [CS:K]Cafetería Spinda[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="This wonderful shop is\noverflowing with hopes and dreams,\nis it not?", french="Ce merveilleux magasin vous\npropose de réaliser tous vos rêves.", german="Dieser schöne Laden quillt\nüber vor Hoffnungen und Träumen,\nisses nich so?", italian="Questo posto meraviglioso\ntrabocca di sogni e di speranze, vero no?", spanish="Esta maravillosa tienda\nes un lugar de ensueño, ¿no es así?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hopes and dreams?", french=" Tous nos rêves?", german=" Hoffen und träumen?", italian=" Sogni e speranze?", spanish=" ¿De ensueño?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hopes and dreams?", french=" Tous nos rêves?", german=" Hoffen und träumen?", italian=" Sogni e speranze?", spanish=" ¿De ensueño?"})
  else
  SkySceneKit.say({english=" Hopes and dreams?", french=" Tous nos rêves?", german=" Hoffen und träumen?", italian=" Sogni e speranze?", spanish=" ¿De ensueño?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_soonansu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_soonansu) end)
  SkySceneKit.say({english=" That's right!", french=" Banco!", german=" Ja, genau!", italian=" Esatto!", spanish=" ¡Eso, eso!"})
  GROUND:EntTurn(npc_npc_soonano, Direction.Right)
  GAME:WaitFrames(3)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  pcall(function() GAME:MoveCamera(216, 228, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_soonano, 232, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_soonano, Direction.Left)
  GROUND:EntTurn(npc_npc_soonansu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="Hey! Why not come on in?\nDon't be shy!", french="Hé! Entrez donc, entrez donc!\nNe soyez pas timides!", german="He! Warum kommt ihr nicht\nrein? Nicht so schüchtern!", italian="Ehi! Perché voi non entrate?\nNon siate timidi!", spanish="¡Eh! ¿Por qué no entráis?\n¡Dejad la timidez a un lado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't know what this place is.\nWant to find out?", french="Je me demande de quel genre\nd'endroit il s'agit. On va jeter un œil?", german="Ich kenne diesen Ort noch nicht.\nWollen wir nicht mal reinschauen?", italian="Non ho idea di cosa sia questo\nposto. Che ne dici di dare un'occhiata?", spanish="No tengo ni idea de qué es este\nsitio... ¿Lo averiguamos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I don't really know about this.\nWant to find out?", french="Je me demande de quel genre\nd'endroit il s'agit. On va jeter un œil?", german="Ich kann mir darunter nichts\nvorstellen. Warum schauen wir nicht einfach\nmal rein?", italian="Che strano posto. Perché non\ndiamo un'occhiata?", spanish="No sé qué es esto.\n¿Quieres que lo averigüemos?"})
  else
  SkySceneKit.say({english="I'm not sure what this is... Want\nto find out?", french="Je me demande de quel genre\nd'endroit il s'agit. On va jeter un œil?", german="Ich bin mir nicht sicher, was\ndas bedeuten soll... Lass es uns herausfinden!", italian="Non ho mai visto un posto così...\nperché non ci diamo un'occhiata?", spanish="No tengo claro qué es esto...\n¿Quieres que lo descubramos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_soonano, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" We have two guests!", french=" Nous avons deux clients, O.K.!", german=" Wir haben zwei Gäste!", italian=" Abbiamo due clienti!", spanish=" ¡Tenemos dos clientes!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_soonano, nil, 0) end) -- EFFECT_NONE
  GROUND:MoveToPosition(hero, 204, 228, false, 2)
  GAME:WaitFrames(35)
  GROUND:MoveToPosition(partner, 204, 228, false, 2)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_soonano, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_soonansu, Direction.DownLeft)
  GROUND:MoveToPosition(hero, 144, 236, false, 2)
  GROUND:MoveToPosition(partner, 144, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_soonano, 144, 236, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_soonansu, 232, 204, false, 2)
  GAME:WaitFrames(20)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
