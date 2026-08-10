"""Décodage des Grounds Blue Rescue Team (ground.sbin) — format Chunsoft GBA/DS.

Fichiers par ground (conventions du pack NDS, validées sur APHP) :
  `A01P01`   — palette : u32 count + count×15 × 4 octets BGRX (index 0 transparent)
  `A01P01c`  — BPC : header {cw, chh, nt, bpa0-3, nc} + tiles 4bpp compressées
               (BPC_IMAGE) + tilemap des chunks compressé (BPC_TILEMAP, 2 phases)
  `A01P01m`  — BMA : header {Wt,Ht,tw,th,Wc,Hc, nL,hD,hC} + layers NRL/XOR
               + collision

Chunk 0 du tilemap = implicite (9 × 0x0000) ; les chunks stockés = 1..nc-1.
Les tiles 4bpp = (nt-1) tiles ; les chunks = (nc-1) × 9 u16
(tile 10 bits | hflip bit10 | vflip bit11 | palette bits 12-15).

Cas particulier documenté : les grounds dont la map a 2 couches (ex. A01P01)
ont un tilemap dont l'équilibrage des phases BPC_TILEMAP n'est pas encore
résolu → statut PARTIAL (tiles décodées, chunks non reconstructibles).
"""
from __future__ import annotations

import struct
from dataclasses import dataclass, field

from ..rom.compression import is_sir0, sir0_parse


@dataclass
class GroundPalette:
    count: int
    colors: list  # list[list[(r,g,b,a)]] — count × 16 couleurs (index 0 = transparent)

    @classmethod
    def parse(cls, blob: bytes) -> "GroundPalette":
        if len(blob) < 4:
            raise ValueError(f"palette trop courte: {len(blob)}")
        (count,) = struct.unpack_from('<I', blob, 0)
        if count < 1 or count > 64:
            raise ValueError(f"count palette invalide: {count} — format spécial (u16 count + données ?)")
        expected = 4 + count * 15 * 4
        if len(blob) < expected:
            raise ValueError(f"palette {len(blob)} B < attendu {expected} B")
        colors = []
        off = 4
        for p in range(count):
            pal = [(0, 0, 0, 0)]  # index 0 transparent
            for _ in range(15):
                r, g, b, x = blob[off:off + 4]
                off += 4
                pal.append((r, g, b, 255 if x == 0 else x))
            colors.append(pal)
        return cls(count=count, colors=colors)


