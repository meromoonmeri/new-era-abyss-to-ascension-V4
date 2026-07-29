#!/usr/bin/env python3
# =============================================================================
# gen_entrance.py — Generateur d'entrances de donjon (avenue Kangourex).
#
#   python3 tools/mapgen/gen_entrance.py lister
#       Audit de coherence des entrances existantes (tileset <-> biome).
#       Aucune ecriture.
#
#   python3 tools/mapgen/gen_entrance.py generer --ground NOM --zone DUNGEON
#       --depart BIOME_DEPART --orientation ORIENT [--template TEMPLATE]
#       [--ecrire]
#       Genere un ground d'entrance avec transition de biome entre le point
#       de depart et le donjon cible.
#       ORIENT = 'ew' (est-ouest), 'we' (ouest-est), 'sn' (sud-nord)
#       TEMPLATE = entrance existante a cloner (defaut : crystal_sanctuary_entrance)
#
#   python3 tools/mapgen/gen_entrance.py verifier --ground NOM
#       Validation avant sortie : coherence tileset, pas de duplication
#       d'entrance existante, protection ch1-5.
#
# REGLE ABSOLUE : ne JAMAIS toucher aux entrances des chapitres 1 a 5.
# =============================================================================
import json, os, sys, copy, argparse, glob

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, '..', '..'))
DB_TS = os.path.join(HERE, 'data', 'tilesets_donjons.json')
DB_BIO = os.path.join(HERE, 'data', 'biomes_zones.json')

# =============================================================================
# PROTECTION : entrances ch1-5 — JAMAIS modifiees
# =============================================================================
ENTRANCES_PROTEGEES = {
    # Chapitre 1-2
    'illuminant_riverbed_entrance',
    # Chapitre 3
    'crooked_cavern_entrance',
    # Chapitre 4
    'apricorn_grove_entrance',
    # Chapitre 5 (expedition — 3 donjons)
    'vast_steppe_entrance',
    'searing_tunnel_entrance',
    'mount_windswept_entrance',
}

# Toutes les entrances connues du depot
ENTRANCES_CONNUES = {}
for _p in sorted(glob.glob(os.path.join(ROOT, 'Data', 'Ground', '*_entrance.rsground'))):
    _name = os.path.basename(_p)[:-9]  # retire .rsground
    _prot = _name in ENTRANCES_PROTEGEES
    ENTRANCES_CONNUES[_name] = {'path': _p, 'protege': _prot}

# Orientations supportees
ORIENTATIONS = {
    'ew': {'label': 'Est → Ouest', 'dx': 1, 'dy': 0},
    'we': {'label': 'Ouest → Est', 'dx': -1, 'dy': 0},
    'sn': {'label': 'Sud → Nord', 'dx': 0, 'dy': -1},
}

# Template par defaut (le plus generique, tileset cristal = neutre)
TEMPLATE_DEFAUT = 'crystal_sanctuary_entrance'


def load_db():
    if not os.path.exists(DB_TS):
        sys.exit('Base absente : lancer python3 tools/mapgen/extract_tileset_db.py')
    ts = json.load(open(DB_TS, encoding='utf-8'))['tilesets']
    bio = json.load(open(DB_BIO, encoding='utf-8'))['zones']
    return ts, bio


def ground_path(nom):
    return os.path.join(ROOT, 'Data', 'Ground', f'{nom}.rsground')


def autotiles_du(obj):
    """Compte les autotiles utilises dans un Object de ground."""
    compte = {}
    for lay in obj.get('Layers', []):
        for col in lay.get('Tiles', []):
            for cell in col:
                a = cell.get('AutoTileset', '')
                if a:
                    compte[a] = compte.get(a, 0) + 1
    return compte


def entites_du(obj):
    """Liste les entites (objets) d'un ground."""
    ents = []
    for ent in obj.get('Entities', []):
        ents.append({
            'name': ent.get('_name', ent.get('Name', '?')),
            'type': ent.get('$type', '?'),
            'loc': ent.get('Loc', ent.get('loc', {})),
        })
    return ents


def tilesets_de_zone(ts, bio, zone):
    """Tous les tilesets (floor) utilises par une zone."""
    out = []
    # 1. Segments de la zone (biomes_zones.json)
    if zone in bio:
        for seg in bio[zone].get('segments', []):
            for t in seg.get('tilesets', []):
                if t not in out:
                    out.append(t)
    # 2. Recherche inverse : tilesets dont la zone apparait dans leur champ zones
    for name, data in ts.items():
        if zone in data.get('zones', []) and name not in out:
            out.append(name)
    return out


