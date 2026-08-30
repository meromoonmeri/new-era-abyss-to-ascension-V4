# Audit des Données Chiffrées et Bloquées (PMU-Server)

## 1. Principe d'Intégrité et de Non-Invention

Conformément aux règles strictes du projet :
- **Aucune donnée manquante n'est inventée.**
- **Aucune carte chiffrée n'est reconstituée par une IA ou un générateur synthétique.**
- **Aucune clé cryptographique n'est devinée arbitrairement.**
- Toutes les limites de données sont explicitement auditées et documentées ci-dessous.

---

## 2. Inventaire des Caches Clients Chiffrés V9 (`.dat`)

### 2.1 Contexte Technique du Chiffrement PMU
Dans le client PMU (`Client/Maps/MapHelper.cs`), les cartes mises en cache localement sont chiffrées en **TripleDES (3DES)** en mode CBC avec padding PKCS7.

Le code source public du client PMU contient une clé de développement par défaut. Cependant, lors des déploiements officiels en production, l'équipe PMU injectait une clé privée de déploiement lors du build de l'exécutable (`Script.dll` / client binaire).

### 2.2 Résultat de l'Audit Cryptographique
- **Fichiers analysés** : 140 fichiers `Map-*.dat` situés dans `resources/MapData/`.
- **Statut** : `BLOCKED` (Échec de validation du padding PKCS7 avec la clé publique par défaut).
- **Recouvrement avec le snapshot SQL public** : 137 de ces 140 cartes existent dans la base SQL `pmu_data.sql` (`Content_Data.zip`) sous forme de données brutes non chiffrées (`s1` à `s2000`).
- **Carte exclusive au cache (`s3000`)** :
  - **ID** : `s3000`
  - **Source** : `resources/MapData/Map-s3000.dat`
  - **Format** : Binaire V9 chiffré TripleDES
  - **Empreinte SHA-256** : `eaa40ba1367698a7837f84e7b45a06b65cc595b648985d0bf7c0483b571dbb74`
  - **Problème** : Clé de déploiement de production non publiée dans les dépôts open source.
  - **Donnée manquante** : Clé symétrique TripleDES de production.
  - **Raison exacte** : La clé par défaut checked-in échoue à la désérialisation. La carte `s3000` reste donc au statut `BLOCKED` et n'est pas promue dans New Era.

---

## 3. Valeurs de Tuiles Inconnues (`UNKNOWN`)

Dans le snapshot SQL public, deux maps historiques contiennent des codes `TileType` non répertoriés dans l'énumération officielle de PMU :

| Map ID | Coordonnées | Valeur Brute (`type`) | Statut | Traitement Pipeline |
| :--- | :--- | :--- | :--- | :--- |
| `s263` | `(12, 14)` | `101` | `UNKNOWN_101` | Conservé comme `raw_value: 101`, non converti en obstacle fantôme |
| `s268` | `(5, 8)`, `(5, 9)`, `(6, 8)`, `(6, 9)`, `(7, 8)` | `103` | `UNKNOWN_103` | Conservé comme `raw_value: 103`, documenté sans supposition |

---

## 4. Tableau Récapitulatif de Provenance et Frontière de Sécurité

```text
┌─────────────────────────────────────────────────────────────┐
│                    PMU SOURCES DISCOVERED                   │
│                                                             │
│  ┌──────────────────────────────┐  ┌─────────────────────┐  │
│  │   Snapshot SQL (s1..s2000)   │  │ Caches V9 (140 .dat)│  │
│  │    2,000 Standard Maps       │  │ (Clé Privée Manq.)  │  │
│  │                              │  │                     │  │
│  │  STATUS: SOURCE_CERTIFIED    │  │  STATUS: BLOCKED    │  │
│  │  ACQUISITION: 100% INTÈGRE   │  │  PROMOTION: REFUSED │  │
│  └──────────────┬───────────────┘  └─────────────────────┘  │
│                 │                                           │
└─────────────────┼───────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────┐
│                 PMU PIPELINE (NEW ERA)                      │
│                                                             │
│  - 2,000 cartes SQL disponibles pour sélection & extraction │
│  - Traitement déterministe à la demande                     │
│  - Zéro hallucination / Zéro génération artificielle        │
└─────────────────────────────────────────────────────────────┘
```