def decode_bpc(blob: bytes):
    """Décode un fichier `c` : tiles 4bpp + chunks (tilemap).
    Retourne (nt, nc, tiles, chunks, bpa, statut, note).
    chunks = liste de (nc-1) × 9 u16 (chunk 0 implicite = 9×0)."""
    from skytemple_files.common.types.file_types import FileType
    if len(blob) < 16:
        raise ValueError("BPC trop court")
    cw, chh = struct.unpack_from('<HH', blob, 0)
    nt = struct.unpack_from('<H', blob, 4)[0]
    bpa = struct.unpack_from('<4H', blob, 6)
    nc = struct.unpack_from('<H', blob, 14)[0]
    if nt < 2 or nc < 2:
        raise ValueError(f"BPC invalide: nt={nt} nc={nc}")
    # tiles 4bpp compressées (BPC_IMAGE), (nt-1) tiles réels
    # + tile 0 implicite (vide) → tiles[0..nt-1] indexés comme dans le jeu
    # (validé pmd-red : tiles = [bytes(32)] + tiles du fichier)
    tiles_raw, consumed = FileType.BPC_IMAGE.decompress(blob[16:], stop_when_size=(nt - 1) * 32)
    tiles = b"\x00" * 32 + tiles_raw
    rest = blob[16 + consumed:]
    # tilemap (chunks) : BPC_TILEMAP 2 phases.
    # Le format Blue tolère un dépassement de la phase 1 (les high bytes écrits
    # au-delà de stop sont ignorés) — on patche donc le décompresseur et on
    # valide le résultat (max_tile < nt, chunks == nc-1).
    try:
        tm = FileType.BPC_TILEMAP.decompress(rest, stop_when_size=(nc - 1) * 18)
        status = "FULL"
        note = None
    except Exception:  # noqa: BLE001
        try:
            from skytemple_files.compression.bpc_tilemap.decompressor import (
                BpcTilemapDecompressor)
            stop = (nc - 1) * 18
            d = BpcTilemapDecompressor(rest, stop)
            while d.cursor < d.max_size and d.bytes_written < stop:
                d._process_phase1()
            d.bytes_written = 0
            while d.cursor < d.max_size and d.bytes_written < stop:
                d._process_phase2()
            tm = bytes(d.decompressed_data[:stop])
            # validation : tiles référencées < nt et nombre de chunks exact
            vals = [int.from_bytes(tm[i:i + 2], 'little') for i in range(0, len(tm), 2)]
            if max(v & 0x3FF for v in vals) < nt and len(vals) // 9 == nc - 1:
                status = "FULL"
                note = "phase1 dépassée (tolérée), résultat validé"
            elif len(vals) // 9 == nc - 1:
                # chunks décodés mais certains tiles référencés > nt :
                # le statut final dépend des chunks réellement utilisés par la map
                bad = sorted({i // 9 for i, v in enumerate(vals) if (v & 0x3FF) >= nt})
                status = "PARTIAL"
                note = (f"tilemap dépassé (toléré) mais {len(bad)} chunk(s) "
                        f"référencent des tiles hors bornes: {bad[:8]} — "
                        f"FULL si non utilisés par la map")
            else:
                status = "PARTIAL"
                note = "tilemap non équilibré (dépassement phase1/phase2 non résolu)"
                tm = b""
        except Exception as ex2:  # noqa: BLE001
            status = "PARTIAL"
            note = f"tilemap non équilibré: {str(ex2)[:120]}"
            tm = b""
    chunks = [int.from_bytes(tm[i:i + 2], 'little')
              for i in range(0, len(tm), 2)] if tm else []
    return {
        "cw": cw, "chh": chh, "nt": nt, "nc": nc, "bpa": list(bpa),
        "tiles": tiles, "chunks": chunks,
        "chunk_count": len(chunks) // 9,
        "status": status, "note": note,
        "has_animation": any(bpa),
    }


def decode_bma(blob: bytes):
    """Décode un fichier `m` : layers (NRL/XOR) + collision.
    Retourne (Wt, Ht, Wc, Hc, layers, collision, statut)."""
    from skytemple_files.common.types.file_types import FileType
    Wt, Ht, tw, th, Wc, Hc = blob[:6]
    nL, hD, hC = struct.unpack_from('<HhH', blob, 6)
    # layers
    layers = []
    src = 12
    STRIDE = 64
    for _ in range(nL):
        dst = []
        for j in range(Hc):
            row = []
            prev = dst[(j - 1) * STRIDE:j * STRIDE] if j > 0 else [0] * STRIDE
            k = 0
            while k < Wc:
                cmd = blob[src]
                src += 1
                if cmd >= 0xC0:
                    for _ in range(cmd - 0xC0 + 1):
                        v = blob[src] | (blob[src + 1] << 8) | (blob[src + 2] << 16)
                        src += 3
                        a, b = v & 0xFFF, (v >> 12) & 0xFFF
                        if j > 0:
                            a ^= prev[len(row)]
                            b ^= prev[len(row) + 1]
                        row += [a, b]
                    k += (cmd - 0xBF) * 2
                elif cmd >= 0x80:
                    v = blob[src] | (blob[src + 1] << 8) | (blob[src + 2] << 16)
                    src += 3
                    for _ in range(cmd - 0x80 + 1):
                        a, b = v & 0xFFF, (v >> 12) & 0xFFF
                        if j > 0:
                            a ^= prev[len(row)]
                            b ^= prev[len(row) + 1]
                        row += [a, b]
                    k += (cmd - 0x7F) * 2
                else:
                    for _ in range(cmd + 1):
                        if j > 0:
                            row += [prev[len(row)], prev[len(row) + 1]]
                        else:
                            row += [0, 0]
                    k += (cmd + 1) * 2
            row = row[:STRIDE] + [0] * (STRIDE - len(row))
            dst += row
        layers.append(dst)
    # collision : couche supplémentaire (RLE/NRL 1 bit ?) via skytemple si possible
    collision = None
    collision_status = "UNKNOWN"
    try:
        bma = FileType.BMA.deserialize(blob)
        collision = bma.collision
        collision_status = "PROVEN"
    except Exception:  # noqa: BLE001
        try:
            bma = FileType.BMA_COLLISION_RLE.deserialize(blob)
            collision = bma.collision
            collision_status = "PROVEN_RLE"
        except Exception:  # noqa: BLE001
            collision_status = "UNKNOWN"
    return {
        "Wt": Wt, "Ht": Ht, "tw": tw, "th": th, "Wc": Wc, "Hc": Hc,
        "nL": nL, "hD": hD, "hC": hC, "layers": layers,
        "collision": collision, "collision_status": collision_status,
    }


def tile_nibble(tile: bytes, x: int, y: int) -> int:
    """Nibble du pixel (x, y) d'un tile 4bpp — convention DS/GBA :
    nibble BAS = pixel de gauche (validé par skytemple iter_bytes_4bit_le
    et pmd-red)."""
    return (tile[y * 4 + x // 2] >> (4 * (x % 2))) & 0xF


def render_ground(ground: dict, palette_index: int = 0):
    """Rend le composite (toutes couches, chunk 0 implicite).
    Retourne une image PIL. ground = dict combiné (bpc + bma).

    Ordre des couches : la couche 0 est la couche du DESSUS (validé pmd-red :
    `for lay in reversed(layers)`), on dessine donc de la dernière vers la 0."""
    from PIL import Image
    bpc, bma = ground["bpc"], ground["bma"]
    tiles = bpc["tiles"]
    chunks = bpc["chunks"]
    Wt, Ht, Wc, Hc = bma["Wt"], bma["Ht"], bma["Wc"], bma["Hc"]
    n_chunks = bpc["nc"] - 1
    img = Image.new("RGBA", (Wt * 8, Ht * 8), (0, 0, 0, 0))
    px = img.load()
    for li in range(bma["nL"] - 1, -1, -1):  # couche 0 = dessus → dessinée en dernier
        layer = bma["layers"][li]
        for cy in range(Hc):
            for cx in range(Wc):
                cid = layer[cy * 64 + cx]
                if cid == 0:
                    continue  # chunk 0 implicite = 9× tile 0 (vide)
                if cid > n_chunks or (cid - 1) * 9 + 9 > len(chunks):
                    continue
                ents = chunks[(cid - 1) * 9:(cid - 1) * 9 + 9]
                for i, ent in enumerate(ents):
                    ti = ent & 0x3FF
                    hf = (ent >> 10) & 1
                    vf = (ent >> 11) & 1
                    pi = (ent >> 12) & 0xF
                    if ti >= len(tiles) // 32:
                        continue
                    tx, ty = cx * 3 + i % 3, cy * 3 + i // 3
                    if tx * 8 + 8 > Wt * 8 or ty * 8 + 8 > Ht * 8:
                        continue
                    td = tiles[ti * 32:(ti + 1) * 32]
                    subpal = ground["palette"].colors[pi % ground["palette"].count]
                    for yy in range(8):
                        for xx in range(8):
                            nib = tile_nibble(td, xx, yy)
                            if nib == 0:
                                continue
                            c = subpal[nib] if nib < len(subpal) else (255, 0, 255, 255)
                            sx, sy = tx * 8 + xx, ty * 8 + yy
                            if hf:
                                sx = tx * 8 + (7 - xx)
                            if vf:
                                sy = ty * 8 + (7 - yy)
                            px[sx, sy] = c
    return img


def render_layer(ground: dict, layer_index: int = 0, palette_index: int = 0):
    """Rend les couches 0..layer_index empilées (couche 0 = dessus, dessinée
    en dernier, comme dans le moteur)."""
    from PIL import Image
    bpc, bma = ground["bpc"], ground["bma"]
    tiles = bpc["tiles"]
    chunks = bpc["chunks"]
    Wt, Ht, Wc, Hc = bma["Wt"], bma["Ht"], bma["Wc"], bma["Hc"]
    n_chunks = bpc["nc"] - 1
    img = Image.new("RGBA", (Wt * 8, Ht * 8), (0, 0, 0, 0))
    px = img.load()
    for li in range(layer_index, -1, -1):
        layer = bma["layers"][li]
        for cy in range(Hc):
            for cx in range(Wc):
                cid = layer[cy * 64 + cx]
                if cid == 0 or cid > n_chunks or (cid - 1) * 9 + 9 > len(chunks):
                    continue
                ents = chunks[(cid - 1) * 9:(cid - 1) * 9 + 9]
                for i, ent in enumerate(ents):
                    ti = ent & 0x3FF
                    hf = (ent >> 10) & 1
                    vf = (ent >> 11) & 1
                    pi = (ent >> 12) & 0xF
                    if ti >= len(tiles) // 32:
                        continue
                    tx, ty = cx * 3 + i % 3, cy * 3 + i // 3
                    if tx * 8 + 8 > Wt * 8 or ty * 8 + 8 > Ht * 8:
                        continue
                    td = tiles[ti * 32:(ti + 1) * 32]
                    subpal = ground["palette"].colors[pi % ground["palette"].count]
                    for yy in range(8):
                        for xx in range(8):
                            nib = tile_nibble(td, xx, yy)
                            if nib == 0:
                                continue
                            c = subpal[nib] if nib < len(subpal) else (255, 0, 255, 255)
                            sx, sy = tx * 8 + xx, ty * 8 + yy
                            if hf:
                                sx = tx * 8 + (7 - xx)
                            if vf:
                                sy = ty * 8 + (7 - yy)
                            px[sx, sy] = c
    return img
