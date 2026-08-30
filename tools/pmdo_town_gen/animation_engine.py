<<<<<<< HEAD
"""Multi-Frame Animation & .dir Binary Compiler for PMDO Town Engine.

Handles multi-frame animated game objects (waterfalls, river ripples, campfires,
waterwheels, smoking chimneys) with frame-perfect dimension alignment and zero jitter.
Compiles to native PMDO .dir format: [uint64 png_len] + [PNG byte stream] + [tail: w, h, offset, frame_count].
"""
=======
"""Multi-frame animation and .dir format compiler for PMDO / RogueEssence."""
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
from __future__ import annotations

import io
import struct
<<<<<<< HEAD
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from PIL import Image, ImageDraw


@dataclass
class AnimatedAsset:
    """Represents a multi-frame animated PMDO entity."""
    asset_id: str
    category: str
    frame_width: int
    frame_height: int
    frame_count: int
    frames: List[Image.Image]  # Individual RGBA frames
    dir_path: Optional[str] = None


class AnimationEngine:
    """Generates, normalizes, and compiles multi-frame animation sequences for PMDO."""
=======
from pathlib import Path
from typing import List, Optional, Tuple
from PIL import Image, ImageDraw


class AnimationEngine:
    """Compiles multi-frame animated sprites into native RogueEssence .dir files."""
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)

    def __init__(self, project_root: Optional[Path] = None):
        self.project_root = project_root or Path(__file__).resolve().parents[2]
        self.output_dir = self.project_root / "Content/Object"
        self.output_dir.mkdir(parents=True, exist_ok=True)
<<<<<<< HEAD
        self.cache: Dict[str, AnimatedAsset] = {}

    def compile_to_dir_format(
        self,
        frames: List[Image.Image],
        frame_width: int,
        frame_height: int,
        output_path: Path,
    ) -> bytes:
        """Compiles a sequence of PIL frames into the native PMDO .dir binary format."""
        frame_count = len(frames)
        assert frame_count > 0, "Animation must contain at least one frame."

        # Create horizontal strip containing all frames side-by-side
        total_width = frame_width * frame_count
        strip_img = Image.new("RGBA", (total_width, frame_height), (0, 0, 0, 0))

        for idx, frame in enumerate(frames):
            # Normalize frame to exact frame dimensions
            norm_frame = frame.convert("RGBA")
            if norm_frame.size != (frame_width, frame_height):
                norm_frame = norm_frame.resize((frame_width, frame_height), Image.Resampling.NEAREST)
            strip_img.paste(norm_frame, (idx * frame_width, 0))

        # Save strip as PNG bytes in memory
        png_buffer = io.BytesIO()
        strip_img.save(png_buffer, format="PNG", optimize=True)
        png_bytes = png_buffer.getvalue()
        png_len = len(png_bytes)

        # Build PMDO .dir binary buffer:
        # 1. 8-byte header: uint64(png_len)
        header = struct.pack("<Q", png_len)
        # 2. 16-byte tail: uint32 frame_w, uint32 frame_h, uint32 offset(0), uint32 frame_count
        tail = struct.pack("<IIII", frame_width, frame_height, 0, frame_count)

        dir_data = header + png_bytes + tail

        # Write to file
        output_path.parent.mkdir(parents=True, exist_ok=True)
        with open(output_path, "wb") as f:
            f.write(dir_data)

        return dir_data
