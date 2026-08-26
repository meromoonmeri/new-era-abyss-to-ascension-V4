-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/um2202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_okutan = SkySceneKit.spawn_npc("octillery", 432, 232, Direction.Down, "NPC_OKUTAN")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okutan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="It's terrible! I don't do anything\nother than trying to win at Big Treasure!", french="C'est terrifiant! Je passe tout\nmon temps à essayer de gagner à Méga Magot!", german="Es ist schrecklich! Meine einzige\nBeschäftigung ist es nun, zu versuchen, beim\nGroßen Schatz abzuräumen!", italian="È terribile! Non faccio altro\nche passare le giornate cercando di\nvincere qualcosa al Gran Tesoro!", spanish="¡Es un horror! ¡Lo único\nemocionante que hago es intentar\nganar en el Gran Tesoro!"})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english=" I can't go on like this!", french="Je ne peux pas continuer\ncomme ça!", german=" So kann ich nicht weitermachen!", italian=" Non posso andare avanti così!", spanish=" ¡Esto no puede seguir así!"})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_okutan, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="Ever since I came back from\n[CS:P]Sky Peak[CR], the daily routine has been\nkind of boring.", french="Depuis que je suis revenue du\n[CS:P]Pic Céleste[CR], le train-train quotidien\nme semble bien ennuyeux.", german="Der Alltag ist jetzt ganz schön\nlangweilig, seitdem ich vom [CS:P]Himmelsgipfel[CR]\nzurückgekehrt bin.", italian="Da quando sono tornata dal\n[CS:P]Picco del Cielo[CR], mi sembra che tutto sia\ndiventato così noioso.", spanish="Desde que volví de la [CS:P]Cumbre[CR]\n[CS:P]del Cielo[CR], la rutina diaria me resulta\nalgo aburridilla."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
