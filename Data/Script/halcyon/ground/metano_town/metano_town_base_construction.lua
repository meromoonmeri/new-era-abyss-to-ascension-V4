--[[
    metano_town_base_construction.lua

    QUÊTE ANNEXE — CONSTRUCTION DE LA BASE PERSONNELLE
    ================================================================
    Adaptation du Bois Brouhaha (Uproar Forest) de PMD Rescue Team.
    Sources : pret/pmd-red (structure), ExplorersOfSkyOrigins (assets).

    STRUCTURE EN 6 ACTES
    ------------------------------------------------------------------
    Acte 1 — L'ANNONCE : Penticus offre un terrain à la guilde
    Acte 2 — LE RECRUTEMENT : Qulbutoké/Okéoké au café proposent
              la mission du Bois Brouhaha
    Acte 3 — LE DONJON : 5-8 étages, boss Papilusion/Chenipan/Boustiflor
    Acte 4 — LA CONSTRUCTION : chantier collectif mis en scène
    Acte 5 — LA GRÈVE : Boustiflor exige des Baies Sucrées (comédie)
    Acte 6 — L'INAUGURATION : visite + reprise trame principale (ch8)

    CONDITION : SV.Chapter7.DefeatedRuinsBoss = true
                + SV.adventure.Rescues >= 10
    LIEU : Metano Town + Café + Bois Brouhaha + Base

    DUREE CIBLE : ~250 dialogues, ~15 minutes de jeu.

    JUSTIFICATION NARRATIVE DES BOSS
    ------------------------------------------------------------------
    Papilusion, Chenipan et Boustiflor ne sont pas méchants.
    Ils protègent leur territoire parce que la corruption d'un Cœur
    voisin les a rendus anxieux et territoriaux. Le combat est un
    malentendu — une fois vaincus, ils comprennent que le héros
    n'est pas une menace et participent à la construction.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

BaseConstruction = {}

--------------------------------------------------------------------
-- ACTE 1 — L'ANNONCE (guilde, ~30 dialogues)
--------------------------------------------------------------------
function BaseConstruction.Act1_Announcement()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()
  SOUND:PlayBGM('Guild Theme.ogg', true)

  -- Penticus s'adresse au héros
  local tropius = CH('Tropius')
  pcall(function() GROUND:CharAnimateTurnTo(tropius, hero, 4) end)
  GAME:WaitFrames(10)

  UI:SetSpeaker(tropius)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Ah, vous voilà ! J'ai quelque chose à vous annoncer.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Après tout ce que vous avez accompli — les Ruines Tordues, le Cœur purifié...")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("La guilde a décidé de vous offrir quelque chose de spécial.")
  GAME:WaitFrames(15)

  -- Le partenaire — curiosité
  GROUND:CharTurnToCharAnimated(partner, tropius, 4)
  GAME:WaitFrames(6)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue("Quelque chose de spécial ?[pause=20] Pour nous ?")
  GAME:WaitFrames(10)

  -- Penticus — l'annonce
  UI:SetSpeaker(tropius)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Un terrain.[pause=25] Derrière la guilde, il y a un espace libre depuis des années.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Il est à vous.[pause=25] Pour construire votre propre base.")
  GAME:WaitFrames(15)

  -- Le partenaire — joie
  pcall(function() GROUND:CharSetEmote(partner, "happy", 2) end)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue("NOTRE base ?![pause=20] Une vraie base d'équipe ?![pause=25] Pas juste un dortoir partagé ?")
  GAME:WaitFrames(10)

  -- Penticus
  UI:SetSpeaker(tropius)
  UI:WaitShowDialogue("Exactement.[pause=25] Un endroit à vous, pour préparer vos missions, stocker votre matériel, et vous reposer.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Mais il faut la construire.[pause=25] Et pour ça, il vous faut des matériaux.")
  GAME:WaitFrames(15)

  -- Penticus — oriente vers le café
  UI:WaitShowDialogue("Allez voir au café.[pause=25] Il y a deux... spécialistes de la construction qui vous attendent.")
  GAME:WaitFrames(10)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Ils sont... particuliers.[pause=20] Mais compétents.[pause=25] Très compétents.")
  GAME:WaitFrames(15)

  -- Le héros — pensée
  GeneralFunctions.HeroDialogue(hero, "(Notre propre base...[pause=25] C'est un rêve qui se réalise.)", "Happy")
  GAME:WaitFrames(15)

  -- Le partenaire — enthousiasme
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(6)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Au café ![pause=20] Tout de suite !")
  GAME:WaitFrames(20)

  -- Sortie
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 40)
  GAME:WaitFrames(40)

  SV.BaseConstruction.Announced = true
  GAME:CutsceneMode(false)
end

--------------------------------------------------------------------
-- ACTE 2 — LE RECRUTEMENT (café, ~50 dialogues)
--------------------------------------------------------------------
function BaseConstruction.Act2_Recruitment()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:PlayBGM('Treasure Town.ogg', true)

  -- Qulbutoké et Okéoké au fond du café
  local wobbuffet = CharacterEssentials.MakeCharactersFromList({
    {'Wobbuffet', 280, 100, Direction.Down}
  })
  local wynaut = CharacterEssentials.MakeCharactersFromList({
    {'Wynaut', 312, 100, Direction.Down}
  })

  -- Marche vers eux
  local c1 = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(hero, 280, 140, false, 1)
  end)
  local c2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:MoveToPosition(partner, 312, 140, false, 1)
  end)
  local c3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GAME:MoveCamera(296, 120, 40, false)
  end)
  TASK:JoinCoroutines({c1, c2, c3})
  GAME:WaitFrames(20)

  -- Qulbutoké et Okéoké se tournent
  pcall(function()
    GROUND:CharAnimateTurnTo(wobbuffet, Direction.Down, 4)
    GROUND:CharAnimateTurnTo(wynaut, Direction.Down, 4)
  end)
  GAME:WaitFrames(8)

  -- Qulbutoké
  pcall(function() GROUND:CharSetEmote(wobbuffet, "happy", 1) end)
  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("Qulbutoké ! Qulbu toké !")
  GAME:WaitFrames(10)

  -- Okéoké — traduit
  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Ah, vous voilà ! On vous attendait.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Penticus nous a parlé de votre base.[pause=25] On est les spécialistes qu'il vous faut !")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Moi c'est Okéoké, et lui c'est Qulbutoké.[pause=20] On a construit des dizaines de bases dans toute la région.")
  GAME:WaitFrames(15)

  -- Qulbutoké — fier
  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("Toké toké ! Qulbutoké !")
  GAME:WaitFrames(8)

  -- Okéoké
  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Il dit que notre dernière base a tenu dix ans sans une fissure.[pause=25] Et c'est vrai !")
  GAME:WaitFrames(15)

  -- Le partenaire — pratique
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Super ! Alors...[pause=20] qu'est-ce qu'il nous faut ?")
  GAME:WaitFrames(10)

  -- Okéoké — la mission
  UI:SetSpeaker(wynaut)
  UI:WaitShowDialogue("Des matériaux.[pause=25] Du bois, de la pierre, des lianes solides.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Et il y a un endroit parfait pour les trouver : le Bois Brouhaha.")
  GAME:WaitFrames(15)

  -- Qulbutoké — inquiet
  UI:SetSpeaker(wobbuffet)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Qul... butoké.")
  GAME:WaitFrames(10)

  -- Okéoké — explique le problème
  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Il y a un petit problème.[pause=25] Le Bois Brouhaha est... occupé.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Un groupe de Pokémon s'y est installé.[pause=20] Un Papilusion, un Chenipan et un Boustiflor.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Ils sont très territoriaux depuis quelque temps.[pause=25] Personne n'ose y entrer.")
  GAME:WaitFrames(15)

  -- Le héros — pense
  GeneralFunctions.HeroDialogue(hero, "(Territoriaux...[pause=25] Encore un effet de la corruption du Cœur, peut-être ?[pause=20] Les Pokémon deviennent anxieux quand l'équilibre se brise.)", "Worried")
  GAME:WaitFrames(15)

  -- Le partenaire — déterminé
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("On va les voir.[pause=25] On leur expliquera qu'on n'est pas une menace.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Et s'ils ne veulent pas écouter...[pause=20] on se défendra, et on prendra les matériaux quand même.")
  GAME:WaitFrames(15)

  -- Qulbutoké — approbation
  pcall(function() GROUND:CharSetEmote(wobbuffet, "happy", 1) end)
  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("QULBUTOKÉ !")
  GAME:WaitFrames(8)

  -- Okéoké
  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Il dit : « Voilà l'attitude d'un vrai constructeur ! »")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Le Bois Brouhaha est au nord-ouest de Metano.[pause=25] Cinq étages, pas plus.[pause=20] Les matériaux sont au dernier niveau.")
  GAME:WaitFrames(15)

  -- Chenipan — arrive timidement
  local caterpie = CharacterEssentials.MakeCharactersFromList({
    {'Caterpie', 260, 160, Direction.Right}
  })
  pcall(function() GROUND:CharAnimateTurnTo(caterpie, Direction.Right, 4) end)
  GAME:WaitFrames(8)

  UI:SetSpeaker(wynaut)
  UI:WaitShowDialogue("Ah, et voici Chenipan ! Il connaît le Bois Brouhaha comme sa poche.")
  GAME:WaitFrames(8)
  UI:WaitShowDialogue("Il veut venir avec vous, si ça ne vous dérange pas.")
  GAME:WaitFrames(10)

  -- Chenipan — timide
  UI:SetSpeaker(caterpie)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Euh...[pause=20] oui...[pause=15] si vous voulez bien de moi...[pause=20] je connais les chemins.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Et...[pause=20] Papilusion et les autres...[pause=25] ce sont mes amis, en fait.[pause=20] Avant qu'ils deviennent comme ça.")
  GAME:WaitFrames(15)

  -- Le partenaire — bienveillant
  GROUND:CharTurnToCharAnimated(partner, caterpie, 4)
  GAME:WaitFrames(6)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Bien sûr que tu viens avec nous ![pause=25] Tu pourras peut-être les raisonner.")
  GAME:WaitFrames(10)

  -- Chenipan — soulagé
  pcall(function() GROUND:CharSetEmote(caterpie, "happy", 1) end)
  UI:SetSpeaker(caterpie)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Merci ! Je vais faire de mon mieux !")
  GAME:WaitFrames(20)

  -- Départ
  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Parfait ! Allez-y, et rapportez-nous ces matériaux !")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("On vous attend ici pour commencer la construction dès votre retour.")
  GAME:WaitFrames(20)

  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 40)
  GAME:WaitFrames(40)

  SV.BaseConstruction.Recruited = true
  SV.BaseConstruction.CaterpieJoined = true
  GAME:CutsceneMode(false)
