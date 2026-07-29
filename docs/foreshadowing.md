# Foreshadowing — Suivi des éléments plantés et payés

> Dernière mise à jour : 2026-07-29.
> Document lié à `directive_structure_donjons_chapitres.md` et
> `bible_continuite.md`.

---

## Éléments plantés → payés

| Planté (ch.) | Élément | Payé (ch.) | Statut |
|---|---|---|---|
| 1 | Transformation du héros en Pokémon | 32 (?) | En cours — cause liée à Necrozma/Eternatus |
| 1 | Test de personnalité + Gardevoir en rêve | 5, 18+ | Planté ch1, rappelé ch5 (rêve Mont Windsep), Team Charm ch18+ |
| 2 | Rivière Illuminée — première mission | 2 | Payé — introduction au monde |
| 3 | Team Style (rivaux) | 9, 30 | Planté ch3, tournoi ch9, coalition ch30 |
| 3 | Team Dazzling mentionnée | 6, 7+ | Planté ch3 (rumeurs), confrontation ch6, alliées ch7+ |
| 5 | Voix mystérieuse (speaker \uE040) | 7, 10, 32 | Planté ch5 (Steppe, Tunnel, Mont), identifiée partiellement ch7, twist ch32 |
| 5 | Phénomène lumineux au sommet du Mont | 8, 10, 32 | Planté ch5, Fragment ch8, vision Lugia ch10, Necrozma ch32 |
| 5 | Légende de Reinier (ciel, Rayquaza) | 27 | Planté ch5 (veillée), payé ch27 (Vigie Stratos) |
| 5 | Phileas « sait des choses » | 7, 8+ | Planté ch5 (veille, rassure le héros), développé ch7+ |
| 5 | Nausée du héros (contact avec la Voix) | 10, 32 | Planté ch5 (2 épisodes), escalade ch10, révélation ch32 |
| 5 | Légende du ciel (Arbiter) via Reinier | 27 | Planté ch5, écho ch27 |
| 6 | Corruption des Anima découverte | 7, 8, 9, 10 | Planté ch6 (Zarude), confirmée ch7-10 (Cœurs d'Anima) |
| 6 | « Ancienne partenaire Gardevoir » (Dazzling) | 18+ | Planté ch6, payé avec Team Charm ch18+ |
| 7 | Regigigas — premier Cœur d'Anima corrompu | 8, 9, 10 | Planté ch7, pattern confirmé ch8-10 |
| 7 | Récit de la Genèse | 32 | Planté ch7, révélation complète ch32 |
| 8 | Fragment de Cristal (Diancie) | 10, 32 | Planté ch8, utilisé ch10, clé ch32 |
| 8 | Météno tombé du ciel (relais Mont) | 10, 32 | Planté ch5 (midpoint), écho ch10, twist ch32 |
| 9 | Cercle du Suaire aperçu | 10, 20+ | Planté ch9, développé ch10, arc complet ch20+ |
| 10 | Vision de Necrozma | 32 | Planté ch10 (silhouette, jamais nommé), révélé ch32 |
| 10 | Escouade Fulgur (Luxray, Lucario, Heliolisk) | 18+ | Planté ch10, potentiel retour arc tournoi |

---

## Éléments payés dans ce chapitre mais plantés plus tôt

### Chapitre 5 (expédition)
- Paiement : introduction de la Voix, du phénomène lumineux, de la nausée
- Planté pour plus tard : légende de Reinier, Phileas, Fragment/Météno

### Chapitre 6 (Forêt Lugubre)
- Paiement : Team Dazzling (plantée ch3)
- Planté pour plus tard : corruption Anima, « ancienne partenaire »

### Chapitre 7 (Ruines Tordues)
- Paiement : corruption Anima (plantée ch6)
- Planté pour plus tard : Genèse, Regigigas pattern

---

## Éléments à surveiller (risque d'oubli)

| Élément | Planté | Doit être payé | Alerte |
|---|---|---|---|
| Phileas « sait des choses » | ch5 | ch7+ | ⚠️ Pas encore développé au-delà de ch5 |
| Plum (Jigglypuff, candidate Rondoudou) | CharacterEssentials | ??? | ⚠️ Existe mais jamais placée |
| Saphir (Méga-Pierres) | Bible continuité | Post-game | ⚠️ Prévues, non implémentées |
| Team Dazzling post-défaite | ch6 | ch7+ | ⚠️ Branche `PostDefeatCutscene` existe mais pas testée |
| Écho Lugia (ch10 → ch19) | ch10 | ch19 (Fosse Abysses) | ⚠️ Prévu dans fiches_boss, pas encore implémenté |

---

## Règles

1. **Ne jamais planter sans savoir comment payer.** Tout élément ajouté
   doit avoir une case dans ce tableau avec un chapitre cible de paiement.
2. **Vérifier avant chaque nouveau chapitre** : relire la colonne
   « Planté (ch.) » pour s'assurer qu'aucun élément n'est oublié.
3. **Les twists majeurs** (Necrozma, Eternatus, cause de la transformation)
   doivent avoir au moins 3 indices plantés dans des chapitres différents
   avant d'être révélés.
4. **Le contrôleur de continuité** (outil futur `audit_continuite.py`)
   devra croiser ce fichier avec les flags `SV.*` pour détecter les
   incohérences automatiquement.