=======

    def compile_dir_file(
        self,
        frame_strip: Image.Image,
        frame_width: int,
        frame_height: int,
        frame_count: int,
        output_path: Path,
    ) -> Path:
        """Encodes horizontal frame strip into PMDO .dir format (PNG data + 16B footer)."""
        png_io = io.BytesIO()
        frame_strip.save(png_io, format="PNG")
        png_bytes = png_io.getvalue()

        # Footer: 16 bytes: [frame_width (i32), frame_height (i32), offset (i32), frame_count (i32)]
        footer = struct.pack("<iiii", frame_width, frame_height, 0, frame_count)
        payload_len = len(png_bytes)
        header = struct.pack("<q", payload_len)

        with open(output_path, "wb") as f:
            f.write(header)
            f.write(png_bytes)
            f.write(footer)

        return output_path
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)

    def create_waterfall_animation(
        self,
        width: int = 48,
        height: int = 72,
        frame_count: int = 4,
        asset_id: str = "waterfall_cascade",
<<<<<<< HEAD
    ) -> AnimatedAsset:
        """Generates a 4-frame top-down PMD waterfall animation with foaming rapids."""
        frames: List[Image.Image] = []
        c_deep = (95, 183, 207, 255)
        c_mid = (131, 218, 230, 255)
        c_foam = (245, 250, 255, 255)
        c_spray = (210, 240, 255, 200)

        for f_idx in range(frame_count):
            frame = Image.new("RGBA", (width, height), (0, 0, 0, 0))
            draw = ImageDraw.Draw(frame)

            # 1. Base water column
            draw.rectangle([(6, 0), (width - 7, height - 1)], fill=c_deep)

            # 2. Vertical cascading streaks (moving downward with frame index)
            for x in range(8, width - 8, 4):
                streak_phase = (f_idx * 6 + (x * 7)) % height
                draw.line([(x, 0), (x, height - 1)], fill=c_mid, width=2)
                # White foam highlights cascading down
                draw.line([(x, streak_phase), (x, min(height - 1, streak_phase + 14))], fill=c_foam, width=2)

            # 3. Top crest overflow
            draw.rectangle([(4, 0), (width - 5, 8)], fill=c_foam)

            # 4. Bottom impact pool foam & spray waves
            pool_y = height - 16
            draw.ellipse([(2, pool_y), (width - 3, height - 1)], fill=c_foam)
            draw.ellipse([(6, pool_y + 4), (width - 7, height - 4)], fill=c_mid)

            # Shifting foam bubbles
            for bx in range(6, width - 6, 8):
                bubble_y = pool_y + ((f_idx * 3 + bx) % 10)
                draw.ellipse([(bx, bubble_y), (bx + 3, bubble_y + 3)], fill=c_spray)

            frames.append(frame)

        out_path = self.output_dir / f"{asset_id}.dir"
        self.compile_to_dir_format(frames, width, height, out_path)

        asset = AnimatedAsset(
            asset_id=asset_id,
            category="waterfall",
            frame_width=width,
            frame_height=height,
            frame_count=frame_count,
            frames=frames,
            dir_path=str(out_path),
        )
        self.cache[asset_id] = asset
        return asset
