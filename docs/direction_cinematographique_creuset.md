# Direction cinématographique — Searing Crucible (Creuset)

> Refonte complète de la mise en scène. Philosophie : chaque scène a une âme.
> Si l'on retire les dialogues, le joueur comprend l'histoire par les corps.

---

## CARTE — searing_crucible (384×384 px, tileset Spring_Cave_Pit)

```
  Y=0  ┌─────────────────────────────┐
       │         LAVE (nord)         │
       │   ┌─────────────────────┐   │
       │   │   ARÈNE COMBAT      │   │  ← Magcargo (256,192)
       │   │   256×192 centre    │   │
       │   │                     │   │  ← Slugma en cercle (8 positions)
       │   └─────────────────────┘   │
       │                             │
       │     ENTRÉE (sud)            │  ← Équipe arrive (240-272, 472)
  Y=384└─────────────────────────────┘
       X=0                         X=384
```

### Positions naturelles (refonte)

**Équipe — arrivée en formation décalée (pas en ligne)**
```
                    hero (244,308)
          partner (268,316)      ← légèrement en retrait, protecteur
    growlithe (228,344)          ← flanc gauche, soldat
              zigzagoon (272,348) ← flanc droit, nerveux
```

**Magcargo — centre de l'arène**
```
              magcargo (256,192)   ← dos à la lave, face à l'entrée
```

**Slugma — en cercle organique (pas en grille parfaite)**
```
  S_B1 (216,200)     S_G1 (296,200)    ← proche de Magcargo, protégés
    S_B2 (188,248)   S_G2 (324,248)    ← flancs
      S_B3 (200,280) S_G3 (312,280)    ← avancés, curieux
  S_B4 (224,312)     S_G4 (288,312)    ← les plus proches de l'équipe
```

---

## SCÈNE 1 — L'ARRIVÉE (FirstPreBossScene, ~2 min)

### Beat 1.1 — Entrée dans le Creuset
**Intention** : le joueur découvre un lieu hostile, magnifique et dangereux.

| Temps | Action | Caméra | Son |
|---|---|---|---|
| 0f | Écran noir | — | Silence |
| 1f | Titre du lieu apparaît | Fixe (264,336) | Vent caverneux lointain |
| 60f | Titre disparaît | — | — |
| 80f | **Fondu d'ouverture (60f)** | — | Montée progressive BGM |
| 140f | Image révélée : lave au nord, équipe au sud | — | BGM "In the Depths" |
| 160f | Équipe marche vers le centre | Pan lent vers le haut | BGM |

**Mouvements** :
- `hero` avance en premier (leader naturel), vitesse 1 (déterminé)
- `partner` suit à 8f de décalage, vitesse 1 (solidaire)
- `growlithe` à 18f, vitesse 1 (soldat qui scanne)
- `zigzagoon` à 14f, vitesse 1 mais avec un léger zigzag (nerveux)

### Beat 1.2 — Exploration du regard
**Intention** : chacun évalue le danger à sa manière.

| Personnage | Comportement | Durée |
|---|---|---|
| hero | Regarde autour calmement, puis fixe le nord (lave) | 40f |
| partner | Regarde hero, puis la lave, puis les parois | 40f |
| growlithe | Scan militaire : gauche, droite, nord, sud | 40f |
| zigzagoon | Regarde partout nerveusement, recule d'un pas | 40f |

### Beat 1.3 — Premier dialogue (le groupe se rassemble)
**Intention** : le groupe fait face ensemble au danger.

```
Disposition pour le dialogue (cercle ouvert vers le nord) :

         hero ──── partner
           │         │
     growlithe ── zigzagoon

Tous regardent vers le centre du cercle (les uns les autres).
```

- `partner` parle → les 3 autres se tournent vers lui
- `zigzagoon` parle → les 3 autres se tournent (il est nerveux, ils le rassurent du regard)
- `growlithe` parle → les 3 autres se tournent (il est le soldat, ils écoutent)
- `partner` conclut → retour au cercle

### Beat 1.4 — Le tremblement de terre
**Intention** : la montagne se réveille. Le danger devient physique.

| Temps | Action | Son |
|---|---|---|
| 0f | Lumière orange monte du sol | Grondement sourd |
| 10f | Écran tremble (ScreenMover 2,4) | Tremblement |
| 20f | **partner recule d'un pas** (instinct) | — |
| 24f | **hero s'avance d'un pas** (protège) | — |
| 28f | **growlithe se met en garde** (posture combat) | — |
| 32f | **zigzagoon tremble** (emote shock) | Cri de surprise |

**Réactions individuelles au tremblement** :
- `partner` : Recoil + emote "shock" + recule de 12px
- `hero` : emote "exclaim" + avance de 6px (protège le groupe)
- `growlithe` : Recoil + se met en posture défensive
- `zigzagoon` : emote "shock" + Recoil + recule de 14px

