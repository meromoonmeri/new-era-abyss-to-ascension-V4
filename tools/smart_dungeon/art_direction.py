#!/usr/bin/env python3
"""Procedural art direction inferred from available assets and user intent.

This module chooses a small, purposeful vocabulary. Compatibility is a gate,
never a sufficient reason to use an asset.
"""
from __future__ import annotations
import hashlib
import math
from collections import Counter, defaultdict
from typing import Any
from .model import DesignBrief


def _stable_fraction(*parts) -> float:
    raw = hashlib.sha256("|".join(map(str, parts)).encode()).digest()
    return int.from_bytes(raw[:4], "little") / 0xFFFFFFFF


def _vector(asset):
    rgb = asset.get("dominant_rgb", [0, 0, 0])
    return [
        rgb[0] / 255, rgb[1] / 255, rgb[2] / 255,
        asset.get("mean_luma", 0), asset.get("mean_saturation", 0),
        asset.get("alpha_coverage", 1), asset.get("edge_density", 0),
        asset.get("detail_score", 0), asset.get("symmetry_score", 0),
    ]


def visual_distance(a, b):
    va, vb = _vector(a), _vector(b)
    return math.sqrt(sum((x - y) ** 2 for x, y in zip(va, vb)) / len(va))


def _intent_targets(brief: DesignBrief):
    tokens = set(brief.theme_tokens + brief.visual_keywords)
    target = {"luma": .48, "saturation": .38, "detail": .48, "symmetry": .45, "contrast": .48}
    reasons = []
    if tokens & {"inquiétant", "grotte", "ancien"}:
        target["luma"] -= .13
        target["contrast"] += .10
        reasons.append("l'intention favorise une palette plus sombre et contrastée")
    if tokens & {"majestueux", "céleste"}:
        target["detail"] += .17
        target["symmetry"] += .14
        target["luma"] += .06
        reasons.append("la monumentalité favorise détail et symétrie maîtrisée")
    if tokens & {"forêt", "eau"}:
        target["saturation"] += .13
        reasons.append("l'intention organique favorise une couleur plus présente")
    if tokens & {"feu"}:
        target["saturation"] += .25
        target["contrast"] += .18
        reasons.append("l'intention de danger favorise saturation et contraste")
    if "glace" in tokens:
        target["luma"] += .18
        target["saturation"] -= .08
        reasons.append("l'intention glacée favorise une palette claire et retenue")
    if "épuré" in tokens:
        target["detail"] -= .22
        reasons.append("l'intention épurée limite le détail")
    return {key: max(0, min(1, value)) for key, value in target.items()}, reasons


def _semantic_score(asset, brief):
    theme = set(brief.theme_tokens + brief.visual_keywords)
    tags = set(asset.get("tags", [])) | set(asset.get("material_hints", []))
    name = asset.get("asset_id", "").casefold()
    return len(theme & tags) * 1.4 + sum(token.casefold() in name for token in theme) * .9


def _target_score(asset, targets, brief):
    score = 1 - (
        abs(asset.get("mean_luma", 0) - targets["luma"]) * .28
        + abs(asset.get("mean_saturation", 0) - targets["saturation"]) * .18
        + abs(asset.get("detail_score", 0) - targets["detail"]) * .25
        + abs(asset.get("symmetry_score", 0) - targets["symmetry"]) * .12
        + abs(asset.get("edge_density", 0) - targets["contrast"]) * .17
    )
    semantic = _semantic_score(asset, brief)
    evidence = min(1, len(asset.get("evidence_sources", [])) / 4)
    confidence = asset.get("confidence", 0)
    ambiguity_penalty = .18 if asset.get("ambiguous") and not asset.get("overridden") else 0
    # Tiny intent-derived tie break: identity differs by intent, never iteration order.
    tie = _stable_fraction(brief.intent, asset.get("asset_id")) * .015
    return score + semantic + evidence * .20 + confidence * .25 - ambiguity_penalty + tie


def _entry(asset, tier, purpose, budget, reason):
    return {
        "asset_id": asset["asset_id"],
        "tier": tier,
        "purpose": purpose,
        "budget": budget,
        "confidence": round(asset.get("confidence", 0), 3),
        "ambiguous": bool(asset.get("ambiguous", False)),
        "evidence": asset.get("evidence_sources", []),
        "cluster_id": asset.get("cluster_id", ""),
        "dominant_rgb": asset.get("dominant_rgb", [96, 96, 96]),
        "reason": reason,
    }


