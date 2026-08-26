-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P11A/us0411.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kinogassa = SkySceneKit.spawn_npc("breloom", 280, 232, Direction.Down, "NPC_KINOGASSA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kinogassa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="It's time for us to move on and\ndiscover new areas that no one's seen before.", french="Il est temps pour nous de\nreprendre la route et de partir explorer\ndes territoires inconnus.", german="Es ist an der Zeit, dass wir\nweiterziehen und neue Gebiete erkunden, die\nnoch niemand vor uns gesehen hat.", italian="Ora dobbiamo ripartire\ne scoprire nuovi luoghi in cui nessuno\nha ancora messo piede.", spanish="Ya es hora de seguir adelante y\ndescubrir zonas que nadie haya visto antes."})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="If there happens to be a new\ndiscovery, we will let you know!", french="Si on fait une nouvelle\ndécouverte, on vous préviendra.", german="Wenn es eine neue Entdeckung\ngibt, lassen wir es euch wissen!", italian="Se scopriremo qualcosa di nuovo,\nve lo faremo sapere!", spanish="Si resulta que descubrimos algo,\nya te lo contaremos."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kinogassa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="We've been working pretty hard\nfor [CS:N]Spinda[CR], so he gave us the day off.", french="On a travaillé plutôt dur pour\n[CS:N]Spinda[CR], alors ils nous a accordé\nune journée de congé.", german="Wir haben ziemlich hart für\n[CS:N]Pandir[CR] gearbeitet, daher hat er uns einen Tag\nfreigegeben.", italian="Abbiamo lavorato molto sodo per\n[CS:N]Spinda[CR], così ci ha dato un giorno libero.", spanish="Trabajamos muy duro para\n[CS:N]Spinda[CR], así que nos ha dado el día libre."})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="[CS:N]Shaymin[CR] are really easy to get\nalong with and hospitable. We were thinking of\njust relaxing here for a while.", french="Les [CS:N]Shaymin[CR] sont vraiment\nagréables et accueillants. On pensait passer\nun peu de temps ici pour se reposer.", german="Mit [CS:N]Shaymin[CR] kann man wirklich\ngut auskommen. Und sie sind so gastfreundlich!\nWir gedenken noch eine Weile hierzubleiben.", italian="È facile andare d'accordo con\ni Pokémon [CS:N]Shaymin[CR]... sono così ospitali!\nPensavamo di rimanere qui a rilassarci un po'.", spanish="Los [CS:N]Shaymin[CR] son de lo más\nhospitalario y amable, así que igual\nnos quedamos por aquí a relajarnos un rato."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
