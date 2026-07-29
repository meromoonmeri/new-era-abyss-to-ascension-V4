# Treasure Town — Intégration dans New Era

> Dernière mise à jour : 2026-07-29.
> Document lié à `PROMPT_MAITRE.md`, `directive_monde_vivant.md`.

---

## Principe

Treasure Town est accessible à un moment précis et délimité de l'histoire,
comme une parenthèse narrative ponctuelle. Une fois introduite, elle doit
atteindre le même niveau de vie et de fonctionnalité que Metano Town.

## Source de référence

**ProjectEoN** : <https://github.com/Logical321/ProjectEoN>

Étudier comment Treasure Town y est implémentée (structure de maps,
agencement des zones, PNJ, job board) avant de l'adapter à New Era.
Ne pas copier : comprendre la logique, puis adapter.

---

## Récupération et adaptation des maps

1. Extraire les maps de Treasure Town depuis ProjectEoN
2. Adapter au format PMDO via `outil_generateur_map_tileset.md`
3. Conversion d'assets si nécessaire via `outil_conversion_assets_pmdsky.md`
4. Vérifier cohérence d'échelle, style visuel, biome

---

## Justification narrative

### Moment dans l'histoire

**Chapitre 12-14** (Arc 2 : Les Cœurs qui s'éteignent).

Le héros et son partenaire sont envoyés en mission diplomatique auprès
d'une guilde sœur, située dans une région côtière éloignée. Cette guilde
opère depuis Treasure Town — une ville portuaire construite autour d'un
ancien dépôt de trésors marins.

### Raison narrative

La guilde de Treasure Town a détecté des perturbations dans le Cœur
d'Anima de sa région — le même phénomène que celui observé à Metano.
Penticus envoie le héros pour :
- Échanger des informations sur les Cœurs corrompus
- Coordonner les efforts entre les deux guildes
- Enquêter sur un donjon marin local lié à la perturbation

### Mise en scène d'entrée

Le voyage est montré (pas un simple fondu) :
- Fondu noir avec musique de voyage
- Panorama de la côte (overlay ou BG dédié)
- Arrivée par le port — le duo découvre la ville
- Premier PNJ guide vers la guilde locale

### Mise en scène de sortie

Une fois la mission terminée :
- Adieu aux PNJ de Treasure Town (réactions personnalisées)
- Départ par le port — fondu avec musique
- Retour à Metano Town — les PNJ de Metano réagissent au retour

---

## Parité de vie — Metano Town ↔ Treasure Town

### Standards communs (les deux villes respectent)

| Critère | Metano Town | Treasure Town |
|---|---|---|
| PNJ réactifs aux événements | ✅ TownVoices/TownVoicesLate | ⬜ À créer (TreasureVoices) |
| Positions variables par jour | ✅ TownPositions | ⬜ À créer |
| Cycle jour/nuit | ✅ TownNight | ⬜ À créer |
| Job board fonctionnel | ✅ mission_gen.lua | ⬜ À adapter |
| Shops fonctionnels | ✅ Kecleon, Kangaskhan, etc. | ⬜ À créer |
| Raids nocturnes | ✅ TownRaid | ⬜ Optionnel (voir justification) |
| Dialogues en français | ✅ | ⬜ À écrire |

### PNJ de Treasure Town (à créer)

| PNJ | Espèce | Rôle | Personnalité |
|---|---|---|---|
| **Chef de guilde locale** | Pelican | Direction de la guilde sœur | Vieux loup de mer, pragmatique |
| **Explorateur maritime** | Sharpedo | Missions maritimes | Impulsif, courageux |
| **Marchand de coquillages** | Slowbro | Boutique locale | Lent mais précis |
| **Guérisseuse** | Chansey | Soins et repos | Maternelle, inquiète |
| **PNJ mystère** | Dusknoir | Lié à l'intrigue de l'Abîme | Énigmatique, voyageur |
| **Habitants** | 8-10 PNJ | Vie quotidienne | Variés, réactifs |

### Dusknoir — pont narratif avec l'Abîme

Dusknoir est un PNJ de Treasure Town qui connaît les légendes de
« Celui qui dort ». Il ne dit pas tout — il suggère, il met en garde.
Son rôle est de semer du foreshadowing pour l'arc 5-6 (Necrozma/Eternatus).

**Portails de Dusknoir** : les assets de portail trouvés dans
ExplorersOfSkyOrigins peuvent être mis de côté pour une réutilisation
future — Dusknoir pourrait ouvrir des portails vers des donjons
spéciaux (mécanique de téléportation liée à l'Abîme).

---

## Job board de Treasure Town

### Missions locales (biome marin/côtier)

| Type | Exemple | Récompense |
|---|---|---|
| Sauvetage | Pokémon perdu dans les récifs | Objet rare marin |
| Exploration | Cartographier une grotte sous-marine | Badge spécial |
| Livraison | Transporter un colis entre ports | Argent + objet |
| Élimination | Calmer un Sharpedo enragé | CT Eau |

### Fonctionnement technique

Le job board de Treasure Town utilise le même `mission_gen.lua` que
Metano Town, avec un paramètre `town = 'treasure'` qui filtre les
missions selon le biome local et les PNJ de Treasure Town.

---

## Checklist d'intégration

- [ ] Maps Treasure Town extraites de ProjectEoN et adaptées
- [ ] Justification narrative claire (ch12-14, mission diplomatique)
- [ ] Mise en scène d'entrée (voyage, arrivée, découverte)
- [ ] Mise en scène de sortie (adieux, départ, retour)
- [ ] PNJ réactifs aux événements (TreasureVoices.lua)
- [ ] Positions variables par jour (TreasurePositions.lua)
- [ ] Job board fonctionnel avec missions locales
- [ ] Shops fonctionnels (au moins 3 boutiques)
- [ ] Dusknoir intégré comme pont narratif avec l'Abîme
- [ ] Parité de vie vérifiée entre les deux villes
- [ ] Aucune incohérence géographique/visuelle/narrative
