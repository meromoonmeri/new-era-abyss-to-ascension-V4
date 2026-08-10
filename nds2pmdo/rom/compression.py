"""Compression des données des jeux Pokémon Donjon Mystère (GBA/NDS).

Formats supportés :
- SIR0  : conteneur utilisé par Red/Blue Rescue Team et Explorers (pointeurs relocalisables)
- AT4PX : compression utilisée par les blobs graphiques (fon/cel/cex) de Rescue Team
- PRS   : compression standard Nintendo (utilisée dans les SIR0 / fichiers .bin)
"""
from __future__ import annotations

import struct
from dataclasses import dataclass

PX_MIN = 3


def iter_bits(n: int):
    b = 0x80
    while b > 0:
        yield 1 if n & b else 0
        b >>= 1


def nibble_pattern(idx: int, low: int) -> bytes:
    """Pattern de 4 nibbles utilisé par AT4PX (d'après le décodage validé sur APHP)."""
    if idx == 0:
        byte1 = byte2 = (low << 4) | low
    else:
        base = low
        if idx == 1:
            base += 1
        elif idx == 5:
            base -= 1
        ns = [base] * 4
        if 1 <= idx <= 4:
            ns[idx - 1] -= 1
        else:
            ns[idx - 5] += 1
        ns = [x & 0xF for x in ns]
        byte1 = (ns[0] << 4) | ns[1]
        byte2 = (ns[2] << 4) | ns[3]
    return bytes([byte1 & 0xFF, byte2 & 0xFF])


def px_decompress(data: bytes, flags: bytes) -> bytes:
    out = bytearray()
    cur = 0

    def rd():
        nonlocal cur
        v = data[cur]
        cur += 1
        return v

    while cur < len(data):
        cb = rd()
        for bit in iter_bits(cb):
            if cur >= len(data):
                break
            if bit == 1:
                out.append(rd())
            else:
                nb = rd()
                hi = (nb >> 4) & 0xF
                lo = nb & 0xF
                idx = next((i for i, f in enumerate(flags) if f == hi), None)
                if idx is not None:
                    out += nibble_pattern(idx, lo)
                else:
                    off = (-0x1000 + (lo << 8)) | rd()
                    pos = len(out) + off
                    for i in range(hi + PX_MIN):
                        out.append(out[pos + i])
    return bytes(out)


def at4px_decompress(blob: bytes) -> bytes:
    """Décompresse un blob AT4PX. Vérifie la taille annoncée."""
    if blob[:5] != b'AT4PX':
        raise ValueError(f"magic AT4PX attendu, trouvé {blob[:5]!r}")
    flen = struct.unpack_from('<H', blob, 5)[0]
    flags = blob[7:16]
    want = struct.unpack_from('<H', blob, 16)[0]
    out = px_decompress(blob[0x12:flen], flags)
    if len(out) != want:
        raise ValueError(f"AT4PX taille {len(out)} != annoncée {want}")
    return out


@dataclass
class Sir0:
    """Conteneur SIR0."""
    data: bytes
    main_ptr: int
    ptrlist_ptr: int
    sub_objects: list[int] = None  # pointeurs relocalisables (offsets absolus dans data)

    def __post_init__(self):
        self.sub_objects = list(self.iter_pointers())

    def iter_pointers(self):
        off = self.ptrlist_ptr
        while off + 4 <= len(self.data):
            ptr = struct.unpack_from('<I', self.data, off)[0]
            if ptr == 0:
                break
            yield ptr
            off += 4


def is_sir0(data: bytes) -> bool:
    return data[:4] == b'SIR0'


def sir0_parse(data: bytes) -> Sir0:
    if not is_sir0(data):
        raise ValueError("pas un SIR0")
    main_ptr = struct.unpack_from('<I', data, 4)[0]
    ptrlist_ptr = struct.unpack_from('<I', data, 8)[0]
    return Sir0(data=data, main_ptr=main_ptr, ptrlist_ptr=ptrlist_ptr)


def find_sir0_subobject(data: bytes, magic: bytes, start: int = 0) -> int:
    """Offset du premier sous-objet (dans un SIR0) commençant par `magic`."""
    return data.find(magic, start)


def prs_decompress(data: bytes) -> bytes:
    """Décompression PRS (LZ Nintendo)."""
    out = bytearray()
    i = 0
    while i < len(data):
        flags = data[i]
        i += 1
        for bit in range(8):
            if i >= len(data):
                break
            if flags & (0x80 >> bit):
                out.append(data[i])
                i += 1
            else:
                if i + 1 >= len(data):
                    break
                b1 = data[i]
                b2 = data[i + 1]
                i += 2
                length = (b1 >> 4) + 3
                disp = ((b1 & 0xF) << 8) | b2
                pos = len(out) - disp - 1
                for _ in range(length):
                    out.append(out[pos])
                    pos += 1
    return bytes(out)


def prs_compress(data: bytes) -> bytes:
    """Compression PRS (algorithme simple, utilisé par les outils officieux)."""
    out = bytearray()
    i = 0
    n = len(data)
    while i < n:
        flag_byte = 0
        chunks = []
        for bit in range(8):
            if i >= n:
                chunks.append((1, b'\x00'))
                continue
            # recherche du meilleur match (backward)
            best_len = 0
            best_disp = 0
            max_len = min(0x12, n - i)
            start = max(0, i - 0x1000)
            # fenêtre de recherche simple
            for j in range(start, i):
                ln = 0
                while ln < max_len and data[j + ln] == data[i + ln]:
                    ln += 1
                if ln > best_len:
                    best_len = ln
                    best_disp = i - j - 1
                    if ln == max_len:
                        break
            if best_len >= 3:
                flag_byte |= 0x80 >> bit
                ln = best_len - 3
                chunks.append((0, bytes([(ln << 4) | ((best_disp >> 8) & 0xF), best_disp & 0xFF])))
                i += best_len
            else:
                chunks.append((1, data[i:i + 1]))
                i += 1
        out.append(flag_byte)
        for kind, payload in chunks:
            out += payload
    return bytes(out)
