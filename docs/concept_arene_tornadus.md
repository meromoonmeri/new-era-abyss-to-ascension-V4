# Concept — Arène de Boréas (Tornadus)

> Level design PMDO — arène de boss légendaire
> Tileset : craggy_peak (falaise escarpée)
> Dimensions : 17×15 tuiles (408×360 px à 24px/tuile)

---

## Identité visuelle

**Nom** : Le Nid des Vents
**Biome** : Sommet montagneux balayé par les tempêtes
**Ambiance** : Exposition totale aux éléments, vent permanent, ciel menaçant
**Couleurs dominantes** : Gris-bleu (roche), blanc (nuages), vert sombre (mousse)

## Organisation spatiale

```
        NORD (falaise, précipice)
  ┌─────────────────────────────────┐
  │  ╔═══════════════════════════╗  │
  │  ║   ZONE COMBAT (ouverte)   ║  │
  │  ║                           ║  │
  │  ║   Tornadus (224, 120)     ║  │  ← Position haute, dominant
  │  ║                           ║  │
  │  ║                           ║  │
  │  ║   Équipe (224, 280)       ║  │  ← Position basse, exposée
  │  ║                           ║  │
  │  ╚═══════════════════════════╝  │
  │         ENTRÉE (sud)            │
  └─────────────────────────────────┘
        SUD (chemin d'accès)
```

### Éléments de décor

| Élément | Position | Rôle narratif | Rôle gameplay |
|---|---|---|---|
| Falaise nord | y=0-40 | Précipice, danger | Limite naturelle de l'arène |
| Plateau central | y=80-300 | Zone de combat | Espace ouvert pour le combat |
| Rochers épars | Positions variées | Abri contre le vent | Couvert tactique limité |
| Mousse/lierre | Bords du plateau | Nature qui résiste au vent | Décoration atmosphérique |
| Entrée sud | y=340-360 | Chemin d'accès | Point de spawn de l'équipe |

### Transition exploration → arène

Le joueur arrive par le sud après avoir traversé les crêtes venteuses.
L'entrée de l'arène est marquée par :
1. **Changement de tileset** : les craggy_peak_floor deviennent plus clairs (sommet)
2. **Élargissement** : le chemin étroit s'ouvre sur un plateau
3. **Vent visuel** : Ominous_Wind overlay permanent
4. **Ciel** : clouds_overhead MapStatus actif
5. **Silence** : la BGM s'arrête, seul le vent reste

---

## Gameplay

### Taille de l'arène

- **Zone de combat** : ~12×10 tuiles (288×240 px)
- **Espace suffisant** pour :
  - Tornadus (volant, se déplace rapidement)
  - Équipe de 4 Pokémon (espacés)
  - Attaques à zone (Vent Arrière, Tornade)
  - Esquives latérales

### Positions de combat

| Entité | Position | Direction |
|---|---|---|
| Tornadus | (224, 120) | Down |
| Héros | (208, 280) | Up |
| Partenaire | (240, 280) | Up |
| Teammate2 | (176, 296) | UpRight |
| Teammate3 | (272, 296) | UpLeft |

### Structure de combat (phases)

| Phase | PV Tornadus | Dialogue | Effet |
|---|---|---|---|
| 1 — Domination | 100-75% | MWG_080 | Vent normal |
| 2 — Reconnaissance | 75-50% | MWG_081 | Vent + fort, ScreenMover |
| 3 — Défi | 50-25% | MWG_082 | Tempête, Ominous_Wind intense |
| 4 — Dernier souffle | 25-0% | MWG_083 | Vent maximal, émotional |

---

## VFX permanents de l'arène

| VFX | Type | Intensité | Phase |
|---|---|---|---|
| `blowing_wind` | MapStatus | Constant | Toutes |
| `clouds_overhead` | MapStatus | Constant | Toutes |
| `Ominous_Wind` | Overlay | Faible→Fort | 1→4 |
| `ScreenMover` | Écran | (1,2)→(4,6) | 1→4 |

---

## Musique

| Phase | Musique | Ambiance |
|---|---|---|
| Entrée | Silence + vent | Tension |
| Combat début | `Boss Battle!.ogg` | Énergique |
| Phase 3+ | `Boss Battle!.ogg` (inchangé) | Intense |
| Victoire | `In the Depths of the Pit.ogg` | Solennel |
