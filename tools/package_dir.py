#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
package_dir.py — Convertit une image PNG en fichier .dir compatible RogueEssence / PMDO.
Il ajoute les 16 octets de métadonnées requis à la fin du fichier PNG :
[ PNG complet ] [ frameWidth (u32) ] [ frameHeight (u32) ] [ 0 (u32) ] [ frameCount (u32) ]

Auteur : Arena Agent
Date : 2026-07-29
"""

import sys
import struct
import os

def package_to_dir(png_path, dir_path):
    if not os.path.exists(png_path):
        print(f"Erreur : Le fichier PNG '{png_path}' n'existe pas.")
        return False

    # Lire l'image PNG pour extraire ses dimensions de l'IHDR
    with open(png_path, 'rb') as f:
        png_data = f.read()

    # Recherche de la signature PNG et du bloc IHDR
    ihdr_idx = png_data.find(b'IHDR')
    if ihdr_idx < 0:
        print("Erreur : Le fichier n'est pas un PNG valide.")
        return False

    # Les dimensions de l'image (Width et Height) sont stockées en big-endian de 4 octets juste après 'IHDR'
    width, height = struct.unpack('>II', png_data[ihdr_idx+4 : ihdr_idx+12])

    print(f"Image PNG détectée : {width}x{height} pixels.")

    # Préparation des 16 octets de métadonnées en little-endian
    # frameWidth, frameHeight, 0, frameCount
    metadata = struct.pack('<4I', width, height, 0, 1)

    # Écriture du fichier .dir final
    with open(dir_path, 'wb') as f:
        f.write(png_data)
        f.write(metadata)

    print(f"✓ Fichier .dir créé avec succès : {dir_path}")
    print(f"  → Dimensions de frame enregistrées : {width}x{height} pixels, 1 frame.")
    return True

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Usage : python3 tools/package_dir.py <chemin_png> <chemin_destination_dir>")
        print("Exemple : python3 tools/package_dir.py celestial_peak_entrance_pixelart.png Content/BG/celestial_peak_entrance_pixelart.dir")
        sys.exit(1)

    png_in = sys.argv[1]
    dir_out = sys.argv[2]
    package_to_dir(png_in, dir_out)
