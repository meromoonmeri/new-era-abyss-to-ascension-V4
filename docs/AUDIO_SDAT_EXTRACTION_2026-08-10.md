# AUDIO — EXTRACTION SDAT DE PMD BLUE RESCUE TEAM (NDS) POUR NEW ERA

**Date : 2026-08-10 — ROM : « Pokemon Mystery Dungeon - Blue Rescue Team (Europe) (En,Fr,De,Es,It).nds »
(CRC-32 `a28b5a7a`, 32 Mo), fournie par l'utilisateur.**

## 1. CONTEXTE

La scène de la Météorite (A04P01) exige les musiques canoniques :
- `MUS_WORLD_CALAMITY` (« Giant Star Approaching ») → **SEQ 19 `SND_BGM_M_EVENT_DISASTER`**
  (bank 19, volume 90, ~64 s par passe à 122 BPM — nom « EVENT_DISASTER » = catastrophe, cohérent
  avec la chute de la météorite) ;
- `MUS_RAYQUAZAS_DOMAIN` → candidates **SEQ 22/23 `SND_BGM_M_DUNGEON_TENKUU_01/02`** (TENKUU = 天空 =
  « ciel », bank 22/23) et **SEQ 6 `SND_BGM_M_EVENT_LEGEND_01`** (bank ?) — à confirmer à l'écoute.

## 2. CE QUI A ÉTÉ EXTRAIT (dossier `rom_assets/extracted_audio/`)

| Contenu | Fichiers |
|---|---|
| 220 séquences SSEQ | `sequences/NNN_NOM.sseq` |
| 49 banques d'instruments (SBNK) | `banks/bank_NNN_NOM.sbnk` |
| 4 archives de formes d'onde (SWAR) | `waves/wave_NNN_NOM.swar` |
| 5 arrangements MIDI (convertisseur maison) | `rom_assets/midi_out/NNN_NOM.mid` (019, 022, 023, 006, 041) |

Le convertisseur SSEQ→MIDI est intégré au repo : **`tools/sseq2midi.py`**
(`python3 tools/sseq2midi.py <sound.sbin> 19 22 23 --out dossier`). Il interprète le bytecode SSEQ
(opcodes vérifiés dans `ndspy.soundSequence` + `fincs/midi2sseq`) : notes/rests/instruments/tempo/
pan/volume, pile d'appels, boucles 0xD4/0xFC, sauts arrière = points de boucle BGM.

## 3. RECETTE POUR PRODUIRE LE .ogg FINAL (sur machine avec outils)

PMDO charge les musiques en `.ogg` dans `Content/Music/`. Rendu FIDÈLE (échantillons originaux) :

1. **SEQ → MIDI** : `python3 tools/sseq2midi.py sound.sbin 19 --loops 1 --out midi/`
2. **SDAT → SoundFont (SF2)** : utiliser un convertisseur SDAT→SF2 (ex. `sdat2sf2`, les outils
   `sseq`/`sbnk`/`swar` de la scène DS) avec `banks/bank_019_*.sbnk` + `waves/wave_*.swar` ;
   en alternative, un SF2 GM classique donne une version d'écoute approximative (non canonique).
3. **MIDI + SF2 → OGG** : `fluidsynth -F sortie.wav banque.sf2 midi/019_*.mid` puis
   `ffmpeg -i sortie.wav -c:a libvorbis -q:a 6 sortie.ogg` (boucler proprement la passe).
4. Nommer le fichier selon la convention New Era (ex. `World Calamity.ogg`) et le référencer dans le
   script de la scène + vérifier qu'il n'existe pas déjà un doublon (134 musiques actuelles).

**Écarts documentés** : la conversion MIDI ignore vibrato/ADSR/expressions (effets de synthèse) ;
le rendu GM n'est PAS le son original (approximation d'écoute seulement). Le rendu SDAT fidèle
nécessite le SF2 construit depuis les .sbnk/.swar.

## 4. MESSAGE FRANÇAIS (utile pour les dialogues)

`rom_fs/message_f.bin` + `message_f.str` contiennent tous les textes français du jeu
(à décoder pour les dialogues des scènes reconstructibles).

## 5. SUITE — SCÈNE MÉTÉORITE (A04P01)

- **Ground** : `a04p01.rsground` récupéré depuis le port PMD-RED-PMDO-PORT (600×312, TexSize 1,
  sheet `a04p01_Base`) — à traiter comme les autres imports 1:1 (éventuel TexSize 2 si validé) ;
- **Script** : décodé dans `AUDIT_CINEMATIQUE_METEORITE_PMD_RED.md` (secteurs g0-g7, flashs,
  caméra, Xatu/Rayquaza, fanfares 465/489/212) ;
- **Sprites Rayquaza** : `pret/pmd-red/graphics/ax/mon/rayquazacutscene/` (374 sprites) ;
- **Cast New Era** : Xatu/Rayquaza → à arbitrer avec l'utilisateur (règle : pas de remplacement
  arbitraire) ;
- **Statut** : `REQUIRES_ROM` levé (ROM reçue) ; conversion audio en cours ; scène
  `PARTIAL/PENDING` jusqu'à l'assemblage complet + validation runtime.
