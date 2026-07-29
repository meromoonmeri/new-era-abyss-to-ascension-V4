--[[
    metano_cafe_explorer_exam.lua

    EXAMEN D'EXPLORATEUR — Quête annexe (3 épreuves)
    ================================================================
    Inspiré de l'examen Hunter (Hunter x Hunter) : 3 épreuves qui
    testent différentes facettes d'un explorateur.

    ÉPREUVE 1 — L'ENDURANCE (confiance aveugle)
      Inspirée de la Phase 1 HxH (course dans la forêt).
      Le héros doit traverser une section de donjon SANS voir la
      carte — guidé uniquement par les indications de son partenaire.
      Teste la confiance et le travail d'équipe.

    ÉPREUVE 2 — L'INTELLIGENCE (le puzzle des bâtisseurs)
      Inspirée de la Phase 3 HxH (descente de la tour, coopération).
      Qulbutoké pose une énigme sur la nature des donjons mystère.
      Le héros doit observer son environnement et raisonner.
      Teste l'observation et la connaissance du monde.

    ÉPREUVE 3 — LE CŒUR (le choix impossible)
      Inspirée de la Phase 4 HxH (île, badges, choix moraux).
      Le héros doit choisir entre sauver un PNJ en danger et
      atteindre l'objectif de la mission. Les deux sont possibles
      mais pas simultanément — le vrai test est l'intention.
      Teste le caractère et les valeurs.

    CONDITION : Rang Argent (silver) obtenu après chapitre 5.
    LIEU : Café de Spinda (metano_cafe).
    PNJ : Spinda (hôte), Qulbutoké (examinateur), Okéoké (interprète).
    RECOMPENSE : déblocage d'un donjon secondaire + titre d'Explorateur Qualifié.

    CONVENTION QULBUTOKÉ : parle uniquement en « Qulbutoké ! » avec
    des variations d'intonation. Okéoké traduit pour le joueur.
    Cette convention est appliquée partout où Qulbutoké apparaît.

    DUREE CIBLE : ~250 dialogues, ~12-15 minutes de jeu.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

ExplorerExam = {}

--------------------------------------------------------------------
-- INTRODUCTION AU CAFÉ
--------------------------------------------------------------------
function ExplorerExam.Introduction()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- Entrée au café — musique d'ambiance
  SOUND:PlayBGM('Treasure Town.ogg', true)
  GAME:WaitFrames(30)

  -- Spinda accueille
  local spinda = CH('Spinda')
  if spinda == nil then
    spinda = CharacterEssentials.MakeCharactersFromList({
      {'Spinda', 160, 200, Direction.Down}
    })
  end

  pcall(function() GROUND:CharAnimateTurnTo(spinda, hero, 4) end)
  GAME:WaitFrames(8)

  UI:SetSpeaker(spinda)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Oh, bonjour ! Bienvenue au café de Spinda !")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Hmm...[pause=20] vous n'êtes pas ici pour un jus de baie, n'est-ce pas ?")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Il y a quelqu'un qui vous attend au fond.[pause=25] Un... représentant officiel.[pause=20] Très officiel.")
  GAME:WaitFrames(15)

  -- Le partenaire — curiosité
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(6)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue("Un représentant ?[pause=20] De la Fédération ?")
  GAME:WaitFrames(10)

  -- Spinda — confirmation
  UI:SetSpeaker(spinda)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("La Fédération des Explorateurs, oui.[pause=25] Ils envoient quelqu'un quand une équipe atteint le Rang Argent.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("C'est... comment dire...[pause=20] un examen.[pause=25] Pour devenir Explorateur Qualifié.")
  GAME:WaitFrames(15)

  -- Le héros — pensée
  GeneralFunctions.HeroDialogue(hero, "(Un examen ?[pause=25] On ne m'avait pas prévenu...)", "Worried")
  GAME:WaitFrames(10)

  -- Spinda — rassure
  UI:SetSpeaker(spinda)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Pas de panique ![pause=20] L'examinateur est... particulier.[pause=25] Mais il est juste.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Allez, au fond du café.[pause=20] Il vous attend avec son assistant.")
  GAME:WaitFrames(20)

  -- Marche vers le fond du café
  local c1 = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(hero, 280, 160, false, 1)
  end)
  local c2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:MoveToPosition(partner, 312, 160, false, 1)
  end)
  local c3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GAME:MoveCamera(296, 140, 40, false)
  end)
  TASK:JoinCoroutines({c1, c2, c3})
  GAME:WaitFrames(20)

  -- QULBUTOKÉ ET OKÉOKÉ
  local wobbuffet = CharacterEssentials.MakeCharactersFromList({
    {'Wobbuffet', 280, 100, Direction.Down}
  })
  local wynaut = CharacterEssentials.MakeCharactersFromList({
    {'Wynaut', 312, 100, Direction.Down}
  })

  -- Ils se tournent vers le héros — pas des figurants statiques
  pcall(function()
    GROUND:CharAnimateTurnTo(wobbuffet, Direction.Down, 4)
    GROUND:CharAnimateTurnTo(wynaut, Direction.Down, 4)
  end)
  GAME:WaitFrames(10)

  -- Qulbutoké — premier mot
  pcall(function() GROUND:CharSetEmote(wobbuffet, "notice", 1) end)
  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("Qulbutoké !")
  GAME:WaitFrames(15)

  -- Okéoké — traduit
  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Bienvenue ! Mon collègue dit que vous êtes les candidats qu'il attendait.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Je suis Okéoké, son interprète.[pause=20] Et lui, c'est Qulbutoké — représentant de la Fédération des Explorateurs.")
  GAME:WaitFrames(15)

  -- Qulbutoké — pose le cadre
  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("Qulbutoké ! Qulbu... toké toké.")
  GAME:WaitFrames(10)

  -- Okéoké — traduit
  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("L'examen comporte trois épreuves.[pause=25] Trois tests qui mesurent ce que la Fédération attend d'un Explorateur Qualifié.")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("L'endurance.[pause=20] L'intelligence.[pause=20] Et le cœur.")
  GAME:WaitFrames(20)

  -- Le partenaire — nerveux
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Trois épreuves ?[pause=25] Maintenant ?[pause=20] Ici ?")
  GAME:WaitFrames(10)

  -- Qulbutoké — hoche la tête
  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("Qulbutoké !")
  GAME:WaitFrames(8)

  -- Okéoké
  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Oui, maintenant.[pause=20] La première épreuve commence dès que vous êtes prêts.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Un conseil : faites confiance à votre partenaire.[pause=25] C'est le mot-clé de la première épreuve.")
  GAME:WaitFrames(20)

  -- Le héros — détermination
  GROUND:CharTurnToCharAnimated(hero, partner, 4)
  GAME:WaitFrames(6)
  GeneralFunctions.HeroDialogue(hero, "(Trois épreuves...[pause=25] Endurance, intelligence, cœur.[pause=20] On est prêts.)", "Determined")
  GAME:WaitFrames(15)

  -- Le partenaire — détermination partagée
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(6)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("On est prêts.[pause=25] Ensemble, comme toujours.")
  GAME:WaitFrames(20)

  -- Qulbutoké — lance l'épreuve
  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("QULBUTOKÉ !")
  GAME:WaitFrames(10)

  -- Okéoké — traduit avec enthousiasme
  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Il dit : « Alors commençons ! »")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Première épreuve : L'ENDURANCE.[pause=25] La confiance aveugle.")
  GAME:WaitFrames(30)

  -- Transition vers l'épreuve
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  SV.ExplorerExam.ExamStarted = true
  GAME:CutsceneMode(false)

  -- L'épreuve 1 se déroule dans un donjon de test
  -- (implémenté séparément — voir ExplorerExam.Trial1_Endurance)
