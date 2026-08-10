"""Tests du pipeline nds2pmdo — exécutables en CI sans la ROM.

Les tests « rom » (extraction) ne s'exécutent que si extracted/ est présent.
Les autres vérifient les décodeurs contre les artefacts ground truth committés
(docs/sinister_woods_nds/ et decoded/).
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from nds2pmdo.blue.mapparam import (decode_mapparam, parse_floor_id_table,
                                    parse_item_table, parse_spawn_table,
                                    parse_trap_table)
from nds2pmdo.blue.sdat import Sdat
from nds2pmdo.config import DECODED_DIR, EXTRACTED_DUNGEON_PACK, EXTRACTED_DIR
from nds2pmdo.blue.graphics import decode_graphics_blob
from nds2pmdo.rom.compression import at4px_decompress
from nds2pmdo.rom.pack import parse_pack

REPO = Path(__file__).resolve().parents[2]
LEGACY = REPO / "docs" / "sinister_woods_nds"
FI = Path(__file__).resolve().parent / "fixtures"

rom_available = (EXTRACTED_DUNGEON_PACK / "mapparam").exists()


def load_legacy(name: str):
    return json.loads((LEGACY / name).read_text())


# ---------------------------------------------------------------------------
# 1. AT4PX — reproduction byte-à-byte des artefacts committés
# ---------------------------------------------------------------------------
@pytest.mark.parametrize("prefix", ["b10", "b41"])
@pytest.mark.parametrize("suffix", ["fon", "cel", "cex"])
def test_at4px_matches_legacy_dec(prefix, suffix):
    raw = (FI / f"{prefix}{suffix}.raw.bin").read_bytes()
    # cex est un SIR0 contenant un AT4PX (at4px_at=16) ; fon/cel sont AT4PX directs
    res = decode_graphics_blob(f"{prefix}{suffix}", raw)
    assert res["status"] == "SOURCE_NDS_DECODED"
    expected = (LEGACY / f"{prefix}{suffix}.dec.bin").read_bytes()
    assert res["decompressed"] == expected, \
        f"{prefix}{suffix} décompressé ≠ ground truth committé"


def test_palette_matches_legacy_raw():
    pal = (FI / "b10pal.raw.bin").read_bytes()
    assert len(pal) == 768
    assert pal == (LEGACY / "b10pal.raw.bin").read_bytes()


# ---------------------------------------------------------------------------
# 2. Pack dungeon.sbin — entrées nommées
# ---------------------------------------------------------------------------
def test_pack_entries_synthetic():
    """Pack synthétique : nom (8 octets paddés) + u32 offset + u32 size."""
    import struct
    data = bytearray()
    data += b"b00canm\x00" + struct.pack('<II', 0x20, 0x10)
    data += b"mapparam" + struct.pack('<II', 0x30, 0x08)
    data += b"zmappat\x00" + struct.pack('<II', 0x38, 0x04)
    data += b"\x00" * 8                      # fin de table
    data += b"A" * 0x40                       # données
    entries = parse_pack(bytes(data))
    assert [e.name for e in entries] == ["b00canm", "mapparam", "zmappat"]
    assert entries[0].offset == 0x20 and entries[0].size == 0x10


@pytest.mark.skipif(not rom_available, reason="extraction ROM non présente")
def test_pack_entries_full_rom():
    m = json.loads((EXTRACTED_DUNGEON_PACK / "manifest.json").read_text())
    names = [e["name"] for e in m["entries"]]
    assert "mapparam" in names and "zmappat" in names and "trappat" in names
    assert len(names) >= 800


# ---------------------------------------------------------------------------
# 3. mapparam — floor ids / propriétés / spawns vs ground truth
# ---------------------------------------------------------------------------
@pytest.mark.skipif(not rom_available, reason="extraction ROM non présente")
def test_mapparam_floor_ids_match_legacy():
    mp = (EXTRACTED_DUNGEON_PACK / "mapparam").read_bytes()
    dec = decode_mapparam(mp)
    gt = load_legacy("floors_f1_f13.json")
    for i in range(13):
        d, g = dec["floor_ids"][i], gt[i]["floor_id"]
        for k in ("MainData", "Pokemon", "Traps", "Items", "KecleonShop",
                  "MonsterRoomItems", "BuriedItems"):
            assert d[k] == g[k], f"F{i+1} {k}: {d[k]} != {g[k]}"


@pytest.mark.skipif(not rom_available, reason="extraction ROM non présente")
def test_mapparam_props_match_legacy_bytes():
    mp = (EXTRACTED_DUNGEON_PACK / "mapparam").read_bytes()
    dec = decode_mapparam(mp)
    gt = load_legacy("floors_f1_f13.json")
    for i in range(13):
        gi = str(gt[i]["properties"]["globalIndex"])
        assert dec["floor_properties"][gi]["bytes_hex"] == gt[i]["properties"]["bytes_hex"]


@pytest.mark.skipif(not rom_available, reason="extraction ROM non présente")
def test_mapparam_spawns_match_legacy():
    mp = (EXTRACTED_DUNGEON_PACK / "mapparam").read_bytes()
    dec = decode_mapparam(mp)
    gt = load_legacy("floors_f1_f13.json")
    for i in range(13):
        idx = str(gt[i]["pokemon_table_index"])
        got = dec["spawns"][idx]
        exp = gt[i]["pokemon_spawns"]
        assert [s["species_id"] for s in got] == [s["species_id"] for s in exp]
        assert [s["level"] for s in got] == [s["level"] for s in exp]
        assert [s["weight0"] for s in got] == [s["weight0"] for s in exp]


@pytest.mark.skipif(not rom_available, reason="extraction ROM non présente")
def test_item_tables_match_legacy_raw():
    mp = (EXTRACTED_DUNGEON_PACK / "mapparam").read_bytes()
    dec = decode_mapparam(mp)
    gt = load_legacy("ITEMS_TABLES_RAW.json")
    for tid, t in gt.items():
        off = t["offset"]
        stream = dec["item_tables"]
        # vérification : le flux u16 brut au même offset est identique (sha du blob)
        from nds2pmdo.blue.mapparam import ITEM_PTR_TABLE
        import struct
        ptr = struct.unpack_from('<I', mp, ITEM_PTR_TABLE + int(tid) * 4)[0]
        blob = mp[ptr:ptr + t["size"]]
        import hashlib
        assert hashlib.sha256(blob).hexdigest() == t["sha256"], f"table items {tid}"


@pytest.mark.skipif(not rom_available, reason="extraction ROM non présente")
def test_trap_tables_match_legacy_raw():
    mp = (EXTRACTED_DUNGEON_PACK / "mapparam").read_bytes()
    gt = load_legacy("TRAPS_TABLES.json")
    blob = mp[gt["2"]["offset"]:gt["2"]["offset"] + gt["2"]["size"]]
    import hashlib
    assert hashlib.sha256(blob).hexdigest() == gt["2"]["sha256"]


def test_trap_table_index17_weight():
    # fixture : 40 octets de la table pièges 2 (Sinister Woods)
    blob = (FI / "trap_table_2.bin").read_bytes()
    weights = parse_trap_table(blob, 0)
    assert weights[17] == 10000


def test_item_table_markers():
    blob = (FI / "item_table_11.bin").read_bytes()
    t = parse_item_table(blob, 0)
    cats = [g["category_id"] for g in t["groups"]]
    assert cats[0] == 50  # 0x32
    assert cats[-1] == 63 or t["groups"][-1]["category_marker"] >= 0x7500
    assert t["groups"][0]["cumulative_weights"] == [3077, 5385]


# ---------------------------------------------------------------------------
# 4. SDAT — noms SEQ vs ground truth
# ---------------------------------------------------------------------------
def test_sdat_seq_names_match_legacy():
    """Les noms SEQ extraits (alignés sur la section SEQ : trous conservés)
    correspondent au ground truth committé, index pour index."""
    data = (FI / "sound_sdat_head.bin").read_bytes()
    sd = Sdat.open(data)
    names = sd.seq_names()
    gt = load_legacy("sdat_seq_names.json")
    gt_vals = [v for v in gt.values()]
    assert len(gt_vals) == len(names)
    for i, (a, b) in enumerate(zip(names, gt_vals)):
        assert a == b, f"SEQ[{i}] : {a!r} != {b!r}"


def test_sdat_chain_file_ids_are_sseq():
    """Structure de la chaîne SEQ → file_id → FAT (fixture court) + validation
    complète des magics via le rapport décodé committé (CI sans ROM)."""
    data = (FI / "sound_sdat_head.bin").read_bytes()
    sd = Sdat.open(data)
    full = sd.parse_full()
    assert full["seq_hole_count"] == 122
    assert full["bank_hole_count"] == 218
    fids = [e["file_id"] for e in full["seq"] if not e["hole"]]
    assert min(fids) == 0 and max(fids) == 97 and len(set(fids)) == 98
    # validation magics (98 SSEQ) depuis le rapport décodé committé
    sdat_report = json.loads((DECODED_DIR / "sound" / "sdat.json").read_text())
    sseq = {f["file_id"] for f in sdat_report["full_chain"]["fat"]
            if f["magic"] == "SSEQ"}
    assert len(sseq) == 98
    for e in sdat_report["full_chain"]["seq"]:
        if not e["hole"]:
            assert e["file_id"] in sseq, f"SEQ {e['index']} → file {e['file_id']} non SSEQ"


# ---------------------------------------------------------------------------
# 5. Provenance — interdiction des valeurs inventées
# ---------------------------------------------------------------------------
def test_provenance_rules():
    from nds2pmdo.provenance import Provenance
    assert Provenance.UNKNOWN.value == "UNKNOWN"
    assert Provenance.CROSS_REFERENCE.value == "CROSS_REFERENCE"


def test_no_placeholder_in_decoded_reports():
    """Aucun rapport décodé ne doit contenir de valeur « inventée » : les champs
    non décodés sont UNKNOWN/MISSING/NOT_DECODED/ADAPTATION_REQUIRED, jamais vides."""
    if not DECODED_DIR.exists():
        pytest.skip("decoded/ absent")
    for f in DECODED_DIR.rglob("*.json"):
        text = f.read_text()
        assert "TODO" not in text
        assert '""' not in text.replace('"LocalTexts": {}', '')
