--[[
    LegendZones.lua
    Zones de recrutement des Pokemon fabuleux et legendaires.

    ------------------------------------------------------------------
    REGLE NARRATIVE (lecture 1, retenue et confirmee)
    ------------------------------------------------------------------
    La regle du projet reste intacte : un legendaire n'apparait JAMAIS en
    rencontre aleatoire. Acheter une zone chez Grodoudou ne fait pas
    apparaitre le legendaire dans la nature et ne le donne pas non plus.

    Elle ouvre une seule chose : le droit de RETOURNER l'affronter, dans
    son propre lieu, une fois que l'histoire l'a deja presente.
    Trois verrous en serie, dans cet ordre :

       1. verrou d'histoire  -> le legendaire doit avoir ete rencontre
                                dans le scenario (champ `flag`).
                                C'est ce qui met la zone EN VENTE.
       2. verrou marchand    -> la zone doit avoir ete achetee
       3. verrou de combat   -> il faut aller le vaincre sur place

    Tant que le verrou 1 n'est pas leve, la zone n'est meme pas proposee :
    Grodoudou n'a "pas encore entendu parler" du lieu. C'est la regle
    demandee : chaque fois qu'on rencontre un legendaire dans l'histoire,
    sa zone devient achetable.

    ------------------------------------------------------------------
    STRUCTURE D'UNE ENTREE
    ------------------------------------------------------------------
      key      identifiant interne, cle dans SV.LegendZones.*
      species  espece PMDO. Les 25 especes listees ici ont ete verifiees
               presentes dans Data/Misc/MonsterFeature.json (1011 entrees).
      name     cle .resx du nom de la zone (EN + FR)
      blurb    cle .resx du boniment de Grodoudou pour cette zone
      sight    cle .resx de la description du lieu (ce qu'on y voit)
      price    prix en Poke (monnaie standard : GAME:GetPlayerMoney)
      flag     fonction -> true si l'histoire a deja presente ce
               legendaire. C'est le verrou 1.
      zone     identifiant de donjon a rejoindre
      segment  segment de ce donjon contenant l'arene de revanche
      roam     true  = le legendaire se deplace dans sa zone une fois
                       vaincu et recrute (comportement errant)
               false = il attend sur place
      ready    true  = la chaine complete existe et est jouable
               false = le chapitre correspondant n'est pas encore ecrit ;
                       l'entree est un contrat pour plus tard et n'est
                       JAMAIS listee en boutique.

    Ne jamais passer `ready = true` sans avoir verifie les trois points :
      (a) le segment existe dans Data/Zone/<zone>.json
      (b) la .rsmap de l'arene existe et son occupant n'est PAS Unrecruitable
      (c) ExitSegment de zone/<zone>/init.lua gere ce numero de segment
]]--

require 'origin.common'

LegendZones = {}

LegendZones.LIST = {
    ------------------------------------------------------------------
    -- JOUABLE AUJOURD'HUI
    ------------------------------------------------------------------
    {
        key = 'verdant_oath', species = 'zarude',
        name = 'LZ_Name_Verdant_Oath', blurb = 'LZ_Blurb_Verdant_Oath',
        sight = 'LZ_Sight_Verdant_Oath', price = 15000,
        -- Pose par zone/gloomy_forest/init.lua (segment 4, victoire).
        -- Segment 5 : decale de 3 -> 5 par l'insertion du mini-boss ch6.
        flag = function() return SV.Chapter6 ~= nil and SV.Chapter6.DefeatedGloomyBoss == true end,
        zone = 'gloomy_forest', segment = 5, roam = true, ready = true
    },

    ------------------------------------------------------------------
    -- CONTRATS EN ATTENTE — chapitres a venir.
    -- Nom, prix et identite visuelle deja arretes : l'ecriture du
    -- chapitre n'aura plus qu'a poser le flag, le segment et ready.
    ------------------------------------------------------------------
    {
        key = 'colossus_quarry', species = 'regigigas',
        name = 'LZ_Name_Colossus_Quarry', blurb = 'LZ_Blurb_Colossus_Quarry',
        sight = 'LZ_Sight_Colossus_Quarry', price = 22000,
        -- Segment 5 : decale de 3 -> 5 par l'insertion du mini-boss ch5.
        flag = function() return SV.Chapter5 ~= nil and SV.Chapter5.SawAnimaCoreCorruption == true end,
        zone = 'cloven_ruins', segment = 5, roam = false, ready = true
    },
    {
        key = 'spatial_hill', species = 'palkia',
        name = 'LZ_Name_Spatial_Hill', blurb = 'LZ_Blurb_Spatial_Hill',
        sight = 'LZ_Sight_Spatial_Hill', price = 38000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 28 end,
        zone = 'grotte_gravee', segment = 1, cine = 'chambre_agee_o', roam = true, ready = true
    },
    {
        key = 'hour_that_lags', species = 'dialga',
        name = 'LZ_Name_Hour_That_Lags', blurb = 'LZ_Blurb_Hour_That_Lags',
        sight = 'LZ_Sight_Hour_That_Lags', price = 38000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 28 end,
        zone = 'tour_reliques', segment = 3, cine = 'fleche_reliques_courroux', roam = false, ready = true
    },
    {
        key = 'reverse_slope', species = 'giratina',
        name = 'LZ_Name_Reverse_Slope', blurb = 'LZ_Blurb_Reverse_Slope',
        sight = 'LZ_Sight_Reverse_Slope', price = 42000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 29 end,
        zone = 'labyrinthe_perdus', segment = 1, cine = 'grotte_cryptique', roam = true, ready = true
    },
    {
        key = 'dead_hours', species = 'celebi',
        name = 'LZ_Name_Dead_Hours', blurb = 'LZ_Blurb_Dead_Hours',
        sight = 'LZ_Sight_Dead_Hours', price = 25000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 20 end,
        zone = 'purity_forest', segment = 1, cine = 'purity_forest_verger', roam = true, ready = true
    },
    {
        key = 'clearwater_ford', species = 'suicune',
        name = 'LZ_Name_Clearwater_Ford', blurb = 'LZ_Blurb_Clearwater_Ford',
        sight = 'LZ_Sight_Clearwater_Ford', price = 26000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 25 end,
        zone = 'northwind_field', segment = 1, cine = 'bois_des_plaintes', roam = true, ready = true
    },
    {
        key = 'ember_vigil', species = 'entei',
        name = 'LZ_Name_Ember_Vigil', blurb = 'LZ_Blurb_Ember_Vigil',
        sight = 'LZ_Sight_Ember_Vigil', price = 26000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 22 end,
        zone = 'fiery_field', segment = 1, cine = 'plaines_brulees', roam = false, ready = true
    },
    {
        key = 'storm_bell', species = 'raikou',
        name = 'LZ_Name_Storm_Bell', blurb = 'LZ_Blurb_Storm_Bell',
        sight = 'LZ_Sight_Storm_Bell', price = 26000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 16 end,
        zone = 'lightning_field', segment = 1, cine = 'arene_hautes_plaines', roam = true, ready = true
    },
    {
        key = 'soft_sleep', species = 'cresselia',
        name = 'LZ_Name_Soft_Sleep', blurb = 'LZ_Blurb_Soft_Sleep',
        sight = 'LZ_Sight_Soft_Sleep', price = 28000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 23 end,
        zone = 'cour_clair_lune', segment = 5, cine = 'mont_lune_vue', roam = true, ready = true
    },
    {
        key = 'upturned_dream', species = 'darkrai',
        name = 'LZ_Name_Upturned_Dream', blurb = 'LZ_Blurb_Upturned_Dream',
        sight = 'LZ_Sight_Upturned_Dream', price = 30000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 23 end,
        zone = 'cour_clair_lune', segment = 5, roam = true, ready = true
    },
    {
        key = 'unsaid_wishes', species = 'jirachi',
        name = 'LZ_Name_Unsaid_Wishes', blurb = 'LZ_Blurb_Unsaid_Wishes',
        sight = 'LZ_Sight_Unsaid_Wishes', price = 32000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 31 end,
        zone = 'wish_cave', segment = 1, cine = 'sanctuaire_voeu', roam = false, ready = true
    },
    {
        key = 'first_cradle', species = 'mew',
        name = 'LZ_Name_First_Cradle', blurb = 'LZ_Blurb_First_Cradle',
        sight = 'LZ_Sight_First_Cradle', price = 50000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 26 end,
        zone = 'bois_enchevetres', segment = 5, cine = 'arene_clairiere_secrete', roam = true, ready = true
    },
    {
        key = 'thawed_step', species = 'articuno',
        name = 'LZ_Name_Thawed_Step', blurb = 'LZ_Blurb_Thawed_Step',
        sight = 'LZ_Sight_Thawed_Step', price = 24000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 17 end,
        zone = 'frosty_forest', segment = 3, cine = 'champ_vent_boreal', roam = false, ready = true
    },
    {
        key = 'high_conductor', species = 'zapdos',
        name = 'LZ_Name_High_Conductor', blurb = 'LZ_Blurb_High_Conductor',
        sight = 'LZ_Sight_High_Conductor', price = 24000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 17 end,
        zone = 'mt_thunder', segment = 3, cine = 'porte_plaines_foudre', roam = false, ready = true
    },
    {
        key = 'long_ash', species = 'moltres',
        name = 'LZ_Name_Long_Ash', blurb = 'LZ_Blurb_Long_Ash',
        sight = 'LZ_Sight_Long_Ash', price = 24000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 14 end,
        zone = 'mt_blaze', segment = 3, cine = 'champ_braises', roam = false, ready = true
    },
    {
        key = 'quiet_ledger', species = 'uxie',
        name = 'LZ_Name_Quiet_Ledger', blurb = 'LZ_Blurb_Quiet_Ledger',
        sight = 'LZ_Sight_Quiet_Ledger', price = 27000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 13 end,
        zone = 'sentier_savoir', segment = 1, cine = 'lac_savoir', roam = false, ready = true
    },
    {
        key = 'kept_feeling', species = 'mesprit',
        name = 'LZ_Name_Kept_Feeling', blurb = 'LZ_Blurb_Kept_Feeling',
        sight = 'LZ_Sight_Kept_Feeling', price = 27000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 13 end,
        zone = 'sentier_espoir', segment = 1, cine = 'lac_espoir', roam = true, ready = true
    },
    {
        key = 'last_resolve', species = 'azelf',
        name = 'LZ_Name_Last_Resolve', blurb = 'LZ_Blurb_Last_Resolve',
        sight = 'LZ_Sight_Last_Resolve', price = 27000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 13 end,
        zone = 'sentier_courage', segment = 1, cine = 'lac_courage', roam = false, ready = true
    },
    {
        key = 'sunken_choir', species = 'lugia',
        name = 'LZ_Name_Sunken_Choir', blurb = 'LZ_Blurb_Sunken_Choir',
        sight = 'LZ_Sight_Sunken_Choir', price = 36000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 19 end,
        zone = 'silver_trench', segment = 1, cine = 'fosse_argentee', roam = false, ready = true
    },
    {
        key = 'rainbow_ash', species = 'ho_oh',
        name = 'LZ_Name_Rainbow_Ash', blurb = 'LZ_Blurb_Rainbow_Ash',
        sight = 'LZ_Sight_Rainbow_Ash', price = 36000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 18 end,
        zone = 'mt_faraway', segment = 1, cine = 'sommet_aurore', roam = false, ready = true
    },
    {
        key = 'ninth_summit', species = 'rayquaza',
        name = 'LZ_Name_Ninth_Summit', blurb = 'LZ_Blurb_Ninth_Summit',
        sight = 'LZ_Sight_Ninth_Summit', price = 45000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 27 end,
        zone = 'sky_tower', segment = 5, cine = 'vigie_stratos', roam = false, ready = true
    },
    {
        key = 'borrowed_light', species = 'necrozma',
        name = 'LZ_Name_Borrowed_Light', blurb = 'LZ_Blurb_Borrowed_Light',
        sight = 'LZ_Sight_Borrowed_Light', price = 48000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 32 end,
        zone = 'sentier_eteint', segment = 4, cine = 'ile_close', roam = false, ready = true
    },
    {
        key = 'given_life', species = 'xerneas',
        name = 'LZ_Name_Given_Life', blurb = 'LZ_Blurb_Given_Life',
        sight = 'LZ_Sight_Given_Life', price = 44000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 30 end,
        zone = 'iles_prismatiques', segment = 1, cine = 'nef_prisme_est', roam = false, ready = true
    },
    ------------------------------------------------------------------
    -- VAGUE 3 (2026-07-27) — L'Eveil des Ancrages : nouvelles especes.
    ------------------------------------------------------------------
    {
        key = 'molten_throne', species = 'groudon',
        name = 'LZ_Name_Molten_Throne', blurb = 'LZ_Blurb_Molten_Throne',
        sight = 'LZ_Sight_Molten_Throne', price = 25200,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 11 end,
        zone = 'magma_cavern', segment = 1, cine = 'arene_trone_magma', roam = false, ready = true
    },
    {
        key = 'tide_hollow', species = 'kyogre',
        name = 'LZ_Name_Tide_Hollow', blurb = 'LZ_Blurb_Tide_Hollow',
        sight = 'LZ_Sight_Tide_Hollow', price = 26400,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 12 end,
        zone = 'stormy_sea', segment = 32, cine = 'abime_tempetes', roam = false, ready = true
    },
    {
        key = 'western_silence', species = 'mewtwo',
        name = 'LZ_Name_Western_Silence', blurb = 'LZ_Blurb_Western_Silence',
        sight = 'LZ_Sight_Western_Silence', price = 37200,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 21 end,
        zone = 'western_cave', segment = 1, cine = 'antre_occident', roam = false, ready = true
    },
    {
        key = 'victory_spark', species = 'victini',
        name = 'LZ_Name_Victory_Spark', blurb = 'LZ_Blurb_Victory_Spark',
        sight = 'LZ_Sight_Victory_Spark', price = 38400,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 22 end,
        zone = 'fiery_field', segment = 1, roam = true, ready = true
    },
    {
        key = 'twin_rift', species = 'latios',
        name = 'LZ_Name_Twin_Rift', blurb = 'LZ_Blurb_Twin_Rift',
        sight = 'LZ_Sight_Twin_Rift', price = 40800,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 24 end,
        zone = 'ile_eon', segment = 1, cine = 'cretes_boreales', roam = true, ready = true
    },
    {
        key = 'twin_rift_latias', species = 'latias',
        name = 'LZ_Name_Twin_Rift_Latias', blurb = 'LZ_Blurb_Twin_Rift_Latias',
        sight = 'LZ_Sight_Twin_Rift_Latias', price = 40800,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 24 end,
        zone = 'ile_eon', segment = 1, roam = true, ready = true
    },
    {
        key = 'first_cradle_hoopa', species = 'hoopa',
        name = 'LZ_Name_First_Cradle_Hoopa', blurb = 'LZ_Blurb_First_Cradle_Hoopa',
        sight = 'LZ_Sight_First_Cradle_Hoopa', price = 43200,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 26 end,
        zone = 'bois_enchevetres', segment = 5, roam = true, ready = true
    },
    {
        key = 'final_rest', species = 'yveltal',
        name = 'LZ_Name_Final_Rest', blurb = 'LZ_Blurb_Final_Rest',
        sight = 'LZ_Sight_Final_Rest', price = 46800,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 29 end,
        zone = 'vallon_malsain', segment = 3, cine = 'vallon_malsain_fond', roam = false, ready = true
    },
    {
        key = 'cells_gathering', species = 'zygarde',
        name = 'LZ_Name_Cells_Gathering', blurb = 'LZ_Blurb_Cells_Gathering',
        sight = 'LZ_Sight_Cells_Gathering', price = 48000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 30 end,
        zone = 'ciel_suspendu', segment = 1, cine = 'terres_tues_porte', roam = false, ready = true
    },
    {
        key = 'two_lights', species = 'solgaleo',
        name = 'LZ_Name_Two_Lights', blurb = 'LZ_Blurb_Two_Lights',
        sight = 'LZ_Sight_Two_Lights', price = 49200,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 31 end,
        zone = 'conte_sans_fin', segment = 1, cine = 'ile_legendaire', roam = false, ready = true
    },
    {
        key = 'two_lights_lunala', species = 'lunala',
        name = 'LZ_Name_Two_Lights_Lunala', blurb = 'LZ_Blurb_Two_Lights_Lunala',
        sight = 'LZ_Sight_Two_Lights_Lunala', price = 49200,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 31 end,
        zone = 'chapelle_nuit', segment = 5, cine = 'ile_australe', roam = false, ready = true
    },
    {
        key = 'eternal_coil', species = 'eternatus',
        name = 'LZ_Name_Eternal_Coil', blurb = 'LZ_Blurb_Eternal_Coil',
        sight = 'LZ_Sight_Eternal_Coil', price = 60000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.StoryCompleted == true end,
        zone = 'nervure_monde', segment = 1, cine = 'couloir_legendes', roam = false, ready = true
    },
    ------------------------------------------------------------------
    -- VAGUE 3c (2026-07-27) — Fabuleux + duos separes.
    ------------------------------------------------------------------
    {
        key = 'only_shadow', species = 'marshadow',
        name = 'LZ_Name_Only_Shadow', blurb = 'LZ_Blurb_Only_Shadow',
        sight = 'LZ_Sight_Only_Shadow', price = 43200,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 26 end,
        zone = 'creux_ombres', segment = 1, cine = 'creux_ombres_scelle', roam = true, ready = true
    },
    {
        key = 'fallen_visitor', species = 'deoxys',
        name = 'LZ_Name_Fallen_Visitor', blurb = 'LZ_Blurb_Fallen_Visitor',
        sight = 'LZ_Sight_Fallen_Visitor', price = 37200,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 21 end,
        zone = 'meteor_cave', segment = 1, cine = 'vallon_perdu', roam = false, ready = true
    },
    {
        key = 'thanks_bloom', species = 'shaymin',
        name = 'LZ_Name_Thanks_Bloom', blurb = 'LZ_Blurb_Thanks_Bloom',
        sight = 'LZ_Sight_Thanks_Bloom', price = 30000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 15 end,
        zone = 'jardin_gratitude', segment = 1, cine = 'champ_sacre', roam = true, ready = true
    },
    {
        key = 'sea_cradle', species = 'manaphy',
        name = 'LZ_Name_Sea_Cradle', blurb = 'LZ_Blurb_Sea_Cradle',
        sight = 'LZ_Sight_Sea_Cradle', price = 31200,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 16 end,
        zone = 'berceau_mers', segment = 1, cine = 'recif_genereux', roam = false, ready = true
    },
    {
        key = 'resolute_ford', species = 'keldeo',
        name = 'LZ_Name_Resolute_Ford', blurb = 'LZ_Blurb_Resolute_Ford',
        sight = 'LZ_Sight_Resolute_Ford', price = 33600,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 18 end,
        zone = 'gue_poulain', segment = 1, cine = 'gue_poulain_autel', roam = false, ready = true
    },
    {
        key = 'last_encore', species = 'meloetta',
        name = 'LZ_Name_Last_Encore', blurb = 'LZ_Blurb_Last_Encore',
        sight = 'LZ_Sight_Last_Encore', price = 36000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 20 end,
        zone = 'amphitheatre_oublie', segment = 1, cine = 'grotte_echos', roam = true, ready = true
    },
    {
        key = 'old_reactor', species = 'genesect',
        name = 'LZ_Name_Old_Reactor', blurb = 'LZ_Blurb_Old_Reactor',
        sight = 'LZ_Sight_Old_Reactor', price = 38400,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 22 end,
        zone = 'reacteur_enfoui', segment = 1, cine = 'labo_decrepit', roam = false, ready = true
    },
    {
        key = 'steam_heart', species = 'volcanion',
        name = 'LZ_Name_Steam_Heart', blurb = 'LZ_Blurb_Steam_Heart',
        sight = 'LZ_Sight_Steam_Heart', price = 39600,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 23 end,
        zone = 'forge_vapeur', segment = 1, cine = 'fosse_volcanique', roam = false, ready = true
    },
    {
        key = 'gear_heart', species = 'magearna',
        name = 'LZ_Name_Gear_Heart', blurb = 'LZ_Blurb_Gear_Heart',
        sight = 'LZ_Sight_Gear_Heart', price = 40800,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 24 end,
        zone = 'atelier_coeur_mecanique', segment = 3, cine = 'carriere_magnetique', roam = false, ready = true
    },
    {
        key = 'wild_current', species = 'zeraora',
        name = 'LZ_Name_Wild_Current', blurb = 'LZ_Blurb_Wild_Current',
        sight = 'LZ_Sight_Wild_Current', price = 42000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 25 end,
        zone = 'piste_fulgurante', segment = 3, cine = 'pre_tonnerre', roam = true, ready = true
    },
    {
        key = 'liquid_metal', species = 'melmetal',
        name = 'LZ_Name_Liquid_Metal', blurb = 'LZ_Blurb_Liquid_Metal',
        sight = 'LZ_Sight_Liquid_Metal', price = 44400,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter ~= nil and SV.ChapterProgression.Chapter >= 27 end,
        zone = 'fonderie_hex', segment = 3, cine = 'grotte_rocheuse', roam = false, ready = true
    },
    {
        key = 'first_breath', species = 'arceus',
        name = 'LZ_Name_First_Breath', blurb = 'LZ_Blurb_First_Breath',
        sight = 'LZ_Sight_First_Breath', price = 66000,
        flag = function() return SV.ChapterProgression ~= nil and SV.ChapterProgression.StoryCompleted == true end,
        zone = 'tour_origine', segment = 1, cine = 'escalier_origine', roam = false, ready = true
    }
}

--------------------------------------------------------------------
-- Etat de sauvegarde
--------------------------------------------------------------------
-- SV.LegendZones est declare dans scriptvars.lua. Ce garde-fou couvre les
-- sauvegardes creees AVANT l'ajout du systeme : sans lui, toute partie
-- existante planterait a la premiere interaction avec le stand.
function LegendZones.EnsureSV()
    if SV.LegendZones == nil then
        SV.LegendZones = { Purchased = {}, Defeated = {}, MetMerchant = false }
    end
    if SV.LegendZones.Purchased == nil then SV.LegendZones.Purchased = {} end
    if SV.LegendZones.Defeated  == nil then SV.LegendZones.Defeated  = {} end
end

function LegendZones.IsPurchased(key)
    LegendZones.EnsureSV()
    return SV.LegendZones.Purchased[key] == true
end

function LegendZones.SetPurchased(key)
    LegendZones.EnsureSV()
    SV.LegendZones.Purchased[key] = true
end

--Le legendaire a-t-il ete vaincu dans sa zone ?
function LegendZones.IsDefeated(key)
    LegendZones.EnsureSV()
    return SV.LegendZones.Defeated[key] == true
end

function LegendZones.SetDefeated(key)
    LegendZones.EnsureSV()
    SV.LegendZones.Defeated[key] = true
end

function LegendZones.Get(key)
    for _, entry in ipairs(LegendZones.LIST) do
        if entry.key == key then return entry end
    end
    return nil
end

--Verrou 1 : l'histoire a-t-elle deja presente ce legendaire ?
--pcall protege des flags dont la table SV n'existe pas encore.
function LegendZones.StoryUnlocked(entry)
    if entry.ready ~= true then return false end
    local ok, result = pcall(entry.flag)
    return ok and result == true
end

--Zones que Grodoudou peut proposer aujourd'hui.
function LegendZones.GetAvailable()
    local out = {}
    for _, entry in ipairs(LegendZones.LIST) do
        if LegendZones.StoryUnlocked(entry) and not LegendZones.IsPurchased(entry.key) then
            table.insert(out, entry)
        end
    end
    return out
end

--Zones deja achetees : Grodoudou peut y conduire l'equipe.
function LegendZones.GetOwned()
    local out = {}
    for _, entry in ipairs(LegendZones.LIST) do
        if LegendZones.IsPurchased(entry.key) and entry.ready then
            table.insert(out, entry)
        end
    end
    return out
end

function LegendZones.ZoneName(entry)
    return STRINGS:Format(STRINGS.MapStrings[entry.name])
end

--Nom colore de l'espece, tel que le jeu l'affiche partout ailleurs.
function LegendZones.SpeciesName(entry)
    return _DATA:GetMonster(entry.species):GetColoredName()
end

return LegendZones
