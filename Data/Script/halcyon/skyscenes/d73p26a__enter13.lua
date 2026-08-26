-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P26A/enter13.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_tamatama = SkySceneKit.spawn_npc("exeggcute", 320, 264, Direction.Down, "NPC_TAMATAMA")
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="Just a little farther to the\nsummit! You can do it!", french="Encore un petit effort jusqu'au\nsommet. Vous pouvez le faire!", german="Nur noch ein bisschen weiter bis\nzum Gipfel! Das schaffst du!", italian="Manca poco alla cima!\nCe la potete fare!", spanish="¡Solo falta un poquito más para\nllegar a la cima! ¡Tú puedes!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english="Hey! Is it true that you flew\ndown from the summit on [CS:N]Shaymin[CR]'s back?", french="Hé! C'est vrai que vous avez\nredescendu la montagne en volant, sur le\ndos de [CS:N]Shaymin[CR]?", german="Hey! Stimmt es, dass ihr vom\nGipfel aus auf dem Rücken von [CS:N]Shaymin[CR]\ngeflogen seid?", italian="Ehi! È vero che [CS:N]Shaymin[CR] vi ha\ndato un passaggio sul suo dorso volando giù\ndalla cima della montagna?", spanish="¡Oye! ¿Es cierto que bajasteis\nvolando a lomos de [CS:N]Shaymin[CR] desde la cima?"})
  pcall(function() UI:SetSpeaker(npc_npc_tamatama) end)
  SkySceneKit.say({english=" We'd love to fly sometime...", french=" Nous adorerions voler un jour...", german="Ich würde auch gerne\neinmal fliegen...", italian="Anche a noi piacerebbe volare\nun giorno...", spanish=" Nos encantaría volar alguna vez."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
