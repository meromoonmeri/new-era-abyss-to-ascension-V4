-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P18P01A/n02a0304.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_STORM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P18P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false,  0)
  GAME:FadeIn(0)
  -- GAP: SetEffect EFFECT_VERY_HEAVY_RAIN — VFX sans émote PMDO équivalente
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(60)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(3)
  GAME:WaitFrames(30)
  local npc_npc_pukurin_papa = SkySceneKit.spawn_npc("wigglytuff", 512, 184, Direction.Left, "NPC_PUKURIN_PAPA")
  GROUND:MoveToPosition(npc_npc_pukurin_papa, 332, 180, false, 2)
  GROUND:MoveToPosition(hero, 384, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(3)
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetPositionMark OBJECT_P18P01A2_382 [cible sans placement SSA zone: placement non joué]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(9) [anim idle native]
  -- GAP: se_Play(9489) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P18P01A2_382) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P18P01A1_381) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin_papa, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" S-so...[K]scary...", french=" J-j'ai...[K] peur...", german=" I-ich habe...[K] Angst...", italian=" C-Che...[K] paura...", spanish=" Ay...[K] Tengo mieditooo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_pukurin_papa.Position; GROUND:MoveToPosition(npc_npc_pukurin_papa, p.X+(24), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" Are you all right?! [CS:Y]Igglybuff[CR]?", french=" Tout va bien, [CS:Y]Toudoudou[CR]?", german="Ist alles in Ordnung?!?\n[CS:Y]Fluffeluff[CR]?", italian=" Tutto bene?! [CS:Y]Igglybuff[CR]?", spanish=" ¿Estás bien, [CS:Y]Igglybuff[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Y-yeah...", french=" V-voui...", german=" J-ja...", italian=" S-Sì...", spanish=" Sí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(20)
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: se_Play(9489) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P18P01A1_381) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P18P01A2_382) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="Can you feel that? The storm is\ncausing the ground to shake!", french="Tu as senti? L'orage a fait\ntrembler le sol!", german="Spürst du das? Der Sturm\nbringt den Boden zum Schwanken!", italian="Hai sentito? La terra ha\ncominciato a tremare a causa\ndella tempesta!", spanish="¡El suelo tiembla por la tormenta!\n¿Lo notas?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="We need to get off this\nmountain quickly...", french="Il faut descendre de cette\nmontagne, et vite...", german="Wir müssen schnell von diesem\nBerg hinunter...", italian="Dobbiamo sbrigarci e scendere\na valle...", spanish="Tenemos que salir de esta montaña\ncuanto antes..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin_papa, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="It's too dangerous to be here.[K]\nLet's hurry.", french="C'est trop dangereux de\nrester ici.[K] Dépêchons-nous.", german="Es ist zu gefährlich,\nhierzubleiben.[K] Beeilung!", italian="È troppo pericoloso restare qui.[K]\nForza.", spanish="Esto es demasiado peligroso.[K]\nSerá mejor que nos demos prisa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yeah...", french=" Voui...", german=" Ja...", italian=" Sì...", spanish=" Sí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(276, 172, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_pukurin_papa, 260, 180, false, 1)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 296, 180, false, 1)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetPositionMark OBJECT_P18P01A2_382 [cible sans placement SSA zone: placement non joué]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetPositionMark OBJECT_P18P01A1_381 [cible sans placement SSA zone: placement non joué]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, "shock", 1) end)
  GAME:WaitFrames(30)
  -- GAP: se_Play(9489) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P18P01A2_382) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P18P01A1_381) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Waaaaaaaahhh!!", french=" Ouuuuaaaaaaaahhh!!", german=" Waaaaaaaah!!!", italian=" Uaaaaaaaaah!!!", spanish=" ¡Aaaaaah!"})
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin_papa, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_pukurin_papa.Position; GROUND:MoveToPosition(npc_npc_pukurin_papa, p.X+(8), p.Y+(0), false, 2) end
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" [CS:Y]I[CR]...[CS:Y]Igglybuff[CR]!", french=" [CS:Y]Tou[CR]... [CS:Y]Toudoudou[CR]!", german=" [CS:Y]F-Fluffeluff[CR]!", italian=" [CS:Y]I[CR]... [CS:Y]Igglybuff[CR]!", spanish=" [CS:Y]I[CR]... ¡[CS:Y]Igglybuff[CR]!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P18P01A4_384) [routine d'objet NDS non simulée - documenté]
  -- back_SetBackEffect(4) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  pcall(function() SOUND:FadeOutBGM(5) end)
  -- PauseEffect(EFFECT_VERY_HEAVY_RAIN) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="[CN]And right then!", french="[CN]C'est alors que...", german="[CN]Und genau in diesem Augenblick...", italian="[CN]E proprio in quel momento...", spanish="[CN]Y justo entonces..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="[CN]This huge boulder started to fall,\n[CN]right above me!", french="[CN]... ce gros rocher a commencé à tomber,\n[CN]juste au-dessus de ma tête!", german="[CN]Da löste sich dieser riesige\n[CN]Felsbrocken direkt über mir!", italian="[CN]... ho visto un enorme masso\n[CN]che rotolava sopra di me!", spanish="[CN]¡Vi caer un pedrusco enorme,\n[CN]que se acercaba a mí a toda velocidad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back_SetBackEffect(5) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- GAP: BGM BGM_STORM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- ResumeEffect(EFFECT_VERY_HEAVY_RAIN) [neutre/état moteur]
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(9490) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(2) [anim idle native]
  -- message_SetWaitMode(45, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" W-waaaaaaaahhhhhhh!!", french=" Ou-ouaaaaaaaahhhhhhh!!", german=" W-waaaaaaaah!!!", italian=" U-Uaaaaaaaaaaaah!!!", spanish=" ¡Ah... Aaaaaaah!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]P[CR]...[CS:N]Papa[CR]!!", french=" [CS:N]Pa[CR]... [CS:N]Papa[CR]!!", german=" [CS:N]P-papa[CR]!!!", italian=" [CS:N]P[CR]... [CS:N]Papà[CR]!!!", spanish=" [CS:N]Pa[CR]... ¡¡[CS:N]papá[CR]!!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  -- supervision_Acting(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P18P01A3_383) [routine d'objet NDS non simulée - documenté]
  -- back_SetBackEffect(4) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  pcall(function() SOUND:FadeOutBGM(5) end)
  -- PauseEffect(EFFECT_VERY_HEAVY_RAIN) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN](It's no good!)[K] (I'm going to be crushed!)", french="[CN](Horreur![K] Je vais me faire ratatiner!)", german="[CN](Gar nicht gut!)[K] (Der wird mich zermalmen!)", italian="[CN](Oh no!)[K] (Verrò schiacciato!)", spanish="[CN]¡No había nada que hacer![K]\n[CN]¡Me iba a aplastar!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]...And just when I thought that!", french="[CN]... Et à peine avais-je pensé cela...", german="[CN]...Und gerade als ich das dachte...", italian="[CN]... E proprio mentre pensavo a questa cosa...", spanish="[CN]Y justo cuando pensaba que mi suerte\n[CN]estaba echada..."})
  -- message_Close
  -- back_SetBackEffect(5) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- GAP: BGM BGM_STORM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- ResumeEffect(EFFECT_VERY_HEAVY_RAIN) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" YOOM...TAH!!", french=" TA-DAAAA!!", german=" LUUUU... FIIII!", italian=" BADABUM!!!", spanish=" ¡Ah... Aaaaaah!"})
  -- SetAnimation(17) [anim idle native]
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  pcall(function() SOUND:FadeOutBGM(160) end)
  -- GAP: se_Play(7435) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(5) [neutre/état moteur]
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 15) -- screen_WhiteOutAll
  -- supervision_RemoveActing(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(90)
  -- GAP: se_Play(9473) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: BGM BGM_STORM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(60)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(60)
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Somehow the boulder was smashed to pieces...", french="[CN]... que le rocher a soudain volé en éclats...", german="[CN]Da wurde der Felsbrocken irgendwie\n[CN]in Stücke zerschmettert...", italian="[CN]Non so come, ma il masso si\n[CN]è frantumato in mille pezzi...", spanish="[CN]El pedrusco se hizo mil pedazos..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]I wasn't crushed by the boulder...[K]\n[CN]Somehow I was saved...", french="[CN]Je n'ai pas été ratatiné par le rocher...[K]\n[CN]J'ai été sauvé...", german="[CN]Ich wurde nicht vom Felsbrocken zermalmt,[K]\n[CN]sondern auf wundersame Weise gerettet...", italian="[CN]E io non sono rimasto schiacciato...[K]\n[CN]In qualche modo ero riuscito a salvarmi...", spanish="[CN]El pedrusco no me aplastó...[K]\n[CN]Me salvé, sin saber bien cómo..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false,  60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- SetEffect EFFECT_NONE vers ACTOR_3 [acteur sans placement SSA zone (spawn superviseur NDS): émote non jouée]
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
