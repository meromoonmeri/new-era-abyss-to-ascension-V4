# Spécification des formats NDS (Blue Rescue Team Europe — APHP)

Toutes les structures ci-dessous ont été **validées par lecture directe de la ROM**
(`sha256 2540966e…`). Les noms de champs issus de la décompilation pmd-red sont
marqués `CROSS_REFERENCE` ; rien ici n'est supposé.

## 1. En-tête NDS (spécifique « POKE DUNGEON »)

La ROM APHP n'utilise pas le logo Nintendo standard dans son en-tête :

| Offset | Taille | Champ | Valeur APHP |
|---|---|---|---|
| 0x00 | 12 | Titre | `POKE DUNGEON` |
| 0x0C | 4 | Gamecode | `APHP` |
| 0x10 | 2 | Makercode | `01` |
| 0x20 | 4 | ARM9 source | `0x4000` |
| 0x40 | 4 | **FNT offset** | `0x24A600` |
| 0x44 | 4 | Taille FNT | `0x185` |
| 0x48 | 4 | **FAT offset** | `0x24A800` |
| 0x4C | 4 | Taille FAT | `0x548` |

## 2. FNT (table de noms) — non standard

Sous-table unique (pas de répertoires) :

```
u16 first_file_id (= 8, non fiable)
u16 parent (= 0)
u16 fat_base (= 145 : index FAT du premier fichier — champ observé sur APHP)
u16 inconnu (= 1)
puis : u8 len, nom[len] … terminé par len == 0
```

Le mapping FNT→FAT est **validé par signature de contenu** (dungeon.sbin commence
par `b00canm\0`, sound.sbin par `SDAT`, …). La base retenue est `fat_base`.

## 3. FAT

169 entrées de 8 octets : `u32 start, u32 end` (offsets absolus ROM).
Les fichiers FNT occupent les entrées 145–168 ; les entrées 0–144 sont du code
ARM9/ARM7 et des overlays.

## 4. Packs nommés (dungeon.sbin, ground.sbin, …)

```
répétition de :
  nom[8]        — null-terminé, paddé à 8 octets
  u32 offset    — relatif au début du pack
  u32 size
terminé par un champ nom vide (8 × 0x00)
```

- `dungeon.sbin` : 804 entrées — `b{NN}{fon,cel,cex,canm,pal}` (NN = tileset),
  `mapparam`, `zmappat`, `trappat`, `talkp*` (portraits de dialogue), …
- `ground.sbin` : 724 entrées — `A01P01` (maps de zones), `B10P01A/B/C` +
  `B10P02A/B/C` (grounds de cinématique Sinister Woods), `D04P*`, `H*`, `S*`, `T*`, `W*`.

## 5. SIR0

```
"SIR0", u32 main_ptr, u32 ptrlist_ptr
```

Les pointeurs sont des offsets dans le fichier. Les fichiers `.sbin` du jeu sont
des SIR0 (parfois contenant un AT4PX à `main_ptr`).

## 6. AT4PX (compression des graphiques)

```
"AT4PX", u16 flen, u16[9] flags, u16 taille_décompressée, puis flux PX
```

PX : bits de contrôle ; bit=1 → littéral ; bit=0 → octet `hi:lo` : si `hi` est un
flag → pattern de 4 nibbles ; sinon → back-reference `(-0x1000 + lo<<8) | next`.
Implémentation validée byte-à-byte contre les artefacts committés
(`docs/sinister_woods_nds/*.dec.bin`).

## 7. mapparam (dungeon.sbin) — tables Sinister Woods

| Table | Offset | Structure |
|---|---|---|
| floor_id (SW = dungeon #3) | `0x160` | 13 × `u16[8]` : MainData, Pokemon, Traps, Items, KecleonShop, MonsterRoomItems, BuriedItems, 0 |
| FloorProperties | `0x7380` | 28 octets/entrée (voir `blue/mapparam.py` pour les champs) ; SW = indices 17..29 |
| Pointeurs spawn | `0x1FEA8` | u32 → tables de spawns |
| Pointeurs items | `0x28978` | u32 → tables d'items |
| Pointeurs pièges | `0x222E4` | u32 → tables de pièges (u16[20]) |
| Structure principale | `0x28C40` | `[0x7280, 0x7380, 0x28978, 0x1FEA8, 0x222E4, 0xAAAAAAAA…]` |

### Spawns (8 octets/entrée, Blue)
`u16 bits` (species = bits & 0x1FF, level = (bits >> 9) & 0x7F), `s16 w0`, `s16 w1`,
`u16 pad`. Terminateur : entrée KECLEON (id 380) à poids nuls.
Les **noms** d'espèces sont `CROSS_REFERENCE` (pmd-red, artefacts committés) ;
l'extraction d'une table de noms depuis les fichiers `message_*.bin/.str` de la ROM
est `NOT_DECODED` (les noms y apparaissent dispersés dans les dialogues).

### Tables d'items (flux u16)
`0x7500+cat` = marqueur de catégorie, suivi des **poids cumulés** des items de la
catégorie ; `0x753F` = fin de table. Les **IDs des items** ne sont pas dans le flux
→ `UNKNOWN` (documenté). Table 11/12 pour Sinister Woods ; frontières de poids
concordantes avec pmd-red (CROSS_REFERENCE).

### Tables de pièges (u16[20])
Poids par type de piège. Sinister Woods : table 2, `index 17 = 10000` (seul piège).
Nom du piège 17 : `UNKNOWN` (la constante pmd-red serait CROSS_REFERENCE).

## 8. SDAT (sound.sbin)

```
"SDAT" + blocs ; SYMB @ 0x40 (taille 0x5310), INFO @ 0x5350, FAT @ 0x64F0, données @ 0x11A0
```

- SYMB : noms null-terminés groupés par player — `SND_BGM_M_*` (musiques),
  `SND_ME_M_*` (jingles), `Se_Num_*` (SFX), `BANK_*`, `WAVE_*`, `PLAYER_*`.
- **Non décodé** (UNKNOWN) : structure exacte des records INFO (lien index SEQ →
  file_id → SSEQ), points de boucle SSEQ, mapping `FloorProperties.bgMusic` (entier)
  → index SEQ (réside dans le code ARM9).
- Résultat partiel documenté : `bgMusic=4` (SW F1–F12) ; candidat par nom :
  `SND_BGM_M_DUNGEON_AYASHIIMORI_01` (SEQ 15) — **non démontré**.

## 9. Messages (message_e.bin / message_e.str)

- `message_*.str` : table de `u32` (42 902 entrées pour l'anglais) = offsets dans le .bin.
- `message_*.bin` : pool de chaînes (codes de contrôle `#C`, `#R`…, séparateur `\n`).
- Frontières exactes des messages et sémantique des codes : `PARTIAL` (à documenter).

## 10. État des formats

| Format | Statut |
|---|---|
| En-tête NDS, FNT, FAT | SOURCE_NDS décodé (validé) |
| Packs nommés | SOURCE_NDS décodé (validé) |
| SIR0, AT4PX | SOURCE_NDS décodé (validé byte-à-byte) |
| mapparam (floor_id, props, spawns) | SOURCE_NDS décodé (validé) |
| Tables items/pièges | PARTIAL (octets SOURCE_NDS, sémantique partielle) |
| canm (animations tileset) | SIR0 identifié, sémantique UNKNOWN |
| SDAT noms | SOURCE_NDS (validé) ; records INFO UNKNOWN |
| ground.sbin | inventaire SOURCE_NDS ; scripts UNKNOWN |
| Messages | PARTIAL |
