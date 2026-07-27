#!/usr/bin/env python3
"""Régénère Content/Tile/index.idx à partir de tous les .tile présents.
Format (docs/CONTEXTE_PROJET.md) :
  uint32 nbTilesets
  pour chacun : uint8 lenNom, nom UTF-8, uint32 tileSize, uint32 tileCount,
                copie de la table (tileCount × 16 octets)
"""
import struct, os

TILE_DIR = 'Content/Tile'
names = sorted(f[:-5] for f in os.listdir(TILE_DIR) if f.endswith('.tile'))
out = bytearray()
out += struct.pack('<I', len(names))
for nm in names:
    data = open(f'{TILE_DIR}/{nm}.tile', 'rb').read()
    tile_size, tile_count = struct.unpack_from('<II', data, 0)
    table = data[8:8 + tile_count*16]
    assert len(table) == tile_count*16, nm
    enc = nm.encode('utf-8')
    out += struct.pack('<B', len(enc)) + enc
    out += struct.pack('<II', tile_size, tile_count)
    out += table
open(f'{TILE_DIR}/index.idx', 'wb').write(bytes(out))
print(f'index.idx régénéré : {len(names)} tilesets, {len(out)} octets')
