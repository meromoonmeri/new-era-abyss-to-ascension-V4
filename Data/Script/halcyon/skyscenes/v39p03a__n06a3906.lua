-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V39P03A/n06a3906.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_V39P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- back_SetEffect(7, 0) [transition couches décor NDS immédiate]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  GAME:FadeIn(60)
  -- GAP: se_Play(9736) — id SE NDS sans portage PMDO identifié
  -- WaitFadeIn() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Th-this is![K] There's something\nfloating in the sky and shining!", french="Regardez![K] Il y a un truc brillant\nqui flotte dans l'air!", german="D-das ist...[K] Da schwebt etwas\nam Himmel und leuchtet!", italian="M-Ma![K] C'è qualcosa che fluttua\nnell'aria e risplende!", spanish="¡Qué fuerte![K] ¡Hay algo brillante\nque flota en el techo!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It's an incredibly\nmysterious scene...", french="Cet objet est nimbé\nde mystère...", german="Was für ein unglaublich\ngeheimnisvoller Anblick...", italian="È una visione incredibilmente\nmisteriosa...", spanish="Esta escena es increíblemente\nmisteriosa..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" But it's so...[K]it's so pretty...", french=" Et il est si...[K] éblouissant...", german=" Aber so...[K] so schön...", italian=" Ma è così...[K] È così bella...", spanish=" A la par que...[K] hermosa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Gardevoir", true, "gardevoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SAANAITO (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Yes, very...", french=" C'est le moins qu'on puisse dire.", german=" Ja, sehr...", italian=" Sì, molto...", spanish=" Sí, mucho..."})
  pcall(function() UI:SetSpeaker("Gardevoir", true, "gardevoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SAANAITO (espèce ROM, sans placement zone)
  SkySceneKit.say({english="It's emitting this blue-green\nradiance from its center...", french="Son centre émet une lueur\nbleu-vert...", german="Aus der Mitte strahlt dieser\nblaugrüne Schein...", italian="Dal centro si irradia un bagliore\nblu e verde...", spanish="Ese resplandor turquesa\nproviene del centro..."})
  pcall(function() UI:SetSpeaker("Gardevoir", true, "gardevoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SAANAITO (espèce ROM, sans placement zone)
  SkySceneKit.say({english="That light is illuminating the\nwhole cave...", french=" ... qui illumine toute la caverne...", german="Die ganze Höhle erstrahlt in\nseinem Licht...", italian="Quella luce illumina l'intera\ncaverna...", spanish=" Esa luz ilumina toda la cueva..."})
  pcall(function() UI:SetSpeaker("Gardevoir", true, "gardevoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SAANAITO (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" This is very beautiful...", french=" Magnifique...", german=" Das ist sehr schön...", italian=" È meraviglioso...", spanish=" Es hermosísimo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Medicham", true, "medicham", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_CHAAREMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" It's just fascinating...", french=" Fascinant...", german=" Einfach faszinierend...", italian=" È davvero incantevole...", spanish=" Me parece fascinante..."})
  pcall(function() UI:SetSpeaker("Medicham", true, "medicham", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_CHAAREMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I've never seen anything like it\nbefore...[K] But...", french="C'est la première fois que\nje vois une telle chose...[K] Mais...", german="Etwas Vergleichbares habe ich\nnoch nie gesehen...[K] Aber...", italian="Non ho mai visto niente di simile\nprima d'ora...[K] ma...", spanish="Nunca había visto nada\nigual...[K] Pero..."})
  pcall(function() UI:SetSpeaker("Medicham", true, "medicham", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_CHAAREMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="But this thing...[K]\nWhat is it exactly?", french="Mais cet objet...[K] Qu'est-ce\nque c'est au juste?", german="Aber was...[K] ist dieses Ding\ngenau?", italian="Ma questo...[K]\nChe cos'è esattamente?", spanish="Pero, esta cosa...[K]\n¿Qué es exactamente?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Weavile", true, "weavile", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_MANYUURA (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" You don't know?", french=" Quelle ignorance!", german=" Das wisst ihr nicht?", italian=" Non lo sai?", spanish=" ¿No lo sabes?"})
  pcall(function() UI:SetSpeaker("Weavile", true, "weavile", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_MANYUURA (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" It's a Time Gear.", french=" C'est un Rouage du Temps.", german=" Das ist ein Zahnrad der Zeit.", italian=" È un Ingranaggio del Tempo.", spanish=" Es un Engranaje del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Huh?![K] A Time Gear?!", french=" Quoi?![K] Un Rouage du Temps?!", german=" Echt?!?[K] Ein Zahnrad der Zeit?!?", italian=" Uh?![K] Un Ingranaggio del Tempo?!", spanish=" ¡¿Eh?![K] ¡¿Un Engranaje del Tiempo?!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Th-this is?!", french=" Sans blague?!", german=" W-wirklich?!?", italian=" È-È questo?!", spanish=" ¡¿Es... Es esto?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Gardevoir", true, "gardevoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SAANAITO (espèce ROM, sans placement zone)
  SkySceneKit.say({english="This is the first time I've\nseen it too...", french="Moi aussi, c'est la première fois\nque j'en vois un...", german="Das ist auch bei mir das erste\nMal, dass ich so etwas sehe.", italian="È la prima volta che ne vedo\nuno...", spanish="También es la primera vez que\nyo veo uno..."})
  pcall(function() UI:SetSpeaker("Gardevoir", true, "gardevoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SAANAITO (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" This is...", french=" Ainsi donc...", german=" Das ist...", italian=" Questo è...", spanish=" Es..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Ditto", true, "ditto", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_METAMON (espèce ROM, sans placement zone)
  SkySceneKit.say({english="...This is... Yes...[K] This is\na Time Gear.", french="... Ainsi donc... C'est...[K] Oui,\nil s'agit d'un Rouage du Temps.", german="...Das ist... Ja...[K] Das ist\nein Zahnrad der Zeit.", italian="Questo è... Sì...[K] Questo\nè un Ingranaggio del Tempo.", spanish=" Sí, eso es...[K] Es un Engranaje del Tiempo."})
  pcall(function() UI:SetSpeaker("Ditto", true, "ditto", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_METAMON (espèce ROM, sans placement zone)
  SkySceneKit.say({english="To protect this...[K] That's why\nI'm here.", french="Si je suis ici...[K] c'est pour le\nprotéger.", german="Es zu beschützen...[K] Das ist\nmeine Aufgabe.", italian="Per proteggerlo...[K] Ecco perché\nsono qui.", spanish=" Por eso estoy aquí...[K] Para protegerlo."})
  -- message_Close
  GAME:FadeOut(false,  60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
