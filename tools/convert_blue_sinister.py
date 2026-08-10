#!/usr/bin/env python3
"""
SQUELETTE TECHNIQUE NON EXÉCUTÉ — ne doit rien écrire dans les données du jeu
But: infrastructure d'audit pour le futur mapping Blue → PMDO
Tant que b10fon/b10cel/b10pal ne sont pas décodés, toutes les valeurs restent UNKNOWN
et aucune conversion automatique n'est effectuée.

Ce script ne génère pas de faux floors et ne contient aucune valeur inventée.
Il sera activé uniquement après que audit_blue_sinister.py ait produit
une table F1→F13 avec SOURCE_NDS prouvée pour chaque champ.
"""
import pathlib, json, sys

MOD_ROOT = pathlib.Path(__file__).resolve().parents[1]
ZONE_OUT = MOD_ROOT / "Data/Zone/gloomy_forest.json"

# Matrice de provenance — toutes les cellules sont UNKNOWN tant que NDS non décodé
# Ne pas remplir avec des valeurs pmd-red ou RogueElements supposées

MATRICE_PROVENANCE = {
    "Floors": {
        "source_NDS": "b10canm/b10fon non décodés (SIR0 décompressé 1088/10177 o, header 0c00 0d00 NOT DECODED)",
        "cross_reference_red": "pmd-red 13 étages (MainData 17-29) — concordance à vérifier, pas source",
        "derived_mapping": "UNKNOWN — ne pas mapper CellWidth 10 etc. tant que b10fon non décodé",
        "PMDO_value": "gloomy_forest.json actuel 11 segments 15+5+1+3+1 (conservé gelé)",
        "test": "UNKNOWN"
    },
    "Géométrie": {
        "grille": "UNKNOWN (b10fon NOT DECODED) — refuser 10x10, Room 4-8 etc. sans champ binaire",
        "salles": "UNKNOWN",
        "couloirs": "UNKNOWN",
        "branchements": "UNKNOWN",
        "escaliers": "UNKNOWN",
        "Monster Houses": "UNKNOWN",
        "Kecleon": "UNKNOWN",
    },
    "Pokémon": {
        "F1": "UNKNOWN (b10cel NOT DECODED) — ne pas utiliser pmd-red oddish/sudowoodo comme preuve Blue",
        "F2": "UNKNOWN",
        "F3": "UNKNOWN",
        "F4": "UNKNOWN",
        "F5": "UNKNOWN",
        "F6": "UNKNOWN",
        "F7": "UNKNOWN",
        "F8": "UNKNOWN",
        "F9": "UNKNOWN",
        "F10": "UNKNOWN",
        "F11": "UNKNOWN",
        "F12": "UNKNOWN",
        "F13": "UNKNOWN",
    },
    "Items": {
        "F1": "UNKNOWN (b10fon Items 11/12 NOT DECODED)",
        "F13": "UNKNOWN",
    },
    "Traps": {
        "F1": "UNKNOWN (Traps 2 NOT DECODED)",
    },
    "Terrain": {
        "tile_source": "UNKNOWN (b10canm NOT DECODED)",
        "terrain_source": "UNKNOWN",
        "collision_source": "UNKNOWN",
        "PMDO_Tile": "UNKNOWN",
    },
    "Musique": {
        "source_NDS": "sound.sbin ID 12 NOT EXTRACTED",
        "PMDO_value": "Mystifying Forest.ogg (placeholder, conservé gelé)",
    },
}

def main():
    print("=== SQUELETTE convert_blue_sinister.py — NON EXÉCUTÉ ===")
    print("Ce script ne modifie PAS gloomy_forest.json, les Grounds, les spawns, la musique ou le boss.")
    print("Il attend que audit_blue_sinister.py ait décodé b10fon/b10cel/b10pal")
    print("\nMatrice de provenance actuelle (toutes UNKNOWN tant que NDS non décodé):")
    print(json.dumps(MATRICE_PROVENANCE, indent=2, ensure_ascii=False))
    print("\nAucune conversion automatique n'a été effectuée.")
    print("Prochaine étape prioritaire: b10fon → décodage des pointeurs SIR0 → structures → F1-F13")
    # Ne rien écrire
    # open(ZONE_OUT, 'w').write(...)  # DÉSACTIVÉ
    sys.exit(0)

if __name__ == "__main__":
    main()
