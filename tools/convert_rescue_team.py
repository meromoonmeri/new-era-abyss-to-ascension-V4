#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Convertit les donjons de Pokemon Mystery Dungeon: Rescue Team au format PMDO.

Ce que fournit la source
------------------------
La decompilation `jtjanecek/rogue-rescue-team` expose, pour chaque
donjon, deux fichiers directement exploitables :

    data/dungeon/<Donjon>/floor_id.json      nombre d'etages et index de tables
    data/dungeon/<Donjon>/pokemon_found.json espece / niveau / probabilite,
                                             par plage d'etages

Mesure faite sur le depot : 64 donjons, 1767 etages, 414 especes
distinctes. C'est la table des rencontres sauvages du jeu d'origine,
telle quelle.

Ce que la source ne fournit PAS
-------------------------------
`main_data.inc` (la geometrie et les reglages d'etage) est en octets
bruts d'assembleur GBA, sans documentation de format dans le depot. On
ne l'utilise donc pas : deviner la signification de chaque octet
produirait des donjons faux, pas des donjons fideles.

Consequence assumee : la conversion reprend l'IDENTITE du donjon (son
bestiaire, ses niveaux, sa profondeur, sa progression de difficulte)
et confie la geometrie a RogueElements, le generateur natif du moteur.
C'est ce que demande le brief — « adapter au moteur », pas transposer
octet par octet une structure GBA que RogueEssence ne sait pas lire.

Fidelite conservee
------------------
- nombre d'etages exact du donjon d'origine ;
- bestiaire exact, avec les niveaux d'origine ;
- probabilites d'apparition converties du format GBA (sur 10000) vers
  le format PMDO (poids relatifs) ;
- decoupage en plages d'etages respecte (« MagmaCavern_1F_3F » devient
  un Range 0-2).

Gabarit
-------
Toute la structure PMDO (GenSteps, ZoneSteps, priorites) est reprise
d'une zone REELLE du mod, `crooked_cavern`, plutot qu'ecrite a la main.
On ne recopie pas son contenu : on garde son squelette et on remplace le
bestiaire et le nombre d'etages. C'est la seule facon de garantir que le
resultat se charge, sans inventer une seule cle.
"""

import argparse
import copy
import json
import os
import pathlib
import re
import sys

RACINE = pathlib.Path(__file__).resolve().parent.parent
GABARIT = RACINE / 'Data' / 'Zone' / 'crooked_cavern.json'


# ---------------------------------------------------------------- espèces

def charger_especes(source=None):
    """Especes valides, identifiees par leur NUMERO NATIONAL.

    Piege ecarte : on ne peut pas valider par liste de noms.
    - Data/Monster ne contient que 22 surcharges locales ;
    - mission_gen.lua enumere une SELECTION d'especes recrutables, pas
      l'exhaustif : machop, arcanine ou espeon n'y figurent pas, alors
      qu'ils existent evidemment dans le moteur.
    Filtrer sur ces listes ecartait 84 especes parfaitement valides.

    On s'appuie donc sur include/constants/monster.h de la decompilation,
    qui numerote chaque espece. Attention : cette numerotation est celle
    de la ROM, PAS le Pokedex national — elle inclut les formes comme
    entrees distinctes, d'ou un decalage croissant (Absol y porte le 387
    alors qu'il est le 359e du Pokedex).

    Borne retenue : 1 a 427. Au-dela commencent les entrees de service du
    moteur GBA — MONSTER_DECOY (428), MONSTER_STATUE (429),
    MONSTER_RAYQUAZA_CUTSCENE (430) — qui ne sont pas des Pokemon.
    427 correspond a Galvantula, dernier vrai Pokemon de la table.
    """
    valides = set()
    if source is not None:
        h = pathlib.Path(source) / 'include' / 'constants' / 'monster.h'
        if h.exists():
            for m in re.finditer(r'#define (MONSTER_[A-Z0-9_]+)\s+(\d+)',
                                 h.read_text(encoding='utf-8', errors='replace')):
                nom, num = m.group(1), int(m.group(2))
                if 1 <= num <= 427:
                    valides.add(nom)
    return valides


def nom_espece(brut):
    """MONSTER_MR_MIME -> mr_mime, en gerant les formes du jeu d'origine."""
    n = brut.replace('MONSTER_', '').lower()
    # Les formes regionales/alternatives de Rescue Team ne se mappent pas
    # une pour une : on retombe sur l'espece de base.
    for suffixe in ('_a', '_b', '_c', '_d', '_e', '_f', '_g', '_h'):
        if n.endswith(suffixe) and len(n) > 3:
            base = n[:-len(suffixe)]
            if base in ('deoxys', 'unown', 'castform'):
                return base
    return n


