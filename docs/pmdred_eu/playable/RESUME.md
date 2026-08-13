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
- Scènes narratives françaises complètes de Petit Bois : **PENDING**.

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
bash docs/pmdred_eu/playable/tiny_woods/route_runtime_v2/commands.sh
```

Les fixtures et preuves sont create-only. Si les noms `*-repro` existent,
utiliser de nouvelles destinations plutôt que les écraser.

## Étape suivante

Construire dans un nouvel overlay isolé les scènes EU de :

- `d01p01:g1` — ouverture et entrée au Petit Bois ;
- `d01p01:g2` — défaite et nouvelle tentative ;
- `d01p02:g1` — rencontre et sauvetage de Chenipan ;
- `d01p01:g3` — relais post-sauvetage.

L’adaptation doit provenir des commandes et textes français authentifiés de
`docs/pmdred_eu/ground_scripts.json`, avec acteurs, portraits, déplacements,
caméra, animations, effets, musique et rythme. Les références aplaties
existantes ne sont pas canoniques par défaut. Ne promouvoir ni `d01p02` ni les
scripts live avant une preuve PMDO fonctionnelle complète et une terminaison
native stricte.
