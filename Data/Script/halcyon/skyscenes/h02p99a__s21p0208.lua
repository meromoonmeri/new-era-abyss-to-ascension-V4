-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s21p0208.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="But these troubles of time and\nspace...[K] I have a feeling that they're related.", french="Ces destructions du temps et\nde l'espace...[K] j'ai le sentiment\nqu'elles sont étroitement liées.", german="Aber die Zerstörung von Zeit\nund Raum...[K] Das muss irgendwie\nzusammenhängen.", italian="Ma questi due fenomeni...[K]\nHo l'impressione che siano collegati.", spanish="Aunque tengo la sensación...[K]\nde que ambos problemas podrían estar\nrelacionados."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(Time and space...[K] A possible connection...?)", french="(Temps et espace...[K] y aurait-il un lien...?)", german="(Zeit und Raum...[K] Ein möglicher\nZusammenhang?)", italian="(Tempo e spazio...[K] Un possibile legame...?)", spanish="(El tiempo y el espacio...[K] ¿Conectados?)"}) -- SwitchMonologue: branche default
  SkySceneKit.say({english="Do you think [CS:N]Lapras[CR] might know\nsomething about it?", french="... tu crois que [CS:N]Lokhlass[CR] sait\nquelque chose aussi?", german="Denkst du, [CS:N]Lapras[CR] könnte\ndarüber etwas wissen?", italian="Pensi che [CS:N]Lapras[CR] potrebbe\nsaperne qualcosa?", spanish="¿Crees que [CS:N]Lapras[CR] podría saber\nalgo?"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="([CS:N]Lapras[CR]...?)", french="([CS:N]Lokhlass[CR]...?)", german="([CS:N]Lapras[CR]?)", italian="([CS:N]Lapras[CR]...?)", spanish="(¿[CS:N]Lapras[CR]...?)"}) -- SwitchMonologue: branche default
  SkySceneKit.say({english="(It wouldn't be unusual if [CS:N]Lapras[CR] did know\nsomething about this...)", french="(Je ne serais pas étonnée si [CS:N]Lokhlass[CR] savait\nquelque chose à ce sujet...)", german="(Es wäre nicht verwunderlich, wenn [CS:N]Lapras[CR]\netwas darüber wüsste.)", italian="(Non sarebbe strano se [CS:N]Lapras[CR] ne sapesse\nqualcosa...)", spanish="(No sería de extrañar que [CS:N]Lapras[CR] supiera\nalgo de todo esto...)"}) -- SwitchMonologue: branche default
  SkySceneKit.say({english="So let's hurry to the beach,\n[hero]!", french=" Dépêchons-nous, [hero]!", german="Ab zum Strand mit uns,\n[hero]!", italian="Forza, andiamo in spiaggia,\n[hero]!", spanish="¡Vámonos para allá,\n[hero]! ¡Deprisa!"}) -- SwitchTalk: branche default (canon générique)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
