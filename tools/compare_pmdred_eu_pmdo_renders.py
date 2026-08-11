#!/usr/bin/env python3
"""Decode and compare exact PMDO Ground screenshots with PMD Red EU PNG/APNG.

This intentionally uses only Python's standard library.  PMDO emits RGBA PNGs,
while the ROM evidence uses RGB PNG/APNG, so both inputs are normalized to
composited 8-bit RGBA pixels before comparison.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import struct
import zlib
from dataclasses import dataclass
from pathlib import Path
from typing import Any

PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"
COLOR_CHANNELS = {0: 1, 2: 3, 3: 1, 4: 2, 6: 4}


@dataclass(frozen=True)
class Frame:
    width: int
    height: int
    rgba: bytes
    delay_num: int = 0
    delay_den: int = 100


@dataclass(frozen=True)
class FrameControl:
    width: int
    height: int
    x: int
    y: int
    delay_num: int
    delay_den: int
    dispose: int
    blend: int


def chunks(data: bytes) -> list[tuple[bytes, bytes]]:
    if not data.startswith(PNG_SIGNATURE):
        raise ValueError("not a PNG file")
    result: list[tuple[bytes, bytes]] = []
    offset = len(PNG_SIGNATURE)
    while offset < len(data):
        if offset + 12 > len(data):
            raise ValueError("truncated PNG chunk")
        length = struct.unpack_from(">I", data, offset)[0]
        kind = data[offset + 4 : offset + 8]
        end = offset + 12 + length
        if end > len(data):
            raise ValueError("truncated PNG chunk payload")
        payload = data[offset + 8 : offset + 8 + length]
        expected = struct.unpack_from(">I", data, offset + 8 + length)[0]
        actual = zlib.crc32(kind + payload) & 0xFFFFFFFF
        if actual != expected:
            raise ValueError(f"bad {kind.decode('ascii', 'replace')} CRC")
        result.append((kind, payload))
        offset = end
        if kind == b"IEND":
            break
    if not result or result[-1][0] != b"IEND" or offset != len(data):
        raise ValueError("invalid PNG termination")
    return result


def paeth(left: int, above: int, upper_left: int) -> int:
    prediction = left + above - upper_left
    dl = abs(prediction - left)
    da = abs(prediction - above)
    du = abs(prediction - upper_left)
    if dl <= da and dl <= du:
        return left
    if da <= du:
        return above
    return upper_left


def unfilter(payload: bytes, width: int, height: int, bytes_per_pixel: int) -> bytes:
    row_bytes = width * bytes_per_pixel
    expected = height * (row_bytes + 1)
    if len(payload) != expected:
        raise ValueError(f"inflated PNG size {len(payload)} != {expected}")
    output = bytearray(height * row_bytes)
    source = 0
    for y in range(height):
        method = payload[source]
        source += 1
        row_start = y * row_bytes
        for x in range(row_bytes):
            raw = payload[source]
            source += 1
            left = output[row_start + x - bytes_per_pixel] if x >= bytes_per_pixel else 0
            above = output[row_start - row_bytes + x] if y else 0
            upper_left = (
                output[row_start - row_bytes + x - bytes_per_pixel]
                if y and x >= bytes_per_pixel
                else 0
            )
            if method == 0:
                value = raw
            elif method == 1:
                value = raw + left
            elif method == 2:
                value = raw + above
            elif method == 3:
                value = raw + ((left + above) // 2)
            elif method == 4:
                value = raw + paeth(left, above, upper_left)
            else:
                raise ValueError(f"unsupported PNG filter {method}")
            output[row_start + x] = value & 0xFF
    return bytes(output)


def to_rgba(
    raw: bytes,
    color_type: int,
    palette: bytes | None,
    transparency: bytes | None,
) -> bytes:
    output = bytearray()
    if color_type == 6:
        return raw
    if color_type == 2:
        transparent_rgb = None
        if transparency is not None:
            if len(transparency) != 6:
                raise ValueError("invalid truecolor tRNS")
            transparent_rgb = tuple(value >> 8 for value in struct.unpack(">HHH", transparency))
        for index in range(0, len(raw), 3):
            rgb = tuple(raw[index : index + 3])
            output.extend(rgb)
            output.append(0 if rgb == transparent_rgb else 255)
    elif color_type == 0:
        transparent_gray = None
        if transparency is not None:
            if len(transparency) != 2:
                raise ValueError("invalid grayscale tRNS")
            transparent_gray = struct.unpack(">H", transparency)[0] >> 8
        for gray in raw:
            output.extend((gray, gray, gray, 0 if gray == transparent_gray else 255))
    elif color_type == 4:
        for index in range(0, len(raw), 2):
            gray, alpha = raw[index : index + 2]
            output.extend((gray, gray, gray, alpha))
    elif color_type == 3:
        if palette is None or len(palette) % 3:
            raise ValueError("indexed PNG has no valid palette")
        for entry in raw:
            start = entry * 3
            if start + 3 > len(palette):
                raise ValueError("PNG palette index out of bounds")
            output.extend(palette[start : start + 3])
            output.append(transparency[entry] if transparency and entry < len(transparency) else 255)
    else:
        raise ValueError(f"unsupported PNG color type {color_type}")
    return bytes(output)


def decode_region(
    compressed: bytes,
    width: int,
    height: int,
    color_type: int,
    palette: bytes | None,
    transparency: bytes | None,
) -> bytes:
    channels = COLOR_CHANNELS.get(color_type)
    if channels is None:
        raise ValueError(f"unsupported PNG color type {color_type}")
    raw = zlib.decompress(compressed)
    return to_rgba(unfilter(raw, width, height, channels), color_type, palette, transparency)


def alpha_over(source: bytes, destination: bytes) -> bytes:
    source_alpha = source[3]
    if source_alpha == 255:
        return source
    if source_alpha == 0:
        return destination
    destination_alpha = destination[3]
    output_alpha_numerator = source_alpha * 255 + destination_alpha * (255 - source_alpha)
    if output_alpha_numerator == 0:
        return b"\0\0\0\0"
    result = bytearray(4)
    for channel in range(3):
        numerator = (
            source[channel] * source_alpha * 255
            + destination[channel] * destination_alpha * (255 - source_alpha)
        )
        result[channel] = (numerator + output_alpha_numerator // 2) // output_alpha_numerator
    result[3] = (output_alpha_numerator + 127) // 255
    return bytes(result)


def decode_png(path: Path) -> list[Frame]:
    records = chunks(path.read_bytes())
    if records[0][0] != b"IHDR" or len(records[0][1]) != 13:
        raise ValueError("missing PNG IHDR")
    width, height, depth, color_type, compression, filtering, interlace = struct.unpack(
        ">IIBBBBB", records[0][1]
    )
    if depth != 8 or compression or filtering or interlace:
        raise ValueError("only non-interlaced 8-bit PNG/APNG is supported")
    palette = next((payload for kind, payload in records if kind == b"PLTE"), None)
    transparency = next((payload for kind, payload in records if kind == b"tRNS"), None)

    default_data = bytearray()
    controls: list[FrameControl] = []
    frame_data: list[bytearray] = []
    active = -1
    for kind, payload in records[1:]:
        if kind == b"fcTL":
            if len(payload) != 26:
                raise ValueError("invalid APNG fcTL")
            _, fw, fh, x, y, num, den, dispose, blend = struct.unpack(">IIIIIHHBB", payload)
            if not fw or not fh or x + fw > width or y + fh > height:
                raise ValueError("APNG frame outside canvas")
            if dispose > 2 or blend > 1:
                raise ValueError("unsupported APNG frame operation")
            controls.append(FrameControl(fw, fh, x, y, num, den or 100, dispose, blend))
            frame_data.append(bytearray())
            active += 1
        elif kind == b"IDAT":
            if active >= 0:
                frame_data[active].extend(payload)
            else:
                default_data.extend(payload)
        elif kind == b"fdAT":
            if active < 0 or len(payload) < 4:
                raise ValueError("APNG fdAT without frame control")
            frame_data[active].extend(payload[4:])

    if not controls:
        if not default_data:
            raise ValueError("PNG has no image data")
        rgba = decode_region(bytes(default_data), width, height, color_type, palette, transparency)
        return [Frame(width, height, rgba)]

    canvas = bytearray(width * height * 4)
    frames: list[Frame] = []
    for control, compressed in zip(controls, frame_data):
        if not compressed:
            raise ValueError("APNG frame has no image data")
        region = decode_region(
            bytes(compressed), control.width, control.height, color_type, palette, transparency
        )
        previous = bytes(canvas) if control.dispose == 2 else None
        for y in range(control.height):
            for x in range(control.width):
                source_at = (y * control.width + x) * 4
                target_at = ((control.y + y) * width + control.x + x) * 4
                source = region[source_at : source_at + 4]
                if control.blend == 0:
                    canvas[target_at : target_at + 4] = source
                else:
                    canvas[target_at : target_at + 4] = alpha_over(
                        source, bytes(canvas[target_at : target_at + 4])
                    )
        frames.append(
            Frame(width, height, bytes(canvas), control.delay_num, control.delay_den)
        )
        if control.dispose == 1:
            for y in range(control.height):
                start = ((control.y + y) * width + control.x) * 4
                canvas[start : start + control.width * 4] = b"\0" * (control.width * 4)
        elif control.dispose == 2:
            assert previous is not None
            canvas[:] = previous
    return frames


def png_chunk(kind: bytes, payload: bytes) -> bytes:
    return (
        struct.pack(">I", len(payload))
        + kind
        + payload
        + struct.pack(">I", zlib.crc32(kind + payload) & 0xFFFFFFFF)
    )


def encode_rgba(path: Path, width: int, height: int, rgba: bytes) -> None:
    if len(rgba) != width * height * 4:
        raise ValueError("invalid RGBA buffer length")
    scanlines = b"".join(
        b"\0" + rgba[y * width * 4 : (y + 1) * width * 4] for y in range(height)
    )
    content = bytearray(PNG_SIGNATURE)
    content.extend(png_chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0)))
    content.extend(png_chunk(b"IDAT", zlib.compress(scanlines, 9)))
    content.extend(png_chunk(b"IEND", b""))
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(content)


def comparative_canvas(expected: Frame, actual: Frame, gap: int = 8) -> tuple[int, int, bytes]:
    if (expected.width, expected.height) != (actual.width, actual.height):
        raise ValueError("cannot montage frames with different dimensions")
    width = expected.width * 2 + gap
    height = expected.height
    output = bytearray((48, 48, 48, 255) * (width * height))
    for y in range(height):
        left = y * width * 4
        source = y * expected.width * 4
        output[left : left + expected.width * 4] = expected.rgba[source : source + expected.width * 4]
        right = left + (expected.width + gap) * 4
        output[right : right + actual.width * 4] = actual.rgba[source : source + actual.width * 4]
    return width, height, bytes(output)


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def compare(expected: Frame, actual: Frame) -> dict[str, Any]:
    dimensions_match = (expected.width, expected.height) == (actual.width, actual.height)
    mismatch_count = None
    maximum_channel_delta = None
    opaque = all(actual.rgba[index] == 255 for index in range(3, len(actual.rgba), 4))
    if dimensions_match:
        mismatch_count = sum(
            expected.rgba[index : index + 4] != actual.rgba[index : index + 4]
            for index in range(0, len(expected.rgba), 4)
        )
        maximum_channel_delta = max(
            (abs(left - right) for left, right in zip(expected.rgba, actual.rgba)), default=0
        )
    return {
        "dimensions_match": dimensions_match,
        "expected_dimensions": [expected.width, expected.height],
        "actual_dimensions": [actual.width, actual.height],
        "expected_rgba_sha256": sha256(expected.rgba),
        "actual_rgba_sha256": sha256(actual.rgba),
        "mismatched_pixels": mismatch_count,
        "maximum_channel_delta": maximum_channel_delta,
        "actual_fully_opaque": opaque,
        "exact": dimensions_match and mismatch_count == 0,
    }


def read_events(events_path: Path) -> list[dict[str, Any]]:
    return [
        json.loads(line) for line in events_path.read_text().splitlines() if line.strip()
    ]


def run(args: argparse.Namespace) -> int:
    events = read_events(args.events)
    completed = [event for event in events if event.get("event") == "screenshot_completed"]
    screenshots = sorted(
        (path for path in args.screenshots.iterdir() if path.suffix.lower() == ".png" and path.stat().st_size),
        key=lambda path: (path.stat().st_mtime_ns, path.name),
    )
    if len(completed) != len(screenshots):
        raise ValueError(
            f"{len(completed)} completed screenshot events but {len(screenshots)} PNG files"
        )

    reference_cache: dict[str, tuple[list[int], list[Frame]]] = {}
    records: list[dict[str, Any]] = []
    for event, screenshot in zip(completed, screenshots):
        asset = event["ground"]
        phase = event["phase"]
        if not phase.startswith("tick_"):
            raise ValueError(f"unexpected screenshot phase {phase}")
        tick = int(phase.removeprefix("tick_"))
        if asset not in reference_cache:
            directory = args.references / asset
            metadata = json.loads((directory / "animation.json").read_text())
            ticks = metadata["preview"]["frame_start_ticks"]
            frames = decode_png(directory / "animation.png")
            if len(ticks) != len(frames):
                raise ValueError(f"{asset}: preview tick/frame count mismatch")
            reference_cache[asset] = (ticks, frames)
        ticks, frames = reference_cache[asset]
        if tick not in ticks:
            raise ValueError(f"{asset}: tick {tick} absent from canonical preview")
        expected = frames[ticks.index(tick)]
        actual_frames = decode_png(screenshot)
        if len(actual_frames) != 1:
            raise ValueError(f"{screenshot}: PMDO screenshot unexpectedly animated")
        actual = actual_frames[0]
        result = compare(expected, actual)
        result.update({
            "ground": asset,
            "tick": tick,
            "source_screenshot": str(screenshot),
        })
        if args.output is not None and (tick == ticks[0] or tick == ticks[-1]):
            suffix = "tick0" if tick == ticks[0] else f"tick{tick}"
            destination = args.output / asset / f"comparison_{suffix}.png"
            width, height, rgba = comparative_canvas(expected, actual)
            encode_rgba(destination, width, height, rgba)
            result["comparative_png"] = str(destination)
        records.append(result)

    ground_count = len({record["ground"] for record in records})
    exact_count = sum(record["exact"] for record in records)
    opaque_count = sum(record["actual_fully_opaque"] for record in records)
    validations = [event for event in events if "verdict" in event]
    cleanups = [
        event for event in events
        if event.get("event") in {"ground_exit", "final_cleanup"}
    ]
    entered = [event for event in events if event.get("event") == "ground_entered"]
    all_runtime_safe = bool(validations) and all(
        event.get("verdict") == "SAFE"
        and event.get("load") == "LOAD_PASS"
        and event.get("movement_probe") == "MOVEMENT_PASS"
        and event.get("animation_probe") == "ANIMATION_SAMPLED_LIFECYCLE_PASS"
        for event in validations
    )
    all_cleanups_pass = (
        all(event.get("cleanup") == "PASS" for event in cleanups)
        if cleanups else None
    )
    entered_ids = [event.get("ground") for event in entered]
    validation_ids = [event.get("ground") for event in validations]
    expected_samples = [
        (event.get("ground"), tick)
        for event in validations
        for tick in event.get("sampled_ticks", [])
    ]
    actual_samples = [(record["ground"], record["tick"]) for record in records]
    runtime_sequence_consistent = (
        entered_ids == validation_ids and expected_samples == actual_samples
    )
    reentry_count = sum(
        current == previous
        for previous, current in zip(entered_ids, entered_ids[1:])
    )
    report = {
        "schema": 1,
        "decoder": "dependency-free PNG/APNG, 8-bit non-interlaced, CRC-checked",
        "ground_count": ground_count,
        "grounds": sorted({record["ground"] for record in records}),
        "sample_count": len(records),
        "exact_sample_count": exact_count,
        "fully_opaque_sample_count": opaque_count,
        "all_exact": exact_count == len(records),
        "all_fully_opaque": opaque_count == len(records),
        "runtime": {
            "validation_count": len(validations),
            "ground_entry_count": len(entered),
            "inter_entry_transition_count": max(0, len(entered) - 1),
            "observed_ground_exit_count": sum(
                event.get("event") == "ground_exit" for event in events
            ),
            "same_ground_reentry_count": reentry_count,
            "cleanup_probe_count": len(cleanups),
            "all_runtime_safe": all_runtime_safe,
            "runtime_sequence_consistent": runtime_sequence_consistent,
            "all_cleanups_pass": all_cleanups_pass,
            "end_event_seen": any(event.get("event") == "end" for event in events),
            "validations": validations,
            "cleanups": cleanups,
        },
        "samples": records,
    }
    report_path = args.report or (
        args.output / "report.json" if args.output is not None else Path("pmdred_eu_render_report.json")
    )
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, indent=2) + "\n")
    print(
        f"{ground_count} Grounds, {len(records)} sampled ticks, "
        f"{exact_count} pixel-exact, {opaque_count} fully opaque"
    )
    print(report_path)
    return 0 if (
        report["all_exact"]
        and report["all_fully_opaque"]
        and all_runtime_safe
        and runtime_sequence_consistent
        and all_cleanups_pass is not False
        and report["runtime"]["end_event_seen"]
    ) else 1


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser()
    result.add_argument("--screenshots", type=Path, required=True)
    result.add_argument("--events", type=Path, required=True)
    result.add_argument(
        "--references", type=Path,
        default=Path("docs/pmdred_eu/dungeon_grounds"),
    )
    result.add_argument("--output", type=Path)
    result.add_argument("--report", type=Path)
    return result


def main() -> int:
    return run(parser().parse_args())


if __name__ == "__main__":
    raise SystemExit(main())
