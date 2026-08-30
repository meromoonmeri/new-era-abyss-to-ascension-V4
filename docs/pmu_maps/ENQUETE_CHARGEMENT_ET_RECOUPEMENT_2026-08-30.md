# Enquête : chemin de chargement du client PMU, et comment les maps ville ont ÉTÉ récupérées

Date : 2026-08-30. Réponse aux 8 questions posées, puis le résultat :
**2000 maps du monde PMU reconstruites en données structurées claires, rendues
et commitées** (`docs/pmu_maps/renders/` + `RENDERS.md`).

## 1. Call graph exact du chargement d'une map (client officiel, dépôt `Sprinkoringo/PMU-Client`, source MIT « PMU Staff »)

```
Loader.cs:245            Globals.Encryption = new Encryption()      ← svKey par défaut
Paths.cs:129             mapPath = <jeu>/MapData/
MapHelper.cs:71          LoadMap: Globals.Encryption.DecryptBytes(File.ReadAllBytes(...))
MapHelper.cs (parser)    StringReader → "MapData|V9|rev|maxX|maxY" / "Data|…" /
                         "NpcSettings|…" / "Tile|x|y|…30 champs…"
                         (Map/Tile objets en mémoire = DONNÉES CLAIRES)
GraphicsManager/Tiles[sheet].GetTileGraphic(idx)                      ← planches .tile
MapRenderer.cs:DrawGroundTilesSeamless                               ← Ground→(anim)→
                         Mask→(anim)→Mask2→(2), index 0 = « Do Nothing », hors
                         bornes = GetTileGraphic(0)
SurfaceManager.cs:199/213  planches GFX lues avec gfxEncryptionKey   ← autre clé, archives .tile
```

## 2. Chemin exact du déchiffrement des caches

- `Encryption.cs` : 3DES-CBC PKCS7 ; clé = SHA1(UTF-16LE(constante)) tronquée/padding
  zéros à 24 ; IV = SHA1(vide)[:8]. Constante : `svKey =
  "justsomewordtobeusedasacryptionkey"`.
- Réseau (`PacketModifiers.cs:44-64`) : DEFAULT_KEY `abcdefgh!6876b)(gjhgfy8u7y`
  (+ variante en commentaire), remplaçable par la clé envoyée par le serveur.

## 3. Origine exacte de la clé

- Côté client : constante de code (ci-dessus), `Loader` ne la remplace JAMAIS.
- Côté réseau : le serveur envoie un paquet `cryptkey` (`MessageProcessor.cs:49`) ;
  le serveur du dépôt envoie `"----" + Rand(1,20000)` (`Client.cs:254`) — et le
  client TRAITE LE PRÉFIXE `----` COMME « chiffrement désactivé ». **La production
  de cette base serveur échangeait donc les maps EN CLAIR.**
- Les 140 `Map-s####.dat` du dépôt client ne se déchiffrent avec AUCUNE clé publiée
  (4 clés × IV × CBC/ECB, 140/140 ratés — documenté avant) : ce sont des caches
  d'une session live avec une clé d'époque non publiée. **Ce n'était PAS la bonne
  porte d'entrée — et ce n'est plus nécessaire du tout.**

## 4. Le client officiel peut-il charger les villes depuis ses caches ?

Avec la clé de CE dépôt : non (vérifié). Mais la question est devenue sans objet :
les mêmes maps existent en clair à la source serveur (voir §6).

## 5. Une étape réseau est-elle nécessaire ?

Non. Historiquement oui (le serveur servait les maps au login, en clair), mais
le DUMP de la base de production est publié dans le dépôt.

## 6. Ce que PMU-Server possède réellement — LA trouvaille

`Sprinkoringo/PMU-Server` (« The server data for Pokemon Mystery Universe »,
46 Mo, MIT) contient **`Content_Data.zip` (51 Mo)** qui contient
**`pmu_data.sql` — dump MySQL officiel du 2014-07-04 (1,15 Go)**, tables :

