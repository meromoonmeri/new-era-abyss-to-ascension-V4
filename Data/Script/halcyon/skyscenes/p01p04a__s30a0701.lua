-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/s30a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- supervision_Acting(0) [neutre/état moteur]
  -- switch(message_Menu(MENU_JUICE_BAR)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_35 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_JUICE_BAR_PICK_ITEM"] or 0) -- switch(message_Menu(MENU_JUICE_BAR_PICK_ITEM)) [message_Menu(MENU_JUICE_BAR_PICK_ITEM): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 1 then
  -- @switch1_472 [étiquette de flux ExplorerScript]
  -- @label_34 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 2 then
  -- @label_1 [étiquette de flux ExplorerScript]
  local npc_npc_patchiiru = SkySceneKit.spawn_npc("spinda", 256, 152, Direction.Down, "NPC_PATCHIIRU")
  GROUND:EntTurn(npc_npc_patchiiru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" Added the [s_item:0]...", french="On ajoute l'ingrédient\n[s_item:0]...", german="[s_item:0] in den\nSaft-Shaker getan...", italian="Aggiunto lo strumento\n[s_item:0]...", spanish=" ¡Se ha añadido [s_item:0]!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  local npc_npc_soonansu = SkySceneKit.spawn_npc("wobbuffet", 456, 152, Direction.Down, "NPC_SOONANSU")
  pcall(function() UI:SetSpeaker(npc_npc_soonansu) end)
  SkySceneKit.say({english=" That's right!", french=" Banco!", german=" Ganz genau!", italian=" Giusto!", spanish=" ¡Eso, eso!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_patchiiru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(20)
  -- GAP: se_Play(11267) — id SE NDS sans portage PMDO identifié
  -- message_SetWaitMode(51, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" Shake it this way...", french=" On secoue, on secoue...", german=" In diese Richtung schütteln...", italian=" Scuoti di qua...", spanish=" Se agita por aquí..."})
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" Shake it that way...", french=" On agite, on agite...", german=" In jene Richtung schütteln...", italian=" Scuoti di là...", spanish=" Se agita por allá..."})
  -- message_KeyWait
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(11023) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(25) [anim idle native]
  -- message_SetWaitMode(30, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" And stir it all around...", french=" On remue le tout...", german=" Ordentlich verquirlen...", italian=" Una bella mescolata...", spanish=" Se remueve bien..."})
  -- message_KeyWait
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(26) [anim idle native]
  -- message_SetWaitMode(40, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" And it's done!", french=" Et c'est prêt!", german=" Und schon ist der Drink fertig!", italian=" ... ed è pronto!", spanish=" ¡Y ya está!"})
  -- message_Close
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  GAME:FadeOut(false, 30)
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:TeleportTo(hero, 264, 180, Direction.Down)
  GROUND:TeleportTo(partner, 240, 180, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_patchiiru, Direction.Down)
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GAME:MoveCamera(264, 180, 1, false) end)
  GAME:WaitFrames(15)
  GAME:FadeIn(30)
  GAME:WaitFrames(10)
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 6 then
  -- jump @switch1_472 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 7 then
  -- @switch1_473 [étiquette de flux ExplorerScript]
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 10 then
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  GAME:FadeOut(false, 30)
  -- supervision_Acting(1) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(264, 180, 1, false) end)
  GROUND:TeleportTo(hero, 284, 180, Direction.Down)
  GROUND:TeleportTo(partner, 220, 180, Direction.Down)
  -- SetPositionMark ACTOR_EVENT_NPC_MAIN [cible sans placement SSA zone: placement non joué]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_patchiiru, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  -- SetDirection ACTOR_EVENT_NPC_MAIN [acteur sans placement SSA zone: orientation non jouée]
  GAME:WaitFrames(15)
  GAME:FadeIn(30)
  GAME:WaitFrames(10)
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 14 then
  GAME:FadeOut(false, 30)
  GROUND:TeleportTo(hero, 264, 180, Direction.Down)
  GROUND:TeleportTo(partner, 240, 180, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  -- supervision_RemoveCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  GAME:FadeIn(30)
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 15 then
  GROUND:MoveToPosition(hero, 264, 180, false, 2)
  GAME:WaitFrames(4)
  GROUND:MoveToPosition(partner, 240, 180, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(4)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_patchiiru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 16 then
  GROUND:MoveToPosition(hero, 264, 180, false, 2)
  GAME:WaitFrames(4)
  GROUND:MoveToPosition(partner, 240, 180, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_patchiiru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(10)
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 17 or __sw == 18 or __sw == 19 then
  -- jump @switch1_473 [saut final vers l'épilogue de switch: flux naturel]
  elseif __sw == 20 then
  GAME:FadeOut(false, 15)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(88) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(88) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(88) [neutre/état moteur]
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN][CS:P]Serenity River[CR]!", french="[CN]Désormais, vous pouvez accéder\n[CN]à la [CS:P]Rivière Sérénité[CR]!", german="[CN]Du kannst nun zum\n[CN][CS:P]Fluss der Klarheit[CR] gelangen!", italian="[CN]Ora potete andare\n[CN]al [CS:P]Fiume Serenità[CR]!", spanish="[CN]¡Ahora ya puedes ir al\n[CN][CS:P]Río Sereno[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[87] = 3 -- dungeon_mode(87) = DMODE_OPEN_AND_REQUEST (ROM)
  -- @label_36 [étiquette de flux ExplorerScript]
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GROUND:TeleportTo(hero, 264, 180, Direction.Down)
  GROUND:TeleportTo(partner, 240, 180, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  -- supervision_RemoveCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveCommon(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:FadeIn(15)
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 22 then
  GAME:FadeOut(false, 15)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(90) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(90) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(90) [neutre/état moteur]
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN]the [CS:P]Lush Prairie[CR]!", french="[CN]Désormais, vous pouvez accéder\n[CN]à la [CS:P]Prairie Luxuriante[CR]!", german="[CN]Du kannst nun zur\n[CN][CS:P]Üppigen Steppe[CR] gelangen!", italian="[CN]Ora potete andare\n[CN]alle [CS:P]Piane Rigogliose[CR]!", spanish="[CN]¡Ahora ya puedes ir a la\n[CN][CS:P]Pradera Exuberante[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[89] = 3 -- dungeon_mode(89) = DMODE_OPEN_AND_REQUEST (ROM)
  -- jump @label_36 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 27 then
  GAME:FadeOut(false, 15)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(95) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(95) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(95) [neutre/état moteur]
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN][CS:P]Happy Outlook[CR]!", french="[CN]Désormais, vous pouvez accéder\n[CN]au [CS:P]Cap Enchanteur[CR]!", german="[CN]Du kannst nun zum\n[CN][CS:P]Frohen Ausguck[CR] gelangen!", italian="[CN]Ora potete andare\n[CN]al [CS:P]Promontorio Sereno[CR]!", spanish="[CN]¡Ahora ya puedes ir al\n[CN][CS:P]Mirador Alegría[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[94] = 3 -- dungeon_mode(94) = DMODE_OPEN_AND_REQUEST (ROM)
  -- jump @label_36 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 28 then
  GAME:FadeOut(false, 15)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(96) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(96) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(96) [neutre/état moteur]
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN][CS:P]Mt. Mistral[CR]!", french="[CN]Désormais, vous pouvez accéder\n[CN]au [CS:P]Mt Mistral[CR]!", german="[CN]Du kannst nun zum\n[CN][CS:P]Mistralberg[CR] gelangen!", italian="[CN]Ora potete andare\n[CN]al [CS:P]Monte Mistral[CR]!", spanish="[CN]¡Ahora ya puedes ir al\n[CN][CS:P]Monte Mistral[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[95] = 3 -- dungeon_mode(95) = DMODE_OPEN_AND_REQUEST (ROM)
  -- jump @label_36 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 30 then
  GAME:FadeOut(false, 15)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(98) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(98) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(98) [neutre/état moteur]
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN][CS:P]Lost Wilderness[CR]!", french="[CN]Désormais, vous pouvez accéder\n[CN]à la [CS:P]Contrée Inexplorée[CR]!", german="[CN]Du kannst nun zur\n[CN][CS:P]Verlorenen Wildnis[CR] gelangen!", italian="[CN]Ora potete andare\n[CN]alla [CS:P]Landa Perduta[CR]!", spanish="[CN]¡Ahora ya puedes ir a la\n[CN][CS:P]Espesura Perdida[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[97] = 3 -- dungeon_mode(97) = DMODE_OPEN_AND_REQUEST (ROM)
  -- jump @label_36 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 32 then
  GAME:FadeOut(false, 15)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(105) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(105) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(105) [neutre/état moteur]
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN][CS:P]Destiny Tower[CR]!", french="[CN]Désormais, vous pouvez accéder\n[CN]à la [CS:P]Tour du Destin[CR]!", german="[CN]Du kannst nun zum\n[CN][CS:P]Verhängnisturm[CR] gelangen!", italian="[CN]Ora potete andare\n[CN]alla [CS:P]Torre Destino[CR]!", spanish="[CN]¡Ahora ya puedes ir a la\n[CN][CS:P]Torre Destino[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[104] = 3 -- dungeon_mode(104) = DMODE_OPEN_AND_REQUEST (ROM)
  -- jump @label_36 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 40 then
  -- supervision_Acting(2) [neutre/état moteur]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(264, 180, 60, false) end) -- performer/caméra
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(4)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetEffect EFFECT_LAUGHING vers ACTOR_ACTOR_EVENT_NPC01 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(80)
  pcall(function() GAME:MoveCamera(264, 180, 60, false) end) -- performer/caméra
  GAME:WaitFrames(10)
  -- SetEffect EFFECT_NONE vers ACTOR_ACTOR_EVENT_NPC01 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(4)
  GROUND:EntTurn(partner, Direction.Up)
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 41 then
  -- supervision_Acting(2) [neutre/état moteur]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(264, 180, 60, false) end) -- performer/caméra
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(4)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  -- Turn2Direction ACTOR_EVENT_NPC_MAIN [acteur sans placement SSA zone: orientation non jouée]
  GAME:WaitFrames(4)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetEffect EFFECT_LAUGHING vers ACTOR_ACTOR_EVENT_NPC01 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(80)
  pcall(function() GAME:MoveCamera(264, 180, 60, false) end) -- performer/caméra
  GAME:WaitFrames(10)
  -- SetEffect EFFECT_NONE vers ACTOR_ACTOR_EVENT_NPC01 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(4)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(4)
  -- Turn2Direction ACTOR_EVENT_NPC_MAIN [acteur sans placement SSA zone: orientation non jouée]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 45 then
  -- supervision_Acting(3) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_patchiiru, Direction.DownRight)
  GAME:WaitFrames(4)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  pcall(function() GAME:MoveCamera(264, 180, 60, false) end) -- performer/caméra
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(4)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  -- MovePositionMark ACTOR_EVENT_NPC02 [cible sans placement SSA zone: mouvement non joué]
  pcall(function() GAME:MoveCamera(264, 180, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 46 then
  -- supervision_Acting(3) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_patchiiru, Direction.DownRight)
  GAME:WaitFrames(4)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  pcall(function() GAME:MoveCamera(264, 180, 60, false) end) -- performer/caméra
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(4)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  -- Turn2Direction ACTOR_EVENT_NPC_MAIN [acteur sans placement SSA zone: orientation non jouée]
  GAME:WaitFrames(4)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  -- MovePositionMark ACTOR_EVENT_NPC02 [cible sans placement SSA zone: mouvement non joué]
  pcall(function() GAME:MoveCamera(264, 180, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 50 then
  -- GAP: se_Play(531) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_STATS_UP_EFFECT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 51 then
  -- GAP: se_Play(534) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_STATS_DOWN_EFFECT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 60 then
  GROUND:EntTurn(npc_npc_patchiiru, Direction.Down)
  -- SetAnimation(1) [anim idle native]
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 61 then
  GAME:WaitFrames(22)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "exclaim", 1) end)
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 62 then
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "shock", 1) end)
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 63 then
  -- SetAnimation(26) [anim idle native]
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 64 then
  -- SetAnimation(2) [anim idle native]
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 65 then
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- SetEffect EFFECT_SHOCKED vers ACTOR_ACTOR_EVENT_NPC_MAIN [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 66 then
  GROUND:EntTurn(npc_npc_patchiiru, Direction.DownRight)
  -- SetAnimation(2) [anim idle native]
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 67 then
  GROUND:EntTurn(npc_npc_patchiiru, Direction.Down)
  -- SetAnimation(2) [anim idle native]
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 68 then
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  -- SetEffect EFFECT_EXCLAMATION_MARK vers ACTOR_ACTOR_EVENT_NPC_MAIN [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 69 then
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  -- SetEffect EFFECT_SHOCKED vers ACTOR_ACTOR_EVENT_NPC_MAIN [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_35 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_34 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
