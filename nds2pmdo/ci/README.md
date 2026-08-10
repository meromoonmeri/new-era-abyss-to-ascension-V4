# CI du pipeline nds2pmdo

`ci.yml` est la définition GitHub Actions du pipeline (tests pytest sur les
artefacts ground truth committés, vérification des manifests, interdiction des
placeholders silencieux dans decoded/).

Pour l'activer sur un dépôt GitHub :
1. copier `ci.yml` vers `.github/workflows/nds2pmdo-ci.yml` du dépôt cible ;
2. pousser (nécessite la permission `workflows` sur le token GitHub).

Note : dans le dépôt de travail actuel, le fichier est volontairement hors de
`.github/workflows/` car le token d'automatisation n'a pas la permission
`workflows`.
