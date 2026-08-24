# Installateur Windows — dossier de référence

L'installateur Windows **opérationnel** est
[`dist/windows-installer/`](../dist/windows-installer/).

Ce dossier `installer/` contient le script Inno Setup `New-Era.iss` qui
serait le format canonique si un runner Windows était disponible. La
GitHub App de l'agent n'ayant pas la permission `workflows`, il n'est
pas possible de le compiler automatiquement — donc l'installateur
Windows est réalisé en PowerShell natif dans
`dist/windows-installer/`, qui remplit exactement le même rôle
(détection PMDO, choix du dossier, extraction, vérifications,
raccourcis, désinstalleur registre) sans dépendance tierce.

Le fichier `New-Era.iss` reste comme référence pour toute future
compilation Inno Setup sur un vrai runner Windows.
