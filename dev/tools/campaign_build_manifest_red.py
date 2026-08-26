#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Manifest de campagne PMD Red Rescue Team (EU) — Grounds + cinématiques + narration.

Croise, sans invention :
  * les 428 Grounds pixel-perfect du port (commit réserve 0ec8129, campagne
    219/219 validée runtime PMDO 0.8.12, mismatched_pixel_count=0) ;
  * les renders produits par campaign_render_grounds.py (frames incluses) ;
  * les cinématiques .cif.json du port (séquences extraites de la ROM :
    musiques, dialogues, animations, flashes, caméra) ;
  * le casting canonique ROM EU (dev/docs/canonical/red/scene_cast/
    eu_scene_cast.json : entités, espèces, positions pixel, directions) ;
  * MAP_DATABASE.md / CINEMATICS_DATABASE.md du port (rôles, contexte) ;
  * l'inventaire projet INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md
    (donjon <-> grounds, boss) ;
  * la table gDungeonMusic déjà auditée (musiques par donjon).

Sortie : dev/CAMPAIGNS/PMD_RED_RESCUE_TEAM/MANIFEST.json + MANIFEST.md
"""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CAMP = ROOT / "dev" / "CAMPAIGNS" / "PMD_RED_RESCUE_TEAM"
PORT = ROOT / ".runtime-cache" / "ports" / "red" / "PMDRed_PMDO_Framework"
SRC = ROOT / ".runtime-cache" / "campaigns" / "red_src"

# ---------------------------------------------------------------- autorités

# Rôle des préfixes de la table de conversion GBA (MAP_DATABASE.md du port)
PREFIX_ROLES = {
    "t0": "rescue_team_base", "t1": "town_hub",
    "a0": "story_cutscene_map", "b0": "boss_arena_legacy",
    "d0": "dungeon_ground", "d1": "dungeon_ground", "d2": "dungeon_ground",
    "h0": "friend_area", "h1": "friend_area", "h2": "friend_area",
    "h3": "friend_area",
    "s0": "system_screen",
}

# Donjon (D01-D25) -> nom humain EN/FR + boss + grounds (INVENTAIRE projet,
# lui-même dérivé du port et de pmd_red_index.json)
DUNGEONS = {
    "D01": ("Tiny Woods", "Petit Bois", None,
            ["foret_tendre_oree", "d01p02"]),
    "D02": ("Thunderwave Cave", "Grotte Statique", None,
            ["grotte_statique_seuil", "d02p02"]),
    "D03": ("Mt. Steel", "Mont Ferreux", "Skarmory",
            ["pic_ferreux_pied", "d03p02"]),
    "D04": ("Sinister Woods", "Bois Sinistres", "Gengar (Team Meanies)",
            ["bois_sombres_oree", "bois_sombres_fond"]),
    "D05": ("Silent Chasm", "Gouffre Muet", "Zubat/Grimer ambush",
            ["gouffre_muet_bord", "d05p02"]),
    "D06": ("Mt. Thunder", "Mont Foudre", "Zapdos",
            ["mont_grondant_pied", "d06p02", "d06p03"]),
    "D07": ("Great Canyon", "Grand Canyon", None,
            ["grand_canyon_porte", "d07p02"]),
    "D08": ("Lapis Cave", "Grotte Lazuli", None,
            ["grotte_lazuli_seuil", "grotte_lazuli_fond"]),
    "D09": ("Mt. Blaze", "Mont Brasier", "Moltres",
            ["mont_cendre_pied", "d09p02", "d09p03"]),
    "D10": ("Frosty Forest", "Forêt Givrée", "Articuno",
            ["foret_givree_oree", "d10p02", "d10p03"]),
    "D11": ("Mt. Freeze", "Mont Gel", "Ninetales (révélation)",
            ["mont_gele_pied", "d11p02", "d11p03"]),
    "D12": ("Magma Cavern", "Caverne Magma", "Groudon",
            ["gorge_ardente_porte", "gorge_ardente_coeur", "fosse_ardente"]),
    "D13": ("Sky Tower", "Tour Céleste", "Rayquaza",
            ["parvis_celeste", "palier_celeste", "tour_ciel_sommet"]),
    "D14": ("Stormy Sea", "Mer Houleuse", "Kyogre", ["abime_tempetes"]),
    "D15": ("Silver Trench", "Fosse Argentée", "Lugia", ["fosse_argentee"]),
    "D16": ("Fiery Field", "Champ Brûlant", "Moltres", ["champ_braises"]),
    "D17": ("Lightning Field", "Champ Éclair", "Raikou", ["champ_foudre"]),
    "D18": ("Northwind Field", "Champ Borée", "Articuno",
            ["champ_vent_boreal"]),
    "D19": ("Mt. Faraway", "Mont Lointain", "Ho-Oh", ["sommet_aurore"]),
    "D20": ("Western Cave", "Grotte Occidentale", "Mewtwo",
            ["antre_occident"]),
    "D21": ("Northern Range", "Crêtes Boréales", "Latios/Latias",
            ["cretes_boreales"]),
    "D22": ("Pitfall Valley", "Vallée Perdue", None, ["vallon_perdu"]),
    "D23": ("Wish Cave", "Grotte du Vœu", "Jirachi", ["sanctuaire_voeu"]),
    "D24": ("Murky Cave", "Caverne Trouble", None,
            ["caverne_trouble_fond", "caverne_trouble_autel"]),
    "D25": ("Howling Forest", "Bois des Plaintes", "Suicune",
            ["bois_des_plaintes"]),
}

# Trame narrative globale (MAP_DATABASE + CINEMATICS_DATABASE + audit projet
# NARRATIVE_AUDIT — chronologie canonique de Rescue Team)
NARRATIVE_ARCS = [
    {"arc": "Prologue", "summary_fr":
     "Le héros se réveille transformé en Pokémon, rencontre son partenaire "
     "et fonde l'équipe de secours. Premiers sauvetages : Petit Bois "
     "(Chenipan), Grotte Statique, Mont Ferreux (Rondoudou/Airmure).",
     "grounds": ["t00p01", "t01p01", "foret_tendre_oree", "d01p02",
                 "grotte_statique_seuil", "d02p02", "pic_ferreux_pied",
                 "d03p02"]},
    {"arc": "Bois Sinistres & Gouffre Muet", "summary_fr":
     "La Team Meanies (Gengar/Ekans/Medicham) manigance. Sauvetage de "
     "Métamorph aux Bois Sinistres ; Grosdoudou au Gouffre Muet.",
     "grounds": ["bois_sombres_oree", "bois_sombres_fond",
                 "gouffre_muet_bord", "d05p02"]},
    {"arc": "Mont Foudre & la légende de Feunard", "summary_fr":
     "Traversée du Mont Foudre jusqu'à Zapdos ; Xatu révèle sur la Colline "
     "des Anciens (D07P02) que la chute de l'étoile menace le monde. Le "
     "rêve de Gardevoir introduit la légende de Feunard.",
     "grounds": ["mont_grondant_pied", "d06p02", "d06p03",
                 "grand_canyon_porte", "d07p02"]},
    {"arc": "Arc Fugitif", "summary_fr":
     "Accusé d'être l'humain maudit de la légende, le héros fuit par la "
     "Grotte Lazuli, le Mont Brasier (Sulfura), la Forêt Givrée (Artikodin, "
     "intervention d'Absol) jusqu'à l'autel du Mont Gel où Feunard révèle "
     "la vérité et innocente le héros.",
     "grounds": ["grotte_lazuli_seuil", "grotte_lazuli_fond",
                 "mont_cendre_pied", "d09p02", "d09p03",
                 "foret_givree_oree", "d10p02", "d10p03",
                 "mont_gele_pied", "d11p02", "d11p03"]},
    {"arc": "Crise de la Météorite", "summary_fr":
     "Xatu observe la météorite ; panique sur la Place Pokémon. L'équipe "
     "réveille Groudon dans la Caverne Magma puis monte à la Tour Céleste : "
     "Rayquaza détruit la météorite. Adieux du héros (fin du scénario "
     "principal).",
     "grounds": ["t01p01", "gorge_ardente_porte", "gorge_ardente_coeur",
                 "fosse_ardente", "parvis_celeste", "palier_celeste",
                 "tour_ciel_sommet"]},
    {"arc": "Post-game", "summary_fr":
     "Retour du héros ; donjons légendaires : Mer Houleuse (Kyogre), Fosse "
     "Argentée (Lugia), champs élémentaires (Sulfura/Raikou/Artikodin), "
     "Mont Lointain (Ho-Oh), Grotte Occidentale (Mewtwo), Grotte du Vœu "
     "(Jirachi), Bois des Plaintes (Suicune), etc.",
     "grounds": [g for d in ("D14", "D15", "D16", "D17", "D18", "D19",
                             "D20", "D21", "D22", "D23", "D24", "D25")
                 for g in DUNGEONS[d][3]]},
]


def load_json(p: Path):
    return json.loads(p.read_text(encoding="utf-8-sig"))


def main() -> int:
    render_report = load_json(CAMP / "Renders" / "render_report.json")
    renders = {r["ground"]: r for r in render_report["renders"]}
    validated = set((Path("/tmp/red_219.txt").read_text().split())
                    if Path("/tmp/red_219.txt").exists() else [])

    # cinématiques du port : id de scène -> résumé de séquence
    cines = {}
    for cif in sorted((PORT / "Data" / "Cinematics").glob("*.cif.json")):
        d = load_json(cif)
        seq = d.get("raw_sequence", [])
        from collections import Counter
        kinds = Counter(e.get("type") for e in seq)
        tracks = [e.get("track") for e in seq if e.get("track")]
        cines[d.get("scene", cif.stem.split(".")[0])] = {
            "events_total": len(seq),
            "dialog_boxes": kinds.get("Dialog", 0),
            "animations": kinds.get("Animation", 0),
            "audio_events": kinds.get("Audio", 0),
            "music_tracks": sorted(set(tracks)),
        }

    # casting canonique ROM (27 scènes décodées)
    cast_p = ROOT / "dev" / "docs" / "canonical" / "red" / "scene_cast" / "eu_scene_cast.json"
    cast = load_json(cast_p)["scenes"] if cast_p.exists() else {}
    # Les grounds du port renommés en français correspondent aux IDs source
    # dXXpYY du scene_cast (INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md §1/§2).
    SOURCE_ID_ALIASES = {
        "bois_sombres_fond": "d04p02",
        "gorge_ardente_coeur": "d12p02",
        "fosse_ardente": "d12p04",
        "palier_celeste": "d13p02",
        "tour_ciel_sommet": "d13p03",
        "abime_tempetes": "d14p01",
        "fosse_argentee": "d15p01",
        "champ_braises": "d16p01",
        "champ_foudre": "d17p01",
        "champ_vent_boreal": "d18p01",
        "sommet_aurore": "d19p01",
        "antre_occident": "d20p01",
        "cretes_boreales": "d21p01",
        "sanctuaire_voeu": "d23p01",
        "caverne_trouble_fond": "d24p01",
        "bois_des_plaintes": "d25p01",
    }

    # nom humain par ground : depuis Name du rsground + inventaire donjons
    ground_names = {}
    for g in sorted(SRC.glob("Grounds/*.rsground")):
        try:
            o = load_json(g)["Object"]
            nm = o.get("Name", {})
            ground_names[g.stem] = {
                "en": nm.get("DefaultText") or g.stem,
                "fr": (nm.get("LocalTexts") or {}).get("fr"),
                "music": o.get("Music") or None,
                "comment": (o.get("Comment") or "")[:220] or None,
            }
        except Exception:
            ground_names[g.stem] = {"en": g.stem, "fr": None}

    ground_to_dungeon = {}
    for did, (en, fr, boss, grounds) in DUNGEONS.items():
        for i, g in enumerate(grounds):
            role = ("entrance" if i == 0 and len(grounds) > 1 else
                    "midpoint" if 0 < i < len(grounds) - 1 else
                    "end_or_arena" if len(grounds) > 1 else "arena")
            ground_to_dungeon[g] = {"dungeon": did, "dungeon_en": en,
                                    "dungeon_fr": fr, "boss": boss,
                                    "role": role}

    entries = []
    for gid in sorted(renders):
        r = renders[gid]
        e = {
            "ground": gid,
            "human_name_en": ground_names.get(gid, {}).get("en", gid),
            "human_name_fr": ground_names.get(gid, {}).get("fr"),
            "render": (None if "error" in r else {
                "dir": f"Renders/{gid}/",
                "width_px": r["width_px"], "height_px": r["height_px"],
                "frames": r["frames_rendered"],
                "animation_cycle": r["animation_cycle"],
                "animated_tiles": r["animated_tiles"],
            }),
            "render_error": r.get("error"),
            "runtime_validated_219": gid in validated,
            "music": ground_names.get(gid, {}).get("music"),
            "source_comment": ground_names.get(gid, {}).get("comment"),
        }
        d = ground_to_dungeon.get(gid)
        if d:
            e["dungeon"] = d
        c = cines.get(gid)
        if c:
            e["cinematic"] = c
        cc = cast.get(gid) or cast.get(SOURCE_ID_ALIASES.get(gid, ""))
        if cc:
            e["source_map_id"] = SOURCE_ID_ALIASES.get(gid, gid)
            ents = [x for x in cc.get("entities", []) if x.get("category") == "live"]
            e["canonical_cast"] = [
                {"role": x.get("actor_type"), "species": x.get("species"),
                 "pixel": [x.get("pixel_x"), x.get("pixel_y")],
                 "direction": x.get("direction")} for x in ents]
        entries.append(e)

    manifest = {
        "schema": "new-era.campaign-manifest.v1",
        "campaign": "PMD Red Rescue Team (EU)",
        "authority": {
            "grounds_source": "meromoonmeri/new-era-abyss-to-ascension-V4@0ec8129 "
                              "(campagne 219/219 Grounds validés PMDO 0.8.12 réel, "
                              "0 pixel mismatch)",
            "rom": "PMD Red EU sha256 0f9d125d…cbcd",
            "cinematics": "PMDRed_PMDO_Framework/Data/Cinematics/*.cif.json "
                          "(séquences extraites de la ROM)",
            "cast": "dev/docs/canonical/red/scene_cast/eu_scene_cast.json "
                    "(gMapScriptTable EU + gGroundLivesTypeData 0x27BEEC)",
            "naming": "rsground Name + INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md",
        },
        "totals": {
            "grounds": len(entries),
            "rendered": sum(1 for e in entries if e["render"]),
            "runtime_validated": sum(1 for e in entries if e["runtime_validated_219"]),
            "with_cinematic": sum(1 for e in entries if "cinematic" in e),
            "with_canonical_cast": sum(1 for e in entries if "canonical_cast" in e),
        },
        "narrative_arcs": NARRATIVE_ARCS,
        "dungeons": {k: {"en": v[0], "fr": v[1], "boss": v[2], "grounds": v[3]}
                     for k, v in DUNGEONS.items()},
        "grounds": entries,
    }
    (CAMP / "MANIFEST.json").write_text(
        json.dumps(manifest, indent=1, ensure_ascii=False))

    # MANIFEST.md lisible
    md = ["# Campagne PMD Red Rescue Team (EU) — manifest des Grounds\n",
          f"- Grounds : **{manifest['totals']['grounds']}** ; rendus : "
          f"**{manifest['totals']['rendered']}** ; validés runtime (campagne 219) : "
          f"**{manifest['totals']['runtime_validated']}**",
          f"- Avec cinématique extraite : **{manifest['totals']['with_cinematic']}** ; "
          f"avec casting canonique ROM : **{manifest['totals']['with_canonical_cast']}**\n",
          "## Narration globale\n"]
    for a in NARRATIVE_ARCS:
        md.append(f"### {a['arc']}\n{a['summary_fr']}\n")
    md.append("\n## Donjons\n")
    md.append("| Donjon | EN | FR | Boss | Grounds |")
    md.append("|---|---|---|---|---|")
    for k, v in DUNGEONS.items():
        md.append(f"| {k} | {v[0]} | {v[1]} | {v[2] or '—'} | "
                  f"{', '.join('`'+g+'`' for g in v[3])} |")
    md.append("\n## Grounds (extrait: donjons + scènes à cinématique)\n")
    md.append("| Ground | Nom | Donjon/Rôle | Frames | Cinématique | Cast ROM |")
    md.append("|---|---|---|---|---|---|")
    for e in entries:
        if "dungeon" not in e and "cinematic" not in e:
            continue
        d = e.get("dungeon", {})
        c = e.get("cinematic", {})
        md.append(
            f"| `{e['ground']}` | {e['human_name_en']} | "
            f"{d.get('dungeon_en','—')} {('('+d['role']+')') if d else ''} | "
            f"{(e['render'] or {}).get('frames','—')} | "
            f"{(str(c['dialog_boxes'])+' dlg / '+', '.join(c['music_tracks'][:2])) if c else '—'} | "
            f"{len(e.get('canonical_cast', [])) or '—'} |")
    (CAMP / "MANIFEST.md").write_text("\n".join(md) + "\n")
    print(f"manifest: {manifest['totals']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
