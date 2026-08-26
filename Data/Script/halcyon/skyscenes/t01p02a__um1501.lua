-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/um1501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 512, 200, Direction.Left, "NPC_MARIRU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_mariru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="Oh, [hero] and\n[partner]!", french="Hé, [hero] et\n[partner]!", german="Oh, [hero] und\n[partner]!", italian="Oh, [hero] e\n[partner]!", spanish=" ¡[hero] y [partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="Mr. [CS:N]Drowzee[CR] left to go travel a\nwhile ago.", french="Monsieur [CS:N]Soporifik[CR], il est parti\nen voyage il y a quelque temps.", german="Herr [CS:N]Traumato[CR] ist vor einiger\nZeit zu einer Reise aufgebrochen.", italian="Il signor [CS:N]Drowzee[CR] è partito per\nun viaggio un po' di tempo fa.", spanish="El señor [CS:N]Drowzee[CR] salió de viaje\nhace un rato."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_mariru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="You saved [CS:N]Azurill[CR]...[K] You made\nthe world peaceful...", french="Vous avez sauvé [CS:N]Azurill[CR]...[K]\nVous avez rétabli la paix dans le monde...", german="Ihr habt [CS:N]Azurill[CR] gerettet.[K]\nIhr habt für Frieden auf der Welt gesorgt...", italian="Avete salvato [CS:N]Azurill[CR]...[K] Avete\nriportato la pace nel mondo...", spanish="Salvasteis a [CS:N]Azurill[CR]...[K] y,\nademás, devolvisteis la paz al mundo..."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Thank you... Thank you so much!", french=" Merci... merci de tout cœur!", german=" Danke. Habt vielen Dank!", italian="Grazie...\nGrazie infinite!", spanish=" Gracias... ¡Muchísimas gracias!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
