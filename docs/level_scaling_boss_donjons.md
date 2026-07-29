# Level Scaling — Boss, mini-boss et donjons

> Dernière mise à jour : 2026-07-29.
> Document lié à `PROMPT_MAITRE.md`, `directive_arenes_boss_tournoi.md`.

---

## Règle fondamentale

**Chaque boss et mini-boss est TOUJOURS plus fort que les Pokémon
qui peuplent son donjon.** C'est une règle absolue, sans exception.

Le boss est le point culminant de difficulté du donjon. Le joueur doit
sentir la montée en puissance en approchant de l'arène.

---

## Courbe de niveaux — ch1 à ch10

| Chapitre | Donjon | Ennemis (niv) | Mini-boss | Boss/Gardien |
|---|---|---|---|---|
| 1 | Forêt Relique | 3-5 | — | — |
| 2 | Rivière Illuminée | 5-8 | — | — |
| 3 | Caverne Tortueuse | 7-10 | — | Luxio 10, Glameow 9, Cacnea 9 |
| 4 | Bosquet Apricorn | 10-14 | — | — |
| 5 | Grande Steppe | 15-22 | Mudbray+Stantler **25** | Stantler **27** |
| 5 | Tunnel Incandescent | 18-24 | Torkoal+Magmar **27** | Magcargo **29** |
| 5 | Mont Venteux | 20-26 | Gligar+Skarmory **30** | Aerodactyl **32** |
| 6 | Forêt Lugubre | 22-28 | — | Zarude **34** |
| 7 | Ruines Tordues | 24-30 | — | Regigigas **36** + trio **34** |
| 8 | Sanctuaire Cristal | 26-32 | — | Diancie **38** |
| 9 | Marais de l'Oubli | 28-34 | — | Laggron **40** |
| 10 | Pic Céleste | 30-36 | Escouade Fulgur **42** | Lugia **45** |

### Progression

```
Ch3  ████████░░░░░░░░░░░░  10
Ch5S ██████████████████░░  25-27
Ch5T ████████████████████░ 27-29
Ch5M █████████████████████ 30-32
Ch6  ██████████████████████ 34
Ch7  ███████████████████████ 36
Ch8  ████████████████████████ 38
Ch9  █████████████████████████ 40
Ch10 ██████████████████████████ 42-45
```

### Écart minimum boss/donjon

Le boss doit être au minimum **5 niveaux au-dessus** du niveau maximum
des ennemis de son donjon. Cet écart garantit que :
- Le boss est un vrai défi, pas un ennemi légèrement plus fort
- Le joueur doit utiliser des objets et une stratégie spécifique
- La victoire est satisfaisante

---

## Variété des Pokémon par donjon

Chaque donjon doit avoir une **identité faunique** propre :

| Donjon | Biome | Espèces attendues | Type dominant |
|---|---|---|---|
| Forêt Relique | Forêt | Chenipan, Aspicot, Roucool, Rattata | Normal/Insecte |
| Rivière Illuminée | Eau/Forêt | Magicarpe, Barpau, Yanma, Lombre | Eau |
| Caverne Tortueuse | Grotte | Nosferapti, Racaillou, Onix, Sabelette | Roche/Sol |
| Bosquet Apricorn | Forêt | Chenipotte, Balignon, Granivol, Ceribou | Plante |
| Grande Steppe | Prairie | Tauros, Kecleon, Écrémeuh, Ponchiot | Normal |
| Tunnel Incandescent | Volcanique | Tadmorv, Smogo, Grindur, Limagma | Feu/Poison |
| Mont Venteux | Montagne | Nidorino, Makuhita, Chimpenfeu, Éoko | Combat/Vol |
| Forêt Lugubre | Forêt sombre | Ténéfix, Mysdibule, Dimoret, Spiritomb | Ténèbres |
| Ruines Tordues | Ruines | Archéomire, Gringolem, Tutankafer, Balbuto | Acier/Psy |
| Sanctuaire Cristal | Cristal | Strass, Diancie*, Mélancolux, Selutin | Roche/Fée |
| Marais de l'Oubli | Marais | Rosélia, Nostenfer, Smogogo, Tentacool | Poison/Eau |
| Pic Céleste | Ciel/Sommet | Électhor*, Airmure, Brutalibré, Hélioncelle | Vol/Électrik |

### Règles de variété

1. **Minimum 8 espèces** par donjon (sauf donjons très courts)
2. **Maximum 2 espèces du même type** dominant
3. **Au moins 1 espèce rare** (taux de spawn < 10%)
4. **Pas de doublon** entre donjons du même chapitre
5. Les espèces doivent être **cohérentes avec le biome**

---

## Corrections appliquées (audit 2026-07-29)

| Boss | Niveau avant | Niveau après | Raison |
|---|---|---|---|
| Zarude (ch6) | 27 | **34** | Était < Gardien Mont ch5 (32) |
| Regigigas (ch7) | 28 | **36** | Était < Gardien Mont ch5 (32) |
| Regi trio (ch7) | 26 | **34** | Doit être cohérent avec Regigigas |
| Diancie (ch8) | 30 | **38** | Progression au-dessus de ch7 |
| Laggron (ch9) | 32 | **40** | Progression au-dessus de ch8 |
| Escouade Fulgur (ch10) | 33 | **42** | Était < Regigigas corrigé |
| Lugia (ch10) | 35 | **45** | Boss final de l'arc 1 |

---

## Auto-questionnement

- [ ] Le boss est-il au moins 5 niveaux au-dessus des ennemis du donjon ?
- [ ] Le donjon a-t-il au moins 8 espèces de Pokémon ?
- [ ] Les espèces sont-elles cohérentes avec le biome ?
- [ ] La progression de niveau est-elle monotone croissante sur l'arc ?
- [ ] Chaque donjon a-t-il une identité faunique distincte ?