def _strategy_preferences(brief):
    scores = Counter({
        "central_landmark": 2,
        "dominant_loop": 2,
        "branching_pockets": 2,
        "asymmetric_gradient": 2,
        "island_clusters": 2,
        "chamber_sequence": 2,
        "corridor_spine": 2,
        "open_field": 2,
        "circular_progression": 2,
        "protected_core": 2,
    })
    for preferred in brief.composition_preferences:
        scores[preferred] += 8
    if brief.topology_start == "open":
        scores.update({"open_field": 5, "island_clusters": 4, "central_landmark": 3})
    if brief.topology_start == "linear":
        scores.update({"corridor_spine": 5, "chamber_sequence": 4})
    if brief.topology_end == "labyrinth":
        scores.update({"dominant_loop": 5, "branching_pockets": 5, "asymmetric_gradient": 3})
    if "majestueux" in brief.theme_tokens:
        scores.update({"central_landmark": 5, "protected_core": 5, "circular_progression": 3})
    if "inquiétant" in brief.theme_tokens:
        scores.update({"asymmetric_gradient": 4, "chamber_sequence": 3, "corridor_spine": 2})
    return [name for name, _ in sorted(scores.items(), key=lambda row: (-row[1], row[0]))]


def _choose_texture(bundles, brief):
    if not bundles:
        return None
    return max(
        bundles,
        key=lambda asset: (
            _semantic_score(asset, brief),
            asset.get("usage_count", 0) > 0,
            _stable_fraction(brief.intent, "texture", asset["asset_id"]),
        ),
    )