# ---------------------------------------------------------------- plages

def plage_etages(nom_table, nb_etages):
    """« MagmaCavern_1F_3F_Pokemon » -> (0, 2).

    Les noms de table portent la plage d'etages en clair. On la lit
    plutot que de repartir le bestiaire au hasard : c'est ce qui
    preserve la progression de difficulte du donjon d'origine.
    """
    ets = re.findall(r'_(\d+)F', nom_table)
    if len(ets) >= 2:
        a, b = int(ets[0]), int(ets[1])
    elif len(ets) == 1:
        a = b = int(ets[0])
    else:
        return 0, max(0, nb_etages - 1)
    return max(0, a - 1), max(0, min(b - 1, nb_etages - 1))


# ------------------------------------------------------------ conversion

def lire_donjon(dossier):
    """Renvoie (nb_etages, [(min, max, [(espece, niveau, proba)])])."""
    fi = pathlib.Path(dossier) / 'floor_id.json'
    pf = pathlib.Path(dossier) / 'pokemon_found.json'
    nb = 0
    if fi.exists():
        nb = len(json.loads(fi.read_text()).get('tables') or [])
    plages = []
    if pf.exists():
        for t in json.loads(pf.read_text()).get('tables') or []:
            mons = []
            for k in (t.get('pokemon') or []):
                sp = nom_espece(k.get('species', ''))
                lv = int(k.get('level', 5))
                pr = int(k.get('probability', 0))
                if sp and pr > 0:
                    mons.append((k.get('species', ''), sp, lv, pr))
            if mons:
                a, b = plage_etages(t.get('name', ''), nb)
                plages.append((a, b, mons))
    return nb, plages


def gabarit_zone():
    d = json.loads(GABARIT.read_bytes().decode('utf-8-sig'))
    return d


def construire(nom_pmdo, titre_fr, titre_en, nb_etages, plages,
               connues, verbeux=True):
    doc = gabarit_zone()
    z = doc.get('Object', doc)

    z['Name'] = {'DefaultText': titre_en, 'LocalTexts': {'fr': titre_fr}}
    z['Comment'] = ('Converti de Pokemon Mystery Dungeon: Rescue Team '
                    '(jtjanecek/rogue-rescue-team). Bestiaire et profondeur '
                    "d'origine ; geometrie generee par RogueElements.")
    z['Released'] = False        # tant que ce n'est pas teste en jeu
    z['GroundMaps'] = []

    seg = z['Segments'][0]
    z['Segments'] = [seg]

    # --- profondeur : on garde le nombre d'etages d'origine
    noeud = copy.deepcopy(seg['Floors']['nodes'][0])
    noeud['Range'] = {'Min': 0, 'Max': max(1, nb_etages)}
    it = noeud.get('Item') or {}
    it['Comment'] = f'{titre_fr} — {nb_etages} etages (source Rescue Team)'
    seg['Floors']['nodes'] = [noeud]

    # --- bestiaire : on remplace celui du gabarit
    modele_spawn = None
    for st in seg['ZoneSteps']:
        if 'TeamSpawnZoneStep' in st.get('$type', ''):
            if st.get('Spawns'):
                modele_spawn = copy.deepcopy(st['Spawns'][0])
            st_cible = st
            break
    else:
        raise RuntimeError('le gabarit ne contient pas de TeamSpawnZoneStep')

    if modele_spawn is None:
        raise RuntimeError('le gabarit ne contient aucun spawn modele')

    spawns = []
    ignores = []
    for a, b, mons in plages:
        # Les probabilites GBA sont sur 10000. PMDO travaille en poids
        # relatifs : on divise par 100 en gardant un minimum de 1 pour ne
        # pas faire disparaitre une espece rare.
        for brut, sp, lv, pr in mons:
            if brut not in connues:
                ignores.append(sp)
                continue
            e = copy.deepcopy(modele_spawn)
            s = e['Spawn']['Spawn']
            s['BaseForm'] = {'Species': sp, 'Form': 0,
                             'Skin': '', 'Gender': -1}
            s['Level'] = {'Min': max(1, lv - 1), 'Max': lv + 1}
            s['SpecifiedSkills'] = []
            e['Rate'] = max(1, round(pr / 100))
            e['Range'] = {'Min': a, 'Max': b}
            spawns.append(e)
    st_cible['Spawns'] = spawns

    if verbeux and ignores:
        uniq = sorted(set(ignores))
        print(f'    {len(uniq)} espece(s) inconnue(s) ecartee(s) : '
              f"{', '.join(uniq[:6])}{'...' if len(uniq) > 6 else ''}")
    return doc, len(spawns), sorted(set(ignores))


