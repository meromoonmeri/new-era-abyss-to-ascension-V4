"""Système de fichiers Nintendo DS : en-tête NDS, FNT (table de noms), FAT (table de fichiers).

Permet d'extraire tous les fichiers de la ROM (`dungeon.sbin`, `ground.sbin`,
`sound.sbin`, `message/`, …) avec des offsets absolus vérifiés.
"""
from __future__ import annotations

import struct
from dataclasses import dataclass, field
from pathlib import Path


@dataclass
class NdsFileEntry:
    file_id: int
    path: str
    start: int
    end: int

    @property
    def size(self) -> int:
        return self.end - self.start


# Signatures de contenu des fichiers FNT (validées sur APHP) :
# {nom → octets attendus au début du fichier}
_FNT_SIGNATURES: dict[str, bytes] = {
    "dungeon.sbin": b"b00canm\x00",
    "effect.sbin": b"efbg000\x00",
    "ground.sbin": b"A01P01\x00",
    "monster.sbin": b"ax001\x00",
    "nitro_haltscreen.sbin": b"AT4PX",
    "ornament.sbin": b"flag00c\x00",
    "sample.sbin": b"anime\x00",
    "sound.sbin": b"SDAT",
    "system.sbin": b"font\x00",
    "titlemenu.sbin": b"clmkpat\x00",
}


@dataclass
class NdsRom:
    path: Path
    data: bytes
    gamecode: str
    makercode: str
    fnt_offset: int
    fat_offset: int
    files: list[NdsFileEntry] = field(default_factory=list)

    @classmethod
    def open(cls, path: str | Path) -> "NdsRom":
        p = Path(path)
        data = p.read_bytes()
        # En-tête NDS "POKE DUNGEON" (logo remplacé) : gamecode 0x0C, makercode 0x10,
        # FNT @ 0x40, FAT @ 0x48 (positions standard NDS).
        gamecode = data[0x0C:0x10].decode('ascii', 'replace')
        makercode = data[0x10:0x12].decode('ascii', 'replace')
        fnt_offset = struct.unpack_from('<I', data, 0x40)[0]
        fat_offset = struct.unpack_from('<I', data, 0x48)[0]
        rom = cls(path=p, data=data, gamecode=gamecode, makercode=makercode,
                  fnt_offset=fnt_offset, fat_offset=fat_offset)
        rom._parse_fat_fnt()
        return rom

    def _parse_fat_fnt(self):
        fat = self.data[self.fat_offset:self.fat_offset + 8 * 0x1000]
        # FNT APHP (non standard) : u16 first_file_id(=8), u16 parent(=0),
        # u16 fat_base(=145, index FAT du premier fichier), u16 inconnu(=1),
        # puis les noms de fichiers.
        fnt = self.data[self.fnt_offset:]
        first_file_id, _parent = struct.unpack_from('<HH', fnt, 0)
        fat_base, _unknown = struct.unpack_from('<HH', fnt, 4)

        names: list[str] = []
        sub = 8
        while sub < len(fnt):
            name_len = fnt[sub]
            sub += 1
            if name_len == 0:
                break
            if name_len & 0x80:
                raise ValueError(f"répertoires non supportés dans la ROM APHP ({name_len} octets)")
            names.append(fnt[sub:sub + name_len].decode('ascii', 'replace'))
            sub += name_len

        # Entrées FAT (u32 start, u32 end)
        fat_entries = []
        off = self.fat_offset
        while off + 8 <= len(self.data):
            start, end = struct.unpack_from('<II', self.data, off)
            if end < start or end > len(self.data):
                break
            fat_entries.append((start, end))
            off += 8
            if len(fat_entries) > 0x4000:
                break

        # Mapping FNT → FAT : la base annoncée dans le FNT (145) est la bonne ;
        # on la valide par signature de contenu, avec repli sur la base standard.
        files: list[NdsFileEntry] = []
        mapped = self._map_fnt_to_fat(names, fat_entries, fat_base, first_file_id)
        for name, (start, end) in zip(names, mapped):
            files.append(NdsFileEntry(file_id=len(files), path=name, start=start, end=end))
        self.files = files

    # Signatures de contenu des fichiers FNT (validées sur APHP) :
    # {nom → octets attendus au début du fichier}
    def _map_fnt_to_fat(self, names, fat_entries, fat_base, first_file_id
                        ) -> list[tuple[int, int]]:
        def check(entries: list[tuple[int, int]]) -> bool:
            for name, (start, end) in zip(names, entries):
                sig = _FNT_SIGNATURES.get(name)
                if sig is not None and not self.data[start:start + len(sig)] == sig:
                    return False
            return True

        for base in (fat_base, first_file_id, len(fat_entries) - len(names)):
            cand = fat_entries[base:base + len(names)]
            if len(cand) == len(names) and check(cand):
                return cand
        raise ValueError(
            f"mapping FNT→FAT non résolu (fat_base={fat_base}, first_file_id={first_file_id}, "
            f"{len(fat_entries)} entrées FAT, {len(names)} fichiers FNT)")

    def get(self, path: str) -> bytes | None:
        for f in self.files:
            if f.path == path:
                return self.data[f.start:f.end]
        return None

    def extract_all(self, outdir: Path) -> list[NdsFileEntry]:
        outdir.mkdir(parents=True, exist_ok=True)
        written = []
        for f in self.files:
            p = outdir / f.path
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_bytes(self.data[f.start:f.end])
            written.append(f)
        return written
