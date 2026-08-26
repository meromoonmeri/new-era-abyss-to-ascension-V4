-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/us2204.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 312, 280, Direction.Up, "NPC_SURIIPU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_suriipu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="I knew you could do it,\n[hero] and [partner]!", french="Je savais que vous en étiez\ncapables, [hero] et [partner]!", german="Ich wusste, dass ihr es\nschaffen könnt, [hero] und\n[partner]!", italian="Sapevo che ce l'avreste fatta,\n[hero] e [partner]!", spanish="¡Sabía que podíais hacerlo,\n[hero] y [partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" You two have true courage.", french="C'est donc cela, le vrai\ncourage... Il est en vous.", german=" Ihr zwei habt wahren Mut.", italian=" Voi due avete davvero fegato!", spanish=" Sois muy valientes."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="I knew it way back when...[K]\nwhen you caught me as an outlaw.", french="Je le savais déjà à l'époque\noù j'étais hors-la-loi...[K]\nquand vous m'avez capturé.", german="Ich wusste das bereits,[K]\nals ihr mich als Ganoven einfingt.", italian="L'ho scoperto tempo addietro\nquando...[K] quando ero ricercato e mi avete\ncatturato.", spanish="Lo supe en cuanto...[K] me\ncapturasteis."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="...[K]I'm going to leave soon.[K]\nI'm going to travel.", french="... [K]Je vais partir bientôt.[K]\nPour voyager.", german="...[K]Ich werde bald aufbrechen.[K]\nIch werde auf Reisen gehen.", italian="...[K] Presto partirò.[K]\nMi metterò in viaggio.", spanish="Pero...[K] pronto me iré.[K] Pienso\nir a un lugar muy lejano."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="It was awkward when we met\non [CS:P]Mt. Travail[CR]...[K] Next time, I'd like to meet\nyou with a smile and open arms.", french="J'étais sur mes gardes lors de\nnotre rencontre au [CS:P]Mt Labeur[CR]... [K]La prochaine\nfois, je vous accueillerai à bras ouverts.", german="Unsere Begegnung auf dem\n[CS:P]Mühsalberg[CR] war komisch.[K] Beim nächsten Mal\nmöchte ich euch mit offenen Armen begegnen.", italian="Il nostro incontro sul [CS:P]Monte[CR]\n[CS:P]Odissea[CR] è stato imbarazzante...[K] Il prossimo\nvorrei che fosse con un sorriso e un abbraccio.", spanish="Nuestro encuentro en el [CS:P]Monte[CR]\n[CS:P]Tribulaciones[CR] fue un tanto incómodo...[K]\nLa próxima vez será muy distinto."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_suriipu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Don't let that [CS:N]Darkrai[CR] beat you!", french="Ne laissez pas ce [CS:N]Darkrai[CR]\nvous vaincre!", german="Lasst euch nicht von diesem\n[CS:N]Darkrai[CR] besiegen!", italian="Non lasciate che [CS:N]Darkrai[CR] abbia\nla meglio!", spanish="¡No dejéis que ese [CS:N]Darkrai[CR]\nse salga con la suya!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
