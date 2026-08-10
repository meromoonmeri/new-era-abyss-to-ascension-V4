#!/usr/bin/env python3
"""
Test couvrant BUG-LUA-01 — SpawnOutlaw rayon élargi.
Vérifie :
  1. Le fichier Lua contient la logique d'expansion progressive
  2. Simulation Python du même algorithme : si aucun candidat dans rayon initial,
     élargit et trouve une case, sinon annule proprement après épuisement.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LUA_PATH = os.path.join(ROOT, "Data/Script/halcyon/event_single.lua")

def test_lua_contains_expansion():
    src = open(LUA_PATH, encoding="utf-8").read()
    assert "currentRadius" in src, "variable currentRadius manquante"
    assert "maxRadius" in src, "variable maxRadius manquante"
    assert "retrying with radius" in src, "log de retry manquant"
    assert "no valid spawn tile after expanding to radius" in src, "log d'annulation après expansion manquant"
    assert "while true do" in src, "boucle while true do manquante"
    print("✓ Lua contient la logique d'expansion progressive")

def find_spawn(origin, radius, is_blocked, width, height, next_to_player=lambda x,y: False):
    max_radius = max(width, height)
    hard_limit = radius + 12
    if max_radius > hard_limit:
        max_radius = hard_limit
    current = radius
    candidates = []
    logs = []
    while True:
        candidates = []
        tl_x, tl_y = origin[0]-current, origin[1]-current
        br_x, br_y = origin[0]+current, origin[1]+current
        for x in range(tl_x, br_x+1):
            for y in range(tl_y, br_y+1):
                if not (0 <= x < width and 0 <= y < height):
                    continue
                if is_blocked(x,y):
                    continue
                if next_to_player(x,y):
                    continue
                candidates.append((x,y))
        if candidates:
            break
        if current >= max_radius:
            break
        nxt = min(current+2, max_radius)
        logs.append(f"retry {current}->{nxt}")
        current = nxt
    if not candidates:
        return None, logs
    return candidates[0], logs

def test_expansion_finds_tile():
    def blocked(x,y):
        return (x,y) not in [(0,0),(9,9)]
    origin = (5,5)
    loc, logs = find_spawn(origin, 3, blocked, 10, 10)
    assert loc is not None, "devrait trouver une case après expansion"
    assert len(logs) >= 1, "devrait avoir logué au moins un retry"
    assert loc in [(0,0),(9,9)], f"case trouvée inattendue {loc}"
    print(f"✓ Expansion trouve une case: {loc} après logs {logs}")

def test_expansion_exhaustion_cancels():
    def blocked(x,y):
        return True
    origin = (2,2)
    loc, logs = find_spawn(origin, 3, blocked, 5, 5)
    assert loc is None, "devrait annuler si aucune case même après expansion"
    print(f"✓ Annulation propre après épuisement des rayons (logs={logs})")

def test_initial_radius_succeeds_no_expansion():
    def blocked(x,y):
        return (x,y) != (5,6)
    origin = (5,5)
    loc, logs = find_spawn(origin, 3, blocked, 10, 10)
    assert loc == (5,6), f"devrait trouver (5,6) directement, got {loc}"
    assert len(logs) == 0, "ne doit pas élargir si déjà une case dans rayon initial"
    print("✓ Pas d'expansion si rayon initial suffit")

if __name__ == "__main__":
    test_lua_contains_expansion()
    test_expansion_finds_tile()
    test_expansion_exhaustion_cancels()
    test_initial_radius_succeeds_no_expansion()
    print("\nAll tests passed — BUG-LUA-01 rayon élargi")