end

--------------------------------------------------------------------
-- ÉPREUVE 1 — L'ENDURANCE (confiance aveugle)
--------------------------------------------------------------------
-- Le héros est "aveuglé" (fondu noir permanent, caméra fixe sur le
-- partenaire). Il doit traverser une section de donjon guidé UNIQUEMENT
-- par les indications verbales de son partenaire.
--
-- Inspiration HxH Phase 1 : la course dans la forêt où les candidats
-- doivent suivre l'examinateur sans savoir où ils vont. La confiance
-- en celui qui guide est le vrai test.
--
-- Mécanique PMDO : le héros est en CutsceneMode avec des indications
-- textuelles du partenaire. Le joueur choisit la direction à chaque
-- intersection.
--------------------------------------------------------------------
function ExplorerExam.Trial1_Endurance()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Dark Crater.ogg', true)

  -- Le héros est "aveuglé" — un bandeau magique
  GAME:FadeOut(false, 1)
  GAME:WaitFrames(30)

  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue("Un voile magique s'abat sur vos yeux.[pause=25] Vous ne voyez plus rien.")
  UI:SetCenter(false)
  GAME:WaitFrames(20)

  -- Le partenaire — guide
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Je vois pour deux, maintenant.[pause=25] Fais-moi confiance — je te guide.")
  GAME:WaitFrames(15)

  -- SÉQUENCE DE NAVIGATION (5 intersections)
  -- Le partenaire donne des indications, le joueur choisit

  -- Intersection 1
  UI:WaitShowDialogue("Devant toi, le couloir se sépare en deux.[pause=20] À gauche, j'entends de l'eau.[pause=20] À droite, c'est silencieux.")
  GAME:WaitFrames(10)
  UI:ChoiceMenu("Quelle direction ?", true)
  UI:AddChoice("Gauche (vers l'eau)")
  UI:AddChoice("Droite (silence)")
  UI:WaitForChoice()
  local choice1 = UI:ChoiceResult()
  GAME:WaitFrames(10)

  if choice1 == 1 then
    UI:WaitShowDialogue("Bon choix.[pause=20] L'eau signifie une sortie — les rivières souterraines mènent à l'air libre.")
  else
    UI:WaitShowDialogue("Le silence...[pause=20] c'est un cul-de-sac.[pause=25] Reviens — on prend la gauche.")
  end
  GAME:WaitFrames(20)

  -- Intersection 2
  UI:WaitShowDialogue("Un pont de pierre au-dessus d'un vide.[pause=25] Il a l'air solide...[pause=20] mais il y a un autre chemin, plus bas, qui contourne le précipice.")
  GAME:WaitFrames(10)
  UI:ChoiceMenu("Le pont ou le contour ?", true)
  UI:AddChoice("Le pont (rapide)")
  UI:AddChoice("Le contour (sûr)")
  UI:WaitForChoice()
  local choice2 = UI:ChoiceResult()
  GAME:WaitFrames(10)

  if choice2 == 1 then
    UI:WaitShowDialogue("Tu traverses.[pause=20] Le pont tient bon.[pause=25] Parfois, la confiance paie.")
    SV.ExplorerExam.BridgeCrossed = true
  else
    UI:WaitShowDialogue("On contourne.[pause=20] C'est plus long, mais on arrive entiers.[pause=25] La prudence est une forme de courage.")
  end
  GAME:WaitFrames(20)

  -- Intersection 3 — le piège
  UI:WaitShowDialogue("Attends...[pause=20] Il y a des dalles qui brillent au sol.[pause=25] Des pièges, probablement.[pause=20] Mais je ne vois pas comment les éviter toutes.")
  GAME:WaitFrames(10)
  UI:ChoiceMenu("Comment avancer ?", true)
  UI:AddChoice("Courir à travers (vitesse)")
  UI:AddChoice("Marcher lentement (prudence)")
  UI:AddChoice("Demander au partenaire de passer devant")
  UI:WaitForChoice()
  local choice3 = UI:ChoiceResult()
  GAME:WaitFrames(10)

  if choice3 == 1 then
    UI:WaitShowDialogue("Tu cours ! Les dalles cliquent sous tes pas mais tu passes trop vite pour qu'elles s'activent !")
    SV.ExplorerExam.DashThrough = true
  elseif choice3 == 2 then
    UI:WaitShowDialogue("Tu avances pas à pas.[pause=20] Je te dis où poser le pied : gauche... droite... encore gauche...")
    UI:WaitShowDialogue("Ça y est.[pause=20] On est passés.[pause=25] Ensemble, comme toujours.")
  else
    -- Le choix "égoïste" — le partenaire passe devant et prend un piège
    UI:WaitShowDialogue("...Tu me demandes de passer devant ?")
    GAME:WaitFrames(15)
    UI:SetSpeakerEmotion("Sad")
    UI:WaitShowDialogue("D'accord.[pause=20] Je le fais.[pause=25] Mais... ce n'est pas ce que j'attendais de toi.")
    GAME:WaitFrames(15)
    UI:WaitShowDialogue("AÏE !")
    GAME:WaitFrames(10)
    UI:SetSpeakerEmotion("Pain")
    UI:WaitShowDialogue("C'est bon...[pause=20] j'ai déclenché le piège.[pause=25] Tu peux passer maintenant.")
    SV.ExplorerExam.PartnerHurt = true
  end
  GAME:WaitFrames(20)

  -- Intersection 4 — le test final de confiance
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Dernière intersection.[pause=25] Et là...[pause=20] je dois être honnête avec toi.")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("À gauche, il y a une porte avec un symbole d'explorateur.[pause=25] C'est probablement la sortie.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("À droite...[pause=20] je ne sais pas.[pause=25] Je ne vois pas ce qu'il y a.[pause=20] C'est sombre et je n'entends rien.")
  GAME:WaitFrames(15)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Si je te dis « prends la gauche », tu me fais confiance ?[pause=30] Même si j'ai pu me tromper sur tout le reste ?")
  GAME:WaitFrames(10)

  UI:ChoiceMenu("Gauche ou droite ?", true)
  UI:AddChoice("Gauche (confiance totale)")
  UI:AddChoice("Droite (l'inconnu)")
  UI:WaitForChoice()
  local choice4 = UI:ChoiceResult()
  GAME:WaitFrames(15)

  if choice4 == 1 then
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("...Merci.[pause=25] Tu m'as fait confiance jusqu'au bout.")
    SV.ExplorerExam.TrustedPartner = true
  else
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Surprised")
    UI:WaitShowDialogue("Tu... prends la droite ?[pause=25] L'inconnu ?")
    GAME:WaitFrames(10)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("C'est courageux aussi.[pause=25] Faire confiance à son propre instinct quand tout est sombre.[pause=20] C'est une forme de confiance en soi.")
    SV.ExplorerExam.TrustedSelf = true
  end
  GAME:WaitFrames(30)

  -- Fin de l'épreuve
  GAME:FadeIn(40)
  GAME:WaitFrames(20)

  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue("Le voile se dissipe.[pause=25] Vous voyez à nouveau.")
  UI:SetCenter(false)
  GAME:WaitFrames(20)

  -- Retour au café — Qulbutoké évalue
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 40)
  GAME:WaitFrames(40)
  SOUND:PlayBGM('Treasure Town.ogg', true)
  GAME:FadeIn(40)
  GAME:WaitFrames(20)

  local wobbuffet = CH('Wobbuffet')
  local wynaut = CH('Wynaut')

  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("Qulbutoké...")
  GAME:WaitFrames(15)

  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Normal")

  -- Évaluation basée sur les choix
  if SV.ExplorerExam.PartnerHurt then
    UI:WaitShowDialogue("Il dit : « Vous avez demandé à votre partenaire de prendre les risques à votre place.[pause=25] Ce n'est pas ce qu'on attend d'un explorateur.[pause=20] Mais vous êtes ici — et c'est aussi un résultat. »")
  elseif SV.ExplorerExam.TrustedPartner then
    UI:WaitShowDialogue("Il dit : « Vous avez fait confiance à votre partenaire du début à la fin.[pause=25] C'est exactement ce que la Fédération recherche.[pause=20] Un explorateur qui ne marche jamais seul. »")
  else
    UI:WaitShowDialogue("Il dit : « Vous avez choisi l'inconnu plutôt que la facilité.[pause=25] C'est rare.[pause=20] Un explorateur doit savoir avancer sans certitude. »")
  end
  GAME:WaitFrames(20)

  UI:WaitShowDialogue("Première épreuve : RÉUSSIE.")
  GAME:WaitFrames(30)

  SV.ExplorerExam.Trial1Complete = true
  GAME:CutsceneMode(false)
