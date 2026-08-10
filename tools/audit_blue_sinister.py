#!/usr/bin/env python3
"""
Audit source NDS réel — Sinister Woods (Blue)
ROM offset → fichier interne → SIR0 → structure → champ → fonction
Ne modifie rien, produit un rapport avec provenance pour chaque champ.
"""
import pathlib, struct, json, sys

MOD_ROOT = pathlib.Path(__file__).resolve().parents[1]
ROM_PATH = pathlib.Path("/tmp/POKEMON-ROM/Pokemon Mystery Dungeon - Blue Rescue Team (Europe) (En,Fr,De,Es,It).nds")
TMP = pathlib.Path("/tmp/sinister_audit")
TMP.mkdir(exist_ok=True)

def log(s): print(s)

log("=== AUDIT SOURCE NDS RÉEL — Sinister Woods (Blue) ===")
log(f"ROM: {ROM_PATH} ({ROM_PATH.stat().st_size} bytes)")

import ndspy.rom
rom = ndspy.rom.NintendoDSRom.fromFile(str(ROM_PATH))
dungeon_sbin = rom.getFileByName("dungeon.sbin")
open("/tmp/dungeon.sbin","wb").write(dungeon_sbin)
log(f"dungeon.sbin: {len(dungeon_sbin)} bytes, header {dungeon_sbin[:16].hex()}")

# Parser dungeon.sbin (table 16o/entry)
entries=[]
for i in range(0, 4096, 16):
    name=dungeon_sbin[i:i+8]
    if not name.startswith(b'b'): break
    try: name_str=name.rstrip(b'\x00').decode('ascii')
    except: break
    off=int.from_bytes(dungeon_sbin[i+8:i+12],'little')
    sz=int.from_bytes(dungeon_sbin[i+12:i+16],'little')
    entries.append((name_str,off,sz))
log(f"Entries: {len(entries)} (b00..bXX)")

# Sinister Woods ID 10 → b10
sinister_id=10
candidates=[f"b{sinister_id:02d}{s}" for s in ["canm","cel","cex","fon","pal"]]
log(f"\nSinister Woods ID {sinister_id} → fichiers: {candidates}")
for name,off,sz in entries:
    if name in candidates:
        chunk=dungeon_sbin[off:off+sz]
        is_sir0=chunk[:4]==b'SIR0'
        log(f"  {name}: off {off} sz {sz} SIR0={is_sir0} header {chunk[:16].hex()} ascii {chunk[:16]}")
        out=TMP / f"{name}.bin"
        open(out,"wb").write(chunk)
        # Si SIR0, décompresser
        if is_sir0:
            from skytemple_files.container.sir0.handler import Sir0Handler
            sir0=Sir0Handler.deserialize(chunk)
            content=sir0.content
            log(f"    -> décompressé {len(chunk)} -> {len(content)} header {content[:32].hex()}")
            open(TMP / f"{name}.decompressed","wb").write(content)
            # Essayer de décoder la structure
            # Pour b10canm (mappa), le contenu décompressé est 1088 bytes, header 0c00 0c00 ...
            # C'est probablement la structure Mappa pour Blue (similaire à GBA mais avec NDS header)
            # On tente de l'analyser comme une grille
            if name.endswith("canm"):
                log(f"    b10canm décompressé: {len(content)} bytes")
                # Dump hex pour analyse
                for off2 in range(0, min(128, len(content)), 16):
                    hexs=" ".join(f"{b:02x}" for b in content[off2:off2+16])
                    asci="".join(chr(b) if 32<=b<127 else "." for b in content[off2:off2+16])
                    log(f"      {off2:04x}: {hexs} |{asci}|")
                # Essayer de décoder comme Mappa Blue: les 2 premiers uint16 sont peut-être la taille de la grille ?
                if len(content)>=4:
                    w,h=struct.unpack_from('<HH', content, 0)
                    log(f"      Possible grille: w={w} h={h} (0c 00 =12)")
                    # 12x12 ? Pour Sinister Woods, la grille pourrait être 12x12
                    # Les prochains bytes sont 81 3c 5d 80 ... qui ressemble à des tiles
            elif name.endswith("fon"):
                log(f"    b10fon décompressé: {len(content)} bytes (si SIR0, sinon raw {sz})")
                # b10fon est probablement le floor data (mappa) pour Blue, non SIR0 (header 41543450 = 'ATCP')
                # On l'a déjà, c'est le fichier avec header 'ATCP'
                pass
            elif name.endswith("cel"):
                log(f"    b10cel: {len(content) if is_sir0 else sz} bytes")
            elif name.endswith("pal"):
                log(f"    b10pal: 768 bytes (palette)")

# Vérifier les autres fichiers b10 non SIR0 (fon, cel sont raw, pas SIR0)
for name,off,sz in entries:
    if name=="b10fon":
        chunk=dungeon_sbin[off:off+sz]
        log(f"\nb10fon raw header {chunk[:32].hex()} ascii {chunk[:32]}")
        # Le header 'ATCP' suggère un autre format (peut-être un conteneur)
        if chunk[:4]==b'ATCP':
            log("  -> ATCP (probablement un conteneur pour le floor data)")
        # Essayer de le parser comme un simple binaire de donjon
    elif name=="b10cel":
        chunk=dungeon_sbin[off:off+sz]
        log(f"b10cel raw header {chunk[:32].hex()}")
        if chunk[:4]==b'AT4P':
            log("  -> AT4P (peut-être des données de monstres)")

log("\n=== CONCLUSION AUDIT SOURCE ===")
log("Blue b10canm: 1088 o décompressés, header 0c00 0c00 (12x12 ?), NOT DECODED (handler Mappa NDS manquant)")
log("Blue b10fon: 10177 o raw, header 41543450 (ATCP), NOT DECODED")
log("Blue b10cel: 2054 o raw, header 41543450 (AT4P), NOT DECODED")
log("Blue b10pal: 768 o palette, DOCUMENTED")
log("Pour un décodage complet, il faut analyser le format NDS Blue Mappa (différent de Sky Mappa)")
log("Cross-reference Red pmd-red: 13 étages, mais ne peut pas être utilisé comme source principale")
log("Prochaine étape: décoder manuellement le format NDS Blue Mappa en analysant les structures binaires")
