# Bible de continuité — New Era : Abyss to Ascension

> Document exigé par le Prompt Maître (§6). À consulter et mettre à jour avant chaque chapitre écrit.
> Dernière mise à jour : 2026-07-26.

## 1. État de l'histoire (chapitres implémentés : 1-10)

| Ch. | Titre FR | Événement majeur | Portée / propagation |
|---|---|---|---|
| 1 | Un Autre Commencement | Le héros devient Pokémon, rencontre le partenaire, Forêt Relique | locale (Metano) |
| 2 | La Première Mission | Rivière Illuminée, entraînement, ouverture du marché | locale |
| 3 | Rivaux | Team Style, hors-la-loi de la Caverne Tortueuse, rang Bronze | locale → régionale (rumeurs de la capture) |
| 4 | Une Vraie Aventure | Bosquet Apricorn, assemblée déverrouillée | locale |
| 5 | L'Expédition | Grande expédition guilde : Steppe → Tunnel → Mont. Phénomène lumineux au sommet | régionale — TOUTE la ville en parle au retour |
| 6 | La Forêt Lugubre | Team Dazzling, corruption des Anima découverte, Zarude vaincu | régionale |
| 7 | (Ruines Tordues) | Regigigas, premier Cœur d'Anima vu corrompu, récit de la Genèse | régionale, la guilde sait |
| 8 | (Sanctuaire de Cristal) | Diancie, Fragment de Cristal obtenu | guilde + proches |
| 9 | (Marais de l'Oubli) | Laggron, Cercle du Suaire aperçu, Cœur purifié | guilde ; rumeurs déformées en ville |
| 10 | (Pic Céleste) | Course contre l'Escouade Fulgur, Lugia, vision de Necrozma | fin d'arc — `SV.ChapterProgression.StoryCompleted` |

Interdits de nommage en cours d'histoire : Necrozma et Eternatus ne sont **jamais nommés** avant leurs révélations ; l'Abîme reste une inquiétude descriptive (règle héritée du rapport ch5).

## 2. PNJ récurrents — statut actuel

| PNJ | Espèce | Rôle | Statut | Localisation habituelle |
|---|---|---|---|---|
| Héros / Partenaire | starters | équipe du joueur | actifs | guilde (chambre) |
| Maître de Guilde (Penticus) | — | chef de guilde | actif | bureau, 3e étage |
| Tropius / Noctowl | — | encadrement guilde | actifs | hall 3e étage |
| Hyko | — | membre guilde (lien Penticus, cf. todo.txt) | actif | guilde |
| Growlithe / Zigzaton (Almotz) | — | recrues guilde | actifs | guilde ; famille Zigzaton en ville |
| Team Style | — | rivaux comiques | actifs, récurrents | place de Metano |
| Team Dazzling (Adagio/Aria/Sonata) | Tsareena/Lopunny/Mismagius | rivales ch6 | actives post-ch6 | place de Metano (ch6+) |
| Bria | Mawile | PNJ ville | active | ville (ch6+) |
| Phileas | — | sait des choses sur la Genèse | actif — à développer ch7+ | ? (à fixer) |
| Kecleon vert/violet | — | boutiques | actifs | marché |
| Auntie Kanga | Kangaskhan | stockage | active | marché |
| Murkrow | — | banque | actif | marché |
| Sneasel | — | évaluation | active | marché |
| Chatot | — | musicien | actif | place |
| **Ambipom** | — | **Boutique d'Échange** | **OUVERTE depuis le retour d'expédition (ch6)** — dernier commerce prévu par Palika, activé 2026-07-26 | marché |
| Slowpoke | — | tuteur de capacités (+ egg moves ch6+) | actif | marché |
| Stunky / Farfetch'd | — | marchands rouge/vert | actifs (cachés pendant l'expédition ch5) | marché |
| Grodoudou | Wigglytuff | Zones Légendaires (revanches) | actif | ville |
| Plum | Jigglypuff | PNJ (candidate Rondoudou chanteur, cinématique comique) | existe dans CharacterEssentials | à placer |
| Melumi | — | PNJ ZMDO (hub non importé) | **non intégrée** — candidate PNJ secondaire future | — |
| Saphir | — | Échoppe des Méga-Pierres | **prévue, non implémentée** — post-game uniquement (`StoryCompleted`) | future boutique |

