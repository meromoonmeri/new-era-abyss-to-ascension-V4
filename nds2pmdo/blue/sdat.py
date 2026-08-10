"""Décodage SDAT (sound.sbin) — inventaire des séquences.

La table SYMB contient les noms (chaînes null-terminées, groupes par player :
SEQ → SND_BGM_M_*, SND_ME_M_* ; SE → Se_Num_* ; BANK → BANK_* ; …).
La structure exacte des records INFO (lien index SEQ → file_id FAT → SSEQ)
n'est pas encore décodée : elle est documentée UNKNOWN, jamais inventée.
"""
from __future__ import annotations

import re
import struct
from dataclasses import dataclass, field

SYMB_NAME_RE = re.compile(rb'[A-Z][A-Z0-9_]{2,44}\x00')


@dataclass
class Sdat:
    data: bytes
    symb_off: int = 0x40
    info_off: int = 0x5350
    fat_off: int = 0x64F0
    symb_size: int = 0x5310
    names: list[str] = field(default_factory=list)

    @classmethod
    def open(cls, data: bytes) -> "Sdat":
        if data[:4] != b'SDAT':
            raise ValueError("pas un SDAT")
        s = cls(data=data)
        s._extract_names()
        return s

    @classmethod
    def parse_symbols(cls, symb_section: bytes) -> "Sdat":
        """Construit un Sdat à partir de la seule section SYMB (tests / CI sans ROM)."""
        s = cls(data=symb_section, symb_off=0, symb_size=len(symb_section))
        s._extract_names()
        return s

    def _extract_names(self):
        """Noms SYMB dans l'ordre (validé contre le ground truth committé
        docs/sinister_woods_nds/sdat_seq_names.json)."""
        symb = self.data[self.symb_off:self.symb_off + self.symb_size]
        self.names = [m[:-1].decode('ascii') for m in SYMB_NAME_RE.findall(symb)]

    def seq_names(self, count: int = 220) -> list[str | None]:
        """Liste des noms SEQ (index 0..count-1). Les trous (records sans symbole)
        sont conservés en None — jamais remplacés par une valeur inventée."""
        out: list[str | None] = []
        for i in range(count):
            out.append(self.names[i] if i < len(self.names) else None)
        return out

    def first_unknown(self) -> dict:
        return {
            "status": "PARTIAL",
            "known": "SYMB name list extracted (SOURCE_NDS)",
            "unknown": [
                "INFO record structure (lien index SEQ → file_id → SSEQ)",
                "mapping FloorProperties.bgMusic integer → SEQ index (code ARM9)",
                "SSEQ loop points",
            ],
        }
