#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os, sys

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SQ_PATH = os.path.join(MOD_ROOT, "Data/Script/halcyon/SideQuests.lua")
SJ_PATH = os.path.join(MOD_ROOT, "Data/Script/halcyon/SecondaryJobs.lua")

CH14_SQ_LUA = """  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24 LIGNES AVEC PARTENAIRE/HÉROS) : Col de l'Aurore ===
  {
    id = 'q14_aurore', ch = 14, giver = 'Vulpix', target = 'Vulpix',
    unlock_dungeon = 'aurora_pass', dungeon_name = "Col de l'Aurore",
    titre = "L'aurore boréale",
    ask = {
      {'Vulpix', 'Sad',     'Snif... Snif... Les aurores polaires ne s allument plus sur notre sommet.'},
      {'Teammate1', 'Surprised','Goupix ? Pourquoi votre ciel du col est-il plongé dans l obscurité ?'},
      {'Vulpix', 'Worried', 'Feunard d Alola l Aurore a glacé le grand miroir boréal du Col de l Aurore.'},
      {'Vulpix', 'Normal',  'Ce col est le point d observation où notre clan chante la lumière polaire.'},
      {'Vulpix', 'Angry',   'Ses blizzards magiques masquent toutes les lumières célestes de la montagne !'},
      {'Vulpix', 'Sad',     'Nos petits Goupix grelottent dans ce noir glacé.'},
      {'Teammate1', 'Worried', 'Les lumières masquées par le blizzard ? Nous devons agir !'},
      {'PLAYER',    'Determined','(Je regarde vers l aurore : allons ramener la clarté polaire.)'},
      {'Vulpix', 'Worried', 'Si Feunard d Alola ne calme pas son souffle, l aurore s éteindra.'},
      {'Vulpix', 'Sad',     'Avez-vous le courage d affronter les neiges du sommet ?'},
      {'Teammate1', 'Determined','Compte sur nous ! Nous allons monter au col et libérer l aurore !'},
      {'Vulpix', 'Inspired','Vrai ? Merci de tout cœur ! Que la lumière polaire vous protège !'}
    },
    accept = {{'Vulpix', 'Happy',   'Youpi ! Votre chaleur brille déjà comme une aurore !'},
      {'Teammate1', 'Happy', 'Abriter les petits, le ciel boréal va bientôt rebriller !'},
      {'Vulpix', 'Normal',  'Le col s ouvre juste au nord des grandes glaces éternelles.'}},
    refuse = {{'Vulpix', 'Sad',     'Snif... Je comprends, le souffle polaire est mordant.'},
      {'Teammate1', 'Sad',   'Nous reviendrons quand nous serons prêts contre le blizzard.'}},
    pending= {{'Vulpix', 'Worried', 'Le Col de l Aurore a-t-il retrouvé ses couleurs boréales ?'},
      {'Teammate1', 'Determined','Nous grimpons vers l autel de Feunard d Alola !'}},
    solve  = {{'Vulpix', 'Worried', 'Le Col de l Aurore a-t-il retrouvé ses couleurs boréales ?'},
      {'Teammate1', 'Determined','Nous grimpons vers l autel de Feunard d Alola !'}},
    done   = {
      {'Vulpix', 'Inspired','YOUPI ! LES AURORES BRILLENT ! Le ciel est éclatant de couleurs !'},
      {'Teammate1', 'Happy', 'Feunard d Alola a accepté de laisser le miroir céleste en paix !'},
      {'PLAYER',    'Happy', '(Des voiles multicolores éclairent doucement la neige du col.)'},
      {'Vulpix', 'Happy',   'Nos petits jouent sous les lumières polaires grâce à vous !'},
      {'Vulpix', 'Surprised','Vous avez convaincu le gardien suprême des aurores boréales ?'},
      {'Teammate1', 'Inspired','La flamme de notre amitié brille dans toutes les nuits polaires !'},
      {'Vulpix', 'Happy',   'Notre clan de Goupix channtera éternellement votre exploit !'},
      {'Vulpix', 'Inspired','Prenez cette perle d aurore en gage de gratitude !'},
      {'Vulpix', 'Normal',  'Bonne suite dans votre voyage vers les sommets !'}
    },
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  },
  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24 LIGNES AVEC PARTENAIRE/HÉROS) : Crevasse Cristalline ===
  {
    id = 'q14_cristal', ch = 14, giver = 'Snorunt', target = 'Snorunt',
    unlock_dungeon = 'crystal_crevasse', dungeon_name = "Crevasse Cristalline",
    titre = "Le miroir de glace",
    ask = {
      {'Snorunt', 'Sad',     'Brrr... Brrr... Les cristaux de notre crevasse se sont obscurcis.'},
      {'Teammate1', 'Surprised','Stalgamin ? Pourquoi votre abri de cristal semble-t-il si sombre ?'},
      {'Snorunt', 'Worried', 'Kaimorse le Glacier a bloqué la grande faille de la Crevasse Cristalline.'},
      {'Snorunt', 'Normal',  'Cette crevasse est notre sanctuaire où brillent les stalactites.'},
      {'Snorunt', 'Angry',   'Sa masse énorme empêche les rayons d aurore de descendre jusqu au fond !'},
      {'Snorunt', 'Sad',     'Notre clan ne peut plus s orienter sans la réflexion des glaces.'},
      {'Teammate1', 'Worried', 'Le sanctuaire dans le noir ? C est un péril pour votre tribu !'},
      {'PLAYER',    'Determined','(Je sers les poings : allons dégager la faille de cristal.)'},
      {'Snorunt', 'Worried', 'Si Kaimorse ne quitte pas le seuil, les glaces perdront leur éclat.'},
      {'Snorunt', 'Sad',     'Avez-vous la force d affronter le grand glacier polaire ?'},
      {'Teammate1', 'Determined','Laisse-nous faire ! Nous allons descendre dans la crevasse et lui parler !'},
      {'Snorunt', 'Inspired','Vrai ? Merci de tout cœur, braves héros du nord !'}
    },
    accept = {{'Snorunt', 'Happy',   'Youpi ! Votre présence illumine déjà la glace !'},
      {'Teammate1', 'Happy', 'Gardez courage, la lumière va replonger dans la faille !'},
      {'Snorunt', 'Normal',  'La crevasse s ouvre sous le grand pic des vents polaires.'}},
    refuse = {{'Snorunt', 'Sad',     'Brrr... Je comprends, ce gouffre glacé est redoutable.'},
      {'Teammate1', 'Sad',   'Nous allons chercher des crampons de glace d abord.'}},
    pending= {{'Snorunt', 'Worried', 'La Crevasse Cristalline a-t-elle retrouvé sa lumière ?'},
      {'Teammate1', 'Determined','Nous approchons de l antre du grand Kaimorse !'}},
    solve  = {{'Snorunt', 'Worried', 'La Crevasse Cristalline a-t-elle retrouvé sa lumière ?'},
      {'Teammate1', 'Determined','Nous approchons de l antre du grand Kaimorse !'}},
    done   = {
      {'Snorunt', 'Inspired','YOUPI ! LES CRISTAUX SCINTILLENT ! La lumière redescend !'},
      {'Teammate1', 'Happy', 'Kaimorse a accepté de se déplacer dans les eaux plus profondes !'},
      {'PLAYER',    'Happy', '(Les stalactites reflètent les feux boréaux dans tout le gouffre.)'},
      {'Snorunt', 'Happy',   'Notre clan retrouve ses repères grâce à vous deux !'},
      {'Snorunt', 'Surprised','Vous avez tenu tête au monarque des mers glaciaires ?'},
      {'Teammate1', 'Inspired','Ensemble, aucun glacier ne peut barrer notre route !'},
      {'Snorunt', 'Happy',   'La tribu de Stalgamin vous devra toujours respect et honneur !'},
      {'Snorunt', 'Inspired','Prenez cet éclat de cristal éternel en gratitude !'},
      {'Snorunt', 'Normal',  'Que la glace vous soit toujours propice !'}
    },
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  },
  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24 LIGNES AVEC PARTENAIRE/HÉROS) : Sommet Grondant ===
  {
    id = 'q14_sommet', ch = 14, giver = 'Pidgeotto', target = 'Pidgeotto',
    unlock_dungeon = 'roaring_summit', dungeon_name = "Sommet Grondant",
    titre = "Le dragon de vent",
    ask = {
      {'Pidgeotto', 'Sad',     'Roucou... Les sommets grondent sous un ouragan continuel.'},
      {'Teammate1', 'Surprised','Roucoups ? Pourquoi les oiseaux s ennuient-ils au pied du grand sommet ?'},
      {'Pidgeotto', 'Worried', 'Dracolosse le Sommet a déclenché une tourmente sur le Sommet Grondant.'},
      {'Pidgeotto', 'Normal',  'Ce pic est le point culminant de la traversée nordique des rapaces.'},
      {'Pidgeotto', 'Angry',   'Ses coups d ailes créent des tourbillons qui clouent tout vol au sol !'},
      {'Pidgeotto', 'Sad',     'Nos éclaireurs ne peuvent plus surveiller l horizon boréal.'},
      {'Teammate1', 'Worried', 'Une tourmente au sommet ? Tout le nord risque la tempête !'},
      {'PLAYER',    'Determined','(Je regarde vers le pic : allons rencontrer ce dragon des vents.)'},
      {'Pidgeotto', 'Worried', 'Si Dracolosse ne se calme pas, la route des crêtes sera bloquée.'},
      {'Pidgeotto', 'Sad',     'Nous cherchons des héros capables d atteindre le toit du nord.'},
      {'Teammate1', 'Determined','Laisse-nous faire ! Nous allons gravir le sommet et calmer le vent !'},
      {'Pidgeotto', 'Inspired','Oh ! Merci ! Que les courants vous soutiennent !'}
    },
    accept = {{'Pidgeotto', 'Happy',   'Génial ! Votre détermination domine les nuages !'},
      {'Teammate1', 'Happy', 'Prévenez les éclaireurs, le sommet va retrouver son calme !'},
      {'Pidgeotto', 'Normal',  'Le sentier du sommet débute après les hauts cols rocheux.'}},
    refuse = {{'Pidgeotto', 'Sad',     'Je comprends... Ses ouragans sont redoutables.'},
      {'Teammate1', 'Sad',   'Nous allons d abord consolider notre prise de sol.'}},
    pending= {{'Pidgeotto', 'Worried', 'Les vents du Sommet Grondant se sont-ils apaisés ?'},
      {'Teammate1', 'Determined','Nous grimpons vers le nid de Dracolosse !'}},
    solve  = {{'Pidgeotto', 'Worried', 'Les vents du Sommet Grondant se sont-ils apaisés ?'},
      {'Teammate1', 'Determined','Nous grimpons vers le nid de Dracolosse !'}},
    done   = {
      {'Pidgeotto', 'Inspired','ROUCOU ! LE CIEL EST CALME ! L ouragan s est dissipé !'},
      {'Teammate1', 'Happy', 'Dracolosse a compris que sa force mettait tout le ciel en danger !'},
      {'PLAYER',    'Happy', '(Les nuées d oiseaux reprennent leur vol autour du pic céleste.)'},
      {'Pidgeotto', 'Happy',   'La surveillance de l horizon boréal est sauvée grâce à vous !'},
      {'Pidgeotto', 'Surprised','Vous avez vaincu le dragon légendaire du plus haut sommet ?'},
      {'Teammate1', 'Inspired','Notre amitié plane plus haut que tous les dragons !'},
      {'Pidgeotto', 'Happy',   'Les rapaces du nord chanteront vos exploits dans les cieux !'},
      {'Pidgeotto', 'Inspired','Voici une plume royale d exception de nos patrouilles !'},
      {'Pidgeotto', 'Normal',  'Bons vents pour vos expéditions au sommet du monde !'}
    },
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  },
  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24 LIGNES AVEC PARTENAIRE/HÉROS) : Toundra Oubliée ===
  {
    id = 'q14_toundra', ch = 14, giver = 'Swinub', target = 'Swinub',
    unlock_dungeon = 'forgotten_tundra', dungeon_name = "Toundra Oubliée",
    titre = "Le désert blanc",
    ask = {
      {'Swinub', 'Sad',     'Gruii... Gruii... La neige de la toundra s est gelée en glace compacte.'},
      {'Teammate1', 'Surprised','Marcacrin ? Pourquoi votre troupeau n arrive-t-il plus à creuser la neige ?'},
      {'Swinub', 'Worried', 'Blizzarroi le Géant a piétiné les sources souterraines de la Toundra Oubliée.'},
      {'Swinub', 'Normal',  'C est une plaine blanche où se cachent nos baies d hiver sous la poudreuse.'},
      {'Swinub', 'Angry',   'Ses pas géants tassent toute la neige et créent un permafrost impénétrable !'},
      {'Swinub', 'Sad',     'Notre troupeau ne trouve plus de baies et souffre de faim.'},
      {'Teammate1', 'Worried', 'Un troupeau sans baies ? Nous ne pouvons pas laisser faire !'},
      {'PLAYER',    'Determined','(Je hoche la tête : allons rendre la poudreuse au troupeau.)'},
      {'Swinub', 'Worried', 'Il faut persuader Blizzarroi de regagner les hauteurs lointaines.'},
      {'Swinub', 'Sad',     'Avez-vous le courage de traverser la grande toundra blanche ?'},
      {'Teammate1', 'Determined','Compte sur nous ! Nous allons libérer la toundra et sauver les baies !'},
      {'Swinub', 'Inspired','Vrai ? Merci ! Sauvez notre plaine de neige !'}
    },
    accept = {{'Swinub', 'Happy',   'Gruii ! Votre gentillesse réchauffe la plaine !'},
      {'Teammate1', 'Happy', 'Gardez courage, la neige sera bientôt à nouveau douce !'},
      {'Swinub', 'Normal',  'La toundra s étend au-delà des cols glacés nordiques.'}},
    refuse = {{'Swinub', 'Sad',     'Gruii... Je comprends, le permafrost est terrifiant.'},
      {'Teammate1', 'Sad',   'Nous reviendrons quand nous serons prêts contre la glace.'}},
    pending= {{'Swinub', 'Worried', 'La Toundra Oubliée a-t-elle retrouvé sa neige douce ?'},
      {'Teammate1', 'Determined','Nous marchons vers le repaire du géant Blizzarroi !'}},
    solve  = {{'Swinub', 'Worried', 'La Toundra Oubliée a-t-elle retrouvé sa neige douce ?'},
      {'Teammate1', 'Determined','Nous marchons vers le repaire du géant Blizzarroi !'}},
    done   = {
      {'Swinub', 'Inspired','GRUII ! LA NEIGE EST DOUCE ! Les baies sont accessibles !'},
      {'Teammate1', 'Happy', 'Blizzarroi a accepté de déplacer ses patrouilles dans les montagnes vides !'},
      {'PLAYER',    'Happy', '(Les Marcacrin creusent joyeusement la neige claire de la toundra.)'},
      {'Swinub', 'Happy',   'Notre troupeau est sauvé grâce à votre courage immense !'},
      {'Swinub', 'Surprised','Vous avez su apaiser la charge du géant de la toundra ?'},
      {'Teammate1', 'Inspired','Notre lien d amitié est plus solide que tous les géants !'},
      {'Swinub', 'Happy',   'Toute la tribu de Marcacrin se souviendra de vos exploits !'},
      {'Swinub', 'Inspired','Voici des baies polaires anciennes récoltées sous la neige !'},
      {'Swinub', 'Normal',  'Bon voyage dans vos aventures à travers le grand nord !'}
    },
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  },
"""

