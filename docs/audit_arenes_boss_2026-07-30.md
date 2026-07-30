# Audit des arènes de boss — 2026-07-30

## Résumé

**9 arènes auditées** : 4 OK, 5 à corriger

| Arène | Boss | Tileset actuel | Biome attendu | Statut |
|---|---|---|---|---|
| Le Creuset (ch5) | Heatran/Magcargo | ❌ VIDE | magma/lave | À CORRIGER |
| Sommet des Mille Vents (ch5) | Tornadus | craggy_peak | montagne/vent | ✅ OK |
| Mini-boss Mont Venteux (ch5) | Gligar+Skarmory | craggy_peak | montagne/vent | ✅ OK |
| Forêt Lugubre (ch6) | Zarude | treeshroud_forest | forêt sombre | ✅ OK |
| Ruines Tordues (ch7) | Regigigas | concealed_ruins | ruines anciennes | ✅ OK |
| Sanctuaire Cristal (ch8) | Diancie | concealed_ruins ❌ | cristal | À CORRIGER |
| Marais Oublié (ch9) | Laggron | concealed_ruins ❌ | marais/eau | À CORRIGER |
| Pic Céleste (ch10) | Lugia | ❌ VIDE | ciel/montagne | À CORRIGER |
| Escouade Fulgur (ch10) | Luxray+Lucario+Heliolisk | concealed_ruins ❌ | ciel/montagne | À CORRIGER |

---

## Arènes à corriger

### 1. Le Creuset (searing_crucible) — ch5

**Problème** : Tilesets vides ([])
**Biome attendu** : magma, lave, volcanique
**Tilesets suggérés** :
- `magma_cavern_2_floor` / `magma_cavern_2_wall` (déjà utilisé dans searing_tunnel)
- Ou `spring_cave_pit_floor` / `spring_cave_pit_wall` (lave visible)

**Action** : Ajouter les tilesets magma_cavern_2 ou spring_cave_pit

### 2. Sanctuaire Cristal (crystal_sanctuary_boss) — ch8

**Problème** : concealed_ruins (ruines) au lieu de cristal
**Biome attendu** : cristal, gemmes, lumière
**Tilesets suggérés** :
- `crystal_cave_1_floor` / `crystal_cave_1_wall` (cristal bleu)
- Ou `crystal_cave_2_floor` / `crystal_cave_2_wall` (cristal rose)

**Action** : Remplacer concealed_ruins par crystal_cave

### 3. Marais Oublié (forgotten_marsh_boss) — ch9

**Problème** : concealed_ruins (ruines) au lieu de marais
**Biome attendu** : marais, eau stagnante, végétation dense
**Tilesets suggérés** :
- `altere_pond_floor` / `altere_pond_wall` (étang)
- Ou `wayward_wetlands_floor` / `wayward_wetlands_wall` (zones humides)

**Action** : Remplacer concealed_ruins par altere_pond ou wayward_wetlands

### 4. Pic Céleste (celestial_peak_boss) — ch10

**Problème** : Tilesets vides ([])
**Biome attendu** : ciel, nuages, sommet montagneux
**Tilesets suggérés** :
- `mount_windswept_floor` / `mount_windswept_wall` (déjà utilisé dans mount_windswept)
- Ou `sky_peak_floor` / `sky_peak_wall` (sommet céleste)

**Action** : Ajouter les tilesets mount_windswept ou sky_peak

### 5. Escouade Fulgur (celestial_peak_fulgur) — ch10

**Problème** : concealed_ruins (ruines) au lieu de ciel/montagne
**Biome attendu** : ciel, sommet, vent
**Tilesets suggérés** :
- `mount_windswept_floor` / `mount_windswept_wall` (déjà utilisé)
- Ou `sky_peak_floor` / `sky_peak_wall`

**Action** : Remplacer concealed_ruins par mount_windswept ou sky_peak

---

## Arènes OK (pas de correction nécessaire)

### Sommet des Mille Vents (mount_windswept_guardian) — ch5
- Tilesets : craggy_peak_floor, craggy_peak_wall ✅
- Biome : montagne/vent ✅
- Boss : Tornadus/Boréas ✅

### Mini-boss Mont Venteux (mount_windswept_miniboss) — ch5
- Tilesets : craggy_peak_floor, craggy_peak_wall ✅
- Biome : montagne/vent ✅
- Boss : Gligar+Skarmory ✅

### Forêt Lugubre (gloomy_forest_boss) — ch6
- Tilesets : treeshroud_forest_1_floor, treeshroud_forest_1_wall ✅
- Biome : forêt sombre ✅
- Boss : Zarude ✅

### Ruines Tordues (cloven_ruins_boss) — ch7
- Tilesets : concealed_ruins_floor, concealed_ruins_wall ✅
- Biome : ruines anciennes ✅
- Boss : Regigigas ✅

---

## Plan d'action

1. **Priorité haute** : Corriger Le Creuset (tilesets vides)
2. **Priorité haute** : Corriger Pic Céleste (tilesets vides)
3. **Priorité moyenne** : Corriger Sanctuaire Cristal (mauvais tileset)
4. **Priorité moyenne** : Corriger Marais Oublié (mauvais tileset)
5. **Priorité moyenne** : Corriger Escouade Fulgur (mauvais tileset)

**Total** : 5 arènes à corriger, 4 arènes OK