## 3. Boutiques — état d'ouverture par chapitre

| Boutique | Ouverture | Note |
|---|---|---|
| Kecleon (objets/TM) | ch2 (MarketIntro) | stock quotidien (DailyFlags) |
| Stockage / Banque / Évaluation | ch2-3 | — |
| Marchands rouge/vert | ch3 (MerchantIntro) | cachés pendant l'expédition ch5 |
| Tuteur Slowpoke | ch3 ; egg moves ch6+ | — |
| **Échange Ambipom** | **ch6 (retour d'expédition)** | dernier shop indisponible → **activé** (Unhide ch6/8/9/10 ; ch7 n'a jamais caché) |
| Échoppe de Saphir (Méga-Pierres) | post-game (`StoryCompleted`) | à implémenter (plan §6 du doc d'assignation) |

## 4. Donjons ouverts et couverture missions (Addendum C.1)

- **Job board** : tous les donjons débloqués ET terminés apparaissent (filtre moteur `GetDungeonUnlock == Completed`). Liste complète dans `mission_gen.lua` : 7 historiques + 7 secondaires vague 1 + **ch7-10 ajoutés** (missions « de rappel » S/STAR_1). Aucun donjon débloqué n'est orphelin de missions.
- Donjons secondaires vague 1 : Petit Tunnel, Bosquet Voilé (ch1) ; Grotte du Mystère, Vallée Fertile (ch2) ; Antre de l'Énigme, Carrière de Cuivre (ch3) ; Grotte de l'Échoué (ch4).
- Donjons secondaires **inventés** de l'addendum C.2 (Antre de l'Écho Perdu, Sanctuaire de la Marée Montante, Verger des Songes Amers, Faille du Minerai Chantant, Nid-Sépulcre des Rafales) : **non implémentés** — nécessitent des mécaniques de mapgen dédiées ; enregistrés comme réserve au plan d'assignation.

## 5. Quêtes annexes ouvertes

| Quête | État | Échéance |
|---|---|---|
| Revanche Zarude (verdant_oath) | ouverte post-ch6 | permanente |
| Relation Hyko/Penticus (todo.txt) | à esquisser dès la scène du matin | ch5+ |
| Phileas et la Genèse | ouverte ch7 | ch7-10 |
| Dispute Floatzel (FloatzelDisputeResolved) | déclarée ch9, non scriptée | ch9 |
| Apology option Rin (todo.txt) | non implémentée | libre |

## 6. Écarts connus entre le Prompt Maître et l'implémentation

1. **7000 lignes/chapitre (ch5+)** : objectif de production long terme. L'implémentation actuelle est loin du compte — ce quota exige des sessions d'écriture dédiées chapitre par chapitre, à raison d'une livraison par chapitre au format §8 du Prompt Maître.
2. **PNJ à emploi du temps horaire** : le moteur du dépôt gère jour/segments d'histoire (SetupGround par chapitre, DailyFlags) mais pas de tranches horaires intra-journée. Les routines existantes (AI ground_default/ground_talking, npc_routines.lua) permettent déjà le déplacement spatial ; la granularité matin/soir demandera un système d'heure in-game — chantier moteur à part.
3. **~20 cinématiques marquantes** : comptage actuel ≈ 15 majeures (intro, EnterGuild, MarketIntro, TeamStyle, MerchantIntro, départ/camps/retour expédition ×4, Dazzling ×3, boss ch6-10). Reste à créer notamment les respirations comiques (ex. scène Rondoudou/Plum — candidate désignée) et contemplatives.
4. Ratio 60/25/15 (drame/comique/contemplatif) : actuellement déséquilibré vers le dramatique. À corriger via les scènes de vie ch6+.

## 7. Protocole pour chaque futur chapitre écrit

1. Relire cette bible + `docs/integration_tracker.md` + `docs/narrative_audit_log.md`.
2. Résumé d'ouverture (état monde/PNJ/intrigues) en tête de livraison.
3. Écriture (quotas §3.1 du Prompt Maître, répartition 25/35/20/10/10).
4. Checklist qualité §7 du Prompt Maître.
5. Mise à jour de cette bible en fin de chapitre + audit narratif §10 de la directive multi-sources.

## Addendum session dialogue ch5 (2026-07-26)

