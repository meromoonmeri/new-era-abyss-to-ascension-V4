-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/um0405.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_dorapion = SkySceneKit.spawn_npc("drapion", 336, 256, Direction.DownLeft, "NPC_DORAPION")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dorapion, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="We found out [CS:P]Zero Isle[CR] is no\nordinary place.", french="Nous avons découvert que l'[CS:P]Ile\nZéro[CR] était tout sauf un endroit ordinaire.", german="Wir haben herausgefunden, dass\ndie [CS:P]Null-Insel[CR] kein gewöhnlicher Ort ist.", italian="Sappiamo che l'[CS:P]Isola Zero[CR] non è\nun posto come gli altri.", spanish="Parece ser que la [CS:P]Isla Cero[CR] no\nes un lugar corriente."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="It turns out that the island has\nseveral dungeons.[K] They each put restrictions on\nexplorers in a unique way.", french="En réalité, il y a plusieurs\ndonjons sur l'île.[K] Chacun impose ses propres\ncontraintes à l'explorateur qui y pénètre.", german="Es sieht so aus, als gäbe es auf\nder Insel mehrere verschiedene Dungeons.[K] Sie\nalle legen Erkundern diverse Bürden auf.", italian="Sembra che l'isola abbia diversi\ndungeon.[K] Ognuno di questi pone restrizioni\nnei confronti degli esploratori.", spanish="Resulta que hay diferentes\nterritorios en la isla.[K] Y en cada uno se\naplican distintas restricciones."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="Some places knock you down to\nLevel 1 temporarily, and another prevents you\nfrom leveling up.", french="Certains vous font retomber\ntemporairement au Niveau 1, et d'autres\nvous empêchent de monter de niveau.", german="Einige Orte lassen deinen Level\nvorübergehend auf 1 sinken, andere verhindern\neinen Levelaufstieg.", italian="Alcuni posti ti fanno tornare\ntemporaneamente al Livello 1 e altri non ti\nconsentono di salire di livello.", spanish="Algunos te rebajan al Nivel 1\ntemporalmente y otros te impiden subir de\nnivel."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="You may also not be allowed to\ntake items in. You'll be restricted in some way\nor another with those dungeons.", french="Parfois, il est interdit d'y\nemporter des objets. Ces donjons imposent\ntous des contraintes diverses.", german="Eventuell ist es dir untersagt,\nItems mitzunehmen. In diesen Dungeons werdet\nihr auf verschiedene Arten eingeschränkt.", italian="In altri non è permesso\nportare strumenti. In un modo o nell'altro,\nquesti dungeon ti pongono restrizioni.", spanish="También pueden prohibirte\nentrar con objetos. Siempre hay algún tipo de\nrestricción en estos territorios."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dorapion, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="[CS:P]Zero Isle[CR] is to the south of\nhere, across the sea.", french="L'[CS:P]Ile Zéro[CR] se trouve au sud d'ici,\nde l'autre côté de la mer.", german="Die [CS:P]Null-Insel[CR] befindet sich\nsüdlich von hier, jenseits des Meeres.", italian="L'[CS:P]Isola Zero[CR] si trova a sud di\nqui, oltre il mare.", spanish="La [CS:P]Isla Cero[CR] está al sur de aquí,\ncruzando el mar."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="That's where we're about to\nraid now!", french="C'est notre prochaine\ndestination!", german="Das ist der Ort, den wir im\nBegriff sind, zu erkunden!", italian="Stiamo per andare a\nsaccheggiarla!", spanish="Nos dirigimos hacia allí\nprecisamente."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="The mountains of treasures and\ngold in there... We mean to have it all!", french="Des montagnes d'or et de\ntrésors... Tout ça sera à nous!", german="Die Schatz- und Goldberge dort\ndrinnen... Wir wollen sie alle haben!", italian="Ci sono montagne d'oro e di\ntesori laggiù... Vogliamo tutto!", spanish="Montañas de oro y riquezas...\n¡Pretendemos quedarnos con todo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
