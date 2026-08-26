-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P26A/s31a2301.ssb (ROM sha256 1fa39d35…).
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
  -- back_SetGround(LEVEL_D73P26A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D73P26A, 'US31') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp(29, 31) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 31]
  -- @label_23 [étiquette de flux ExplorerScript]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_SKY_PEAK_SNOWFIELD non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  if (SkyProg.cmp(29, 25) == 0) then -- if ROM: scn($SCENARIO_MAIN) == [29, 25]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" If we don't hurry, [CS:N]Sneasel[CR] will...", french="Si on ne se dépêche pas,\n[CS:N]Farfuret[CR] va...", german="Wenn wir uns nicht beeilen,\nwird [CS:N]Sniebel[CR]...", italian=" Se non ci sbrighiamo, [CS:N]Sneasel[CR]...", spanish=" Si no nos damos prisa, [CS:N]Sneasel[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Let's hurry to the\n8th Station Clearing!", french="Hâtons-nous vers la trouée\ndu 8[F:E] Relais!", german="Lasst uns schnell zur\n8. Zwischenlagerlichtung gehen!", italian="Presto, raggiungiamo\nil Bivacco 8!", spanish="¡Vamos deprisa a la Base del\nOctavo Puerto!"})
  -- message_Close
  else
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Usually, [CS:N]Grimer[CR] and [CS:N]Muk[CR] should\nbe living farther down the mountain, I think...", french="Normalement, les [CS:N]Tadmorv[CR] et\nles [CS:N]Grotadmorv[CR] habitent plus bas sur la\nmontagne, je crois...", german="Gewöhnlich wohnen [CS:N]Sleima[CR] und\n[CS:N]Sleimok[CR] weiter unten am Berg...", italian="Di solito i [CS:N]Grimer[CR] e i [CS:N]Muk[CR] vivono\nnelle profondità della montagna, almeno credo...", spanish="Creo que los [CS:N]Grimer[CR] y [CS:N]Muk[CR]\nviven en la parte inferior de la montaña..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We need to do something about\nthe summit, no matter what!", french="Il faut qu'on fasse quelque chose\nau sujet du sommet, peu importe quoi!", german="Wir müssen etwas mit dem\nGipfel machen, was auch immer es sein mag!", italian="Dobbiamo raggiungere la cima\na qualsiasi costo!", spanish="Tenemos que llegar a la cima\nsea como sea."})
  -- message_Close
  end
  else
  -- supervision_Station(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(40) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  end
end