Nouveaux personnages/scènes établis (à respecter dans toute écriture future) :
- **Plum** (Rondoudou/Jigglypuff) : artiste lyrique itinérante de la steppe. Trac du public endormi (« Un jour, quelqu'un écoutera ma chanson jusqu'au bout »). Sa berceuse = celle de sa mère. Réutilisable en ville ou ch6+.
- **Le Météno du Mont Venteux** : Fragment tombé du ciel, cherche son « banc » dispersé. A vu la lumière du sommet « avoir peur ». Reste dans la région du Mont. Accroche ouverte : ses amis dispersés.
- **Voix des PNJ d'expédition** (verrouillées) : Penticus = façade sereine fissurée ; Phileas = érudit, hypothèses qui ne lui plaisent pas, « Hou » ; Rin = prescriptrice douce ; Coco = râle par principe, loyale ; Shuca = optimiste statique (électrocute Ganlon « une fois et demie ») ; Ganlon = bourru protecteur (surveille « le périmètre ») ; Kino = blagueur, pacte de dignité avec Coco ; Reinier = vétéran, « arrière-tête » infaillible ; Hyko = procédure + cœur (rapport en 3 exemplaires) ; Almotz = famille de 8, gratin de Baies Oran, cailloux souvenirs.
- **Tweed & Maris** (maison de l'eau) : 47 plans foireux au compteur ; « eau millésimée » puis « eau d'altitude ». Maris : « Booon... ».
- **Événements consignés** : la « voix » de la steppe entendue par TOUTE l'équipe (verbalisée à la veillée) ; Hyko consigne les murmures pour Penticus ; Almotz a dit merci (rapport officiel de Hyko, 22h).

## Système de légendes des aînés (session 4 — 2026-07-26)

Règle : les légendaires sont MENTIONNÉS par les anciens (« On raconte... »), jamais rencontrés.
Chaque légende a son OST, son conteur attitré et prépare un contenu futur planifié. Choix du joueur (ChoiceMenuYesNo) avant chaque récit — jamais imposé.

| Légende | Conteur | Lieu | OST | Légendaires cités | Prépare |
|---|---|---|---|---|---|
| Les Trois Serviteurs et le Colosse | Rubble (Aggron, ex-mineur) | café | In the Depths of the Pit | Regirock, Regice, Registeel + « le Colosse » (Regigigas non nommé) | ch7 Ruines Tordues |
| Les Trois Lacs | le vieux Relicanth | étang d'Altere | Star Cave | Créhelf, Créfollet, Créfadet | Sentiers Savoir/Espoir/Courage (P5) |
| Les Deux Gardiens du Ciel | Nidoqueen (aubergiste, histoire de sa mère) | auberge | I Saw Something Again... | Ho-Oh, Lugia (« il ne remonte que si le ciel est en danger ») | ch10 Pic Céleste |
| Le Fourneau et les Cœurs | Phileas (Noctowl) — GRANDE VEILLÉE mise en scène | camp du Tunnel | I Saw Something Again... → Rising Fear | Heatran + les « Cœurs » (Anima sans le mot) | tout l'arc Anima |
| Celui qui Dort sous les Volcans | Dotra (Camerupt, transmission mère→enfant) | maison feu | In the Depths of the Pit | Groudon | donjons volcaniques futurs |

Déblocages : Titans/Lacs/Ciel/Terre = post-expédition ; Fourneau = après rencontre du clan Slugma (répond à la question « pourquoi défendent-ils le tunnel ? »).

## Cinématique majeure « La Nuit où le Ciel a Tremblé » (enjeu de l'expédition)

- Déclencheur : première visite à l'entrée steppe après victoire sur le mini-boss.
- Ce qui est établi CANON : le phénomène du sommet émet des PULSES visibles à des jours de marche ; l'onde se SENT physiquement (« un battement de cœur immense, irrégulier » — le héros) ; les Pokémon sauvages se taisent avant chaque pulse ; Penticus fait le discours fondateur (« pour que chaque famille se couche sans regarder le nord avec angoisse ») ; les archives de Phileas parlent de « nuits où la montagne s'allume » (compte-rendu, pas poésie).
- OST : silence → Growing Anxiety → Rising Fear → Sympathy. VFX : Flash + Cosmic_Power overlay + ShakeScreen.
- Toute écriture future ch5+ doit référencer ce pulse comme événement partagé par toute l'expédition ET visible depuis Metano (rumeurs ch6 à prévoir).
