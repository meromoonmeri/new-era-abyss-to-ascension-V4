-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P11A/us0208.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_togepii = SkySceneKit.spawn_npc("togepi", 400, 336, Direction.Down, "NPC_TOGEPII")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english=" I'm having so much fun! ♪", french="Je m'amuse comme un petit\nfou, pas vrai, les copains? ♪", german=" Ich habe so viel Spaß! ♪", italian=" Mi sto divertendo un mondo! ♪", spanish="¡Me estoy divirtiendo un\nmontón! ♪"})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_togepii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_togepii) end)
  SkySceneKit.say({english="Be strong for us![K] And go bring\npeace to the world!", french="Faites preuve de courage![K]\nPartez ramener la paix dans le monde!", german="Seid stark für uns![K] Und bringt\nder Welt Frieden!", italian="Forza![K] Riportate la pace nel\nmondo!", spanish="¡Sed fuertes por nosotros![K]\n¡Y traed la paz a este mundo!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
