-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P02A/m00p1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  -- back_SetGround(LEVEL_P01P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_kurabu = SkySceneKit.spawn_npc("krabby", 72, 240, Direction.Down, "NPC_KURABU")
  GROUND:MoveToPosition(npc_npc_kurabu, 192, 196, false, 2)
  GAME:FadeIn(30)
  GROUND:MoveToPosition(hero, 236, 140, false, 2)
  GROUND:MoveToPosition(partner, 196, 140, false, 2)
  GROUND:MoveToPosition(npc_npc_kurabu, 216, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(3) [anim idle native]
  GROUND:EntTurn(npc_npc_kurabu, Direction.Right)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kurabu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kurabu) end)
  SkySceneKit.say({english="Ahoy![K]\nAre you headed to the beach?", french=" Hé ho![K] Vous allez à la plage?", german="Ahoi![K]\nSeid ihr auf dem Weg zum Strand?", italian="Arrr! [K]\nState andando alla spiaggia?", spanish="¡Buenas![K]\n¿Te diriges a la playa?"})
  pcall(function() UI:SetSpeaker(npc_npc_kurabu) end)
  SkySceneKit.say({english=" Well...", french=" Hé ben...", german=" Nun...", italian=" Beh...", spanish=" Pues..."})
  pcall(function() UI:SetSpeaker(npc_npc_kurabu) end)
  SkySceneKit.say({english="Would you keep an eye out for\nsomething, if you could?", french=" Un bon tuyau, ça vous dirait?", german="Auf eine Sache\nkönntet ihr achten...", italian="Volevo dirvi di fare attenzione\na una cosa, se potete!", spanish="¿Te importaría buscar una\ncosilla si tienes tiempo?"})
  pcall(function() UI:SetSpeaker(npc_npc_kurabu) end)
  SkySceneKit.say({english="Recently...[K]there have been\nBottles washing up on the beach...", french="Depuis peu...[K] il y a des Bouteilles\nqui s'échouent sur la plage.", german="Seit einiger Zeit...[K]\nwerden Flaschen an den Strand gespült...", italian="Ultimamente...[K] sono state\ntrovate molte bottiglie sulla spiaggia...", spanish="Últimamente...[K] han aparecido\nfrascos en la playa..."})
  pcall(function() UI:SetSpeaker(npc_npc_kurabu) end)
  SkySceneKit.say({english="It looks as though there's\nsomething inside those Bottles...", french="On dirait qu'il y a quelque chose\nà l'intérieur de ces Bouteilles...", german="Anscheinend ist in diesen\nFlaschen etwas drin...", italian="E sembra che al loro interno\nci sia qualcosa...", spanish="Además, parece que tienen\nalgo dentro..."})
  pcall(function() UI:SetSpeaker(npc_npc_kurabu) end)
  SkySceneKit.say({english="If that sounds interesting, you\nmight want to look for Bottles on the beach.", french="Si ça vous intéresse, vous\npouvez aller chercher des Bouteilles\nsur la plage.", german="Wenn das für euch interessant\nklingt, solltet ihr am Strand nach Flaschen\nAusschau halten.", italian="Se vi interessa, potreste\ncercarne qualcuna giù alla spiaggia.", spanish="Si te parece interesante, podrías\nir a la playa a buscar frascos."})
  -- message_Close
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_kurabu.Position; GROUND:MoveToPosition(npc_npc_kurabu, p.X+(0), p.Y+(-200), false, 2) end
  GAME:WaitFrames(20)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.say({english=" Sounds interesting...", french=" Intéressant. Et si on allait voir?", german=" Klingt interessant...", italian=" Questa storia mi ha incuriosita...", spanish=" Podría ser interesante..."}) -- SwitchTalk: branche default (canon générique)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  SkySceneKit.say({english="Whenever we head to the beach,\nwe can look for a Bottle!", french="Quand on ira à la plage, on\npourra voir si on trouve une Bouteille!", german="Jedes Mal, wenn wir zum Strand\ngehen, können wir nach Flaschen suchen!", italian="Ogni volta che andiamo\nalla spiaggia, possiamo cercare una bottiglia!", spanish="Si vamos a la playa\npodemos buscar frascos."}) -- SwitchTalk: branche default (canon générique)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[92] = 1 -- $SCENARIO_MAIN_BIT_FLAG[92] = 1 (ROM)
  SkySceneKit.cleanup_npcs()
end
