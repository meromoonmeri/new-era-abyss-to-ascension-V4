#!/usr/bin/env python3
"""Focused tests for the shared early-dungeon serializer."""

from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from pmdred_early_dungeon import append_index_entries


class IndexAppendTests(unittest.TestCase):
    def test_preserves_compact_history_and_absent_final_newline(self) -> None:
        before = '{\n"Version": "0.8.9.0",\n"Object": {\n"old": {\n"Name": "kept"\n}\n}\n}'
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "index.idx"
            path.write_text(before, encoding="utf-8")
            append_index_entries(path, {"new": {"Name": "ajouté"}})
            after = path.read_text(encoding="utf-8")
            self.assertTrue(after.startswith(before[:-4]))
            self.assertFalse(after.endswith("\n"))
            self.assertEqual(json.loads(after)["Object"]["old"], {"Name": "kept"})
            self.assertEqual(json.loads(after)["Object"]["new"], {"Name": "ajouté"})

    def test_preserves_bom_indented_history_and_rejects_duplicate(self) -> None:
        before = b"\xef\xbb\xbf" + b'{\n  "Version": "0.8.12.0",\n  "Object": {\n    "old": {\n      "Name": "kept"\n    }\n  }\n}'
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "index.idx"
            path.write_bytes(before)
            append_index_entries(path, {"new": {"Name": "new"}})
            after = path.read_bytes()
            self.assertTrue(after.startswith(b"\xef\xbb\xbf" + before[3:-6]))
            self.assertEqual(json.loads(after.decode("utf-8-sig"))["Object"]["old"], {"Name": "kept"})
            with self.assertRaises(FileExistsError):
                append_index_entries(path, {"new": {"Name": "replacement"}})


if __name__ == "__main__":
    unittest.main()
