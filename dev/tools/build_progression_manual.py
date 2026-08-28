#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""build_progression_manual.py — Manuel de progression illustré.

Rend en PNG (render_ground_png, déterministe) chaque ground de la chaîne
de progression Sky CH1→FINALE puis Red CH1→CH13, dans l'ordre exact des
journeys runtime (mêmes tables que ground_gameplay_validator), et écrit
dev/docs/canonical/PROGRESSION_MANUAL.md : pour chaque lieu, nom canonique
ROM (LEVEL_HUMAN_NAMES / pret), ce qui s'y passe (scène du chapitre) et
le donjon lié.
"""
import json
import os
import subprocess
import sys

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT_DIR = os.path.join(REPO, "dev", "docs", "canonical", "renders",
                       "progression")
MD = os.path.join(REPO, "dev", "docs", "canonical",
                  "PROGRESSION_MANUAL.md")
PY = os.path.join(REPO, ".runtime-cache", "sky-venv", "bin", "python")

NAMES = json.load(open(os.path.join(
    REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS", "Docs",
    "LEVEL_HUMAN_NAMES.json")))["levels"]

# ---- Sky : chapitres du journey (mêmes données que self.J du validateur)
SKY = [
    ("CH1 — Éveil sur la plage", "1.0",
     ["t01p01a", "p01p01a", "d01p11b"],
     {"t01p01a": "Bourg-Trésor : hub principal, boutiques (Duskull Bank, "
                 "magasin Kecleon, entrepôt Gallade).",
      "p01p01a": "Croisement : carrefour entre le bourg, la guilde et la "
                 "plage.",
      "d01p11b": "Plage : le héros s'éveille transformé en Pokémon ; le "
                 "partenaire perd son Fragment Relique face à Koffing et "
                 "Zubat — entrée du donjon Grotte Littorale."},
     "beach_cave (4 étages) → boss Koffing/Zubat (beach_cave_pit)"),
    ("CH2 — L'apprenti de la guilde", "3.0",
     ["g01p02a", "g01p01b"],
     {"g01p02a": "Entrée de la Guilde de Grodoudou : la grille d'examen "
                 "des visiteurs (Taupiqueur).",
      "g01p01b": "Guilde de Grodoudou (rez) : cérémonie d'admission ; "
                 "briefing du 1er travail par Ramboum."},
     "drenched_bluff (6 étages) — mission Perle de Spoink"),
    ("CH3 — L'arrestation", "4.0",
     ["g01p03a"],
     {"g01p03a": "Guilde - 1er sous-sol : tableaux des missions et des "
                 "avis de recherche ; briefing de la capture."},
     "mt_bristle (9 étages) → boss Drowzee (mt_bristle_peak)"),
    ("CH4 — La patrouille aux Aliments", "5.0",
     ["g01p04a"],
     {"g01p04a": "Guilde - 2e sous-sol : mess et cuisine de Wigglytuff ; "
                 "départ de la corvée de Perles Perche."},
     "waterfall_cave (8 étages) — la cascade cache une grotte"),
    ("CH5 — Les Baies Perche", "6.0",
     ["g01p04a"],
     {"g01p04a": "Guilde - 2e sous-sol : Wigglytuff envoie l'équipe "
                 "chercher des Pommes Parfaites."},
     "apple_woods (12 étages) — Bois aux Pommes, Groddur"),
    ("EXPÉDITION — Le lac Brumeux", "8.0",
     ["g01p06b", "d06p11a", "d07p11a", "d08p11a", "d09p11a"],
     {"g01p06b": "Mess de la Guilde : annonce de la Grande Expédition, "
                 "constitution des groupes.",
      "d06p11a": "Côte Escarpée - entrée : première étape de "
                 "l'expédition vers le lac.",
      "d07p11a": "Mt Corne - entrée : passage montagneux de "
                 "l'expédition.",
      "d08p11a": "Camp de Base : bivouac de l'expédition de la guilde.",
      "d09p11a": "Grotte Étuve - entrée : dernière ligne droite vers "
                 "Fogbound Lake ; Uxie et Groudon-illusion au sommet."},
     "craggy_coast → mt_horn → foggy_forest → steam_cave → "
     "upper_steam_cave → boss Groudon (steam_cave_peak)"),
    ("CH10 — Les Plaines Élek", "10.0",
     ["d09p11a"],
     {"d09p11a": "Retour d'expédition : l'équipe est envoyée aux "
                 "Plaines Élek enquêter sur Grovyle."},
     "amp_plains → far_amp_plains → boss Manectric (amp_clearing)"),
    ("CH11 — Le Lac Souterrain", "11.0",
     ["g01p07a", "d15p41a"],
     {"g01p07a": "Dortoir : réveil de l'équipe, plan pour retrouver les "
                 "Gemmes du Temps.",
      "d15p41a": "Lac Souterrain : la caverne de Mespérit sous le "
                 "désert."},
     "northern_desert → quicksand_cave → quicksand_pit → "
     "boss Mespérit (underground_lake)"),
    ("CH12 — Le Lac Cristal", "12.0",
     ["g01p04a", "d16p31a", "d17p11a"],
     {"g01p04a": "Guilde - 2e sous-sol : préparation de la traque de "
                 "Grovyle.",
      "d16p31a": "Caverne Cristal : les cristaux changeants de couleur.",
      "d17p11a": "Lac Cristal (Shining Lake) : sanctuaire de Créhelf."},
     "crystal_cave → crystal_crossing → boss Grovyle (crystal_lake)"),
    ("FUTUR — Le monde paralysé", "13.0",
     ["g01p03a", "d18p11a", "d19p11a", "d20p11a"],
     {"g01p03a": "Guilde - 1er sous-sol : Dusknoir emmène héros et "
                 "partenaire dans le futur.",
      "d18p11a": "Grotte Abîme - entrée (futur) : fuite avec Grovyle.",
      "d19p11a": "Colline Sombre - entrée (futur) : la planète "
                 "paralysée.",
      "d20p11a": "Ruine Scellée - entrée (futur) : vers Spiritomb."},
     "chasm_cave → dark_hill → sealed_ruin → sealed_ruin_pit → "
     "boss Spiritomb (spiritomb_room)"),
    ("CH15 — La Forêt Crépuscule", "15.0",
     ["d22p11a", "d23p11a", "d24p11a"],
     {"d22p11a": "Forêt Crépuscule - entrée : retour au présent, quête "
                 "des Gemmes du Temps avec Grovyle.",
      "d23p11a": "Cœur de la Forêt Crépuscule : la brume s'épaissit.",
      "d24p11a": "Forêt Linceul - entrée : la 3e Gemme du Temps."},
     "dusk_forest → deep_dusk_forest → treeshroud_forest (20 étages)"),
    ("CH17 — La Caverne Saline", "17.0",
     ["p05p02a", "d25p11a"],
     {"p05p02a": "Prison de la guilde : l'équipe détenue après le "
                 "quiproquo Grovyle/Dusknoir.",
      "d25p11a": "Caverne Saline - entrée : sur les traces de Grodoudou "
                 "et du repaire des bandits."},
     "brine_cave → lower_brine_cave → boss Omastar/Kabutops "
     "(brine_cave_pit)"),
    ("CH18 — Les Terres Illusoires", "18.0",
     ["d27p11a", "d28p31a"],
     {"d27p11a": "Terres Illusoires - entrée : au-delà de la mer, le "
                 "domaine caché de Lapras.",
      "d28p31a": "Ruines Anciennes (Old Ruins) : l'affrontement contre "
                 "Dusknoir avant la Tour du Temps."},
     "hidden_land → hidden_highland → boss Dusknoir+Sabelette "
     "(old_ruins)"),
    ("FINALE — La Tour du Temps", "20.0",
     ["d01p11a", "d29p11a"],
     {"d01p11a": "Plage : adieux et départ vers la Tour du Temps.",
      "d29p11a": "Tour du Temps - entrée : l'ascension finale pour "
                 "sauver le temps."},
     "temporal_tower → temporal_spire → boss DIALGA "
     "(temporal_pinnacle, plateforme entourée de vide — fixed floor 10)"),
]

# ---- Red : chapitres du journey (self.RJ) — grounds d'entrée pret
RED = [
    ("CH1 — Tiny Woods", ["t01p01", "d01p01"],
     {"t01p01": "Place du village (Pokémon Square) : hub Red — Kecleon, "
                "Kangaskhan, Persian Bank.",
      "d01p01": "Entrée de Tiny Woods : sauvetage de Caterpie pour "
                "Butterfree."},
     "tiny_woods (3 étages)"),
    ("CH2 — Thunderwave Cave", ["d02p01"],
     {"d02p01": "Entrée de Thunderwave Cave : sauvetage des Magnemite "
                "coincés."},
     "thunderwave_cave (5 étages)"),
    ("CH3 — Mt Steel", ["d03p01"],
     {"d03p01": "Entrée du Mont Acier : Diglett kidnappé par Skarmory."},
     "mt_steel (8 étages) → boss SKARMORY (fixed room GBA, décor "
     "pixel-exact d03p02)"),
    ("CH4 — Sinister Woods", ["d04p01"],
     {"d04p01": "Entrée des Bois Sinistres : l'embuscade de la Team "
                "Meanies (Gengar, Ekans, Medicham) dans la clairière."},
     "gloomy_forest (6+6 étages, 2 segments)"),
    ("CH5 — Silent Chasm", ["d05p01"],
     {"d05p01": "Entrée du Gouffre Silencieux : Shiftry disparu."},
     "silent_chasm (9 étages)"),
    ("CH6 — Mt Thunder", ["d06p01"],
     {"d06p01": "Entrée du Mont Tonnerre : la rumeur accuse le héros ; "
                "Zapdos retient Shiftry au sommet."},
     "mt_thunder → mt_thunder_peak → boss ZAPDOS"),
    ("CH7 — Great Canyon", ["d07p01"],
     {"d07p01": "Entrée du Grand Canyon : rencontre de Xatu et révélation "
                "de la prophétie de Ninetales."},
     "great_canyon (12 étages)"),
    ("CH8 — Lapis Cave", ["d08p01"],
     {"d08p01": "Entrée de la Grotte Lapis : la fuite commence, le "
                "village croit le héros maudit."},
     "lapis_cave (14 étages)"),
    ("CH9 — Mt Blaze", ["d09p01"],
     {"d09p01": "Entrée du Mont Brasier : la fuite continue vers le "
                "nord ; Moltres barre le passage au pic."},
     "mt_blaze → mt_blaze_peak → boss MOLTRES"),
    ("CH10 — Frosty Forest", ["d10p01"],
     {"d10p01": "Entrée de la Forêt Givrée : la traversée glaciale des "
                "fugitifs."},
     "frosty_forest (8 étages)"),
    ("CH11 — Mt Freeze", ["d11p01"],
     {"d11p01": "Entrée du Mont Gel : Ninetales révèle la vérité ; "
                "affrontement contre Glalie (Alakazam interrompt)."},
     "mt_freeze → mt_freeze_peak → boss GLALIE"),
    ("CH12 — Magma Cavern", ["d15p01"],
     {"d15p01": "Entrée de la Caverne Magma : Groudon s'éveille sous "
                "terre ; l'équipe réhabilitée part le neutraliser."},
     "magma_cavern (8+7+8) → magma_cavern_pit (3) → boss GROUDON "
     "(fixed room GBA fr7, poches de lave restaurées)"),
    ("CH13 — Sky Tower (FINALE)", ["d16p01"],
     {"d16p01": "Entrée de la Tour Céleste : l'étoile menace de "
                "s'écraser ; Rayquaza seul peut la détruire."},
     "sky_tower (25) → sky_tower_summit (9) → boss RAYQUAZA "
     "(fixed room GBA fr8, plateforme céleste + ciel)"),
]


def human_name(g):
    e = NAMES.get(g.upper())
    if e and e.get("place_name"):
        return e["place_name"]["fr"], e["place_name"]["en"]
    return None, None


def render(grounds):
    os.makedirs(OUT_DIR, exist_ok=True)
    todo = [g for g in grounds
            if not os.path.exists(os.path.join(OUT_DIR, f"{g}.png"))]
    if todo:
        subprocess.run([PY, os.path.join(REPO, "dev", "tools",
                                         "render_ground_png.py"),
                        "--output-dir", OUT_DIR] + todo,
                       check=True, cwd=REPO)


def main():
    allg = []
    for _, _, gs, _, _ in SKY:
        allg += gs
    for _, gs, _, _ in RED:
        allg += gs
    # dédup en préservant l'ordre
    seen = set()
    ordered = [g for g in allg if not (g in seen or seen.add(g))]
    render(ordered)

    lines = [
        "# MANUEL DE PROGRESSION — PMD Explorers of Sky + Red Rescue "
        "Team (PMDO)",
        "",
        "Renders déterministes `render_ground_png` (géométrie/tuiles "
        "réelles des .rsground importés des ROM EU). Ordre = chaîne de "
        "progression canonique, identique aux journeys runtime "
        "(GLOBAL_JOURNEY_PASS / RED_GLOBAL_JOURNEY_PASS).",
        "",
        "---",
        "",
        "## PARTIE 1 — Explorers of Sky (EU), CH1 → FINALE",
        ""]
    for title, state, gs, desc, dungeon in SKY:
        lines.append(f"### {title}  `état {state}`")
        lines.append("")
        lines.append(f"**Donjon(s) lié(s)** : {dungeon}")
        lines.append("")
        for g in gs:
            fr, en = human_name(g)
            nm = f"{fr} / {en}" if fr else g
            lines.append(f"#### `{g}` — {nm}")
            lines.append("")
            lines.append(desc.get(g, ""))
            lines.append("")
            lines.append(f"![{g}](renders/progression/{g}.png)")
            lines.append("")
        lines.append("---")
        lines.append("")
    lines.append("## PARTIE 2 — Red Rescue Team (EU), CH1 → CH13")
    lines.append("")
    for title, gs, desc, dungeon in RED:
        lines.append(f"### {title}")
        lines.append("")
        lines.append(f"**Donjon(s) lié(s)** : {dungeon}")
        lines.append("")
        for g in gs:
            lines.append(f"#### `{g}`")
            lines.append("")
            lines.append(desc.get(g, ""))
            lines.append("")
            lines.append(f"![{g}](renders/progression/{g}.png)")
            lines.append("")
        lines.append("---")
        lines.append("")
    open(MD, "w").write("\n".join(lines))
    print("manuel:", MD)
    print("renders:", len(ordered), "->", OUT_DIR)


if __name__ == "__main__":
    main()
