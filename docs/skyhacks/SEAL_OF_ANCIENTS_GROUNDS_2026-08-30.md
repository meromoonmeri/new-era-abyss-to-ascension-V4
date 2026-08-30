# Grounds exclusifs des romhacks SkyTemple — état : Seal of Ancients

Date : 2026-08-30 — mission « récupère les grounds exclusifs au romhack Sky
Temple, commence par Seal of Ancients ».

Statut global : **OUTIL LIVRÉ ET VALIDÉ — contenu Seal of Ancients BLOCKED BY
NETWORK** (voir §5, preuve à l'appui, et les 3 voies de déblocage §6).

---

## 1. Décodage de la demande (et corrections au passage)

« Sky Temple » côté communauté = l'écosystème **SkyTemple** (org GitHub
`SkyTemple`, éditeur de ROM PMD Explorers of Sky) et son **répertoire de
romhacks** `hacks.skytemple.org`. « Seal of Ancients » y est une entrée :
*Pokémon Mystery Dungeon: Seal of Ancients* (story hack terminé, juin 2023),
par « -Tainted- » et « baroness faron » (base ROM US n°4273, patch
Delta Patcher, archive hébergée sur Dropbox uniquement).

Clarifications utiles (erreurs relevées dans nos propres docs antérieurs) :

- `pret/pmd-sky` n'est **pas** le hack PMDSky : c'est la disassembly de l'EoS
  **vanilla**. Les notes du 2026-08-02 (« Sky Peak / Shaymin Village »)
  traitaient ce dépôt comme s'il contenait le hack ; en fait Sky Peak et
  Shaymin Village sont des contenus **d'EoS vanilla** (épisodes événements),
  et le verdict « conversion impossible faute d'outils » de ce doc est
  **obsolète** : le décodeur officiel existe (`skytemple-files`), il est
  installable par pip, et il marche (voir §3).
- Un romhack EoS ne définit jamais un « format de ground » à lui : il
  réutilise le mécanisme vanilla (`MAP_BG` + scripts `GROUND/`). Un ground
  « exclusif » est donc = un ground **modifié** ou une entrée **ajoutée**.
  Les « MAPPA/GROUND .wan » du doc de 2026-08-02 sont des sprites d'objets
  animés du mode ground, pas des cartes.

## 2. Le sol « ground » EoS, format exact (vérifié dans le décodeur)

- `MAP_BG/bg_list.dat` : 443 entrées. Noms par banque : `G` (grounds du mode
  town — 23 entrées), `D`/`V` (donjons/visuels), `S` (scènes fixes), `H`
  (intérieur), `P`/`W`/`T` (annexes). Un hack qui veut une nouvelle map
  « White Garden » either réutilise/reteinte une entrée `G`, either déclare une
  entrée `S`/`P`/`Gxx` de son cru — le retriever attrape les deux cas.
- Chaque ground = `.bma` (dims tuiles 8 px, calques, **collision**, NRL),
  `.bpc` (chunks 3×3 tuiles, 24 px), `.bpl` (jusqu'à 16 sous-palettes +
  animation de palette), `.bpa` (tuiles animées, 8 slots max).
- Variantes « 2 » (ex. `G01P01A2`) = même `.bpc` que la base, `.bpl` différent
  (palettes alternatives). Jour `A` / crépuscule `B` / nuit `C`.
- Collisions = bit par tuile de 8 px, lu directement dans le `.bma`.

## 3. Ce qui est livré et exécuté (PASS, pas d'à-peu-près)

`tools/skyhacks/ground_retriever.py` — extracteur/rendeur/classifieur, modes :
dossier pret-style (`--files`), ROM (`--nds`), patch IPS + ROM propre
(`--ips --base-nds`, patchage en pur Python). Sorties : `manifest.json`
(dims, sha1 par fichier source, empreinte globale), rendu `frame0.png` +
`anim.gif`, `collision.png`, statut par ground vs baseline vanilla
(`same_as_vanilla` / `MODIFIED` / `NEW_GROUND`), `orphan_bma_on_disk`
(grounds posés dans MAP_BG sans entrée de bg_list — signature typique d'un
hack).

Exécutions réelles dans la sandbox (venv pip `skytemple-files` 1.8.5) :

| test | résultat |
|---|---|
| extraction des 23 grounds vanilla depuis `pret/pmd-sky` | **PASS** — 23/23 rendus, 0 erreur |
| hack synthétique : 1 byte de `g01p01a.bpl` retourné | **PASS** — `G01P01A → MODIFIED` |
| hack synthétique : `G99P01A` copié + enregistré dans `bg_list.dat` | **PASS** — `NEW_GROUND` + rendu complet ; 22 autres `same_as_vanilla` |
| `test_romprovider.py` (mode ROM via provider ndspy factice) | **PASS** — sha1 identiques au mode dossier |
| lecture d'un vrai `.nds` par ndspy | CODE CONFIRMED seulement (aucun dump dans la sandbox — §5) |