end

--------------------------------------------------------------------
-- ACTE 3 — BOSS DU BOIS BROUHABA (pré-combat)
--------------------------------------------------------------------
function BaseConstruction.Act3_BossIntro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- Arrivée au dernier étage du donjon — clairière
  GAME:MoveCamera(180, 140, 1, false)
  GAME:WaitFrames(30)

  -- Papilusion, Chenipan et Boustiflor
  local butterfree = CharacterEssentials.MakeCharactersFromList({
    {'Butterfree', 180, 100, Direction.Down}
  })
  local bellsprout = CharacterEssentials.MakeCharactersFromList({
    {'Bellsprout', 140, 120, Direction.DownRight}
  })
  local wild_caterpie = CharacterEssentials.MakeCharactersFromList({
    {'Caterpie', 220, 120, Direction.DownLeft}
  })

  -- Chenipan (allié) essaie de parler
  local ally_caterpie = CH('Teammate2')
  if ally_caterpie == nil then ally_caterpie = CH('Caterpie') end

  pcall(function()
    GROUND:CharAnimateTurnTo(butterfree, Direction.Down, 4)
    GROUND:CharAnimateTurnTo(bellsprout, Direction.DownRight, 4)
  end)
  GAME:WaitFrames(10)

  -- Chenipan allié — essaie de raisonner
  pcall(function()
    GROUND:MoveToPosition(ally_caterpie, 180, 140, false, 1)
    GROUND:CharAnimateTurnTo(ally_caterpie, Direction.Up, 4)
  end)
  GAME:WaitFrames(10)

  UI:SetSpeaker(ally_caterpie)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Papilusion ![pause=20] C'est moi ! Chenipan !")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Ces Pokémon ne sont pas méchants ![pause=25] Ils viennent chercher du bois, c'est tout !")
  GAME:WaitFrames(15)

  -- Papilusion — territorial, anxieux
  UI:SetSpeaker(butterfree)
  UI:SetSpeakerEmotion("Angry")
  UI:WaitShowDialogue("Du bois ?[pause=20] Ils viennent TOUJOURS pour le bois !")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Et après ils coupent nos arbres ! Ils détruisent nos fleurs ! Ils piétinent nos nids !")
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(butterfree, "angry", 1) end)
  UI:WaitShowDialogue("Personne ne touche à notre forêt ! PERSONNE !")
  GAME:WaitFrames(15)

  -- Boustiflor — dramatique
  UI:SetSpeaker(bellsprout)
  UI:SetSpeakerEmotion("Angry")
  UI:WaitShowDialogue("DEHORS ! Tous dehors ! Cette clairière est à NOUS !")
  GAME:WaitFrames(10)

  -- Chenipan sauvage — timide
  UI:SetSpeaker(wild_caterpie)
  UI:SetSpeakerEmotion("Sad")
  UI:WaitShowDialogue("...Je... je suis désolé, Chenipan.[pause=25] Mais Papilusion a raison.[pause=20] On ne peut plus faire confiance à personne.")
  GAME:WaitFrames(15)

  -- Le partenaire — comprend
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(6)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Sad")
  UI:WaitShowDialogue("Ils ont peur...[pause=25] C'est la corruption du Cœur.[pause=20] Elle rend tout le monde anxieux et territorial.")
  GAME:WaitFrames(10)

  -- Le héros — déterminé mais respectueux
  GeneralFunctions.HeroDialogue(hero, "(On ne va pas les blesser plus que nécessaire.[pause=25] Juste les calmer assez pour qu'ils écoutent.)", "Determined")
  GAME:WaitFrames(15)

  -- Papilusion — charge
  UI:SetSpeaker(butterfree)
  UI:SetSpeakerEmotion("Angry")
  UI:WaitShowDialogue("Assez parlé ! DEHORS !")
  GAME:WaitFrames(10)

  -- Transition combat
  SOUND:PlayBGM('Rising Fear.ogg', true)
  GAME:WaitFrames(20)
  COMMON.BossTransition()

  SV.BaseConstruction.BossFought = true
  GAME:CutsceneMode(false)
