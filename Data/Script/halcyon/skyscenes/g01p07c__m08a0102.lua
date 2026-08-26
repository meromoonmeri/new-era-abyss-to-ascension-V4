-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m08a0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  SkySceneKit.say({english=" It's making me sort of nervous.", french=" Je suis un peu nerveuse.", german="Das macht mich irgendwie\nnervös.", italian=" Non sto più nella pelle.", spanish=" Estoy algo nerviosa."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="After all, we didn't bring back\nany of those Perfect Apples that [CS:N]Wigglytuff[CR]\nloves so much.", french="C'est vrai, quoi! Nous n'avons\npas rapporté une seule des Pommes Parfaites\nque [CS:N]Grodoudou[CR] aime tant.", german="Schließlich haben wir [CS:N]Knuddeluff[CR]\nkeinen der Perfekten Äpfel gebracht, die er\nso liebt.", italian="In fondo non abbiamo trovato\nneanche una di quelle Mele Perfette di cui\n[CS:N]Wigglytuff[CR] è così ghiotto.", spanish="Después de todo, no conseguimos\ntraerle a [CS:N]Wigglytuff[CR] ninguna de esas\nManzanas Perfectas que tanto le gustan."}) -- SwitchTalk: branche default (canon générique)
  SkySceneKit.say({english="We've done the best we could.\nEven if we don't get picked, I don't regret\na thing.", french="Nous avons fait de notre mieux.\nMême si nous ne faisons pas partie de\nl'expédition, je ne regrette rien.", german="Wir haben unser Bestes gegeben.\nSelbst wenn wir nicht ausgewählt werden,\nbereue ich nichts.", italian="Abbiamo fatto del nostro meglio.\nAnche se non dovessero sceglierci, non ho\nrimorsi.", spanish="Hemos hecho lo que hemos\npodido. Aunque no nos escojan, no me\narrepiento de nada."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.Down)
  -- SetAnimation(70) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  SkySceneKit.say({english="Yaaaaawn... I'm getting drowsy.\nLet's get some sleep.", french="Mouaaah... je commence à avoir\nsommeil. Nous devrions dormir.", german="Gääääähn... Ich bin müde.\nLass uns schlafen.", italian="Yaaaaawn... Sto per\naddormentarmi. Andiamo a dormire.", spanish="¡Uaaa! Me caigo de sueño.\nVamos a dormir."}) -- SwitchTalk: branche default (canon générique)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.say({english="I'm looking forward to\ntomorrow's announcement. OK, good night.", french="J'ai hâte d'être à demain,\npour l'annonce. Allez, bonne nuit.", german="Ich freue mich auf den\naufregenden Tag morgen. Gute Nacht.", italian="Non vedo l'ora di sentire\nl'annuncio di domani. Ok, buonanotte.", spanish="Me muero de ganas por saber a\nquién han elegido. Bueno, hasta mañana."}) -- SwitchTalk: branche default (canon générique)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(76) [anim idle native]
  GAME:WaitFrames(60)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Right)
  -- SetAnimation(76) [anim idle native]
  GAME:WaitFrames(50)
  GAME:FadeIn(60) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  -- SetAnimation(62) [anim idle native]
  GAME:WaitFrames(60)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="(That special ability I have may be\nuseful then...)", french="(... ce don que je possède pourrait nous\nêtre d'une grande utilité...)", german="(Dann könnte diese besondere Fähigkeit von\nmir von Nutzen sein.)", italian="(... la mia abilità speciale potrebbe rivelarsi\nutile.)", spanish="(Esa capacidad especial que tengo podría\nresultar muy útil...)"}) -- SwitchMonologue: branche default
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"}) -- SwitchMonologue: branche default
  GAME:WaitFrames(30)
  -- SetAnimation(62) [anim idle native]
  GAME:WaitFrames(90)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(60)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" There it is! Another Time Gear!", french=" Le voilà! Un autre Rouage du Temps!", german=" Da ist es! Ein weiteres Zahnrad der Zeit!", italian=" Eccolo! Un altro Ingranaggio del Tempo!", spanish=" ¡Ahí está! ¡Otro Engranaje del Tiempo!"})
  -- message_Close
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
