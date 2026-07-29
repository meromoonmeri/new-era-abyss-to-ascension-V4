--[[
    metano_town_ch_7_enrichment.lua

    DIALOGUES NPC ENRICHIS — Chapitre 7 : Les Ruines Tordues
    ================================================================
    Chaque PNJ de Metano Town a des dialogues qui evoluent selon
    l'avancement du chapitre 7 :

    Phase A : AVANT l'adresse du matin (RuinsAddressGiven = false)
    Phase B : APRES l'adresse, AVANT d'entrer dans les ruines
    Phase C : APRES la victoire sur Regigigas (DefeatedRuinsBoss)

    Chaque phase a au minimum 3 repliques par PNJ significatif.
    Les PNJ reagissent aux evenements — pas de texte statique.

    DUREE CIBLE : ~500 dialogues additionnels pour atteindre 4000+.
]]

require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.TownVoices'

metano_town_ch_7_enrich = {}

--------------------------------------------------------------------
-- HELPER : dialogue selon la phase du chapitre
--------------------------------------------------------------------
local function phaseDialogue(npc_name, phaseA, phaseB, phaseC)
  if SV.Chapter7.DefeatedRuinsBoss and phaseC then
    return phaseC
  elseif SV.Chapter7.RuinsAddressGiven and phaseB then
    return phaseB
  else
    return phaseA
  end
end