=======
    ) -> Path:
        """Generates dynamic 4-frame animated waterfall cascade."""
        strip_w = width * frame_count
        strip_h = height
        strip = Image.new("RGBA", (strip_w, strip_h), (0, 0, 0, 0))
        draw = ImageDraw.Draw(strip)

        foam_colors = [
            (225, 245, 255, 255),
            (195, 230, 255, 255),
            (160, 215, 255, 255),
            (120, 190, 245, 255),
        ]

        for frame in range(frame_count):
            fx = frame * width
            # Draw torrent streams
            for x in range(fx, fx + width, 4):
                phase = (frame * 6 + (x - fx) * 3) % 24
                # Water columns
                draw.line([(x, 0), (x, height)], fill=(75, 145, 220, 255), width=3)
                draw.line([(x + 1, phase), (x + 1, min(height, phase + 14))], fill=foam_colors[frame % 4], width=2)
                draw.line([(x + 2, (phase + 12) % height), (x + 2, min(height, (phase + 26) % height))], fill=foam_colors[(frame + 2) % 4], width=2)

            # Plunge splash foam at bottom
            draw.ellipse([fx, height - 16, fx + width, height + 4], fill=(240, 250, 255, 255))
            draw.ellipse([fx + 4, height - 12, fx + width - 4, height], fill=(210, 235, 255, 255))

        out_path = self.output_dir / f"{asset_id}.dir"
        return self.compile_dir_file(strip, width, height, frame_count, out_path)
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)

    def create_river_ripple_animation(
        self,
        width: int = 24,
        height: int = 24,
        frame_count: int = 4,
        asset_id: str = "river_shimmer",
<<<<<<< HEAD
    ) -> AnimatedAsset:
        """Generates a 4-frame seamless river shimmer and ripple animation."""
        frames: List[Image.Image] = []
        c_water = (95, 183, 207, 255)
        c_ripple = (145, 230, 245, 240)
        c_highlight = (235, 250, 255, 220)

        for f_idx in range(frame_count):
            frame = Image.new("RGBA", (width, height), (0, 0, 0, 0))
            draw = ImageDraw.Draw(frame)

            offset = (f_idx * (height // frame_count)) % height

            # Draw curved ripple bands drifting downstream
            for r_y in (offset, (offset + height // 2) % height):
                draw.arc([(2, r_y - 4), (width - 3, r_y + 4)], start=0, end=180, fill=c_ripple, width=1)
                draw.line([(width // 3, r_y), (2 * width // 3, r_y)], fill=c_highlight, width=1)

            frames.append(frame)

        out_path = self.output_dir / f"{asset_id}.dir"
        self.compile_to_dir_format(frames, width, height, out_path)

        asset = AnimatedAsset(
            asset_id=asset_id,
            category="water_ripple",
            frame_width=width,
            frame_height=height,
            frame_count=frame_count,
            frames=frames,
            dir_path=str(out_path),
        )
        self.cache[asset_id] = asset
        return asset
=======
    ) -> Path:
        """Generates 4-frame river surface ripple animation."""
        strip = Image.new("RGBA", (width * frame_count, height), (0, 0, 0, 0))
        draw = ImageDraw.Draw(strip)

        for frame in range(frame_count):
            fx = frame * width
            y_shift = frame * 3
            draw.line([(fx + 3, (6 + y_shift) % height), (fx + 12, (6 + y_shift) % height)], fill=(160, 220, 255, 200), width=1)
            draw.line([(fx + 10, (14 + y_shift) % height), (fx + 21, (14 + y_shift) % height)], fill=(160, 220, 255, 200), width=1)
            draw.point((fx + 16, (9 + y_shift) % height), fill=(255, 255, 255, 230))

        out_path = self.output_dir / f"{asset_id}.dir"
        return self.compile_dir_file(strip, width, height, frame_count, out_path)
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)

    def create_campfire_animation(
        self,
        width: int = 36,
        height: int = 36,
        frame_count: int = 4,
<<<<<<< HEAD
        asset_id: str = "Campfire_custom",
    ) -> AnimatedAsset:
        """Generates a 4-frame campfire animation matching PMDO Campfire.dir spec."""
        frames: List[Image.Image] = []
        c_wood = (112, 72, 40, 255)
        c_ember = (255, 100, 20, 255)
        c_fire_core = (255, 240, 80, 255)
        c_flame_tip = (240, 60, 20, 240)

        cx, cy = width // 2, height // 2 + 4

        for f_idx in range(frame_count):
            frame = Image.new("RGBA", (width, height), (0, 0, 0, 0))
            draw = ImageDraw.Draw(frame)

            # Wood logs
            draw.line([(cx - 10, cy + 4), (cx + 10, cy + 4)], fill=c_wood, width=3)
            draw.line([(cx - 8, cy + 8), (cx + 8, cy)], fill=c_wood, width=2)
            draw.line([(cx - 8, cy), (cx + 8, cy + 8)], fill=c_wood, width=2)

            # Glowing ember bed
            draw.ellipse([(cx - 6, cy - 2), (cx + 6, cy + 6)], fill=c_ember)

            # Shifting flame tongue
            f_height = 12 + (f_idx % 2) * 3
            flame_tip_x = cx + ((f_idx * 3) % 5) - 2
            draw.polygon([
                (cx - 5, cy + 2),
                (cx + 5, cy + 2),
                (flame_tip_x, cy - f_height),
            ], fill=c_flame_tip)

            # Bright yellow core
            draw.polygon([
                (cx - 3, cy + 1),
                (cx + 3, cy + 1),
                (cx, cy - f_height + 5),
            ], fill=c_fire_core)

            frames.append(frame)

        out_path = self.output_dir / f"{asset_id}.dir"
        self.compile_to_dir_format(frames, width, height, out_path)

        asset = AnimatedAsset(
            asset_id=asset_id,
            category="campfire",
            frame_width=width,
            frame_height=height,
            frame_count=frame_count,
            frames=frames,
            dir_path=str(out_path),
        )
        self.cache[asset_id] = asset
        return asset
=======
        asset_id: str = "Campfire",
    ) -> Path:
        """Generates 4-frame flickering campfire animation."""
        strip = Image.new("RGBA", (width * frame_count, height), (0, 0, 0, 0))
        draw = ImageDraw.Draw(strip)

        flame_shapes = [
            [(18, 4), (10, 24), (26, 24)],
            [(17, 2), (11, 24), (27, 24)],
            [(19, 5), (9, 24), (25, 24)],
            [(18, 3), (12, 24), (26, 24)],
        ]

        for frame in range(frame_count):
            fx = frame * width
            # Base stone circle
            draw.ellipse([fx + 4, 20, fx + 32, 34], fill=(70, 65, 60, 255), outline=(40, 35, 30, 255))
            # Logs
            draw.line([(fx + 8, 28), (fx + 28, 24)], fill=(100, 60, 30, 255), width=3)
            draw.line([(fx + 10, 24), (fx + 26, 28)], fill=(90, 50, 25, 255), width=3)
            # Flame
            pts = [(fx + x, y) for x, y in flame_shapes[frame]]
            draw.polygon(pts, fill=(255, 100, 20, 255))
            inner_pts = [(fx + x, y + 6) for x, y in flame_shapes[frame]]
            draw.polygon(inner_pts, fill=(255, 220, 50, 255))

        out_path = self.output_dir / f"{asset_id}.dir"
        return self.compile_dir_file(strip, width, height, frame_count, out_path)
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
