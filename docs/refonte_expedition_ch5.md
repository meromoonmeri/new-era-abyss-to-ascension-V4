# Refonte intégrale — Expédition ch5 : Landes Sauvages → Tunnel → Sommet des Mille Vents

> Date : 2026-07-30. Document de conception.
> Philosophie : le joueur se souvient de cette expédition comme d'une aventure.

---

## Nouvelle nomenclature

| Ancien nom | Nouveau nom FR | ID technique (inchangé) |
|---|---|---|
| Grande Steppe | **Les Landes Sauvages** | `vast_steppe` |
| Tunnel Incandescent | **Le Creuset** | `searing_tunnel` |
| Mont Venteux | **Le Sommet des Mille Vents** | `mount_windswept` |
| Expédition ch5 | **Expédition du Mont Éternelle** | — |

L'ID technique reste identique pour ne pas casser les sauvegardes.
Seul le nom affiché (`Name.LocalTexts.fr`) change.

---

## Boss — Remplacements

| Donjon | Ancien boss | Nouveau boss | Justification |
|---|---|---|---|
| Le Creuset (searing_crucible) | Magcargo + 8 Slugma | **Heatran** (niv 36) | Gardien des profondeurs volcaniques, forces géothermiques |
| Sommet des Mille Vents — Gardien | Aerodactyl (niv 32) | **Boréas / Tornadus** (niv 45) | Maître des vents, tempêtes, courants aériens |
| Sommet des Mille Vents — Mini-boss | Gligar + Skarmory (niv 30) | **Inchangé** | Sentinelles du vent, cohérent avec le biome |

### Heatran — Le Creuset

**Identité** : Ancien gardien des profondeurs volcaniques. Heatran ne parle pas —
il est une force de la nature, une présence géothermique. Pas de dialogue,
pas de Voix de l'Abîme. La montagne elle-même est son langage.

**Indices environnementaux avant le combat** :
- Fissures chaudes dans les parois du tunnel (Steam VFX)
- Pierres rougies par la chaleur (tileset Spring_Cave_Pit existant)
- Secousses discrètes qui s'intensifient (ScreenMover progressif)
- BGM qui monte en tension (pas de changement brusque)

**Apparition** : flash blanc simple. Heatran émerge de la lave.
Pas d'animation Sacred_Fire_Ranger — le flash blanc est suffisant
et cohérent avec les standards PMDO.

**Combat** : Heatran seul (pas de Slugma). Niveau 36.
Moveset : Feu/Acier, capacités signature (Éruption, Lame de Roc, Tête de Fer).

### Boréas (Tornadus) — Sommet des Mille Vents

**Identité** : Maître des vents. Boréas ne parle pas en mots — il parle
en rafales, en tourbillons, en changements de pression. Sa présence
est annoncée par des phénomènes météorologiques tout au long de l'ascension.

**Indices environnementaux avant le combat** :
- Rafales inhabituelles dès les premiers étages (Ominous_Wind VFX)
- Témoignages d'explorateurs au relais ("Le vent a une volonté propre")
- Changements soudains de climat (dusk → vent violent → éclaircies)
- BGM de tempête qui monte progressivement

**Apparition** : flash blanc + descente des nuages.
Boréas se matérialise au sommet, entouré de vents tourbillonnants.
Utiliser `BossFX.Flash` + `Ominous_Wind` overlay.

**Combat** : Boréas seul. Niveau 45 (boss final de l'expédition).
Moveset : Vol, capacités de vent (Vent Arrière, Tornade, Lame d'Air, Cru-Aile).

---

## Progression environnementale de l'ascension

| Segment | Altitude | Biome | Végétation | Vent | Indices Heatran/Boréas |
|---|---|---|---|---|---|
| Landes Sauvages seg 0-2 | Plaines | Prairie, herbes hautes | Dense | Léger | Aucun |
| Landes Sauvages seg 3-4 | Collines | Rocaille, buissons | Raréfiée | Modéré | Aucun |
| Creuset seg 0-1 | Sous-terrain | Tunnel volcanique | Nulle | Nul | Fissures, vapeur |
| Creuset seg 2 (boss) | Chambre magma | Lave, roches noires | Nulle | Nul | Chaleur extrême |
| Sommet seg 0-1 | Basse montagne | Forêt d'altitude, sapins | Conifères | Fort | Rafales inhabituelles |
| Sommet seg 2 (relais) | Mi-montagne | Terrasse panoramique | Fleurs alpines | Protégé | Témoignages |
| Sommet seg 3 | Haute montagne | Falaises, roches nues | Nulle | Violent | Tempête approche |
| Sommet seg 4 (boss) | Sommet | Ciel ouvert, nuages | Nulle | Ouragan | Boréas |

---

## Le relais — La Terrasse des Vents

Le relais du Sommet des Mille Vents est une terrasse naturelle protégée
du vent par une paroi rocheuse. Un ancien campement d'explorateurs y
est installé : pierres plates formant un cercle, restes de feu de camp,
marques de grattoirs sur la roche.

**Ambiance** : le vent souffle au-delà de la terrasse mais ne pénètre pas.
Le joueur entend le vent sans le subir. Les nuages défilent en contrebas.
Le panorama sur les vallées est visible (overlay parallaxe).

**Cinématique** (SummitVigilScene déjà existante, enrichie) :
- L'équipe arrive, épuisée mais déterminée
- Chacun observe le paysage (regards vers le bas, l'horizon)
- Le partenaire évoque le chemin parcouru
- Ganlon parle de ce qui les attend au sommet
- Shuca ressent la présence de Boréas ("Le vent a changé")
- Moment de calme avant la tempête
- Départ vers le sommet avec détermination

---

## Animations de boss — Simplification

**Avant** : animations complexes (Sacred_Fire_Ranger, Slugma_Materialize,
Ominous_Wind wings, impact dust clouds)

**Après** : flash blanc standard (`BossFX.Flash`) pour toutes les
apparitions et disparitions de boss. Plus propre, plus cohérent avec
les standards PMDO, et plus fiable techniquement (pas de luanet.import_type).

| Boss | Apparition | Disparition |
|---|---|---|
| Heatran | BossFX.Flash + Unhide | BossFX.Flash + Hide |
| Boréas | BossFX.Flash + Unhide + Ominous_Wind overlay | BossFX.Flash + Hide |
| Gligar | BossFX.Flash + Unhide | BossFX.Flash + Hide |
| Skarmory | BossFX.Flash + Unhide | BossFX.Flash + Hide |

---

## Fichiers à modifier

| Fichier | Modification |
|---|---|
| `Data/Zone/vast_steppe.json` | Nom FR : "Grande Steppe" → "Les Landes Sauvages" |
| `Data/Zone/searing_tunnel.json` | Nom FR : inchangé ("Le Creuset" via strings) |
| `Data/Zone/mount_windswept.json` | Nom FR : "Mont Venteux" → "Le Sommet des Mille Vents" |
| `Data/Map/searing_crucible.rsmap` | Species: magcargo→heatran, supprimer slugma |
| `Data/Map/mount_windswept_guardian.rsmap` | Species: aerodactyl→tornadus |
| `searing_crucible_ch_5.lua` | Magcargo→Heatran, retirer Slugma, simplifier VFX |
| `mount_windswept_guardian_ch_5.lua` | Aerodactyl→Tornadus, simplifier VFX |
| `mount_windswept_miniboss_ch_5.lua` | Simplifier VFX (flash blanc) |
| `docs/direction_cinematographique_mont_venteux.md` | Mise à jour avec les nouveaux boss |
