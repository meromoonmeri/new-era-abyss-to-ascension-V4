# Reconstruction jouable PMD Red EU — checkpoint

Checkpoint du `2026-08-13`, branche
`arena/019ff05e-new-era-abyss-to-ascension-v4`.

## État autoritatif

- Grounds archive-backed : **219/219 PASS**, historique inchangé dans
  [`../pmdo_validation/progress.json`](../pmdo_validation/progress.json).
- Petit Bois, génération procédurale 1–3F : **PASS**.
- Petit Bois, ouverture/escaliers/sortie/échec/retry/sauvetage/nettoyage :
  **PASS v2** dans [`tiny_woods/route_runtime_v2`](tiny_woods/route_runtime_v2),
  avec les facings Red `4=North` corrigés. La v1 reste conservée avec erratum.
- Graphe scènes EU : **697 commandes / 117 textes français authentifiés**.
- Noyau jouable des quatre scènes : **PARTIAL PASS** — 74 lignes neutres,
  menus natifs, acteurs, facings, musique ROM et chorégraphie principale.
- Restitution commande-par-commande et destination post-`g3` : **PENDING**.

La route certifiée exécute trois scénarios PMDO 0.8.12 indépendants. Le scénario
complet soumet 143 actions natives, dont trois actions d’escalier et deux
attaques contre des occupants hostiles naturels. Les 28 replans d’occupation,
les trois étages, `d01p02:g1`, `d01p01:g3`, les acteurs, positions, collision,
musique EU et nettoyage de réentrée sont attestés. Les trois processus se
terminent par `LoadPhase.Unload`, `NORMAL_EXIT`, rc 0, sans signal ni orphelin.

## Reprise exacte

```bash
bash tools/restore_pmdred_eu_validation_runtime.sh
python3 tools/update_pmdred_eu_validation_progress.py --check
bash docs/pmdred_eu/playable/tiny_woods/scene_runtime/commands.sh
```

Les fixtures et preuves sont create-only. Si les noms `*-repro` existent,
utiliser de nouvelles destinations plutôt que les écraser.

## Étape suivante

Étendre dans un nouvel overlay le noyau certifié sans le réécrire :

- interpréter chaque cue restant des 697 commandes authentifiées ;
- reproduire fanfares, portraits/émotions, chemins de marche et caméra ;
- brancher le renommage interactif et les récompenses réelles ;
- identifier puis certifier la destination canonique après `d01p01:g3` ;
- rejouer ouverture, défaite/retry et sauvetage complet avec terminaison stricte.

Les références aplaties existantes ne sont pas canoniques par défaut. Ne
promouvoir ni `d01p02` ni les scripts Ground live avant ce gate exhaustif.
