"""Pack nommé des jeux Rescue Team DS (dungeon.sbin, ground.sbin, …).

Format (validé sur la ROM APHP) :
  répétition de { nom\\0, u32 offset, u32 size } jusqu'au premier nom vide ;
  les offsets sont relatifs au début du fichier pack.
"""
from __future__ import annotations

import re
from dataclasses import dataclass

_NAME_RE = re.compile(rb'^[A-Za-z0-9_#]{2,24}$')


@dataclass
class PackEntry:
    name: str
    offset: int
    size: int
    absolute: int

    @property
    def end(self) -> int:
        return self.offset + self.size


def parse_pack(data: bytes, base_absolute: int = 0) -> list[PackEntry]:
    """Parse un pack nommé. Retourne les entrées triées par ordre de table.

    Format (validé sur la ROM APHP) : entrées de 16 octets —
      nom (8 octets, null-terminé, paddé), u32 offset, u32 size.
    base_absolute : offset absolu (dans la ROM) du début du pack, pour traçabilité.
    """
    entries: list[PackEntry] = []
    off = 0
    while off + 16 <= len(data):
        field = data[off:off + 8]
        name = field.split(b'\x00', 1)[0]
        if not name:
            break
        if not _NAME_RE.match(name):
            # repli : nom plus long que 8 octets (non observé sur APHP) → variable
            name_end = data.find(b'\x00', off, off + 32)
            if name_end < 0:
                raise ValueError(f"nom non terminé à l'offset {off:#x}")
            name = data[off:name_end]
            if not _NAME_RE.match(name):
                raise ValueError(f"nom de pack invalide {name!r} à l'offset {off:#x}")
            eoff = int.from_bytes(data[name_end + 1:name_end + 5], 'little')
            esize = int.from_bytes(data[name_end + 5:name_end + 9], 'little')
            next_off = name_end + 9
        else:
            eoff = int.from_bytes(data[off + 8:off + 12], 'little')
            esize = int.from_bytes(data[off + 12:off + 16], 'little')
            next_off = off + 16
        if eoff + esize > len(data):
            raise ValueError(f"entrée {name!r} hors limites (off={eoff:#x} size={esize:#x})")
        entries.append(PackEntry(name.decode('ascii'), eoff, esize, base_absolute + eoff))
        off = next_off
    return entries


def unpack_pack(data: bytes, outdir, base_absolute: int = 0,
                only: set[str] | None = None) -> list[PackEntry]:
    """Extrait les entrées d'un pack vers outdir. Retourne les entrées."""
    import hashlib
    from pathlib import Path

    outdir = Path(outdir)
    outdir.mkdir(parents=True, exist_ok=True)
    entries = parse_pack(data, base_absolute)
    manifest = {"entries": []}
    for e in entries:
        if only is not None and e.name not in only:
            continue
        blob = data[e.offset:e.end]
        (outdir / e.name).write_bytes(blob)
        manifest["entries"].append({
            "name": e.name, "offset": e.offset, "size": e.size,
            "absolute": e.absolute, "sha256": hashlib.sha256(blob).hexdigest()})
    (outdir / "manifest.json").write_text(
        __import__("json").dumps(manifest, indent=1, ensure_ascii=False))
    return entries