CH14_SJ_LUA = """  {
    chapter = 14, zone = 'aurora_pass', segment = 0, floor = 10,
    client = 'vulpix', client_gender = RogueEssence.Data.Gender.Female,
    target = 'vulpix', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'S', reward = 'money',
    title = "L'aurore boréale",
    flavor = "Un blizzard obscurcit le ciel du Col de l'Aurore et prive notre clan de lumière.\nSécurisez le sommet nordique.",
  },
  {
    chapter = 14, zone = 'crystal_crevasse', segment = 0, floor = 12,
    client = 'snorunt', client_gender = RogueEssence.Data.Gender.Male,
    target = 'snorunt', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'S', reward = 'money',
    title = "Le miroir glacé",
    flavor = "La Crevasse Cristalline est assombrie par un géant des mers glaciaires.\nAidez-nous à restaurer l'éclat des cristaux.",
  },
  {
    chapter = 14, zone = 'roaring_summit', segment = 0, floor = 11,
    client = 'pidgeotto', client_gender = RogueEssence.Data.Gender.Male,
    target = 'pidgeotto', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'S', reward = 'money',
    title = "Le dragon du sommet",
    flavor = "Des ouragans perpétuels empêchent la patrouille aérienne du Sommet Grondant.\nApaiser les vents au sommet.",
  },
  {
    chapter = 14, zone = 'forgotten_tundra', segment = 0, floor = 12,
    client = 'swinub', client_gender = RogueEssence.Data.Gender.Male,
    target = 'swinub', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'A', reward = 'money',
    title = "La plaine blanche",
    flavor = "Le permafrost de la Toundra Oubliée est piétiné par un monarque des neiges.\nProtégez nos champs de baies polaires.",
  },
"""

