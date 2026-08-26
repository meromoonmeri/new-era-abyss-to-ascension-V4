-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/um1403.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kemusso = SkySceneKit.spawn_npc("wurmple", 296, 272, Direction.DownRight, "NPC_KEMUSSO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kemusso, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="I'm ashamed that I doubted my\nleader even a little...", french="J'ai honte d'avoir osé douter\nde mon meneur, ne serait-ce qu'un seul\ninstant...", german="Ich bin beschämt, dass ich auch\nnur geringfügig an meinem Anführer\ngezweifelt habe.", italian="Mi vergogno di aver dubitato\nanche solo per un attimo del mio leader...", spanish="Me avergüenzo de haber dudado\nde mi líder..."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" But I'm glad I had the guts to.", french="Mais je suis heureux d'avoir eu\nle courage de lui parler.", german="Aber andererseits bin ich froh,\ndass ich genug Mumm hatte, ihn zu fragen.", italian="Ma sono contento di aver avuto\nil coraggio di parlargli.", spanish="Pero me alegro de haber tenido\nlas agallas de preguntarle."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="You helped me be brave,\n[hero].", french="C'est toi qui m'as aidé à faire\npreuve de courage, [hero].", german="Du hast mir geholfen, tapfer zu\nsein, [hero].", italian="Mi hai aiutato a fare questo\npasso, [hero].", spanish="Tú me ayudaste a ser valiente,\n[hero]."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" Thank you so much!", french=" Je te remercie du fond du cœur!", german=" Vielen Dank!", italian=" Grazie mille!", spanish=" ¡Muchas gracias!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- SetAnimation(2) [anim idle native]
  local npc_npc_oosubame = SkySceneKit.spawn_npc("swellow", 320, 288, Direction.UpLeft, "NPC_OOSUBAME")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_oosubame, 4) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_kemusso, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english="Eep...[K] Thank you, [CS:N]Swellow[CR]...\nYou are my one and only leader...", french="Ah...[K] Merci, [CS:N]Hélédelle[CR]...\nTu es mon seul et unique meneur...", german="Urgs...[K] Danke, [CS:N]Schwalboss[CR]. Dich\nund nur dich betrachte ich als meinen\nAnführer...", italian="Eeh...[K] Grazie, [CS:N]Swellow[CR]...\nSei il mio solo e unico leader...", spanish="Ay...[K] Gracias, [CS:N]Swellow[CR]... Eres mi\nlíder..."})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" I'm very...[K] So very h-h-happy...", french=" Je suis si...[K] Si c-c-content...", german="Ich bin so...[K] so unglaublich\nglücklich!", italian="Sono molto...[K] Davvero molto\nf-f-felice...", spanish=" Estoy tan...[K] ¡tan feliz!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
