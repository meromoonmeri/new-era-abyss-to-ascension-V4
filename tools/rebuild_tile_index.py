#!/usr/bin/env python3
"""Régénère Content/Tile/index.idx à partir de tous les .tile présents.

Format (docs/CONTEXTE_PROJET.md) :
  uint32 nbTilesets
  pour chacun : uint8 lenNom, nom UTF-8, uint32 tileSize, uint32 tileCount,
                copie de la table (tileCount × 16 octets)

--------------------------------------------------------------------
CORRECTIF 2026-08-04 — ce script a provoqué un ECRAN NOIR GENERAL
--------------------------------------------------------------------
Il régénère l'index à partir des SEULS fichiers présents dans
Content/Tile. Or le plan de travail est un CHECKOUT PARTIEL : il ne
contient que les 10 planches en cours d'édition, pas les 546 du dépôt.
L'index est donc passé de 537 entrées (16,1 Mo) à 10 (539 ko), et toutes
les cartes du jeu — Metano en tête — ont perdu la déclaration de leur
tileset. Le moteur ne trouvait plus la planche : écran noir.

Mesuré : commit 9c0ed26, index.idx 16 153 898 o -> 123 984 o.
Aucun .tile n'avait été supprimé, seul l'index était amputé.

DEUX GARDE-FOUS, tous deux nécessaires :

1. FUSION AU LIEU DE REECRITURE. On relit l'index existant et on n'y
   REMPLACE que les planches réellement présentes sur le disque. Une
   entrée dont le .tile est absent du plan de travail est CONSERVEE
   telle quelle, octet pour octet. C'est le comportement correct dans
   un checkout partiel comme dans un checkout complet.

2. REFUS DE L'AMPUTATION. Si le résultat comptait moins d'entrées que
   l'index de départ, on s'arrête sans rien écrire. Une régénération
   ne doit jamais faire DISPARAITRE une déclaration.

Passer --repartir-de-zero force l'ancien comportement (utile seulement
sur un checkout complet, à vérifier avant).
"""
import argparse
import os
import struct
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TILE_DIR = os.path.join(ROOT, 'Content', 'Tile')
IDX = os.path.join(TILE_DIR, 'index.idx')


def lire_index(chemin):
    """Renvoie {nom: (tileSize, tileCount, table_brute)}.

    Lecture stricte : on vérifie que le curseur tombe exactement sur la
    fin du fichier. Un index tronqué doit être détecté ici, pas par le
    moteur au chargement d'une carte.
    """
    if not os.path.exists(chemin):
        return {}
    b = open(chemin, 'rb').read()
    n = struct.unpack_from('<I', b, 0)[0]
    i = 4
    d = {}
    for _ in range(n):
        ln = b[i]
        i += 1
        nom = b[i:i + ln].decode('utf-8')
        i += ln
        tile_size, tile_count = struct.unpack_from('<II', b, i)
        i += 8
        table = b[i:i + tile_count * 16]
        if len(table) != tile_count * 16:
            raise ValueError(f'index tronque sur {nom}')
        i += tile_count * 16
        d[nom] = (tile_size, tile_count, table)
    if i != len(b):
        raise ValueError(f'octets en trop dans l index : {len(b) - i}')
    return d


def ecrire_index(chemin, entrees):
    out = bytearray()
    out += struct.pack('<I', len(entrees))
    for nom in sorted(entrees):
        tile_size, tile_count, table = entrees[nom]
        enc = nom.encode('utf-8')
        if len(enc) > 255:
            raise ValueError(f'nom trop long : {nom}')
        out += struct.pack('<B', len(enc)) + enc
        out += struct.pack('<II', tile_size, tile_count)
        out += table
    open(chemin, 'wb').write(bytes(out))
    return len(out)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--repartir-de-zero', action='store_true',
                    help='ignore l index existant (checkout COMPLET seulement)')
    a = ap.parse_args()

    avant = {} if a.repartir_de_zero else lire_index(IDX)
    presents = sorted(f[:-5] for f in os.listdir(TILE_DIR)
                      if f.endswith('.tile'))

    entrees = dict(avant)
    maj, nouveaux = 0, 0
    for nm in presents:
        data = open(os.path.join(TILE_DIR, nm + '.tile'), 'rb').read()
        tile_size, tile_count = struct.unpack_from('<II', data, 0)
        table = data[8:8 + tile_count * 16]
        if len(table) != tile_count * 16:
            print(f'ABANDON : {nm}.tile est tronque.')
            return 1
        if nm in entrees:
            if entrees[nm] != (tile_size, tile_count, table):
                maj += 1
        else:
            nouveaux += 1
        entrees[nm] = (tile_size, tile_count, table)

    # GARDE-FOU : une regeneration ne doit jamais amputer l index.
    if len(entrees) < len(avant):
        print(f'ABANDON : {len(avant)} entrees avant, {len(entrees)} apres. '
              'Une regeneration ne doit rien faire disparaitre.')
        return 1

    conservees = len(entrees) - len(presents)
    taille = ecrire_index(IDX, entrees)
    print(f'index.idx : {len(entrees)} tilesets, {taille} octets')
    print(f'  {nouveaux} ajoutes, {maj} mis a jour, '
          f'{conservees} conservees (fichier absent du plan de travail)')

    # Relecture : le fichier qu on vient d ecrire doit se reparser.
    relu = lire_index(IDX)
    if relu != entrees:
        print('ABANDON : le round-trip a echoue.')
        return 1
    print('  round-trip verifie')
    return 0


if __name__ == '__main__':
    sys.exit(main())
