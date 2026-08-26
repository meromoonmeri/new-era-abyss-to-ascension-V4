-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P11A/s31a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oogh...\nIt's hard to make progress...", french="Ouille...\nPas facile...", german="Uff...\nEs ist hart, vorwärts zu kommen...", italian="Orgh...\nÈ difficile fare progressi...", spanish="Uf...\nCuesta mucho avanzar..."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D73P11A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D73P11A, 'US31') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp(29, 31) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 31]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Station(23) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(40) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(47) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(50) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_23 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_SHAYMIN_VILLAGE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  if (SkyProg.cmp(29, 19) == 0) then -- if ROM: scn($SCENARIO_MAIN) == [29, 19]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[player]. Let's head to the\n5th Station Clearing!", french="[player]. Dirigeons-nous\nvers la trouée du 5[F:E] Relais!", german="[player], das nächste\nZiel ist die 5. Zwischenlagerlichtung!", italian="[player], raggiungiamo\nil Bivacco 5!", spanish="Vamos a la Base del Quinto\nPuerto, [player]."})
  -- message_Close
  else
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" If we don't hurry, [CS:N]Sneasel[CR] will...", french="Si on ne se dépêche pas,\n[CS:N]Farfuret[CR] va...", german="Wenn wir uns nicht beeilen,\nwird [CS:N]Sniebel[CR]...", italian=" Se non ci sbrighiamo, [CS:N]Sneasel[CR]...", spanish=" Si no nos damos prisa, [CS:N]Sneasel[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Let's hurry to the\n8th Station Clearing!", french="Hâtons-nous vers la trouée\ndu 8[F:E] Relais!", german="Lasst uns schnell zur\n8. Zwischenlagerlichtung gehen!", italian="Presto, raggiungiamo\nil Bivacco 8!", spanish="¡Vamos deprisa a la Base del\nOctavo Puerto!"})
  -- message_Close
  end
  else
  -- supervision_Station(20) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(40) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(47) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(50) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  end
end
