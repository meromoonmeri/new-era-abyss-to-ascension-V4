#!/usr/bin/env python3
"""Translate natural French/English dungeon intentions into an explicit brief."""
from __future__ import annotations
import hashlib
import re
import unicodedata
from .model import DesignBrief

THEMES = {
    "ancien": ["ancien", "antique", "ruine", "ancestral", "forgotten", "old"],
    "majestueux": ["majestueux", "royal", "grandiose", "sacré", "majestic"],
    "inquiétant": ["inquiétant", "angoissant", "sombre", "oppressant", "sinistre", "creepy", "dark"],
    "forêt": ["forêt", "forest", "bois", "jungle", "végétal"],
    "grotte": ["grotte", "caverne", "mine", "cave", "souterrain"],
    "eau": ["eau", "rivière", "lac", "mer", "water", "river"],
    "feu": ["feu", "volcan", "lave", "fire", "lava"],
    "glace": ["glace", "neige", "gelé", "ice", "snow"],
    "céleste": ["céleste", "étoile", "ciel", "cosmique", "sky", "star"],
    "mécanique": ["machine", "mécanique", "usine", "industrial", "mechanical"],
}

COMPOSITIONS = {
    "central_landmark": ["salle centrale", "centre protégé", "central room", "protected center"],
    "circular_progression": ["circulaire", "anneau", "circular", "ring"],
    "corridor_spine": ["couloirs", "corridor", "colonne vertébrale", "spine"],
    "island_clusters": ["îlots", "archipel", "islands", "clusters"],
    "branching_pockets": ["branches", "embranchements", "branching"],
    "asymmetric_gradient": ["asymétrique", "asymmetry", "irrégulier"],
    "chamber_sequence": ["succession de salles", "petites salles", "chambers"],
    "open_field": ["très ouvert", "grande zone ouverte", "open field"],
    "dominant_loop": ["grande boucle", "boucle principale", "main loop"],
}


def norm(text: str) -> str:
    return "".join(
        c for c in unicodedata.normalize("NFKD", text.casefold())
        if not unicodedata.combining(c)
    )


def _number(text, patterns, default):
    for pattern in patterns:
        match = re.search(pattern, text)
        if match:
            return int(match.group(1))
    return default


def slugify(name):
    return re.sub(r"[^a-z0-9]+", "_", norm(name)).strip("_") or "dungeon"


