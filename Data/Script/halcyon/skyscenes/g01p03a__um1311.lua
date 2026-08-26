-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/um1311.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_yamikarasu = SkySceneKit.spawn_npc("murkrow", 336, 288, Direction.Left, "NPC_YAMIKARASU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yamikarasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="Oooh, I must have it! The [CS:I]Lost\nLoot[CR] calls to me!", french="Oooh, il me le faut! Le [CS:I]Butin\nPerdu[CR] m'appelle!", german="Oooh, ich muss es haben! Das\n[CS:I]Beutegut[CR] ruft nach mir!", italian="Oooh, devo averlo!\nIl [CS:I]Tesorperduto[CR] mi chiama!", spanish="¡Lo necesito! ¡El [CS:I]Botín Oculto[CR] me\nestá llamando!"})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english=" The [CS:I]Lost Loot[CR] is rightfully mine!", french="Le [CS:I]Butin Perdu[CR] m'appartient\nde droit!", german="Das [CS:I]Beutegut[CR] gehört\nrechtmäßig mir!", italian=" Il [CS:I]Tesorperduto[CR] è mio di diritto!", spanish="¡El [CS:I]Botín Oculto[CR] será mío y solo\nmío!"})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yamikarasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="I discovered there's something\nI find more desirable than the [CS:I]Golden Apple[CR]!", french="J'ai découvert qu'il existait\nquelque chose que je convoitais encore plus\nqu'une [CS:I]Pomme d'Or[CR]!", german="Ich habe herausgefunden, dass\nes etwas gibt, was ich noch mehr begehre als\nden [CS:I]Goldapfel[CR]!", italian="Ho scoperto che c'è qualcosa\nche desidero di più della [CS:I]Mela Dorata[CR]!", spanish="He descubierto que hay algo más\napetecible que la [CS:I]Manzana Oro[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english=" And that is...[K]the [CS:I]Lost Loot[CR]!", french="Et cette chose, c'est...[K]\nle [CS:I]Butin Perdu[CR]!", german=" Und zwar ist es... [K]das [CS:I]Beutegut[CR]!", italian=" Ed è...[K] il [CS:I]Tesorperduto[CR]!", spanish=" Y es...[K] ¡el [CS:I]Botín Oculto[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english="We've heard rumors that the\nincredibly valuable [CS:I]Lost Loot[CR] is buried\nsomewhere!", french="C'est un trésor d'une valeur\ninestimable! Le bruit court que le [CS:I]Butin Perdu[CR]\nest enfoui quelque part!", german="Gerüchten zufolge liegt das\nunglaublich wertvolle [CS:I]Beutegut[CR] irgendwo\nbegraben!", italian="Dicono che l'inestimabile\n[CS:I]Tesorperduto[CR] sia sepolto da qualche parte!", spanish="¡Hemos oído rumores de que el\nincreíblemente valioso [CS:I]Botín Oculto[CR] está\nenterrado en alguna parte!"})
  pcall(function() UI:SetSpeaker(npc_npc_yamikarasu) end)
  SkySceneKit.say({english=" Do you know anything of it?", french=" Ça vous dit quelque chose?", german=" Wisst ihr etwas darüber?", italian=" Ne sapete qualcosa?", spanish=" ¿Sabes algo de él?"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
