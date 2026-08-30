"""PMU Map Catalog and Search.
Allows browsing, filtering, and querying all recoverable maps in the PMU database.
"""
from __future__ import annotations

import json
import sqlite3
from pathlib import Path
from typing import Any

from .constants import PMU_TILE_SIZE, TILE_TYPES
from .extractor import normalize_map_id


class PMUCatalog:
    def __init__(self, db_path: Path, repo_root: Path | None = None):
        self.db_path = Path(db_path)
        self.repo_root = Path(repo_root) if repo_root else self.db_path.parent.parent.parent

    def get_connection(self) -> sqlite3.Connection:
        con = sqlite3.connect(self.db_path)
        con.row_factory = sqlite3.Row
        return con

    def list_maps(
        self,
        query: str | None = None,
        limit: int = 50,
        offset: int = 0,
    ) -> list[dict[str, Any]]:
        """List maps with filtering and status annotations."""
        with self.get_connection() as con:
            cur = con.cursor()
            sql = """
                SELECT map_id, name, revision, max_x, max_y, moral, music, weather, indoors,
                       (SELECT COUNT(*) FROM map_npcs n WHERE n.map_id = m.map_id) as npc_count,
                       (SELECT COUNT(*) FROM tiles t WHERE t.map_id = m.map_id AND t.type = 2) as warp_count,
                       (SELECT COUNT(*) FROM tiles t WHERE t.map_id = m.map_id AND t.type = 1) as blocked_count,
                       (SELECT COUNT(*) FROM tiles t WHERE t.map_id = m.map_id AND (t.ground_anim != 0 OR t.mask_anim != 0 OR t.mask2_anim != 0 OR t.fringe_anim != 0 OR t.fringe2_anim != 0)) as anim_count
                FROM maps m
            """
            params: list[Any] = []
            if query:
                clean_q = query.strip()
                sql += " WHERE map_id LIKE ? OR name LIKE ? OR music LIKE ?"
                params.extend([f"%{clean_q}%", f"%{clean_q}%", f"%{clean_q}%"])

            sql += " ORDER BY CAST(SUBSTR(map_id, 2) AS INTEGER) LIMIT ? OFFSET ?"
            params.extend([limit, offset])

            cur.execute(sql, params)
            rows = [dict(r) for r in cur.fetchall()]

        # Annotate with filesystem status
        results = []
        for r in rows:
            mid = r["map_id"]
            w = (r["max_x"] + 1)
            h = (r["max_y"] + 1)

            # Check status
            import_dir = self.repo_root / "data/pmu_imports" / mid
            render_dir = self.repo_root / "docs/pmu_maps/renders" / mid
            ground_file = self.repo_root / "Data/Ground" / f"pmu_{mid}.rsground"

            extracted = import_dir.exists() and (import_dir / "pmu_map.json").exists()
            rendered = render_dir.exists() and (render_dir / "original.png").exists()
            converted = ground_file.exists() and (render_dir / "pmdo.png").exists()
            approved = import_dir.exists() and (import_dir / "pmdo_manifest.json").exists()

            results.append({
                "map_id": mid,
                "name": r["name"] or "Unnamed",
                "revision": r["revision"],
                "dimensions_tiles": [w, h],
                "dimensions_px": [w * PMU_TILE_SIZE, h * PMU_TILE_SIZE],
                "warps_count": r["warp_count"],
                "npcs_count": r["npc_count"],
                "blocked_count": r["blocked_count"],
                "animated_tiles_count": r["anim_count"],
                "music": r["music"],
                "indoors": r["indoors"] == "1",
                "status": {
                    "extracted": extracted,
                    "rendered": rendered,
                    "converted_pmdo": converted,
                    "approved": approved,
                },
            })
        return results

    def get_map_summary(self, map_id: str | int) -> dict[str, Any] | None:
        """Get full single-map summary."""
        mid = normalize_map_id(map_id)
        results = self.list_maps(query=mid, limit=1)
        for res in results:
            if res["map_id"] == mid:
                return res
        return None

    def get_total_count(self) -> int:
        with self.get_connection() as con:
            cur = con.cursor()
            cur.execute("SELECT COUNT(*) FROM maps")
            return cur.fetchone()[0]