def tilesets_de_biome(ts, bio, biome_name):
    """Trouve les tilesets correspondant a un biome (recherche fuzzy)."""
    # 1. Recherche directe dans les zones
    direct = tilesets_de_zone(ts, bio, biome_name)
    if direct:
        return direct
    # 2. Recherche par fragment de nom de tileset
    matches = []
    for name in ts:
        if biome_name.lower() in name.lower():
            matches.append(name)
    if matches:
        return matches
    # 3. Recherche par fragment de nom de zone
    for zone_name in bio:
        if biome_name.lower() in zone_name.lower():
            found = tilesets_de_zone(ts, bio, zone_name)
            if found:
                return found
    return []


def triplet_du_tileset(ts, floor_name):
    """Retourne (floor, wall, secondary) pour un tileset floor donne."""
    if floor_name not in ts:
        return None
    d = ts[floor_name]
    return (floor_name, d.get('wall', ''), d.get('water_wall', d.get('wall', '')))


def signature_entrance(obj):
    """Signature unique d'une entrance pour detection de doublons."""
    autos = set(autotiles_du(obj).keys())
    dims = (len(obj.get('Layers', [{}])[0].get('Tiles', [])),
            len(obj.get('Layers', [{}])[0].get('Tiles', [[]])[0])
            if obj.get('Layers', [{}])[0].get('Tiles', []) else 0)
    ents = len(obj.get('Entities', []))
    return (frozenset(autos), dims, ents)


# =============================================================================
# COMMANDE : lister
# =============================================================================
def cmd_lister(args):
    """Audit de coherence tileset <-> biome pour toutes les entrances."""
    ts, bio = load_db()
    print(f'{"entrance":<36} {"protege":>8} {"autotiles":40} {"verdict"}')
    print('-' * 120)

    for name, info in sorted(ENTRANCES_CONNUES.items()):
        if not os.path.exists(info['path']):
            continue
        try:
            root = json.load(open(info['path'], encoding='utf-8-sig'))
            obj = root.get('Object', root)
        except Exception:
            continue

        autos = autotiles_du(obj)
        auto_str = ','.join(sorted(autos.keys())) if autos else '(feuilles/manuel)'
        prot = 'OUI' if info['protege'] else ''

        # Determiner le donjon associe
        zone = name.replace('_entrance', '')
        if zone in bio:
            attendus = tilesets_de_zone(ts, bio, zone)
            if not autos:
                verdict = 'visuel dedie (hors autotiles)'
            elif any(a in attendus for a in autos):
                verdict = f'COHERENT avec {zone}'
            else:
                verdict = f'A ASSORTIR -> {attendus[0] if attendus else "?"}'
        else:
            verdict = 'zone inconnue dans biomes_zones.json'

        if info['protege']:
            verdict += ' [PROTEGE ch1-5]'

        print(f'{name:<36} {prot:>8} {auto_str:40} {verdict}')

    print()
    print(f'Total : {len(ENTRANCES_CONNUES)} entrances '
          f'({len(ENTRANCES_PROTEGEES)} protegees ch1-5)')
    return 0