end

--------------------------------------------------------------------
-- ACTE 4 — LA CONSTRUCTION (base, ~60 dialogues)
--------------------------------------------------------------------
function BaseConstruction.Act4_Construction()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()
  SOUND:PlayBGM('Sky Peak Prairie.ogg', true)

  -- Les trois boss vaincus — calmés, pas humiliés
  local butterfree = CharacterEssentials.MakeCharactersFromList({
    {'Butterfree', 140, 200, Direction.Right}
  })
  local bellsprout = CharacterEssentials.MakeCharactersFromList({
    {'Bellsprout', 100, 220, Direction.Right}
  })
  local wild_caterpie = CharacterEssentials.MakeCharactersFromList({
    {'Caterpie', 180, 220, Direction.Up}
  })

  -- Qulbutoké et Okéoké arrivent
  local wobbuffet = CharacterEssentials.MakeCharactersFromList({
    {'Wobbuffet', 260, 180, Direction.Left}
  })
  local wynaut = CharacterEssentials.MakeCharactersFromList({
    {'Wynaut', 290, 200, Direction.Left}
  })

  GAME:MoveCamera(200, 200, 1, false)
  GAME:WaitFrames(20)

  -- Papilusion — calmé, honteux
  UI:SetSpeaker(butterfree)
  UI:SetSpeakerEmotion("Sad")
  UI:WaitShowDialogue("Je... je suis désolé.[pause=25] Je ne sais pas ce qui m'a pris.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Depuis que l'air a changé, je...[pause=20] je vois des menaces partout.")
  GAME:WaitFrames(15)

  -- Le partenaire — bienveillant
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Ce n'est pas ta faute.[pause=25] Le Cœur de la région est malade, et ça vous affecte tous.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Mais maintenant, on a purifié le Cœur des Ruines.[pause=25] L'air va redevenir normal.")
  GAME:WaitFrames(15)

  -- Chenipan allié — réconciliation
  pcall(function() GROUND:MoveToPosition(CH('Caterpie'), 160, 210, false, 1) end)
  GAME:WaitFrames(8)
  UI:SetSpeaker(CH('Caterpie'))
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Tu vois, Papilusion ?[pause=25] Ils ont réparé le Cœur ! C'est pour ça que l'air est meilleur !")
  GAME:WaitFrames(15)

  -- Papilusion — reconnaissant
  pcall(function() GROUND:CharSetEmote(butterfree, "happy", 1) end)
  UI:SetSpeaker(butterfree)
  UI:WaitShowDialogue("Alors... c'est grâce à vous ?[pause=25] C'est pour ça que je me sens... mieux ?")
  GAME:WaitFrames(10)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Dans ce cas... prenez tout le bois que vous voulez.[pause=25] Et on va vous aider à construire.")
  GAME:WaitFrames(15)

  -- Boustiflor — enthousiaste
  UI:SetSpeaker(bellsprout)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Oui ! Je suis doué en charpente, moi ![pause=25] Mes racines, c'est comme des outils !")
  GAME:WaitFrames(10)

  -- Okéoké — le chef de chantier
  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Parfait ! Tout le monde au travail !")
  GAME:WaitFrames(10)

  -- Qulbutoké — dirige
  pcall(function() GROUND:CharSetEmote(wobbuffet, "determined", 1) end)
  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("QULBUTOKÉ ! Toké toké qulbu !")
  GAME:WaitFrames(8)

  -- Okéoké traduit
  UI:SetSpeaker(wynaut)
  UI:WaitShowDialogue("Il dit : « Boustiflor aux fondations ! Papilusion, transporte les poutres en volant ! Chenipan, assemble les feuilles pour le toit ! »")
  GAME:WaitFrames(15)

  -- Le partenaire — participe
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Et nous ?[pause=20] On fait quoi ?")
  GAME:WaitFrames(8)

  -- Okéoké
  UI:SetSpeaker(wynaut)
  UI:WaitShowDialogue("Vous ?[pause=20] Vous portez les pierres.[pause=25] C'est lourd.")
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  UI:SetSpeaker(partner)
  UI:WaitShowDialogue("...Évidemment.")
  GAME:WaitFrames(20)

  -- MONTAGE DE CONSTRUCTION (coroutines parallèles)
  -- Boustiflor creuse
  local build1 = TASK:BranchCoroutine(function()
    pcall(function()
      GROUND:MoveToPosition(bellsprout, 120, 260, false, 2)
      GROUND:CharSetAnim(bellsprout, "Attack", true)
      GAME:WaitFrames(30)
      GROUND:CharSetAnim(bellsprout, "Idle", true)
      GROUND:MoveToPosition(bellsprout, 160, 260, false, 2)
      GROUND:CharSetAnim(bellsprout, "Attack", true)
      GAME:WaitFrames(30)
      GROUND:CharSetAnim(bellsprout, "Idle", true)
    end)
  end)

  -- Papilusion vole avec des poutres
  local build2 = TASK:BranchCoroutine(function()
    pcall(function()
      GROUND:MoveToPosition(butterfree, 200, 160, false, 3)
      GAME:WaitFrames(20)
      GROUND:MoveToPosition(butterfree, 140, 240, false, 3)
      GAME:WaitFrames(20)
      GROUND:MoveToPosition(butterfree, 240, 160, false, 3)
      GAME:WaitFrames(20)
      GROUND:MoveToPosition(butterfree, 180, 240, false, 3)
    end)
  end)

  -- Le duo porte des pierres
  local build3 = TASK:BranchCoroutine(function()
    pcall(function()
      GROUND:MoveToPosition(hero, 260, 260, false, 2)
      GAME:WaitFrames(15)
      GROUND:MoveToPosition(hero, 140, 280, false, 2)
      GAME:WaitFrames(15)
      GROUND:MoveToPosition(hero, 280, 260, false, 2)
    end)
  end)

  local build4 = TASK:BranchCoroutine(function()
    pcall(function()
      GAME:WaitFrames(8)
      GROUND:MoveToPosition(partner, 280, 280, false, 2)
      GAME:WaitFrames(15)
      GROUND:MoveToPosition(partner, 160, 280, false, 2)
      GAME:WaitFrames(15)
      GROUND:MoveToPosition(partner, 260, 280, false, 2)
    end)
  end)

  -- Narration pendant le montage
  local narration = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    UI:ResetSpeaker()
    UI:SetCenter(true)
    UI:WaitShowTimedDialogue("Le chantier bat son plein.[pause=20] Boustiflor creuse les fondations avec ses racines.[pause=25] Papilusion transporte les poutres en voltigeant.", 100)
    GAME:WaitFrames(40)
    UI:WaitShowTimedDialogue("Chenipan tisse le toit avec des feuilles imperméables.[pause=25] Qulbutoké supervise en criant des instructions que seul Okéoké comprend.", 100)
    GAME:WaitFrames(40)
    UI:WaitShowTimedDialogue("Le héros et son partenaire portent des pierres.[pause=20] Beaucoup de pierres.[pause=25] Vraiment beaucoup.", 80)
    UI:SetCenter(false)
  end)

  TASK:JoinCoroutines({build1, build2, build3, build4, narration})
  GAME:WaitFrames(30)

  SV.BaseConstruction.BuiltPhase1 = true
  GAME:CutsceneMode(false)
