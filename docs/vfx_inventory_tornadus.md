# Inventaire VFX — Entrée légendaire de Boréas (Tornadus)

> Analyse exhaustive des assets PMDO disponibles pour la scène d'apparition.
> Chaque effet est classé par phase de la cinématique.

---

## PHASE 1 — Les premiers signes (0-30 secondes)
*Le vent change. Les personnages le remarquent.*

| VFX | Type | Utilisation | Moment |
|---|---|---|---|
| `Ominous_Wind` | Overlay défilant | Rafales sombres traversent l'écran de droite à gauche | Dès le début, subtil (alpha 80) |
| `Gust_Wind` | Particules | Petites bourrasques locales autour des personnages | Quand partner remarque le changement |
| `blowing_wind` | MapStatus | Statut de vent actif sur toute la carte | Posé dès le début de la scène |
| `SE5_Wind_Background` | BG parallaxe 5120×256 | Ciel de vent en arrière-plan, défilement horizontal | Overlay lointain, vitesse lente |
| `ScreenMover(1,2,30)` | Mouvement écran | Léger tremblement de caméra (vent qui pousse) | Continu, subtil |

**SE associés :**
- `EVT_Emote_Shock` — quand le partenaire sursaute
- Vent ambiant (LoopSE si disponible)

---

## PHASE 2 — La montée en puissance (30-60 secondes)
*Le vent devient violent. Les nuages s'accumulent. Quelque chose approche.*

| VFX | Type | Utilisation | Moment |
|---|---|---|---|
| `Ominous_Wind` | Overlay défilant | Intensifié (alpha 160, vitesse ×2) | Progressif |
| `Cloudy_Sky` | Overlay ciel | Nuages sombres qui s'accumulent | Au-dessus de l'arène |
| `clouds_overhead` | MapStatus | Couverture nuageuse dense | Posé pendant la montée |
| `Sandstorm` | Overlay tempête | Poussière et débris emportés par le vent | Rafales au sol |
| `Feather` | Particules | Plumes emportées par les courants | Quand Boréas approche |
| `Silver_Wind` | Particules | Vent argenté/spectral (dimension légendaire) | Juste avant l'apparition |
| `ScreenMover(3,5,30)` | Mouvement écran | Secousses plus fortes | Pendant la tempête |

**SE associés :**
- `EVT_Tower_Quake` — grondement profond (le ciel tremble)
- `EVT_Emote_Exclaim` — cris de surprise de l'équipe
- `_UNK_EVT_003` — son d'apparition légendaire (utilisé pour Aerodactyl)

---

## PHASE 3 — L'apparition (60-80 secondes)
*Le ciel se déchire. Boréas se matérialise dans un tourbillon.*

| VFX | Type | Utilisation | Moment |
|---|---|---|---|
| `White` | Flash BG (FlashEmitter) | Flash blanc aveuglant (FadeIn 2, Hold 4, FadeOut 20) | Point culminant |
| `EVT_Battle_Flash` | SE | Son du flash | Synchronisé avec le flash |
| `wand_whirlwind` | Tourbillon | Vortex d'air autour du point d'apparition | Pendant le flash |
| `Ominous_Wind` | Overlay | Deux couches croisées (gauche→droite + droite→gauche) | Tourbillon final |
| `Gust_Wind` | Particules | Rafales explosives depuis le centre | À l'impact |
| `Feather` | Particules | Pluie de plumes à l'apparition | Après le flash |

**Séquence exacte :**
```
t=0    : White flash (FadeIn 2f)
t=2    : EVT_Battle_Flash SE
t=4    : Hold (flash blanc plein écran)
t=6    : wand_whirlwind apparaît au centre
t=10   : Tornadus Unhide (le Pokémon est révélé)
t=12   : Feather + Gust_Wind explosent depuis Tornadus
t=20   : ScreenMover(4,6,30) — impact au sol
t=24   : White flash (FadeOut 20f) — retour à la normale
t=44   : Ominous_Wind persiste (aura de Tornadus)
```

---

## PHASE 4 — La révélation (80-120 secondes)
*Boréas flotte au-dessus de l'arène, entouré de vents. Il observe l'équipe.*

| VFX | Type | Utilisation | Moment |
|---|---|---|---|
| `Ominous_Wind` | Overlay lent | Aura permanente autour de Tornadus | Tant qu'il est visible |
| `Silver_Wind` | Particules lentes | Courants d'air subtils autour de son corps | Continu |
| `clouds_overhead` | MapStatus | Ciel couvert, menaçant | Persiste |
| `Cosmic_Power` | Particules | Énergie légendaire (lueur subtile) | Quand il parle/agit |

**SE associés :**
- Vent ambiant continu (LoopSE)
- `EVT_Emote_Shock` — réactions de l'équipe

---

## PHASE 5 — Transition vers le combat
*Le vent redouble. L'écran se remplit de rafales. Transition BossTransition.*

| VFX | Type | Utilisation | Moment |
|---|---|---|---|
| `Ominous_Wind` | Overlay rapide | Vent maximal, deux couches croisées | Juste avant le combat |
| `Sandstorm` | Overlay | Tempête de poussière | Dernier souffle |
| `White` | Flash BG | Flash final de transition | BossTransition |
| `darkness` | MapStatus | Obscurcissement pré-combat | Pendant la transition |

---

## Bibliothèque VFX complète pour Tornadus

### Overlays (FiniteOverlayEmitter)
- `Ominous_Wind` — vent sombre défilant (principal)
- `Silver_Wind` — vent argenté/spectral
- `Sandstorm` — tempête de poussière
- `Cloudy_Sky` — ciel nuageux
- `Fog` — brouillard (optionnel, pour l'ambiance)
- `Steam` — vapeur (optionnel, humidité)

### Backgrounds (BGAnimData)
- `White` — flash blanc (apparition)
- `Black` — noir (transitions)
- `SE5_Wind_Background` — parallaxe vent (5120×256)
- `Cloudy_Sky` — ciel couvert

### Particules (AnimData / StaticAnim)
- `Feather` — plumes
- `Gust_Wind` — rafales
- `wand_whirlwind` — tourbillon
- `Flash_Cannon_Sparkle` — étincelles
- `Cosmic_Power` — énergie cosmique

### MapStatus
- `blowing_wind` — vent actif
- `clouds_overhead` — nuages
- `darkness` — obscurité
- `Sandstorm` — tempête de sable

### Sons (PlayBattleSE / LoopSE)
- `EVT_Battle_Flash` — flash
- `EVT_Tower_Quake` — grondement
- `EVT_Emote_Shock` — choc
- `EVT_Emote_Exclaim` — exclamation
- `_UNK_EVT_003` — apparition légendaire
- `DUN_Wind` — vent donjon

### Mouvements d'écran (ScreenMover)
- Léger : `ScreenMover(1, 2, 30)` — brise
- Modéré : `ScreenMover(3, 5, 30)` — vent fort
- Fort : `ScreenMover(4, 6, 30)` — tempête
- Impact : `ScreenMover(5, 8, 20)` — choc
