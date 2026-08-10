"""Décodage SDAT (sound.sbin) — chaîne musicale complète, validée sur APHP.

Structure validée (SOURCE_NDS) :
- En-tête : 'SDAT' + champs (taille, offsets de sections)
- SYMB  @0x40   : noms (pool de chaînes null-terminées) ; base des noms SEQ
- INFO  @0x5350 : { 'INFO', u32 size, u32 count(=0x40? -> 64 cases, 8 utilisées),
                     u32[64] offsets de sections (relatifs à INFO, 0 = absente) }
  - section SEQ  @ INFO+0x40  = 0x5390 : { u32 count=220, u32[220] offsets records }
      record i = { u32 file_id, u16 ?, u16 ?, u16 ?, u16 ? } (12 octets)
      offset == 0  ⇒  index SEQ vide (TROU — jamais compacté)
      file_id → entrée FAT → fichier SSEQ
  - section STRM @ INFO+0x84C = 0x5B9C : 1 flux (SSAR)
  - section BANK @ INFO+0x858 = 0x5BA8 : { count=301, u32[301] } → SBNK
  - section WAVE @ INFO+0x10F4 = 0x6444 : 4 archives SWAR
  - section GRP  @ INFO+0x1118 = 0x6468 : 6 groupes
  - section PLAYER@ INFO+0x1164 = 0x64B4 : 1 joueur
- FAT   @0x64F0 : { 'FAT', u32 size, u32 count=186, 186 × { u32 offset, u32 size, u32 0, u32 0 } }
  offsets absolus dans le fichier ; 98 SSEQ + 83 SBNK + 4 SWAR + 1 SSAR

Ce qui reste UNKNOWN (documenté, jamais inventé) :
- mapping FloorProperties.bgMusic (entier) → index SEQ (table dans le code ARM9)
- sémantique des champs u16 internes des records SEQ/BANK
- points de boucle SSEQ (à parser dans les fichiers SSEQ)
"""
from __future__ import annotations

import re
from dataclasses import dataclass, field

from ..provenance import Provenance

SYMB_NAME_RE = re.compile(rb'[A-Z][A-Z0-9_]{2,44}\x00')