# =============================================================================
# COMMANDE : generer
# =============================================================================
def cmd_generer(args):
    """Genere un ground d'entrance avec transition de biome."""
    ts, bio = load_db()

    # Protection ch1-5
    if args.ground in ENTRANCES_PROTEGEES:
        sys.exit(f'REFUS : {args.ground} est une entrance ch1-5 PROTEGEE. '
                 f'Ne jamais regenerer les entrances validees.')

    # Validation orientation
    if args.orientation not in ORIENTATIONS:
        sys.exit(f'Orientation invalide : {args.orientation}. '
                 f'Choix : {", ".join(ORIENTATIONS.keys())}')

    # Charger le template
    template_name = args.template or TEMPLATE_DEFAUT
    template_path = ground_path(template_name)
    if not os.path.exists(template_path):
        sys.exit(f'Template introuvable : {template_path}')

    template_root = json.load(open(template_path, encoding='utf-8-sig'))
    template_obj = template_root.get('Object', template_root)

    # Determiner les tilesets de depart et d'arrivee
    ts_depart = tilesets_de_biome(ts, bio, args.depart)
    if not ts_depart:
        sys.exit(f'Aucun tileset trouve pour le biome depart "{args.depart}"')

    ts_dungeon = tilesets_de_zone(ts, bio, args.zone)
    if not ts_dungeon:
        # Fallback : chercher par elements du donjon
        if args.zone in bio:
            elements = set()
            for seg in bio[args.zone].get('segments', []):
                for e in seg.get('elements', []):
                    elements.add(e)
            if elements:
                for name, data in ts.items():
                    if set(data.get('elements', [])) & elements:
                        ts_dungeon.append(name)
                        if len(ts_dungeon) >= 3:
                            break
        if not ts_dungeon:
            sys.exit(f'Aucun tileset trouve pour la zone "{args.zone}". '
                     f'Cette zone n\'a pas encore de tilesets assignes dans '
                     f'biomes_zones.json. Assigner d\'abord avec gen_map.py.')

    # Triplets
    triplet_depart = triplet_du_tileset(ts, ts_depart[0])
    triplet_dungeon = triplet_du_tileset(ts, ts_dungeon[0])

    if not triplet_depart or not triplet_dungeon:
        sys.exit('Impossible de resoudre les triplets tileset.')

    print(f'Generation entrance : {args.ground}')
    print(f'  Template    : {template_name}')
    print(f'  Orientation : {ORIENTATIONS[args.orientation]["label"]}')
    print(f'  Depart      : {args.depart} -> {triplet_depart[0]}')
    print(f'  Donjon      : {args.zone} -> {triplet_dungeon[0]}')
    print()

    # Cloner le template
    new_root = copy.deepcopy(template_root)
    new_obj = new_root.get('Object', new_root)

    # Remplacer les autotiles : transition progressive
    # Strategie : la moitie des cellules vers le biome de depart,
    # l'autre moitie vers le biome du donjon (transition douce)
    autos_template = autotiles_du(template_obj)
    correspondance = {}
    for name in autos_template:
        if name.endswith('_floor'):
            # Les premieres cellules (cote arrivee) = biome depart
            # Les dernieres (cote donjon) = biome donjon
            correspondance[name] = {
                'depart': triplet_depart[0],
                'donjon': triplet_dungeon[0],
            }
        elif name.endswith('_wall'):
            correspondance[name] = {
                'depart': triplet_depart[1],
                'donjon': triplet_dungeon[1],
            }
        elif name.endswith('_secondary'):
            correspondance[name] = {
                'depart': triplet_depart[2],
                'donjon': triplet_dungeon[2],
            }

    # Appliquer la transition : les cellules sont parcourues dans l'ordre
    # de l'avenue (selon l'orientation). Premiere moitie = depart,
    # seconde moitie = donjon.
    orient = ORIENTATIONS[args.orientation]
    total_cells = 0
    for lay in new_obj.get('Layers', []):
        for col in lay.get('Tiles', []):
            for cell in col:
                if cell.get('AutoTileset', '') in correspondance:
                    total_cells += 1

    cell_idx = 0
    midpoint = total_cells // 2

    for lay in new_obj.get('Layers', []):
        for col in lay.get('Tiles', []):
            for cell in col:
                av = cell.get('AutoTileset', '')
                if av in correspondance:
                    if cell_idx < midpoint:
                        cell['AutoTileset'] = correspondance[av]['depart']
                    else:
                        cell['AutoTileset'] = correspondance[av]['donjon']
                    cell_idx += 1

    # Mise a jour du commentaire
    new_obj['Comment'] = (
        f'gen_entrance : {args.depart} -> {args.zone} '
        f'(orient={args.orientation}, template={template_name})'
    )

    # Verification de non-duplication
    new_sig = signature_entrance(new_obj)
    for exist_name, exist_info in ENTRANCES_CONNUES.items():
        if exist_name == args.ground:
            continue
        if not os.path.exists(exist_info['path']):
            continue
        try:
            exist_root = json.load(open(exist_info['path'], encoding='utf-8-sig'))
            exist_obj = exist_root.get('Object', exist_root)
            if signature_entrance(exist_obj) == new_sig:
                print(f'ATTENTION : signature identique a {exist_name} '
                      f'(meme tileset + dimensions). Verifier la diversite.')
        except Exception:
            pass

    # Sortie
    text = '\ufeff' + json.dumps(new_root, ensure_ascii=False, indent=0)
    out_path = ground_path(args.ground)

    if args.ecrire:
        open(out_path, 'w', encoding='utf-8').write(text)
        print(f'Ecrit : {out_path}')
        print(f'  {total_cells} cellules converties '
              f'({midpoint} depart + {total_cells - midpoint} donjon)')
        print()
        print('Prochaines etapes :')
        print(f'  1. Editer manuellement dans le PMDO Ground Map Editor')
        print(f'  2. Placer le rocher Kangourex (Kangaskhan_Rock)')
        print(f'  3. Placer Dungeon_Entrance (entree du donjon)')
        print(f'  4. Placer Main_Entrance_Marker (point d\'arrivee joueur)')
        print(f'  5. Creer Data/Script/halcyon/ground/{args.ground}/init.lua')
        print(f'  6. python3 tools/mapgen/gen_map.py check --cible {out_path}')
    else:
        print(f'(--ecrire pour materialiser)')
        print(f'  {total_cells} cellules a convertir '
              f'({midpoint} depart + {total_cells - midpoint} donjon)')
        print(f'  Tilesets : {triplet_depart[0]} -> {triplet_dungeon[0]}')

    return 0