| table | rôle |
|---|---|
| `map_general` | MapID, Revision, MaxX, MaxY |
| `map_data` | Nom, Moral, Musique, Indoors, Weather, Darkness, spawn npcs… |
| `map_standard_data` | MapID, Instanced — ~2000 maps « s » du monde |
| `map_tiles` | PAR TUILE : X,Y, Ground, GroundAnim, Mask, MaskAnim, Mask2, Mask2Anim, Fringe, FringeAnim, Fringe2, Fringe2Anim, Type, Data1-3, String1-3, Light, et les 10 Tilesets — 2 131 267 lignes |
| `map_npcs` | slots PNJ (NpcNum, SpawnX/Y, niveaux, taux) |
| `map_switchovers` | Up/Down/Left/Right (voisins) |
| `map_house_data`, `map_instanced_data`, `map_rdungeon_data` | maisons joueur / instanciées / R-Dungeons (hors périmètre « ville ») |

C'est la source serveur autoritaire : chaque tuile, chaque couche, chaque type
de sol, chaque warp brut, sans décodage, sans dédup hasardeuse, sans pixels
inventés.

## 7. PMD-Toolkit

Contient des loaders de maps (`PMDToolkit/Maps/*`, Editors/MapEditor) et des
`Tiles0..10.png`, mais AUCUNE donnée de map du monde ; pas de logique de clé
supplémentaire. Aucun apport au déblocage.

## 8. Ce qui manquait réellement, et ce qui manque encore

- Manquant hier : rien d'technique — il manquait juste l'idée que le serveur
  publie sa base. Le dump SQL la fournit.
- Fait aujourd'hui : `tools/pmu_maps/sql_maps_extract.py` rejoue les tables
  `map_*` vers des fichiers **`Map-<id>.dat` au format texte exact du client**
  (`MapData|V9|rev|maxX|maxY` + `Data|…` + `NpcSettings|…` + `Tile|x|y|…|`).
  2000 maps monde extraites (2 131 267 lignes utiles), rendues par le renderer
  fidèle (`render_pmu_maps`, passe `MapRenderer.cs`), exportées avec manifest
  dans `docs/pmu_maps/renders/<id>/` + contact sheets des 2000 dans
  `docs/pmu_maps/sheets/` + index `docs/pmu_maps/RENDERS.md`.
- Toujours hors périmètre (volontaire, récupérables pareil si demandé) :
  maisons de joueurs (`map_house_data`, ~4500 IDs « h- »), instances de
  missions (`map_instanced_data`), R-Dungeons génératifs. Les caches chiffrés
  du client restent non déchiffrés — inutiles désormais.

## Provenance et vérifiabilité

- Source : `github.com/Sprinkoringo/PMU-Server`@master, `Content_Data.zip`
  (51 512 308 o) → `pmu_data.sql` (1 155 666 067 o, mysql dump 2014-07-04).
- Extraction : SHA du `.dat` reconstruit, dims, comptes de couches, fallbacks
  (0 sur les 2000 maps monde — aucun index invalide dans la base), et
  déterminisme 2 passes : TOUT est dans chaque `manifest.json` commité.
- Le PNG n'est QUE l'aperçu : les données structurées (tuiles, types, Data1-3,
  PNJ, voisins) voyagent à côté (semantics + manifest), prêtes pour
  `pmu_pipeline import --mode A` (round-trip disque byte-identical, cf.
  `PIPELINE_GUIDE.md`).
- Aucun contournement de chiffrement n'a été pratiqué ni nécessaire : la voie
  utilisée est la publication officielle MIT du staff du serveur.

## Suite immédiate

La map sélectionnable n°1 était « le » point dur — elle est tombée : toute map
de `RENDERS.md` peut être passée par
`pmu_pipeline render/preview/validate/approve/import --mode A` pour générer son
`.rsground` New Era + `.tile` + `init.lua` avec la sémantique complète.
