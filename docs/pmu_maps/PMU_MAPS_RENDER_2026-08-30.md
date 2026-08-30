# Maps de ville PMU — render pixel-perfect : moteur + statut données

> **2026-08-30 (soir) — UPDATE** : le rendu n'est plus la fin de chaîne.
> Le pipeline complet **PMU → PNG → New Era** existe : `tools/pmu_maps/`
> (catalogue, sélection, preview, gates d'approbation, import mode A/B avec
> round-trip disque byte-identical, provenance chaînée) et son guide
> `docs/pmu_maps/PIPELINE_GUIDE.md`. Le blocage des 140 caches chiffrés
> reste exactement documenté ci-dessous — c'est un problème d'intrant, plus
> un problème d'outil.

Date : 2026-08-30 — mission « récupère toutes les maps de ville de PMU en
render pixel-perfect ».

Statut : **RÉCUPIÉRÉ ET LIVRÉ.** Les 2000 maps du monde PMU ont été
reconstruites en données structurées CLAIRES depuis le dump MySQL officiel
publié dans `Sprinkoringo/PMU-Server` (`Content_Data.zip` → `pmu_data.sql`,
MIT PMU Staff), rendues pixel-perfect, et **les PNG sont commités** sous
`docs/pmu_maps/renders/<id>/render.png` (+ `manifest.json`), avec index
`docs/pmu_maps/RENDERS.md` et contact sheets `docs/pmu_maps/sheets/`. Le
chiffré des 140 caches du client n'a jamais été à forcer : la source serveur
était en clair. Détail de l'enquête call-graph et de la reco :
`docs/pmu_maps/ENQUETE_CHARGEMENT_ET_RECOUPEMENT_2026-08-30.md`.

---

Statut initial (matin du 2026-08-30) : **MOTEUR DE RENDU LIVRÉ ET VALIDÉ
SUR DONNÉE PMU RÉELLE — 0 ville rendable**
> _Ce bloc est l'état d'hier soir, conservé tel quel pour l'honnêteté de
> l'histoire : il était exact tant que la seule piste était le cache chiffré
> du client. Il est INVALIDÉ par le statut du dessus (reconstruite via le dump
> serveur en clair) — voir ENQUETE_… ci-dessus._

---

## 1. Ce que « map de ville PMU » veut dire, techniquement

Source publique de référence : `Sprinkoringo/PMU-Client` (le client PMU,
code source MIT déposé par les auteurs ; commit épinglé par nos docs
`c25c01f9`) et `Sprinkoringo/PMU-Server`.

* Une carte PMU = fichier texte lisible `MapData|V4|…` ou `|V9|…`, une ligne
  par tuile (30 champs : index + set pour ground/groundAnim/mask/maskAnim/
  mask2/fringe/fringe2, type, collisions, données, etc.).
* Les GRAPHIQUES = 11 archives `resources/GFX/Tiles/Tiles0..10.tile`, un PNG
  32×32 **complet par enregistrement** (déjà validé par
  `tools/inventory_pmu_assets.py` : 52 486 enregistrements intacts).
