"""Containers SIR0 des jeux Rescue Team (dungeon.sbin, ground.sbin, mapparam…).

Le SIR0 contient une table d'entrées nommées : {nom → (offset, taille)}.
La disposition exacte est détectée et validée (les noms doivent matcher un motif
d'identifiants binaires du jeu : `mapparam`, `b41fon`, `dungeon#3`, `B10P01`…).
"""
from __future__ import annotations

import re
import struct
from dataclasses import dataclass

from .compression import Sir0, sir0_parse

_NAME_RE = re.compile(rb'^[A-Za-z0-9_#]{2,24}$')


@dataclass
class SbinEntry:
    name: str
    offset: int
    size: int

    @property
    def end(self) -> int:
        return self.offset + self.size


def _read_cstr(data: bytes, off: int, maxlen: int = 64) -> bytes | None:
    if off < 0 or off >= len(data):
        return None
    end = data.find(b'\x00', off, off + maxlen)
    if end < 0:
        return None
    return data[off:end]


def _try_layout(data: bytes, count: int, entry_offsets: list[int],
                name_field: int, off_field: int, size_field: int) -> list[SbinEntry] | None:
    """name_field/off_field/size_field : position (0,1,2) du champ dans l'entrée u32×3."""
    entries = []
    for eo in entry_offsets:
        if eo + 12 > len(data):
            return None
        fields = struct.unpack_from('<III', data, eo)
        name_ptr = fields[name_field]
        off = fields[off_field]
        size = fields[size_field]
        name = _read_cstr(data, name_ptr)
        if name is None or not _NAME_RE.match(name):
            return None
        if off + size > len(data):
            return None
        entries.append(SbinEntry(name.decode('ascii'), off, size))
    return entries


def parse_sbin(data: bytes) -> list[SbinEntry]:
    """Parse un container SIR0 de type `.sbin` (Rescue Team).

    Retourne la liste des entrées {nom, offset, taille}. Les données des entrées
    peuvent elles-mêmes être compressées (AT4PX, PRS) ou brutes.
    """
    sir0: Sir0 = sir0_parse(data)
    main = sir0.main_ptr
    if main + 4 > len(data):
        raise ValueError("main_ptr SIR0 hors limites")
    (count,) = struct.unpack_from('<I', data, main)
    if count == 0 or count > 0x10000:
        raise ValueError(f"count SIR0 invalide: {count}")
    entry_offsets = list(struct.unpack_from(f'<{count}I', data, main + 4))
    for layout in ((1, 0, 2), (2, 0, 1), (0, 1, 2), (1, 2, 0)):
        entries = _try_layout(data, count, entry_offsets, *layout)
        if entries is not None:
            return entries
    raise ValueError("layout de container SIR0 non reconnu")
