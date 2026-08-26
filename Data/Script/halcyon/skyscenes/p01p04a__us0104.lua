-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/us0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_jiguzaguma = SkySceneKit.spawn_npc("zigzagoon", 352, 208, Direction.Left, "NPC_JIGUZAGUMA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_jiguzaguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="I've decided to team up with\n[CS:N]Heracross[CR] and explore all over the world! ♪", french="J'ai décidé de faire équipe avec\n[CS:N]Scarhino[CR] et d'aller explorer\nle monde entier! ♪", german="Ich habe beschlossen, zusammen\nmit [CS:N]Skaraborn[CR] die ganze Welt zu erkunden! ♪", italian="Ho deciso di unirmi a [CS:N]Heracross[CR]\nper esplorare tutto il mondo! ♪", spanish="He decidido unirme a [CS:N]Heracross[CR]\ny explorar todo el mundo. ♪"})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_jiguzaguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english=" [CS:P]Sky Peak[CR] was so much fun...", french="Escalader le [CS:P]Pic Céleste[CR],\nc'était si amusant...", german="Die Erkundung zum\n[CS:P]Himmelsgipfel[CR] hat so viel Spaß gemacht...", italian="Mi sono proprio divertito\nsul [CS:P]Picco del Cielo[CR]...", spanish=" La [CS:P]Cumbre del Cielo[CR] es la pera..."})
  pcall(function() UI:SetSpeaker(npc_npc_jiguzaguma) end)
  SkySceneKit.say({english="I wonder where I'll explore\nnext time.", french="Je me demande où je vais aller\npour ma prochaine exploration.", german="Ich frage mich, wohin ich das\nnächste Mal auf Erkundung gehen werde.", italian="Chissà che luogo esplorerò\nla prossima volta.", spanish="Quién sabe dónde exploraré\nla próxima vez."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
