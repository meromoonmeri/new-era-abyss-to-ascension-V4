-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m01d0722.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03B) [décor sub chargé: Sub_v01p03b]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- screen2_FlushOut [sub déjà caché]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  SkySubScreen.Show("v01p03b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  SkySceneKit.say({english="Sure, it does look like junk, but\ntake a closer look.", french="C'est vrai, ça ressemble un peu\nà de la camelote, mais à y regarder de plus\nprès...", german="Sicher, es sieht wie ein\nnutzloser Stein aus. Aber sieh genauer hin.", italian="Sulle prime non sembra\nniente di speciale, ma dai un'occhiata più\nda vicino...", spanish="Ya sé que parece un pedrusco,\npero si miras más de cerca..."}) -- SwitchTalk: branche default (canon générique)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(4), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-4), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetGround(V01P06B) [décor sub chargé: Sub_v01p06b]
  -- camera2_SetPositionMark(Position<'m1', 21, 15>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v01p06b", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  SkySceneKit.say({english="Look there.[K] See that strange\npattern inscribed on it?", french="Tu vois?[K] Tu vois ce motif\nétrange gravé dessus?", german="Sieh mal.[K] Siehst du das\nmerkwürdige Muster auf dem Stein?", italian="Guarda qui.[K] C'è uno strano\ndisegno inciso sulla superficie.", spanish="¿Ves esto?[K] ¿Ves ese extraño\nsímbolo?"}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="(I've never seen a pattern like this.)", french="(Je n'avais encore jamais vu de motif de\nce genre.)", german="(So ein Muster habe ich noch nie gesehen.)", italian="(Non ho mai visto un disegno del genere.)", spanish="(Nunca había visto nada así.)"}) -- SwitchMonologue: branche default
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Show("v01p06b", 0, false) -- screen2_FlushIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
