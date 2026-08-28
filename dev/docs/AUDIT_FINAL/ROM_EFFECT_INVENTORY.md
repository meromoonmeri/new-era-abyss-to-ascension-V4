# ROM — ANALYSE DES EFFETS (VFX / ANIMATIONS / PARTICULES / ENVIRONNEMENT)

État consolidé des audits déjà PROUVÉS (sessions précédentes, preuves dans dev/docs/canonical/) + périmètre restant.

## 1. GBA (Red) — audité exhaustivement : 246/246 PASS
Réf. `RED_GBA_GROUND_AUDIT.json` + `audit_red_grounds_vs_gba.py` :
- Animations de tiles (BPL cyclage de palettes + BPA cellules animées) : canaux d'animation EFFECTIFS vérifiés par carte (bits des chunks + frames variantes) — cas limites documentés (a05p02 frames identiques ; d14p01/d15p01 palettes 7/8 non référencées = statiques canoniques).
- Palette-6 « arc-en-ciel » (cyclage OAM Mt Blaze) : pixels brûlés corrigés, 0 hors-gamme ; les verts/magentas d'autres grounds vérifiés CANONIQUES (présents dans le BPL ROM) — non « corrigés » (règle anti-« à l'œil »).
- 27 grounds direct-GBA : descripteurs CANM (cells/records/states) + adaptateurs Lua `RedDirectGroundAnimation` — 16 744 états TexLoc, 0 hors index ; runtime 3/3 PASS.
- Colorimétrie/textures : audit par ground, artefacts hors-palette-ROM = 0.

## 2. NDS (Sky) — couvert par pipeline + audits partiels
- Tilesets/animations d'eau : BMA/BPC/BPL + BPA (cellules animées) — diff 6.8 % t01p02a expliqué par BPA absent du render de référence, pas de perte projet.
- Statues Kangaskhan (objets SSA) : 57 extraites, 30 posées, échelle 1:1 prouvée.
- Musiques : 2775 références / 0 manquante (MUSIC_MID_MAP.json).
- Météo par étage : champ mappa_s `weather` par étage — données présentes dans nos tables ; branchement par MapStatus à vérifier zone/zone (voir checklist finale).

## 3. Effets de combat / statuts / particules — position architecturale
- PMDO possède le système COMPLET (skills/intrinsics/statuts avec VFX, sons, overlays définis en data). Règle §79/« natif avant custom » : les effets d'attaque/statut utilisent les données PMDO natives, PAS des ré-extractions WAN de la ROM (double système interdit par la directive ROM BRIDGE §« un seul renderer »).
- Écart canonique admis et documenté : les VFX d'attaques sont ceux de PMDO (fidèles à la famille PMD), non bit-exact ROM. Statut : PORTED_APPROXIMATED, justification : directive « AUCUN DEUXIÈME JEU DERRIÈRE L'ÉCRAN ».

## 4. Effets d'environnement de donjon (périmètre du présent audit donjons)
| Effet ROM | Source | Statut projet |
|---|---|---|
| Météo (pluie/neige/soleil/brouillard/grêle) | mappa_s weather/étage | MapStatus natifs PMDO ; couverture data à recontrôler par étage |
| Darkness (niveau 1/2/4) | mappa_s darkness_level | TileSight/CharSight MapDataStep ✔ |
| Pièges (25 types Sky) | mappa traps/étage | EffectTile natifs ✔ (178 z.) ; distribution à valider statistiquement |
| Tuiles Wonder (Sky) | mappa | partiel (à inventorier au moment du branchement hidden stairs) |
| Écrans de transition d'étage | moteur | natifs RogueEssence ✔ |
| Boss cinématiques | scripts ROM | 36 arènes + cinématiques auditées (CUTSCENE_AUDIT) ✔ |

## 5. Reste à faire tracé (aucune suppression silencieuse)
1. Contrôle statistique météo/étage vs mappa_s (dans les 100 générations §36).
2. Inventaire des tuiles Wonder Sky au moment de R11 (hidden stairs).
3. VFX d'attaques : maintien du statut PORTED_APPROXIMATED documenté (pas d'action).
