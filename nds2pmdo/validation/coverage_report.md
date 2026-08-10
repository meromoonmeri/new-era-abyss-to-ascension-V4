# Rapport de couverture — nds2pmdo (Phase 1 : reconstruction de la source)

Convertisseur : nds2pmdo v0.1.0
Source : ROM APHP (`2540966e…14b05`) — seule référence : https://github.com/meromoonmeri/POKEMON-ROM
Portée : Sinister Woods (pilote) + inventaires globaux de la ROM

## Décodé et validé (SOURCE_NDS)
- floor_id
- FloorProperties
- spawns
- AT4PX
- SIR0
- cel (tile/palette)
- pal (192 couleurs)
- SDAT noms SEQ/ME/SE
- inventaires packs

## Partiel (octets SOURCE_NDS, sémantique incomplète)
- items (poids)
- pièges (poids)
- canm (forme)
- ground packages B10P01
- messages
- records INFO/FAT SDAT

## Non décodé (UNKNOWN — jamais inventé)
- IDs items par catégorie
- mapping bgMusic→SEQ (code ARM9)
- sémantique canm
- flags cel
- scripts ground B10P01
- table de noms espèces ROM
- SSEQ + boucles

## Conversion PMDO
- **BLOQUÉE — audit OVERALL = PARTIAL/UNKNOWN (gates stricts)**

Détails par catégorie : `validation/coverage_report.json` et `validation/audit_report.json`.