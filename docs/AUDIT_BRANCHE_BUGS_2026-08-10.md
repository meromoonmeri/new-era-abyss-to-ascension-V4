# AUDIT COMPLET DE LA BRANCHE — BUGS & RISQUES DE CRASH

**Date** : 2026-08-10
**Branche** : `arena/019fd882-new-era-abyss-to-ascension-v4` (HEAD `18f9842`)
**Méthode** : validation statique exhaustive — JSON (611 fichiers), références croisées
fichiers/espèces/items/musiques/tilesets, require Lua, APIs vs moteur (api_usage.json /
api_engine.json fournis), hooks de combat, cohérence index.idx.
**Limite** : audit STATIQUE — le moteur PMDO n'a pas été exécuté ici. Tout bug
"crash" est un risque étayé, non une observation runtime.

---

## RÉSUMÉ

| Catégorie | Nombre |
|---|---|
| 🔴 Bugs confirmés (crash / gameplay cassé) | **7** |
| 🟠 Risques / à vérifier au runtime | 4 |
| 🟢 Éléments vérifiés OK | 10 |

---

## 🔴 BUGS CONFIRMÉS

### B1. Ground `s04p01a` ABSENT — 7 références dans des scènes JOUÉES (CRASH)

- **Source** : 7 scènes de l'arc futur font `GAME:EnterGroundMap('s04p01a', ...)` :
  `p05p02a_m17a0301` (traversée du trou dimensionnel), `d18p11a_m17a0701`,
  `d19p11a_m18a0301`, `d20p11a_m18b0701`, `d21p21a_m18b1002`, `d22p11a_m19a0501`,
  `m17a0301` (Data/Script/halcyon/future_arc/scene/*.lua).
- **Ces scènes sont câblées** : `d18p11a_m17a0701` est appelée par
  `ground/d18p11a/init.lua` (retour de Chasm Cave), `p05p02a_m17a0301` est dans
  `FutureArc.SEQUENCE`.
- **État** : `Data/Ground/s04p01a.rsground` **n'existe pas**. Le ground complet
  existe pourtant dans `RESERVE/sky_grounds/sky_s04p01a.rsground` (TexSize 1,
  rendu 1:1, « Un vœu de paix ») mais il est **inactif**.
- **Impact** : `EnterGroundMap` vers un ground inexistant → exception / repli
  quand la scène se joue. C'est un maillon du parcours futur.
- **Correction** : copier `RESERVE/sky_grounds/sky_s04p01a.rsground` →
  `Data/Ground/s04p01a.rsground` (vérifier `AssetName` = `s04p01a`) + l'ajouter
  dans `master_zone.json` si nécessaire.

### B2. `require 'halcyon.future_arc.Dungeon55Events'` — ERREUR DE CASSE (CRASH au chargement)

- **Source** : `Data/Script/halcyon/zone/passage_temps/init.lua:18`.
- **État** : le fichier s'appelle `future_arc/dungeon55_events.lua` (minuscules),
  le require cherche `Dungeon55Events.lua` (CamelCase). Lua est **case-sensitive**.
- **Impact** : crash au chargement de la zone `passage_temps` (présente dans
  index.idx). Appelé aussi par `FutureArc.lua:141` (`EnterDungeon('passage_temps')`).
- **Correction** : `require 'halcyon.future_arc.dungeon55_events'` (ou renommer le
  fichier en `Dungeon55Events.lua`).

### B3. Musique `Dusk Forest.ogg` — MAUVAIS NOM (musique silencieuse)

- **Source** : `Data/Zone/dusk_forest.json` référence `"Dusk Forest.ogg"`.
- **État** : le repo contient **`Deep Dusk Forest.ogg`** (jamais référencé nulle part).
- **Impact** : aucune musique dans Dusk Forest (donjon 32).
- **Correction** : référencer `Deep Dusk Forest.ogg` dans dusk_forest.json (ou
  fournir `Dusk Forest.ogg`).

### B4. Combats déclenchés contre 0 ENNEMI (gameplay cassé)

- **Source** : `Data/Map/crystal_sanctuary_relay.rsmap` et
  `Data/Map/forgotten_marsh_relay.rsmap` : `OnMapStarts` =
  `BattlePositionEvent` + `LuaBeginBattleEvent` + `ResetTurnCounter`, mais
  **`MapTeams` = 0** et aucun script n'ajoute d'équipe.
- **Impact** : le clear check passe immédiatement → le « combat de relais »
  (censé être un boss/rencontre) se termine sans combat, ou comportement indéfini.
- **Correction** : ajouter l'équipe ennemie dans MapTeams, ou retirer
  `LuaBeginBattleEvent` si le relais n'est pas censé avoir de combat.

### B5. Musique `Sealed Ruin Pit.ogg` — ABSENTE (REQUIRES_ASSET)

- **Source** : 3 références — `Data/Map/spiritomb_arena.rsmap`,
  `Data/Zone/sealed_ruin_pit.json`, `Data/Zone/spiritomb_room.json`.
- **État** : absente de Content/Music (seul `Sealed Ruin.ogg` existe).
- **Impact** : musique silencieuse dans Sealed Ruin Pit + l'arène Spiritomb.
- **Correction** : REQUIRES_ASSET (fichier NDS `Sealed Ruin Pit` à fournir).

### B6. Musique `Rayquazas Domain.ogg` — ABSENTE (REQUIRES_ASSET)

- **Source** : `Data/Ground/tour_ciel_sommet.rsground`.
- **État** : absente de Content/Music (aucune variante proche).
- **Impact** : musique silencieuse au sommet de la Tour Céleste.
- **Correction** : REQUIRES_ASSET.

### B7. NPC fantômes (Level 0, espèce `missingno`) — mineur

- **Source** : `Data/Ground/luminous_spring.rsground` et
  `Data/Ground/gloomy_forest_midpoint.rsground` : entrées personnage
  `BaseForm.Species = "missingno"`, Level 0.
- **Impact** : sprite invisible / comportement indéfini si ces entrées sont
  activées. (Les 134 autres `missingno` sont des placeholders de Spawner
  Teammate1/2/3 — NORMALE, remplacés au runtime.)
- **Correction** : nettoyer les 2 entrées fantômes.

---

## 🟠 RISQUES / À VÉRIFIER AU RUNTIME

| # | Risque | Fichiers | Note |
|---|---|---|---|
| R1 | Tileset `test_dungeon_*` utilisé massivement | 55 `.rsmap` de boss/rooms (ex: boss_eclipse) | Rendu générique (esthétique), pas un crash. Vérifier si volontaire. |
| R2 | Espèces à nom underscore | `porygon_z`, `mime_jr`, `mr_mime`, `nidoran_f`, `nidoran_m` (zones) | Probablement valides (nommage PMDO des formes), à confirmer au runtime. |
| R3 | Tileset `unused_waterfall_pond_*` | `Data/Zone/grotte_mystere.json` | Nom "unused" référencé — vérifier si c'est le bon tileset. |
| R4 | `GROUND.EnterGroundMap` (1 usage) | — | Faux positif probable (0 occurrence réelle dans le code). |

---

## 🟢 ÉLÉMENTS VÉRIFIÉS OK

1. **JSON valides** : 611 fichiers (298 .json + 313 .rsground/.rsmap/.tile) — **0 invalide**.
2. **Types `$type`** : 0 inconnu, **0 MultiSpawner** → le crash historique
   `FileLoadException chasm_cave` (log 2026-08-09) est **corrigé**.
3. **index.idx** : 56 zones fichier = 56 zones listées (cohérent).
4. **MapID → .rsmap** : 94 référencés, tous présents (hors s04p01a qui est un ground).
5. **EnterGroundMap → .rsground** : seul `s04p01a` manquant (B1).
6. **master_zone GroundMaps** : tous les grounds référencés existent.
7. **MapStatus/Status** : tous les référencés existent (darkness, dusk, steam…).
8. **Skills** : 232 uniques, 0 nom suspect (tous canoniques PMDO).
9. **API Lua vs moteur** (api_usage.json vs api_engine.json) : **0 API inexistante**
   (5 faux positifs = sous-objets `STRINGS.MapStrings`/`GAME.Rand`, alias `_MoveCamera`/
   `_CharAnimateTurnTo`, encodage).
10. **Clés STRINGS RUINES_*** : 122 définies, toutes référencées couvertes.

---

## ANALYSE DU LOG DE CRASH (2026-08-09.txt)

```
System.NullReferenceException
   at RogueEssence.Dev.ViewModels.DevTabTravelViewModel.ZoneChanged()
   at ...DevTabTravelViewModel.ReloadZones()
```
- **Cause immédiate** : l'onglet Travel charge les zones ; une zone dont le JSON
  échoue à désérialiser (à l'époque : `chasm_cave.json` avec `MultiSpawner`
  non résolu) laissait un pointeur null dans la liste → `ZoneChanged()` crashe.
- **État actuel** : le MultiSpawner a été remplacé par les types natifs
  (PoolTeamSpawner/TeamContextSpawner) — vérifié : **0 MultiSpawner, 0 type
  inconnu** dans les 57 zones. Le crash DevTab ne devrait plus se produire.
- **À surveiller** : si le DevTab recharge et qu'une des 57 zones référence un
  fichier manquant (ex: une musique), la désérialisation des données peut encore
  échouer → NullReference. Les B1-B6 doivent être corrigés pour un DevTab stable.

---

## VERDICT

- **Aucun crash avéré au boot** de la chaîne principale (tous les require
  top-level résolus, sauf `Dungeon55Events` qui ne crashe qu'à l'entrée de
  `passage_temps`).
- **3 bugs corrigibles immédiatement** (B1, B2, B3) — fichiers existants, il
  suffit de copier/renommer.
- **2 assets manquants** (B5, B6) → REQUIRES_ASSET (fournir les .ogg).
- **2 combats vides** (B4) → à corriger dans les .rsmap.
- **Statut global** : `STATIC VERIFIED` avec 7 bugs identifiés ; `REQUIRES_RUNTIME`
  pour la validation finale en jeu.