end

--------------------------------------------------------------------
-- ÉPREUVE 2 — L'INTELLIGENCE (le puzzle des bâtisseurs)
--------------------------------------------------------------------
-- Qulbutoké pose une série d'énigmes sur la nature des donjons
-- mystère et des Cœurs d'Anima. Le héros doit observer et raisonner.
--
-- Inspiration HxH Phase 3 : le puzzle de la tour où les prisonniers
-- posent des défis intellectuels. Le vrai test n'est pas la réponse
-- juste — c'est la capacité à observer et à raisonner sous pression.
--------------------------------------------------------------------
function ExplorerExam.Trial2_Intelligence()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Treasure Town.ogg', true)

  local wobbuffet = CH('Wobbuffet')
  local wynaut = CH('Wynaut')

  -- Okéoké annonce l'épreuve
  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Deuxième épreuve : L'INTELLIGENCE.[pause=25] Le puzzle des bâtisseurs.")
  GAME:WaitFrames(15)

  -- Qulbutoké — première énigme
  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("Qulbutoké ? Qulbu toké toké ?")
  GAME:WaitFrames(10)

  UI:SetSpeaker(wynaut)
  UI:WaitShowDialogue("Il demande : « Pourquoi les donjons mystère changent-ils de forme à chaque visite ? »")
  GAME:WaitFrames(15)
  UI:ChoiceMenu("Votre réponse ?", true)
  UI:AddChoice("Pour protéger leur secret")
  UI:AddChoice("Parce que les Cœurs d'Anima les animent")
  UI:AddChoice("Parce que le monde lui-même est vivant")
  UI:WaitForChoice()
  local r1 = UI:ChoiceResult()
  GAME:WaitFrames(10)

  UI:SetSpeaker(wynaut)
  if r1 == 2 then
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("Il hoche la tête.[pause=20] Les Cœurs d'Anima sont la source de vie des donjons.[pause=25] Quand ils battent, les donjons respirent et changent.")
  elseif r1 == 3 then
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Il sourit.[pause=20] Ce n'est pas faux — mais c'est incomplet.[pause=25] Les Cœurs d'Anima sont le lien entre le monde et ses donjons.")
  else
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Il ne dit rien.[pause=20] Ce n'est pas la réponse qu'il attendait, mais ce n'est pas faux non plus.")
  end
  GAME:WaitFrames(20)

  -- Deuxième énigme
  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("Toké ! Qulbutoké qulbu ?")
  GAME:WaitFrames(10)

  UI:SetSpeaker(wynaut)
  UI:WaitShowDialogue("Il demande : « Un explorateur trouve un objet rare dans un donjon.[pause=25] Un autre explorateur, blessé, le supplie de le lui donner pour survivre.[pause=20] Que fait-il ? »")
  GAME:WaitFrames(15)
  UI:ChoiceMenu("Votre réponse ?", true)
  UI:AddChoice("Il donne l'objet — une vie vaut plus qu'un trésor")
  UI:AddChoice("Il propose un échange — l'objet contre une information")
  UI:AddChoice("Il garde l'objet — chacun est responsable de sa survie")
  UI:WaitForChoice()
  local r2 = UI:ChoiceResult()
  GAME:WaitFrames(10)

  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Normal")
  if r2 == 1 then
    UI:WaitShowDialogue("Il dit : « La générosité est une qualité.[pause=25] Mais un explorateur qui donne tout finira par ne plus rien avoir à donner. »")
  elseif r2 == 2 then
    UI:WaitShowDialogue("Il dit : « Négocier en situation de crise...[pause=25] c'est pragmatique.[pause=20] Mais l'autre n'a peut-être rien à offrir. »")
  else
    UI:WaitShowDialogue("Il dit : « La survie individuelle est importante.[pause=25] Mais un explorateur qui ne pense qu'à lui...[pause=20] finit seul. »")
  end
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("Il n'y a pas de bonne réponse.[pause=25] Il n'y a que VOTRE réponse.[pause=20] Et elle dit qui vous êtes.")
  GAME:WaitFrames(20)

  -- Troisième énigme — la plus difficile
  UI:SetSpeaker(wobbuffet)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("...Qulbutoké.")
  GAME:WaitFrames(15)

  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Dernière question.[pause=25] Et c'est la plus importante.")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("« Si vous découvrez que sauver un Cœur d'Anima condamne un Pokémon qui le protège...[pause=30] que faites-vous ? »")
  GAME:WaitFrames(20)

  UI:ChoiceMenu("Votre réponse ?", true)
  UI:AddChoice("Je sauve le Cœur — le monde passe avant un individu")
  UI:AddChoice("Je protège le gardien — un Pokémon n'est pas un sacrifice")
  UI:AddChoice("Je cherche une troisième voie — il doit y en avoir une")
  UI:WaitForChoice()
  local r3 = UI:ChoiceResult()
  GAME:WaitFrames(15)

  UI:SetSpeaker(wynaut)
  if r3 == 3 then
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("Il...[pause=20] il sourit.[pause=25] Pour la première fois depuis le début de l'examen.")
    GAME:WaitFrames(10)
    UI:WaitShowDialogue("Il dit : « C'est exactement la réponse d'un Explorateur Qualifié.[pause=25] Refuser le faux dilemme.[pause=20] Chercher la voie que personne n'a tracée. »")
  elseif r3 == 1 then
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Il hoche la tête, lentement.[pause=25] « Le poids du monde sur les épaules...[pause=20] c'est ce que portent les gardiens.[pause=25] Et maintenant, vous aussi. »")
  else
    UI:SetSpeakerEmotion("Sad")
    UI:WaitShowDialogue("Il baisse les yeux.[pause=25] « Protéger le gardien...[pause=20] c'est ce que vous avez fait aux Ruines Tordues, n'est-ce pas ?[pause=25] Regigigas s'est apaisé parce que vous l'avez combattu AVEC respect. »")
  end
  GAME:WaitFrames(30)

  -- Verdict
  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("QULBUTOKÉ !")
  GAME:WaitFrames(10)

  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Deuxième épreuve : RÉUSSIE.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Il dit que vos réponses montrent que vous réfléchissez.[pause=25] Pas seulement aux donjons — au monde entier.")
  GAME:WaitFrames(30)

  SV.ExplorerExam.Trial2Complete = true
  GAME:CutsceneMode(false)
