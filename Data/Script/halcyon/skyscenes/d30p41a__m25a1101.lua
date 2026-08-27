-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D30P41A/m25a1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(43, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  SkyProg.set(26, 6) -- $SCENARIO_MAIN = scn[26,6] (ROM)
  -- back_SetGround(LEVEL_D30P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_HEAVY_FEELING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GROUND:MoveToPosition(partner, 260, 364, false, 2)
  GROUND:MoveToPosition(hero, 292, 364, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Is this...[K] Is this the top of\n[CS:P]Temporal Tower[CR]?", french="C'est...[K] c'est le sommet\nde la [CS:P]Tour du Temps[CR]?", german="Ist dies...[K] Ist dies die Spitze des\n[CS:P]Zeitturms[CR]?", italian="Questa è...[K] Questa è la cima\ndella [CS:P]Torre del Tempo[CR]?", spanish="¿Hemos llegado?[K] ¿Estamos en\nlo alto de la [CS:P]Torre del Tiempo[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Is this...[K] Is this the top of\n[CS:P]Temporal Tower[CR]?", french="C'est...[K] c'est le sommet\nde la [CS:P]Tour du Temps[CR]?", german="Ist dies...[K] Ist dies die Spitze des\n[CS:P]Zeitturms[CR]?", italian="Questa è...[K] Questa è la cima\ndella [CS:P]Torre del Tempo[CR]?", spanish="¿Hemos llegado?[K] ¿Estamos en\nlo alto de la [CS:P]Torre del Tiempo[CR]?"})
  else
  SkySceneKit.say({english="Is this...[K] Is this the top of\n[CS:P]Temporal Tower[CR]?", french="C'est...[K] c'est le sommet\nde la [CS:P]Tour du Temps[CR]?", german="Ist dies...[K] Ist dies die Spitze des\n[CS:P]Zeitturms[CR]?", italian="Questa è...[K] Questa è la cima\ndella [CS:P]Torre del Tempo[CR]?", spanish="¿Hemos llegado?[K] ¿Estamos en\nlo alto de la [CS:P]Torre del Tiempo[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7690) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(3)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! Lightning!", french=" Ouah! Un éclair!", german=" Aaah! Blitze!", italian=" Aaah! I fulmini!", spanish=" ¡Vaya! ¡Una tormenta!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! Lightning!", french=" Ouah! Un éclair!", german=" Waah! Blitze!", italian=" Aaah! I fulmini!", spanish=" ¡Vaya! ¡Una tormenta!"})
  else
  SkySceneKit.say({english=" Waah! Lightning!", french=" Ouah! Un éclair!", german=" Waah! Blitze!", italian=" Aaah! I fulmini!", spanish=" ¡Vaya! ¡Una tormenta!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitSe
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Look at the sky, [hero]!", french=" Regarde le ciel, [hero]!", german="Sieh dir den Himmel an,\n[hero]!", italian=" Guarda il cielo, [hero]!", spanish=" ¡Mira el cielo, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Look at the sky, [hero]!", french=" Regarde le ciel, [hero]!", german="Sieh dir den Himmel an,\n[hero]!", italian=" Guarda il cielo, [hero]!", spanish=" ¡Mira el cielo, [hero]!"})
  else
  SkySceneKit.say({english=" Look at the sky, [hero]!", french=" Regarde le ciel, [hero]!", german="Sieh dir den Himmel an,\n[hero]!", italian=" Guarda il cielo, [hero]!", spanish=" ¡Mira el cielo, [hero]!"})
  end
  -- message_Close
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V25P03A) [décor sub chargé: Sub_v25p03a]
  -- camera2_SetPositionMark(Position<'m2', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- GAP: se_Play(7691) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  SkySubScreen.Show("v25p03a", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's incredible![K] Red clouds are\nswirling!", french="Incroyable![K] Il y a un tourbillon\nde nuages rouges!", german="Das ist unglaublich![K] Da wirbeln\nrote Wolken durcheinander!", italian="È incredibile![K] Ci sono delle\nnuvole rosse che si muovono vorticosamente!", spanish="¡Es increíble![K] ¡Se están\narremolinando nubes rojas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's incredible![K] Red clouds are\nswirling!", french="Incroyable![K] Il y a un tourbillon\nde nuages rouges!", german="Das ist unglaublich![K] Da wirbeln\nrote Wolken durcheinander!", italian="È incredibile![K] Ci sono delle\nnuvole rosse che si muovono vorticosamente!", spanish="¡Es increíble![K] ¡Se están\narremolinando nubes rojas!"})
  else
  SkySceneKit.say({english="It's incredible![K] Red clouds are\nswirling!", french="Incroyable![K] Il y a un tourbillon\nde nuages rouges!", german="Das ist unglaublich![K] Da wirbeln\nrote Wolken durcheinander!", italian="È incredibile![K] Ci sono delle\nnuvole rosse che si muovono vorticosamente!", spanish="¡Es increíble![K] ¡Se están\narremolinando nubes rojas!"})
  end
  -- message_Close
  -- se_FadeOut(7691, 45) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  -- GAP: se_Play(7692) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! It happened again!", french=" Ouah! Ça recommence!", german=" Es ist schon wieder passiert!", italian=" Wow! È successo di nuovo!", spanish=" ¡Aaah! ¡Ha vuelto a ocurrir!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! It happened again!", french=" Ouah! Ça recommence!", german=" Es ist schon wieder passiert!", italian=" Aaah! È successo di nuovo!", spanish=" ¡Aaah! ¡Ha vuelto a ocurrir!"})
  else
  SkySceneKit.say({english=" Waah! It happened again!", french=" Ouah! Ça recommence!", german=" Es ist schon wieder passiert!", italian=" Aaah! È successo di nuovo!", spanish=" ¡Aaah! ¡Ha vuelto a ocurrir!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_Stop(7692) [SE one-shot PMDO déjà terminé: arrêt sans objet, canal SE V2]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This tower feels like it's going\nto fall apart any second!", french="La tour menace de s'écrouler\nd'une seconde à l'autre!", german="Es fühlt sich an, als würde der\nTurm jeden Moment zusammenbrechen!", italian="Ho come l'impressione che questa\ntorre crollerà da un momento all'altro!", spanish="Parece que la torre se va a\ncaer de un momento a otro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This tower feels like it's going\nto shake apart any moment!", french="La tour menace de s'écrouler\nd'une seconde à l'autre!", german="Es fühlt sich an, als würde\njeden Moment der Turm auseinanderfallen!", italian="Ho come l'impressione che questa\ntorre crollerà da un momento all'altro!", spanish="Parece que la torre se va a\ncaer de un momento a otro."})
  else
  SkySceneKit.say({english="This tower feels like it's going\nto break apart any moment!", french="La tour menace de s'écrouler\nd'une seconde à l'autre!", german="Es fühlt sich an, als würde\nder Turm jeden Moment kollabieren!", italian="Ho come l'impressione che questa\ntorre crollerà da un momento all'altro!", spanish="Parece que la torre se va a\ncaer de un momento a otro."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's move it, [hero]!", french=" Vite, [hero]!", german="Setzen wir uns in\nBewegung, [hero]!", italian=" Facciamo presto, [hero]!", spanish=" ¡Démonos prisa, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's hustle, [hero]!", french=" Vite, [hero]!", german="Es ist Zeit,\n[hero]!", italian="Facciamo in fretta,\n[hero]!", spanish=" ¡Démonos prisa, [hero]!"})
  else
  SkySceneKit.say({english=" Let's hurry, [hero]!", french=" Vite, [hero]!", german="Beeilen wir uns,\n[hero]!", italian=" Facciamo presto, [hero]!", spanish=" ¡Démonos prisa, [hero]!"})
  end
  -- message_Close
  pcall(function() GAME:MoveCamera(276, 276, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 260, 284, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 292, 284, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! Over there!", french=" Regarde là-bas!", german=" Hey! Dort drüben!", italian=" Ehi! Laggiù!", spanish=" ¡Mira eso!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Look! Over there!", french=" Regarde là-bas!", german=" Sieh mal! Dort drüben!", italian=" Guarda! Laggiù!", spanish=" ¡Mira eso!"})
  else
  SkySceneKit.say({english=" Oh! Over there!", french=" Regarde là-bas!", german=" Oh! Da drüben!", italian=" Oh! Laggiù!", spanish=" ¡Mira eso!"})
  end
  -- message_Close
  pcall(function() GAME:MoveCamera(276, 212, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 260, 220, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 292, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V25P04A) [décor sub chargé: Sub_v25p04a]
  -- camera2_SetPositionMark(Position<'m9', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v25p04a", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  -- bgm2_PlayFadeIn(BGM_TEMPORAL_PINNACLE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]What is this?", french=" ...[K] Qu'est-ce que c'est que ça?", german=" ...[K]Was ist das?", italian=" ...[K] Che cos'è?", spanish=" ¿Qué...?[K] ¿Qué crees que será?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]What could this be?", french=" ...[K] Qu'est-ce que c'est que ça?", german=" ...[K]Was könnte das sein?", italian=" ...[K] Cosa potrebbe essere?", spanish=" ¿Qué...?[K] ¿Qué crees que será?"})
  else
  SkySceneKit.say({english=" ...[K]What could this be?", french=" ...[K] Qu'est-ce que c'est que ça?", german=" ...[K]Was könnte das sein?", italian=" ...[K] Cosa potrebbe essere?", spanish=" ¿Qué...?[K] ¿Qué crees que será?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It has a mystical air to it...", french="Il y a comme une aura mystique\nqui s'en dégage...", german="Es hat etwas Mystisches an\nsich...", italian=" Ha un'aria mistica...", spanish=" Tiene un aire misterioso."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It has a strange, mystical feel...", french="Il y a comme une aura mystique\nqui s'en dégage...", german="Es hat etwas Seltsames,\nMystisches an sich...", italian=" Ha un'aria strana, mistica...", spanish=" Tiene un aire misterioso."})
  else
  SkySceneKit.say({english=" It has a mystical feel to it...", french="Il y a comme une aura mystique\nqui s'en dégage...", german="Irgendetwas daran macht es\ngeheimnisvoll...", italian=" Ha un'aria mistica...", spanish=" Tiene un aire misterioso."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...............)", french="(...............)", german="(...............)", italian="(...............)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...............)", french="(...............)", german="(...............)", italian="(...............)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There's a big circular pattern...)", french="(Il y a un grand symbole circulaire...)", german="(Dort ist ein großes kreisförmiges Muster.)", italian="(Un grosso disegno circolare...)", spanish="(Hay un círculo enorme dibujado.)"})
  else
  SkySceneKit.say({english="(There's a big circular pattern...)", french="(Il y a un grand symbole circulaire...)", german="(Dort ist ein großes kreisförmiges Muster.)", italian="(Un grosso disegno circolare...)", spanish="(Hay un círculo enorme dibujado.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Inside are indentations that look like they've\nbeen gouged out...)", french="(On dirait que quelqu'un a creusé des trous\ndedans...)", german="(Und innen sind Vertiefungen, die aussehen, als\nwären sie herausgemeißelt worden.)", italian="(Ci sono delle incavature...)", spanish="(Dentro, tiene unas marcas; como si se hubiera\nsacado algo a la fuerza.)"})
  else
  SkySceneKit.say({english="(Inside are indentations that look like they've\nbeen gouged out...)", french="(On dirait que quelqu'un a creusé des trous\ndedans...)", german="(Und innen sind Vertiefungen, die aussehen, als\nwären sie herausgemeißelt worden.)", italian="(Ci sono delle incavature...)", spanish="(Dentro, tiene unas marcas; como si se hubiera\nsacado algo a la fuerza.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What is this...?)", french="(Mais à quoi ça peut bien servir...?)", german="(Was ist das?)", italian="(Che cosa...?)", spanish="(¿Qué es esto?)"})
  else
  SkySceneKit.say({english="(What is this...?)", french="(Mais à quoi ça peut bien servir...?)", german="(Was ist das?)", italian="(Che cosa...?)", spanish="(¿Qué es esto?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...![K] Wait a second!)", french="(...![K] Une seconde!)", german="(...[K]Einen Moment mal!)", italian="(...![K] Aspetta un secondo!)", spanish="(¡Eh![K] ¡Espera un segundo!)"})
  else
  SkySceneKit.say({english="(...![K] Wait a second!)", french="(...![K] Une seconde!)", german="(...[K]Einen Moment mal!)", italian="(...![K] Aspetta un secondo!)", spanish="(¡Eh![K] ¡Espera un segundo!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The gouged-out indentations...[K] There are\nfive in all.)", french="(Ces creux dans le symbole...[K] Il y en a cinq\nen tout.)", german="(Die herausgemeißelten Vertiefungen...[K] Es sind\ninsgesamt fünf.)", italian="(Le incavature...[K] in tutto sono\ncinque.)", spanish="(Son...[K] ¡Son cinco marcas en total!)"})
  else
  SkySceneKit.say({english="(The gouged-out indentations...[K] There are\nfive in all.)", french="(Ces creux dans le symbole...[K] Il y en a cinq\nen tout.)", german="(Die herausgemeißelten Vertiefungen...[K] Es sind\ninsgesamt fünf.)", italian="(Le incavature...[K] in tutto sono\ncinque.)", spanish="(Son...[K] ¡Son cinco marcas en total!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Five slots...[K] That means...!)", french="(Cinq cavités...[K] Bon sang mais c'est bien sûr!)", german="(Fünf Vertiefungen...[K] Das bedeutet...)", italian="(Cinque alloggiamenti...[K] Questo significa...!)", spanish="(Cinco huecos...[K] Eso significa que...)"})
  else
  SkySceneKit.say({english="(Five slots...[K] That means...!)", french="(Cinq cavités...[K] Bon sang mais c'est bien sûr!)", german="(Fünf Vertiefungen...[K] Das bedeutet...)", italian="(Cinque alloggiamenti...[K] Questo significa...!)", spanish="(Cinco huecos...[K] Eso significa que...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? Five slots?", french=" Hein, quoi? Cinq trous?", german=" Fünf Vertiefungen?", italian=" Eh? Cinque alloggiamenti?", spanish=" ¿Qué? ¿Cinco huecos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What? Five slots?", french=" Hein, quoi? Cinq trous?", german=" Was? Fünf Vertiefungen?", italian=" Cosa? Cinque alloggiamenti?", spanish=" ¿Qué? ¿Cinco huecos?"})
  else
  SkySceneKit.say({english=" What? Five slots?", french=" Hein, quoi? Cinq trous?", german=" Was? Fünf Vertiefungen?", italian=" Cosa? Cinque alloggiamenti?", spanish=" ¿Qué? ¿Cinco huecos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Th-that's it![K] If I put the Time\nGears into these slots...", french="Mais oui, c'est ça![K] Si je place\nles Rouages du Temps dans les trous...", german="D-das ist es![K] Wenn ich die\nZahnräder der Zeit in diese Vertiefungen\neinsetze...", italian="D-Dev'essere così![K] Se metto\ngli Ingranaggi del Tempo nelle incavature...", spanish="¡Eso es![K] Si introduzco los\nEngranajes del Tiempo en esos cinco huecos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Th-that's it![K] If I set the five\nTime Gears into these five slots...", french="Mais oui, c'est ça![K] Si je place\nles Rouages du Temps dans les trous...", german="D-das ist es![K] Wenn ich die\nZahnräder der Zeit in diese Vertiefungen\neinsetze...", italian="D-Dev'essere così![K] Se metto\ngli Ingranaggi del Tempo nelle incavature...", spanish="¡Eso es![K] Si introduzco los\nEngranajes del Tiempo en esos cinco huecos..."})
  else
  SkySceneKit.say({english="Th-that's it![K] If I put the Time\nGears into these slots...", french="Mais oui, c'est ça![K] Si je place\nles Rouages du Temps dans les trous...", german="D-das ist es![K] Wenn ich die\nZahnräder der Zeit in diese Vertiefungen\neinsetze...", italian="D-Dev'essere così![K] Se metto\ngli Ingranaggi del Tempo nelle incavature...", spanish="¡Eso es![K] Si introduzco los\nEngranajes del Tiempo en esos cinco huecos..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We might be able to prevent\ntime from stopping!", french="... alors on pourra empêcher\nque le temps ne se fige!", german="Dann könnten wir vielleicht\nverhindern, dass die Zeit stehenbleibt!", italian="Riusciremo a impedire che il\ntempo si fermi!", spanish="¡Tal vez podamos evitar que\nse detenga el tiempo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We might prevent time from\nstopping!", french="... alors on pourra empêcher\nque le temps ne se fige!", german="Dann könnten wir vielleicht\nverhindern, dass die Zeit stehenbleibt!", italian="Potremo impedire che il tempo\nsi fermi!", spanish="¡Tal vez podamos evitar que\nse detenga el tiempo!"})
  else
  SkySceneKit.say({english="We might prevent time from\nstopping!", french="... alors on pourra empêcher\nque le temps ne se fige!", german="Dann könnten wir vielleicht\nverhindern, dass die Zeit stehenbleibt!", italian="Potremo impedire che il tempo\nsi fermi!", spanish="¡Tal vez podamos evitar que\nse detenga el tiempo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Gotcha! I'll do it!", french=" Compris, je vais le faire!", german=" Kapiert! Ich mache es!", italian=" Afferrato! Ci penso io!", spanish=" ¡Voy a hacerlo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK! I'll do it!", french=" Compris, je vais le faire!", german=" Okay! Ich mache es!", italian=" Ok! Ci penso io!", spanish=" ¡De acuerdo! ¡Voy a hacerlo!"})
  else
  SkySceneKit.say({english=" All right! I'll do it!", french=" Compris, je vais le faire!", german=" Alles klar! Ich mache es!", italian=" Va bene! Ci penso io!", spanish=" ¡Voy a hacerlo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- GAP: se_Play(7693) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(64) -- WhiteChange
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  pcall(function() GAME:MoveCamera(276, 276, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 292, 284, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 260, 284, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D30P33A4_78) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaaah!", german=" Waaaah!", italian=" Aaaaah!", spanish=" ¡Aaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaaah!", german=" Waaaah!", italian=" Aaaaah!", spanish=" ¡Aaaah!"})
  else
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaaah!", german=" Waaaah!", italian=" Aaaaah!", spanish=" ¡Aaaah!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:FadeIn(256) -- WhiteChange
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6925) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 30) -- screen_FadeChange vers alpha 128 (assombrissement, adaptation)
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa![K] It turned dark suddenly!", french=" Ouah![K] Il fait noir tout à coup!", german="Aaah![K] Es ist plötzlich dunkel\ngeworden!", italian="Wow![K] È diventato buio\nall'improvviso!", spanish="¡Pero bueno![K] ¡De pronto todo\nse ha oscurecido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Waaah![K] It turned dark all of a\nsudden!", french=" Ouah![K] Il fait noir tout à coup!", german="Waaah![K] Es ist plötzlich finster\ngeworden!", italian="Aaaah![K] È diventato tutto buio\nall'improvviso!", spanish="¡Vaya![K] ¿Qué ha pasado con\nla luz?"})
  else
  SkySceneKit.say({english=" Waaah![K] It turned suddenly dark!", french=" Ouah![K] Il fait noir tout à coup!", german="Waaah![K] Es ist plötzlich ganz\ndunkel geworden!", italian="Aaaah![K] È diventato buio\nall'improvviso!", spanish="¡Vaya![K] ¡De pronto todo se\nha vuelto negro!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_DOWN_A_DARK_PATH non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="GRRRRRRRRR...", french="GRRRRRRRRR...", german="GRRRRRRRRR...", italian="GRRRRRRRRR...", spanish="GRRRRRRRRR..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" SO! IT'S YOU!", french=" ALORS, C'EST VOUS!", german=" AH! IHR SEID ES!", italian=" ALLORA SIETE VOI!", spanish=" ¡ASÍ QUE HA SIDO CULPA VUESTRA!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="YOU SEEK THE DESTRUCTION OF\n[CS:P]TEMPORAL TOWER[CR]!", french="VOUS CHERCHEZ A DETRUIRE LA [CS:P]TOUR\nDU TEMPS[CR]!", german="IHR STREBT DIE ZERSTÖRUNG DES\n[CS:P]ZEITTURMS[CR] AN!", italian="STATE CERCANDO DI DISTRUGGERE LA\n[CS:P]TORRE DEL TEMPO[CR]!", spanish="¡SOIS LOS QUE QUERÉIS ACABAR CON\nLA [CS:P]TORRE DEL TIEMPO[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?![K] That's not true!", french="Pardon?![K] Non,\nvous vous trompez!", german=" Was?[K] Das stimmt nicht!", italian=" Cosa?![K] Non è vero!", spanish=" ¡¿Qué?![K] ¡Eso no es verdad!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] You're wrong!", french="Pardon?![K] Non,\nvous vous trompez!", german=" Was?[K] Mitnichten!", italian=" Cosa?![K] Ti sbagli!", spanish=" ¡¿Qué?![K] ¡Te equivocas!"})
  else
  SkySceneKit.say({english=" What?![K] That's not true!", french="Pardon?![K] Non,\nvous vous trompez!", german=" Was?[K] Das stimmt nicht!", italian=" Cosa?![K] Non è vero!", spanish=" ¡¿Qué?![K] ¡Eso no es verdad!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We came to prevent time from\nstopping!", french="On est venus pour éviter\nque le temps ne s'arrête!", german="Wir sind gekommen, um zu\nverhindern, dass die Zeit stehenbleibt!", italian="Siamo qui per evitare che\nil tempo si fermi!", spanish="¡Hemos venido a evitar que\nel tiempo se detenga!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're here to prevent time\nfrom stopping!", french="On est venus pour éviter\nque le temps ne s'arrête!", german="Wir sind gekommen, um zu\nverhindern, dass die Zeit stehenbleibt!", italian="Siamo qui per evitare che il\ntempo si fermi!", spanish="¡Hemos venido a evitar que\nel tiempo se detenga!"})
  else
  SkySceneKit.say({english="We came to prevent time from\nstopping!", french="On est là pour éviter\nque le temps ne s'arrête!", german="Wir sind gekommen, um zu\nverhindern, dass die Zeit stehenbleibt!", italian="Siamo qui per evitare che il\ntempo si fermi!", spanish="¡Hemos venido a evitar que\nel tiempo se detenga!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" TIME...[K]STOPPING...", french=" LE TEMPS...[K] S'ARRETE...", german=" ZEIT...[K] STEHENBLEIBT...", italian=" IL TEMPO...[K] SI FERMI...", spanish=" QUE EL TIEMPO...[K] SE DETENGA..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5126) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" TIME...[K] GRRR-OOOOOO!", french=" LE TEMPS...[K] GRRR-OOOOOO!", german=" ZEIT...[K] GRRR-OOOOOO!", italian=" IL TEMPO...[K] GRRR-OOOOOO!", spanish=" EL TIEMPO...[K] ¡GRRRRRRR!"})
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
  GAME:WaitFrames(30)
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(45)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SlidePositionOffset 0 [cible sans placement SSA zone: déplacement non joué]
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]D-Dialga[CR]!", french=" [CS:N]D-Dialga[CR]!", german=" [CS:N]D-Dialga[CR]!", italian=" [CS:N]D-Dialga[CR]!", spanish=" ¡[CS:N]Dialga[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]D-Dialga[CR]!", french=" [CS:N]D-Dialga[CR]!", german=" [CS:N]D-Dialga[CR]!", italian=" [CS:N]D-Dialga[CR]!", spanish=" ¡[CS:N]Dialga[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]D-Dialga[CR]!", french=" [CS:N]D-Dialga[CR]!", german=" [CS:N]D-Dialga[CR]!", italian=" [CS:N]D-Dialga[CR]!", spanish=" ¡[CS:N]Dialga[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dark_diaruga = SkySceneKit.spawn_npc("dialga", 280, 240, Direction.Down, "NPC_DARK_DIARUGA")
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO!", french=" GRRR-OOOOOO!", german=" GRRR-OOOOOO!", italian=" GRRR-OOOOOO!", spanish=" ¡GRRRRRRR! ¡GRRRRRRR!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- SetAnimation(2) [anim idle native]
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english="YOU![K] YOU DARE BRING RUIN TO\nTHE TOWER!", french="MISERABLES![K] VOUS OSEZ\nVOUS EN PRENDRE A LA TOUR!", german="IHR![K] IHR WAGT ES, NACH DER\nZERSTÖRUNG DES TURMS ZU TRACHTEN!", italian="VOI![K] VOI OSATE CONDURRE\nLA TORRE ALLA ROVINA!", spanish="¡CÓMO OS ATREVÉIS![K] ¡CÓMO\nOSÁIS DESTRUIR LA TORRE!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No! You've got it wrong!", french=" Non, c'est un malentendu!", german=" Nein! Das siehst du falsch!", italian=" No! Ti stai sbagliando!", spanish=" ¡No! ¡Te equivocas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No! That's wrong!", french=" Non, c'est un malentendu!", german=" Nein! Das stimmt nicht!", italian=" No! Non è vero!", spanish=" ¡No! ¡Te equivocas!"})
  else
  SkySceneKit.say({english=" No! That's not it!", french=" Non, c'est un malentendu!", german=" Nein! Das tun wir nicht!", italian=" No! Non è così!", spanish=" ¡No! ¡Te equivocas!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We want to prevent the Tower\nfrom falling apart...", french="C'est le contraire, on veut\nempêcher qu'elle ne s'écroule...", german="Wir wollen verhindern, dass der\nTurm auseinanderbricht...", italian="Noi vogliamo evitare che la\ntorre crolli...", spanish="Queremos evitar que la Torre\nse derrumbe."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We want to prevent the Tower\nfrom collapsing...", french="C'est le contraire, on veut\nempêcher qu'elle ne s'écroule...", german="Wir wollen verhindern, dass der\nTurm kollabiert...", italian="Noi vogliamo evitare che la\ntorre venga distrutta...", spanish="Queremos evitar que la Torre\nse derrumbe."})
  else
  SkySceneKit.say({english="We came to prevent the Tower\nfrom breaking apart...", french="C'est le contraire, on veut\nempêcher qu'elle ne s'écroule...", german="Wir wollen verhindern, dass der\nTurm zusammenbricht...", italian="Noi vogliamo evitare che la\ntorre crolli...", spanish="Queremos evitar que la Torre\nse derrumbe."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" SILENCE! GRRR-OOOOOO!", french=" SILENCE! GRRR-OOOOOO!", german=" SCHWEIGT! GRRR-OOOOOO!", italian=" SILENZIO! GRRR-OOOOOO!", spanish=" ¡SILENCIO! ¡GRRRRRRR!"})
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english="FOR ALL THOSE WHO THREATEN\n[CS:P]TEMPORAL TOWER[CR]...", french="QUICONQUE MENACE LA [CS:P]TOUR\nDU TEMPS[CR]...", german="AN ALLE, DIE IHR DEN\n[CS:P]ZEITTURM[CR] BEDROHT...", italian="VERSO CHI MINACCIA LA\n[CS:P]TORRE DEL TEMPO[CR]...", spanish="AQUELLOS QUE AMENACEN\nLA [CS:P]TORRE DEL TIEMPO[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" I WILL SHOW NO MERCY!", french="... S'EXPOSE A MON\nIMPITOYABLE COURROUX!", german="ICH WERDE EUCH KEINE GNADE\nGEWÄHREN!", italian=" NON MOSTRERÒ ALCUNA PIETÀ!", spanish=" ¡NO TENDRÁN MI CLEMENCIA!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO...OOOOOH!", french=" GRRR-OOOOOO... OOOOOH!", german=" GRRR-OOOOOO...OOOOOH!", italian=" GRRR-OOOOOO... OOOOOH!", spanish=" ¡GRRRRRRR!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- SetAnimation(2) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's no use, [hero]!", french=" Rien à faire, [hero]!", german="Es hat keinen Zweck,\n[hero]!", italian=" È inutile, [hero]!", spanish=" Es inútil, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's no use, [hero]!", french=" Rien à faire, [hero]!", german="Es hat keinen Zweck,\n[hero]!", italian=" È inutile, [hero]!", spanish=" No sirve de nada, [hero]."})
  else
  SkySceneKit.say({english=" It's no use, [hero]!", french=" Rien à faire, [hero]!", german="Es hat keinen Zweck,\n[hero]!", italian=" È inutile, [hero]!", spanish=" No sirve de nada, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" He won't listen to us!", french=" Il refuse de nous écouter!", german=" Es will uns nicht zuhören!", italian=" Non ci darà ascolto!", spanish=" No quiere escucharnos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" He's not listening to us at all!", french=" Il refuse de nous écouter!", german=" Es hört uns absolut nicht zu!", italian=" Non ci sta neanche ascoltando!", spanish=" No quiere escucharnos."})
  else
  SkySceneKit.say({english=" He's not listening to us at all!", french=" Il refuse de nous écouter!", german=" Es hört uns absolut nicht zu!", italian=" Non ci sta neanche ascoltando!", spanish=" No quiere escucharnos."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Dialga[CR] is losing control because time is\nbreaking down!)", french="([CS:N]Dialga[CR] devient fou à cause du temps\nqui se détraque!)", german="([CS:N]Dialga[CR] verliert die Kontrolle, weil die Zeit\nzusammenbricht!)", italian="([CS:N]Dialga[CR] sta perdendo il controllo perché\nl'equilibrio del tempo sta andando in frantumi!)", spanish="(¡[CS:N]Dialga[CR] ha perdido el control de sí mismo\nporque el tiempo se está desmoronando!)"})
  else
  SkySceneKit.say({english="([CS:N]Dialga[CR] is losing control because time is\nbreaking down!)", french="([CS:N]Dialga[CR] devient fou à cause du temps\nqui se détraque!)", german="([CS:N]Dialga[CR] verliert die Kontrolle, weil die Zeit\nzusammenbricht!)", italian="([CS:N]Dialga[CR] sta perdendo il controllo perché il\ntempo sta andando in frantumi!)", spanish="(¡[CS:N]Dialga[CR] ha perdido el control de sí mismo\nporque el tiempo se está desmoronando!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But...)", french="(Pourtant...)", german="(Aber...)", italian="(Ma...)", spanish="(Pero...)"})
  else
  SkySceneKit.say({english="(But...)", french="(Pourtant...)", german="(Aber...)", italian="(Ma...)", spanish="(Pero...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(This isn't like Primal [CS:N]Dialga[CR] in the future...)", french="(... il n'est pas comme [CS:N]Dialga[CR] Primal\ndans le futur...)", german="(Dieses Pokémon ist nicht das [CS:N]Schatten-Dialga[CR],\ndem wir in der Zukunft begegnet sind...)", italian="(Questo non è come [CS:N]Dialga[CR] Oscuro del\nfuturo...)", spanish="(Este no es como el [CS:N]Dialga Primario[CR] del\nfuturo.)"})
  else
  SkySceneKit.say({english="(This isn't like Primal [CS:N]Dialga[CR] in the future...)", french="(... il n'est pas comme [CS:N]Dialga[CR] Primal\ndans le futur...)", german="(Dieses Pokémon ist nicht das [CS:N]Schatten-Dialga[CR],\ndem wir in der Zukunft begegnet sind...)", italian="(Questo non è come [CS:N]Dialga[CR] Oscuro del\nfuturo...)", spanish="(Este no es como el [CS:N]Dialga Primario[CR] del\nfuturo.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(He's not yet fully consumed by the power of\ndarkness!)", french="(La puissance de l'ombre ne l'a pas encore\nentièrement consumé!)", german="(Die Macht der Dunkelheit hat es noch nicht\nvöllig überwältigt!)", italian="(Non è ancora completamente consumato dal\npotere dell'oscurità!)", spanish="(La oscuridad aún no lo tiene totalmente en\nsu poder...)"})
  else
  SkySceneKit.say({english="(He's not yet fully consumed by the power of\ndarkness!)", french="(La puissance de l'ombre ne l'a pas encore\nentièrement consumé!)", german="(Die Macht der Dunkelheit hat es noch nicht\nvöllig überwältigt!)", italian="(Non è ancora completamente consumato dal\npotere dell'oscurità!)", spanish="(La oscuridad aún no lo tiene totalmente en\nsu poder...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There's still a chance that [CS:N]Dialga[CR] can be\nbrought back to reason!)", french="(Il nous reste une chance de ramener [CS:N]Dialga[CR]\nà la raison!)", german="(Es gibt immer noch eine Chance, [CS:N]Dialga[CR] zur\nVernunft zu bringen!)", italian="(C'è ancora una possibilità di riportare\n[CS:N]Dialga[CR] alla ragione!)", spanish="(Todavía queda una oportunidad de que [CS:N]Dialga[CR]\nrecupere la razón.)"})
  else
  SkySceneKit.say({english="(There's still a chance that [CS:N]Dialga[CR] can be\nbrought back to reason!)", french="(Il nous reste une chance de ramener [CS:N]Dialga[CR]\nà la raison!)", german="(Es gibt immer noch eine Chance, [CS:N]Dialga[CR] zur\nVernunft zu bringen!)", italian="(C'è ancora una possibilità di riportare\n[CS:N]Dialga[CR] alla ragione!)", spanish="(Todavía queda una oportunidad de que [CS:N]Dialga[CR]\nrecupere la razón.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There's still hope!)", french="(L'espoir est encore permis!)", german="(Es gibt noch Hoffnung!)", italian="(C'è ancora una speranza!)", spanish="(¡Aún hay esperanza!)"})
  else
  SkySceneKit.say({english="(There's still hope!)", french="(L'espoir est encore permis!)", german="(Es gibt noch Hoffnung!)", italian="(C'è ancora una speranza!)", spanish="(¡Aún hay esperanza!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" H-here he comes, [hero]!", french="Il... il commence à se fâcher,\n[hero]!", german="E-es greift gleich an,\n[hero]!", italian="S-Si sta avvicinando,\n[hero]!", spanish=" ¡Aquí viene, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" H-here he comes, [hero]!", french="Il... il commence à se fâcher,\n[hero]!", german="E-es greift gleich an,\n[hero]!", italian="S-Si sta avvicinando,\n[hero]!", spanish=" ¡Aquí viene, [hero]!"})
  else
  SkySceneKit.say({english=" H-here he comes, [hero]!", french="Il... il commence à se fâcher,\n[hero]!", german="E-es greift gleich an,\n[hero]!", italian="S-Si sta avvicinando,\n[hero]!", spanish=" ¡Aquí viene, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO!", french=" GRRR-OOOOOO!", german=" GRRR-OOOOOO!", italian=" GRRR-OOOOOO!", spanish=" ¡GRRRRRRR!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5140) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(43, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
