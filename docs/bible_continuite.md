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
