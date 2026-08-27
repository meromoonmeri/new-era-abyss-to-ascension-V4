-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V38P10A/n09a2209.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_A_NEW_WORLD non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V38P09A) [décor sub chargé: Sub_v38p09a]
  -- back_SetGround(LEVEL_V38P10A) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 39.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetOutputAttribute(1) [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(480), g.ViewCenter.Y+(300), 120, false) end) -- back_SetBackScrollSpeed(4.0,2.5) px/frame -> caméra continue (pilote scroll)
  SkySubScreen.Show("v38p09a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(60)
  GAME:WaitFrames(60)
  -- message_SetWaitMode(180, 90) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Celebi", true, "celebi", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SEREBII (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Th-this is...?", french=" Qu'est-ce que...?", german=" D-das ist...", italian=" Q-Questa è...?", spanish=" ¿Esto es...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_SetWaitMode(210, 90) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Master [CS:N]Dialga[CR]'s...[K]telepathy?", french="Maître [CS:N]Dialga[CR]...[K] use\nde la télépathie?", german="Sind das die telepathischen\nKräfte[K] von Meister [CS:N]Dialga[CR]?", italian="La telepatia...[K] del Maestro\n[CS:N]Dialga[CR]?", spanish=" ¿La telepatía de [CS:N]Dialga[CR]?"})
  -- message_Close
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  GAME:WaitFrames(8)
  -- GAP: se_Play(11538) — id SE NDS sans portage PMDO identifié
  -- SetupOutputAttributeAndAnimation<object OBJECT_V38P10B1_525> [prop décor NDS, rendu du ground]
  -- SetupOutputAttributeAndAnimation<object OBJECT_V38P10B2_526> [prop décor NDS, rendu du ground]
  -- SetupOutputAttributeAndAnimation<object OBJECT_V38P10B3_527> [prop décor NDS, rendu du ground]
  -- SetupOutputAttributeAndAnimation<object OBJECT_V38P10B4_528> [prop décor NDS, rendu du ground]
  -- SetupOutputAttributeAndAnimation<object OBJECT_V38P10B5_529> [prop décor NDS, rendu du ground]
  -- SetupOutputAttributeAndAnimation<object OBJECT_V38P10B6_530> [prop décor NDS, rendu du ground]
  -- SlidePositionOffset<object OBJECT_V38P10B1_525> [prop décor NDS, géré par le rendu du ground]
  -- SlidePositionOffset<object OBJECT_V38P10B2_526> [prop décor NDS, géré par le rendu du ground]
  -- SlidePositionOffset<object OBJECT_V38P10B3_527> [prop décor NDS, géré par le rendu du ground]
  -- SlidePositionOffset<object OBJECT_V38P10B4_528> [prop décor NDS, géré par le rendu du ground]
  -- SlidePositionOffset<object OBJECT_V38P10B5_529> [prop décor NDS, géré par le rendu du ground]
  -- SlidePositionOffset<object OBJECT_V38P10B6_530> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(60)
  GAME:WaitFrames(23)
  SkySubScreen.Hide(30) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- back_SetBackScrollSpeed(0,0): arrêt du défilement
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