def inject_sq():
    with open(SQ_PATH, "r", encoding="utf-8") as f:
        content = f.read()
    if "id = 'q14_aurore'" in content:
        print("  [SideQuests] Ch14 déjà injecté dans SideQuests.lua.")
        return
    anchor = "    id = 'q13_marais', ch = 13, giver = 'Wooper_Girl',"
    if anchor not in content:
        print("  [Erreur] Ancre q13_marais introuvable dans SideQuests.lua.")
        return
    idx = content.find(anchor)
    end_entry = content.find("undertow = \"mission personnelle de déblocage donjon avec partenaire et héros\",\n  },", idx)
    if end_entry == -1:
        print("  [Erreur] Fin de q13_marais introuvable.")
        return
    insert_pos = end_entry + len("undertow = \"mission personnelle de déblocage donjon avec partenaire et héros\",\n  },")
    new_content = content[:insert_pos] + "\n" + CH14_SQ_LUA + content[insert_pos:]
    with open(SQ_PATH, "w", encoding="utf-8") as f:
        f.write(new_content)
    print("  [SideQuests] Quêtes q14_aurore, q14_cristal, q14_sommet, q14_toundra injectées !")

def inject_sj():
    with open(SJ_PATH, "r", encoding="utf-8") as f:
        content = f.read()
    if "zone = 'aurora_pass'" in content:
        print("  [SecondaryJobs] Ch14 déjà injecté dans SecondaryJobs.lua.")
        return
    anchor = "    title = \"Le silence du marais\","
    idx = content.find(anchor)
    if idx == -1:
        print("  [Erreur] Ancre silent_marsh introuvable dans SecondaryJobs.lua.")
        return
    end_entry = content.find("  },", idx) + len("  },")
    new_content = content[:end_entry] + "\n" + CH14_SJ_LUA + content[end_entry:]
    with open(SJ_PATH, "w", encoding="utf-8") as f:
        f.write(new_content)
    print("  [SecondaryJobs] Contrats de guilde Ch14 injectés !")

if __name__ == "__main__":
    print("=== INJECTION QUÊTES & CONTRATS CH14 ===")
    inject_sq()
    inject_sj()
