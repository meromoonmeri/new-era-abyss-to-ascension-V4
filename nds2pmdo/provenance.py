"""Règles de provenance strictes du pipeline.

Chaque donnée importante doit pouvoir être classée dans l'une de ces catégories.
Une donnée non décodée reste UNKNOWN. Remplir un champ avec une valeur supposée
uniquement parce qu'elle semble plausible est interdit.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum
from typing import Any


class Provenance(str, Enum):
    SOURCE_NDS = "SOURCE_NDS"                    # octets lus directement dans la ROM APHP
    SOURCE_NDS_DECODED = "SOURCE_NDS_DECODED"    # octets ROM décompressés/décodés
    CROSS_REFERENCE = "CROSS_REFERENCE"          # autre projet (pmd-red, SkyTemple…) — jamais une preuve NDS
    DERIVED_MAPPING = "DERIVED_MAPPING"          # règle de correspondance dérivée
    PMDO_VALUE = "PMDO_VALUE"                    # état actuel du mod New Era — jamais une preuve NDS
    UNKNOWN = "UNKNOWN"                          # non décodé — aucune valeur inventée
    ADAPTATION_REQUIRED = "ADAPTATION_REQUIRED"  # sans équivalent direct PMDO, stratégie documentée
    MISSING = "MISSING"                          # ressource absente, signalée explicitement
    NOT_DECODED = "NOT_DECODED"                  # présent mais non décodé


@dataclass
class ProvenanceRecord:
    """Traçabilité d'une donnée : d'où elle vient, comment elle a été décodée, par quoi."""
    value: Any = None
    provenance: Provenance = Provenance.UNKNOWN
    source_file: str | None = None      # ex. dungeon.sbin/mapparam
    source_offset: int | None = None    # offset dans le fichier source
    source_map: str | None = None       # ex. dungeon#3
    source_floor: int | None = None     # étage 1..13
    decoder: str | None = None          # outil/module qui a décodé
    converter_version: str | None = None  # version du convertisseur
    note: str | None = None
    cross_reference_from: str | None = None  # ex. pret/pmd-red (si CROSS_REFERENCE)
    raw: dict[str, Any] = field(default_factory=dict)

    def to_dict(self) -> dict[str, Any]:
        return {
            "value": self.value,
            "provenance": self.provenance.value,
            "source_file": self.source_file,
            "source_offset": self.source_offset,
            "source_map": self.source_map,
            "source_floor": self.source_floor,
            "decoder": self.decoder,
            "converter_version": self.converter_version,
            "note": self.note,
            "cross_reference_from": self.cross_reference_from,
        }


def tag(value: Any, prov: Provenance, **kw) -> dict[str, Any]:
    """Court-circuit pour construire un dict de provenance."""
    d = {"value": value, "provenance": prov.value}
    d.update({k: v for k, v in kw.items() if v is not None})
    return d
