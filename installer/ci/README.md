# Activation manuelle du workflow CI

Ce dossier contient le workflow GitHub Actions **`build-installer.yml`**
qui compile l'installateur Windows `New-Era-Setup.exe` via Inno Setup 6
sur un runner `windows-latest`.

## Pourquoi il n'est pas déjà dans `.github/workflows/`

L'agent qui a créé ce contenu tourne sous une **GitHub App** sans la
permission `workflows`. GitHub refuse tout push d'un fichier sous
`.github/workflows/*.yml` fait par une App sans cette permission (message :
« refusing to allow a GitHub App to create or update workflow […] without
`workflows` permission »).

Le fichier est donc parqué ici pour que **vous** (utilisateur humain
authentifié directement sur GitHub) le déplaciez à sa place définitive.

## Comment l'activer (une seule commande)

Depuis votre PC, sur la branche `arena/01a0337b-new-era-abyss-to-ascension-v4` :

```bash
git pull
mkdir -p .github/workflows
git mv installer/ci/build-installer.yml .github/workflows/build-installer.yml
git rm installer/ci/README.md
git commit -m "Activate build-installer workflow"
git push
```

Une fois pushé, le workflow devient disponible sous :
- GitHub → onglet **Actions** → **Build Windows installer (Inno Setup)**

## Comment déclencher un build ensuite

### Publier une Release avec l'installateur attaché

```bash
git tag installer-v0.5.1
git push origin installer-v0.5.1
```

Le workflow s'exécute (~4-5 min), crée la Release `installer-v0.5.1`,
et y attache `New-Era-Setup.exe` + `New-Era-Setup.exe.sha256`.

### Build sans Release (artifact seulement)

GitHub → **Actions** → **Build Windows installer (Inno Setup)** →
**Run workflow**. L'`.exe` est disponible ~5 min plus tard dans les
**Artifacts** du run (30 jours de rétention).

## Vérification

Le workflow échoue si :
- `Mod.xml` n'est pas produit par le packager
- Un des dossiers `Data\`, `Content\`, `Strings\`, `CONVERSION\` manque
- `ISCC.exe` ne compile pas (erreur dans `installer/New-Era.iss`)
- L'`.exe` de sortie n'est pas créé

Aucune Release n'est publiée en cas d'échec.
