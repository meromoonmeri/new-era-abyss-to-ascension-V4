#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
create_handdrawn_rsground.py — Génère une carte .rsground basée sur un fond pixel art pré-rendu (hand-drawn/painted background).
Cette méthode permet d'utiliser de magnifiques illustrations pixel art (comme celestial_peak_entrance_pixelart)
et de configurer un masque d'obstacles à l'échelle 8x8px pour respecter la logique spatiale.

Auteur : Arena Agent
Date : 2026-07-29
"""

import json
import os
import sys

def make_obstacle(x, y, w, h, tags=0):
    """Crée un bloc de collision."""
    return {
        "$type": "RogueElements.TileBlock, RogueElements",
        "Color": "#FF000000",
        "Rectangle": {"X": x, "Y": y, "Width": w, "Height": h},
        "Tags": tags
    }

def generate_handdrawn_ground(asset_name, name_en, name_fr, width_px, height_px, walkable_rects, music_bg="Sky Peak Cave.ogg"):
    """
    Génère un dictionnaire au format JSON .rsground (RogueEssence GroundMap)
    avec un fond d'image pré-rendu et une grille de collision personnalisée.
    
    Arguments :
      - asset_name: Nom du fond d'image (ex: 'celestial_peak_entrance_pixelart')
      - name_en: Nom anglais de la carte
      - name_fr: Nom français de la carte
      - width_px: Largeur de la carte en pixels (ex: 480 ou 640)
      - height_px: Hauteur de la carte en pixels (ex: 360 ou 480)
      - walkable_rects: Liste de rectangles walkables [(x, y, w, h), ...] en pixels.
                        Tout ce qui n'est pas dans ces rectangles sera bloqué (Tags=1).
      - music_bg: Thème musical de la zone
    """
    
    # Nombre de tuiles de 32x32px nécessaires pour couvrir les dimensions de l'image
    w_tiles = (width_px + 31) // 32
    h_tiles = (height_px + 31) // 32
    
    # Grid de collisions à l'échelle 8x8px (RogueEssence obstacles)
    # W_obs et H_obs représentent la taille de la grille d'obstacles
    w_obs = w_tiles * 4
    h_obs = h_tiles * 4
    
    # Par défaut, tout est bloqué (Tags = 1)
    obstacle_grid = [[1 for _ in range(h_obs)] for _ in range(w_obs)]
    
    # On applique les rectangles marchables (Tags = 0)
    for (rx, ry, rw, rh) in walkable_rects:
        # Conversion des coordonnées pixels en coordonnées d'obstacles 8x8px
        g_start_x = max(0, rx // 8)
        g_start_y = max(0, ry // 8)
        g_end_x = min(w_obs, (rx + rw + 7) // 8)
        g_end_y = min(h_obs, (ry + rh + 7) // 8)
        
        for x in range(g_start_x, g_end_x):
            for y in range(g_start_y, g_end_y):
                obstacle_grid[x][y] = 0 # 0 = Walkable
                
    # Formatage de la grille d'obstacles pour le JSON
    obstacles_json = []
    for x in range(w_obs):
        row = []
        for y in range(h_obs):
            row.append({
                "Bounds": {
                    "X": x * 8,
                    "Y": y * 8,
                    "Width": 8,
                    "Height": 8
                },
                "Tags": obstacle_grid[x][y]
            })
        obstacles_json.append(row)
        
    # Couche de tuiles vide (on utilise le fond d'écran pré-rendu pour le visuel,
    # les tuiles servent juste à définir la taille logique de la carte)
    empty_tile = {
        "AutoTileset": "",
        "Associates": [],
        "Layers": [],
        "NeighborCode": -1
    }
    
    tiles_grid = [[empty_tile for _ in range(h_tiles)] for _ in range(w_tiles)]
    
    # Assemblage de la GroundMap RogueEssence
    ground_map = {
        "Version": "0.8.9.0",
        "Object": {
            "$type": "RogueEssence.Ground.GroundMap, RogueEssence",
            "TexSize": 1,
            "Name": {
                "DefaultText": name_en,
                "LocalTexts": {"fr": name_fr}
            },
            "Released": False,
            "Comment": "Pre-rendered pixel art background with custom 8x8 spatial logic collision map.",
            "AssetName": asset_name,
            "Music": music_bg,
            "EdgeView": 1,
            "NoSwitching": False,
            "ViewCenter": None,
            "ViewOffset": {"X": 0, "Y": 0},
            "ActiveChar": None,
            "obstacles": obstacles_json,
            "rand": {
                "$type": "RogueEssence.Ground.AutoTile.RandImg, RogueEssence",
                "MinBoundary": {"X": 0, "Y": 0},
                "MinBorderBoundary": {"X": 0, "Y": 0}
            },
            "Status": {},
            "Background": {
                "$type": "RogueEssence.Dungeon.MapBG, RogueEssence",
                "MapLoc": {"X": 0, "Y": 0},
                "BGAnim": {
                    "AnimIndex": asset_name, # Ici on lie l'image de fond pré-rendue (ex: de Content/BG/)
                    "FrameTime": 1,
                    "StartFrame": -1,
                    "EndFrame": -1,
                    "AnimDir": -1,
                    "Alpha": 255,
                    "AnimFlip": False
                }
            },
            "BlankBG": {
                "AutoTileset": "",
                "Associates": [],
                "Layers": [],
                "NeighborCode": -1
            },
            "Layers": [
                {
                    "Name": "Visual Tile Size Grid",
                    "Layer": 0,
                    "Visible": True,
                    "Tiles": tiles_grid
                }
            ],
            "Decorations": [
                {
                    "Name": "New Deco",
                    "Layer": 0,
                    "Visible": True,
                    "Anims": {
                        "$type": "System.Collections.Generic.List`1[[RogueEssence.Ground.GroundAnim, RogueEssence]], System.Private.CoreLib",
                        "$values": []
                    }
                }
            ],
            "Entities": [
                {
                    "Name": "New EntLayer",
                    "Visible": True,
                    "MapChars": [],
                    "GroundObjects": [
                        {
                            "EntName": "Dungeon_Entrance",
                            "Position": {"X": (width_px // 2) - 16, "Y": height_px - 48, "Width": 32, "Height": 32},
                            "EntEnabled": True,
                            "EntOrder": 0,
                            "InteractOrder": 0,
                            "triggerType": 0
                        },
                        {
                            "EntName": "Kangaskhan_Rock",
                            "Position": {"X": (width_px // 2) - 16, "Y": 32, "Width": 32, "Height": 32},
                            "EntEnabled": True,
                            "EntOrder": 0,
                            "InteractOrder": 0,
                            "triggerType": 0
                        }
                    ],
                    "Spawners": [
                        {"Spawns": {"$type": "System.Collections.Generic.List`1[[RogueEssence.Ground.GroundSpawner+GroundSpawn, RogueEssence]], System.Private.CoreLib", "$values": []}} for _ in range(5)
                    ],
                    "Markers": [
                        {
                            "EntName": "Main_Entrance_Marker",
                            "Direction": 4,
                            "EntEnabled": True,
                            "EntOrder": 0,
                            "InteractOrder": 0,
                            "triggerType": 0,
                            "Collider": {"X": (width_px // 2) - 16, "Y": height_px - 80, "Width": 32, "Height": 32}
                        }
                    ]
                }
            ]
        }
    }
    
    return ground_map

if __name__ == '__main__':
    # Exemple : Générer la carte d'entrée du Pic Céleste à partir de l'image pixel art générée
    # Supposons que l'image fait 1024x680 pixels (ou redimensionnée)
    # Nous définissons des rectangles marchables correspondant au pont et aux chemins de pierre.
    
    # Chemin et nom de l'image de fond (doit être placée dans Content/BG/celestial_peak_entrance_pixelart.dir)
    bg_asset = "celestial_peak_entrance_pixelart"
    
    # Exemple de zones marchables en pixels adaptés à la taille réelle 1376x768 :
    # 1. Un chemin principal montant depuis le bas (largeur de 200px)
    # 2. Le pont de singe qui traverse au centre
    # 3. La zone d'arrivée de la caverne à droite
    walkable_areas = [
        (450, 500, 400, 268),  # Zone et chemin du bas (spawn de départ)
        (250, 300, 800, 220),  # Zone intermédiaire, pont de singe
        (850, 100, 450, 250),  # Zone d'arrivée de la caverne à droite
    ]
    
    ground_data = generate_handdrawn_ground(
        asset_name=bg_asset,
        name_en="Celestial Peak Entrance",
        name_fr="Entrée du Pic Céleste",
        width_px=1376,
        height_px=768,
        walkable_rects=walkable_areas,
        music_bg="Sky Peak Cave.ogg"
    )
    # Remplacer directement celestial_peak_entrance
    ground_data["Object"]["AssetName"] = "celestial_peak_entrance"
    
    out_dir = "Data/Ground"
    os.makedirs(out_dir, exist_ok=True)
    out_file = os.path.join(out_dir, "celestial_peak_entrance.rsground")
    
    with open(out_file, 'w', encoding='utf-8-sig') as f:
        json.dump(ground_data, f, ensure_ascii=False, indent=2)
        
    print(f"✓ Fichier de carte .rsground généré avec succès : {out_file}")
    print(f"  → Image de fond liée : Content/BG/{bg_asset}.dir")
    print(f"  → Grille de collision 8x8px générée à partir des rectangles marchables.")
