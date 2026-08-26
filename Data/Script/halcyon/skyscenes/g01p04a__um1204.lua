-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/um1204.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ah, you two! ♪", french=" Ah, vous deux! ♪", german=" Ah, ihr zwei! ♪", italian=" Ah, voi due! ♪", spanish=" ¡Ah, aquí estáis! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I do hope you'll work hard and\nearn good money again today.", french="Une fois encore, j'espère que\nvous travaillerez dur pour gagner beaucoup\nd'argent.", german="Ich hoffe doch, dass ihr heute\nwieder hart arbeitet und reichlich Geld für die\nGilde verdient.", italian="Spero che anche oggi lavorerete\nduro per guadagnare un po' di soldi.", spanish="Espero que trabajéis duro y\nhoy también ganéis mucho dinero."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The guild certainly appreciates\nthe funding you provide! ♪", french="La Guilde apprécie à leur juste\nvaleur les fonds que vous lui procurez! ♪", german="Die Gilde weiß eure finanzielle\nUnterstützung zu schätzen! ♪", italian="La Gilda sicuramente apprezza il\nvostro apporto finanziario! ♪", spanish="¡El [CS:N]Pokégremio[CR] agradece todos\nlos fondos que le proporcionáis! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Also...[K] I must thank you for\nputting a stop to [CS:N]Darkrai[CR]'s wicked scheme! ♪", french="Et aussi...[K] Je dois vous\nremercier pour avoir déjoué les plans\nmachiavéliques de [CS:N]Darkrai[CR]! ♪", german="Ferner[K] muss ich euch dafür\ndanken, dass ihr das bösartige Komplott von\n[CS:N]Darkrai[CR] verhindert habt! ♪", italian="Inoltre...[K] Vi devo ringraziare\nper aver sventato il malvagio piano di\n[CS:N]Darkrai[CR]! ♪", spanish="Además...[K] ¡Debo agradeceros\nel haber frustrado el malvado plan de\n[CS:N]Darkrai[CR]! ♪"})
  -- message_Close
  -- @label_129 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" So it was all [CS:N]Darkrai[CR]'s doing...", french="Alors tout était de la faute de\n[CS:N]Darkrai[CR]...", german="Also haben wir das alles [CS:N]Darkrai[CR]\nzu verdanken.", italian="Quindi è stata tutta opera di\n[CS:N]Darkrai[CR]...", spanish="Así que todo era cosa de\n[CS:N]Darkrai[CR]..."})
  -- message_Close
  -- jump @label_129 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
