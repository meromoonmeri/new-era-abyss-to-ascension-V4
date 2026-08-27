-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/s30a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SUB30_SPOT_DISCOVER = SV.SkyVars.SUB30_SPOT_DISCOVER or {}; SV.SkyVars.SUB30_SPOT_DISCOVER[0] = 0 -- $SUB30_SPOT_DISCOVER[0] = 0 (ROM)
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_soonansu = SkySceneKit.spawn_npc("wobbuffet", 456, 152, Direction.Down, "NPC_SOONANSU")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_soonano = SkySceneKit.spawn_npc("wynaut", 432, 152, Direction.Down, "NPC_SOONANO")
  pcall(function() GROUND:CharSetEmote(npc_npc_soonano, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="Did you hear the happy news,\nwhy not?", french=" Excellente nouvelle, O.K.!", german=" Frohe Neuigkeiten, so isses!", italian=" È una bella notizia, vero no?", spanish=" Son buenas noticias, ¿no es así?"})
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_soonano, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="Thanks to everyone's recycling\nefforts, Project P recently made a\nnew discovery!", french="Grâce à votre soutien pour\nnotre projet d'échanges, le Projet P\nvient de permettre une nouvelle découverte!", german="Weil alle so fleißig\nwiederverwertet haben, hat Projekt P\nkürzlich eine neue Entdeckung gemacht!", italian="Grazie agli sforzi di tutti,\nil Progetto P ha appena fatto una nuova\nscoperta!", spanish="¡Gracias al esfuerzo de todos, el\nProyecto P ha hecho un gran descubrimiento!"})
  -- message_Close
  -- GAP: se_Play(7944) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(60)
  -- SetEffect EFFECT_NONE vers ACTOR_4 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- SetEffect EFFECT_NONE vers ACTOR_5 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- SetEffect EFFECT_NONE vers ACTOR_6 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- SetEffect EFFECT_NONE vers ACTOR_7 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  -- se_FadeOut(7944, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="This time, a new unexplored\narea was discovered!", french="Cette fois-ci, c'est une région\ninexplorée qui vient d'être découverte, donc...", german="Dieses Mal wurde ein\nunerkundeter Ort entdeckt!", italian="Questa volta è stata trovata\nuna nuova area inesplorata!", spanish="Esta vez se ha descubierto\nuna zona inexplorada."})
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" I'll mark it on your map for you!", french="... je vais la reporter\nsur votre carte!", german="Ich werde ihn auf\neurer Karte markieren!", italian=" Ve la segnerò sulla mappa!", spanish=" Deja que te la señale en el mapa."})
  -- message_Close
  GAME:FadeOut(false, 15)
  do local __sw = ((SV.SkyVars or {}).SUB30_SPOT_LEVEL or 0) -- switch($SUB30_SPOT_LEVEL) [GameVar SUB30_SPOT_LEVEL (SV.SkyVars)]
  if __sw == 2 then
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(91) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(91) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(91) [neutre/état moteur]
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  -- message_Close
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN]the [CS:P]Tiny Meadow[CR]!", french="[CN]Désormais, vous pouvez accéder\n[CN]au [CS:P]Petit Pré[CR]!", german="[CN]Du kannst nun zur\n[CN][CS:P]Kleinen Weide[CR] gelangen!", italian="[CN]Ora potete andare\n[CN]al [CS:P]Praticello[CR]!", spanish="[CN]¡Ahora ya puedes ir al\n[CN][CS:P]Prado Chico[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[90] = 3 -- dungeon_mode(90) = DMODE_OPEN_AND_REQUEST (ROM)
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(93) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(93) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(93) [neutre/état moteur]
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  -- message_Close
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN][CS:P]Oran Forest[CR]!", french="[CN]Désormais, vous pouvez accéder\n[CN]à la [CS:P]Forêt Oran[CR]!", german="[CN]Du kannst nun zum\n[CN][CS:P]Sinelwald[CR] gelangen!", italian="[CN]Ora potete andare\n[CN]alla [CS:P]Foresta d'Aranci[CR]!", spanish="[CN]¡Ahora ya puedes ir al\n[CN][CS:P]Aranjal[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[92] = 3 -- dungeon_mode(92) = DMODE_OPEN_AND_REQUEST (ROM)
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(94) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(94) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(94) [neutre/état moteur]
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  -- message_Close
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN][CS:P]Lake Afar[CR]!", french="[CN]Désormais, vous pouvez accéder\n[CN]au [CS:P]Lac Lointain[CR]!", german="[CN]Du kannst nun zum\n[CN][CS:P]Fernen See[CR] gelangen!", italian="[CN]Ora potete andare\n[CN]al [CS:P]Lago Lontano[CR]!", spanish="[CN]¡Ahora ya puedes ir al\n[CN][CS:P]Lago Recóndito[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[93] = 3 -- dungeon_mode(93) = DMODE_OPEN_AND_REQUEST (ROM)
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(104) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(104) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(104) [neutre/état moteur]
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  -- message_Close
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN][CS:P]Zero Isle Center[CR]!", french="[CN]Désormais, vous pouvez accéder\n[CN]à l'[CS:P]Ile Zéro Centre[CR]!", german="[CN]Du kannst nun zum\n[CN][CS:P]Null-Insel-Zentrum[CR] gelangen!", italian="[CN]Ora potete andare\n[CN]all'[CS:P]Isola Zero Centro[CR]!", spanish="[CN]¡Ahora ya puedes ir al\n[CN][CS:P]Corazón de la Isla Cero[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[103] = 3 -- dungeon_mode(103) = DMODE_OPEN_AND_REQUEST (ROM)
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_0 [étiquette de flux ExplorerScript]
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(89) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(89) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(89) [neutre/état moteur]
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  -- message_Close
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN][CS:P]Landslide Cave[CR]!", french="[CN]Désormais, vous pouvez accéder\n[CN]à la [CS:P]Grotte Eboulement[CR]!", german="[CN]Du kannst nun zur\n[CN][CS:P]Erdrutschhöhle[CR] gelangen!", italian="[CN]Ora potete andare\n[CN]alla [CS:P]Grotta Slavina[CR]!", spanish="[CN]¡Ahora ya puedes ir a la\n[CN][CS:P]Cueva Alud[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[88] = 3 -- dungeon_mode(88) = DMODE_OPEN_AND_REQUEST (ROM)
  -- @label_5 [étiquette de flux ExplorerScript]
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:FadeIn(15)
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english=" Please keep recycling!", french="Continuez à échanger,\ns'il vous plaît!", german=" Bitte macht weiter fleißig mit!", italian=" Continuate a riciclare!", spanish=" ¡Sigue reciclando!"})
  -- message_Close
  end
  end
  SkySceneKit.cleanup_npcs()
end
