# PROMPT ULTIME — Conception de donjons : segments, biomes et relais uniques

Ce document consolide et prolonge `conception_donjons_segmentes.md` : il reste la référence de base pour la logique de progression de biome, mais ce prompt élève l'exigence sur un point précis — **chaque point médian et chaque relais, dans chaque zone, doit être propre et unique à son biome**, jamais un gabarit générique dupliqué d'un donjon à l'autre.

## 1. Principe fondateur — rappel

Un donjon à plusieurs segments exprime visuellement une progression réelle (altitude, distance, dangerosité). Chaque segment a un biome qui lui est propre, dégradé progressivement du précédent au suivant (cf. exemple Mont Windsep : verdoyant → falaise → sommet). Ce principe reste la base de toute conception de donjon à partir de maintenant.

## 2. Points médians et relais — exigence d'unicité totale

C'est le cœur de ce prompt : **aucun relais ne doit ressembler à un autre relais du jeu**, même entre deux donjons partageant un biome proche. Un point médian n'est pas une pièce fonctionnelle interchangeable posée au milieu d'un donjon — c'est un lieu qui appartient à ce donjon précis, à ce moment précis de la traversée, et à nul autre.

**Ce qui rend un relais unique :**
- Sa position exacte dans la progression de biome du segment (un relais entre "verdoyant" et "falaise" n'a pas la même composition qu'un relais entre "falaise" et "sommet" — chacun capture un instant différent de la transition).
- Les éléments de décor spécifiques au lieu : formation rocheuse particulière, arbre remarquable, ruine, source d'eau, vestige narratif lié à l'histoire du donjon — au moins un élément distinctif propre à ce relais et absent de tous les autres.
- La disposition du camp (emplacement du feu, des zones de repos, du point de service) adaptée à la topographie réelle du lieu plutôt qu'un plan fixe recopié.
- Si le donjon a une identité narrative propre (lié à un chapitre, à un personnage, à un événement), le relais peut porter une trace de cette identité (un détail visuel qui rappelle l'histoire du lieu).

**Ce qui est interdit :**
- Réutiliser telle quelle la disposition d'un relais déjà construit ailleurs, même en changeant seulement le tileset.
- Un relais "neutre" qui pourrait être déplacé dans n'importe quel autre donjon du jeu sans que rien ne paraisse incohérent.
- Un point médian dont le seul rôle est fonctionnel (restauration) sans aucune identité visuelle propre.

## 3. Fonctions de gameplay systématiques des relais

Indépendamment de leur unicité visuelle, tous les relais du jeu partagent les mêmes fonctions systématiques, à implémenter de façon cohérente sur l'ensemble des donjons à segments :
- Restauration des PP et de l'estomac (faim) du joueur et de son équipe.
- Possibilité de croiser des Pokémon sauvages inoffensifs aux abords du relais, avec une faune cohérente avec le biome traversé à cet endroit précis.

L'unicité porte sur l'apparence et l'intégration narrative du lieu, jamais sur ses fonctions de gameplay, qui doivent rester prévisibles et fiables pour le joueur.

## 4. Construction technique

- Utiliser l'outil de génération de map/tileset (`outil_generateur_map_tileset.md`) comme point de départ pour la cohérence de tileset avec le biome exact de la position du relais dans la progression du segment.
- Finaliser chaque relais manuellement pour y intégrer l'élément distinctif qui le rend unique — l'outil fournit une base cohérente, il ne remplace pas le travail de composition qui donne au lieu son identité propre.
- Piocher exclusivement dans les sources d'assets déjà validées du projet (DumpAsset, PMDODump, RawAsset) pour tout élément de décor ajouté.
- Pour les entrances de donjon construites comme des avenues en segments de camp (`outil_generateur_entrance_donjon.md`), la même exigence d'unicité s'applique : chaque entrance doit se distinguer des autres par sa combinaison de biomes et son traitement propre, jamais un gabarit recopié.

## 5. Génération procédurale et relais

La génération procédurale des étages (RogueElements) porte sur la structure des étages entre les relais, jamais sur les relais eux-mêmes. Un relais n'est jamais généré aléatoirement : c'est un point fixe, construit à la main, qui ancre la progression du joueur dans un lieu reconnaissable au milieu d'étages qui, eux, peuvent varier à chaque traversée.

## 6. Cohérence avec les cinématiques et les boss

- Si une cinématique se déclenche à un relais, son décor doit correspondre exactement à l'identité visuelle propre de ce relais — jamais un fond générique qui ignore les détails distinctifs du lieu.
- Le dernier relais avant l'arène de boss (cf. `arenes_boss_arc_tournoi.md`) doit particulièrement porter la tension de l'approche finale : c'est souvent le relais qui doit le plus clairement annoncer, par son décor, la nature du combat à venir.

## 7. Registre de suivi anti-duplication

Tenir une trace de l'ensemble des relais déjà conçus dans le projet (donjon, position dans la progression, éléments distinctifs utilisés), pour permettre de vérifier rapidement qu'un nouveau relais ne recycle pas une combinaison déjà existante. Ce suivi peut s'appuyer sur le même principe que le contrôleur de continuité déjà prévu dans la suite d'outils internes du projet, étendu à la cohérence visuelle des lieux plutôt qu'à la seule cohérence narrative.

## 8. Auto-questionnement avant de valider un relais

- Ce relais a-t-il au moins un élément distinctif absent de tous les autres relais du jeu ?
- Sa position dans la progression de biome du segment est-elle visuellement lisible (on comprend qu'on est entre tel biome et tel autre) ?
- La disposition du camp est-elle adaptée à la topographie réelle du lieu, ou est-ce un plan générique recopié ?
- Les fonctions de gameplay (PP, estomac, rencontres inoffensives) sont-elles bien présentes et fonctionnelles ?
- Une cinématique déclenchée à ce relais correspondrait-elle exactement à son décor propre ?
- Ce relais a-t-il été comparé au registre des relais déjà existants pour écarter tout risque de duplication ?

Si l'une de ces questions révèle une incohérence ou une ressemblance non justifiée avec un relais déjà existant, le relais n'est pas terminé.