def parse_intent(
    name: str,
    intent: str,
    floors: int | None = None,
    difficulty: str | None = None,
    boss: bool | None = None,
    mini_bosses: int | None = None,
    relays: int | None = None,
    seed: int | None = None,
    boss_species: str | None = None,
    boss_category: str = "auto",
    narrative_prompt: str = "",
):
    text = norm(intent)
    count_text = text
    number_words = {
        "un": "1", "une": "1", "deux": "2", "trois": "3", "quatre": "4",
        "cinq": "5", "six": "6", "seven": "7", "two": "2", "three": "3",
        "four": "4", "five": "5",
    }
    for word, value in number_words.items():
        count_text = re.sub(rf"\b{word}\b", value, count_text)

    floor_count = floors or _number(count_text, [r"(\d+)\s*(?:etages|floors|niveaux)"], 20)
    mini = mini_bosses if mini_bosses is not None else _number(count_text, [r"(\d+)\s*mini[- ]?boss"], 0)
    relay = relays if relays is not None else _number(count_text, [r"(\d+)\s*(?:relais|refuges|rest stops?)"], 0)
    has_boss = boss if boss is not None else bool(re.search(r"\bboss\b|gardien final|final guardian", text))
    diff = difficulty or (
        "extrême" if any(x in text for x in ("extreme", "brutal", "tres difficile"))
        else "difficile" if any(x in text for x in ("difficile", "dangereux", "hard"))
        else "facile" if any(x in text for x in ("facile", "calme", "easy"))
        else "normal"
    )
    theme_tokens = [key for key, words in THEMES.items() if any(norm(word) in text for word in words)]
    composition_preferences = [
        key for key, words in COMPOSITIONS.items() if any(norm(word) in text for word in words)
    ]

    topology_start = (
        "open" if re.search(r"(debut|premiers?).{0,30}(ouvert|open)|(ouvert|open).{0,20}(debut|premiers?)", text)
        else "linear" if "lineaire" in text else "balanced"
    )
    topology_end = (
        "labyrinth" if re.search(r"(devien|fin|progress).{0,45}(labyrinth|complex)", text) or "labyrinth" in text
        else "open" if "reste ouvert" in text else "complex"
    )
    mood_start = "majestueux" if "majestueux" in theme_tokens else "calme" if "calme" in text else "lisible"
    mood_end = (
        "inquiétant" if "inquiétant" in theme_tokens or "progressivement inquietant" in text
        else "spectaculaire" if "spectacul" in text else "intense"
    )
    decoration_bias = .78 if "forte densite" in text or "tres decore" in text else .28 if "epure" in text or "peu decore" in text else .52
    danger_bias = .82 if diff in ("difficile", "extrême") else .28 if diff == "facile" else .55
    water_policy = "forbid" if re.search(r"sans eau|no water", text) else "required" if re.search(r"beaucoup d eau|aquatique|water", text) else "auto"

    constraints = []
    checks = [
        (r"immense salle centrale|grande salle centrale", "central_landmark"),
        (r"tres labyrinthique", "strong_labyrinth"),
        (r"etage plus ouvert", "open_floor"),
        (r"calme avant le boss|refuge avant le boss", "preboss_calm"),
        (r"zone secrete|raccourci", "secrets_and_shortcuts"),
        (r"sans eau|no water", "no_water"),
        (r"progression circulaire", "circular_progression"),
        (r"forte asymetrie", "strong_asymmetry"),
    ]
    for pattern, label in checks:
        if re.search(pattern, text):
            constraints.append(label)
    if "central_landmark" in constraints and "central_landmark" not in composition_preferences:
        composition_preferences.append("central_landmark")

    requested_specials = []
    if has_boss:
        requested_specials.append({"kind": "boss", "count": 1})
    if mini:
        requested_specials.append({"kind": "mini_boss", "count": mini})
    if relay:
        requested_specials.append({"kind": "relay", "count": relay})

    if seed is None:
        seed = int.from_bytes(hashlib.sha256((name + "\0" + intent).encode()).digest()[:8], "little") & 0x7fffffff

    spectacle = .75 if any(x in text for x in ("spectaculaire", "grandiose", "epique", "climax")) else .4 if "discret" in text else .55
    surprise = .14 if any(x in text for x in ("surprenant", "inattendu", "surprise")) else .04 if "tres coherent" in text else .08
    visual_keywords = sorted(set(theme_tokens + [
        word for word in ("contrasté", "épuré", "dense", "organique", "géométrique", "monumental")
        if norm(word) in text
    ]))

    return DesignBrief(
        name=name,
        slug=slugify(name),
        intent=intent,
        floors=max(3, min(200, floor_count)),
        difficulty=diff,
        boss=has_boss,
        mini_bosses=max(0, mini),
        relays=max(0, relay),
        seed=int(seed),
        theme_tokens=theme_tokens,
        mood_start=mood_start,
        mood_end=mood_end,
        topology_start=topology_start,
        topology_end=topology_end,
        water_policy=water_policy,
        decoration_bias=decoration_bias,
        danger_bias=danger_bias,
        constraints=constraints,
        requested_specials=requested_specials,
        composition_preferences=composition_preferences,
        visual_keywords=visual_keywords,
        spectacle_bias=spectacle,
        surprise_budget=surprise,
        boss_species=boss_species.casefold().strip() if boss_species else None,
        boss_category=boss_category,
        narrative_prompt=narrative_prompt,
    )