end

--------------------------------------------------------------------
-- ACTE 5 — LA GRÈVE (comédie, ~40 dialogues)
--------------------------------------------------------------------
function BaseConstruction.Act5_Strike()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:PlayBGM('Sky Peak Prairie.ogg', true)

  -- Boustiflor s'arrête brusquement
  local bellsprout = CH('Bellsprout')
  local wobbuffet = CH('Wobbuffet')
  local wynaut = CH('Wynaut')

  pcall(function()
    GROUND:CharSetAnim(bellsprout, "Idle", true)
    GROUND:CharSetEmote(bellsprout, "angry", 1)
  end)
  GAME:WaitFrames(10)

  -- Boustiflor — la grève
  UI:SetSpeaker(bellsprout)
  UI:SetSpeakerEmotion("Angry")
  UI:WaitShowDialogue("STOP ! J'arrête tout !")
  GAME:WaitFrames(10)

  -- Tout le monde se tourne
  pcall(function()
    GROUND:CharAnimateTurnTo(hero, bellsprout, 4)
    GROUND:CharAnimateTurnTo(partner, bellsprout, 4)
    GROUND:CharAnimateTurnTo(wobbuffet, bellsprout, 4)
    GROUND:CharAnimateTurnTo(wynaut, bellsprout, 4)
  end)
  GAME:WaitFrames(8)

  -- Le partenaire — surpris
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue("Quoi ?[pause=20] Pourquoi ?")
  GAME:WaitFrames(10)

  -- Boustiflor — exige
  UI:SetSpeaker(bellsprout)
  UI:SetSpeakerEmotion("Angry")
  UI:WaitShowDialogue("Mes fleurs ont besoin de SUCRE !")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("La résine que je produis pour la charpente, ça consomme du sucre !")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Et je n'ai plus de Baies Sucrées !")
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(bellsprout, "angry", 1) end)
  UI:WaitShowDialogue("Pas de Baies Sucrées = pas de résine = pas de charpente = pas de base !")
  GAME:WaitFrames(15)

  -- Okéoké traduit la frustration de Qulbutoké
  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Qulbutoké dit que c'est du chantage.")
  GAME:WaitFrames(8)

  -- Qulbutoké — furieux
  UI:SetSpeaker(wobbuffet)
  UI:SetSpeakerEmotion("Angry")
  UI:WaitShowDialogue("QULBUTOKÉ !!!")
  GAME:WaitFrames(10)

  -- Okéoké
  UI:SetSpeaker(wynaut)
  UI:WaitShowDialogue("Il dit aussi que c'est la troisième fois que ça arrive sur un chantier.")
  GAME:WaitFrames(10)

  -- Le héros — pragmatique
  GeneralFunctions.HeroDialogue(hero, "(Des Baies Sucrées...[pause=25] J'en ai peut-être dans le sac ?)", "Normal")
  GAME:WaitFrames(10)

  -- Choix : donner des baies ou aller en chercher
  UI:ChoiceMenu("Avez-vous des Baies Sucrées ?", true)
  UI:AddChoice("Oui, en voici !")
  UI:AddChoice("Non, je vais en chercher au marché")
  UI:WaitForChoice()
  local choice = UI:ChoiceResult()
  GAME:WaitFrames(10)

  if choice == 1 then
    -- Le héros donne les baies
    UI:SetSpeaker(bellsprout)
    UI:SetSpeakerEmotion("Happy")
    pcall(function() GROUND:CharSetEmote(bellsprout, "happy", 2) end)
    UI:WaitShowDialogue("Des Baies Sucrées ![pause=20] Vous en aviez ?![pause=25] Pourquoi vous ne les avez pas données TOUT DE SUITE ?")
    GAME:WaitFrames(10)
    UI:WaitShowDialogue("Bon, au travail ! La résine va couler à flots !")
  else
    -- Le héros va au marché
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Je cours chez Kecleon ![pause=20] Ne bougez pas !")
    GAME:WaitFrames(20)

    -- Fondu rapide
    GAME:FadeOut(false, 20)
    GAME:WaitFrames(30)
    GAME:FadeIn(20)
    GAME:WaitFrames(10)

    -- Retour avec les baies
    UI:SetSpeaker(bellsprout)
    UI:SetSpeakerEmotion("Happy")
    pcall(function() GROUND:CharSetEmote(bellsprout, "happy", 2) end)
    UI:WaitShowDialogue("Mmmh...[pause=20] des Baies Sucrées bien juteuses !")
    GAME:WaitFrames(10)
    UI:WaitShowDialogue("La grève est terminée ! Au travail !")
  end
  GAME:WaitFrames(15)

  -- Papilusion — pique
  local butterfree = CH('Butterfree')
  pcall(function() GROUND:CharAnimateTurnTo(butterfree, bellsprout, 4) end)
  UI:SetSpeaker(butterfree)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Tu fais ça à CHAQUE chantier, Boustiflor.")
  GAME:WaitFrames(8)

  -- Boustiflor — sans honte
  UI:SetSpeaker(bellsprout)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Et ça marche à chaque fois !")
  GAME:WaitFrames(15)

  -- Reprise du travail — fondu
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 40)
  GAME:WaitFrames(40)

  SV.BaseConstruction.StrikeResolved = true
  GAME:CutsceneMode(false)
