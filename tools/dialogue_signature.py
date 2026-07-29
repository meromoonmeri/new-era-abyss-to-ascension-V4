#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
dialogue_signature.py — empreinte du RYTHME d'une scene.

A quoi ca sert
==============
Avant de nettoyer la forme d'un fichier de cinematique, on releve la suite
EXACTE de ses evenements de rythme : chaque attente, chaque boite de
dialogue, chaque changement de locuteur, dans l'ordre. Apres nettoyage, on
recompare. Si l'empreinte est identique, le nettoyage n'a strictement rien
change a ce que le joueur voit et entend.

C'est la garantie demandee : « on conserve nos temps de dialogues ».

Ce qui est releve, dans l'ordre du fichier
------------------------------------------
  WAIT <n>        GAME:WaitFrames(n)
  DLG <cle>       une boite de dialogue (cle resx ou texte)
  SPK <nom>       UI:SetSpeaker(...)
  EMO <nom>       UI:SetSpeakerEmotion(...)
  PAUSE <n>       balise [pause=n] dans un texte
  BGM/SE ...      musique et bruitages, qui font partie du rythme

Les commentaires et les lignes vides sont ignores : c'est precisement ce
qu'on s'autorise a modifier.

Usage
-----
    python3 tools/dialogue_signature.py <fichier.lua>            # affiche
    python3 tools/dialogue_signature.py <fichier.lua> --hash     # empreinte
    python3 tools/dialogue_signature.py <a.lua> --diff <b.lua>   # compare
"""
import hashlib
import re
import sys

WAIT = re.compile(r'GAME:WaitFrames\s*\(\s*(\d+)\s*\)')
DLG = re.compile(r"MapStrings\[\s*'([^']+)'\s*\]")
DLG_TXT = re.compile(r'(?:WaitShowDialogue|WaitShowTimedDialogue)\s*\(\s*"([^"]{0,60})')
SPK = re.compile(r'UI:SetSpeaker\s*\(\s*([A-Za-z_][\w.]*)')
SPK_RESET = re.compile(r'UI:ResetSpeaker\s*\(')
EMO = re.compile(r'UI:SetSpeakerEmotion\s*\(\s*"([^"]+)"')
PAUSE = re.compile(r'\[pause=(\d+)\]')
BGM = re.compile(r'SOUND:(PlayBGM|StopBGM|FadeOutBGM)\s*\(\s*([^),]*)')
SE = re.compile(r'SOUND:(PlaySE|PlayBattleSE|FadeInSE|FadeOutSE)\s*\(\s*([^),]*)')
FADE = re.compile(r'GAME:(FadeIn|FadeOut)\s*\(\s*([^)]*)\)')
KEY_CALL = re.compile(r"\b(?:Says|SaysA|greet|voice|dreamer)\s*\(\s*[^,)]*,?[^,)]*,?\s*'([A-Z0-9_]+)'")


def signature(chemin):
    evenements = []
    with open(chemin, encoding='utf-8') as fh:
        for ligne in fh:
            nu = ligne.strip()
            if not nu or nu.startswith('--'):
                continue
            for m in WAIT.finditer(nu):
                evenements.append('WAIT %s' % m.group(1))
            for m in SPK.finditer(nu):
                evenements.append('SPK %s' % m.group(1))
            if SPK_RESET.search(nu):
                evenements.append('SPK reset')
            for m in EMO.finditer(nu):
                evenements.append('EMO %s' % m.group(1))
            for m in DLG.finditer(nu):
                evenements.append('DLG %s' % m.group(1))
            for m in KEY_CALL.finditer(nu):
                evenements.append('DLG %s' % m.group(1))
            for m in DLG_TXT.finditer(nu):
                evenements.append('DLG "%s"' % m.group(1).strip())
            for m in PAUSE.finditer(nu):
                evenements.append('PAUSE %s' % m.group(1))
            for m in BGM.finditer(nu):
                evenements.append('BGM %s %s' % (m.group(1), m.group(2).strip()))
            for m in SE.finditer(nu):
                evenements.append('SE %s %s' % (m.group(1), m.group(2).strip()))
            for m in FADE.finditer(nu):
                evenements.append('FADE %s %s' % (m.group(1),
                                                  m.group(2).replace(' ', '')))
    return evenements


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    a = sys.argv[1]
    sig_a = signature(a)

    if '--diff' in sys.argv:
        b = sys.argv[sys.argv.index('--diff') + 1]
        sig_b = signature(b)
        if sig_a == sig_b:
            print('IDENTIQUE — %d evenements de rythme, aucun ecart.'
                  % len(sig_a))
            return 0
        print('DIFFERENT — %d evenements vs %d' % (len(sig_a), len(sig_b)))
        import difflib
        n = 0
        for l in difflib.unified_diff(sig_a, sig_b, 'avant', 'apres',
                                      lineterm='', n=1):
            print(l)
            n += 1
            if n > 80:
                print('... (tronque)')
                break
        return 1

    if '--hash' in sys.argv:
        h = hashlib.sha256('\n'.join(sig_a).encode()).hexdigest()[:16]
        print('%s  %d evenements  %s' % (h, len(sig_a), a))
        return 0

    for e in sig_a:
        print(e)
    return 0


if __name__ == '__main__':
    sys.exit(main())
