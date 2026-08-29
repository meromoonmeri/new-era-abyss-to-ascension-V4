-- GÉNÉRÉ par dev/tools/sky_compile_hub_npcs.py — NE PAS ÉDITER À LA MAIN.
-- NPC résidents canoniques du hub p19p01a (enter.sse ROM Sky EU: placements SSA exacts,
-- dialogues enterNN.ssb 5 langues; talk=nil = script ROM sans dialogue compilable, tracé).
local SkySceneKit = require 'halcyon.skyscenes.kit'
local function talk_npc_aamarudo(hero, partner)
      pcall(function() UI:SetSpeaker("Armaldo", true, "armaldo", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AAMARUDO (espèce ROM, sans placement zone)
      SkySceneKit.say({english=" Let's try again.", french=" Essayons encore.", german=" Lass es uns noch mal probieren.", italian=" Riproviamoci.", spanish=" Volvamos a intentarlo."})
      pcall(function() UI:SetSpeaker("Armaldo", true, "armaldo", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AAMARUDO (espèce ROM, sans placement zone)
      SkySceneKit.say({english=" We'll get there this time.", french=" On y arrivera, cette fois-ci.", german=" Diesmal werden wir es schaffen.", italian=" Questa volta ce la faremo.", spanish=" Esta vez lo conseguiremos."})
      pcall(function() UI:SetSpeaker("Armaldo", true, "armaldo", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AAMARUDO (espèce ROM, sans placement zone)
      SkySceneKit.say({english=" We're almost there.", french=" On y est presque.", german=" Wir sind fast da.", italian=" Ci siamo quasi.", spanish=" Ya casi hemos llegado."})
      pcall(function() UI:SetSpeaker("Armaldo", true, "armaldo", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AAMARUDO (espèce ROM, sans placement zone)
      SkySceneKit.say({english="Let's keep going, but remain\ncautious.", french="Continuons,\nmais restons sur nos gardes.", german="Lass uns den Weg fortsetzen,\naber bleib vorsichtig!", italian="Andiamo avanti, ma facciamo\nmolta attenzione.", spanish="Debemos continuar, pero\nsiempre con cautela."})
      pcall(function() UI:SetSpeaker("Armaldo", true, "armaldo", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AAMARUDO (espèce ROM, sans placement zone)
      SkySceneKit.say({english="You can make a record of your\nadventure and take out items using the\nKangaskhan Rock.", french="Tu peux utiliser la Statue\nKangourex pour retirer un objet utile de la\nréserve et pour sauvegarder ton aventure.", german="Mithilfe des Kangama-Speichers\nkannst du deinen Fortschritt sichern oder\nItems aus dem Lager entnehmen.", italian="Puoi salvare la partita\ne prelevare gli strumenti usando\nla Statua Kangaskhan.", spanish="Puedes guardar tu aventura y\nsacar objetos de la consigna en\nla Roca de Kangaskhan."})
      pcall(function() UI:SetSpeaker("Armaldo", true, "armaldo", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AAMARUDO (espèce ROM, sans placement zone)
      SkySceneKit.say({english="Use the Kangaskhan Rock to\nprepare for the exploration.", french="Utilise la Statue Kangourex pour\npréparer l'exploration.", german="Verwende den\nKangama-Speicher, um dich für die\nErkundung vorzubereiten.", italian="Usa la Statua Kangaskhan per\nprepararti all'esplorazione.", spanish="Usa la Roca de Kangaskhan para\nprepararte para explorar."})
      pcall(function() UI:SetSpeaker("Armaldo", true, "armaldo", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AAMARUDO (espèce ROM, sans placement zone)
      SkySceneKit.say({english="Once you're done with that, let's\nhead out on our exploration.", french="Nous partirons dès que tu\nauras terminé.", german="Lass uns aufbrechen, wenn du\ndamit fertig bist.", italian="Quando hai finito, possiamo\nmetterci in cammino.", spanish="Cuando acabes, podremos partir\nde exploración."})
      pcall(function() UI:SetSpeaker("Armaldo", true, "armaldo", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AAMARUDO (espèce ROM, sans placement zone)
      SkySceneKit.say({english="You can use the Kangaskhan Rock\nto take any items you might need.", french="Tu peux utiliser la\nStatue Kangourex pour retirer\nun objet utile de la réserve.", german="Du kannst den Kangama-Speicher\nverwenden, um benötigte Items aus dem Lager\nzu entnehmen.", italian="Puoi usare la Statua Kangaskhan\nper prelevare gli strumenti che ti servono.", spanish="Usa la Roca de Kangaskhan para\nsacar de la consigna los objetos que necesites."})
      pcall(function() UI:SetSpeaker("Armaldo", true, "armaldo", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AAMARUDO (espèce ROM, sans placement zone)
      SkySceneKit.say({english="Anyway, go ahead and make a\nrecord of your adventure and take out items\nusing the Kangaskhan Rock.", french="Très bien, vas-y: retire des\nobjets de la réserve et sauvegarde ton\naventure grâce à la Statue Kangourex.", german="Nun gut. Sichere deinen\nFortschritt oder nimm dir benötigte Items\nmithilfe des Kangama-Speichers.", italian="Non solo, puoi anche salvare\nla partita.", spanish="Luego, usa la Roca de Kangaskhan\npara guardar tu aventura, si quieres."})
      pcall(function() UI:SetSpeaker("Armaldo", true, "armaldo", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AAMARUDO (espèce ROM, sans placement zone)
      SkySceneKit.say({english="Once you're done with that, let's\nhead out on our exploration.", french="Nous partirons dès que tu\nauras terminé.", german="Lass uns auf Erkundung gehen,\nsobald du damit fertig bist!", italian="Quando hai finito, possiamo\ncominciare la nostra esplorazione.", spanish="Cuando estés listo podremos\nemprender nuestra exploración."})
end
return {
  {species="armaldo", x=256, y=176, dir=Direction.Down, name="NPC_AAMARUDO", talk=talk_npc_aamarudo},
}
