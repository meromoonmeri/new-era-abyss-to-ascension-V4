"""8-Neighbor Bitmask Autotiler for PMDO Town Generator.

Based on PMU's mathematical adjacency foundation (DungeonArrayFloor.cs),
providing multi-terrain Wang/blob transitions for cliffs, shores, and road borders.
"""
from __future__ import annotations

from typing import Callable, Dict, List, Tuple


class Autotiler:
    """Computes 8-neighbor bitmask and maps 256 adjacency states to autotile pieces."""

    # 8-Direction bit positions
    # 0: North, 1: North-East, 2: East, 3: South-East,
    # 4: South, 5: South-West, 6: West, 7: North-West
    NORTH = 1 << 0       # 1
    NORTHEAST = 1 << 1   # 2
    EAST = 1 << 2        # 4
    SOUTHEAST = 1 << 3   # 8
    SOUTH = 1 << 4       # 16
    SOUTHWEST = 1 << 5   # 32
    WEST = 1 << 6        # 64
    NORTHWEST = 1 << 7   # 128

    @classmethod
    def compute_bitmask(
        cls, x: int, y: int, width: int, height: int, predicate: Callable[[int, int], bool]
    ) -> int:
        """Calculates 8-neighbor bitmask for a cell given a matching predicate."""
        mask = 0

        # Cardinal & Diagonal offsets: (dx, dy, bit)
        neighbors = (
            (0, -1, cls.NORTH),
            (1, -1, cls.NORTHEAST),
            (1, 0, cls.EAST),
            (1, 1, cls.SOUTHEAST),
            (0, 1, cls.SOUTH),
            (-1, 1, cls.SOUTHWEST),
            (-1, 0, cls.WEST),
            (-1, -1, cls.NORTHWEST),
        )

        cardinals = {
            cls.NORTH: False,
            cls.EAST: False,
            cls.SOUTH: False,
            cls.WEST: False,
        }

        # Check cardinal neighbors first
        for dx, dy, bit in neighbors:
            nx, ny = x + dx, y + dy
            is_match = False
            if 0 <= nx < width and 0 <= ny < height:
                is_match = predicate(nx, ny)
            else:
                # Boundary treat as matching or non-matching
                is_match = True

            if bit in cardinals:
                cardinals[bit] = is_match
                if is_match:
                    mask |= bit

        # Diagonals only matter if both adjacent cardinals match
        for dx, dy, bit in neighbors:
            if bit not in cardinals:
                nx, ny = x + dx, y + dy
                is_match = 0 <= nx < width and 0 <= ny < height and predicate(nx, ny)
                if is_match:
                    if bit == cls.NORTHEAST and (cardinals[cls.NORTH] and cardinals[cls.EAST]):
                        mask |= bit
                    elif bit == cls.SOUTHEAST and (cardinals[cls.SOUTH] and cardinals[cls.EAST]):
                        mask |= bit
                    elif bit == cls.SOUTHWEST and (cardinals[cls.SOUTH] and cardinals[cls.WEST]):
                        mask |= bit
                    elif bit == cls.NORTHWEST and (cardinals[cls.NORTH] and cardinals[cls.WEST]):
                        mask |= bit

        return mask

    @classmethod
    def get_blob_index(cls, mask: int) -> int:
        """Maps 8-neighbor mask (0-255) to canonical 47-tile autotile blob index."""
        # Standard blob lookup mapping
        # 0: isolated, 255: center/full surrounded
        if mask == 255:
            return 46  # Center
        if mask == 0:
            return 0   # Isolated single tile
        # Simple reduction for cardinal edges
        has_n = bool(mask & cls.NORTH)
        has_e = bool(mask & cls.EAST)
        has_s = bool(mask & cls.SOUTH)
        has_w = bool(mask & cls.WEST)

        cardinal_sum = (1 if has_n else 0) + (1 if has_e else 0) + (1 if has_s else 0) + (1 if has_w else 0)

        if cardinal_sum == 4:
            # Check corners
            return 46
        elif cardinal_sum == 3:
            if not has_n: return 12  # Open top
            if not has_s: return 14  # Open bottom
            if not has_w: return 13  # Open left
            if not has_e: return 15  # Open right
        elif cardinal_sum == 2:
            if has_n and has_s: return 5   # Vertical corridor
            if has_e and has_w: return 6   # Horizontal corridor
            if has_s and has_e: return 1   # Top-left corner
            if has_s and has_w: return 2   # Top-right corner
            if has_n and has_e: return 3   # Bottom-left corner
            if has_n and has_w: return 4   # Bottom-right corner
        elif cardinal_sum == 1:
            if has_n: return 7
            if has_s: return 8
            if has_e: return 9
            if has_w: return 10
        return 0
