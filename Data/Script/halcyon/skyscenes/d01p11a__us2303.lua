-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/us2303.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_erureido = SkySceneKit.spawn_npc("gallade", 352, 216, Direction.Up, "NPC_ERUREIDO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_erureido, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_erureido) end)
  SkySceneKit.say({english="We found these fellows\ndrowning in the surf, so we hauled them out.", french="Nous l'avons trouvé en train de\nse noyer dans le ressac, alors on l'a tiré de là.", german="Wir haben diesen Burschen hier\nin der Brandung gefunden, wo er fast er-\ntrunken wäre. Also haben wir ihn rausgezogen.", italian="Li abbiamo trovati che\nstavano per annegare tra le onde e li abbiamo\ntrascinati a riva.", spanish="Nos los encontramos ahogándose\ny los sacamos afuera."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