--------------------------------------------------------------------
-- KECELEON VERT — marchand d'objets
--------------------------------------------------------------------
function metano_town_ch_7_enrich.KecleonGreen_Action(chara, activator)
  local lines = phaseDialogue('KecleonGreen',
    -- Phase A : avant la mission
    {
      "Bienvenue ! J'ai reçu des Baies Oran fraîches ce matin.",
      "Les donjons au nord sont plus difficiles en ce moment.[pause=15] Prenez des provisions.",
      "Ah, et si vous voyez mon cousin violet, dites-lui qu'il me doit trois baies.",
    },
    -- Phase B : après l'adresse, avant les ruines
    {
      "Vous partez aux Ruines Tordues ?[pause=20] Prenez ça — des Baies Sitrus, au cas où.",
      "Les anciens disaient que les ruines étaient maudites.[pause=25] Moi je dis : une malédiction, ça s'achète avec de bonnes provisions.",
      "Faites attention aux pièges.[pause=20] Les ruines anciennes en sont remplies.",
    },
    -- Phase C : après Regigigas
    {
      "Vous avez VU Regigigas ?![pause=20] En vrai ?![pause=15] Vivant ?!",
      "Je...[pause=15] je vais devoir revoir ma politique de prix pour les clients qui ont combattu un colosse millénaire.",
      "Les veines bleues, vous dites ?[pause=20] Le Cœur va bien, alors ?[pause=25] Tant mieux.[pause=15] Tant mieux pour tout le monde.",
    }
  )
  local idx = (SV.ChapterProgression.DaysPassed or 0) % #lines + 1
  GeneralFunctions.StartConversation(chara, lines[idx], "Normal")
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- KECELEON VIOLET — marchand de CT
--------------------------------------------------------------------
function metano_town_ch_7_enrich.KecleonPurple_Action(chara, activator)
  local lines = phaseDialogue('KecleonPurple',
    {
      "Des CT ? J'en ai quelques-unes en stock.[pause=20] Rien d'extraordinaire, mais ça dépanne.",
      "Mon cousin vert est plus populaire que moi.[pause=25] C'est la vie.",
    },
    {
      "Vous partez en mission dangereuse ?[pause=20] Voici une CT Abri.[pause=15] Considérez ça comme un investissement dans votre retour.",
      "Les Ruines Tordues...[pause=20] Mon grand-père disait que les murs y sont vivants.",
    },
    {
      "Regigigas.[pause=25] Le mot seul fait trembler les CT sur mes étagères.",
      "Vous savez ce que ça veut dire ?[pause=20] Que les CT que je vends sont maintenant des reliques pré-colosse.[pause=25] Le prix va monter.",
    }
  )
  local idx = (SV.ChapterProgression.DaysPassed or 0) % #lines + 1
  GeneralFunctions.StartConversation(chara, lines[idx], "Normal")
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- AUDINO (Kangaskhan) — stockage
--------------------------------------------------------------------
function metano_town_ch_7_enrich.Kangaskhan_Action(chara, activator)
  local lines = phaseDialogue('Kangaskhan',
    {
      "Besoin de stocker quelque chose ?[pause=15] Mon sac est grand comme ma patience.",
      "Les explorateurs partent, les explorateurs reviennent.[pause=20] Et moi, je garde leurs affaires entre les deux.",
    },
    {
      "Les Ruines Tordues ?[pause=20] J'ai déjà stocké des équipements pour des expéditions là-bas.[pause=25] Aucune n'est revenue complète.",
      "Prenez ce qu'il vous faut.[pause=15] Et revenez entiers.",
    },
    {
      "Vous avez réussi.[pause=20] Je le vois à votre façon de marcher — plus droits qu'avant.",
      "Stockez ce que vous voulez.[pause=20] Vous l'avez mérité.",
    }
  )
  local idx = (SV.ChapterProgression.DaysPassed or 0) % #lines + 1
  GeneralFunctions.StartConversation(chara, lines[idx], "Normal")
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- BANK — Murkrow
--------------------------------------------------------------------
function metano_town_ch_7_enrich.Murkrow_Action(chara, activator)
  local lines = phaseDialogue('Murkrow',
    {
      "Votre solde est satisfaisant.[pause=20] Pour un débutant.",
      "La banque ne ferme jamais.[pause=15] Même la nuit.[pause=20] Surtout la nuit.",
    },
    {
      "Les Ruines Tordues...[pause=20] J'ai des clients qui y ont perdu plus que de l'argent.",
      "Assurez-vous de déposer vos objets de valeur avant de partir.[pause=25] Les ruines ne rendent rien.",
    },
    {
      "Regigigas, hein ?[pause=25] Intéressant.[pause=20] Un colosse millénaire ne paie pas de cotisation bancaire, mais sa légende, si.",
      "Votre solde a augmenté.[pause=15] La guilde récompense bien ses héros.",
    }
  )
  local idx = (SV.ChapterProgression.DaysPassed or 0) % #lines + 1
  GeneralFunctions.StartConversation(chara, lines[idx], "Normal")
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- SNEASEL — evaluation
--------------------------------------------------------------------
function metano_town_ch_7_enrich.Sneasel_Action(chara, activator)
  local lines = phaseDialogue('Sneasel',
    {
      "Des objets à évaluer ?[pause=15] Montrez-moi ça.",
      "La plupart des objets qu'on m'apporte ne valent rien.[pause=25] Mais de temps en temps...[pause=15] de temps en temps.",
    },
    {
      "Vous allez aux ruines ?[pause=20] Ramenez-moi quelque chose d'ancien.[pause=25] J'adore évaluer les reliques.",
      "Attention aux faux.[pause=20] Les ruines en sont pleines.[pause=15] Des pièges déguisés en trésors.",
    },
    {
      "Si vous avez trouvé des éclats de cristal dans les ruines...[pause=25] je peux les évaluer.[pause=15] Ce serait les objets les plus anciens que j'aie jamais touchés.",
      "Un fragment de Cœur d'Anima ?[pause=25] Je...[pause=20] non.[pause=15] Ça, ça ne s'évalue pas.[pause=25] Ça se respecte.",
    }
  )
  local idx = (SV.ChapterProgression.DaysPassed or 0) % #lines + 1
  GeneralFunctions.StartConversation(chara, lines[idx], "Normal")
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- SLOWPOKE — tuteur de capacites
--------------------------------------------------------------------
function metano_town_ch_7_enrich.Slowpoke_Action(chara, activator)
  local lines = phaseDialogue('Slowpoke',
    {
      "Hmm...[pause=30] une capacité...[pause=20] hmm...[pause=30] oui...[pause=20] laquelle ?",
      "Je suis lent...[pause=25] mais mes leçons sont bonnes.[pause=20] Il faut juste...[pause=30] être patient.",
    },
    {
      "Les Ruines...[pause=30] hmm...[pause=25] j'ai appris une capacité là-bas...[pause=30] il y a longtemps...",
      "Revenez...[pause=30] après votre mission...[pause=25] j'aurai peut-être...[pause=30] quelque chose de nouveau.",
    },
    {
      "Vous...[pause=25] avez vu le Cœur ?[pause=30] Hmm...[pause=20] je sens...[pause=30] qu'il bat mieux maintenant.",
      "Le Cœur...[pause=25] et mon esprit...[pause=30] sont liés...[pause=20] d'une façon...[pause=30] que je ne comprends pas.",
    }
  )
  local idx = (SV.ChapterProgression.DaysPassed or 0) % #lines + 1
  GeneralFunctions.StartConversation(chara, lines[idx], "Normal")
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- AMBIPOM — boutique d'echange
--------------------------------------------------------------------
function metano_town_ch_7_enrich.Ambipom_Action(chara, activator)
  local lines = phaseDialogue('Ambipom',
    {
      "Un échange ?[pause=15] J'adore les échanges ![pause=20] Deux queues, deux fois plus de plaisir !",
      "Échanger, c'est comme danser : il faut que les deux partenaires soient contents.",
    },
    {
      "Vous partez loin ?[pause=20] Échangez vos objets inutiles contre quelque chose de pratique !",
      "Les ruines, c'est sombre.[pause=20] Échangez une CT inutile contre une Lampe de Poche !",
    },
    {
      "Vous revenez des ruines ! Formidable ![pause=25] Rapportez des objets à échanger ?",
      "Vous savez quoi ?[pause=20] Depuis que le Cœur va mieux, les objets que j'échange brillent un peu plus.[pause=25] C'est dans ma tête, probablement.",
    }
  )
  local idx = (SV.ChapterProgression.DaysPassed or 0) % #lines + 1
  GeneralFunctions.StartConversation(chara, lines[idx], "Happy")
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- CHATOT (Falou) — musicien de la place
--------------------------------------------------------------------
function metano_town_ch_7_enrich.Musician_Action(chara, activator)
  local lines = phaseDialogue('Musician',
    {
      "♪ La-la-la...[pause=15] Pardon, je compose.[pause=20] Une nouvelle mélodie pour Metano.",
      "La musique adoucit les mœurs...[pause=20] et les donjons.[pause=15] Enfin, je crois.",
    },
    {
      "Je compose un hymne pour votre expédition ![pause=25] Il s'appellera « La Marche des Ruines ».[pause=20] Ou « Ruinons les Ruines ».[pause=15] Je n'ai pas encore décidé.",
      "Revenez en un morceau — j'aurai besoin d'un public pour la première.",
    },
    {
      "J'ai terminé l'hymne ![pause=25] « La Ballade du Colosse Endormi ».[pause=20] Trois couplets, un refrain, et un pont qui fait pleurer.",
      "Vous voulez l'entendre ?[pause=20] Non, non, pas maintenant.[pause=25] Il faut le bon moment.[pause=15] La musique, c'est comme les Cœurs — ça se joue au bon rythme.",
    }
  )
  local idx = (SV.ChapterProgression.DaysPassed or 0) % #lines + 1
  GeneralFunctions.StartConversation(chara, lines[idx], "Happy")
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- TEAM STYLE — rivaux comiques
--------------------------------------------------------------------
function metano_town_ch_7_enrich.TeamStyle_Leader_Action(chara, activator)
  local lines = phaseDialogue('TeamStyle',
    {
      "Team Style est la meilleure équipe de Metano ![pause=20] Acceptez-le, c'est plus simple.",
      "Notre prochain objectif ?[pause=20] Un donjon que VOUS n'oseriez jamais affronter.[pause=25] Probablement.",
    },
    {
      "Les Ruines Tordues ?[pause=20] Pff, Team Style y est déjà allée !",
      "...Bon, on est allés jusqu'à l'entrée.[pause=25] Et on est repartis.[pause=20] Stratégiquement !",
      "Si vous y allez, faites-nous un rapport.[pause=25] Pour... la science.",
    },
    {
      "Vous avez COMBATTU REGIGIGAS ?!",
      "...Team Style va s'entraîner.[pause=25] Beaucoup.[pause=20] Énormément.",
      "OK, peut-être que vous êtes...[pause=20] un tout petit peu...[pause=25] meilleurs que nous.[pause=15] POUR L'INSTANT !",
    }
  )
  local idx = (SV.ChapterProgression.DaysPassed or 0) % #lines + 1
  GeneralFunctions.StartConversation(chara, lines[idx], "Normal")
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- GROWLITHE (Hyko) — membre guilde
--------------------------------------------------------------------
function metano_town_ch_7_enrich.Growlithe_Action(chara, activator)
  local lines = phaseDialogue('Growlithe',
    {
      "Salut ! L'entraînement se passe bien.[pause=20] Penticus nous pousse à fond.",
      "Tu as entendu parler des Ruines Tordues ?[pause=25] Phileas dit que c'est dangereux.",
    },
    {
      "Tu vas aux ruines ?[pause=20] Je... j'aimerais venir, mais Penticus veut que je reste ici.",
      "Fais attention.[pause=20] Les murs des ruines sont piégés — j'ai lu les rapports.",
      "Reviens en un morceau, d'accord ?[pause=25] On a encore besoin de toi à la guilde.",
    },
    {
      "Tu as purifié un Cœur d'Anima.[pause=25] Tu te rends compte de ce que ça veut dire ?",
      "Ça veut dire que c'est possible.[pause=20] Que les Cœurs PEUVENT être sauvés.",
      "Toute la guilde en parle.[pause=25] Penticus est fier — il ne le dit pas, mais je le vois.",
    }
  )
  local idx = (SV.ChapterProgression.DaysPassed or 0) % #lines + 1
  GeneralFunctions.StartConversation(chara, lines[idx], "Normal")
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- ZIGZAGOON (Almotz) — membre guilde
--------------------------------------------------------------------
function metano_town_ch_7_enrich.Zigzagoon_Action(chara, activator)
  local lines = phaseDialogue('Zigzagoon',
    {
      "Je m'entraîne à courir en zigzag ![pause=20] C'est ma spécialité !",
      "Un jour, je serai aussi fort que toi.[pause=25] Un jour.",
    },
    {
      "Les Ruines Tordues ?![pause=20] J'ai peur pour toi...[pause=25] mais je sais que tu vas y arriver !",
      "J'ai préparé un porte-bonheur.[pause=20] C'est un caillou que j'ai trouvé.[pause=25] Il est rond.[pause=15] Les cailloux ronds, ça porte chance.",
      "...Tu le veux ?[pause=20] Vraiment ?[pause=25] Bon, garde-le bien alors !",
    },
    {
      "REGIGIGAS ?![pause=20] Le vrai ?![pause=15] Le géant ?![pause=20] Celui qui a des bras ENORMES ?",
      "Tu...[pause=15] tu l'as battu ?[pause=25] TOI ?![pause=20] Mon ami a battu REGIGIGAS !",
      "Je vais le raconter à tout le monde ![pause=20] À TOUT LE MONDE !",
    }
  )
  local idx = (SV.ChapterProgression.DaysPassed or 0) % #lines + 1
  GeneralFunctions.StartConversation(chara, lines[idx], "Happy")
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- GRODOUDOU (Wigglytuff) — Zones Legendaire
--------------------------------------------------------------------
function metano_town_ch_7_enrich.Wigglytuff_Action(chara, activator)
  local lines = phaseDialogue('Wigglytuff',
    {
      "Gro-dou-dou ![pause=15] Les Zones Légendaires attendent les plus braves !",
      "Tu n'es pas encore prêt pour mes zones spéciales.[pause=25] Mais bientôt !",
    },
    {
      "Hmm...[pause=20] Les Cœurs d'Anima...[pause=25] J'en ai entendu parler dans mes voyages.",
      "Il y a des zones où les légendaires se cachent.[pause=25] Peut-être que certaines sont liées aux Cœurs ?",
      "Reviens me voir quand tu en sauras plus !",
    },
    {
      "Tu as sauvé un Cœur ! Gro-dou-dou !",
      "Tu sais ce que ça veut dire ?[pause=25] Que les légendaires que je connais...[pause=20] sont peut-être les GARDIENS de ces Cœurs.",
      "Je vais réfléchir à tout ça.[pause=20] Reviens me voir — j'aurai peut-être des zones spéciales pour toi.",
    }
  )
  local idx = (SV.ChapterProgression.DaysPassed or 0) % #lines + 1
  GeneralFunctions.StartConversation(chara, lines[idx], "Happy")
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- MAREEP — habitante
--------------------------------------------------------------------
function metano_town_ch_7_enrich.Mareep_Action(chara, activator)
  local lines = phaseDialogue('Mareep',
    {
      "Ma laine est toute électrifiée aujourd'hui.[pause=20] C'est le temps, je crois.",
      "Vous allez dans un donjon ?[pause=20] Ne touchez pas ma laine en partant — ça pique.",
    },
    {
      "Les ruines...[pause=20] Ma grand-mère disait que les murs y chantent la nuit.",
      "Elle disait aussi qu'elle inventait la moitié de ses histoires.[pause=25] Mais pas celle-là.",
    },
    {
      "Depuis que vous êtes revenus, ma laine est plus douce.[pause=25] C'est bizarre, non ?",
      "Comme si l'air de Metano avait changé.[pause=20] Plus léger.[pause=15] Plus propre.",
    }
  )
  local idx = (SV.ChapterProgression.DaysPassed or 0) % #lines + 1
  GeneralFunctions.StartConversation(chara, lines[idx], "Normal")
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- CRANIDOS — habitant
--------------------------------------------------------------------
function metano_town_ch_7_enrich.Cranidos_Action(chara, activator)
  local lines = phaseDialogue('Cranidos',
    {
      "Mon crâne est dur comme de la pierre ![pause=20] C'est pratique pour les donjons.",
      "Un jour, je serai explorateur.[pause=20] Un VRAI explorateur.",
    },
    {
      "Les Ruines Tordues ?[pause=20] Les murs sont en pierre ancienne.[pause=25] Mon crâne les reconnaîtrait.",
      "Si tu trouves des fossiles, ramène-les moi !",
    },
    {
      "Tu as combattu Regigigas...[pause=25] un Pokémon de PIERRE et de FORCE.",
      "Mon crâne est jaloux.[pause=20] Mais mon cœur est fier.",
    }
  )
  local idx = (SV.ChapterProgression.DaysPassed or 0) % #lines + 1
  GeneralFunctions.StartConversation(chara, lines[idx], "Normal")
  GeneralFunctions.EndConversation(chara)
end

return metano_town_ch_7_enrich
