-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D65P41A/s12a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(80, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  do local __sw = (math.random(0, 99)) -- switch(random(100)) [random(100): tirage ROM -> math.random]
  if __sw < 50 then
  -- @label_0 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_EVENT_LOCAL = 0 -- $DUNGEON_EVENT_LOCAL = 0 (ROM)
  -- @label_1 [étiquette de flux ExplorerScript]
  -- back_SetGround(LEVEL_D65P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 300, 244, false, 2)
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 324, 260, false, 2) end end
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 276, 260, false, 2) end end
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 300, 276, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(50)
  -- GAP: se_Play(5125) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(60)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Up)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_hiidoran = SkySceneKit.spawn_npc("heatran", 304, 208, Direction.Down, "NPC_HIIDORAN")
  pcall(function() UI:SetSpeaker(npc_npc_hiidoran) end)
  SkySceneKit.say({english=" Seekers of the seven treasures!", french=" Chercheurs des sept trésors!", german=" Suchende der sieben Schätze!", italian=" Tu che cerchi i sette tesori!", spanish=" ¡Buscadores de los siete tesoros!"})
  pcall(function() UI:SetSpeaker(npc_npc_hiidoran) end)
  SkySceneKit.say({english="I am [CS:N]Heatran[CR]![K] The guardian of\nthe [CS:P]Giant Volcano[CR]!", french="Je suis [CS:N]Heatran[CR]![K] Le gardien\ndu [CS:P]Volcan Géant[CR]!", german="Ich bin [CS:N]Heatran[CR],[K] Wächter\ndes [CS:P]Riesenvulkans[CR]!", italian="Io sono [CS:N]Heatran[CR],[K] il guardiano\ndel [CS:P]Vulcano Gigante[CR]!", spanish="¡Soy [CS:N]Heatran[CR]![K] ¡El guardián del\n[CS:P]Volcán Gigante[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_hiidoran) end)
  SkySceneKit.say({english="If it is the treasure that\nyou seek...", french="Si c'est le trésor que vous\ncherchez...", german="Wenn ihr nach dem Schatz\nsucht...", italian=" Se vuoi il tesoro...", spanish="Si es el tesoro lo que andáis\nbuscando..."})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_hiidoran) end)
  SkySceneKit.say({english=" Withstand the scorching fire...", french=" Bravez le feu ardent...", german=" Trotzt dem lodernden Feuer...", italian="... devi affrontare\nle fiamme roventi.", spanish=" Resiste el fuego abrasador..."})
  pcall(function() UI:SetSpeaker(npc_npc_hiidoran) end)
  SkySceneKit.say({english="I challenge you to surpass\nyour limits...", french="Je vous engage à dépasser vos\nlimites... Je vous mets au défi!", german="Ich fordere euch heraus,\nüber euch hinauszuwachsen...", italian="Ti sfido a superare\ni tuoi limiti...", spanish="Os reto a superar vuestros\nlímites..."})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_hiidoran) end)
  SkySceneKit.say({english=" Demonstrate your power to me!", french=" Montrez-moi votre puissance!", german=" Zeigt mir eure Kraft!", italian=" Mostrami la tua forza!", spanish="¡Y a demostrarme vuestro\npoder!"})
  pcall(function() UI:SetSpeaker(npc_npc_hiidoran) end)
  SkySceneKit.say({english=" Now it begins!", french=" Que le combat commence!", german=" Jetzt geht es los!", italian=" Che lo scontro abbia inizio!", spanish=" ¡Adelante!"})
  -- message_Close
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  elseif true then -- default
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.DUNGEON_EVENT_LOCAL = 1 -- $DUNGEON_EVENT_LOCAL = 1 (ROM)
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
