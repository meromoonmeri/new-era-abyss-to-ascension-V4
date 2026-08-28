# AUDIT SPÉCIFIQUE — GROUND NINETALES (§27)

Ninetales (PMD Red, arc Fugitif) apparaît canoniquement au **sommet du Mont Gel** : ground GBA **d11p03** (Mt. Freeze summit pass, cinématique « vérité de la malédiction »).

## Vérifications ROM → PMDO (sources : audits prouvés + fichiers)
| Critère | Résultat | Preuve |
|---|---|---|
| Textures/tileset | PASS | RED_GBA_GROUND_AUDIT.json d11p03 : dims ROM 63×63 = PMDO 63×63, artifact_cells 0 |
| Animations BPA/palettes | PASS (aucune canonique : rom_bpa=[], pal_anims_effective={} — le sommet du Mont Gel est STATIQUE dans la ROM, contre-épreuve par bits de chunks) | idem |
| Colorimétrie | PASS — palette 100 % ROM ; les teintes vertes contrôlées en session antérieure sont CANONIQUES (présentes dans le BPL ROM, correction annulée par git checkout, documenté GROUND_TEXTURE_PALETTE6_AUDIT) | audit palette |
| Collision/walkability | PASS | validé par pilote runtime (PILOT d11p03 = mt_freeze idx 2 : LOAD+MOVEMENT_PASS, dev/docs/canonical/red) |
| Scripts/cinématique | PASS | redscenes/d11p03__station.lua (6 réf. Ninetales) + FugitiveCinematics.lua l.400+ : apparition, BossFX.RadiantDawn (VFX), dialogues, orientation Direction.Down |
| VFX d'événement | PASS (BossFX.RadiantDawn au spawn de Ninetales — équivalent natif du flash d'apparition ROM) | FugitiveCinematics.lua l.401 |
| Position acteur | PASS — coordonnées fixes (252,168) posées dans le système de coordonnées ROM 1:1 (règle « positions ROM canoniques ») | script |
| Musique | PASS — musiques du Mont Gel auditées dans la passe 2775 réfs/0 manquante | MUSIC audit |
| Caméra | PASS — caméra moteur unique, CANONICAL_VIEW_PASS (viewport adapté, monde intact) | CANONICAL_VIEWPORT_TEST.json |
| Runtime bout-en-bout | PASS — redjourney traverse Mt Freeze (CH boss Glalie en aval), preuve global_journey_runtime_proof.jsonl | red journeys |

## Verdict : **PASS** (aucune texture/animation/BCA/VFX/particule/script canonique manquant identifié ; l'absence d'animation de tiles sur d11p03 est PROUVÉE côté ROM, pas supposée).

Détail machine : `ninetales_ground_audit.json`.
