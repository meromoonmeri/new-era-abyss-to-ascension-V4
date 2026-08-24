# New Era: Abyss to Ascension — installateur Windows

## Installation en 30 secondes

1. Téléchargez le dossier `dist/windows-installer/` **en entier**
   (ce README + `New-Era-Installer.bat` + `New-Era-Installer.ps1` +
   les 6 fichiers `New-Era.zip.part_00X`).
2. Double-cliquez sur **`New-Era-Installer.bat`**.
3. L'installateur détecte PMDO, propose un dossier
   (`<PMDO>\MODS\New-Era` par défaut), reassemble le zip depuis les
   6 parts, vérifie son SHA-256, extrait dans le dossier choisi,
   enregistre un désinstalleur et propose un raccourci menu Démarrer.
4. Lancez PMDO → **Special Episodes → New Era: Abyss to Ascension**.

Aucun `.msi` à installer, aucun Inno Setup pré-requis. L'installateur
n'utilise que PowerShell, présent nativement sur Windows 7 SP1 et
au-dessus.

## Contenu du dossier

| Fichier | Rôle |
|---|---|
| `New-Era-Installer.bat` | Point d'entrée. Double-clic pour lancer. |
| `New-Era-Installer.ps1` | Installateur PowerShell qui fait le vrai travail. |
| `New-Era.zip.part_001..006` | Les 6 parts du zip release (85 MiB chacune, sauf la dernière). |
| `MANIFEST.json` | Facts d'intégrité (SHA-256 total + par part, taille, version). |
| `README.md` | Ce document. |

Le zip complet fait **433.07 MiB** (`SHA-256`
`19ff0fade7a45fa23e30ace16fdb01a495966cc1278bcad205363cbfe95e3428`).
Il contient l'arborescence Halcyon-conforme (`Mod.xml`, `Data/`,
`Content/`, `Strings/`, `CONVERSION/`, `readme.md`, `patchnotes.txt`,
`Pokemon changes.txt`, `CREDITS.md`), incluant les extensions
Waves of Nostalgia et No Name Village.

## Détection automatique de PMDO

L'installateur cherche PMDO dans cet ordre :

1. `<Drive>:\PMDOSetup\PMDO` sur toutes les lettres C..H
2. `<Drive>:\PMDO`, `<Drive>:\Games\PMDO`, `<Drive>:\Pokemon\PMDO`
3. `%LOCALAPPDATA%\PMDO`, `%APPDATA%\PMDO`
4. `Documents\PMDO`, `Bureau\PMDO`

S'il ne trouve rien, il propose `D:\PMDOSetup\PMDO\MODS\New-Era`
comme dossier par défaut (vous pouvez taper un autre chemin).

## Vérifications automatiques

- Taille et **SHA-256** du zip reassemblé validés avant extraction ;
  toute part corrompue provoque un abandon immédiat.
- Présence de `Mod.xml` **directement dans `New-Era\`** vérifiée
  après extraction (protection contre le bug historique du double
  niveau `New-Era\New-Era\`).
- Refuse d'écraser un dossier `New-Era\` existant sans confirmation
  (protège une éventuelle personnalisation utilisateur).

## Désinstallation

**Panneau de configuration → Programmes → New Era: Abyss to Ascension →
Désinstaller.**

Alternative en ligne de commande :
```
powershell -File .\New-Era-Installer.ps1 -InstallerRoot . -Uninstall
```

## Mode silencieux

Pour une installation non interactive :
```
powershell -File .\New-Era-Installer.ps1 -InstallerRoot . `
    -InstallDir "D:\PMDOSetup\PMDO\MODS\New-Era" -Silent
```

## Compatibilité

- Windows 7 SP1, 8.1, 10, 11 (32 ou 64 bits)
- PowerShell 5.1+ (préinstallé sur Windows 10/11 ; installable sur
  Windows 7 via *Windows Management Framework 5.1*)
- Aucun composant tiers requis

## Pourquoi 6 parts et pas un `.exe` unique ?

Le zip release fait 416+ MiB, au-dessus de la recommandation GitHub
de 50 MiB par fichier. Le split en parts de 85 MiB permet à Git de
les héberger sans avertissement bloquant, et la reassembly + hash
check est faite automatiquement par l'installateur — l'utilisateur
final n'a rien à faire manuellement.
