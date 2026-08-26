-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/um2407.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_pochiena_c = SkySceneKit.spawn_npc("poochyena", 480, 240, Direction.UpLeft, "NPC_POCHIENA_C")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_c, 4) end)
  local npc_npc_pochiena_a = SkySceneKit.spawn_npc("poochyena", 448, 240, Direction.Up, "NPC_POCHIENA_A")
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="[CS:N]Drowzee[CR] has become a changed\nPokémon?[K] Good to hear he has reformed.", french="[CS:N]Soporifik[CR] a changé de vie?[K]\nHeureux d'apprendre qu'il a tiré un trait\nsur ses crimes passés.", german="[CS:N]Traumato[CR] hat sich verändert?[K]\nGut zu hören, dass er sich gebessert hat.", italian="[CS:N]Drowzee[CR] è cambiato?[K] Che bello\nsapere che non è più quello di una volta!", spanish="¿[CS:N]Drowzee[CR] se ha reformado?[K]\nPues un problema menos..."})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="Not that it matters to us, since\nwe're a team that focuses on catching outlaws.", french="Bon, nous, ça ne nous arrange\npas vraiment, puisque nous sommes spécialisés\ndans la capture des bandits.", german="Nicht, dass das für uns von\nBedeutung wäre, sind wir doch ein Team, das\nauf das Fangen von Ganoven spezialisiert ist.", italian="A noi non cambia molto, dato che\nsiamo una squadra che si occupa di catturare\ni ricercati.", spanish="Aunque, tampoco me preocuparía\nlo contrario, puesto que nuestro equipo se\nespecializa en atrapar maleantes..."})
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="But if [CS:N]Drowzee[CR] becomes an\noutlaw again, we'll be there to catch him.", french="Mais si [CS:N]Soporifik[CR] recommence\nà faire du grabuge, on sera les premiers\nà l'attraper.", german="Aber falls sich [CS:N]Traumato[CR] wieder\nzu einem Ganoven entwickelt, werden wir da\nsein, um ihn einzufangen.", italian="Ma se [CS:N]Drowzee[CR] tornerà a\ncommettere crimini, saremo pronti ad\nacciuffarlo.", spanish="Pero avísanos si [CS:N]Drowzee[CR]\nvuelve a las andadas, porque entonces...\n¡nos encargaremos de cogerle!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pochiena_c, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pochiena_a) end)
  SkySceneKit.say({english="We heard that [CS:N]Drowzee[CR] is holed\nup on [CS:P]Mt. Travail[CR].", french="Nous avons entendu dire que\n[CS:N]Soporifik[CR] se terre sur le [CS:P]Mt Labeur[CR].", german="Wir haben gehört, dass sich\n[CS:N]Traumato[CR] auf den [CS:P]Mühsalberg[CR] zurückgezogen\nhat.", italian="Abbiamo saputo che [CS:N]Drowzee[CR]\nsi è rintanato sul [CS:P]Monte Odissea[CR].", spanish="Hemos oído que [CS:N]Drowzee[CR] se ha\nrefugiado en el [CS:P]Monte Tribulaciones[CR]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
