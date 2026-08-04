--[[
    SideQuests.lua

    LES REQUETES DE METANO — quetes secondaires OBLIGATOIRES
    ================================================================
    CONSTAT
    ------------------------------------------------------------------
    Le jeu n'a AUCUN contenu optionnel. On enchaine : cinematique de
    ville -> donjon -> boss -> veillee -> chapitre suivant. C'est un
    couloir. Mesure : le chapitre 6 tient en 1 h 20, le 10 en 1 h.

    Ce module ajoute par chapitre 3 requetes qui doivent etre RENDUES
    avant que l'histoire reprenne. Ce ne sont pas des missions du
    comptoir (aleatoires, repetables) : ce sont des demandes ecrites,
    liees a des PNJ nommes, qui ne se presentent qu'une fois.

    POURQUOI OBLIGATOIRES
    ------------------------------------------------------------------
    Demande explicite. Techniquement : le palier de chapitre pose
    DaysToReach ; tant que les 3 requetes du chapitre ne sont pas
    rendues, on repousse ce palier. Le joueur n'est jamais bloque sans
    savoir pourquoi — le tableau des Requetes affiche ce qui manque.

    LE CONTRASTE, PRINCIPE D'ECRITURE
    ------------------------------------------------------------------
    L'arc principal est grave : la Voix, les Coeurs qui s'eteignent, le
    doute. Si TOUT est grave, plus rien ne l'est.

    Ces requetes respirent donc volontairement : un chapardeur de
    petit-dejeuner, une dispute de marchands, un enfant qui veut un
    autographe. Elles sont courtes, chaleureuses, parfois drôles.

    MAIS chacune porte une seconde couche que le joueur attentif
    ramasse : le Sentinelle qui compte les allees et venues, la
    marchande qui n'ose plus aller cueillir au nord, le petit qui
    demande pourquoi les adultes chuchotent depuis quelque temps.
    Le quotidien est le meilleur endroit pour montrer qu'un monde
    va mal — bien meilleur qu'un discours.

    REGLES DU PROJET
      * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
      * La Voix ne parle JAMAIS dans une requete : elle ne s'interesse
        pas au quotidien. Son absence ici la rend plus lourde ailleurs.
      * Module global -> texte litteral (patron SuaireArc / LegendArc).
      * Repliques courtes, < 150 caracteres hors balises [pause=N].
      * Tout sous pcall, sortie garantie.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

SideQuests = {}

--------------------------------------------------------------------
-- ETAT
--------------------------------------------------------------------
function SideQuests.Ensure()
  if SV.SideQuests == nil then SV.SideQuests = {} end
  local s = SV.SideQuests
  if s.Done == nil then s.Done = {} end        -- [id] = true
  if s.Taken == nil then s.Taken = {} end      -- [id] = true
  if s.Step == nil then s.Step = {} end        -- [id] = n (avancement)
  return s
end

--------------------------------------------------------------------
-- LES REQUETES
--------------------------------------------------------------------
-- id       identifiant interne
-- ch       chapitre qui la propose
-- giver    instance du PNJ demandeur (deja sur la carte de Metano)
-- titre    ce qui s'affiche au tableau
-- ask      ce que dit le PNJ quand on l'aborde
-- accept   sa reaction si on accepte
-- refuse   sa reaction si on refuse (jamais vexante : on peut revenir)
-- pending  ce qu'il dit tant que ce n'est pas fait
-- target   instance du PNJ a qui parler pour resoudre
-- solve    l'echange chez la cible
-- done     le remerciement du demandeur
-- undertow la seconde couche : ce que la scene dit du monde
SideQuests.LIST = {

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Désert des Oubliés ===
  {
    id = 'q6_desert', ch = 6, giver = 'Doduo', target = 'Doduo',
    unlock_dungeon = 'forsaken_desert', dungeon_name = "Désert des Oubliés",
    titre = "Le sac de courrier volé",
    ask = {
      {'Doduo', 'Worried', 'C est une catastrophe ! Ma sacoche de courrier prioritaire a disparu !'},
      {'Doduo', 'Angry',   'C est Hippodocus le Colosse qui me l a arrachée avant de s enfouir dans le Désert des Oubliés !'},
      {'Doduo', 'Sad',     'Si je ne livre pas ces lettres aujourd hui, je suis renvoyé...'}
    },
    accept = {{'Doduo', 'Happy', 'Merci mille fois ! Le désert s étend au sud-est de la route principale !'}},
    refuse = {{'Doduo', 'Sad',   'Je comprends... Je vais devoir affronter le désert tout seul.'}},
    pending= {{'Doduo', 'Worried', 'Avez-vous retrouvé ma sacoche de courrier dans le Désert des Oubliés ?'}},
    solve  = {{'Doduo', 'Worried', 'Avez-vous retrouvé ma sacoche de courrier dans le Désert des Oubliés ?'}},
    done   = {
      {'Doduo', 'Inspired', 'MA SACOCHE ! Et toutes les lettres sont intactes !'},
      {'Doduo', 'Happy',    'Vous avez sauvé ma tournée et ma réputation ! Tenez, voici pour votre guilde !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Crevasse de Géode ===
  {
    id = 'q6_geode', ch = 6, giver = 'Gulpin', target = 'Gulpin',
    unlock_dungeon = 'geode_crevice', dungeon_name = "Crevasse de Géode",
    titre = "Tarinor pris au piège",
    ask = {
      {'Gulpin', 'Sad',     'Gloup... Mon ami Tarinor n est pas rentré de son expédition minérale.'},
      {'Gulpin', 'Worried', 'Un éboulement provoqué par Gigalithe le Diamant a bloqué la Crevasse de Géode !'},
      {'Gulpin', 'Normal',  'Il a besoin d une équipe d explorateurs pour dégager la roche.'}
    },
    accept = {{'Gulpin', 'Happy', 'Gloup ! La crevasse se trouve au nord des anciennes carrières !'}},
    refuse = {{'Gulpin', 'Sad',   'Gloup... J espère que sa boussole interne tiendra le coup.'}},
    pending= {{'Gulpin', 'Worried', 'Avez-vous réussi à dégager la Crevasse de Géode ?'}},
    solve  = {{'Gulpin', 'Worried', 'Avez-vous réussi à dégager la Crevasse de Géode ?'}},
    done   = {
      {'Gulpin', 'Happy',   'GLOUP ! Tarinor est rentré sain et sauf !'},
      {'Gulpin', 'Inspired','Il m a ramené ces cristaux rares, je vous en offre la moitié !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Verger Sauvage ===
  {
    id = 'q6_verger', ch = 6, giver = 'Silcoon', target = 'Silcoon',
    unlock_dungeon = 'wild_orchard', dungeon_name = "Verger Sauvage",
    titre = "La sève dorée de la reine",
    ask = {
      {'Silcoon', 'Worried', 'Les sous-bois du Verger Sauvage sont devenus impraticables.'},
      {'Silcoon', 'Sad',     'Apireine la Souveraine a confisqué toute la sève dorée dont nous avons besoin pour évoluer.'},
      {'Silcoon', 'Normal',  'Pouvez-vous négocier ou combattre pour rétablir le partage du verger ?'}
    },
    accept = {{'Silcoon', 'Happy', 'Merci... Le sentier du verger part juste à l ouest des arbres de guilde.'}},
    refuse = {{'Silcoon', 'Sad',   '...Je vais devoir attendre une saison de plus dans ma coque.'}},
    pending= {{'Silcoon', 'Worried', 'Le Verger Sauvage est-il à nouveau libre d accès ?'}},
    solve  = {{'Silcoon', 'Worried', 'Le Verger Sauvage est-il à nouveau libre d accès ?'}},
    done   = {
      {'Silcoon', 'Inspired','La sève dorée coule de nouveau dans les arbres !'},
      {'Silcoon', 'Happy',   'Je sens que ma transformation est proche ! Merci à votre équipe !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Plaines Brûlées ===
  {
    id = 'q6_plaines', ch = 6, giver = 'Mareep', target = 'Mareep',
    unlock_dungeon = 'scorched_plains', dungeon_name = "Plaines Brûlées",
    titre = "Surcharges dans la savane",
    ask = {
      {'Mareep', 'Worried', 'Bêêê... La laine de mon troupeau fait des étincelles incontrôlables.'},
      {'Mareep', 'Angry',   'Élecsprint la Tempête a déclenché un orage statique permanent sur les Plaines Brûlées !'},
      {'Mareep', 'Sad',     'Il faut calmer sa colère pour que les plaines retrouvent leur sérénité.'}
    },
    accept = {{'Mareep', 'Happy', 'Bêêê ! Les plaines s étendent par-delà la colline foudroyée !'}},
    refuse = {{'Mareep', 'Sad',   'Bêêê... Nous allons devoir rester à l abri des rochers.'}},
    pending= {{'Mareep', 'Worried', 'Avez-vous apaisé les Plaines Brûlées ?'}},
    solve  = {{'Mareep', 'Worried', 'Avez-vous apaisé les Plaines Brûlées ?'}},
    done   = {
      {'Mareep', 'Happy',   'BÊÊÊ ! L air est redevenu doux et respirable !'},
      {'Mareep', 'Inspired','Voici une Toison Douce pour vous remercier de votre bravoure !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Jardin d'Énergie ===
  {
    id = 'q7_jardin', ch = 7, giver = 'Magnemite', target = 'Magnemite',
    unlock_dungeon = 'energy_garden', dungeon_name = "Jardin d'Énergie",
    titre = "L'antenne disparue",
    ask = {
      {'Magnemite', 'Worried', 'Bzz... Bzz... Communication interrompue avec notre relais du sous-sol.'},
      {'Magnemite', 'Sad',     'Lucario l Onde s est approprié l antenne de résonance du Jardin d Énergie.'},
      {'Magnemite', 'Normal',  'Nous avons besoin de guerriers pour descendre dans les cavernes de quartz.'}
    },
    accept = {{'Magnemite', 'Happy', 'Bzz ! Positif ! Le jardin se situe sous la faille minérale !'}},
    refuse = {{'Magnemite', 'Sad',   'Bzz... Négatif... Signal perdu.'}},
    pending= {{'Magnemite', 'Worried', 'Bzz... Avez-vous restauré le signal du Jardin d Énergie ?'}},
    solve  = {{'Magnemite', 'Worried', 'Bzz... Avez-vous restauré le signal du Jardin d Énergie ?'}},
    done   = {
      {'Magnemite', 'Inspired','BZZ ! BZZ ! Signal rétabli à 100% !'},
      {'Magnemite', 'Happy',   'Connexion optimale ! Votre équipe est inscrite dans notre registre de héros !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Relique Engloutie ===
  {
    id = 'q7_relique', ch = 7, giver = 'Bronzor', target = 'Bronzor',
    unlock_dungeon = 'sunken_relic', dungeon_name = "Relique Engloutie",
    titre = "Les tables sacrées englouties",
    ask = {
      {'Bronzor', 'Sad',     'Hummm... Les eaux ont recouvert l entrée de la Relique Engloutie.'},
      {'Bronzor', 'Worried', 'Tutufeur le Gardien refuse de laisser quiconque transcrire les tables d histoire.'},
      {'Bronzor', 'Normal',  'Pouvez-vous explorer les ruines pour rapporter la transcription ?'}
    },
    accept = {{'Bronzor', 'Happy', 'Hummm ! La relique repose au fond de la crique ouest !'}},
    refuse = {{'Bronzor', 'Sad',   'Hummm... L histoire restera prisonnière de la roche.'}},
    pending= {{'Bronzor', 'Worried', 'Avez-vous transcrit les tables de la Relique Engloutie ?'}},
    solve  = {{'Bronzor', 'Worried', 'Avez-vous transcrit les tables de la Relique Engloutie ?'}},
    done   = {
      {'Bronzor', 'Happy',   'HUMMM ! La transcription est complète et exacte !'},
      {'Bronzor', 'Inspired','La sagesse des anciens vivra grâce à vous !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Labyrinthe Moussue ===
  {
    id = 'q7_labyrinthe', ch = 7, giver = 'Turtwig', target = 'Turtwig',
    unlock_dungeon = 'mossy_labyrinth', dungeon_name = "Labyrinthe Moussue",
    titre = "Les racines envahissantes",
    ask = {
      {'Turtwig', 'Worried', 'Les racines ligneuses de Torterra le Géant ont proliféré.'},
      {'Turtwig', 'Sad',     'Elles étouffent la flore du Labyrinthe Moussue et ferment les sentiers.'},
      {'Turtwig', 'Normal',  'Il faut élaguer le chemin avant que la forêt ne s effondre sur elle-même.'}
    },
    accept = {{'Turtwig', 'Happy', 'Merci ! Le labyrinthe commence au nord du grand vieux chêne !'}},
    refuse = {{'Turtwig', 'Sad',   'Tant pis... Je vais essayer d arracher la mousse tout seul.'}},
    pending= {{'Turtwig', 'Worried', 'Les sentiers du Labyrinthe Moussue sont-ils dégagés ?'}},
    solve  = {{'Turtwig', 'Worried', 'Les sentiers du Labyrinthe Moussue sont-ils dégagés ?'}},
    done   = {
      {'Turtwig', 'Inspired','HOURRA ! Les jeunes pousses ont à nouveau accès à la lumière !'},
      {'Turtwig', 'Happy',   'Notre forêt vous est éternellement reconnaissante !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Carrière Magmatique ===
  {
    id = 'q7_carriere', ch = 7, giver = 'Numel', target = 'Numel',
    unlock_dungeon = 'magma_quarry', dungeon_name = "Carrière Magmatique",
    titre = "Le charbon thermique",
    ask = {
      {'Numel', 'Sad',     'Pfff... Mes réserves de charbon thermique sont épuisées.'},
      {'Numel', 'Worried', 'Arkani la Flamme garde farouchement la mine centrale de la Carrière Magmatique.'},
      {'Numel', 'Normal',  'J ai besoin de quelques pépites de roche brûlante pour passer l hiver.'}
    },
    accept = {{'Numel', 'Happy', 'Pfff ! Chaleureux merci ! La carrière est dans la faille volcanique !'}},
    refuse = {{'Numel', 'Sad',   'Pfff... Je vais avoir froid à la bosse.'}},
    pending= {{'Numel', 'Worried', 'Avez-vous pu ramener le charbon de la Carrière Magmatique ?'}},
    solve  = {{'Numel', 'Worried', 'Avez-vous pu ramener le charbon de la Carrière Magmatique ?'}},
    done   = {
      {'Numel', 'Inspired','PFFF ! Quelle chaleur vivifiante dans ces minerais !'},
      {'Numel', 'Happy',   'Je suis réchauffée pour toute la saison ! Prenez cette récompense en or !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Toundra Désolée ===
  {
    id = 'q8_toundra', ch = 8, giver = 'Spheal', target = 'Spheal',
    unlock_dungeon = 'barren_tundra', dungeon_name = "Toundra Désolée",
    titre = "La cargaison gelée",
    ask = {
      {'Spheal', 'Sad',     'Aglagla... Ma livraison de baies a été prise dans une tempête de grêle.'},
      {'Spheal', 'Worried', 'Blizzarroi l Hiver la protège sur les hauteurs de la Toundra Désolée.'},
      {'Spheal', 'Normal',  'Qui osera affronter le blizzard pour me la rapporter ?'}
    },
    accept = {{'Spheal', 'Happy', 'Aglagla ! Merci ! Prenez le sentier qui monte vers les glaciers !'}},
    refuse = {{'Spheal', 'Sad',   'Aglagla... Mes nageoires sont trop gelées pour y aller.'}},
    pending= {{'Spheal', 'Worried', 'Avez-vous récupéré ma cargaison dans la Toundra Désolée ?'}},
    solve  = {{'Spheal', 'Worried', 'Avez-vous récupéré ma cargaison dans la Toundra Désolée ?'}},
    done   = {
      {'Spheal', 'Inspired','AGLAGLA ! Les baies sont encore parfaitement fraîches !'},
      {'Spheal', 'Happy',   'Vous êtes les héros des crêtes gelées !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Caverne Stérile ===
  {
    id = 'q8_caverne', ch = 8, giver = 'Aron', target = 'Aron',
    unlock_dungeon = 'barren_cavern', dungeon_name = "Caverne Stérile",
    titre = "Les filons d'acier",
    ask = {
      {'Aron', 'Worried', 'Croc... Les galeries d acier de la Caverne Stérile tremblent.'},
      {'Aron', 'Sad',     'Charmina le Sceau a scellé le passage vers le minerai ferreux.'},
      {'Aron', 'Normal',  'Notre colonie a besoin que vous brisiez ce sceau de roche.'}
    },
    accept = {{'Aron', 'Happy', 'Croc ! Formidable ! L entrée est au pied des éboulis de l est !'}},
    refuse = {{'Aron', 'Sad',   'Croc... Nous devrons jeûner de minerai.'}},
    pending= {{'Aron', 'Worried', 'Le passage de la Caverne Stérile est-il ouvert ?'}},
    solve  = {{'Aron', 'Worried', 'Le passage de la Caverne Stérile est-il ouvert ?'}},
    done   = {
      {'Aron', 'Happy',   'CROC ! CROC ! Le minerai est libre d accès !'},
      {'Aron', 'Inspired','Notre carapace sera plus solide que jamais grâce à vous !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Crête Craquelée ===
  {
    id = 'q8_crete', ch = 8, giver = 'Bagon', target = 'Bagon',
    unlock_dungeon = 'cracked_ridge', dungeon_name = "Crête Craquelée",
    titre = "Les ailes d'altitude",
    ask = {
      {'Bagon', 'Angry',   'Je veux voler ! Mais Drattak la Cime m interdit l accès au sommet !'},
      {'Bagon', 'Worried', 'Il dit que les secousses de la Crête Craquelée sont trop dangereuses.'},
      {'Bagon', 'Normal',  'Prouvez-lui que nous sommes assez forts pour atteindre le sommet !'}
    },
    accept = {{'Bagon', 'Happy', 'Génial ! La crête surplombe le vieux pont de corde !'}},
    refuse = {{'Bagon', 'Sad',   '...Je vais continuer à sauter depuis mon rocher en bas.'}},
    pending= {{'Bagon', 'Worried', 'Avez-vous vaincu le défi de la Crête Craquelée ?'}},
    solve  = {{'Bagon', 'Worried', 'Avez-vous vaincu le défi de la Crête Craquelée ?'}},
    done   = {
      {'Bagon', 'Inspired','YOUHOU ! Drattak a enfin reconnu mon courage !'},
      {'Bagon', 'Happy',   'Un jour je déploierai de grandes ailes rouges comme lui ! Merci !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Vallon Suspendu ===
  {
    id = 'q8_vallon', ch = 8, giver = 'Fletchling', target = 'Fletchling',
    unlock_dungeon = 'suspended_valley', dungeon_name = "Vallon Suspendu",
    titre = "La plume d'argent",
    ask = {
      {'Fletchling', 'Sad',     'Cuii... J ai lâché ma plume porte-bonheur au-dessus des brumes.'},
      {'Fletchling', 'Worried', 'Elle s est posée dans le Vallon Suspendu, gardé par Bruyverne le Cri.'},
      {'Fletchling', 'Normal',  'Pouvez-vous voler à mon secours pour me la rapporter ?'}
    },
    accept = {{'Fletchling', 'Happy', 'Cuii ! Merci ! Suivez les courants d air ascendants !'}},
    refuse = {{'Fletchling', 'Sad',   'Cuii... Mon nid sera triste sans elle.'}},
    pending= {{'Fletchling', 'Worried', 'Avez-vous retrouvé ma plume dans le Vallon Suspendu ?'}},
    solve  = {{'Fletchling', 'Worried', 'Avez-vous retrouvé ma plume dans le Vallon Suspendu ?'}},
    done   = {
      {'Fletchling', 'Inspired','CUII ! C est bien ma plume porte-bonheur !'},
      {'Fletchling', 'Happy',   'Que les vents vous soient toujours favorables, braves explorateurs !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Bassin Tari ===
  {
    id = 'q9_bassin', ch = 9, giver = 'Psyduck', target = 'Psyduck',
    unlock_dungeon = 'depleted_basin', dungeon_name = "Bassin Tari",
    titre = "La perle d'eau pure",
    ask = {
      {'Psyduck', 'Worried', 'Psyyy... J ai un mal de tête terrible à cause de la sécheresse.'},
      {'Psyduck', 'Sad',     'Léviator le Courroux a monopolisé la perle d eau pure au fond du Bassin Tari.'},
      {'Psyduck', 'Normal',  'Si vous la rapportez, la pluie apaisera mon crâne.'}
    },
    accept = {{'Psyduck', 'Happy', 'Psy ! Merci ! Le bassin descend sous la plaine de limon !'}},
    refuse = {{'Psyduck', 'Sad',   'Psyyy... Aïe... Ma tête...'}},
    pending= {{'Psyduck', 'Worried', 'Avez-vous trouvé la perle d eau du Bassin Tari ?'}},
    solve  = {{'Psyduck', 'Worried', 'Avez-vous trouvé la perle d eau du Bassin Tari ?'}},
    done   = {
      {'Psyduck', 'Inspired','PSY ! LA PERLE ! Mon mal de tête a complètement disparu !'},
      {'Psyduck', 'Happy',   'Vous êtes des magiciens de l eau, prenez ce trésor !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Marais Errants ===
  {
    id = 'q9_marais', ch = 9, giver = 'Lotad', target = 'Lotad',
    unlock_dungeon = 'wayward_wetlands', dungeon_name = "Marais Errants",
    titre = "Le nénuphar géant",
    ask = {
      {'Lotad', 'Sad',     'Plouf... Ma feuille s assèche sous les brumes acides.'},
      {'Lotad', 'Worried', 'Milobellus le Bassin veille sur les nénuphars géants des Marais Errants.'},
      {'Lotad', 'Normal',  'Pouvez-vous en cueillir une bouture pour guérir notre mare ?'}
    },
    accept = {{'Lotad', 'Happy', 'Plouf ! Merci ! Les marais s ouvrent à l est du grand étang !'}},
    refuse = {{'Lotad', 'Sad',   'Plouf... Ma feuille va finir par jaunir.'}},
    pending= {{'Lotad', 'Worried', 'Avez-vous la bouture de nénuphar des Marais Errants ?'}},
    solve  = {{'Lotad', 'Worried', 'Avez-vous la bouture de nénuphar des Marais Errants ?'}},
    done   = {
      {'Lotad', 'Happy',   'PLOUF ! Quelle feuille magnifique et vivace !'},
      {'Lotad', 'Inspired','Notre mare est sauvée et resplendit à nouveau !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Jungle Méridionale ===
  {
    id = 'q9_jungle', ch = 9, giver = 'Oddish', target = 'Oddish',
    unlock_dungeon = 'southern_jungle', dungeon_name = "Jungle Méridionale",
    titre = "La graine solaire",
    ask = {
      {'Oddish', 'Worried', 'La canopée de la Jungle Méridionale est devenue trop dense.'},
      {'Oddish', 'Sad',     'Roserade le Venin a emprisonné la graine solaire qui éclaire nos plantes.'},
      {'Oddish', 'Normal',  'Aidez-nous à percer la canopée pour ramener la lumière !'}
    },
    accept = {{'Oddish', 'Happy', 'Merci ! La jungle démarre derrière les grands banians de la côte !'}},
    refuse = {{'Oddish', 'Sad',   '...Nous ne pourrons plus faire de photosynthèse.'}},
    pending= {{'Oddish', 'Worried', 'La Jungle Méridionale a-t-elle retrouvé son soleil ?'}},
    solve  = {{'Oddish', 'Worried', 'La Jungle Méridionale a-t-elle retrouvé son soleil ?'}},
    done   = {
      {'Oddish', 'Inspired','LA LUMIÈRE ! Le soleil traverse enfin les feuilles !'},
      {'Oddish', 'Happy',   'Nos pétales dansent de joie ! Merci de tout cœur !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Gouffre Immergé ===
  {
    id = 'q9_gouffre', ch = 9, giver = 'Shellder', target = 'Shellder',
    unlock_dungeon = 'submerged_chasm', dungeon_name = "Gouffre Immergé",
    titre = "La conque abyssale",
    ask = {
      {'Shellder', 'Sad',     'Clac... J ai perdu la conque abyssale de ma famille.'},
      {'Shellder', 'Worried', 'Elle a glissé au fond du Gouffre Immergé, où règne Hyporoi le Fond.'},
      {'Shellder', 'Normal',  'Seuls de grands plongeurs peuvent descendre aussi bas.'}
    },
    accept = {{'Shellder', 'Happy', 'Clac ! Formidable ! Le gouffre est dans la faille sous-marine !'}},
    refuse = {{'Shellder', 'Sad',   'Clac... Ma coquille sonne creux sans elle.'}},
    pending= {{'Shellder', 'Worried', 'Avez-vous rapporté la conque du Gouffre Immergé ?'}},
    solve  = {{'Shellder', 'Worried', 'Avez-vous rapporté la conque du Gouffre Immergé ?'}},
    done   = {
      {'Shellder', 'Inspired','CLAC ! CLAC ! Vous entendez cet écho marin divin ?'},
      {'Shellder', 'Happy',   'C est l authentique chant des abysses ! Merci !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Sentier Enneigé ===
  {
    id = 'q10_sentier', ch = 10, giver = 'Snorunt', target = 'Snorunt',
    unlock_dungeon = 'snowbound_path', dungeon_name = "Sentier Enneigé",
    titre = "La cape du blizzard",
    ask = {
      {'Snorunt', 'Sad',     'Frrr... Ma cape de paille ne suffit plus contre le vent polaire.'},
      {'Snorunt', 'Worried', 'Momartik le Souffle conserve le tissu glacé sacré au bout du Sentier Enneigé.'},
      {'Snorunt', 'Normal',  'Pouvez-vous lui demander un fragment de ce tissu polaire ?'}
    },
    accept = {{'Snorunt', 'Happy', 'Frrr ! Merci ! Le sentier longe la grande crête du nord !'}},
    refuse = {{'Snorunt', 'Sad',   'Frrr... Je vais continuer à grelotter.'}},
    pending= {{'Snorunt', 'Worried', 'Avez-vous le tissu glacé du Sentier Enneigé ?'}},
    solve  = {{'Snorunt', 'Worried', 'Avez-vous le tissu glacé du Sentier Enneigé ?'}},
    done   = {
      {'Snorunt', 'Inspired','FRRR ! Quelle cape merveilleuse, je n ai plus froid du tout !'},
      {'Snorunt', 'Happy',   'Vous êtes de véritables légendes vivantes !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Col de la Foudre ===
  {
    id = 'q10_foudre', ch = 10, giver = 'Shinx', target = 'Shinx',
    unlock_dungeon = 'thunderstruck_pass', dungeon_name = "Col de la Foudre",
    titre = "Le paratonnerre antique",
    ask = {
      {'Shinx', 'Worried', 'Bzz ! Les orages continus menacent d irradier tout le village.'},
      {'Shinx', 'Angry',   'Magnézone l Éclair absorbe toute la foudre au sommet du Col de la Foudre !'},
      {'Shinx', 'Normal',  'Il faut réactiver le paratonnerre antique pour disperser les décharges.'}
    },
    accept = {{'Shinx', 'Happy', 'Bzz ! Excellent ! Le col se trouve par-delà les collines orageuses !'}},
    refuse = {{'Shinx', 'Sad',   'Bzz... Attention à la foudre en sortant.'}},
    pending= {{'Shinx', 'Worried', 'Les orages du Col de la Foudre sont-ils dispersés ?'}},
    solve  = {{'Shinx', 'Worried', 'Les orages du Col de la Foudre sont-ils dispersés ?'}},
    done   = {
      {'Shinx', 'Happy',   'BZZ ! Le ciel s est enfin dégagé et les étincelles sont douces !'},
      {'Shinx', 'Inspired','Votre courage électrise tout Metano !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Falaises de l'Envol ===
  {
    id = 'q10_falaises', ch = 10, giver = 'Pidgey', target = 'Pidgey',
    unlock_dungeon = 'flyaway_cliffs', dungeon_name = "Falaises de l'Envol",
    titre = "L'œuf du nid suprême",
    ask = {
      {'Pidgey', 'Sad',     'Cui ! Une bourrasque a emporté un des œufs de notre couvée !'},
      {'Pidgey', 'Worried', 'Il repose au nid de Roucarnage le Sommet sur les Falaises de l Envol.'},
      {'Pidgey', 'Normal',  'Pouvez-vous grimper sur les crêtes pour nous le rapporter en sécurité ?'}
    },
    accept = {{'Pidgey', 'Happy', 'Cui ! Merci ! Les falaises s élèvent face au ciel austral !'}},
    refuse = {{'Pidgey', 'Sad',   'Cui... Notre nid restera incomplet.'}},
    pending= {{'Pidgey', 'Worried', 'Avez-vous retrouvé l œuf sur les Falaises de l Envol ?'}},
    solve  = {{'Pidgey', 'Worried', 'Avez-vous retrouvé l œuf sur les Falaises de l Envol ?'}},
    done   = {
      {'Pidgey', 'Inspired','L ŒUF ! Il est entier et chaud !'},
      {'Pidgey', 'Happy',   'Vous avez sauvé l avenir de nos cieux ! Merci mille fois !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE : Cime d'Argent Oubliée ===
  {
    id = 'q10_cime', ch = 10, giver = 'Ralts', target = 'Ralts',
    unlock_dungeon = 'forgotten_silver_spire', dungeon_name = "Cime d'Argent Oubliée",
    titre = "Le diadème d'argent",
    ask = {
      {'Ralts', 'Sad',     'Hummm... Le diadème d argent qui protège nos esprits a été volé.'},
      {'Ralts', 'Worried', 'Kaorine l Antique l a scellé dans l autel de la Cime d Argent Oubliée.'},
      {'Ralts', 'Normal',  'Seuls des esprits nobles peuvent briser le sceau de cette cime sacrée.'}
    },
    accept = {{'Ralts', 'Happy', 'Hummm ! Merci ! La cime argentée brille au-dessus des nuages du nord !'}},
    refuse = {{'Ralts', 'Sad',   'Hummm... Nos rêves resteront troublés par l ombre.'}},
    pending= {{'Ralts', 'Worried', 'Le diadème de la Cime d Argent Oubliée est-il libéré ?'}},
    solve  = {{'Ralts', 'Worried', 'Le diadème de la Cime d Argent Oubliée est-il libéré ?'}},
    done   = {
      {'Ralts', 'Inspired','HUMMM ! LE DIADÈMES ! Sa clarté apaise instantanément nos esprits !'},
      {'Ralts', 'Happy',   'Que la lumière céleste guide éternellement vos pas !'}
    },
    undertow = "mission personnelle de déblocage donjon",
  },

  ---------------------------------------------------------------
  -- CHAPITRE 6 — la ville respire encore
  ---------------------------------------------------------------
  {
    id = 'q6_petitdej', ch = 6, giver = 'Furret', target = 'Zigzagoon',
    titre = "Le chapardeur du petit-déjeuner",
    ask = {
      {'Furret', 'Worried', "Trois matins de suite.[pause=20] Trois."},
      {'Furret', 'Angry',   "Quelqu'un me pique ma part avant que je descende.[pause=20] Je veux un nom."},
      {'Furret', 'Sad',     "Je ne veux pas de punition.[pause=25] Je veux juste savoir."},
    },
    accept = {'Furret', 'Happy', "Merci.[pause=20] Commencez par ceux qui se lèvent tôt."},
    refuse = {'Furret', 'Sad',   "...Bon. Je mangerai plus tôt, alors."},
    pending= {'Furret', 'Worried', "Alors ?[pause=20] Vous avez un nom ?"},
    solve = {
      {'Zigzagoon', 'Surprised', "Moi ?![pause=20] Pourquoi vous me regardez comme ça ?"},
      {'Zigzagoon', 'Sad',       "...Bon. C'est moi.[pause=25] Mais j'ai une raison !"},
      {'Zigzagoon', 'Worried',   "Je pars avant l'aube depuis une semaine.[pause=20] Je surveille la route du nord."},
      {'Zigzagoon', 'Sad',       "Il y a moins de monde qui passe.[pause=25] Beaucoup moins. Ça m'inquiète."},
      {'Zigzagoon', 'Determined',"Alors je pars tôt. Et j'ai faim. Voilà."},
    },
    done = {
      {'Furret', 'Surprised', "Il surveille la route ?[pause=25] Tout seul ? À l'aube ?"},
      {'Furret', 'Sad',       "...Le petit imbécile.[pause=20] Il aurait pu demander."},
      {'Furret', 'Determined',"Dites-lui que je lui mettrai deux parts de côté.[pause=25] Deux."},
    },
    undertow = "moins de voyageurs sur les routes",
  },

  {
    id = 'q6_etal', ch = 6, giver = 'Bellossom', target = 'Roselia',
    titre = "L'étal à moitié vide",
    ask = {
      {'Bellossom', 'Worried', "Mon étal est vide et ce n'est pas la saison qui veut ça."},
      {'Bellossom', 'Sad',     "Ma cueilleuse ne monte plus au nord.[pause=25] Elle ne me dit pas pourquoi."},
      {'Bellossom', 'Normal',  "Vous, elle vous parlera peut-être.[pause=20] Vous n'êtes pas sa patronne."},
    },
    accept = {'Bellossom', 'Normal', "Elle est près des fleurs.[pause=20] Elle y est toujours."},
    refuse = {'Bellossom', 'Sigh',   "Je comprends.[pause=20] Vous avez une forêt à sauver."},
    pending= {'Bellossom', 'Worried', "Vous lui avez parlé ?"},
    solve = {
      {'Roselia', 'Sad',      "Elle vous envoie, c'est ça.[pause=25] Je m'y attendais."},
      {'Roselia', 'Worried',  "Je n'ai pas peur des Pokémon sauvages.[pause=20] J'y vais depuis dix ans."},
      {'Roselia', 'Sad',      "C'est le silence.[pause=30] Là-haut, il n'y a plus un chant d'oiseau."},
      {'Roselia', 'Pain',     "On s'habitue au danger.[pause=25] Pas au silence."},
      {'Roselia', 'Determined',"Dites-lui que j'irai. Mais accompagnée.[pause=20] Plus jamais seule."},
    },
    done = {
      {'Bellossom', 'Surprised', "Le silence...[pause=25] Elle ne m'avait rien dit."},
      {'Bellossom', 'Sad',       "J'ai cru qu'elle devenait paresseuse.[pause=25] J'ai eu honte de le penser."},
      {'Bellossom', 'Determined',"J'irai avec elle demain.[pause=20] L'étal attendra."},
    },
    undertow = "le silence gagne les hauteurs",
  },

  {
    id = 'q6_autographe', ch = 6, giver = 'Marill', target = 'Aria',
    titre = "Un autographe, s'il vous plaît",
    ask = {
      {'Marill', 'Happy',   "Vous êtes des explorateurs ![pause=20] Des VRAIS !"},
      {'Marill', 'Inspired',"J'ai vu passer trois Pokémon magnifiques hier.[pause=20] Une équipe célèbre !"},
      {'Marill', 'Sad',     "J'ai pas osé leur parler.[pause=25] Vous pourriez leur demander un autographe ?"},
    },
    accept = {'Marill', 'Happy', "OUI ![pause=20] Merci merci merci !"},
    refuse = {'Marill', 'Sad',   "Ah...[pause=25] C'est pas grave. Elles font peur, hein ?"},
    pending= {'Marill', 'Happy', "Alors ?[pause=20] Vous leur avez demandé ?"},
    solve = {
      {'Aria', 'Surprised', "Un autographe ?[pause=25] Pour un petit ?"},
      {'Aria', 'Happy',     "Adagio va détester.[pause=20] Donnez-moi ça."},
      {'Aria', 'Normal',    "Voilà.[pause=25] Dites-lui de ne pas devenir explorateur."},
      {'Aria', 'Sad',       "...Non. Ne lui dites pas ça.[pause=25] Dites-lui de bien s'entraîner."},
    },
    done = {
      {'Marill', 'Inspired', "ELLE A SIGNÉ ![pause=20] Elle a VRAIMENT signé !"},
      {'Marill', 'Happy',    "Je vais m'entraîner tous les jours ![pause=20] Tous les jours !"},
      {'Marill', 'Normal',   "...Vous croyez qu'un jour on me demandera un autographe, à moi ?"},
    },
    undertow = "la releve regarde, et decide",
  },

  ---------------------------------------------------------------
  -- CHAPITRE 7 — premières secousses et inquiétude
  ---------------------------------------------------------------
  {
    id = 'q7_seisme', ch = 7, giver = 'Quagsire', target = 'Cranidos',
    titre = "Les vibrations du sous-sol",
    ask = {
      {'Quagsire', 'Worried', "L'eau de mon bassin bouge tout le temps depuis hier."},
      {'Quagsire', 'Sad',     "Comme de petites vagues sauvages, mais sans aucun vent."},
      {'Quagsire', 'Normal',  "Le jeune Cranidos là-bas passe son temps le nez collé contre la roche. Demandez-lui s'il sent quelque chose."},
    },
    accept = {'Quagsire', 'Normal', "Faites attention à vos pieds en marchant."},
    refuse = {'Quagsire', 'Normal', "Pas de souci, ça doit être mon imagination."},
    pending= {'Quagsire', 'Worried', "Vous avez trouvé d'où viennent ces rides sur l'eau ?"},
    solve = {
      {'Cranidos', 'Shock', "Moi ? Oui, ma tête résonne !"},
      {'Cranidos', 'Worried', "Quand je pose mes cornes sur la falaise au nord, ça fait 'bzzz' tout le temps."},
      {'Cranidos', 'Sad',     "Le sol ne dort pas. Quelque chose pousse très fort très loin d'ici."},
      {'Cranidos', 'Determined', "C'est comme un grand tambour géant sous la terre. J'espère qu'elle ne va pas se fendre !"},
    },
    done = {
      {'Quagsire', 'Sad', "Un tambour sous la terre..."},
      {'Quagsire', 'Normal', "Ce gamin a le crâne solide, s'il le dit, c'est vrai."},
      {'Quagsire', 'Worried', "Les anciens racontent que lorsque la terre grogne, les étoiles finissent par tomber..."},
    },
    undertow = "la terre transmet des tensions lointaines",
  },

  {
    id = 'q7_peur', ch = 7, giver = 'Oddish', target = 'Noctowl',
    titre = "L'ombre des arbres",
    ask = {
      {'Oddish', 'Sad', "Je n'ose plus aller jouer près du bosquet nord."},
      {'Oddish', 'Worried', "Il y a des ombres bizarres qui s'agitent, froides comme de la glace."},
      {'Oddish', 'Pain', "Elles n'ont pas de visage, juste de grands yeux flous."},
    },
    accept = {'Oddish', 'Happy', "Demandez au vieux Noarfang, il sait tout sur la nuit !"},
    refuse = {'Oddish', 'Sad', "D'accord... Restez bien à la lumière."},
    pending= {'Oddish', 'Worried', "Vous avez parlé à Noarfang ?"},
    solve = {
      {'Noctowl', 'Normal', "Des ombres glacées près du bosquet ?"},
      {'Noctowl', 'Worried', "Ce ne sont pas des spectres ordinaires. L'air se trouble à cause des anomalies atmosphériques."},
      {'Noctowl', 'Sad', "Quand les courants thermiques s'effondrent, les illusions se matérialisent sous forme de brume froide."},
      {'Noctowl', 'Determined', "Dites au petit que ce n'est que de la vapeur condensée... Même si cela cache un mal bien réel."},
    },
    done = {
      {'Oddish', 'Surprised', "De la vapeur froide ?"},
      {'Oddish', 'Happy', "Ouf, j'ai cru que c'étaient des monstres mangeurs de feuilles !"},
      {'Oddish', 'Normal', "Mais pourquoi l'air devient-il si bizarre ?"},
    },
    undertow = "les perturbations thermiques créent des anomalies locales",
  },

  {
    id = 'q7_eau', ch = 7, giver = 'Spheal', target = 'Relicanth',
    titre = "La source tarie",
    ask = {
      {'Spheal', 'Sad', "La petite fontaine de la place ne coule presque plus."},
      {'Spheal', 'Normal', "Elle était si fraîche d'habitude !"},
      {'Spheal', 'Worried', "Le doyen Relicanth doit savoir d'où vient l'eau de la colline."},
    },
    accept = {'Spheal', 'Happy', "Allez le voir près de son bassin !"},
    refuse = {'Spheal', 'Normal', "Tant pis, je boirai de l'eau tiède."},
    pending= {'Spheal', 'Worried', "L'eau va revenir ?"},
    solve = {
      {'Relicanth', 'Normal', "La fontaine faiblit, dites-vous ?"},
      {'Relicanth', 'Worried', "C'est logique. Les galeries souterraines se réchauffent."},
      {'Relicanth', 'Sad', "L'eau s'évapore dans les abysses avant de pouvoir remonter jusqu'à notre surface."},
      {'Relicanth', 'Determined', "Un grand feu couve sous nos pieds, mes enfants. L'équilibre se brise lentement."},
    },
    done = {
      {'Spheal', 'Surprised', "L'eau s'évapore en dessous ?"},
      {'Spheal', 'Sad', "Mais alors, la ville va finir par avoir très soif ?"},
      {'Spheal', 'Normal', "Je vais économiser mes réserves d'eau douce !"},
    },
    undertow = "les eaux souterraines s'assèchent sous l'effet de la chaleur",
  },

  ---------------------------------------------------------------
  -- CHAPITRE 8 — la tension grimpe d'un cran
  ---------------------------------------------------------------
  {
    id = 'q8_cristaux', ch = 8, giver = 'Mawile', target = 'Bisharp',
    titre = "Les éclats perdus",
    ask = {
      {'Mawile', 'Worried', "Je cherche des morceaux de pierre de lune pour mes sculptures."},
      {'Mawile', 'Sad', "Le garde Scalproie m'interdit d'aller aux falaises."},
      {'Mawile', 'Normal', "Allez lui demander pourquoi il est si sévère !"},
    },
    accept = {'Mawile', 'Happy', "S'il vous plaît, faites-le changer d'avis !"},
    refuse = {'Mawile', 'Sad', "Oh... Mes sculptures resteront ternes."},
    pending= {'Mawile', 'Worried', "Scalproie a dit oui ?"},
    solve = {
      {'Bisharp', 'Determined', "Pourquoi j'interdis l'accès ?"},
      {'Bisharp', 'Angry', "Parce que la roche s'effrite sans raison !"},
      {'Bisharp', 'Worried', "De grandes failles apparaissent sur les parois cristallines, comme si la montagne ployait sous un poids invisible."},
      {'Bisharp', 'Sad', "C'est trop dangereux d'approcher des corniches. Dites-lui de sculpter du bois."},
    },
    done = {
      {'Mawile', 'Surprised', "La montagne s'effrite ?"},
      {'Mawile', 'Sad', "Pourtant, le cristal est si solide d'habitude..."},
      {'Mawile', 'Normal', "Je vais utiliser du vieux chêne. C'est plus sûr."},
    },
    undertow = "la structure géologique de la région se fragilise",
  },

  {
    id = 'q8_reves', ch = 8, giver = 'Jigglypuff', target = 'Sonata',
    titre = "Le chant des insomnies",
    ask = {
      {'Jigglypuff', 'Sad', "Je...[pause=15] Je ne peux plus chanter mes berceuses."},
      {'Jigglypuff', 'Pain', "Ma gorge est toute serrée de peur, et personne ne dort bien."},
      {'Jigglypuff', 'Worried', "Magirêve passe ses nuits à écouter le vent. Elle doit savoir ce qui cloche."},
    },
    accept = {'Jigglypuff', 'Happy', "Merci...[pause=10] Retrouvez-la sur la colline."},
    refuse = {'Jigglypuff', 'Sad', "Je vais essayer de boire du miel chaud..."},
    pending= {'Jigglypuff', 'Worried', "Magirêve a entendu mes soupirs ?"},
    solve = {
      {'Sonata', 'Normal', "Le petit Rondoudou s'inquiète pour son chant ?"},
      {'Sonata', 'Worried', "Ce n'est pas le vent qui l'empêche de chanter, c'est l'angoisse ambiante."},
      {'Sonata', 'Sad', "Une onde d'inquiétude muette traverse la vallée chaque nuit, comme un écho de l'Abîme."},
      {'Sonata', 'Determined', "Ses mélodies douces n'arrivent plus à percer cette lourde chape. Il lui faut du courage, pas du miel."},
    },
    done = {
      {'Jigglypuff', 'Surprised', "De l'angoisse dans le vent ?"},
      {'Jigglypuff', 'Determined', "Alors je chanterai plus fort !"},
      {'Jigglypuff', 'Happy', "La musique doit chasser la peur, pas l'inverse !"},
    },
    undertow = "l'anxiété collective perturbe le sommeil de la ville",
  },

  {
    id = 'q8_climat', ch = 8, giver = 'Vileplume', target = 'Tropius',
    titre = "La fanaison précoce",
    ask = {
      {'Vileplume', 'Sad', "Regardez mes pétales... Ils perdent leur éclat et flétrissent."},
      {'Vileplume', 'Worried', "La terre est humide, mais mes racines se sentent malades."},
      {'Vileplume', 'Normal', "Tropius a beaucoup voyagé, il sait si l'air est empoisonné."},
    },
    accept = {'Vileplume', 'Normal', "Il est près de l'entrée de la guilde."},
    refuse = {'Vileplume', 'Sad', "Je vais essayer de rester à l'ombre..."},
    pending= {'Vileplume', 'Worried', "Tropius a une idée ?"},
    solve = {
      {'Tropius', 'Normal', "Les plantes perdent leur éclat ?"},
      {'Tropius', 'Worried', "Le vent du nord n'apporte plus d'humidité depuis la mer."},
      {'Tropius', 'Sad', "Il transporte une fine poussière grise, invisible à l'œil nu, qui étouffe les feuilles."},
      {'Tropius', 'Determined', "Le ciel se charge de cendres froides. Quelque chose brûle ou s'éteint là-haut."},
    },
    done = {
      {'Vileplume', 'Surprised', "De la poussière grise dans l'air ?"},
      {'Vileplume', 'Sad', "C'est pour ça que le soleil semble si pâle depuis des semaines..."},
      {'Vileplume', 'Normal', "Je vais laver mes feuilles tous les matins avec de l'eau claire."},
    },
    undertow = "les courants aériens charrient des résidus atmosphériques anormaux",
  },

  ---------------------------------------------------------------
  -- CHAPITRE 9 — l'étau se resserre
  ---------------------------------------------------------------
  {
    id = 'q9_rumeurs', ch = 9, giver = 'Nidoqueen', target = 'Luxray',
    titre = "Les chuchotements de la place",
    ask = {
      {'Nidoqueen', 'Worried', "Tout le monde s'observe de travers ce matin."},
      {'Nidoqueen', 'Sad', "Les marchands chuchotent dès qu'un étranger approche."},
      {'Nidoqueen', 'Normal', "Luxray fait ses rondes pour la Fédération. Allez lui parler de cette ambiance."},
    },
    accept = {'Nidoqueen', 'Normal', "Faites cela discrètement."},
    refuse = {'Nidoqueen', 'Sigh', "Mieux vaut ne pas s'en mêler, vous avez raison."},
    pending= {'Nidoqueen', 'Worried', "La Fédération est nerveuse aussi ?"},
    solve = {
      {'Luxray', 'Normal', "L'ambiance de la place ?"},
      {'Luxray', 'Determined', "La Fédération est sur les dents. Les ordres viennent d'en haut."},
      {'Luxray', 'Worried', "On nous demande de surveiller les allées et venues de tous les explorateurs."},
      {'Luxray', 'Sad', "Ils cherchent un coupable pour les dérèglements climatiques. La méfiance s'installe partout."},
    },
    done = {
      {'Nidoqueen', 'Surprised', "La Fédération cherche un coupable ?"},
      {'Nidoqueen', 'Sad', "Mais nous n'y sommes pour rien..."},
      {'Nidoqueen', 'Determined', "Il faut rester soudés. Ne les laissons pas nous diviser."},
    },
    undertow = "les autorités cherchent activement des boucs émissaires",
  },

  {
    id = 'q9_fugitifs', ch = 9, giver = 'Camerupt', target = 'Medicham',
    titre = "Le ravitaillement secret",
    ask = {
      {'Camerupt', 'Worried', "Je prépare de grands sacs de baies séchées et de graines."},
      {'Camerupt', 'Sad', "Ce n'est pas pour la boutique. Je veux les cacher en cas d'urgence."},
      {'Camerupt', 'Normal', "Charmina m'aide à faire l'inventaire, mais elle a l'air si pensive."},
    },
    accept = {'Camerupt', 'Normal', "Allez la voir, elle est près du stand d'entraînement."},
    refuse = {'Camerupt', 'Normal', "D'accord, je finirai mes paquets tout seul."},
    pending= {'Camerupt', 'Worried', "Elle vous a dit pourquoi elle soupire ?"},
    solve = {
      {'Medicham', 'Normal', "Pourquoi je soupire ?"},
      {'Medicham', 'Worried', "Je médite sur l'avenir, et mes visions sont sombres."},
      {'Medicham', 'Sad', "Le vent tourne. Bientôt, la ville ne sera plus un refuge sûr pour personne."},
      {'Medicham', 'Determined', "Conseillez à Camerupt de garder un sac de voyage bien rempli sous la paille. Juste au cas où..."},
    },
    done = {
      {'Camerupt', 'Surprised', "Un sac de voyage sous la paille ?"},
      {'Camerupt', 'Sad', "Elle craint que nous devions fuir la ville ?"},
      {'Camerupt', 'Determined', "C'est impensable... Mais je vais quand même doubler les rations."},
    },
    undertow = "les pressentiments d'une fuite imminente se propagent",
  },

  {
    id = 'q9_cloche', ch = 9, giver = 'Ledian', target = 'Audino',
    titre = "L'alarme silencieuse",
    ask = {
      {'Ledian', 'Worried', "La cloche d'alarme de la guilde est fêlée."},
      {'Ledian', 'Sad', "Si un danger arrive du ciel, personne n'entendra le signal."},
      {'Ledian', 'Normal', "L'infirmière Nanméouïe a de précieux onguents pour ressouder les métaux légers."},
    },
    accept = {'Ledian', 'Happy', "Demandez-lui un flacon de sève réparatrice !"},
    refuse = {'Ledian', 'Sad', "Si la cloche reste muette... Espérons qu'on n'en ait pas besoin."},
    pending= {'Ledian', 'Worried', "Elle a pu vous donner la sève ?"},
    solve = {
      {'Audino', 'Normal', "De la sève pour la cloche d'alarme ?"},
      {'Audino', 'Worried', "Bien sûr, tenez. Mais j'ai bien peur qu'une simple cloche ne suffise plus."},
      {'Audino', 'Sad', "Les blessures de la terre ne s'effacent pas avec du métal soudé."},
      {'Audino', 'Determined', "Quand le ciel se mettra en colère, il faudra courir, pas seulement sonner l'alarme."},
    },
    done = {
      {'Ledian', 'Surprised', "Courir au lieu de sonner ?"},
      {'Ledian', 'Sad', "Ses paroles font froid dans le dos..."},
      {'Ledian', 'Normal', "La cloche est réparée. Espérons que son timbre reste clair."},
    },
    undertow = "les infrastructures de sécurité de la ville deviennent dérisoires",
  },

  ---------------------------------------------------------------
  -- CHAPITRE 10 — au bord du gouffre
  ---------------------------------------------------------------
  {
    id = 'q10_derniervoeu', ch = 10, giver = 'Bagon', target = 'Adagio',
    titre = "L'envol impossible",
    ask = {
      {'Bagon', 'Inspired', "Je veux voler ! Je veux monter tout en haut des nuages, au-delà de la brume !"},
      {'Bagon', 'Sad', "Mais mes petites ailes ne poussent pas, et le ciel est si noir."},
      {'Bagon', 'Normal', "La grande Sucreine dit que seuls ceux qui ont du style méritent de s'élever. Demandez-lui son secret !"},
    },
    accept = {'Bagon', 'Happy', "Allez la voir, elle est près du grand étal de luxe !"},
    refuse = {'Bagon', 'Sad', "Je... Je vais continuer à sauter depuis mon rocher alors."},
    pending= {'Bagon', 'Worried', "Elle vous a donné son secret pour voler ?"},
    solve = {
      {'Adagio', 'Surprised', "Ce petit Draby veut s'élever au-dessus de la brume ?"},
      {'Adagio', 'Normal', "Quelle idée saugrenue par un temps pareil."},
      {'Adagio', 'Sad', "Mais au moins, il a l'ambition de fuir cette médiocrité ambiante."},
      {'Adagio', 'Determined', "Dites-lui de ne pas attendre que ses ailes poussent. S'il veut partir, qu'il coure de toutes ses forces avant que les portes ne se ferment définitivement."},
    },
    done = {
      {'Bagon', 'Surprised', "Courir avant que ça ne ferme ?"},
      {'Bagon', 'Inspired', "Elle a raison ! Je vais m'entraîner à courir super vite !"},
      {'Bagon', 'Happy', "Comme ça, je prendrai tellement d'élan que je finirai par toucher les nuages !"},
    },
    undertow = "l'urgence de l'évacuation commence à toucher les plus jeunes",
  },

  {
    id = 'q10_lettre', ch = 10, giver = 'Wooper_Girl', target = 'Growlithe_Desk',
    titre = "La lettre sans réponse",
    ask = {
      {'Wooper_Girl', 'Sad', "J'ai écrit une jolie lettre pour ma cousine qui habite au Bourg Comptoir."},
      {'Wooper_Girl', 'Worried', "Mais le facteur n'est pas passé depuis des jours."},
      {'Wooper_Girl', 'Normal', "Caninos au guichet refuse de prendre mon enveloppe. Pourquoi ?"},
    },
    accept = {'Wooper_Girl', 'Normal', "Demandez-lui s'il a perdu son sac postal !"},
    refuse = {'Wooper_Girl', 'Sad', "Ma lettre va rester toute mouillée sous la pluie..."},
    pending= {'Wooper_Girl', 'Worried', "Le guichet postal est toujours fermé ?"},
    solve = {
      {'Growlithe_Desk', 'Normal', "Pourquoi je refuse la lettre ?"},
      {'Growlithe_Desk', 'Sad', "Ce n'est pas de ma faute, les petits."},
      {'Growlithe_Desk', 'Worried', "Les routes vers le sud et Bourg Comptoir sont totalement bloquées par un dôme d'électricité statique et de brume."},
      {'Growlithe_Desk', 'Determined', "Aucun messager ne peut traverser sans risquer sa vie. La ville est coupée du reste du monde."},
    },
    done = {
      {'Wooper_Girl', 'Sad', "La ville est coupée du monde ?"},
      {'Wooper_Girl', 'Pain', "Alors ma cousine ne saura jamais que j'ai appris à nager..."},
      {'Wooper_Girl', 'Normal', "Je vais garder la lettre dans ma poche, bien au chaud, pour lui donner plus tard."},
    },
    undertow = "l'isolement complet de Metano Town se matérialise",
  },

  {
    id = 'q10_espoir', ch = 10, giver = 'Sentret', target = 'Relicanth',
    titre = "La dernière lueur",
    ask = {
      {'Sentret', 'Sad', "La nuit est devenue si noire, et les lampadaires de la ville s'éteignent les uns après les autres."},
      {'Sentret', 'Worried', "J'ai peur du noir complet. Je cherche une lueur qui ne s'éteint jamais."},
      {'Sentret', 'Normal', "Le vieux Relicanth dit qu'il a des pierres brillantes tout au fond de son étang."},
    },
    accept = {'Sentret', 'Normal', "S'il vous plaît, demandez-lui si je peux en avoir une."},
    refuse = {'Sentret', 'Sad', "D'accord, je fermerai les yeux très fort sous ma couverture."},
    pending= {'Sentret', 'Worried', "Il a accepté de partager sa lumière ?"},
    solve = {
      {'Relicanth', 'Normal', "Une lueur qui ne s'éteint jamais pour Fouinette ?"},
      {'Relicanth', 'Happy', "Ah, l'enfance... Tenez, prenez cette pierre luminescente des grands fonds."},
      {'Relicanth', 'Sad', "Elle a brillé dans les abysses pendant des siècles sans jamais faiblir."},
      {'Relicanth', 'Determined', "Dites-lui que tant que nous gardons cette lumière avec nous, l'obscurité du ciel ne pourra pas nous atteindre."},
    },
    done = {
      {'Sentret', 'Inspired', "Wouah ! Elle brille comme une petite étoile verte !"},
      {'Sentret', 'Happy', "Elle est si douce et si chaude dans mes pattes !"},
      {'Sentret', 'Normal', "Je n'aurai plus jamais peur de la nuit. Je veillerai sur elle, promis !"},
    },
    undertow = "la recherche d'espoir et de réconfort face aux ténèbres imminentes",
  },

  ---------------------------------------------------------------
  -- CHAPITRE 8 — la requête de Ceili : le Village des Shaymin
  ---------------------------------------------------------------
  -- Quatrième requête du ch8, à part des trois autres : c'est Ceili
  -- (Spinda) qui l'affiche au comptoir, pas un habitant de la place.
  --
  -- ANTERIORITE ASSUMEE. Raikou est deja un Ancrage du Livre II
  -- (storm_bell / crete_voilee / arene_hautes_plaines, ch16). Il
  -- n'est PAS vaincu ici : le duo le deloge, il repart de lui-meme.
  -- La vraie confrontation reste celle du ch16, et cette rencontre
  -- lui donne du poids au lieu de la vider — meme traitement que
  -- Zeraora au ch6.
  --
  -- TEST DU DIALOGUE DE BOSS applique aux repliques de Raikou :
  --   « Ce sommet porte l'orage. Je m'y arrete quand il gronde. »
  --     -> information concrete sur SA motivation, verifiable
  --        (il suit les orages), et propre a lui seul.
  --   « Je ne les avais pas vus. Ils sont petits, et je suis vaste. »
  --     -> pas de malveillance : l'indifference d'un colosse. Fonde
  --        sur un fait de la scene (les Shaymin sont sous ses pattes).
  --   « Vous auriez pu m'attaquer. Vous avez parle. Je m'en
  --     souviendrai. »
  --     -> fait avancer la relation, et pose explicitement le
  --        rappel du ch16. Ne peut appartenir qu'a ce moment-la.
  {
    id = 'q8_shaymin', ch = 8, giver = 'Spinda', target = 'Shaymin_Doyenne',
    titre = "Le village sous l'orage",
    ask = {
      {'Spinda', 'Worried',  "Une lettre du Val Fleuri.[pause=20] L'écriture tremble tellement que j'ai mis une heure à la lire."},
      {'Spinda', 'Sad',      "Quelque chose s'est installé au sommet du Pic Céleste.[pause=25] Depuis, la foudre tombe sans arrêt sur le val."},
      {'Spinda', 'Normal',   "Les Shaymin ne peuvent plus sortir de chez eux.[pause=20] Ils ne demandent pas qu'on se batte."},
      {'Spinda', 'Determined',"Ils demandent qu'on aille voir.[pause=25] C'est tout."},
    },
    accept = {'Spinda', 'Happy',  "Merci.[pause=20] Montez doucement : là-haut, l'air est mince."},
    refuse = {'Spinda', 'Sad',    "Je comprends.[pause=25] Je garde la lettre au comptoir, au cas où."},
    pending= {'Spinda', 'Worried',"Toujours pas monté ?[pause=20] La foudre n'attend pas, elle."},
    solve = {
      {'Shaymin_Doyenne', 'Worried',  "Vous êtes montés jusqu'ici ?[pause=25] Personne ne monte jamais jusqu'ici."},
      {'Shaymin_Doyenne', 'Sad',      "Il est arrivé il y a six jours.[pause=20] Il ne nous a rien fait."},
      {'Shaymin_Doyenne', 'Sad',      "C'est bien ça, le problème.[pause=25] Il ne nous a même pas remarqués."},
      {'Shaymin_Cadet',   'Crying',   "La foudre a brûlé le pré du haut ![pause=20] Il ne reste plus rien !"},
      {'Shaymin_Eclaireur','Determined',"J'ai essayé de monter lui parler.[pause=25] Je n'ai pas dépassé la troisième corniche."},
      {'Shaymin_Doyenne', 'Normal',   "Alors montez, vous.[pause=25] Et ne l'attaquez pas.[pause=20] Parlez-lui."},
      {'Raikou', 'Normal',     "Ce sommet porte l'orage.[pause=25] Je m'y arrête quand il gronde."},
      {'Raikou', 'Surprised',  "En dessous ?[pause=30] Je ne les avais pas vus.[pause=20] Ils sont petits, et je suis vaste."},
      {'Raikou', 'Normal',     "Six jours de foudre sur un pré.[pause=25] Ce n'était pas contre eux."},
      {'Raikou', 'Determined', "Vous auriez pu m'attaquer.[pause=30] Vous avez parlé.[pause=20] Je m'en souviendrai."},
    },
    done = {
      {'Shaymin_Doyenne', 'Surprised', "Le ciel s'est dégagé d'un coup.[pause=25] On a cru que c'était une accalmie."},
      {'Shaymin_Doyenne', 'Happy',     "Puis on a vu la lumière partir vers le nord.[pause=20] Il est parti."},
      {'Shaymin_Cadet',   'Joyous',    "Le pré va repousser ![pause=20] Gratiane dit qu'il repousse toujours !"},
      {'Shaymin_Doyenne', 'Normal',    "Il reviendra, un jour.[pause=25] Les orages reviennent toujours."},
      {'Shaymin_Doyenne', 'Determined',"Mais maintenant il sait qu'on est là.[pause=25] Ça change tout."},
    },
    undertow = "un colosse qui ne voyait pas ce qu'il ecrasait — et qui, une fois qu'on le lui dit, s'en va",
  },
}

--------------------------------------------------------------------
-- OUTILS
--------------------------------------------------------------------
local function say(who, emo, txt)
  if who == nil then return end
  UI:SetSpeaker(who)
  if emo ~= nil then GeneralFunctions.SetEmotion(emo) end
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(8)
end

local function line(t)
  local c = CH(t[1])
  if c == nil then return end
  say(c, t[2], t[3])
end

--Requetes d'un chapitre donne.
function SideQuests.OfChapter(ch)
  local out = {}
  for _, q in ipairs(SideQuests.LIST) do
    if q.ch == ch then table.insert(out, q) end
  end
  return out
end

--Combien reste-t-il a rendre ?
function SideQuests.Remaining(ch)
  local s = SideQuests.Ensure()
  local n = 0
  for _, q in ipairs(SideQuests.OfChapter(ch)) do
    if not s.Done[q.id] then n = n + 1 end
  end
  return n
end

--Le chapitre peut-il se cloturer ?
function SideQuests.AllDone(ch)
  return SideQuests.Remaining(ch) == 0
end

local function find(id)
  for _, q in ipairs(SideQuests.LIST) do
    if q.id == id then return q end
  end
end

--------------------------------------------------------------------
-- INTERACTION AVEC LE DEMANDEUR
--------------------------------------------------------------------
-- Renvoie true si le PNJ avait quelque chose a dire (la scene a eu
-- lieu), false sinon — le ground enchaine alors sur son dialogue
-- habituel. Aucun PNJ ne perd sa replique de base.
function SideQuests.TalkGiver(inst, ch)
  local s = SideQuests.Ensure()
  for _, q in ipairs(SideQuests.OfChapter(ch)) do
    if q.giver == inst and not s.Done[q.id] then
      local chara = CH(inst)
      if chara == nil then return false end
      local ok = pcall(function()
        if s.Taken[q.id] then
          line(q.pending)
        else
          for _, t in ipairs(q.ask) do line(t) end
          UI:ChoiceMenuYesNo("Accepter cette requête ?", true)
          UI:WaitForChoice()
          if UI:ChoiceResult() then
            s.Taken[q.id] = true
            line(q.accept)
            UI:ResetSpeaker(false)
            UI:SetCenter(true)
            UI:WaitShowDialogue("Requête acceptée :[pause=10] « " .. q.titre .. " ».")
            if q.unlock_dungeon then
              if SV.ChapterProgression.UnlockedDungeons == nil then
                SV.ChapterProgression.UnlockedDungeons = {}
              end
              SV.ChapterProgression.UnlockedDungeons[q.unlock_dungeon] = true
              UI:WaitShowDialogue("Nouveau donjon débloqué :[pause=10] « " .. (q.dungeon_name or q.unlock_dungeon) .. " » !")
            end
            UI:SetCenter(false)
          else
            line(q.refuse)
          end
        end
      end)
      pcall(function() UI:ResetSpeaker() end)
      return ok
    end
  end
  return false
end

--------------------------------------------------------------------
-- INTERACTION AVEC LA CIBLE
--------------------------------------------------------------------
function SideQuests.TalkTarget(inst, ch)
  local s = SideQuests.Ensure()
  for _, q in ipairs(SideQuests.OfChapter(ch)) do
    if q.target == inst and s.Taken[q.id] and not s.Done[q.id] and not s.Step[q.id] then
      local chara = CH(inst)
      if chara == nil then return false end
      local ok = pcall(function()
        for _, t in ipairs(q.solve) do line(t) end
        s.Step[q.id] = 1
        UI:ResetSpeaker(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue("Il reste à en rendre compte.")
        UI:SetCenter(false)
      end)
      pcall(function() UI:ResetSpeaker() end)
      return ok
    end
  end
  return false
end

--------------------------------------------------------------------
-- RENDRE LA REQUETE
--------------------------------------------------------------------
function SideQuests.TurnIn(inst, ch)
  local s = SideQuests.Ensure()
  for _, q in ipairs(SideQuests.OfChapter(ch)) do
    if q.giver == inst and s.Step[q.id] and not s.Done[q.id] then
      local chara = CH(inst)
      if chara == nil then return false end
      local ok = pcall(function()
        for _, t in ipairs(q.done) do line(t) end
        s.Done[q.id] = true
        UI:ResetSpeaker(false)
        UI:SetCenter(true)
        UI:WaitShowDialogue("Requête accomplie :[pause=10] « " .. q.titre .. " ».")
        local r = SideQuests.Remaining(ch)
        if r > 0 then
          UI:WaitShowDialogue("Il reste " .. r .. " requête(s) en attente à Metano.")
        else
          UI:WaitShowDialogue("Plus aucune requête en attente.[pause=20] La ville peut souffler.")
        end
        UI:SetCenter(false)
      end)
      pcall(function() UI:ResetSpeaker() end)
      return ok
    end
  end
  return false
end

--------------------------------------------------------------------
-- POINT D'ENTREE UNIQUE POUR LES GROUNDS
--------------------------------------------------------------------
-- Un seul appel a placer en tete du handler d'un PNJ :
--   if SideQuests.Interact('Furret') then return end
-- Il gere l'ordre : rendre > resoudre > proposer.
function SideQuests.Interact(inst, ch)
  ch = ch or (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 0
  if SideQuests.TurnIn(inst, ch) then return true end
  if SideQuests.TalkTarget(inst, ch) then return true end
  if SideQuests.TalkGiver(inst, ch) then return true end
  return false
end

--------------------------------------------------------------------
-- LE TABLEAU DES REQUETES
--------------------------------------------------------------------
-- Le joueur doit TOUJOURS pouvoir savoir ce qui lui manque. Sans cela,
-- une progression bloquee devient une enigme frustrante.
function SideQuests.Board(ch)
  ch = ch or (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 0
  local s = SideQuests.Ensure()
  local list = SideQuests.OfChapter(ch)
  pcall(function()
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    if #list == 0 then
      UI:WaitShowDialogue("Le tableau est vide.[pause=20] Rien à signaler aujourd'hui.")
    else
      UI:WaitShowDialogue("TABLEAU DES REQUÊTES")
      for _, q in ipairs(list) do
        local etat = "à prendre"
        if s.Done[q.id] then etat = "accomplie"
        elseif s.Step[q.id] then etat = "à rendre"
        elseif s.Taken[q.id] then etat = "en cours" end
        UI:WaitShowDialogue("« " .. q.titre .. " » —[pause=10] " .. etat .. ".")
      end
      local r = SideQuests.Remaining(ch)
      if r > 0 then
        UI:WaitShowDialogue("La guilde n'enverra pas de nouvelle expédition[pause=10] tant que Metano a besoin de nous.")
      end
    end
    UI:SetCenter(false)
  end)
  pcall(function() UI:ResetSpeaker() end)
end

return SideQuests
