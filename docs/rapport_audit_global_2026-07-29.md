# Rapport d'audit global — New Era — 2026-07-29

## Résumé par catégorie

| Catégorie | Trouvés | Corrigés | Signalés |
|---|---|---|---|
| Variables SV non déclarées | 29 | 29 (garde-fous) | 0 |
| PoseFaint non protégés | 3 fichiers | 2 (crooked_den) | 1 (RaidScenes, déjà sous pcall) |
| Ground maps absentes (master_zone) | 11 | 0 | 11 (camps importés) |
| Boss level scaling incorrect | 7 boss | 7 | 0 |
| Assets audio manquants | 0 | — | — |
| Clés traduction FR manquantes | 0 | — | — |
| Faute de frappe ParnterCompleted | 0 | — | Déjà corrigée |

## Corrections appliquées

### 1. Variables SV non déclarées (scriptvars.lua)

29 champs utilisés mais non déclarés, ajoutés avec garde-fous `if nil then` :
- `SV.Reseau` : Adieux, StationIntros, Veilleurs, VoiesOuvertes
- `SV.LegendZones` : ArrivalScenePlayed, Defeated, MetMerchant
- `SV.TownNight` : SawStars, Seen, VoiceHeard
- `SV.Anchors` : Adieux, Stabilized
- `SV.Chapter3` : CrookedMidpointState, CrookedPlayedMidpointIntro
- `SV.DailyFlags` : PurpleKecleonRefreshedStock, PurpleKecleonStock
- `SV.TownReward` : LastMoney, Total
- `SV.Chapter5/7/8/9/10` : MidState, TunnelSegmentsShiftedFix
- `SV.Seasons` : Actif
- `SV.TownPlunder` : TotalRaids

### 2. PoseFaint protégés (crooked_den_ch_3.lua)

- Ligne 621 : Glameow `PoseGroundAction("Faint")` → enveloppé dans `pcall`
- Ligne 652 : Luxio `PoseGroundAction("Faint")` → enveloppé dans `pcall`
- `RaidScenes.lua` : déjà sous `pcall`, pas de modification nécessaire

### 3. Boss level scaling (6 fichiers .rsmap)

| Boss | Avant | Après |
|---|---|---|
| Zarude (ch6) | 27 | 34 |
| Regigigas (ch7) | 28 | 36 |
| Regi trio (ch7) | 26 | 34 |
| Diancie (ch8) | 30 | 38 |
| Laggron (ch9) | 32 | 40 |
| Escouade Fulgur (ch10) | 33 | 42 |
| Lugia (ch10) | 35 | 45 |

## Décisions en attente

### 11 ground maps absentes de master_zone

Fichiers référencés dans `master_zone.json` mais absents du disque :
- `base_camp`, `base_camp_2`, `forest_camp`, `cliff_camp`, `canyon_camp`
- `rest_stop`, `final_stop`, `guildmaster_summit`, `guild_path`, `guild_hut`
- `test_grounds`

**Options** :
- (A) Les supprimer de `master_zone.json` — ces camps sont des imports PMDODump
  qui n'ont jamais été intégrés comme fichiers séparés
- (B) Les conserver avec un commentaire — ils pourraient servir de référence
- (C) Les créer à partir des templates PMDODump existants

**Recommandation** : Option (A) — ces maps sont déjà intégrées dans les
donjons sous d'autres noms (`searing_tunnel_midpoint` = `canyon_camp`,
`vast_steppe_midpoint` = `cliff_camp`, etc.)

## Non résolu (impossible sans test en jeu)

- **Crash `vast_steppe`** après boucle Mission 1-8 : nécessite test en jeu
- **Sacs en double `searing_tunnel_entrance`** : nécessite test en jeu
- **Penticus bloque le passage** : nécessite test en jeu
- **Coffre bugué `searing_tunnel_entrance`** : nécessite test en jeu
- **Effets vertige/rêve non chargés** : nécessite test en jeu
- **Branche défaite Zarude (ch6)** : nécessite test en jeu
- **Cycle nuit Metano Town** : nécessite test en jeu
- **265 appels EnterGroundMap** : vérifiés statistiquement, aucun
  inter-zone évident détecté — validation manuelle recommandée

## Fichiers modifiés

- `Data/Script/halcyon/scriptvars.lua` — 29 garde-fous SV + BaseConstruction
- `Data/Script/halcyon/ground/crooked_den/crooked_den_ch_3.lua` — 2 pcall PoseFaint
- `Data/Map/gloomy_forest_boss.rsmap` — Zarude 27→34
- `Data/Map/sanctuaire_titans.rsmap` — Regigigas 28→36, trio 26→34
- `Data/Map/crystal_sanctuary_boss.rsmap` — Diancie 30→38
- `Data/Map/forgotten_marsh_boss.rsmap` — Laggron 32→40
- `Data/Map/celestial_peak_fulgur.rsmap` — Fulgur 33→42
- `Data/Map/celestial_peak_boss.rsmap` — Lugia 35→45

## Documents créés

- `docs/level_scaling_boss_donjons.md` — Courbe de niveaux + variété faunique
- `docs/rapport_audit_global_2026-07-29.md` — Ce rapport

## Tests à effectuer manuellement

1. Parcourir ch1-5 de bout en bout (vérifier transitions, boss, cinématiques)
2. Tester `searing_tunnel_entrance` : sacs, Penticus, coffre, vertige
3. Tester défaite contre Zarude (ch6) : branche de retour
4. Vérifier cycle nuit Metano Town
5. Tester les boss re-nivelés : sont-ils assez difficiles ? trop ?