@dataclass
class Sdat:
    data: bytes
    symb_off: int = 0x40
    symb_size: int = 0x5310
    info_off: int = 0x5350
    fat_off: int = 0x64F0
    names: list[str] = field(default_factory=list)

    # --- sections (offsets relatifs à INFO) ---
    SEC_SEQ = 0x40
    SEC_STRM = 0x84C
    SEC_BANK = 0x858
    SEC_WAVE = 0x10F4
    SEC_GRP = 0x1118
    SEC_PLAYER = 0x1164

    @classmethod
    def open(cls, data: bytes) -> "Sdat":
        if data[:4] != b'SDAT':
            raise ValueError("pas un SDAT")
        s = cls(data=data)
        s._extract_names()
        return s

    @classmethod
    def parse_symbols(cls, symb_section: bytes) -> "Sdat":
        s = cls(data=symb_section, symb_off=0, symb_size=len(symb_section))
        s._extract_names()
        return s

    def _extract_names(self):
        symb = self.data[self.symb_off:self.symb_off + self.symb_size]
        self.names = [m[:-1].decode('ascii') for m in SYMB_NAME_RE.findall(symb)]

    def seq_names(self, count: int = 220) -> list[str | None]:
        """Liste des noms SEQ (index 0..count-1) alignés sur la section SEQ :
        les trous de la section (offset=0) sont conservés (None) et consomment
        un index, jamais un nom — le pool SYMB n'a pas de trous."""
        try:
            seq = self._section_records(self.SEC_SEQ, count)
        except Exception:
            seq = []
        out: list[str | None] = []
        pool = iter(self.names)
        for i in range(count):
            if i < len(seq) and seq[i]["hole"]:
                out.append(None)
            else:
                out.append(next(pool, None))
        return out

    def _section_records(self, sec_rel: int, count: int) -> list[dict]:
        """Table {count, u32[count] offsets} → records (12 octets) à INFO+offset.
        offset == 0 ⇒ trou (index vide, jamais compacté)."""
        base = self.info_off + sec_rel
        out = []
        for i in range(count):
            off = int.from_bytes(self.data[base + 4 + 4 * i:base + 8 + 4 * i], 'little')
            if off == 0:
                out.append({"index": i, "hole": True, "file_id": None})
                continue
            rec = self.info_off + off
            fid = int.from_bytes(self.data[rec:rec + 4], 'little')
            raw = self.data[rec:rec + 12]
            out.append({"index": i, "hole": False, "file_id": fid,
                        "raw": raw.hex(),
                        "extra_u16": [int.from_bytes(raw[j:j + 2], 'little')
                                      for j in (4, 6, 8, 10)]})
        return out

    def parse_full(self) -> dict:
        """Chaîne complète SEQ/BANK/FAT + extraction des fichiers SSEQ/SBNK/SSAR/SWAR."""
        import struct
        # FAT
        cnt = struct.unpack_from('<I', self.data, self.fat_off + 8)[0]
        fat = []
        for i in range(cnt):
            off, sz, p1, p2 = struct.unpack_from('<IIII', self.data,
                                                 self.fat_off + 12 + i * 16)
            magic = self.data[off:off + 4].decode('ascii', 'replace') if off else None
            fat.append({"file_id": i, "offset": off, "size": sz, "magic": magic})
        # SEQ
        seq = self._section_records(self.SEC_SEQ, 220)
        # BANK
        bank = self._section_records(self.SEC_BANK, 301)
        # autres sections : STRM/WAVE/GRP/PLAYER (formes brutes)
        others = {}
        for label, sec in (("STRM", self.SEC_STRM), ("WAVE", self.SEC_WAVE),
                           ("GRP", self.SEC_GRP), ("PLAYER", self.SEC_PLAYER)):
            b = self.info_off + sec
            cnt2 = struct.unpack_from('<I', self.data, b)[0]
            offs = [struct.unpack_from('<I', self.data, b + 4 + 4 * i)[0]
                    for i in range(min(cnt2, 8))]
            others[label] = {"count": cnt2,
                             "record_offsets": [hex(o) for o in offs]}
        names = self.names
        for e in seq:
            if not e["hole"] and e["index"] < len(names):
                e["name"] = names[e["index"]]
        return {
            "provenance": Provenance.SOURCE_NDS.value,
            "file_count": cnt,
            "fat": fat,
            "seq": seq,
            "seq_hole_count": sum(1 for e in seq if e["hole"]),
            "bank": bank,
            "bank_hole_count": sum(1 for e in bank if e["hole"]),
            "others": others,
            "unknowns": [
                "mapping FloorProperties.bgMusic (entier) → index SEQ (table ARM9)",
                "sémantique des u16 internes des records SEQ/BANK",
                "points de boucle SSEQ",
            ],
        }

    def extract_files(self, outdir) -> dict:
        """Extrait SSEQ, SBNK, SWAR, SSAR vers outdir (sous-dossiers par type)."""
        from pathlib import Path
        import struct
        outdir = Path(outdir)
        cnt = struct.unpack_from('<I', self.data, self.fat_off + 8)[0]
        made = {"SSEQ": [], "SBNK": [], "SWAR": [], "SSAR": []}
        for i in range(cnt):
            off, sz, p1, p2 = struct.unpack_from('<IIII', self.data,
                                                 self.fat_off + 12 + i * 16)
            if not off:
                continue
            magic = self.data[off:off + 4].decode('ascii', 'replace')
            if magic in made:
                sub = outdir / magic
                sub.mkdir(parents=True, exist_ok=True)
                (sub / f"file_{i:03d}.bin").write_bytes(self.data[off:off + sz])
                made[magic].append(i)
        return made
