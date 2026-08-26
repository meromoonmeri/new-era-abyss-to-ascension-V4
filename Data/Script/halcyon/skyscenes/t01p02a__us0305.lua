-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/us0305.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_zanguusu = SkySceneKit.spawn_npc("zangoose", 368, 264, Direction.Up, "NPC_ZANGUUSU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="Like there are encounters, so\nthere too must be farewells.", french="Tout comme il y a des\nrencontres, il doit y avoir des adieux.", german="So, wie es erste Treffen\ngibt, muss es auch Abschiede geben.", italian="La vita è così...\nÈ fatta di incontri e di addii...", spanish="Igual que hay encuentros, debe\nhaber despedidas."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zanguusu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="Phione Dew?[K] Oh, that! Yes!\nThey say that it's a cure-all.", french="La Rosée Phione?[K] Ah, oui!\nOn dit que c'est un remède miracle capable\nde tout soigner.", german="Phione-Tau?[K] Ach so! Ja!\nSie sagen, es sei ein Allheilmittel.", italian="Brina Phione?[K] Oh, quella! Sì!\nDicono che sia una panacea.", spanish="¿Rocío Phione?[K] ¡Ah, claro!\n¡Sí! Dicen que lo cura todo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