Catalogue vanilla versionné : `docs/skyhacks/eos_grounds/`
(manifest + 23 renders + 23 collision + gifs) et
`docs/skyhacks/eos_grounds_contact_sheet.png`. Identification visuelle
certaine : `G01P01*` = **Treasure Town** (statue Cherrim géante + entrée de la
grotte), avec variantes jour/crépuscule/nuit × palettes « 2 » ; les autres
entrées `G01P0x` sont cataloguées par code (les noms communautaires seront
fixés quand les scripts `GROUND` seront audités — pas d'étiquette inventée).

## 4. « Grounds exclusifs » d'un hack : définition opérationnelle

Pour Seal of Ancients (et n'importe quel hack du répertoire) :
exclusif = tout ground dont le statut sort `MODIFIED`/`NEW_GROUND` contre le
baseline vanilla, **plus** tout ground `S/H/P` ajouté à `bg_list.dat`
(le pattern `--ground-pattern` est configurable, ex. `^(G|S|H|P)` pour tout
voir). C'est mécanique et auditable (sha1), pas un jugement de goût.

## 5. Seal of Ancients : le blocage, prouvé

- Seule source du payload : `www.dropbox.com/…/PMD-Seal-of-Ancients.rar`
  (page du répertoire + fil PokéCommunity vérifiées le 2026-08-30) ;
  l'API `hacks.skytemple.org/api/hack/{nom}` renvoie 404 pour cette entrée.
- Réseau de la sandbox = allowlist : `github.com`/`api.github.com` → 200,
  `pypi.org` → 200 ; `dropbox.com`, `dl.dropboxusercontent.com`,
  `drive.google.com`, `archive.org`, `hacks.skytemple.org`,
  `sprites.pmdcollab.org`, `raw.githubusercontent.com` → **code 000**
  (connexions refusées). Les assets GitHub des releases
  (`objects.githubusercontent.com`) sont aussi bloqués ; `codeload` passe.
- Miroirs GitHub : recherche exhaustive (repos + code + noms de fichiers) →
  **0**. Le hack n'a aucun dépôt (contrairement à des hacks de jams qui
  publient leurs patchs, ex. `tech-ticks/strung-up-by-patches`).
- Extraire le `.rar` ici même échoue aussi : `unrar-cffi` ne build pas (pas de
  librar), pas d'`unrar`/`7z`/`bsdtar` système, apt mort.

Verdict honnête : les données du ground Seal of Ancients **existent** (c'est
du MAP_BG vanilla retouché + très probablement des cartes `S` de cinématiques
« White Garden »), le pipeline pour les extraire **marche**, mais l'archive
n'est pas téléchargeable depuis cet environnement.

## 6. Déblocage — trois voies, choisir une

1. **Fichier joint à la session** : vous téléchargez le `.rar`, vous en
   extrayez le contenu chez vous ; si c'est un `.ips` seul, il me faut aussi
   une ROM EoS US propre (`4273 - Pokemon Mystery Dungeon - Explorers of
   Sky (USA).nds`, sha1 `5fa96ca8d8dd6405d6cd2bad73ed68bc73a9d152`) — sinon
   envoyez directement le `.nds` patché si votre outil de chat accepte la
   taille. Je lance alors `--ips`/`--nds` et je rends catalogue + classification.
2. **Vous exécutez chez vous** (recommandé, ~2 min) :
   ```bash
   git clone -b arena/01a02f1c-new-era-abyss-to-ascension-v4 \
     https://github.com/meromoonmeri/new-era-abyss-to-ascension-V4 newera
   python3 -m venv newera/venv && newera/venv/bin/pip install skytemple-files pillow ndspy
   newera/venv/bin/python newera/tools/skyhacks/ground_retriever.py \
     --nds Chemin/Vers/SealOfAncients_patched.nds --out out_soa \
     --baseline-manifest newera/docs/skyhacks/eos_grounds/manifest.json
   ```
   `out_soa/` = quelques Mo : vous me les joignez (ou poussez sur le dépôt),
   j'intègre le catalogue exclusif + les rendus définitifs.
3. **Via l'éditeur SkyTemple** : vous ouvrez la ROM patchée dans SkyTemple,
   vous exportez le dossier `files/` (mode décompilation), vous zippez
   `MAP_BG`+`GROUND`+`BALANCE` ; `--files` fait le reste.

## 7. Suite logique (après §6, non commencé volontairement)

Import des grounds exclusifs identifiés vers PMDO : atlas `.tile` par hash de
contenu (règle apprise sur Metano : jamais par TexLoc), grammaire propre à
SoA, collisions 8 px natives du `.bma` = terrain déjà compatible. Ce sera une
tâche dédiée — pas de copinage avec le vocabulaire Metano, les deux univers
n'ont aucun atlas en commun (démontré sur Metano/Luluby : `shared_sheets = 0`).
