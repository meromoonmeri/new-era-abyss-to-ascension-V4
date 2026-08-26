-- GÉNÉRÉ par dev/tools/red_compile_cinematics.py — NE PAS ÉDITER À LA MAIN.
-- Station canonique PMD Red EU : ground s01 (dialogues ROM 0x0856266C).
-- Ordre = (script, command_index) ROM. Textes 5 langues ROM. Ops cif non ordonnancées: voir rapport.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- BGM MUS_WELCOME_TO_THE_WORLD_OF_POKEMON: GAP (pas d'ogg extrait ROM vérifié) — aucune piste substituée
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Welcome!", french="Bienvenue!", german="Herzlich willkommen!", italian="Ti do il benvenuto!", spanish="¡Te doy la bienvenida!"})
  SkySceneKit.say({english="This is the portal that leads to the world of Pokémon!", french="Ceci est le portail qui mène au monde des Pokémon!", german="Dies ist das Portal zur Welt der Pokémon!", italian="Da qui puoi accedere al mondo dei Pokémon!", spanish="¡Este es el portal de entrada al mundo de los Pokémon!"})
  SkySceneKit.say({english="But before I can let you through, I have several questions for you.", french="Mais avant de vous laisser entrer, j'ai plusieurs questions à vous poser.", german="Doch bevor ich dich passieren lassen kann, muss ich dir ein paar Fragen stellen.", italian="Ma prima di lasciarti passare, devo farti un bel po' di domande.", spanish="Pero antes de dejarte entrar, debo hacerte varias preguntas."})
  SkySceneKit.say({english="I want you to answer them sincerely.", french="Je veux que vous y répondiez avec sincérité.", german="Ich möchte, dass du alle Fragen ehrlich beantwortest.", italian="Cerca di rispondere con sincerità.", spanish="Quiero que respondas con sinceridad."})
  SkySceneKit.say({english="Are you ready?", french="On peut commencer?", german="Bist du bereit?", italian="Possiamo cominciare?", spanish="¿Podemos empezar?..."})
  SkySceneKit.say({english="OK... Let the interview begin!", french="D'accord... Commençons l'entretien!", german="Gut... Fangen wir an!", italian="OK... Diamo inizio all'intervista!", spanish="Vale. ¡Que empiece la entrevista!"})
end
