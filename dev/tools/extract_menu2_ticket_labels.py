#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""extract_menu2_ticket_labels.py — labels canoniques des cases `menu2(N)`
du script loterie Spinda Café (P01P04A/s30a0601.ssb, seul usage ROM).

Sémantique prouvée ROM : le menu « Select which Ticket to use » liste les
tickets possédés ; chaque `case menu2(N)` (N=2..5) branche sur un type de
ticket, prouvé par le corps de chaque branche (« Draw a [CS:I]X Ticket[CR]? » :
2=Prize @label_34, 3=Silver @label_36, 4=Gold @label_37, 5=Prism @label_38).
Les libellés 5 langues sont extraits des Strings ROM EU (MESSAGE/text_*.str,
ids item 6944-6947) — AUCUN texte inventé.

Sortie : dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables/MENU2_TICKET_LABELS.json
"""
import glob
import json
import os

from ndspy.rom import NintendoDSRom
from skytemple_files.common.types.file_types import FileType

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS",
                   "Tables", "MENU2_TICKET_LABELS.json")
ROM_GLOB = os.path.join(REPO, ".runtime-cache", "sky-rom", "*.nds")

# id Strings ROM EU des noms d'objets tickets (vérifié : text_e.str
# 6944='Prize Ticket', 6945='Silver Ticket', 6946='Gold Ticket',
# 6947='Prism Ticket')
STR_IDS = {"2": 6944, "3": 6945, "4": 6946, "5": 6947}
LANGS = {"english": "text_e.str", "french": "text_f.str",
         "german": "text_g.str", "italian": "text_i.str",
         "spanish": "text_s.str"}


def main():
    rompath = sorted(glob.glob(ROM_GLOB))
    if not rompath:
        raise SystemExit("ROM Sky EU absente (.runtime-cache/sky-rom)")
    rom = NintendoDSRom.fromFile(rompath[0])
    strs = {}
    for lang, fn in LANGS.items():
        strs[lang] = FileType.STR.deserialize(
            rom.getFileByName("MESSAGE/" + fn)).strings
    assert strs["english"][6944] == "Prize Ticket", strs["english"][6944]
    labels = {}
    for m2id, sid in STR_IDS.items():
        labels[m2id] = {lang: strs[lang][sid] for lang in LANGS}
    doc = {
        "schema": "sky-menu2-ticket-labels/1",
        "authority": "Strings ROM Sky EU MESSAGE/text_*.str ids 6944-6947 "
                     "(noms d'objets tickets) ; mapping menu2(N)->ticket "
                     "prouvé par les corps de branche de "
                     "P01P04A/s30a0601.ssb",
        "labels": labels,
    }
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    json.dump(doc, open(OUT, "w", encoding="utf-8"),
              ensure_ascii=False, indent=1)
    print("OK", OUT, json.dumps(labels["2"], ensure_ascii=False))


if __name__ == "__main__":
    main()