end

--------------------------------------------------------------------
-- ACTE 6 — L'INAUGURATION (base, ~50 dialogues)
--------------------------------------------------------------------
function BaseConstruction.Act6_Inauguration()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:PlayBGM('Sky Peak Prairie.ogg', true)

  -- La base est terminée — tous les PNJ présents
  local tropius = CH('Tropius')
  local butterfree = CH('Butterfree')
  local bellsprout = CH('Bellsprout')
  local caterpie = CH('Caterpie')
  local wobbuffet = CH('Wobbuffet')
  local wynaut = CH('Wynaut')

  GAME:WaitFrames(30)

  -- Penticus inaugure
  UI:SetSpeaker(tropius)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Au nom de la Guilde de Metano...")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("J'ai l'honneur d'inaugurer la base de notre équipe la plus prometteuse !")
  GAME:WaitFrames(15)

  -- Le partenaire — émerveillé
  pcall(function() GROUND:CharSetEmote(partner, "happy", 2) end)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue("Notre base...[pause=25] C'est... c'est magnifique.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Il y a un coin pour dormir, un coin pour préparer les missions, un stockage...")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("C'est chez nous.")
  GAME:WaitFrames(15)

  -- Boustiflor — fier
  UI:SetSpeaker(bellsprout)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("La charpente, c'est moi ! Et elle tiendra cent ans !")
  GAME:WaitFrames(8)

  -- Papilusion — modeste
  UI:SetSpeaker(butterfree)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Les poutres aussi, c'est nous.[pause=25] Mais on ne va pas se vanter.")
  GAME:WaitFrames(10)

  -- Chenipan — timide mais heureux
  UI:SetSpeaker(caterpie)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Le toit, c'est mes feuilles...[pause=25] Elles sont imperméables, j'ai vérifié trois fois.")
  GAME:WaitFrames(10)

  -- Qulbutoké — satisfaction
  pcall(function() GROUND:CharSetEmote(wobbuffet, "happy", 1) end)
  UI:SetSpeaker(wobbuffet)
  UI:WaitShowDialogue("Qulbutoké !")
  GAME:WaitFrames(8)

  -- Okéoké
  UI:SetSpeaker(wynaut)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Il dit : « Encore un chantier réussi ! »")
  GAME:WaitFrames(15)

  -- Penticus — transition vers la trame principale
  UI:SetSpeaker(tropius)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Profitez de votre base.[pause=25] Vous l'avez méritée.")
  GAME:WaitFrames(10)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Mais...[pause=20] j'ai aussi des nouvelles.")
  GAME:WaitFrames(15)

  -- Transition vers ch8
  UI:WaitShowDialogue("Un nouveau rapport vient d'arriver.[pause=25] Un autre Cœur d'Anima faiblit.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Cette fois, c'est au nord-est.[pause=25] Au Sanctuaire de Cristal.")
  GAME:WaitFrames(15)

  -- Le partenaire — la mission continue
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(6)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Le Sanctuaire de Cristal...[pause=25] Un autre Cœur à protéger.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("On a une base maintenant.[pause=25] On peut se préparer correctement.")
  GAME:WaitFrames(15)

  -- Le héros — détermination
  GeneralFunctions.HeroDialogue(hero, "(Notre base.[pause=25] Notre équipe.[pause=20] Et une mission qui ne fait que commencer.)", "Determined")
  GAME:WaitFrames(20)

  -- Fin
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  SV.BaseConstruction.Complete = true
  SV.BaseConstruction.BaseUnlocked = true
  -- Prépare la transition vers ch8
  SV.TemporaryFlags.MorningAddress = true
  GAME:CutsceneMode(false)
end

return BaseConstruction
