# Installateur Windows — New Era: Abyss to Ascension

Ce dossier contient la définition de l'installateur Windows du mod, compilé
via **Inno Setup 6** par GitHub Actions.

## Fichiers

- **`New-Era.iss`** — script Inno Setup (source de vérité de l'installateur).
- **`README.md`** — ce document.

## Comment est produit `New-Era-Setup.exe`

Le workflow `.github/workflows/build-installer.yml` s'occupe de tout :

1. **Runner Windows officiel** (`windows-latest`) — pas de Wine, résultat natif.
2. **Staging du mod** : `python dev/tools/package_windows.py` assemble le
   dossier `New-Era\` conforme à la convention Halcyon (Mod.xml + Data\ +
   Content\ + Strings\ + CONVERSION\ + docs), sans le dev material (dev/,
   dist/, external/, docs/…).
3. **Compilation Inno Setup** :
   `ISCC.exe /DSourceDir=<stage> /DOutputDir=<out> New-Era.iss`
4. **Upload** de `New-Era-Setup.exe` :
   - Toujours : comme artifact du run (téléchargeable 30 jours depuis
     l'onglet Actions).
   - Sur tag `installer-vX.Y.Z` : publie une **GitHub Release** publique
     avec l'`.exe` attaché.

## Comment déclencher un build

### Option 1 — Release publique (recommandé)

Pousser un tag sur la branche de travail :

```bash
git tag installer-v0.5.1
git push origin installer-v0.5.1
```

Le workflow compile, crée la Release `installer-v0.5.1`, y attache
`New-Era-Setup.exe` et `New-Era-Setup.exe.sha256`. L'URL publique est
`https://github.com/meromoonmeri/new-era-abyss-to-ascension-V4/releases/tag/installer-v0.5.1`.

### Option 2 — Build à la demande (artifact seulement)

Depuis GitHub → onglet **Actions** → workflow **Build Windows installer
(Inno Setup)** → **Run workflow**. Laisser `create_release=false`. On
récupère l'`.exe` en cliquant l'artifact `New-Era-Setup-Windows`.

### Option 3 — Build à la demande + Release

Même chose qu'option 2 mais `create_release=true` et `release_tag=installer-vX.Y.Z`.

## Ce que fait `New-Era-Setup.exe` chez l'utilisateur

1. **Détecte PMDO** automatiquement :
   - Registry `HKCU\Software\audinowho\PMDO\InstallDir` puis `HKLM`
   - Heuristiques : `<Drive>:\PMDOSetup\PMDO`, `<Drive>:\PMDO`,
     `<Drive>:\Games\PMDO`, `<Drive>:\Pokemon\PMDO` sur tous les lecteurs
   - Puis `%localappdata%\PMDO`, `%appdata%\PMDO`, `Documents\PMDO`
2. **Propose** `<PMDO>\MODS\New-Era` comme dossier d'installation
   (modifiable par l'utilisateur).
3. **Décompacte** le contenu (Mod.xml + Data + Content + Strings +
   CONVERSION + readme.md + patchnotes.txt + Pokemon changes.txt +
   CREDITS.md) directement dans le dossier choisi.
4. **Vérifie** qu'il n'y a pas de double niveau `New-Era\New-Era\`
   (bug historique du zip mal extrait).
5. **Optionnel** : crée un raccourci menu Démarrer et/ou Bureau
   « Jouer à New Era » qui lance `PMDO.exe` du dossier PMDO.
6. **Installe un désinstalleur** standard Windows
   (Panneau de configuration → Programmes).

## Ce que l'installateur NE fait PAS

- Il **ne redistribue pas PMDO**. L'utilisateur doit d'abord installer
  PMDO via [PMDOSetup officiel](https://github.com/audinowho/PMDODump/releases).
  C'est la convention de tous les mods PMDO (Halcyon inclus).
- Il **ne lance pas PMDO tout seul**. C'est PMDO qui charge le mod via
  Special Episodes.

## Convention de version

- Version du **mod** : dans `Mod.xml` (élément `<Version>`).
- Version de l'**installateur** : reflétée dans `#define AppVersion` du
  fichier `.iss`. Doit rester alignée sur le `Version` du `Mod.xml`.

Quand on incrémente le mod à `0.5.2`, il faut :
1. Modifier `<Version>0.5.2</Version>` dans `Mod.xml`
2. Modifier `#define AppVersion "0.5.2"` dans `installer/New-Era.iss`
3. Tagger : `git tag installer-v0.5.2 && git push origin installer-v0.5.2`
