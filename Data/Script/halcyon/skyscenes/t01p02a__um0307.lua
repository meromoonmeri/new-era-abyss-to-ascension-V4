-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/um0307.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kagebouzu = SkySceneKit.spawn_npc("shuppet", 96, 232, Direction.Left, "NPC_KAGEBOUZU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kagebouzu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="My partner [CS:N]Murkrow[CR] won't do\nanything I say.", french="Ma partenaire, [CS:N]Cornèbre[CR],\nn'écoute jamais ce que je lui dis de faire.", german="Mein Partner [CS:N]Kramurx[CR] tut nichts\nvon dem, was ich ihr auftrage.", italian="La mia compagna [CS:N]Murkrow[CR] non\nfa nulla di quello che le dico.", spanish="Mi compañera [CS:N]Murkrow[CR] nunca\nhace lo que le digo."})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="I really want to go look for the\n[CS:I]Secret Slab[CR], but...", french="J'aimerais vraiment partir en\nquête du [CS:I]Bloc Secret[CR], mais...", german="Ich möchte wirklich gerne die\n[CS:I]Geheimtafel[CR] suchen gehen, aber...", italian="Vorrei davvero cercare la\n[CS:I]Lastraenigma[CR], ma...", spanish="Querría buscar la [CS:I]Losa Secreta[CR],\npero..."})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kagebouzu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="We've been on the hunt for the\n[CS:I]Golden Apple[CR], but...[K]we've given up.", french="Nous avons longtemps cherché\nla [CS:I]Pomme d'Or[CR], mais en vain...[K]\nNous avons fini par abandonner.", german="Wir sind auf der Jagd nach dem\n[CS:I]Goldapfel[CR] gewesen, aber[K] wir haben aufgegeben.", italian="Siamo andate alla ricerca della\n[CS:I]Mela Dorata[CR], ma...[K] abbiamo rinunciato.", spanish="Hemos intentado encontrar la\n[CS:I]Manzana Oro[CR], pero...[K] nos hemos rendido."})
  pcall(function() UI:SetSpeaker(npc_npc_kagebouzu) end)
  SkySceneKit.say({english="My partner [CS:N]Murkrow[CR] has no\npatience or endurance for searches...", french="Ma partenaire, [CS:N]Cornèbre[CR],\nla patience, ce n'est pas son fort,\nla persévérance non plus d'ailleurs...", german="Mein Partner [CS:N]Kramurx[CR] hat\nweder Geduld noch Ausdauer bei Suchaktionen.", italian="La mia compagna [CS:N]Murkrow[CR] non\nha abbastanza pazienza e resistenza per le\nricerche...", spanish="Mi compañera [CS:N]Murkrow[CR] no tiene\nni paciencia ni resistencia para buscar."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
