-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/um0312.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_oosubame = SkySceneKit.spawn_npc("swellow", 376, 248, Direction.Up, "NPC_OOSUBAME")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_oosubame, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="My partner was terrified of\nme, and I didn't know it...", french="Mon partenaire avait une\npeur panique de moi, et je ne le savais\nmême pas...", german="Mein Partner hatte schreckliche\nAngst vor mir, und ich wusste nichts davon.", italian="Terrorizzavo il mio compagno, e\nnon lo sapevo...", spanish="Mi compañero me tenía pánico...\ny yo no tenía ni idea..."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" As a leader...[K]I must be a failure.", french="Je dois être indigne... [K]d'être\nmeneur.", german="Als Anführer[K] muss ich ein\nechter Versager sein.", italian="Come leader...[K] sono proprio un\nfallimento.", spanish="Como líder...[K] debo de ser\nun fracaso."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_oosubame, 4) end)
  local npc_npc_kemusso = SkySceneKit.spawn_npc("wurmple", 216, 200, Direction.Right, "NPC_KEMUSSO")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_oosubame, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" What...[K]what are you suggesting?", french="Quoi... [K]mais qu'est-ce que\ntu sous-entends?", german="Was...[K] Was willst du damit\nandeuten?", italian="Cosa...[K]\nCosa avevi capito?", spanish=" ¿Qué...?[K] ¿Qué quieres decir?"})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" Me? Eat you? Are you kidding?", french="Moi? Te manger, toi?\nTu rigoles ou quoi?", german="Ich dich essen? Machst du\nWitze?", italian="Io? Mangiare te? Stai\nscherzando?", spanish="¿Crees que te comería a ti?\n¿Estás de guasa?"})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="[CS:N]Wurmple[CR]![K] You're my\ntrusted partner.", french="[CS:N]Chenipotte[CR]![K] Tu es mon fidèle\npartenaire.", german="[CS:N]Waumpel[CR]![K] Du bist mein\nzuverlässiger Partner.", italian="[CS:N]Wurmple[CR]![K] Tu sei il mio\nfido compagno.", spanish="¡[CS:N]Wurmple[CR]![K] Eres mi fiel\ncompañero."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="You're my one...[K]and only partner.\nThere's no replacing you!", french="Mon seul... [K]et unique partenaire.\nTu es irremplaçable!", german="Du bist mein einziger,[K] mein\nwirklich einziger Partner. Du bist unersetzbar!", italian="Sei il mio solo...[K] e unico\ncompagno. Sei insostituibile!", spanish="Eres mi único...[K] compañero.\n¿Dónde iba a encontrar a alguien como tú?"})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="You and me, we're going to keep\non exploring together like we've always done.", french="Toi et moi, on va continuer à\nexplorer ensemble comme on l'a toujours fait.", german="Du und ich, wir werden weiter\nzusammen auf Erkundung gehen, wie wir es\nseit jeher getan haben.", italian="Tu e io continueremo ad andare a\nesplorare insieme come abbiamo sempre fatto.", spanish="Los dos vamos a seguir\nexplorando juntos, igual que siempre."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kemusso, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_oosubame, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" Hm?[K] Why are you crying?", french="Hein?[K] Pourquoi est-ce que\ntu pleures?", german=" Nanu?[K] Warum weinst du?", italian=" Mmm?[K] Perché piangi?", spanish=" ¿Eh?[K] ¿Por qué lloras?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