def build_art_direction(catalog: dict[str, Any], brief: DesignBrief, overrides: dict | None = None):
    assets = catalog.get("assets", [])
    sheets = [asset for asset in assets if asset.get("kind") == "ground_tile_sheet"]
    bundles = [asset for asset in assets if asset.get("kind") == "dungeon_texture_bundle"]
    targets, target_reasons = _intent_targets(brief)
    ranked = sorted(sheets, key=lambda asset: (-_target_score(asset, targets, brief), asset["asset_id"]))

    if ranked:
        anchor = ranked[0]
        compatible = sorted(
            sheets,
            key=lambda asset: (
                visual_distance(anchor, asset),
                -_target_score(asset, targets, brief),
                asset["asset_id"],
            ),
        )
        coherent = [asset for asset in compatible if visual_distance(anchor, asset) <= .34]
        if len(coherent) < min(6, len(sheets)):
            coherent = compatible[:min(max(6, len(coherent)), len(compatible))]
    else:
        anchor, coherent = None, []

    # Ambiguous assets may be a conservative background, but never exceptional
    # without a human override or strong evidence.
    reliable = [asset for asset in coherent if not asset.get("ambiguous") or asset.get("overridden")]
    safe = reliable or coherent[:2]
    used = set()

    def take(candidates, count, reverse=False):
        ordered = sorted(
            (asset for asset in candidates if asset["asset_id"] not in used),
            key=lambda asset: (
                asset.get("detail_score", 0), asset.get("rarity", 0),
                asset.get("confidence", 0), asset["asset_id"],
            ),
            reverse=reverse,
        )
        chosen = ordered[:count]
        used.update(asset["asset_id"] for asset in chosen)
        return chosen

    primary_assets = take(safe, min(3, len(safe)), reverse=False)
    secondary_candidates = sorted(
        coherent,
        key=lambda asset: (
            abs(visual_distance(anchor, asset) - .18) if anchor else 0,
            -asset.get("confidence", 0), asset["asset_id"],
        ),
    )
    secondary_assets = []
    for asset in secondary_candidates:
        if asset["asset_id"] not in used:
            secondary_assets.append(asset)
            used.add(asset["asset_id"])
        if len(secondary_assets) >= 3:
            break
    exceptional_assets = take(
        [asset for asset in coherent if not asset.get("ambiguous") or asset.get("overridden")],
        min(2, max(0, len(coherent) - len(used))),
        reverse=True,
    )

    transition_candidates = [
        asset for asset in sheets
        if asset["asset_id"] not in used and (
            asset.get("bridge_clusters") or (anchor and visual_distance(anchor, asset) <= .46)
        )
    ]
    transition_assets = sorted(
        transition_candidates,
        key=lambda asset: (-len(asset.get("bridge_clusters", [])), visual_distance(anchor, asset) if anchor else 0, asset["asset_id"]),
    )[:2]
    used.update(asset["asset_id"] for asset in transition_assets)

    # If analysis is sparse, preserve honesty rather than inventing four roles.
    if not primary_assets and sheets:
        primary_assets = [sheets[0]]
    primary = [
        _entry(asset, "primary", "base_visuelle_et_rythme_commun", max(12, brief.floors * 12), "proche des axes visuels et suffisamment sobre pour soutenir la scène")
        for asset in primary_assets
    ]
    secondary = [
        _entry(asset, "secondary", "variation_locale_et_accent_secondaire", max(6, brief.floors * 5), "compatible avec le vocabulaire principal mais assez distinct pour structurer une zone")
        for asset in secondary_assets
    ]
    exceptional = [
        _entry(asset, "exceptional", "landmark_ou_pic_visuel", 1, "détail ou rareté élevés; usage réservé à un moment visuel")
        for asset in exceptional_assets
    ]
    transition = [
        _entry(asset, "transition", "pont_visuel_entre_regions", max(3, brief.floors), "distance visuelle intermédiaire ou relation avec plusieurs familles")
        for asset in transition_assets
    ]

    texture = _choose_texture(bundles, brief)
    palette_rows = primary + secondary + exceptional
    palette = [row["dominant_rgb"] for row in palette_rows[:6]] or [[96, 96, 96]]
    selected_tiers = {
        row["asset_id"]: tier
        for tier, entries in (("primary", primary), ("secondary", secondary), ("transition", transition), ("exceptional", exceptional))
        for row in entries
    }
    uncertain = [
        {
            "asset_id": asset["asset_id"],
            "reasons": asset.get("uncertainty_reasons", []),
            "strategy": (
                "conservative_background_only" if selected_tiers.get(asset["asset_id"]) == "primary"
                else "conservative_support_only" if selected_tiers.get(asset["asset_id"]) in ("secondary", "transition")
                else "not_selected_without_override"
            ),
        }
        for asset in coherent if asset.get("ambiguous") and not asset.get("overridden")
    ]
    rejected = [
        {"asset_id": asset["asset_id"], "reason": "outside_selected_visual_distance"}
        for asset in ranked if asset["asset_id"] not in used and asset not in coherent
    ][:24]

    # Legacy role pools remain available to the Phase 1-compatible compiler and APIs.
    primary_ids = [row["asset_id"] for row in primary]
    secondary_ids = [row["asset_id"] for row in secondary] or primary_ids
    exceptional_ids = [row["asset_id"] for row in exceptional] or secondary_ids
    transition_ids = [row["asset_id"] for row in transition] or secondary_ids
    roles = {
        "common": primary_ids or ["generic_common"],
        "secondary": secondary_ids or ["generic_secondary"],
        "rare": transition_ids or ["generic_rare"],
        "focal": exceptional_ids or ["generic_focal"],
    }
    texture_values = texture["asset_id"].split(":", 1)[1].split("|") if texture else None
    cluster_id = anchor.get("cluster_id", "unclustered") if anchor else "unclustered"
    identity_hash = hashlib.sha256((brief.intent + "|" + "|".join(primary_ids)).encode()).hexdigest()[:12]
    strategies = _strategy_preferences(brief)
    direction = {
        "schema_version": "2.0.0",
        "identity_id": f"direction_{identity_hash}",
        "intent": brief.intent,
        "visual_axes": targets,
        "palette": palette,
        "vocabulary": {
            "primary": primary,
            "secondary": secondary,
            "exceptional": exceptional,
            "transition": transition,
        },
        "asset_budgets": {
            row["asset_id"]: row["budget"] for row in primary + secondary + exceptional + transition
        },
        "ambiguous_assets": uncertain,
        "rejected_assets": rejected,
        "strategy_preferences": strategies,
        "acts": [
            {
                "act": index + 1,
                "floor_range": [round(index * brief.floors / 4) + 1, max(round(index * brief.floors / 4) + 1, round((index + 1) * brief.floors / 4))],
                "identity_role": ["introduction_lisible", "developpement_et_variation", "escalade_et_contraste", "climax_et_resolution"][index],
                "vocabulary_priority": "primary" if index == 0 else "secondary" if index in (1, 2) else "exceptional",
                "density_intent": ["retenue", "variée", "contrastée", "focalisée"][index],
                "reason": "progression artistique calculée à l'échelle du donjon avant les étages",
            }
            for index in range(4)
        ],
        "principles": [
            "l'identité précède la décoration",
            "un asset n'est utilisé que s'il remplit une fonction de composition",
            "les éléments exceptionnels sont budgétés à l'échelle du donjon",
            "le vide et les zones neutres font partie de la composition",
            "une information ambiguë entraîne un choix conservateur",
        ],
        "decisions": [
            {
                "decision": "visual_axes",
                "why": target_reasons or ["axes neutres faute d'indice sémantique fort"],
                "evidence": sorted(set(brief.theme_tokens + brief.visual_keywords)),
            },
            {
                "decision": "primary_anchor",
                "asset_id": anchor["asset_id"] if anchor else None,
                "why": "meilleur compromis intention, métriques visuelles, usage observé et confiance",
                "confidence": anchor.get("confidence", 0) if anchor else 0,
            },
            {
                "decision": "asset_restraint",
                "selected_count": len(used),
                "compatible_count": len(coherent),
                "why": "la compatibilité seule ne justifie pas l'emploi d'un élément",
            },
        ],
        "runtime_selection": {
            "cluster_id": cluster_id,
            "cluster_score": round(_target_score(anchor, targets, brief), 3) if anchor else 0,
            "theme_tokens": sorted(set(brief.theme_tokens)),
            "roles": roles,
            "texture_bundle": texture["asset_id"] if texture else None,
            "texture_values": texture_values,
            "asset_count": len(used),
            "manual_override_applied": False,
            "direction_id": f"direction_{identity_hash}",
        },
    }

    locked = (overrides or {}).get("visual_language", {})
    if locked:
        direction["runtime_selection"].update({key: value for key, value in locked.items() if value is not None})
        direction["runtime_selection"]["manual_override_applied"] = True
        direction["decisions"].append({"decision": "human_visual_language_override", "keys": sorted(locked)})
    return direction
