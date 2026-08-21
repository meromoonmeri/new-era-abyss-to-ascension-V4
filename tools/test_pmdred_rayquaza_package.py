#!/usr/bin/env python3
"""Static integrity gate for the PMD Red EU Rayquaza dungeon/ground/cinematic package."""
from __future__ import annotations
import hashlib, json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EXPECTED = {
    "Content/Music/PMD Red EU - Sky Tower.ogg": "ce7903580f8b688bf5d5d39ebc6913d260047ff44111ea1860918af33fa800e9",
    "Content/Music/PMD Red EU - Sky Tower Summit.ogg": "61cd209a33fe455a62584983e73bafb9cd365a2bbbe1759d724910a7c6abafe6",
}

def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()

def collect_music(obj):
    out=[]
    if isinstance(obj, dict):
        if "Music" in obj: out.append(obj["Music"])
        for value in obj.values(): out.extend(collect_music(value))
    elif isinstance(obj, list):
        for value in obj: out.extend(collect_music(value))
    return out

def main() -> None:
    for rel, expected in EXPECTED.items():
        actual=sha256(ROOT/rel)
        assert actual == expected, f"{rel}: {actual} != {expected}"
    zone=json.loads((ROOT/'Data/Zone/sky_tower.json').read_text(encoding='utf-8-sig'))['Object']
    music=[collect_music(segment) for segment in zone['Segments']]
    assert music[0] == ['PMD Red EU - Sky Tower.ogg']
    assert music[2] == ['PMD Red EU - Sky Tower.ogg']
    assert music[4] == ['PMD Red EU - Sky Tower Summit.ogg']
    assert len(zone['Segments']) >= 6
    for rel in ('Data/Ground/tour_ciel_sommet.rsground','Data/Map/tour_ciel_sommet.rsmap'):
        assert (ROOT/rel).is_file(), rel
    scene=(ROOT/'Data/Script/halcyon/ground/tour_ciel_sommet/init.lua').read_text()
    required=(
      "PMD Red EU - Sky Tower Summit.ogg", "BossFX.DescendSky(rayquaza",
      "VFX_Rayquaza_Hyperbeam_Core", "VFX_Meteor_Fragment", "DUN_Hyper_Beam",
      "DUN_Explosion", "SV.Chapter10.PlayedVictoryScene = true",
      'GAME:ContinueDungeon("sky_tower", 5, 0, 0',
      'GAME:EnterGroundMap("guild_heros_room"',
    )
    for token in required: assert token in scene, token
    route=(ROOT/'Data/Script/halcyon/zone/sky_tower/init.lua').read_text()
    assert "segmentID == 4" in route and "segmentID == 5" in route
    assert route.count("GAME:EnterGroundMap('tour_ciel_sommet'") >= 2
    assert "SV.Chapter10.CelestialPeakComplete = true" in route
    print('PMDRED_RAYQUAZA_PACKAGE_PASS')
    print(json.dumps({'zone':'sky_tower','ground':'tour_ciel_sommet','boss':'rayquaza','music_sha256':EXPECTED,'meteor_vfx':True},sort_keys=True))
if __name__ == '__main__': main()
