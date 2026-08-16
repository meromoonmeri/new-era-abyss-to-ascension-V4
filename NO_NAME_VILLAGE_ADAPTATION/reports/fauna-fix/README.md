# Correctif — faune source jamais peinte en décor

## Le bug

Vous aviez raison : des oiseaux étaient visibles sur les rendus. Ce n'était pas
un cas isolé.

Le convertisseur excluait la faune avec ce filtre :

```python
if object_name.startswith(("objmob", "objbmob")) or object_name in {...}:
    continue
```

Seul le préfixe `objmob` était reconnu. Tout ce qui ne le portait pas passait au
travers et était **peint dans le Ground comme une tuile décorative**.

L'inventaire, lui, les avait bien signalés `REVIEW_REQUIRED` avec
`import_policy: manual_semantic_review` et
`reason: insufficient_semantic_evidence; never auto-promote`. **Le convertisseur
ne lisait tout simplement pas ce statut.**

## Ampleur réelle — bien au-delà des oiseaux

Une recherche exhaustive sur les 727 objets source, par jetons sémantiques
(`mob`, `bird`, `butterfly`, `bug`, `firefly`, `frog`) et non par préfixe
supposé, donne :

| Objet | Instances peintes | Statut inventaire |
|---|---:|---|
| `objbutterfly1` | **478** | `REVIEW_REQUIRED` |
| `objbug0` | **369** | `REVIEW_REQUIRED` |
| `objfirefly` | **326** | `REVIEW_REQUIRED` |
| `objbird0` | **185** | `REVIEW_REQUIRED` |
| `objfrog` | **125** | `REVIEW_REQUIRED` |
| **Total** | **1 483** | sur **45 rooms** |

Les 663 occurrences que j'avais annoncées ne couvraient que oiseaux et
papillons ; le vrai total est **1 483**. Les `objmob*` (536 instances) étaient
correctement exclus.

## Correction

Une règle centrale, unique source de vérité :

```python
FAUNA_PREFIXES = ("objmob", "objbmob", "objbfmob", "objbgmob", "objbird", "objbutterfly")
FAUNA_EXACT = {"objbug0", "objfirefly", "objfrog", "objbutterfly0", "objbutterfly1", "objbird0"}

def is_fauna(object_name: str) -> bool:
    return object_name.startswith(FAUNA_PREFIXES) or object_name in FAUNA_EXACT
```

Appliquée aux **deux** endroits : l'exclusion du rendu et l'enregistrement des
occurrences. Les préfixes `objbfmob` / `objbgmob`, absents du filtre d'origine,
sont désormais couverts.

## Validation automatique

`NO_NAME_VILLAGE_ADAPTATION/test_no_baked_fauna.py`, trois gardes :

1. **Familles couvertes** — vérifie que des noms représentatifs *et des
   variantes* (`objbird9`, `objbutterfly7`, `objmobsm999`) sont bien reconnus.
2. **Découverte indépendante** — rescanne l'inventaire par jetons sémantiques ;
   échoue si un objet faune placé n'est pas exclu par le convertisseur.
3. **Artefacts** — vérifie qu'aucun manifest ne déclare de faune rendue.

Les règles sont **lues dans le code du convertisseur** (parsing statique, sans
dépendre de Pillow) : le test suit automatiquement toute évolution.

**Efficacité prouvée** : j'ai réintroduit le bug (retrait de `objbird`/
`objbutterfly` des préfixes) et le test a échoué —
`fauna families no longer covered: ['objbird9', 'objbutterfly7']`. Ma première
version du test ne détectait pas cette régression ; je l'ai renforcée.

## Données de faune conservées

`fauna-occurrences.json` : **2 019 occurrences**, 36 objets, 45 rooms. Pour
chacune : room, objet source, `instance_id`, position source, statut, et
`was_baked_as_decor`.

## Cohérence NNVLife — vérifiée

| | Source | `NNVLife.lua` | |
|---|---:|---:|---|
| `objbird0` dans `rmvillage` | 12 | `source_birds` = 12 | **concorde** |
| `objbutterfly1` dans `rmvillage` | 19 | `source_butterflies` = 19 | **concorde** |

Le casting était donc déjà anticipé côté vie, mais jamais branché — pendant que
le terrain les peignait en dur en parallèle.

**Aucune espèce Pokémon n'est choisie ici**, aucun comportement décidé.

## Ce qui reste à faire

La reconversion des 45 rooms n'a **pas** été exécutée : l'environnement
sandbox a été réinitialisé en cours de travail (`/tmp` et `.runtime-cache/`
vidés), emportant `data.win`, les textures décodées et les 4 zones voisines.
Le dépôt a été resynchronisé depuis le remote, où tout le travail antérieur
était intact.

Pour appliquer le correctif aux Grounds il faut donc :

1. re-télécharger `data.win` via `codeload.github.com` (méthode validée) ;
2. relancer `convert_environment_room.py` sur les rooms concernées ;
3. vérifier que les 1 483 occurrences ont disparu du rendu.

Le correctif et sa garde sont en place ; seuls les artefacts régénérés manquent.

## Statut

`FILTER_FIXED_GUARD_ACTIVE_RECONVERSION_PENDING`. Aucun Ground certifié
modifié.
