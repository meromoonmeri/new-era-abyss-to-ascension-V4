-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/enter10.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_garuura = SkySceneKit.spawn_npc("kangaskhan", 184, 168, Direction.Down, "NPC_GARUURA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  if ((SV.SkyTalkBitFlags or {})[71] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[71]
  -- @label_131 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  -- switch(message_Menu(MENU_KANGASKHAN_STORAGE)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[71] = 1 -- $SCENARIO_TALK_BIT_FLAG[71] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english=" Well! Aren't you impressive!", french="Eh bien! Vous êtes\nfantastiques!", german=" Ihr seid echt beeindruckend!", italian=" Bene! Siete grandi!", spanish=" ¡Vaya! ¡Me siento muy orgullosa!"})
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="My dears, I love the both of you\nas if you were my own children!", french="Je vous aime\ncomme mes propres enfants!", german="Meine Lieben, ich liebe euch\nbeide, als wärt ihr meine eigenen Kinder!", italian="Dolcezze mie, vi voglio bene\ncome se foste miei cuccioli!", spanish="No hace falta que os diga que\npara mí sois como de la familia."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_garuura, 4) end)
  if ((SV.SkyTalkBitFlags or {})[70] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[70]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[70] = 1 -- $SCENARIO_TALK_BIT_FLAG[70] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="I've heard you have to face a\ntough enemy...", french="J'ai entendu dire que vous alliez\naffronter un ennemi coriace...", german="Ich habe gehört, dass ihr es mit\neinem schwierigen Gegner zu tun habt.", italian="Ho sentito che dovete affrontare\nun nemico di quelli tosti...", spanish="He oído que debéis enfrentaros\na un duro enemigo..."})
  pcall(function() UI:SetSpeaker(npc_npc_garuura) end)
  SkySceneKit.say({english="But you two can do it! You're\nsure to win! Don't lose faith!", french="Mais vous pouvez y arriver!\nVous allez gagner, c'est sûr! Ne perdez pas\nespoir!", german="Aber ihr zwei könnt es\nschaffen! Ihr werdet mit Sicherheit siegreich\nsein! Ihr müsst nur daran glauben!", italian="Ma voi ce la potete fare!\nVincerete di sicuro! Abbiate fiducia!", spanish="¡Pero sé que podréis vencerle!\n¡No perdáis la fe en vuestro potencial!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