# =============================================================================
# COMMANDE : verifier
# =============================================================================
def cmd_verifier(args):
    """Validation d'une entrance avant sortie."""
    ts, bio = load_db()
    p = ground_path(args.ground)
    if not os.path.exists(p):
        sys.exit(f'Fichier introuvable : {p}')

    # Protection ch1-5
    if args.ground in ENTRANCES_PROTEGEES:
        print(f'ATTENTION : {args.ground} est une entrance ch1-5 PROTEGEE.')
        print('  Toute modification est INTERDITE par la directive.')
        return 1

    root = json.load(open(p, encoding='utf-8-sig'))
    obj = root.get('Object', root)
    autos = autotiles_du(obj)
    ents = entites_du(obj)

    erreurs = []
    warnings = []

    # 1. Verifier la coherence tileset
    zone = args.ground.replace('_entrance', '')
    if zone in bio:
        attendus = tilesets_de_zone(ts, bio, zone)
        if autos and not any(a in attendus for a in autos):
            erreurs.append(f'Aucun autotile ne correspond au donjon {zone} '
                           f'(attendu : {attendus[:3]})')

    # 2. Verifier la presence d'entites essentielles
    ent_names = [e['name'] for e in ents]
    has_kangaskhan = any('Kangaskhan' in n or 'kangaskhan' in n.lower()
                         for n in ent_names)
    has_dungeon = any('Dungeon_Entrance' in n or 'dungeon_entrance' in n.lower()
                      for n in ent_names)
    has_marker = any('Main_Entrance' in n or 'main_entrance' in n.lower()
                     for n in ent_names)

    if not has_kangaskhan:
        warnings.append('Rocher Kangourex (Kangaskhan_Rock) non trouve')
    if not has_dungeon:
        warnings.append('Entree du donjon (Dungeon_Entrance) non trouvee')
    if not has_marker:
        warnings.append('Marker d\'arrivee (Main_Entrance_Marker) non trouve')

    # 3. Verifier la non-duplication
    sig = signature_entrance(obj)
    for exist_name, exist_info in ENTRANCES_CONNUES.items():
        if exist_name == args.ground:
            continue
        if not os.path.exists(exist_info['path']):
            continue
        try:
            exist_root = json.load(open(exist_info['path'], encoding='utf-8-sig'))
            exist_obj = exist_root.get('Object', exist_root)
            if signature_entrance(exist_obj) == sig:
                warnings.append(f'Signature identique a {exist_name} '
                                f'(risque de duplication)')
        except Exception:
            pass

    # Rapport
    print(f'Verification : {args.ground}')
    print(f'  Autotiles : {sorted(autos.keys()) if autos else "(aucun)"}')
    print(f'  Entites   : {len(ents)}')
    print(f'  Kangaskhan: {"OUI" if has_kangaskhan else "NON"}')
    print(f'  Donjon    : {"OUI" if has_dungeon else "NON"}')
    print(f'  Marker    : {"OUI" if has_marker else "NON"}')

    if erreurs:
        print(f'\n  ERREURS ({len(erreurs)}) :')
        for e in erreurs:
            print(f'    - {e}')

    if warnings:
        print(f'\n  WARNINGS ({len(warnings)}) :')
        for w in warnings:
            print(f'    - {w}')

    if not erreurs and not warnings:
        print(f'\n  OK — entrance valide')
        return 0
    elif erreurs:
        return 1
    else:
        return 0


# =============================================================================
# MAIN
# =============================================================================
def main():
    p = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    sp = p.add_subparsers(dest='cmd', required=True)

    # lister
    sp.add_parser('lister', help='Audit de coherence des entrances'
                  ).set_defaults(f=cmd_lister)

    # generer
    g = sp.add_parser('generer', help='Generer une nouvelle entrance')
    g.add_argument('--ground', required=True,
                   help='Nom du ground a generer (sans .rsground)')
    g.add_argument('--zone', required=True,
                   help='ID du donjon cible (dans biomes_zones.json)')
    g.add_argument('--depart', required=True,
                   help='Biome du point de depart (foret, plaine, etc.)')
    g.add_argument('--orientation', required=True,
                   choices=list(ORIENTATIONS.keys()),
                   help='Axe de l\'avenue (ew, we, sn)')
    g.add_argument('--template', default=None,
                   help=f'Template a cloner (defaut : {TEMPLATE_DEFAUT})')
    g.add_argument('--ecrire', action='store_true',
                   help='Materialiser le fichier (sinon apercu seul)')
    g.set_defaults(f=cmd_generer)

    # verifier
    v = sp.add_parser('verifier', help='Valider une entrance avant sortie')
    v.add_argument('--ground', required=True)
    v.set_defaults(f=cmd_verifier)

    args = p.parse_args()
    return args.f(args)


if __name__ == '__main__':
    sys.exit(main())
