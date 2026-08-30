<<<<<<< HEAD
"""Interactive Real-Time Web Viewer for PMDO Town Layout Generator.

Provides live canvas layer toggles, entity inspector, parameter controls,
reference comparison, and PMDO export interface.
"""
from __future__ import annotations

import base64
import http.server
import io
import json
import socketserver
import urllib.parse
from pathlib import Path
from typing import Any, Dict, Optional

from PIL import Image

from .generator import TownGenerator
from .models import BiomeType, SeasonType, TownSpec
from .reference_analyzer import ReferenceAnalyzer
from .renderer import TownRenderer

HTML_TEMPLATE = """<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PMDO Outdoor Town Layout Generator</title>
    <style>
        :root {
            --bg-dark: #1a1e24;
            --panel-bg: #242a34;
            --panel-border: #364050;
            --accent: #4a90e2;
            --accent-green: #50b86c;
            --accent-gold: #f5a623;
            --text-main: #f0f4f8;
            --text-dim: #9aa8b8;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background: var(--bg-dark);
            color: var(--text-main);
            display: flex;
            height: 100vh;
            overflow: hidden;
        }
        #sidebar {
            width: 380px;
            background: var(--panel-bg);
            border-right: 1px solid var(--panel-border);
            display: flex;
            flex-direction: column;
            overflow-y: auto;
            padding: 16px;
            gap: 16px;
        }
        #main-view {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #14171c;
            position: relative;
        }
        .header-bar {
            padding: 12px 20px;
            background: var(--panel-bg);
            border-bottom: 1px solid var(--panel-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .title { font-size: 18px; font-weight: 700; color: #fff; display: flex; align-items: center; gap: 8px; }
        .badge { background: var(--accent); color: #fff; font-size: 11px; font-weight: 700; padding: 2px 8px; border-radius: 12px; }
        .badge.pass { background: var(--accent-green); }
        .canvas-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: auto;
            padding: 24px;
            position: relative;
        }
        canvas {
            box-shadow: 0 12px 36px rgba(0,0,0,0.6);
            border: 2px solid var(--panel-border);
            border-radius: 6px;
            image-rendering: pixelated;
        }
        .section-box {
            background: #1d222b;
            border: 1px solid var(--panel-border);
            border-radius: 8px;
            padding: 14px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .section-title { font-size: 13px; font-weight: 700; text-transform: uppercase; color: var(--text-dim); letter-spacing: 0.5px; }
        .control-row { display: flex; align-items: center; justify-content: space-between; font-size: 13px; }
        .control-row label { color: var(--text-main); }
        input, select {
            background: #2b3340;
            border: 1px solid var(--panel-border);
            color: #fff;
            padding: 6px 10px;
            border-radius: 4px;
            font-size: 13px;
        }
        input[type="number"] { width: 70px; }
        .btn-primary {
            background: var(--accent);
            color: #fff;
            border: none;
            padding: 10px 16px;
            font-weight: 700;
            font-size: 14px;
            border-radius: 6px;
            cursor: pointer;
            transition: 0.15s ease;
        }
        .btn-primary:hover { background: #357abd; }
        .btn-success {
            background: var(--accent-green);
            color: #fff;
            border: none;
            padding: 8px 14px;
            font-weight: 700;
            font-size: 13px;
            border-radius: 6px;
            cursor: pointer;
        }
        .layer-toggles { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
        .layer-btn {
            background: #2b3340;
            border: 1px solid var(--panel-border);
            color: var(--text-dim);
            padding: 8px 10px;
            font-size: 12px;
            font-weight: 600;
            border-radius: 4px;
            cursor: pointer;
            text-align: center;
        }
        .layer-btn.active {
            background: var(--accent);
            color: #fff;
            border-color: var(--accent);
        }
        #inspector {
            font-family: monospace;
            font-size: 12px;
            background: #111418;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #28303d;
            line-height: 1.5;
            color: #7dd3fc;
            min-height: 90px;
        }
        .score-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 6px; font-size: 12px; }
        .score-item { background: #2b3340; padding: 6px 8px; border-radius: 4px; display: flex; justify-content: space-between; }
        .score-val { font-weight: 700; color: var(--accent-green); }
    </style>
</head>
<body>
    <div id="sidebar">
        <div class="title">
            <span>🌿 PMDO Town Gen</span>
            <span class="badge" id="badge-status">VALIDATED</span>
        </div>

        <div class="section-box">
            <div class="section-title">Generation Parameters</div>
            <div class="control-row">
                <label>Biome (Strictly 1)</label>
                <select id="sel-biome">
                    <option value="grassland">Grassland</option>
                    <option value="forest">Forest</option>
                    <option value="coastal">Coastal</option>
                    <option value="mountain">Mountain</option>
                </select>
            </div>
            <div class="control-row">
                <label>Season (Strictly 1)</label>
                <select id="sel-season">
                    <option value="spring">Spring</option>
                    <option value="summer">Summer</option>
                    <option value="autumn">Autumn</option>
                    <option value="winter">Winter</option>
                </select>
            </div>
            <div class="control-row">
                <label>Seed</label>
                <div style="display: flex; gap: 4px;">
                    <input type="number" id="inp-seed" value="184729" style="width: 100px;">
                    <button class="layer-btn" onclick="randomSeed()">🎲</button>
                </div>
            </div>
            <div class="control-row">
                <label>Elevation Levels</label>
                <select id="sel-levels">
                    <option value="2">2 Levels (Terraced)</option>
                    <option value="3">3 Levels (Highland)</option>
                    <option value="1">1 Level (Flat)</option>
                </select>
            </div>
            <div class="control-row">
                <label>River Feature</label>
                <select id="sel-river">
                    <option value="false">No River</option>
                    <option value="true_east">River East</option>
                    <option value="true_west">River West</option>
                </select>
            </div>
            <button class="btn-primary" onclick="generateMap()">⚡ Generate Town</button>
        </div>

        <div class="section-box">
            <div class="section-title">View Mode / Layer Toggles</div>
            <div class="layer-toggles">
                <div class="layer-btn active" id="btn-final" onclick="setLayer('final')">Final</div>
                <div class="layer-btn" id="btn-layout" onclick="setLayer('layout')">Layout</div>
                <div class="layer-btn" id="btn-elevation" onclick="setLayer('elevation')">Elevation</div>
                <div class="layer-btn" id="btn-cliffs" onclick="setLayer('cliffs')">Cliffs</div>
                <div class="layer-btn" id="btn-collision" onclick="setLayer('collision')">Collision</div>
                <div class="layer-btn" id="btn-navigation" onclick="setLayer('navigation')">Navigation</div>
            </div>
        </div>

        <div class="section-box">
            <div class="section-title">Real-Time Tile Inspector</div>
            <div id="inspector">Hover over map to inspect coordinates, elevation, structure parcels, and collision state.</div>
        </div>

        <div class="section-box">
            <div class="section-title">Validation Scoring</div>
            <div class="score-grid" id="score-grid">
                <div class="score-item"><span>Geometry</span><span class="score-val" id="sc-geom">100</span></div>
                <div class="score-item"><span>Connectivity</span><span class="score-val" id="sc-conn">100</span></div>
                <div class="score-item"><span>Collision</span><span class="score-val" id="sc-coll">100</span></div>
                <div class="score-item"><span>Elevation</span><span class="score-val" id="sc-elev">100</span></div>
                <div class="score-item"><span>Stairs</span><span class="score-val" id="sc-stair">100</span></div>
                <div class="score-item"><span>Total Score</span><span class="score-val" id="sc-total" style="color: #60a5fa;">100.0</span></div>
            </div>
        </div>

        <button class="btn-success" onclick="exportPMDO()">📦 Export Native PMDO Bundle</button>
    </div>

    <div id="main-view">
        <div class="header-bar">
            <div id="town-title" style="font-weight: 700; font-size: 15px;">Starter Village (Seed 184729) — 64x48 Tiles</div>
            <div style="display: flex; gap: 8px;">
                <button class="layer-btn" onclick="loadReference('metano')">Metano Town</button>
                <button class="layer-btn" onclick="loadReference('grasstown')">Grasstown</button>
            </div>
        </div>
        <div class="canvas-container">
            <canvas id="mapCanvas" width="1536" height="1152"></canvas>
        </div>
    </div>

    <script>
        let currentLayoutData = null;
        let currentActiveLayer = 'final';
        let layerImages = {};
        const canvas = document.getElementById('mapCanvas');
        const ctx = canvas.getContext('2d');

        function randomSeed() {
            document.getElementById('inp-seed').value = Math.floor(Math.random() * 899999) + 100000;
            generateMap();
        }

        function setLayer(layerName) {
            currentActiveLayer = layerName;
            document.querySelectorAll('.layer-toggles .layer-btn').forEach(btn => {
                btn.classList.toggle('active', btn.id === 'btn-' + layerName);
            });
            drawCanvas();
        }

        async function generateMap() {
            const spec = {
                name: "procedural_town",
                display_name: "Procedural Pokémon Village",
                biome: document.getElementById('sel-biome').value,
                season: document.getElementById('sel-season').value,
                seed: parseInt(document.getElementById('inp-seed').value),
                width: 64,
                height: 48,
                elevation_levels: parseInt(document.getElementById('sel-levels').value),
                has_river: document.getElementById('sel-river').value.startsWith('true'),
                river_side: document.getElementById('sel-river').value.includes('west') ? 'west' : 'east',
            };

            const resp = await fetch('/api/generate', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(spec)
            });
            const data = await resp.json();
            currentLayoutData = data;
            layerImages = data.renders;

            document.getElementById('town-title').innerText = `${spec.display_name} (Seed ${spec.seed}) — ${spec.width}x${spec.height} Tiles`;
            
            // Update validation scores
            const sc = data.validation.score;
            document.getElementById('sc-geom').innerText = sc.geometry;
            document.getElementById('sc-conn').innerText = sc.connectivity;
            document.getElementById('sc-coll').innerText = sc.collision;
            document.getElementById('sc-elev').innerText = sc.elevation;
            document.getElementById('sc-stair').innerText = sc.stairs;
            document.getElementById('sc-total').innerText = data.validation.total_score;

            const badge = document.getElementById('badge-status');
            badge.innerText = data.validation.status;
            badge.className = 'badge ' + (data.validation.status === 'PASS' ? 'pass' : '');

            drawCanvas();
        }

        function drawCanvas() {
            if (!layerImages[currentActiveLayer]) return;
            const img = new Image();
            img.onload = () => {
                canvas.width = img.width;
                canvas.height = img.height;
                ctx.drawImage(img, 0, 0);
            };
            img.src = 'data:image/png;base64,' + layerImages[currentActiveLayer];
        }

        canvas.addEventListener('mousemove', (e) => {
            if (!currentLayoutData) return;
            const rect = canvas.getBoundingClientRect();
            const scaleX = canvas.width / rect.width;
            const scaleY = canvas.height / rect.height;
            const px = (e.clientX - rect.left) * scaleX;
            const py = (e.clientY - rect.top) * scaleY;

            const tilePx = 24;
            const tx = Math.floor(px / tilePx);
            const ty = Math.floor(py / tilePx);

            if (tx >= 0 && tx < currentLayoutData.width && ty >= 0 && ty < currentLayoutData.height) {
                const elev = currentLayoutData.heightmap[tx][ty];
                const collVal = currentLayoutData.collision[tx][ty];
                const collStr = collVal === 0 ? "WALKABLE" : (collVal === 1 ? "BLOCKED" : (collVal === 2 ? "WARP" : "SPECIAL"));
                const terrain = currentLayoutData.terrain[tx][ty];

                // Find structure at coord
                let structName = "None";
                for (let b of currentLayoutData.buildings) {
                    if (tx >= b.x && tx < b.x + b.width && ty >= b.y && ty < b.y + b.height) {
                        structName = `${b.role.toUpperCase()} (${b.instance_id})`;
                        break;
                    }
                }

                document.getElementById('inspector').innerHTML = `
                    <b>Cell (${tx}, ${ty})</b><br>
                    Elevation: Level ${elev}<br>
                    Terrain: ${terrain.toUpperCase()}<br>
                    Collision: <span style="color: ${collVal === 0 ? '#4ade80' : '#f87171'}">${collStr}</span><br>
                    Structure: ${structName}
                `;
            }
        });

        async function exportPMDO() {
            const resp = await fetch('/api/export', { method: 'POST' });
            const data = await resp.json();
            alert(`PMDO Asset Bundle successfully compiled!\\n.rsground: ${data.ground}\\n.tile: ${data.tile}\\nLua controller: ${data.script}`);
        }

        async function loadReference(refName) {
            const resp = await fetch(`/api/reference?name=${refName}`);
            const data = await resp.json();
            alert(`Loaded ${data.name}:\\nSize: ${data.dimensions.width_tiles || data.dimensions.width_cells_8px} tiles\\nElevation Levels: ${data.elevation.levels_count}\\nWalkable Ratio: ${data.metrics.walkable_ratio}`);
        }

        // Initialize on load
        window.onload = generateMap;
    </script>
</body>
</html>
"""