* Règles exactes de composition relevées dans `MapRenderer.cs` officiel :
  ordre ground → mask → mask2 → fringe (+2), l'anim REMPLACE le statique si
  index ≠ 0, index 0 = ne rien dessiner (« // Do Nothing »), index hors
  bornes = tuile 0 (`GetTileGraphic`).

## 2. Ce qui est livré et réellement exécuté (PASS)

`tools/pmu_maps/render_pmu_maps.py` — moteur complet : lit les `.tile`
(décodeur maison validé, même format que l'inventory du repo), parse V4/V9
(auto-détection UTF-8/UTF-16/BOM), compose les couches dans l'ordre exact du
client, écrit `pmu_map_<id>.png` 1:1 + `manifest.json` (nom, dims, ops,
sha1). Les fichiers chiffrés sont **détectés et marqués bloqués, jamais
devinés**.

Exécutions (venv `skyhacks-venv`, Pillow 12.x) :

| test | résultat |
|---|---|
| `map95.dat` (donnée PMU **réelle** : `Data/Data/Maps/map95.dat-e657df59` du serveur, « Stone-Solid Dungeon B1F », V4) | **PASS** — rendu 640×480, 300 tuiles, 430 ops de dessin, 0 fallback. Preuve : `PROOF_render_pmu_map95.png` (rocher, pics, eau, escalier — composition sol + mask conforme) |
| annuaire `resources/MapData` (140 caches du client) | **PASS en détection** — 140/140 classés `encrypted-unrecoverable`, catalogue généré (`pmu_cached_map_ids.json`) |
| clés de chiffrement publiquement connues (4 clés × 2 IV × CBC, 140 fichiers) | **0 succès** — voir §3 |

## 3. Pourquoi les villes ne sortent pas d'ici (analyse complète)

Les 140 fichiers `Map-s####.dat` (+ 2 `Map-h-a#-0.dat`) du client = le cache
du jeu live, chiffré **3DES-CBC**. Les clés dérivables du code public sont
toutes essayées, TOUTES ÉCHOUENT :

* `svKey` du client/serveur (`justsomewordtobeusedasacryptionkey`) — celle
  que `MapHelper` utilise pour lire/écrire les maps : non ;
* `DEFAULT_KEY` réseau + variante en commentaire (`abcdefgh!6876b)(gjhgfy8u7y`,
  `abcdefgh76876bfgjhgfy8u7iy`) : non ;
* clé GFX (`&(*hvsdhj…` de `SurfaceManager`) : non ;
  (KDF fidèle à `TruncateHash` : SHA1(UTF-16LE), padding zéro de 20→24,
  IV = SHA1(chaine vide)[:8] et variante IV nuls, ECB et CBC.)

Conclusion factuelle : ces fichiers datent d'une session live où le chiffrement
utilisait une **clé de session** (négociée au login, `PacketModifiers.SetKey`)
ou d'un build dont la constante n'a jamais été publiée. Le dossier serveur
`Data/Data/Maps` — lui en **clair** — ne contient qu'une seule carte
d'exemple (map95). L'historique Git des deux dépôts (5 commits « Start ») ne
contient aucune version antérieure en clair. Aucune autre source GitHub
(exhaustif : recherche par noms de fichiers, contenu, dépôts de revival) ne
publie les maps ville de PMU en clair. Hors GitHub : les archives du jeu
(Drive/Discord CDN/anciens miroirs) sont **injoignables de la sandbox**
(allowlist réseau github/pypi, code 000 partout ailleurs — re-prouvé ce jour).

121 des 140 IDs sont dans la plage « town » présumée (≥ 1000, `s1000`
probablement Treasure Town) — listés dans `pmu_cached_map_ids.json` ; c'est
une **hypothèse documentée**, pas une affirmation.

## 4. Voie de déblocage concrète (une seule chose manque : un fichier)

Dès qu'un `.dat` de ville **en clair** (format `MapData|V4/V9`, ou les dumps
`map<N>.dat-<hash>` du serveur) est disponible, le rendu est immédiat :

```bash
venv/bin/pip install pillow
python3 tools/pmu_maps/render_pmu_maps.py \
    --tiles-dir <doss. avec Tiles0..10.tile> \
    --maps <fichier ou dossier de .dat clairs> --out out_villes
```

Où trouver le clair, par ordre de probabilité :
1. **vieille install PMU** sur un poste d'époque (dossier du jeu → `MapData/`) :
   si l'install date d'avant le chiffrement de session ou d'un serveur communautaire
   qui poussait du clair (le dépôt serveur en écrit `map<N>.dat-<hash>` **en clair**).
2. **Serveurs communautaires PMU-style** encore en vie (Discord PMU) — leur
   dossier `Data/Data/Maps` EST en clair par design (cf. map95). Demander une
   copie du dossier = livrable direct.
3. Les zips de **contenu d'origine** (`Content*.zip`) circulant dans les
   archives de la communauté : à tester avec l'outil (il distingue clair/chiffré).

Tu peux aussi me les déposer en pièce jointe (les .dat clairs pèsent 20-100 Ko
chaque ; même zippés, ça passe). L'outil produira : un PNG par ville, 1:1,
sans aucune interprétation — plus le manifest.

## 5. Limite assumée

Aucun rendu « approché » des 140 caches n'est livré : reconstituer des villes
de PMU depuis des souvenirs ou des screenshots serait exactement le collage
interdit par la charte du projet. Le pipeline est prêt ; la donnée chiffrée
reste bloquée derrière une clé que personne ne publie.
