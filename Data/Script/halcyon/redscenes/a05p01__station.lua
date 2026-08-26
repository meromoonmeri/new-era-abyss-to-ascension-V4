-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground a05p01 (dialogues ROM 0x084C976C).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- BGM MUS_CREDITS: GAP (pas d'ogg extrait ROM vérifié) — aucune piste substituée
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="(I'm rising into the sky...)", french="(Je m'élève dans le ciel...)", german="(Ich schwebe Richtung Himmel...)", italian="(Mi sto sollevando verso il cielo...)", spanish="(Estoy elevándome hacia el cielo...)"})
  SkySceneKit.say({english="(I'm rising into the sky...)", french="(Je m'élève dans le ciel...)", german="(Ich schwebe zum Himmel...)", italian="(Mi sto sollevando verso il cielo...)", spanish="(Me elevo hacia el cielo...)"})
  SkySceneKit.say({english="(I wonder where I'm going?)", french="(Je me demande où je vais...)", german="(Wo ich wohl hinkomme?)", italian="(Dove starò andando?)", spanish="(¿Adónde me voy?...)"})
  SkySceneKit.say({english="(I wonder where I'm going?)", french="(Je me demande où je me dirige...)", german="(Wo ich wohl hinkomme?)", italian="(Dove starò andando?)", spanish="(¿Adónde me estoy yendo?...)"})
end