class TownViewerHandler(http.server.BaseHTTPRequestHandler):
    generator = TownGenerator()
    renderer = TownRenderer(tile_size=24)
    analyzer = ReferenceAnalyzer()
    current_layout: Optional[TownLayout] = None

    def log_message(self, format: str, *args: Any) -> None:
        pass  # Suppress default noisy console logs

    def do_GET(self) -> None:
        parsed = urllib.parse.urlparse(self.path)
        if parsed.path in ("/", "/index.html"):
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.end_headers()
            self.wfile.write(HTML_TEMPLATE.encode("utf-8"))
        elif parsed.path == "/api/reference":
            query = urllib.parse.parse_qs(parsed.query)
            ref_name = query.get("name", ["metano"])[0]
            if ref_name == "metano":
                data = self.analyzer.analyze_metano()
            else:
                data = self.analyzer.analyze_grasstown()
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps(data).encode("utf-8"))
        else:
            self.send_response(404)
            self.end_headers()

    def do_POST(self) -> None:
        parsed = urllib.parse.urlparse(self.path)
        content_len = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(content_len).decode("utf-8") if content_len > 0 else "{}"

        if parsed.path == "/api/generate":
            spec_dict = json.loads(body)
            spec = TownSpec.from_dict(spec_dict)
            layout = self.generator.generate(spec)
            TownViewerHandler.current_layout = layout

            # Render all visual passes to base64
            renders = {}
            for pass_name, render_fn in (
                ("final", self.renderer.render_final),
                ("layout", self.renderer.render_layout),
                ("elevation", self.renderer.render_elevation),
                ("cliffs", self.renderer.render_cliffs),
                ("collision", self.renderer.render_collision),
                ("navigation", self.renderer.render_navigation),
            ):
                img = render_fn(layout)
                buf = io.BytesIO()
                img.save(buf, format="PNG")
                renders[pass_name] = base64.b64encode(buf.getvalue()).decode("utf-8")

            resp_data = {
                "width": layout.width,
                "height": layout.height,
                "heightmap": layout.heightmap,
                "collision": layout.collision,
                "terrain": layout.terrain_types,
                "buildings": [
                    {
                        "instance_id": b.instance_id,
                        "role": b.role,
                        "x": b.x,
                        "y": b.y,
                        "width": b.width,
                        "height": b.height,
                        "elevation": b.elevation,
                    }
                    for b in layout.buildings
                ],
                "validation": {
                    "status": layout.validation.status if layout.validation else "PASS",
                    "total_score": layout.validation.score.total_score if layout.validation else 100.0,
                    "score": {
                        "geometry": layout.validation.score.geometry,
                        "connectivity": layout.validation.score.connectivity,
                        "collision": layout.validation.score.collision,
                        "elevation": layout.validation.score.elevation,
                        "stairs": layout.validation.score.stairs,
                    } if layout.validation else {},
                },
                "renders": renders,
            }

            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps(resp_data).encode("utf-8"))

        elif parsed.path == "/api/export":
            if TownViewerHandler.current_layout:
                artifacts = self.generator.exporter.export(TownViewerHandler.current_layout)
                resp = {
                    "ground": str(artifacts["ground"]),
                    "tile": str(artifacts["tile"]),
                    "script": str(artifacts["script"]),
                }
            else:
                resp = {"error": "No layout generated"}
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps(resp).encode("utf-8"))


def run_viewer_server(port: int = 8080) -> None:
    server = socketserver.TCPServer(("0.0.0.0", port), TownViewerHandler)
    server.allow_reuse_address = True
    print(f"PMDO Town Generator Viewer Server running on http://0.0.0.0:{port}")
    server.serve_forever()


if __name__ == "__main__":
    run_viewer_server(8080)
=======
"""Interactive web viewer for PMD & PMDO town layouts."""
from __future__ import annotations

import http.server
import json
import os
import socketserver
from pathlib import Path


def run_viewer_server(port: int = 8080) -> None:
    project_root = Path(__file__).resolve().parents[2]
    web_dir = project_root / "docs/pmu_maps"

    class Handler(http.server.SimpleHTTPRequestHandler):
        def __init__(self, *args, **kwargs):
            super().__init__(*args, directory=str(project_root), **kwargs)

    print(f"Serving PMDO Town Viewer at http://0.0.0.0:{port}")
    with socketserver.TCPServer(("0.0.0.0", port), Handler) as httpd:
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nShutting down server.")
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
