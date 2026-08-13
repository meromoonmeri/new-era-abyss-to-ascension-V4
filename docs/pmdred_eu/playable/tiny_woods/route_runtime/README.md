# Petit Bois — routage PMDO natif certifié

Statut : **PASS** (`2026-08-13`). Cette étape prolonge la génération procédurale
EU déjà certifiée par une preuve fonctionnelle sérialisée du premier itinéraire :

```text
d01p01:g1 → Petit Bois 1–3F → d01p02:g1 → sauvetage → d01p01:g3
                   ↘ échec → d01p01:g2 → nouvelle tentative 1F
```

## Autorité et adaptation isolée

- ROM Europe SHA-256 :
  `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`.
- Ground final direct `d01p02` :
  `ce2e109b082a5a6986fb5768ea315b60dfb5549d882f2f11908842b37e52e47e`.
- Planche `d01p02_DirectBase.tile` :
  `0aff40efcb0a42849495510eac868402245e0489876da595511b28b74466350f`,
  installée sous `Content/Tile` et inscrite dans l’index binaire privé.
- La commande EU authentifiée à `0x084D4C78` (`op 0x44`, musique `114`)
  correspond à **In the Depths of the Pit**. L’asset officiel contrôlé vaut
  `4b22c99be63e4ec61055c9a32ea0951e4910132551a8258f58fe2f1a6f9d9cd2`.
- Les scripts, marqueurs, index, deux Grounds et la ZoneData modifiés restent
  dans un overlay jetable. Aucun Ground, script ou index de la quête suivie
  n’est promu par cette étape.

## Preuves fonctionnelles

Trois processus PMDO 0.8.12 distincts ont été exécutés en série :

1. **opening_entry** — `d01p01:g1`, position/direction du héros et entrée 1F ;
2. **defeat_retry** — véritable `ProcessPlayerInput(GameAction GiveUp)` avec
   `ResultType.Failed`, dialogue modal natif, `d01p01:g2`, puis retour 1F ;
3. **clear_rescue_cleanup** — 143 actions natives (déplacements, 2 attaques,
   3 actions de dalle/escalier), les trois étages dans l’ordre, routage naturel
   vers `d01p02:g1`, acteurs et positions EU, collision 1 503 cellules,
   musique EU, relais de sauvetage `g3`, puis nouvelle entrée sans acteur ni
   musique résiduels.

Le parcours recalcule une BFS cardinale tenant compte des occupants. Le seed
`424242` a produit 28 replans d’occupation et deux blocages hostiles réellement
résolus par des actions `Attack`; le leader n’est jamais téléporté.

Chaque terminaison vérifie `LoadPhase.Unload`, `NORMAL_EXIT`, code retour `0`,
`terminal=true`, `graceful=true`, sans watchdog, signal demandé, SIGSEGV,
kill forcé ni processus orphelin. L’indexation Zone PMDO est également PASS.

Le rapport machine principal est `native_route_validation.json`; les événements,
logs et classifications de terminaison de chaque scénario sont conservés dans
les sous-répertoires correspondants.

## Reproduction

Après restauration et contrôle des dépendances exactes :

```bash
bash tools/restore_pmdred_eu_validation_runtime.sh
bash docs/pmdred_eu/playable/tiny_woods/route_runtime/commands.sh
```

Les destinations sont create-only : choisir de nouveaux noms si elles existent.

## Limite de cette étape

Ce PASS certifie le routage, les actions, la progression et le nettoyage. Il ne
transforme pas les références de dialogue aplaties en scènes canoniques : le
texte français EU, la chorégraphie complète, les portraits, caméras, effets et
rythmes de `d01p01:g1/g2/g3` et `d01p02:g1` restent l’étape narrative suivante.
