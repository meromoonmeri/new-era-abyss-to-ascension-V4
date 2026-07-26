# Tableau de suivi — Réutilisation multi-sources (directive §4)

Source de vérité pour l'audit global (§10). Une ligne par ressource migrée/réutilisée, tous mods sources confondus.

| Mod source | Ressource d'origine | Nouvelle identité New Era | Chapitre | Boss / Event | Fonction narrative | Type | Statut |
|---|---|---|---|---|---|---|---|
| ProjectEoN | BranchwayWoodsExitCutscene | gloomy_forest_exit_witness | 6 | — | Découverte de la corruption des Anima, avant boss | Donjon principal | Fait |
| PMDO base (DumpAsset) | end_treacherous_mountain | mount_windswept_guardian | 5 | Aerodactyl | Arène du gardien du sommet | Donjon principal | Fait (collision régénérée) |
| Halcyon (base du mod) | searing_tunnel_midpoint | Patron « relais Statue Kangourex » | 5+ | — | Modèle canonique de checkpoint mi-donjon | Infrastructure | Fait |
| Halcyon (composition biome) | vast_steppe_entrance (tiles) | vast_steppe_midpoint | 5 | — | Relais Grande Steppe (repos avant mini-boss) | Donjon principal | Fait — entités corrigées 2026-07-26 |
| Halcyon (composition biome) | mount_windswept_entrance (tiles) | mount_windswept_midpoint | 5 | — | Relais Mont Venteux | Donjon principal | Fait — entités corrigées 2026-07-26 |
| Halcyon (composition biome) | gloomy_forest/relic (tiles) | cloven_ruins_entrance / _midpoint / _boss | 7 | Regigigas | Cœur d'Anima des Ruines, Titan gardien | Donjon principal | Fait — flux + entités corrigés 2026-07-26 |
| Halcyon (crop réel) | first_core_location | crystal_sanctuary_entrance | 8 | — | Seuil du Sanctuaire, réserve d'Anima cristallisée | Donjon principal | Fait — reconstruite 2026-07-26 |
| Halcyon (crop réel) | altere_pond | forgotten_marsh_entrance | 9 | — | Berges du Marais de l'Oubli | Donjon principal | Fait — reconstruite 2026-07-26 |
| Halcyon (crop réel) | mount_windswept_entrance | celestial_peak_entrance | 10 | — | Pied du Pic Céleste | Donjon principal | Fait — reconstruite 2026-07-26 |
| New Era (modèle cloven) | cloven_ruins_relay.rsmap | crystal/marsh/celestial relais (.rsmap) | 8-10 | — | Étages-relais sûrs mi-donjon | Infrastructure | Fait 2026-07-26 |
| New Era (modèle cloven) | cloven_ruins_boss.rsmap | crystal_sanctuary_boss / forgotten_marsh_boss / celestial_peak_boss / celestial_peak_fulgur (.rsmap) | 8-10 | Diancie / Laggron / Lugia / Escouade Fulgur | Arènes de boss et course Fulgur | Donjon principal | Fait 2026-07-26 — équilibrage à tester en jeu |
| ProjectEoN | Wishmaker Cave | Sanctuaire Anima de Jirachi | 7 | Jirachi | Origine des Anima | Donjon principal | À faire |
| ProjectEoN | Crystal zones | Sanctuaire Diancie (assets visuels) | 8 | Diancie | Réserve d'Anima cristallisée | Donjon principal | À faire (tilesets dédiés) |
| ProjectEoN | Abyss zones | Ruines Eon | 9 | Entité Abyss | Corruption | Donjon secondaire | À faire |
| ProjectEoN | Sky zones | Ascension finale | 10 | Boss final | Résolution | Donjon principal | À faire (tilesets dédiés) |

## Justification narrative des légendaires (§5)

- **Regigigas (ch7)** : Titan gardien du Cœur d'Anima des Ruines Tordues. Ni hostile ni corrompu : il protège ce qui reste du Cœur. La Voix de l'Abysse guide volontairement l'équipe vers lui — premier indice de manipulation. Conséquence : `SawAnimaCoreCorruption`, conduit au récit de la Genèse par Phileas.
- **Diancie (ch8)** : gardienne d'une réserve d'Anima cristallisée ; hostile parce qu'elle soupçonne les visiteurs d'être responsables de l'affaiblissement des Cœurs — test moral, pas mur de HP. Conséquence : `ObtainedCrystalFragment`.
- **Lugia (ch10)** : Gardien des Cieux au sommet du Pic Céleste ; juge la légitimité de l'équipe avant la vision de Necrozma. Conséquence : `SawNecrozmaVision`, transition vers l'arc final.
- **Laggron (Mega-Blastoise prévu, ch9)** : gardien millénaire du Cœur du Marais. Note : la trame (`docs/08_zones_vivantes_ch8_ch10.md`) prévoit Mega-Blastoise ; le sprite/espèce méga n'étant pas garanti dans le jeu de base, l'arène utilise **Laggron (Swampert)** en attendant la validation d'un asset méga. À trancher avant la démo.
