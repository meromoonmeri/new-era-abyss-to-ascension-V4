# tools/skyhacks — récupération des grounds EoS/SkyTemple

Outils pour extraire, rendre et **classer** les cartes « ground » (overworld)
des ROMs Pokémon Mystery Dungeon : Explorers of Sky — vanilla ou patchées par
un romhack du répertoire SkyTemple (hacks.skytemple.org).

## Principe

Un ground EoS = une entrée de `MAP_BG/bg_list.dat` (nom `G01P01A`…) pointant
sur 4 fichiers : `.bma` (agencement + collision), `.bpc` (chunks), `.bpl`
(palettes ± animation), `.bpa` (tuiles animées). Le rendu pixel exact vient
de `skytemple-files` (`Bma.to_pil`), **sans réinvention de pixels**.

Un ground est **exclusif d'un hack** quand son empreinte sha1 des fichiers
sources diffère du vanilla (`MODIFIED`) ou quand le hack enregistre une entrée
inconnue du vanilla (`NEW_GROUND`). C'est le seul moyen honnête de le savoir :
un hack ne livre presque jamais de « map nouvelle », il *modifie* les grounds.

## Fichiers

| fichier | rôle |
|---|---|
| `ground_retriever.py` | le pipeline : modes `--files` (dossier pret-style), `--nds` (ROM propre ou patchée), `--ips` (+ `--base-nds`), baseline vanilla, classification, renders PNG/GIF, collision PNG, manifest.json |
| `test_romprovider.py` | test de non-régression : le mode ROM doit produire les mêmes sha1 que le mode dossier |

## Installation (sandbox ou PC local)

```bash
python3 -m venv venv && venv/bin/pip install skytemple-files pillow ndspy
```

## Utilisation

```bash
# 1. baseline vanilla (dossier pret-style = clone de pret/pmd-sky,
#    merge de files/* + files/language-specific/US/*)
venv/bin/python ground_retriever.py --files merged_US --out out_vanilla --baseline

# 2. grounds d'un hack patché, classés contre le baseline
venv/bin/python ground_retriever.py --nds seal_of_ancients.nds --out out_hack \
    --baseline-manifest out_vanilla/manifest.json

# 3. si on n'a que le .ips du hack + une ROM US propre :
venv/bin/python ground_retriever.py --ips patch.ips --base-nds eos.us.nds \
    --out-hack-nds /tmp/patched.nds --out out_hack \
    --baseline-manifest out_vanilla/manifest.json
```

Sorties : `manifest.json` (empreintes, dims, collision, statut
`same_as_vanilla|MODIFIED|NEW_GROUND`), `renders/<code>_frame0.png`,
`renders/<code>_anim.gif`, `collision/<code>_collision.png` (1 px = 1 tuile
de 8 px ; blanc = solide).

Le baseline vanilla prêt à l'emploi est versionné dans le dépôt :
`docs/skyhacks/eos_grounds/manifest.json`.

## État de validation (2026-08-30)

- PASS (exécuté) : extraction complète des 23 grounds vanilla EoS depuis
  `pret/pmd-sky` (rendus + collision + GIF d'animation).
- PASS (exécuté) : détection sur hack synthétique — 1 byte modifié dans
  `g01p01a.bpl` → `MODIFIED` ; ground `G99P01A` ajouté + enregistré dans
  `bg_list.dat` → `NEW_GROUND` ; les 22 autres → `same_as_vanilla`.
- PASS (exécuté) : `test_romprovider.py` — mode ROM (faux provider ndspy)
  identique au mode dossier, hash par hash.
- CODE CONFIRMED seulement : `ndspy.fromFile` sur un vrai .nds (aucun dump
  n'est présent dans la sandbox ; le chemin est le même code que le mode
  dossier une fois le fichier lu).

## Limite réseau connue de la sandbox

Seuls `github.com`/`api.github.com`/`pypi.org` sortent. Dropbox, Drive,
archive.org, hacks.skytemple.org : joignables par le navigateur de l'humain,
injoignables ici (`curl` → code 000). Les archives des romhacks du
répertoire (dont Seal of Ancients) ne sont hébergées qu'ailleurs que GitHub →
la ROM patchée doit arriver par l'utilisateur (fichier joint) ou le script
doit tourner chez lui.
