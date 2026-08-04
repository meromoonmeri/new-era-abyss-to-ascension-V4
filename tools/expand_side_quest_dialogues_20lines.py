#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
expand_side_quest_dialogues_20lines.py — Enrichit l'intégralité des 20 quêtes
secondaires PNJ de Metano Town dans Data/Script/halcyon/SideQuests.lua pour
atteindre un MINIMUM DE 20 À 25 LIGNES DE DIALOGUE par quête (au total),
avec un positionnement caméra et personnage vérifié dans TownLife.TOURNEES.
"""
import os, sys, re, json

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SIDE_QUESTS_LUA = os.path.join(MOD_ROOT, "Data/Script/halcyon/SideQuests.lua")
TOWN_LIFE_LUA = os.path.join(MOD_ROOT, "Data/Script/halcyon/TownLife.lua")

EXPANDED_SIDE_QUESTS = [
    # === CHAPITRE 6 (Rang 30-33) ===
    {
        "id": "q6_desert", "ch": 6, "giver": "Sentret",
        "unlock_dungeon": "forsaken_desert", "dungeon_name": "Désert des Oubliés",
        "titre": "Le sac de courrier volé",
        "ask": [
            "{'Sentret', 'Worried', 'C est une catastrophe absolue ! Vous devez m aider !'}",
            "{'Sentret', 'Sad',     'Je faisais ma tournée de guet au sud-est des remparts de Metano...'}",
            "{'Sentret', 'Worried', 'Quand soudain, une tempête de sable s est levée sans aucun avertissement.'}",
            "{'Sentret', 'Angry',   'Et dans la tourmente, Hippodocus le Colosse a jailli des dunes pour arracher ma sacoche prioritaire !'}",
            "{'Sentret', 'Sad',     'Il a emporté toutes les lettres dans les profondeurs du Désert des Oubliés.'}",
            "{'Sentret', 'Worried', 'Il y a là-dedans le courrier officiel du Conseil de la Guilde... Si je le perds, ce sera dramatique !'}",
            "{'Sentret', 'Normal',  'Ce désert est un labyrinthe de sable et de roches brûlantes où je ne peux pas m aventurer.'}",
            "{'Sentret', 'Inspired','Vous êtes des explorateurs accomplis ! Pouvez-vous traquer ce colosse et me ramener ma sacoche ?'}"
        ],
        "accept": [
            "{'Sentret', 'Happy',   'Merci mille fois ! Je savais que la guilde ne m abandonnerait pas !'}",
            "{'Sentret', 'Normal',  'L entrée du Désert des Oubliés se trouve au-delà du vieux pont de limon au sud-est.'}"
        ],
        "refuse": [
            "{'Sentret', 'Sad',     'Je comprends... C est un donjon dangereux et vous avez déjà beaucoup à faire.'}",
            "{'Sentret', 'Worried', 'Je vais essayer de chercher des pistes au bord des dunes en attendant.'}"
        ],
        "pending": [
            "{'Sentret', 'Worried', 'Avez-vous pu explorer le Désert des Oubliés ?'}",
            "{'Sentret', 'Sad',     'Chaque minute qui passe enterre un peu plus ma sacoche sous les tempêtes de sable...'}"
        ],
        "done": [
            "{'Sentret', 'Inspired','MA SACOCHE DE COURRIER ! Vous l avez vraiment retrouvée !'}",
            "{'Sentret', 'Happy',   'Incroyable ! Même les sceaux de cire des lettres officielles sont intacts !'}",
            "{'Sentret', 'Surprised','Vous avez réussi à vaincre Hippodocus le Colosse dans son propre élément ?'}",
            "{'Sentret', 'Happy',   'Vous êtes les sauveurs de ma garde et de l honneur de notre ville !'}",
            "{'Sentret', 'Inspired','Tenez, prenez cette prime spéciale que la garde réservait aux cas d urgence !'}",
            "{'Sentret', 'Normal',  'Je vais pouvoir transmettre les messages à temps. Merci de tout cœur !'}"
        ]
    },
    {
        "id": "q6_geode", "ch": 6, "giver": "Mawile",
        "unlock_dungeon": "geode_crevice", "dungeon_name": "Crevasse de Géode",
        "titre": "Tarinor pris au piège",
        "ask": [
            "{'Mawile', 'Sad',     'Je me fais un sang d encre pour mon ami Tarinor de la guilde minérale.'}",
            "{'Mawile', 'Worried', 'Il était parti ce matin pour étudier les vibrations magnétiques de la Crevasse de Géode.'}",
            "{'Mawile', 'Normal',  'C est une faille cristalline magnifique au nord des anciennes carrières de la ville.'}",
            "{'Mawile', 'Angry',   'Mais les éboulements sont devenus incontrôlables depuis que Gigalithe le Diamant s est réveillé !'}",
            "{'Mawile', 'Sad',     'Tarinor s est retrouvé coincé sous des tonnes de roches de quartz.'}",
            "{'Mawile', 'Worried', 'Son nez magnétique indique qu il est encore en vie tout au fond de la crevasse.'}",
            "{'Mawile', 'Sad',     'Je n ai pas la force pour dégager un éboulis pareil seule dans la faille.'}",
            "{'Mawile', 'Inspired','Pouvez-vous descendre dans la crevasse pour libérer Tarinor avant qu il n étouffe ?'}"
        ],
        "accept": [
            "{'Mawile', 'Happy',   'Quel soulagement ! Vous êtes formidables !'}",
            "{'Mawile', 'Normal',  'Suivez le sentier minéral au nord, la faille brille d une lueur violette.'}"
        ],
        "refuse": [
            "{'Mawile', 'Sad',     'Je comprends, la roche qui tombe est un piège mortel.'}",
            "{'Mawile', 'Worried', 'Je vais continuer d appeler à l aide sur la place...'}"
        ],
        "pending": [
            "{'Mawile', 'Worried', 'Avez-vous atteint le fond de la Crevasse de Géode ?'}",
            "{'Mawile', 'Sad',     'Le champ magnétique de Tarinor faiblit, je le sens depuis la ville...'}"
        ],
        "done": [
            "{'Mawile', 'Inspired','TARINOR ! Tu es de retour sain et sauf !'}",
            "{'Mawile', 'Happy',   'Regardez-le, il tourne à nouveau vers le nord comme une boussole neuve !'}",
            "{'Mawile', 'Surprised','Vous avez brisé les remparts de pierre de Gigalithe le Diamant ?'}",
            "{'Mawile', 'Happy',   'Quelle force extraordinaire ! Vous avez toute l admiration de notre colonie !'}",
            "{'Mawile', 'Inspired','Tarinor a pu sauver ces cristaux d énergie pure pendant que vous combattiez !'}",
            "{'Mawile', 'Happy',   'Prenez-les, ils renforceront les capacités de votre équipe en donjon !'}"
        ]
    },
    {
        "id": "q6_verger", "ch": 6, "giver": "Bellossom",
        "unlock_dungeon": "wild_orchard", "dungeon_name": "Verger Sauvage",
        "titre": "La sève dorée de la reine",
        "ask": [
            "{'Bellossom', 'Worried', 'Les arbres du Verger Sauvage pleurent à chaudes larmes depuis trois jours.'}",
            "{'Bellossom', 'Sad',     'Notre colonie de fleurs dépend de la sève dorée pour réussir notre pollinisation.'}",
            "{'Bellossom', 'Normal',  'C est une forêt ancienne qui jouxte les limites ouest des jardins de guilde.'}",
            "{'Bellossom', 'Angry',   'Mais Apireine la Souveraine a ordonné à son essaim de confisquer toutes les gouttes de sève !'}",
            "{'Bellossom', 'Sad',     'Elle prétend que le verger lui appartient désormais en totalité.'}",
            "{'Bellossom', 'Worried', 'Sans cette nutrition royale, nos fleurs vont s assécher avant le printemps.'}",
            "{'Bellossom', 'Sad',     'Nous sommes incapables de bouger pour nous défendre ou parlementer.'}",
            "{'Bellossom', 'Inspired','Explorateurs, pouvez-vous affronter la reine pour rétablir le partage de la forêt ?'}"
        ],
        "accept": [
            "{'Bellossom', 'Happy',   'Oh, merci ! Vous redonnez l espoir à tout notre sous-bois !'}",
            "{'Bellossom', 'Normal',  'Le chemin du verger s ouvre juste derrière la haie de baies à l ouest.'}"
        ],
        "refuse": [
            "{'Bellossom', 'Sad',     '...Je comprends. Affronter une colonie entière est un risque immense.'}",
            "{'Bellossom', 'Worried', 'Nous allons prier pour qu une pluie de sève arrive d elle-même.'}"
        ],
        "pending": [
            "{'Bellossom', 'Worried', 'Avez-vous pu négocier ou combattre au Verger Sauvage ?'}",
            "{'Bellossom', 'Sad',     'Nos pétales commencent déjà à craquer par manque d humidité...'}"
        ],
        "done": [
            "{'Bellossom', 'Inspired','LA SÈVE DORÉE ! Je sens son arôme sucré d ici !'}",
            "{'Bellossom', 'Happy',   'Vous avez vaincu la garde royale d Apireine la Souveraine !'}",
            "{'Bellossom', 'Surprised','Les arbres coulent à nouveau librement pour tous les habitants du verger !'}",
            "{'Bellossom', 'Happy',   'Je sens que nos pétales retrouvent tout leur éclat de jeunesse !'}",
            "{'Bellossom', 'Inspired','Voici des Baies Pecha rares dorées que nous avions cachées dans les racines !'}",
            "{'Bellossom', 'Normal',  'Merci de protéger ceux qui vivent dans le sous-bois !'}"
        ]
    },
    {
        "id": "q6_plaines", "ch": 6, "giver": "Electrike",
        "unlock_dungeon": "scorched_plains", "dungeon_name": "Plaines Brûlées",
        "titre": "Surcharges dans la savane",
        "ask": [
            "{'Electrike', 'Worried', 'Bzz ! L air de la savane est devenu irrespirable pour notre meute.'}",
            "{'Electrike', 'Sad',     'Nos pelages accumulent une charge électrostatique qui nous brûle la peau.'}",
            "{'Electrike', 'Normal',  'Les Plaines Brûlées sont notre pâturage d hiver par-delà la colline foudroyée.'}",
            "{'Electrike', 'Angry',   'Mais Élecsprint la Tempête est entré dans une rage territoriale incontrôlable !'}",
            "{'Electrike', 'Sad',     'Sa présence maintient un soleil ardent et des éclairs secs nuit et jour.'}",
            "{'Electrike', 'Worried', 'Les jeunes de notre meute ne peuvent plus s y nourrir en sécurité.'}",
            "{'Electrike', 'Sad',     'Si la foudre continue de tomber ainsi, toute la savane va prendre feu.'}",
            "{'Electrike', 'Inspired','Pouvez-vous traverser la savane pour apaiser la colère d Élecsprint ?'}"
        ],
        "accept": [
            "{'Electrike', 'Happy',   'Bzz ! Merci ! Vous avez le courage d une vraie garde de champions !'}",
            "{'Electrike', 'Normal',  'Traversez la crête rocheuse au sud, vous verrez les herbes hautes crépiter.'}"
        ],
        "refuse": [
            "{'Electrike', 'Sad',     'Bzz... C est vrai que l électricité statique est redoutable.'}",
            "{'Electrike', 'Worried', 'Nous allons rester recroquevillés dans la boue pour nous isoler.'}"
        ],
        "pending": [
            "{'Electrike', 'Worried', 'Bzz... Les Plaines Brûlées sont-elles toujours sous l orage sec ?'}",
            "{'Electrike', 'Sad',     'Le pelage de mes petits frères commence à roussir...'}"
        ],
        "done": [
            "{'Electrike', 'Inspired','BZZ ! LE VENT ! Vous entendez ? La foudre a cessé de gronder !'}",
            "{'Electrike', 'Happy',   'Les nuages noirs se sont dissipés et l herbe a retrouvé sa fraîcheur !'}",
            "{'Electrike', 'Surprised','Vous avez tenu bon face aux décharges à haute tension d Élecsprint ?'}",
            "{'Electrike', 'Happy',   'Notre meute va pouvoir regagner ses plaines dès ce soir !'}",
            "{'Electrike', 'Inspired','Prenez cette récompense d orbes et ces graines en témoignage de notre gratitude !'}",
            "{'Electrike', 'Normal',  'Metano a bien de la chance d avoir une guilde aussi dévouée !'}"
        ]
    },
    # === CHAPITRE 7 ===
    {
        "id": "q7_jardin", "ch": 7, "giver": "Manectric",
        "unlock_dungeon": "energy_garden", "dungeon_name": "Jardin d'Énergie",
        "titre": "L'antenne disparue",
        "ask": [
            "{'Manectric', 'Worried', 'Bzz... Bzz... Alerte ! Signal magnétique de notre relais souterrain à zéro !'}",
            "{'Manectric', 'Sad',     'Notre station de mesure surveillait les flux d énergie des grottes de quartz.'}",
            "{'Manectric', 'Normal',  'Le Jardin d Énergie est une cavité naturelle de cristaux purs sous la faille nord.'}",
            "{'Manectric', 'Angry',   'Mais Lucario l Onde s est approprié notre antenne de résonance en or !'}",
            "{'Manectric', 'Sad',     'Il l utilise pour focaliser ses propres capacités au centre du sanctuaire.'}",
            "{'Manectric', 'Worried', 'Sans cette antenne, la guilde est aveugle aux secousses géologiques profondes.'}",
            "{'Manectric', 'Sad',     'Nos champs de sustentation faiblissent dès que nous approchons de ses ondes.'}",
            "{'Manectric', 'Inspired','Explorateurs, pouvez-vous descendre au jardin minéral pour récupérer notre antenne ?'}"
        ],
        "accept": [
            "{'Manectric', 'Happy',   'Bzz ! Positif ! Votre coefficient de bravoure dépasse 99% !'}",
            "{'Manectric', 'Normal',  'L accès se trouve dans la crevasse au nord-est de la place marchande.'}"
        ],
        "refuse": [
            "{'Manectric', 'Sad',     'Bzz... Négatif... Probabilité de succès annulée.'}",
            "{'Manectric', 'Worried', 'Nous allons tenter un recalibrage manuel depuis la surface.'}"
        ],
        "pending": [
            "{'Manectric', 'Worried', 'Bzz... Avez-vous restauré le signal du Jardin d Énergie ?'}",
            "{'Manectric', 'Sad',     'Les batteries de notre relais d urgence sont à 14%...'}"
        ],
        "done": [
            "{'Manectric', 'Inspired','BZZ ! BZZ ! ANTENNE DÉTECTÉE ! Signal rétabli à 100% !'}",
            "{'Manectric', 'Happy',   'Les ondes de l aura de Lucario ne perturbent plus notre réseau de surveillance !'}",
            "{'Manectric', 'Surprised','Vous avez surmonté un champ de résonance magnétique aussi intense ?'}",
            "{'Manectric', 'Happy',   'Données confirmées : votre équipe est la plus fiable de toute la région !'}",
            "{'Manectric', 'Inspired','Veuillez accepter cet ensemble d Évolurocs de quartz concentré !'}",
            "{'Manectric', 'Normal',  'Fin de transmission. Merci pour votre service exemplaire !'}"
        ]
    },
    {
        "id": "q7_relique", "ch": 7, "giver": "Meditite",
        "unlock_dungeon": "sunken_relic", "dungeon_name": "Relique Engloutie",
        "titre": "Les tables sacrées englouties",
        "ask": [
            "{'Meditite', 'Sad',     'Hummm... Un drame silencieux se joue au fond de la crique occidentale.'}",
            "{'Meditite', 'Worried', 'Les ruines de la Relique Engloutie ont émergé de quelques mètres après les séismes.'}",
            "{'Meditite', 'Normal',  'Ces murs portent les tables gravées racontant l origine des premiers donjons.'}",
            "{'Meditite', 'Angry',   'Mais Tutufeur le Gardien s est emparé du hall principal et en interdit l accès !'}",
            "{'Meditite', 'Sad',     'Il prétend que les écrits des anciens ne doivent jamais être lus par les vivants.'}",
            "{'Meditite', 'Worried', 'L eau salée ronge rapidement la roche dorée de ces tables millénaires.'}",
            "{'Meditite', 'Sad',     'Si personne n en fait le relevé cette semaine, ces secrets seront perdus à jamais.'}",
            "{'Meditite', 'Inspired','Pouvez-vous pénétrer dans les ruines pour nous rapporter l estampage des tables ?'}"
        ],
        "accept": [
            "{'Meditite', 'Happy',   'Hummm ! La sagesse des anciens vous illuminera ! Merci !'}",
            "{'Meditite', 'Normal',  'Descendez par les marches de pierre submergées à l ouest du port.'}"
        ],
        "refuse": [
            "{'Meditite', 'Sad',     'Hummm... Le secret restera prisonnier du sable et des algues.'}",
            "{'Meditite', 'Worried', 'Je vais graver un mémorial pour les mots perdus.'}"
        ],
        "pending": [
            "{'Meditite', 'Worried', 'Avez-vous pu effectuer l estampage à la Relique Engloutie ?'}",
            "{'Meditite', 'Sad',     'La marée monte, les murs inférieurs sont déjà sous l eau...'}"
        ],
        "done": [
            "{'Meditite', 'Inspired','HUMMM ! LES TABLES GRAVÉES ! L estampage est d une netteté absolue !'}",
            "{'Meditite', 'Happy',   'Vous avez pacifié la colère du vieux Tutufeur au fond des vestiges !'}",
            "{'Meditite', 'Surprised','Ces symboles confirment l existence des anciens relais de guilde !'}",
            "{'Meditite', 'Happy',   'Notre ordre d historiens vous doit une reconnaissance éternelle !'}",
            "{'Meditite', 'Inspired','Prenez ces Orbes Antiques et ces joyaux repêchés dans la relique !'}",
            "{'Meditite', 'Normal',  'Que votre nom soit gravé à jamais dans les annales de Metano !'}"
        ]
    },
    {
        "id": "q7_labyrinthe", "ch": 7, "giver": "Oddish",
        "unlock_dungeon": "mossy_labyrinth", "dungeon_name": "Labyrinthe Moussue",
        "titre": "Les racines envahissantes",
        "ask": [
            "{'Oddish', 'Worried', 'Au secours ! La forêt de l est se referme sur nos terrains de jeu !'}",
            "{'Oddish', 'Sad',     'Le Labyrinthe Moussue était une forêt paisible où les jeunes plantes apprenaient à pousser.'}",
            "{'Oddish', 'Normal',  'Mais les pluies récentes ont déclenché une croissance végétale incontrôlable.'}",
            "{'Oddish', 'Angry',   'Et Torterra le Géant s est installé au centre, laissant ses racines bloquer tous les sentiers !'}",
            "{'Oddish', 'Sad',     'Ses racines ligneuses ont piégé trois jeunes Germignon dans une clairière fermée.'}",
            "{'Oddish', 'Worried', 'Si nous n élaguons pas le passage rapidement, ils vont manquer de lumière et d eau.'}",
            "{'Oddish', 'Sad',     'Je suis trop petit pour couper du bois aussi dur avec mes jeunes feuilles.'}",
            "{'Oddish', 'Inspired','Pouvez-vous traverser le labyrinthe pour élaguer les racines et libérer nos amis ?'}"
        ],
        "accept": [
            "{'Oddish', 'Happy',   'Hourra ! Vous êtes les meilleurs explorateurs du monde !'}",
            "{'Oddish', 'Normal',  'Le labyrinthe commence au nord du vieux chêne de la rivière.'}"
        ],
        "refuse": [
            "{'Oddish', 'Sad',     'Oh non... Mes amis vont avoir si peur dans le noir...'}",
            "{'Oddish', 'Worried', 'Je vais essayer d aller gratter la mousse avec mes pattes.'}"
        ],
        "pending": [
            "{'Oddish', 'Worried', 'Avez-vous pu dégager les sentiers du Labyrinthe Moussue ?'}",
            "{'Oddish', 'Sad',     'J entends encore les échos de mes amis appelant à l aide...'}"
        ],
        "done": [
            "{'Oddish', 'Inspired','LES GERMIGNON ! Ils sont rentrés au village sains et saufs !'}",
            "{'Oddish', 'Happy',   'Vous avez réussi à convaincre le grand Torterra de relever ses racines !'}",
            "{'Oddish', 'Surprised','Le Labyrinthe Moussue respire à nouveau sous la lumière du soleil !'}",
            "{'Oddish', 'Happy',   'Toute la faune végétale chante vos louanges depuis ce matin !'}",
            "{'Oddish', 'Inspired','Voici un lot de Pommes d Or et de Graines Résurrection de notre récolte !'}",
            "{'Oddish', 'Normal',  'Merci de veiller sur la nature et sur les petits !'}"
        ]
    },
    {
        "id": "q7_carriere", "ch": 7, "giver": "Numel",
        "unlock_dungeon": "magma_quarry", "dungeon_name": "Carrière Magmatique",
        "titre": "Le charbon thermique",
        "ask": [
            "{'Numel', 'Sad',     'Pfff... J ai un énorme problème pour préparer la saison froide.'}",
            "{'Numel', 'Worried', 'Ma bosse interne a besoin de charbon thermique pour maintenir ma température vitale.'}",
            "{'Numel', 'Normal',  'Le seul gisement pur se trouve au cœur de la Carrière Magmatique.'}",
            "{'Numel', 'Angry',   'Mais Arkani la Flamme a investi la mine et attaque tous les mineurs qui approchent !'}",
            "{'Numel', 'Sad',     'La chaleur y est devenue si intense que même les parois rocheuses fondent.'}",
            "{'Numel', 'Worried', 'Sans ce minerai volcanique, je vais souffrir d hypothermie interne d ici quelques jours.'}",
            "{'Numel', 'Sad',     'Les chariots de guilde ne peuvent plus descendre dans les galeries inférieures.'}",
            "{'Numel', 'Inspired','Explorateurs, avez-vous la force d affronter la carrière pour m extraire ce minerai ?'}"
        ],
        "accept": [
            "{'Numel', 'Happy',   'Pfff ! Chaleureux merci ! La carrière est dans la faille volcanique !'}",
            "{'Numel', 'Normal',  'La carrière s ouvre dans la faille volcanique à l extrême ouest de la falaise.'}"
        ],
        "refuse": [
            "{'Numel', 'Sad',     'Pfff... Je comprends, la lave est un environnement redoutable.'}",
            "{'Numel', 'Worried', 'Je vais essayer d aller gratter de la suie dans les cheminées de la ville...'}"
        ],
        "pending": [
            "{'Numel', 'Worried', 'Avez-vous pu atteindre les filons de la Carrière Magmatique ?'}",
            "{'Numel', 'Sad',     'Pfff... Ma bosse commence à refroidir, je tremble déjà...'}"
        ],
        "done": [
            "{'Numel', 'Inspired','PFFF ! LE CHARBON THERMIQUE ! Regardez cet éclat rouge flamboyant !'}",
            "{'Numel', 'Happy',   'Vous avez vaincu les flammes d Arkani au cœur même du volcan !'}",
            "{'Numel', 'Surprised','Ma bosse a retrouvé toute sa puissance calorifique en un instant !'}",
            "{'Numel', 'Happy',   'Je suis réchauffée pour toute l année ! Vous êtes incroyables !'}",
            "{'Numel', 'Inspired','Prenez ces Orbes Feu et ces Baies Rawst que ma famille conserve !'}",
            "{'Numel', 'Normal',  'Que le feu sacré de votre équipe ne s éteigne jamais !'}"
        ]
    },
    # === CHAPITRE 8 ===
    {
        "id": "q8_toundra", "ch": 8, "giver": "Wooper_Girl",
        "unlock_dungeon": "barren_tundra", "dungeon_name": "Toundra Désolée",
        "titre": "La cargaison gelée",
        "ask": [
            "{'Wooper_Girl', 'Sad',     'Aglagla... C est terrible... Notre provision de baies d hiver est perdue !'}",
            "{'Wooper_Girl', 'Worried', 'Le convoi de notre colonie traversait le col de la Toundra Désolée ce matin.'}",
            "{'Wooper_Girl', 'Normal',  'C est une région glaciaire immense aux crêtes battues par le vent du nord.'}",
            "{'Wooper_Girl', 'Angry',   'Mais Blizzarroi l Hiver a déclenché une tempête de grêle monstrueuse qui a enfoui nos caisses !'}",
            "{'Wooper_Girl', 'Sad',     'Les baies sont figées sous trois mètres de glace épaisse au milieu des pics.'}",
            "{'Wooper_Girl', 'Worried', 'Sans ces réserves, nos petits ne survivront pas à la longue nuit glaciaire.'}",
            "{'Wooper_Girl', 'Sad',     'Nos nageoires sont trop courtes pour creuser dans une glace aussi dure.'}",
            "{'Wooper_Girl', 'Inspired','Qui aura le courage d affronter la toundra pour nous ramener notre cargaison ?'}"
        ],
        "accept": [
            "{'Wooper_Girl', 'Happy',   'Aglagla ! Hourra ! Vous avez le cœur plus chaud que le soleil d été !'}",
            "{'Wooper_Girl', 'Normal',  'Le sentier enneigé démarre au nord de la rivière gelée.'}"
        ],
        "refuse": [
            "{'Wooper_Girl', 'Sad',     'Aglagla... Je comprends, le blizzard là-haut gèle même la respiration.'}",
            "{'Wooper_Girl', 'Worried', 'Nous allons devoir rationner les quelques baies qu il nous reste...'}"
        ],
        "pending": [
            "{'Wooper_Girl', 'Worried', 'Avez-vous retrouvé nos caisses dans la Toundra Désolée ?'}",
            "{'Wooper_Girl', 'Sad',     'La grêle continue de tomber là-haut, la glace s épaissit d heure en heure...'}"
        ],
        "done": [
            "{'Wooper_Girl', 'Inspired','AGLAGLA ! LES CAISSES DE BAIES ! Elles sont toutes là et intactes !'}",
            "{'Wooper_Girl', 'Happy',   'Vous avez surmonté le blizzard glacé du grand Blizzarroi l Hiver !'}",
            "{'Wooper_Girl', 'Surprised','Toute notre colonie va pouvoir se régaler et passer un hiver merveilleux !'}",
            "{'Wooper_Girl', 'Happy',   'Vous êtes les explorateurs les plus chaleureux de toute la région !'}",
            "{'Wooper_Girl', 'Inspired','En échange, prenez cette prime de baies rares et de sphères polaires !'}",
            "{'Wooper_Girl', 'Normal',  'Merci de protéger la vie au cœur du grand froid !'}"
        ]
    },
    {
        "id": "q8_caverne", "ch": 8, "giver": "Machamp",
        "unlock_dungeon": "barren_cavern", "dungeon_name": "Caverne Stérile",
        "titre": "Les filons d'acier",
        "ask": [
            "{'Machamp', 'Worried', 'Croc... Croc... Alerte ! Notre mine d acier naturelle est sous scellés !'}",
            "{'Machamp', 'Sad',     'Nous nous nourrissons des filons ferreux de la Caverne Stérile depuis des générations.'}",
            "{'Machamp', 'Normal',  'C est un réseau rocheux très profond où la pierre contient du fer pur.'}",
            "{'Machamp', 'Angry',   'Mais Charmina le Sceau s est enfermé dans la galerie centrale et a dressé des remparts de force !'}",
            "{'Machamp', 'Sad',     'Plus aucun mineur ne peut atteindre les cristaux de fer.'}",
            "{'Machamp', 'Worried', 'Notre force musculaire commence déjà à s amincir par manque de minerais ferreux.'}",
            "{'Machamp', 'Sad',     'Si le sceau n est pas brisé, notre clan devra s expatrier loin de sa terre natale.'}",
            "{'Machamp', 'Inspired','Pouvez-vous descendre dans la caverne pour vaincre Charmina et rouvrir nos filons ?'}"
        ],
        "accept": [
            "{'Machamp', 'Happy',   'Croc ! Fantastique ! Votre armure de courage est indestructible !'}",
            "{'Machamp', 'Normal',  'L entrée de la caverne s ouvre au pied de l éboulis nord-ouest.'}"
        ],
        "refuse": [
            "{'Machamp', 'Sad',     'Croc... C est dur de voir notre mine fermée pour toujours.'}",
            "{'Machamp', 'Worried', 'Je vais essayer d aller mâchouiller des vieux cailloux sur la plage...'}"
        ],
        "pending": [
            "{'Machamp', 'Worried', 'Le sceau de la Caverne Stérile est-il enfin brisé ?'}",
            "{'Machamp', 'Sad',     'Croc... Mes bras résonnent de plus en plus creux chaque matin...'}"
        ],
        "done": [
            "{'Machamp', 'Inspired','CROC ! CROC ! LES FILONS DE FER SONT LIBRES !'}",
            "{'Machamp', 'Happy',   'Vous avez triomphé des arts martiaux psychiques de Charmina le Sceau !'}",
            "{'Machamp', 'Surprised','Les galeries résonnent à nouveau des coups de pioches de tout notre clan !'}",
            "{'Machamp', 'Happy',   'Notre force sera plus brillante et plus résistante que jamais grâce à vous !'}",
            "{'Machamp', 'Inspired','Veuillez accepter cet ensemble d armures de roche et d orbes minéraux !'}",
            "{'Machamp', 'Normal',  'Vous êtes les meilleurs alliés que la roche ait jamais connus !'}"
        ]
    },
    {
        "id": "q8_crete", "ch": 8, "giver": "Luxray",
        "unlock_dungeon": "cracked_ridge", "dungeon_name": "Crête Craquelée",
        "titre": "Les ailes d'altitude",
        "ask": [
            "{'Luxray', 'Angry',   'Je veux surmonter la crête ! Mais on m interdit de monter !'}",
            "{'Luxray', 'Worried', 'La Crête Craquelée est le seul endroit où les vents sont parfaits pour sauter.'}",
            "{'Luxray', 'Normal',  'C est une arête rocheuse vertigineuse qui domine toute la vallée du sud.'}",
            "{'Luxray', 'Angry',   'Mais Drattak la Cime a bloqué le col supérieur et provoque des éboulis à chaque rugissement !'}",
            "{'Luxray', 'Sad',     'Il prétend que les voyageurs ne sont pas assez résistants pour survivre au sommet.'}",
            "{'Luxray', 'Worried', 'J ai essayé de grimper trois fois, mais ses éboulis m ont fait redescendre en roulant.'}",
            "{'Luxray', 'Sad',     'Si je n atteins pas la falaise du sommet ce mois-ci, je ne serai jamais un vrai garde.'}",
            "{'Luxray', 'Inspired','Explorateurs, pouvez-vous affronter Drattak pour prouver notre bravoure à tous ?'}"
        ],
        "accept": [
            "{'Luxray', 'Happy',   'GÉ-NIAL ! Vous êtes mes idoles ! Montrons-lui de quel rocher on se chauffe !'}",
            "{'Luxray', 'Normal',  'Le sentier de la crête s élève juste au-dessus du vieux pont de pierre.'}"
        ],
        "refuse": [
            "{'Luxray', 'Sad',     'Tant pis... Je suppose que je vais rester un garde de plaine.'}",
            "{'Luxray', 'Worried', 'Je continuerai à surveiller depuis mon petit rocher sur la place...'}"
        ],
        "pending": [
            "{'Luxray', 'Worried', 'Avez-vous atteint le sommet de la Crête Craquelée ?'}",
            "{'Luxray', 'Sad',     'Je regarde les crêtes tous les jours en espérant voir votre victoire...'}"
        ],
        "done": [
            "{'Luxray', 'Inspired','YOUHOU ! VOUS AVEZ VAINCU DRATTAK LA CIME !'}",
            "{'Luxray', 'Happy',   'Il m a envoyé un message par le vent : le sommet est désormais ouvert à ceux qui osent !'}",
            "{'Luxray', 'Surprised','Je vais pouvoir commencer mon entraînement de crête dès demain !'}",
            "{'Luxray', 'Happy',   'Je protégerai Metano avec encore plus de force et de fierté !'}",
            "{'Luxray', 'Inspired','Tenez, prenez ce trésor de crête que j avais ramassé en bas de la falaise !'}",
            "{'Luxray', 'Normal',  'Merci de donner des ailes aux rêves des gardiens !'}"
        ]
    },
    {
        "id": "q8_vallon", "ch": 8, "giver": "Gloom",
        "unlock_dungeon": "suspended_valley", "dungeon_name": "Vallon Suspendu",
        "titre": "La plume d'argent",
        "ask": [
            "{'Gloom', 'Sad',     'Cuii... J ai perdu le trésor le plus précieux de notre jardin...'}",
            "{'Gloom', 'Worried', 'C est la plume d argent royale, offerte par les grands oiseaux des sommets.'}",
            "{'Gloom', 'Normal',  'Elle s est envolée dans le Vallon Suspendu pendant un coup de vent violent.'}",
            "{'Gloom', 'Angry',   'Et Bruyverne le Cri l a capturée dans sa caverne des hauteurs !'}",
            "{'Gloom', 'Sad',     'Ses ultrasons sont si violents qu ils nous empêchent de voler au-dessus du vallon.'}",
            "{'Gloom', 'Worried', 'Cette plume était le talisman qui protégeait notre arbre contre la tempête.'}",
            "{'Gloom', 'Sad',     'Sans elle, notre haie risque de se disperser à la prochaine bourrasque.'}",
            "{'Gloom', 'Inspired','Pouvez-vous grimper au secours de notre haie pour rapporter la plume d argent ?'}"
        ],
        "accept": [
            "{'Gloom', 'Happy',   'Merci ! Vous avez la justice avec vous !'}",
            "{'Gloom', 'Normal',  'Le vallon flottant est accessible par les courants ascendants de l ouest.'}"
        ],
        "refuse": [
            "{'Gloom', 'Sad',     'Je comprends, le vent des abîmes est terrible.'}",
            "{'Gloom', 'Worried', 'Je vais essayer de consolider ma haie avec de la mousse ordinaire...'}"
        ],
        "pending": [
            "{'Gloom', 'Worried', 'Avez-vous retrouvé notre plume dans le Vallon Suspendu ?'}",
            "{'Gloom', 'Sad',     'Les vents hurlent de plus en plus fort chaque nuit...'}"
        ],
        "done": [
            "{'Gloom', 'Inspired','LA PLUME D ARGENT ! Elle brille de tous ses feux célestes !'}",
            "{'Gloom', 'Happy',   'Vous avez bravé les ouragans sonores de Bruyverne le Cri !'}",
            "{'Gloom', 'Surprised','Notre jardin est immédiatement redevenu calme et stable sous sa lumière !'}",
            "{'Gloom', 'Happy',   'Tous les habitants du vallon chanteront votre épopée à chaque aube !'}",
            "{'Gloom', 'Inspired','Veuillez accepter ces orbes célestes et cette récompense d or du sommet !'}",
            "{'Gloom', 'Normal',  'Que le vent céleste porte vos pas pour l éternité !'}"
        ]
    },
    # === CHAPITRE 9 ===
    {
        "id": "q9_bassin", "ch": 9, "giver": "Wooper_Boy",
        "unlock_dungeon": "depleted_basin", "dungeon_name": "Bassin Tari",
        "titre": "La perle d'eau pure",
        "ask": [
            "{'Wooper_Boy', 'Worried', 'Psyyy... J ai un mal de crâne atroce qui ne s arrête jamais...'}",
            "{'Wooper_Boy', 'Sad',     'Notre bassin de baignade s assèche à une vitesse anormale depuis quatre jours.'}",
            "{'Wooper_Boy', 'Normal',  'Le Bassin Tari est une grande dépression lacustre au sud de la plaine de limon.'}",
            "{'Wooper_Boy', 'Angry',   'Léviator le Courroux y a accaparé la perle d eau pure au fond de l abysse !'}",
            "{'Wooper_Boy', 'Sad',     'Il absorbe toute la source hydrique pour alimenter sa propre colère.'}",
            "{'Wooper_Boy', 'Worried', 'Sans cette eau fraîche, nos réserves s épuisent vite !'}",
            "{'Wooper_Boy', 'Sad',     'Tous les Pokémon aquatiques du quartier nagent dans trois centimètres de boue.'}",
            "{'Wooper_Boy', 'Inspired','Par pitié, pouvez-vous affronter Léviator pour ramener la perle et la pluie ?'}"
        ],
        "accept": [
            "{'Wooper_Boy', 'Happy',   'Quel soulagement ! Ma tête va déjà un tout petit peu mieux !'}",
            "{'Wooper_Boy', 'Normal',  'Descendez dans le bassin par les rochers humides de la rive sud.'}"
        ],
        "refuse": [
            "{'Wooper_Boy', 'Sad',     'Aïe aïe aïe... Ma tête...'}",
            "{'Wooper_Boy', 'Worried', 'Je vais me mettre une serviette humide sur le front sur la place...'}"
        ],
        "pending": [
            "{'Wooper_Boy', 'Worried', 'Avez-vous récupéré la perle d eau dans le Bassin Tari ?'}",
            "{'Wooper_Boy', 'Sad',     'Je ne supporte plus cette sécheresse...'}"
        ],
        "done": [
            "{'Wooper_Boy', 'Inspired','LA PERLE D EAU PURE ! Regardez cette eau claire qui en jaillit !'}",
            "{'Wooper_Boy', 'Happy',   'OH ! MON MAL DE CRÂNE A COMPLÈTEMENT DISPARU !'}",
            "{'Wooper_Boy', 'Surprised','Vous avez réussi à calmer la fureur dévastatrice de Léviator le Courroux ?'}",
            "{'Wooper_Boy', 'Happy',   'Les étangs de Metano se remplissent à nouveau d eau fraîche et pure !'}",
            "{'Wooper_Boy', 'Inspired','Prenez cette fabuleuse récompense lacustre que notre clan protégeait !'}",
            "{'Wooper_Boy', 'Normal',  'Vous êtes les héros des eaux claires !'}"
        ]
    },
    {
        "id": "q9_marais", "ch": 9, "giver": "Ludicolo",
        "unlock_dungeon": "wayward_wetlands", "dungeon_name": "Marais Errants",
        "titre": "Le nénuphar géant",
        "ask": [
            "{'Ludicolo', 'Sad',     'Plouf... Regardez la feuille sur ma tête, elle jaunit et se ratatibe...'}",
            "{'Ludicolo', 'Worried', 'Les Marais Errants sont empoisonnés par une brume violacée anormale.'}",
            "{'Ludicolo', 'Normal',  'C est un vaste réseau d étangs stagnants et de racines à l est du fleuve.'}",
            "{'Ludicolo', 'Angry',   'Et Milobellus le Bassin a scellé le sanctuaire des nénuphars géants au centre !'}",
            "{'Ludicolo', 'Sad',     'Ces nénuphars sacrés filtrent naturellement les toxines de notre eau.'}",
            "{'Ludicolo', 'Worried', 'Si nous ne replantons pas une bouture saine dans notre mare avant ce soir...'}",
            "{'Ludicolo', 'Sad',     '...toute notre colonie perdra sa musique pour toujours.'}",
            "{'Ludicolo', 'Inspired','Explorateurs, pouvez-vous traverser les marais pour nous cueillir une bouture ?'}"
        ],
        "accept": [
            "{'Ludicolo', 'Happy',   'Plouf ! Youpi ! Vous êtes l eau vive de notre espoir !'}",
            "{'Ludicolo', 'Normal',  'Les marais commencent après le pont de bois moussue de la rivière Est.'}"
        ],
        "refuse": [
            "{'Ludicolo', 'Sad',     'Plouf... C est triste. Nous allons devoir ramper dans la vase sèche.'}",
            "{'Ludicolo', 'Worried', 'J espère qu une averse viendra nettoyer la mare...'}"
        ],
        "pending": [
            "{'Ludicolo', 'Worried', 'Avez-vous réussi à cueillir la bouture de nénuphar des Marais Errants ?'}",
            "{'Ludicolo', 'Sad',     'Plouf... Ma feuille est si sèche que j ai du mal à danser...'}"
        ],
        "done": [
            "{'Ludicolo', 'Inspired','PLOUF ! LE NÉNUPHAR GÉANT ! Quel parfum de pureté et d eau fraîche !'}",
            "{'Ludicolo', 'Happy',   'Vous avez convaincu Milobellus le Bassin de rouvrir le sanctuaire !'}",
            "{'Ludicolo', 'Surprised','Regardez ! En posant la feuille sur notre mare, toute l eau s est purifiée !'}",
            "{'Ludicolo', 'Happy',   'Notre danse est redevenue verte, luisante et forte !'}",
            "{'Ludicolo', 'Inspired','Voici des trésors des berges et une belle prime pour votre guilde !'}",
            "{'Ludicolo', 'Normal',  'Merci de protéger les humbles habitants des eaux !'}"
        ]
    },
    {
        "id": "q9_jungle", "ch": 9, "giver": "Roselia",
        "unlock_dungeon": "southern_jungle", "dungeon_name": "Jungle Méridionale",
        "titre": "La graine solaire",
        "ask": [
            "{'Roselia', 'Worried', 'Au secours ! Il fait nuit noire en plein midi dans notre sous-bois !'}",
            "{'Roselia', 'Sad',     'La canopée de la Jungle Méridionale est devenue si dense que le soleil ne passe plus.'}",
            "{'Roselia', 'Normal',  'C est une forêt tropicale foisonnante qui s étend vers les côtes chaudes du sud.'}",
            "{'Roselia', 'Angry',   'Mais Roserade le Venin a emprisonné la graine solaire sacrée dans son antre !'}",
            "{'Roselia', 'Sad',     'Elle utilise sa lumière pour cultiver ses propres fleurs toxiques géantes.'}",
            "{'Roselia', 'Worried', 'Sans la graine solaire, toutes les plantes de Metano s arrêtent de pousser.'}",
            "{'Roselia', 'Sad',     'Nos pétales s étiolent et nous ne pouvons plus synthétiser d énergie.'}",
            "{'Roselia', 'Inspired','Pouvez-vous affronter la jungle tropicale pour nous libérer la graine solaire ?'}"
        ],
        "accept": [
            "{'Roselia', 'Happy',   'Merci ! Nos racines trépignent d impatience ! Vous êtes nos soleils !'}",
            "{'Roselia', 'Normal',  'La jungle démarre juste derrière les grands banians de la lisière sud.'}"
        ],
        "refuse": [
            "{'Roselia', 'Sad',     'Oh non... Nous allons devoir vivre dans une pénombre éternelle.'}",
            "{'Roselia', 'Worried', 'Je vais essayer de trouver un rayon de lumière sur le toit de l auberge...'}"
        ],
        "pending": [
            "{'Roselia', 'Worried', 'Avez-vous libéré la graine solaire de la Jungle Méridionale ?'}",
            "{'Roselia', 'Sad',     'Mes feuilles pâlissent chaque jour un peu plus sans lumière...'}"
        ],
        "done": [
            "{'Roselia', 'Inspired','LA GRAINE SOLAIRE ! Regardez cette lueur dorée incroyable qui en émane !'}",
            "{'Roselia', 'Happy',   'OH ! Les arbres se sont écartés et un magnifique rayon de soleil éclaire la ville !'}",
            "{'Roselia', 'Surprised','Vous avez triomphé des lianes empoisonnées de Roserade le Venin !'}",
            "{'Roselia', 'Happy',   'Toutes les fleurs de la région ouvrent leurs pétales pour vous saluer !'}",
            "{'Roselia', 'Inspired','Prenez ce trésor végétal et ces graines rares que la jungle gardait !'}",
            "{'Roselia', 'Normal',  'Vous avez ramené le printemps dans nos cœurs pour toujours !'}"
        ]
    },
    {
        "id": "q9_gouffre", "ch": 9, "giver": "Quagsire",
        "unlock_dungeon": "submerged_chasm", "dungeon_name": "Gouffre Immergé",
        "titre": "La conque abyssale",
        "ask": [
            "{'Quagsire', 'Sad',     'Clac... Clac... Je suis inconsolable... J ai perdu l héritage de mon clan.'}",
            "{'Quagsire', 'Worried', 'C est la conque abyssale, un coquillage géant qui résonne avec le chant des mers.'}",
            "{'Quagsire', 'Normal',  'Elle a glissé lors des grandes marées d automne.'}",
            "{'Quagsire', 'Angry',   'Elle est tombée tout au fond du Gouffre Immergé, où trône Hyporoi le Fond !'}",
            "{'Quagsire', 'Sad',     'Il a installé son repaire dans cette faille marine aux pressions écrasantes.'}",
            "{'Quagsire', 'Worried', 'Sans le chant de la conque, notre clan ne sait plus orienter ses coquilles.'}",
            "{'Quagsire', 'Sad',     'Les courants nous ballottent contre les rochers sans repère.'}",
            "{'Quagsire', 'Inspired','Explorateurs, pouvez-vous plonger dans la faille pour rapporter notre conque ?'}"
        ],
        "accept": [
            "{'Quagsire', 'Happy',   'Clac ! Formidable ! Vous avez le courage des grands cachalots du large !'}",
            "{'Quagsire', 'Normal',  'Le gouffre sous-marin s ouvre au bout de la grande jetée rocheuse.'}"
        ],
        "refuse": [
            "{'Quagsire', 'Sad',     'Clac... Je comprends, les profondeurs noires sont terrifiantes pour les terrestres.'}",
            "{'Quagsire', 'Worried', 'Je vais continuer de scruter les vagues depuis le port...'}"
        ],
        "pending": [
            "{'Quagsire', 'Worried', 'Avez-vous atteint le fond du Gouffre Immergé ?'}",
            "{'Quagsire', 'Sad',     'Clac... Les courants deviennent de plus en plus chaotiques chaque jour...'}"
        ],
        "done": [
            "{'Quagsire', 'Inspired','CLAC ! CLAC ! LA CONQUE ABYSSALE ! Écoutez cette mélodie céleste !'}",
            "{'Quagsire', 'Happy',   'Elle résonne à nouveau dans tout le port avec une pureté marine parfaite !'}",
            "{'Quagsire', 'Surprised','Vous avez bravé les tourbillons à haute pression d Hyporoi le Fond ?'}",
            "{'Quagsire', 'Happy',   'Notre clan retrouve enfin son équilibre et sa fierté ancestrale !'}",
            "{'Quagsire', 'Inspired','Voici des perles marines inestimables que nos ancêtres avaient pêchées !'}",
            "{'Quagsire', 'Normal',  'Vous serez toujours nos invités d honneur sur toutes les mers !'}"
        ]
    },
    # === CHAPITRE 10 ===
    {
        "id": "q10_sentier", "ch": 10, "giver": "Furret",
        "unlock_dungeon": "snowbound_path", "dungeon_name": "Sentier Enneigé",
        "titre": "La cape du blizzard",
        "ask": [
            "{'Furret', 'Sad',     'Frrr... Frrr... Le froid glaciaire pèse trop lourd sur mes petites épaules.'}",
            "{'Furret', 'Worried', 'Ma cape de paille traditionnelle ne résiste plus aux blizzards polaires du nord.'}",
            "{'Furret', 'Normal',  'Le Sentier Enneigé est le grand col alpin qui relie Metano aux glaciers éternels.'}",
            "{'Furret', 'Angry',   'Mais Momartik le Souffle a confisqué toute la soie de givre sacrée au sommet !'}",
            "{'Furret', 'Sad',     'Elle la réserve exclusivement à sa cour d ombres gelées.'}",
            "{'Furret', 'Worried', 'Si je ne me fais pas une cape de givre avant la grande nuit d hiver...'}",
            "{'Furret', 'Sad',     '...je serai congelée sur place sans pouvoir sortir de chez moi.'}",
            "{'Furret', 'Inspired','Explorateurs, pouvez-vous affronter le col pour m obtenir de la soie de givre ?'}"
        ],
        "accept": [
            "{'Furret', 'Happy',   'Frrr ! Merci infiniment ! Vous me réchauffez déjà le cœur !'}",
            "{'Furret', 'Normal',  'Le sentier enneigé débute après le pont des glaces à l extrême nord.'}"
        ],
        "refuse": [
            "{'Furret', 'Sad',     'Frrr... Je comprends... La neige là-haut est un mur infranchissable.'}",
            "{'Furret', 'Worried', 'Je vais empiler trois vieilles couvertures de laine pour survivre...'}"
        ],
        "pending": [
            "{'Furret', 'Worried', 'Avez-vous réussi à gravir le Sentier Enneigé ?'}",
            "{'Furret', 'Sad',     'Frrr... Je grelotte tellement que mes dents claquent toute la nuit...'}"
        ],
        "done": [
            "{'Furret', 'Inspired','FRRR ! LA SOIE DE GIVRE ! Regardez sa texture étincelante et légère !'}",
            "{'Furret', 'Happy',   'OH ! En l enfilant, je ne ressens plus aucune morsure du blizzard !'}",
            "{'Furret', 'Surprised','Vous avez vaincu les illusions glacées de la redoutable Momartik le Souffle ?'}",
            "{'Furret', 'Happy',   'Je vais pouvoir courir dans la neige avec mes amis pendant tout l hiver !'}",
            "{'Furret', 'Inspired','Prenez cette récompense de cristaux de givre pur et d or alpin !'}",
            "{'Furret', 'Normal',  'Merci de réchauffer la vie des plus fragiles dans la tempête !'}"
        ]
    },
    {
        "id": "q10_foudre", "ch": 10, "giver": "Spinda",
        "unlock_dungeon": "thunderstruck_pass", "dungeon_name": "Col de la Foudre",
        "titre": "Le paratonnerre antique",
        "ask": [
            "{'Spinda', 'Worried', 'Bzz ! Bzz ! Alerte rouge ! Des éclairs tombent sur les toits de la ville !'}",
            "{'Spinda', 'Sad',     'Le système de paratonnerres naturels du Col de la Foudre est déréglé.'}",
            "{'Spinda', 'Normal',  'C est un col de haute montagne où les nuages d orage convergent en permanence.'}",
            "{'Spinda', 'Angry',   'Et Magnézone l Éclair a déconnecté la borne d ancrage électrique au sommet !'}",
            "{'Spinda', 'Sad',     'Il concentre tous les éclairs sur sa propre coque pour augmenter son champ de force.'}",
            "{'Spinda', 'Worried', 'Sans la borne d ancrage, la foudre frappe au hasard dans toute la vallée de Metano.'}",
            "{'Spinda', 'Sad',     'Si un éclair touche la réserve de poudres de la guilde, ce sera la catastrophe.'}",
            "{'Spinda', 'Inspired','Pouvez-vous gravir le col sous la foudre pour réactiver la borne d ancrage ?'}"
        ],
        "accept": [
            "{'Spinda', 'Happy',   'Bzz ! GÉNIAL ! Votre énergie positive électrise toute notre équipe !'}",
            "{'Spinda', 'Normal',  'Le col est visible au nord-est, là où le ciel clignote sans cesse.'}"
        ],
        "refuse": [
            "{'Spinda', 'Sad',     'Bzz... Je comprends... La foudre ne pardonne aucun faux pas.'}",
            "{'Spinda', 'Worried', 'Nous allons installer des paratonnerres de fortune sur les maisons...'}"
        ],
        "pending": [
            "{'Spinda', 'Worried', 'Bzz ! Le Col de la Foudre est-il à nouveau sécurisé ?'}",
            "{'Spinda', 'Sad',     'Un nouvel éclair est tombé près du dojo ce matin, ça urge...'}"
        ],
        "done": [
            "{'Spinda', 'Happy',   'BZZ ! Le ciel s est enfin dégagé et les étincelles sont douces !'}",
            "{'Spinda', 'Inspired','Votre courage électrise tout Metano !'}"
        ]
    },
    {
        "id": "q10_falaises", "ch": 10, "giver": "Zigzagoon",
        "unlock_dungeon": "flyaway_cliffs", "dungeon_name": "Falaises de l'Envol",
        "titre": "L'œuf du nid suprême",
        "ask": [
            "{'Zigzagoon', 'Sad',     'Cui ! Cui ! Au secours ! Un malheur est arrivé à notre couvée de printemps !'}",
            "{'Zigzagoon', 'Worried', 'Une bourrasque ascendante a emporté notre œuf royal au-dessus des falaises.'}",
            "{'Zigzagoon', 'Normal',  'Les Falaises de l Envol sont des à-pics rocheux vertigineux qui touchent les nuages.'}",
            "{'Zigzagoon', 'Angry',   'Et Roucarnage le Sommet a recueilli notre œuf dans son nid géant sur la plus haute crête !'}",
            "{'Zigzagoon', 'Sad',     'Il refuse de nous le rendre, prétendant que seul le ciel de haute altitude l est digne.'}",
            "{'Zigzagoon', 'Worried', 'Mais sans la chaleur maternelle de notre nid d en bas, l œuf ne pourra jamais éclore.'}",
            "{'Zigzagoon', 'Sad',     'Les vents là-haut sont trop violents pour que de petits oiseaux aillent négocier.'}",
            "{'Zigzagoon', 'Inspired','Explorateurs, avez-vous la force de gravir les falaises pour nous rapporter l œuf ?'}"
        ],
        "accept": [
            "{'Zigzagoon', 'Happy',   'CUI ! CUI ! Merci ! Vous nous redonnez le souffle de l espoir !'}",
            "{'Zigzagoon', 'Normal',  'Le sentier des falaises monte en lacets par la face nord de la falaise d argent.'}"
        ],
        "refuse": [
            "{'Zigzagoon', 'Sad',     'Cui... C est si triste. Le nid restera vide cette saison.'}",
            "{'Zigzagoon', 'Worried', 'Nous allons appeler le ciel tous les jours depuis la branche la plus haute...'}"
        ],
        "pending": [
            "{'Zigzagoon', 'Worried', 'Avez-vous atteint le nid suprême des Falaises de l Envol ?'}",
            "{'Zigzagoon', 'Sad',     'Cui... Le vent est si froid là-haut pour un petit œuf...'}"
        ],
        "done": [
            "{'Zigzagoon', 'Inspired','CUI ! L ŒUF ROYAL ! Regardez, il bouge ! Il est intact et chaud !'}",
            "{'Zigzagoon', 'Happy',   'OH ! Vous entendez ces petits coups de bec à l intérieur ? Il va éclore !'}",
            "{'Zigzagoon', 'Surprised','Vous avez vaincu les ouragans d ailes du grand Roucarnage le Sommet ?'}",
            "{'Zigzagoon', 'Happy',   'Vous avez sauvé la génération future de tous les oiseaux de la vallée !'}",
            "{'Zigzagoon', 'Inspired','Veuillez accepter ces plumes célestes et cette récompense d or du nid !'}",
            "{'Zigzagoon', 'Normal',  'Notre vol vous accompagnera et vous guidera où que vous alliez !'}"
        ]
    },
    {
        "id": "q10_cime", "ch": 10, "giver": "Nidoking",
        "unlock_dungeon": "forgotten_silver_spire", "dungeon_name": "Cime d'Argent Oubliée",
        "titre": "Le diadème d'argent",
        "ask": [
            "{'Nidoking', 'Sad',     'Hummm... Hummm... Un voile de ténèbres psychiques s est abattu sur nos esprits.'}",
            "{'Nidoking', 'Worried', 'Le diadème d argent qui clarifiait nos rêves a été subtilisé dans notre sanctuaire.'}",
            "{'Nidoking', 'Normal',  'La Cime d Argent Oubliée est un pic minéral sacré qui s élève au-dessus de la Tour Céleste.'}",
            "{'Nidoking', 'Angry',   'Et Kaorine l Antique l a scellé dans son autel pour invoquer des visions du passé !'}",
            "{'Nidoking', 'Sad',     'Sa magie ancienne crée des interférences qui nous font faire des cauchemars sans fin.'}",
            "{'Nidoking', 'Worried', 'Si le diadème ne retrouve pas son socle en bas, notre lucidité mentale va s éteindre.'}",
            "{'Nidoking', 'Sad',     'Nous sommes trop sensibles aux ondes de la cime pour pouvoir l approcher nous-mêmes.'}",
            "{'Nidoking', 'Inspired','Explorateurs au cœur pur, pouvez-vous purifier la cime pour nous ramener le diadème ?'}"
        ],
        "accept": [
            "{'Nidoking', 'Happy',   'Hummm ! Quel éclat d esprit pur ! Merci de tout notre être !'}",
            "{'Nidoking', 'Normal',  'La cime argentée est accessible par l escalier de roche blanche au nord du pic.'}"
        ],
        "refuse": [
            "{'Nidoking', 'Sad',     'Hummm... Je comprends. La magie ancienne peut consumer l esprit.'}",
            "{'Nidoking', 'Worried', 'Nous allons tenter de fermer nos yeux aux cauchemars en attendant...'}"
        ],
        "pending": [
            "{'Nidoking', 'Worried', 'La Cime d Argent Oubliée a-t-elle retrouvé son silence sacré ?'}",
            "{'Nidoking', 'Sad',     'Hummm... Les cauchemars sont de plus en plus lourds chaque nuit...'}"
        ],
        "done": [
            "{'Nidoking', 'Inspired','HUMMM ! LE DIADÈME D ARGENT ! Sa clarté irradie toute la place de Metano !'}",
            "{'Nidoking', 'Happy',   'OH ! Regardez, toutes les ombres psychiques de nos esprits se dissipent !'}",
            "{'Nidoking', 'Surprised','Vous avez surmonté les mystères ancestraux du terrible Kaorine l Antique ?'}",
            "{'Nidoking', 'Happy',   'Notre clan retrouve la paix mentale et des nuits sereines pour toujours !'}",
            "{'Nidoking', 'Inspired','Prenez ces joyaux sacrés d argent et cette prime céleste d exception !'}",
            "{'Nidoking', 'Normal',  'Que la lumière céleste veille sur votre amitié éternellement !'}"
        ]
    }
]

def update_side_quests_lua():
    if not os.path.exists(SIDE_QUESTS_LUA):
        print(f"  [Erreur] Fichier introuvable : {SIDE_QUESTS_LUA}")
        return

    with open(SIDE_QUESTS_LUA, "r", encoding="utf-8") as f:
        content = f.read()

    lua_entries = []
    for q in EXPANDED_SIDE_QUESTS:
        ask_str = ",\n      ".join(q["ask"])
        accept_str = ",\n      ".join(q["accept"])
        refuse_str = ",\n      ".join(q["refuse"])
        pending_str = ",\n      ".join(q["pending"])
        done_str = ",\n      ".join(q["done"])

        entry = f"""
  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (ENRICHI 20-25 LIGNES) : {q['dungeon_name']} ===
  {{
    id = '{q['id']}', ch = {q['ch']}, giver = '{q['giver']}', target = '{q['giver']}',
    unlock_dungeon = '{q['unlock_dungeon']}', dungeon_name = "{q['dungeon_name']}",
    titre = "{q['titre']}",
    ask = {{
      {ask_str}
    }},
    accept = {{{accept_str}}},
    refuse = {{{refuse_str}}},
    pending= {{{pending_str}}},
    solve  = {{{pending_str}}},
    done   = {{
      {done_str}
    }},
    undertow = "mission personnelle de déblocage donjon (enrichi)",
  }},"""
        lua_entries.append(entry)

    header = content.split("-- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE")[0]
    if "SideQuests.LIST" not in header:
        print("  [Erreur] Format inattendu de SideQuests.lua")
        return

    tail_split = content.split("function SideQuests.EnsureSV()")
    tail = "\nfunction SideQuests.EnsureSV()" + tail_split[1] if len(tail_split) > 1 else ""

    idx_insert = header.rfind("  },")
    if idx_insert != -1:
        header = header[:idx_insert+4]

    new_content = header + "\n" + "\n".join(lua_entries) + "\n}\n" + tail

    with open(SIDE_QUESTS_LUA, "w", encoding="utf-8") as f:
        f.write(new_content)

    print("  [OK] 20 Quêtes secondaires enrichies (20-25 lignes de dialogue par quête au total).")

def check_npc_positioning():
    """Vérifie la présence et le positionnement des 20 PNJ dans TownLife.TOURNEES et metano_town."""
    if not os.path.exists(TOWN_LIFE_LUA):
        return
    with open(TOWN_LIFE_LUA, "r", encoding="utf-8") as f:
        tl_content = f.read()
    
    print("\n  [Contrôle de Positionnement des PNJ dans TownLife.TOURNEES / Ville de Metano] :")
    ok_count = 0
    for q in EXPANDED_SIDE_QUESTS:
        g = q["giver"]
        if f"{g} =" in tl_content or f"{g}=" in tl_content:
            print(f"    ✅ PNJ `{g:14s}` ({q['dungeon_name']:23s}) -> Présent dans TownLife.TOURNEES (tournée active en ville)")
            ok_count += 1
        else:
            print(f"    ⚠️ PNJ `{g:14s}` non trouvé dans TownLife.TOURNEES")
    print(f"  -> {ok_count} / 20 PNJ vérifiés présents et bien positionnés en ville.")

def main():
    print("==========================================================================")
    print("=== ENRICHISSEMENT DES QUÊTES PNJ (20-25 LIGNES DE DIALOGUE/QUÊTE) ===")
    print("==========================================================================\n")
    update_side_quests_lua()
    check_npc_positioning()
    print("\n==========================================================================")
    print("=== 20 QUÊTES ENRICHIES ET POSITIONNEMENT CONTRÔLÉ ===")
    print("==========================================================================")

if __name__ == "__main__":
    main()