# ----------------------------------------------------------------- noms

# Nom francais des donjons canoniques. Le brief impose de conserver le nom
# canonique traduit plutot que d'en inventer un.
NOMS = {
    'TinyWoods': ('Petit Bois', 'Tiny Woods'),
    'ThunderwaveCave': ('Grotte Tonnerre', 'Thunderwave Cave'),
    'MtSteel': ('Mont Acier', 'Mt. Steel'),
    'SinisterWoods': ('Bois Sinistres', 'Sinister Woods'),
    'SilentChasm': ('Gouffre Silencieux', 'Silent Chasm'),
    'MtThunder': ('Mont Tonnerre', 'Mt. Thunder'),
    'MtThunderPeak': ('Cime du Mont Tonnerre', 'Mt. Thunder Peak'),
    'GreatCanyon': ('Grand Canyon', 'Great Canyon'),
    'LapisCave': ('Grotte Lapis', 'Lapis Cave'),
    'MtBlaze': ('Mont Brasier', 'Mt. Blaze'),
    'MtBlazePeak': ('Cime du Mont Brasier', 'Mt. Blaze Peak'),
    'FrostyForest': ('Foret Glacee', 'Frosty Forest'),
    'FrostyGrotto': ('Grotte Glacee', 'Frosty Grotto'),
    'MtFreeze': ('Mont Gel', 'Mt. Freeze'),
    'MtFreezePeak': ('Cime du Mont Gel', 'Mt. Freeze Peak'),
    'MagmaCavern': ('Caverne Magma', 'Magma Cavern'),
    'MagmaCavernPit': ('Fosse de la Caverne Magma', 'Magma Cavern Pit'),
    'SkyTower': ('Tour Celeste', 'Sky Tower'),
    'SkyTowerSummit': ('Sommet de la Tour Celeste', 'Sky Tower Summit'),
    'StormySea': ('Mer Tempetueuse', 'Stormy Sea'),
    'SilverTrench': ('Fosse Argentee', 'Silver Trench'),
    'MeteorCave': ('Grotte Meteore', 'Meteor Cave'),
    'BuriedRelic': ('Relique Enfouie', 'Buried Relic'),
    'WesternCave': ('Antre d Occident', 'Western Cave'),
    'NorthernRange': ('Chaine du Nord', 'Northern Range'),
    'PitfallValley': ('Vallee des Chausse-trappes', 'Pitfall Valley'),
    'DesertRegion': ('Region Desertique', 'Desert Region'),
    'SouthernCavern': ('Caverne du Sud', 'Southern Cavern'),
    'WyvernHill': ('Colline Wyvern', 'Wyvern Hill'),
    'SolarCave': ('Grotte Solaire', 'Solar Cave'),
    'DarknightRelic': ('Relique Tenebreuse', 'Darknight Relic'),
    'GrandSea': ('Grande Mer', 'Grand Sea'),
    'WaterfallPond': ('Etang de la Cascade', 'Waterfall Pond'),
    'UnownRelic': ('Relique des Zarbi', 'Unown Relic'),
    'JoyousTower': ('Tour de la Joie', 'Joyous Tower'),
    'PurityForest': ('Foret de Purete', 'Purity Forest'),
    'WishCave': ('Grotte des Voeux', 'Wish Cave'),
    'MurkyCave': ('Grotte Trouble', 'Murky Cave'),
    'HowlingForest': ('Foret Hurlante', 'Howling Forest'),
    'UproarForest': ('Foret du Tumulte', 'Uproar Forest'),
    'FieryField': ('Champ de Braises', 'Fiery Field'),
    'LightningField': ('Champ de Foudre', 'Lightning Field'),
    'NorthwindField': ('Champ du Vent du Nord', 'Northwind Field'),
    'MtFaraway': ('Mont Lointain', 'Mt. Faraway'),
    'RemainsIsland': ('Ile des Vestiges', 'Remains Island'),
    'MarvelousSea': ('Mer Merveilleuse', 'Marvelous Sea'),
    'FantasyStrait': ('Detroit Fantastique', 'Fantasy Strait'),
    'FaroffSea': ('Mer Lointaine', 'Far-off Sea'),
    'WondrousSea': ('Mer Prodigieuse', 'Wondrous Sea'),
    'OddityCave': ('Grotte Etrange', 'Oddity Cave'),
    'RockPath': ('Sentier Rocheux', 'Rock Path'),
    'SnowPath': ('Sentier Enneige', 'Snow Path'),
}

