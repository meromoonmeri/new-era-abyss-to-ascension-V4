-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/un0113.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 328, 224, Direction.UpRight, "NPC_HEIGANI")
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! [CS:Y]Bidoof[CR]!", french=" Hé dis donc! [CS:Y]Keunotor[CR]!", german=" Hey, hey! [CS:Y]Bidiza[CR]!", italian=" Ehi, ehi! [CS:Y]Bidoof[CR]!", spanish=" ¡Oye, oye, [CS:Y]Bidoof[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Have a successful exploration!", french="Je te souhaite\nune bonne exploration!", german=" Viel Erfolg bei deiner Erkundung!", italian="Ti auguro il meglio per\nla tua esplorazione!", spanish=" ¡Mucha suerte en la exploración!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" I'm cheering for you! Hey, hey!", french=" Je me réjouis pour toi, dis donc!", german="Ich drücke dir die Daumen!\nHey, hey!", italian=" Faccio il tifo per te! Ehi, ehi!", spanish=" ¡Me alegro mucho por ti!"})
  -- message_Close
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="I wonder...[K]what kind of jobs we\nhave today? Hey, hey...", french="Tiens...[K] Quel genre de\ntravail on a à faire aujourd'hui, dis donc?", german="Ich frage mich,[K] welche Jobs\nwir wohl heute übernehmen werden. Hey, hey...", italian="Mi chiedo...[K] quali missioni\ndovremo affrontare oggi... Ehi, ehi!", spanish="Me pregunto...[K] qué tipo de\nmisiones tenemos hoy... Vete a saber, oye..."})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
