-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/us0207.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_yarukimono = SkySceneKit.spawn_npc("vigoroth", 184, 232, Direction.Right, "NPC_YARUKIMONO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" Yo! You two sure showed them!", french=" Yo! Vous les avez laminés!", german="Hey! Ihr zwei habt es denen echt\ngezeigt!", italian=" Avete fatto vedere chi siete!", spanish=" ¡Eh! ¡Menuda lección les disteis!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="We can go on like this without\nbeing scared again!", french="La vie peut reprendre son cours!\nPersonne aura plus jamais peur!", german="Wir können so weiterleben wie\nbisher, ohne wieder Angst haben zu müssen!", italian=" Non dovremo più avere paura!", spanish="Por fin, vamos a poder respirar\ntranquilos sin más sustos de este tipo."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" You get my thanks for that!", french=" Merci à vous!", german=" Dafür möchte ich euch danken!", italian=" Grazie di tutto!", spanish=" ¡Os lo agradezco!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yarukimono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="You show that [CS:N]Darkrai[CR] he picked\nthe wrong bunch to mess with!", french="Montrez à ce [CS:N]Darkrai[CR] qu'il a mal\nchoisi ses adversaires!", german="Zeigt diesem [CS:N]Darkrai[CR], dass es\nsich dieses Mal mit der falschen Truppe\nangelegt hat!", italian="[CS:N]Darkrai[CR]  si è messo contro\nil gruppo di Pokémon sbagliato.", spanish="¡Tenéis que darle un buen\nescarmiento a ese tal [CS:N]Darkrai[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
