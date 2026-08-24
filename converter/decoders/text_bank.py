"""Text bank decoder — placeholder.

PMD Red stores dialogue strings in per-language banks referenced by
16-bit ids. The decoder will surface only the string IDs and the
character encoding table needed to convert user-facing text into UTF-8
for PMDO Strings/*.resx. Any actual text extracted from the user's ROM
stays under converter/rom_output/ (git-ignored) and is only merged
into Strings/ at s05_emit under the user's own responsibility.
"""
from __future__ import annotations


def decode(blob: bytes, *, rom_offset: int, rom_sha256: str, language: str):
    raise NotImplementedError(
        f"Text bank decoder not implemented yet (language={language})."
    )
