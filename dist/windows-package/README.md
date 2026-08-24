# Distribution Windows — obsolète

> **Ce dossier de distribution en parts n'est plus le canal principal.**

L'ancien mécanisme (5 parts `New-Era.zip.part_00X` à reassembler via
`copy /b`) fonctionne toujours mais n'est plus la méthode recommandée.

## Nouvelle méthode : installateur Inno Setup

L'installateur `New-Era-Setup.exe` est produit par GitHub Actions
(workflow `.github/workflows/build-installer.yml`) et publié en tant que
**GitHub Release** attachable en un seul fichier.

- Source Inno Setup : [`installer/New-Era.iss`](../../installer/New-Era.iss)
- Workflow          : [`.github/workflows/build-installer.yml`](../../.github/workflows/build-installer.yml)
- Documentation     : [`installer/README.md`](../../installer/README.md)

## Comment obtenir `New-Era-Setup.exe`

### Option A — dernière Release publiée
```
https://github.com/meromoonmeri/new-era-abyss-to-ascension-V4/releases
```
Section **Assets** → `New-Era-Setup.exe`.

### Option B — depuis un run Actions
```
https://github.com/meromoonmeri/new-era-abyss-to-ascension-V4/actions/workflows/build-installer.yml
```
Cliquer le dernier run → section **Artifacts** → `New-Era-Setup-Windows`.

## Comment publier une nouvelle Release

```bash
git tag installer-v0.5.1
git push origin installer-v0.5.1
```
Le workflow compile et publie automatiquement.
