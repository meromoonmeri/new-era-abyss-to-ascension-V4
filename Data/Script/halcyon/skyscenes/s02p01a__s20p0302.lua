-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S02P01A/s20p0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_S02P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_WELCOME_TO_THE_WORLD_OF_POKEMON non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(60)
  GAME:WaitFrames(60)
  SkySceneKit.say({english="Oh...[K] That's...", french="Oh...[K] C'est...", german="Oh...[K] Das ist...", italian="Oh...[K] Quella è...", spanish="Oh...[K] Esa..."}) -- SwitchMonologue: branche default
  GAME:WaitFrames(60)
  -- GAP: se_Play(6922) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 184, 104, Direction.Down, "NPC_KURESERIA")
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(80)
  SkySceneKit.say({english="What did you mean by that?", french="Qu'est-ce que ça veut dire?", german="Was meintest du damit?", italian="Cosa intendevi?", spanish="¿Qué querías decir con eso?"}) -- SwitchMonologue: branche default
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="You are a human who came from\nthe future.", french="Tu es un être humain qui vient\ndu futur.", german="Du bist ein Mensch, der aus der\nZukunft kam.", italian="Sei un essere umano che è\nvenuto dal futuro.", spanish="Eres un humano que vino del\nfuturo."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" You are not of this world.", french=" Tu n'appartiens pas à ce monde.", german=" Du bist nicht von dieser Welt.", italian=" Non fai parte di questo mondo.", spanish=" No eres de este mundo."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="That is creating the distortion\nin the fabric of space.", french="C'est ce qui crée la distorsion\ndans la trame de l'espace.", german="Das verursacht die Verzerrung\ndes Raumgefüges.", italian="Questo sta causando la\ndistorsione della struttura dello spazio.", spanish="Y eso está deformando el\nespacio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="Distortion...[K]in the fabric of space?!", french="Une distorsion...[K] dans la trame de l'espace?!", german="Verzerrung...[K] des Raumgefüges?!?", italian="Distorsione...[K] della struttura dello spazio?!", spanish="Deformando...[K] ¡¿el espacio?!"}) -- SwitchMonologue: branche default
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="And if this distortion of space\nwere to expand...", french="Et si cette distorsion venait à\ns'étendre...", german="Und falls sich die Verzerrung\ndes Raumes weiter ausdehnt...", italian="E se questa distorsione\nsi espandesse...", spanish="Si la deformación sigue\naumentando..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" This world would be ruined.", french="... ce monde serait complètement\ndévasté.", german=" Dann wäre diese Welt am Ende.", italian="... questo mondo\nsarebbe spacciato.", spanish="Este mundo acabará por\ndestruirse."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="The distortion of space...[K]w-will ruin the\nworld...", french="La distorsion de l'espace...[K] dévasterait le\nmonde...", german="Die Verzerrung des Raumes...[K] w-wird die Welt\nzerstören...", italian="La distorsione dello spazio...[K] d-distruggerà\nil mondo...", spanish="¿Cómo?[K] ¿La deformación del espacio\npodría acabar con este mundo?"}) -- SwitchMonologue: branche default
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" You are...", french=" Ta présence...", german=" Du bist...", italian=" Tu sei...", spanish=" Tu presencia..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="a presence that must not exist\nin this world!", french=" ... en ce monde est une anomalie!", german="Du bist eine Existenz, die es\nin dieser Welt nicht geben darf!", italian="... una presenza che non deve\nesistere in questo mondo!", spanish="Tu presencia aquí es un riesgo.\n¡No tienes lugar en este mundo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(43) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" You must...[K]not...[K]be here...", french=" Tu ne dois...[K] pas...[K] être ici...", german=" Du darfst...[K] nicht...[K] hier sein...", italian=" Tu non...[K] devi...[K] essere qui...", spanish=" No deberías...[K] estar...[K] aquí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="Please, tell me more!", french="S'il te plaît, dis-m'en plus!", german="Bitte, erzähl mir mehr!", italian="Ti prego, dimmi di più!", spanish="¡Necesito saber más!"}) -- SwitchMonologue: branche default
  -- GAP: se_Play(6922) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(90)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(90)
  SkySceneKit.say({english="..................", french="..................", german="..................", italian="..................", spanish="... ..."}) -- SwitchMonologue: branche default
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(false,  90)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(90)
  SkySceneKit.cleanup_npcs()
end
