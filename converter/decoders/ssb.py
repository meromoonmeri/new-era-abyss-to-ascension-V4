"""SSB (Scripted Sequence Bytecode) decoder — placeholder.

Ground scripts in PMD Red are compiled from a high-level source
(preserved verbatim under data/scripts/*.inc in pret/pmd-red) into
bytecode packed inside the ROM. The bytecode is a sequence of opcodes:
each opcode has a fixed operand width followed by kind-specific args.

The decoder will:
  1. Split the bytecode into individual opcode records.
  2. Identify known opcodes (PlayMusic, pause, setFlag, waitFlag,
     fadeColorIn, msgEnd, movement, animation, etc.) using the opcode
     table defined in converter/decoders/ssb_opcodes.py (populated from
     the pret macro definitions).
  3. Return a Cinematic_IR with a timeline of Event_IR instances.
  4. Preserve unknown opcodes as UnknownOpcode(bytes, offset) rather
     than dropping them silently.

Current status: not implemented. Raises rather than emitting a fake
scene.
"""
from __future__ import annotations


def decode(blob: bytes, *, rom_offset: int, rom_sha256: str):
    raise NotImplementedError(
        "SSB decoder not implemented yet. Wire the opcode table first "
        "in converter/decoders/ssb_opcodes.py."
    )
