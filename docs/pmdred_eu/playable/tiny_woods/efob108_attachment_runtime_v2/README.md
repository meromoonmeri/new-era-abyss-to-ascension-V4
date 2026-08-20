# Chenipan / efob108 — attachement natif PMDO

Statut : **PASS** (`2026-08-15`). Cette archive certifie dans PMDO 0.8.12 la
commande EU `0x56(62,0)` de `s_gs179_g1_s0_lives2_dlg0` et son attente `0xDE`.

La fixture compare les deux conventions spatiales possibles avec Chenipan
orienté vers le Sud et son action `Walk` non bouclée :

- position littérale `(180,148)` → point `Head` terminal `(187,161)` ;
- conversion centre EU vers top-left PMDO `(-8,-8)`, donc `(172,140)` → point
  `Head` terminal `(179,153)`.

Avec `Emote.LocHeight=4`, la seconde convention place le centre de l'effet à
`(179,149)`, exactement sur l'attachement AX authentifié. L'asset privé
`PMDRed_Efob108.dir` contient 13 frames 128×128, deux ticks chacune et un seul
cycle. Les 26 sélections natives sont `0,0,…,12,12`; `Finished=false` à la
frame 25 et `true` à la frontière 26. L'action
`IdleAnimGroundAction(Walk, loop=false)` est échantillonnée à sa frame terminale
puis à `Complete=true` avant la transition idle.

Le processus termine par `LoadPhase.Unload`, `NORMAL_EXIT`, rc 0,
`terminal/graceful=true`, sans watchdog, signal, SIGSEGV, kill forcé ni
orphelin. Rapport : `native_attachment_validation.json`.

La v1 voisine reste conservée comme diagnostic : son runtime était PASS mais le
premier wrapper comptait 45 événements au lieu des 44 réellement spécifiés.
Aucun gate natif ou sémantique n'a été affaibli dans cette v2.

Reproduction create-only :

```bash
bash docs/pmdred_eu/playable/tiny_woods/efob108_attachment_runtime_v2/commands.sh
```