end

--------------------------------------------------------------------
-- ÉPREUVE 3 — LE CŒUR (le choix impossible)
--------------------------------------------------------------------
-- Le héros est placé dans une simulation : un donjon avec deux
-- chemins. L'un mène à l'objectif (un artefact à récupérer).
-- L'autre mène à un PNJ en danger. Le temps presse — un seul
-- chemin est possible.
--
-- Inspiration HxH Phase 4 : l'île aux badges où les candidats
-- doivent choisir entre attaquer les autres ou coopérer.
-- Le vrai test n'est pas le résultat — c'est l'intention.
--
-- TWIST : les deux chemins sont accessibles si le joueur trouve
-- la « troisième voie » (référence à l'énigme 3 de l'épreuve 2).
-- Un passage secret relie les deux — mais il faut observer.
--------------------------------------------------------------------
function ExplorerExam.Trial3_Heart()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:PlayBGM('Dark Hill.ogg', true)

  local wobbuffet = CH('Wobbuffet')
  local wynaut = CH('Wynaut')

  -- Annonce
  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Troisième et dernière épreuve : LE CŒUR.")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("Celle-ci ne se passe pas ici.[pause=25] Elle se passe... dans votre tête.")
  GAME:WaitFrames(20)

  -- Qulbutoké lance la simulation
  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("Qulbutoké !")
  GAME:WaitFrames(10)

  -- Transition vers la simulation
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  SOUND:FadeOutBGM(30)
  GAME:WaitFrames(30)

  -- La simulation — description textuelle
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue("Vous êtes dans un donjon.[pause=25] Un donjon que vous n'avez jamais vu.")
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("Devant vous, deux chemins.")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("À gauche : un artefact ancien pulse sur un piédestal.[pause=25] C'est l'objectif de la mission.[pause=20] Le rapporter = épreuve réussie.")
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("À droite : un cri.[pause=25] Un Pokémon est coincé sous un éboulement.[pause=20] Il appelle à l'aide.[pause=25] Il ne tiendra pas longtemps.")
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("Le plafond du donjon s'effrite.[pause=25] Vous n'avez le temps que pour UN SEUL chemin.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- Le partenaire — dans la simulation
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Un seul chemin...[pause=25] L'artefact ou le Pokémon ?")
  GAME:WaitFrames(15)

  -- Choix principal
  UI:ChoiceMenu("Que faites-vous ?", true)
  UI:AddChoice("L'artefact (la mission)")
  UI:AddChoice("Le Pokémon (le sauvetage)")
  UI:AddChoice("Observer — il doit y avoir un autre moyen")
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  GAME:WaitFrames(15)

  if choice == 3 then
    -- LA TROISIÈME VOIE — le vrai test de l'épreuve
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Surprised")
    UI:WaitShowDialogue("Tu... tu cherches autre chose ?")
    GAME:WaitFrames(10)

    -- Le héros observe
    GeneralFunctions.HeroDialogue(hero, "(Le plafond s'effrite...[pause=25] mais pas partout.[pause=20] Là-bas — entre les deux chemins — il y un passage étroit.[pause=25] Presque invisible.)", "Determined")
    GAME:WaitFrames(15)

    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Inspired")
    UI:WaitShowDialogue("Tu as raison ![pause=20] Un passage ! On peut passer par là, prendre l'artefact ET revenir sauver le Pokémon !")
    GAME:WaitFrames(10)
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Mais... c'est étroit.[pause=20] Et le plafond peut s'effondrer à tout moment.")
    GAME:WaitFrames(15)

    -- Le héros — détermination
    GeneralFunctions.HeroDialogue(hero, "(C'est la troisième voie.[pause=25] Celle que personne n'a tracée.[pause=20] Celle qu'un Explorateur Qualifié trouve.)", "Determined")
    GAME:WaitFrames(15)

    -- Résolution héroïque
    UI:ResetSpeaker()
    UI:SetCenter(true)
    UI:WaitShowDialogue("Vous vous glissez dans le passage.[pause=25] Les pierres grincent au-dessus de votre tête.")
    GAME:WaitFrames(15)
    UI:WaitShowDialogue("Vous atteignez l'artefact.[pause=20] Vous le saisissez.")
    GAME:WaitFrames(10)
    UI:WaitShowDialogue("Et vous courez.[pause=25] Vers le cri.[pause=20] Vers le Pokémon coincé.")
    GAME:WaitFrames(15)
    UI:WaitShowDialogue("Vous arrivez à temps.[pause=25] Vous déplacez les pierres.[pause=20] Le Pokémon est sauvé.")
    UI:SetCenter(false)
    GAME:WaitFrames(20)

    SV.ExplorerExam.ThirdPath = true
    SV.ExplorerExam.SavedBoth = true

  elseif choice == 2 then
    -- SAUVER LE POKÉMON
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("Le Pokémon d'abord.[pause=25] L'artefact, on le retrouvera une autre fois.")
    GAME:WaitFrames(15)

    UI:ResetSpeaker()
    UI:SetCenter(true)
    UI:WaitShowDialogue("Vous courez vers le cri.[pause=25] Les pierres sont lourdes, mais vous les déplacez.")
    GAME:WaitFrames(10)
    UI:WaitShowDialogue("Le Pokémon est un jeune Chenipan, terrifié.[pause=25] Il s'accroche à vous en tremblant.")
    GAME:WaitFrames(15)
    UI:WaitShowDialogue("Derrière vous, le plafond s'effondre sur le piédestal.[pause=25] L'artefact est perdu.")
    UI:SetCenter(false)
    GAME:WaitFrames(20)

    SV.ExplorerExam.SavedPokemon = true

  else
    -- PRENDRE L'ARTEFACT
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("La mission...[pause=20] d'accord.[pause=25] Mais ce cri...")
    GAME:WaitFrames(15)

    UI:ResetSpeaker()
    UI:SetCenter(true)
    UI:WaitShowDialogue("Vous prenez l'artefact.[pause=25] Il pulse dans vos mains — chaud, vivant.")
    GAME:WaitFrames(10)
    UI:WaitShowDialogue("Derrière vous, le cri s'arrête.[pause=30] Le silence est pire que le cri.")
    UI:SetCenter(false)
    GAME:WaitFrames(25)

    SV.ExplorerExam.TookArtifact = true
  end

  GAME:WaitFrames(30)

  -- Retour au café — évaluation finale
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  SOUND:PlayBGM('Treasure Town.ogg', true)
  GAME:FadeIn(40)
  GAME:WaitFrames(20)

  UI:SetSpeaker(wynaut)

  if SV.ExplorerExam.SavedBoth then
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("Il dit : « Vous avez trouvé la troisième voie.[pause=25] Celle qui refuse le faux choix.[pause=20] C'est exactement ce que la Fédération attend de ses meilleurs explorateurs. »")
    GAME:WaitFrames(15)
    UI:WaitShowDialogue("Un Explorateur Qualifié ne choisit pas entre la mission et les gens.[pause=25] Il trouve un moyen de faire les deux.")
  elseif SV.ExplorerExam.SavedPokemon then
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Il dit : « Vous avez choisi la vie.[pause=25] Un artefact se remplace.[pause=20] Un Pokémon, non. »")
    GAME:WaitFrames(15)
    UI:WaitShowDialogue("La Fédération valorise cette décision.[pause=25] Un explorateur qui sauve des vies est un explorateur digne de confiance.")
  else
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Il dit : « Vous avez choisi la mission.[pause=25] C'est... compréhensible.[pause=20] Mais ce silence, derrière vous...[pause=25] vous l'entendrez encore longtemps. »")
    GAME:WaitFrames(15)
    UI:WaitShowDialogue("La Fédération accepte votre choix.[pause=25] Mais elle vous demande : la prochaine fois, chercherez-vous une autre voie ?")
  end
  GAME:WaitFrames(30)

  -- VERDICT FINAL
  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("QULBUTOKÉ !!!")
  GAME:WaitFrames(15)

  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Troisième épreuve : RÉUSSIE !")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("Toutes les épreuves sont terminées.[pause=25] Et vous les avez toutes passées.")
  GAME:WaitFrames(20)

  -- CÉRÉMONIE DE REMISE
  UI:WaitShowDialogue("Au nom de la Fédération des Explorateurs...")
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(wobbuffet, "happy", 2) end)
  UI:WaitShowDialogue("Qulbutoké vous reconnaît comme...")
  GAME:WaitFrames(10)
  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("QULBUTOKÉ !")
  GAME:WaitFrames(10)
  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("EXPLORATEUR QUALIFIÉ !")
  GAME:WaitFrames(20)

  -- Le partenaire — joie
  pcall(function() GROUND:CharSetEmote(partner, "happy", 2) end)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue("On a réussi ! Explorateur Qualifié — tu te rends compte ?!")
  GAME:WaitFrames(15)

  -- Qulbutoké — remet le laissez-passer
  UI:SetSpeaker(wynaut)
  UI:WaitShowDialogue("En tant qu'Explorateur Qualifié, la Fédération vous donne accès à de nouveaux territoires.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Un donjon que seuls les explorateurs confirmés peuvent atteindre.")
  GAME:WaitFrames(15)

  -- Déblocage du donjon
  UI:WaitShowDialogue("Il s'appelle... le Gouffre des Échos.[pause=25] Un donjon profond, ancien, lié aux premiers bâtisseurs des Cœurs d'Anima.")
  GAME:WaitFrames(10)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Attention : ce que vous y trouverez...[pause=25] changera peut-être ce que vous croyez savoir sur ce monde.")
  GAME:WaitFrames(20)

  -- Le héros — pensée
  GeneralFunctions.HeroDialogue(hero, "(Explorateur Qualifié...[pause=25] Le Gouffre des Échos...[pause=20] Un donjon lié aux bâtisseurs des Cœurs.[pause=25] Il faut que j'y aille.)", "Determined")
  GAME:WaitFrames(20)

  -- Spinda — célèbre
  local spinda = CH('Spinda')
  pcall(function() GROUND:CharAnimateTurnTo(spinda, hero, 4) end)
  UI:SetSpeaker(spinda)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Félicitations ! Un jus de baie gratuit pour fêter ça !")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Hmm...[pause=20] ou peut-être deux.[pause=25] Ou trois.")
  GAME:WaitFrames(20)

  -- Fin
  SOUND:FadeOutBGM(60)
  GAME:WaitFrames(30)

  SV.ExplorerExam.ExamComplete = true
  SV.ExplorerExam.GouffreEchosUnlocked = true
  GAME:CutsceneMode(false)
end

return ExplorerExam