### Beat 1.5 — Les Slugma apparaissent
**Intention** : l'ennemi se révèle progressivement, créant un encerclement.

Ordre d'apparition (du plus proche au plus loin) :
1. S_B4 + S_G4 (les plus proches de l'équipe) → tout le groupe sursaute
2. S_B3 + S_G3 (flancs) → regard latéral
3. S_B2 + S_G2 (avancés) → l'équipe se resserre
4. S_B1 + S_G1 (près de Magcargo) → regard vers le nord

**Réaction de l'équipe** : le groupe se resserre instinctivement (chacun avance de 8px vers le centre).

### Beat 1.6 — La Voix parle
**Intention** : quelque chose d'ancien et de puissant s'adresse à eux.

- `partner` se tourne vers `hero` (cherche du réconfort)
- `growlithe` regarde en l'air (cherche la source)
- `zigzagoon` regarde partout (panique)
- `hero` reste immobile, écoute intensément

### Beat 1.7 — Magcargo apparaît
**Intention** : le boss se révèle dans une explosion de feu.

- Flash blanc → écran tremble → Magcargo materialisé
- **L'équipe recule de 24px** (mouvement de groupe synchronisé)
- `partner` : Recoil + emote "sweating"
- `hero` : emote "exclaim" + recule
- `growlithe` : Recoil + grogne
- `zigzagoon` : Recoil + emote "shock"

### Beat 1.8 — Combat
- Transitions vers le combat (BossTransition)
- `COMMON.BossTransition()` gère le fondu

---

## SCÈNE 2 — APRÈS LE COMBAT (DefeatedBossBody, ~4 min)

### Beat 2.1 — Magcargo vaincu
**Intention** : le boss s'effondre. L'équipe est surprise — il se soumet.

| Temps | Action | Caméra |
|---|---|---|
| 0f | Fondu d'ouverture (60f) | Fixe (264,264) |
| 60f | Image : Magcargo debout mais affaibli | — |
| 80f | Magcargo parle (douleur) | — |
| 100f | Flash noir (emphase) | — |
| 130f | **Magcargo s'effondre** (pose Special0) | — |
| 160f | **Les 8 Slugma se prosternent en cascade** | — |
| 200f | **Recadrage caméra sur l'équipe** (264,264→256,240) | Pan down |

### Beat 2.2 — L'équipe réagit
**Intention** : confusion. Ils s'attendaient à un combat, pas à une soumission.

```
Disposition : l'équipe regarde Magcargo au sol

  growlithe ── hero ── partner ── zigzagoon
       │         │        │          │
       └─────────┴────────┴──────────┘
              regardent Magcargo (nord)
```

- Tous se regardent entre eux (confusion) → emotes sweatdrop en cascade
- `partner` : "On... on ne voulait pas se battre..."
- L'équipe se tourne vers Magcargo quand il parle

### Beat 2.3 — Le monologue de Magcargo
**Intention** : Magcargo raconte son histoire. L'équipe écoute, émue.

**Caméra** : alterne entre plan large (groupe + Magcargo) et plan serré (Magcargo seul).

| Dialogue | Caméra | Réactions équipe |
|---|---|---|
| SC5_045-047 | Plan Magcargo (256,220) | — |
| SC5_048-049 | Plan groupe (264,264) | partner emote sweating |
| SC5_050-052 | Plan Magcargo | partner emote notice |
| SC5_053 | Plan groupe | partner question |
| SC5_054-061 | Plan Magcargo (long) | hero notice à SC5_056, growlithe emote à SC5_058 |
| SC5_062-063 | Plan groupe | partner worried |
| SC5_064-067 | Plan Magcargo | magcargo sweatdrop |
| SC5_068 | Plan Magcargo (se relève) | — |

### Beat 2.4 — Les Slugma disparaissent
**Intention** : le peuple de Magcargo rentre chez lui. Moment poétique.

Ordre de disparition (du plus éloigné au plus proche) :
1. S_B4 + S_G4 → l'équipe les regarde partir
2. S_B3 + S_G3 → hero tourne la tête
3. S_B2 + S_G2 → partner observe
4. S_B1 + S_G1 → dernier au revoir

**Mouvements de l'équipe pendant les disparitions** :
- `partner` regarde les Slugma partir (suit du regard chaque paire)
- `hero` observe calmement
- `growlithe` reste en alerte (habitude de soldat)
- `zigzagoon` compte les Slugma qui partent

### Beat 2.5 — Magcargo s'en va
**Intention** : le boss part dignement. Explosion de flamme (sa nature).

- Magcargo regarde à gauche, puis à droite, puis face (hésitation)
- Dit son dernier mot
- **Explosion de flamme** (Sacred_Fire_Ranger) → disparition
- **L'équipe recule** (Recoil synchronisé)
- Emotes sweatdrop en cascade (soulagement + surprise)

### Beat 2.6 — Discussion post-combat
**Intention** : le groupe débriefe. Moment de camaraderie.

```
Disposition naturelle (cercle ouvert, détendu) :

       partner ── hero      ← face à face, proches
           │       │
     zigzagoon  growlithe   ← de chaque côté, relaxés
```

- `zigzagoon` soupire (soulagement)
- `partner` remercie `growlithe` et `zigzagoon` (se tourne vers chacun)
- `growlithe` sourit (fierté modeste)
- `zigzagoon` réalise quelque chose (se tourne vers le nord)
- `partner` s'inquiète du changement dans le tunnel
- `hero` réfléchit à voix haute (pensée intérieure)
- `partner` a une idée (emote exclaim → Recoil)
- Tous se tournent vers `partner`
- `zigzagoon` et `growlithe` réagissent
- `partner` conclut : "Le Mont Venteux nous attend."

### Beat 2.7 — Départ vers le Mont
**Intention** : le groupe se met en marche. Transition cinématographique.

**Mouvements** (départ échelonné, pas simultané) :
1. `partner` se tourne vers le nord + commence à marcher (leader du moment)
2. `hero` suit à 14f (solidaire)
3. `growlithe` à 20f (soldat qui ferme la marche)
4. `zigzagoon` à 30f (dernier, regarde derrière une dernière fois)

**Transition** :
- À t=30f, la musique commence son fondu (FadeOutBGM 60f)
- À t=30f, le fondu noir commence (FadeOut 60f)
- Le fondu accompagne la marche — les personnages disparaissent progressivement
- **90f de noir pur** (respiration, ellipse temporelle)

---

## SCÈNE 3 — TRANSITION VERS LE REPAS

### Beat 3.1 — Ellipse temporelle (fondu noir)
**Intention** : le joueur comprend que le temps passe. Voyage → arrivée → installation.

| Phase | Durée | Son |
|---|---|---|
| Marche dans le noir | 30f | Silence |
| Arrivée au camp (bruitages) | 30f | Vent, pas sur la pierre |
| Installation du camp | 30f | Bois qui craque, feu qui prend |
| **Total noir** | **90f** | Ambiance progressive |

### Beat 3.2 — Le repas (silence + ambiance)
**Intention** : moment de calme et d'intimité. PAS DE MUSIQUE.

**Ambiance sonore** :
- Vent léger (LoopSE "Wind")
- Feu de camp (LoopSE "Campfire" si disponible, sinon silence)
- Légers bruits de mastication (optionnel)

**Disposition du repas** (cercle autour du feu) :
```
        hero ────── partner
         │    🔥     │
   growlithe ── zigzagoon
```

### Beat 3.3 — Transition vers la nuit
**Intention** : ellipse vers la nuit. La musique nocturne monte progressivement.

| Phase | Durée | Son |
|---|---|---|
| Fondu noir | 60f | Silence → fondu ambiance |
| Noir + étoiles | 40f | Silence |
| **Montée OST nocturne** | 60f | "Goodnight.ogg" fade in |
| Fondu d'ouverture | 40f | OST nocturne |

---

## RÈGLES DE MISE EN SCÈNE

### R1 — Distances interpersonnelles
- Alliés proches : 24-32 px
- Alliés en conversation : 32-48 px
- Inconnus/méfiance : 64+ px
- Ennemis : 96+ px

### R2 — Hiérarchie des regards
1. Le locuteur actuel (priorité absolue)
2. La menace/événement en cours
3. L'allié le plus proche (réconfort)
4. Le nord (direction du voyage)

### R3 — Vitesse de déplacement émotionnelle
- Déterminé : vitesse 1 (normal)
- Inquiet : vitesse 1 mais hésitations (WaitFrames entre pas)
- Paniqué : vitesse 2 (rapide) + Recoil
- Fatigué : vitesse 2 (lent)
- Enthousiaste : vitesse 1 + léger bond (Hop si disponible)

### R4 — Cascade de réactions
Quand un événement se produit, les réactions suivent cet ordre :
1. Le plus proche de l'événement (0f)
2. Le plus attentif (6-8f)
3. Les autres (12-16f)
4. Le distrait (20-30f)

### R5 — Composition de plan
- **Plan large** : toute l'équipe + environnement (caméra haute, 264,336)
- **Plan moyen** : équipe seule (caméra médiane, 264,264)
- **Plan serré** : un personnage + son interlocuteur (caméra basse, centrée)
- **Plan de coupe** : détail environnement (lave, Slugma, ciel)