# Donjons ecartes : structures de service du jeu d'origine, sans identite
# de lieu (le brief exige un nom de LIEU, pas de fonction).
ECARTES = {'Autopilot', 'DojoRegistration', 'D50', 'D51', 'D54', 'D61',
           'D63', 'Boss3', 'Boss4', 'Boss9', 'FantasyStraitAlt',
           'MtFreezePeakAlt'}


def slug(n):
    s = re.sub(r'(?<!^)(?=[A-Z])', '_', n).lower()
    return re.sub(r'[^a-z0-9_]', '', s)


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('source', help='racine de rogue-rescue-team')
    ap.add_argument('donjons', nargs='*', help='noms a convertir (defaut : tous)')
    ap.add_argument('--prefixe', default='rt_',
                    help="prefixe des zones produites (defaut rt_)")
    ap.add_argument('--appliquer', action='store_true')
    a = ap.parse_args()

    racine = pathlib.Path(a.source) / 'data' / 'dungeon'
    if not racine.is_dir():
        print(f'ABANDON : {racine} introuvable')
        return 1

    connues = charger_especes(a.source)
    print(f'{len(connues)} especes valides (table ROM 1-427)\n')

    noms = a.donjons or sorted(
        d.name for d in racine.iterdir()
        if d.is_dir() and (d / 'floor_id.json').exists())

    faits = 0
    ignores_tot = set()
    for n in noms:
        if n in ECARTES:
            print(f'  passe  {n:22s} (structure de service, pas un lieu)')
            continue
        nb, plages = lire_donjon(racine / n)
        if not nb or not plages:
            print(f'  passe  {n:22s} (pas de bestiaire exploitable)')
            continue
        fr, en = NOMS.get(n, (n, n))
        cible = a.prefixe + slug(n)
        try:
            doc, nsp, ign = construire(cible, fr, en, nb, plages, connues)
        except Exception as e:
            print(f'  ERREUR {n:22s} {e}')
            continue
        ignores_tot |= set(ign)
        print(f'  OK     {cible:26s} {nb:3d} etages, {nsp:4d} spawns  « {fr} »')
        if a.appliquer:
            p = RACINE / 'Data' / 'Zone' / (cible + '.json')
            p.write_text('\ufeff' + json.dumps(doc, ensure_ascii=False,
                                               indent=2),
                         encoding='utf-8')
        faits += 1

    print(f'\n{faits} donjon(s) converti(s)'
          f"{' (APPLIQUE)' if a.appliquer else ' (SIMULATION)'}")
    if ignores_tot:
        print(f'{len(ignores_tot)} espece(s) inconnue(s) au total')
    return 0


if __name__ == '__main__':
    sys.exit(main())
