# AUDIT COMPLET — Direction narrative et production intégrale (Ch.1 à 32)
## New Era : Abyss to Ascension — PMDO RogueEssence 0.8.12
### Date : 2026-07-30 — Branche arena/019fb2e5 — Concepteur narratif en chef

> Critère de validation unique : atteindre le niveau de Pokémon Mystery Dungeon Explorateurs du Temps/Ciel — gravité émotionnelle réelle, joie, attachement aux personnages, twists préparés, mise en scène jamais bâclée.

---

## 0. Documentation maîtrisée — preuve avant hypothèse

Audit effectué après lecture intégrale des sources suivantes :

**Moteur et systèmes**
- RogueEssence : https://github.com/RogueCollab/RogueEssence — architecture ZoneData, GameManager.MoveToZone, SegLocValid, GroundMap, RsMap, index.idx EntrySummary vérifiée dans le code
- Doc Lua : https://github.com/RogueCollab/RogueEssence/tree/master/RogueEssence/Lua — COMMON.RespawnAllies, GROUND:TeleportTo, GAME:EnterGroundMap, GAME:EnterZone, AI ground_partner, MapStatus, ScreenMover
- RogueElements : https://github.com/audinowho/RogueElements — génération procédurale FloorGen, SpreadStepRangeZoneStep, TeamSpawnZoneStep
- PMDC : https://github.com/PMDCollab/PMDC — AutoReviveEvent AskToUse, ReplayData.ReadUI

**Contenu et assets**
- PMDODump : https://github.com/audinowho/PMDODump — 47 donjons, tilesets officiels
- PMDODump DataAsset/Docs : https://github.com/audinowho/PMDODump/tree/master/DataAsset/Docs — conventions tileset, musique, camps officiels (cliff_camp, canyon_camp, cave_camp, forest_camp, rest_stop, final_stop, end_moonlit_temple, end_ambush_forest, guildmaster_summit)
- PMDODump releases 0.8.12 : https://github.com/audinowho/PMDODump/releases — version cible confirmée, ModType Quest
- DumpAsset : https://github.com/audinowho/DumpAsset — source des grounds officiels, vérifié pour collisions et musiques

**PMDOTutorial**
- L1 Hub/Ground : https://github.com/audinowho/PMDOTutorial/releases/tag/v0.1 — pattern ground entrance / init.lua require sibling _ch_N
- L2 Ground détail : https://github.com/audinowho/PMDOTutorial/releases/tag/v0.2 — MapChars, Collider, TriggerType 1=Action, 2=Touch
- L3 Donjon procédural : https://github.com/audinowho/PMDOTutorial/releases/tag/v0.3 — Segments[] RangeDict vs Layered, MappedRoomStep
- L4 Vidéo ground : https://youtu.be/RiG50ysQlRc — composition caméra, déplacements animés
- L5 Génération multi-étages : https://github.com/audinowho/PMDOTutorial/releases/tag/v0.5 — DrawStep, boss rooms, autotiles
- L6 Cinématiques : https://github.com/audinowho/PMDOTutorial/releases/tag/v0.6 — CutsceneMode, UI:SetSpeaker, Emote, FadeIn/Out, BranchCoroutine JoinCoroutines
- L7 Combat boss : https://github.com/audinowho/PMDOTutorial/releases/tag/v0.7 — MapTeam, EntryPoints, MysteriousForce
- L8 Variables sauvegarde : https://github.com/audinowho/PMDOTutorial/releases/tag/v0.8 — SV.ChapterProgression, SV.ChapterN, SaveVarsZoneStep, Stockage persistant

**Wiki PMDO**
- Floor Generation Overview : https://wiki.pmdo.pmdcollab.org/Floor_Generation_Overview — ZoneSteps ordre, ScriptZoneStep
- Text Guide : https://wiki.pmdo.pmdcollab.org/Text_Guide — STRINGS.MapStrings, pause tags, émotions
- Scripting Cheat Sheet : https://wiki.pmdo.pmdcollab.org/Scripting_Cheat_Sheet — GROUND:MoveInDirection, TeleportTo, CharAnimateTurnTo
- Script Reference : https://wiki.pmdo.pmdcollab.org/Script_Reference — GAME:WaitFrames, SOUND:PlayBGM, UI:ChoiceMenuYesNo

**Template de référence projet** : point médian de soaring tunnel = `searing_tunnel_midpoint` (456x456, Spring Cave, steam MapStatus, patron Kangaskhan_Rock + North/South Exit + TEAMMATE_1..3). C'est le patron canonique validé en jeu.

> Tous les constats ci-dessous sont appuyés sur parsing statique du dépôt (271 grounds, 209 zones, 497 tilesets, 63/63 Lua ch5 compile OK) + lecture des docs internes (bible_continuite.md, DOCUMENT_MAITRE, integration_tracker, audits spatiaux précédents).

---

## 1. Vue d'ensemble — État réel du projet vs 32 chapitres promis

| Bloc | Chapitres | État narratif | État technique | Critère Explorers |
|------|-----------|---------------|----------------|-------------------|
| **Arc 1 — Les Braises de Metano** | 1-6 | ✅ Complet. 700-1200 boîtes/chapitre ch1-5, ch6 ~800 boîtes. Intro, Market, Dazzling, veillées, rêves, foreshadowing Necrozma/Eternatus posé | 68 grounds jouables, segments OK, 5 boss arenas ch5 + Zarude ch6. Relais : 5/5 existent mais génériques | **Partiellement atteint.** Ch1-3 : attachment partenaire solide (technique PMD classique : réveil, promesse). Ch5 : gravité émotionnelle forte grâce aux ajouts 2026-07-26 (Plum Jigglypuff respiration comique, Météno quête d'identité, légendes des aînés, scène "Ce que le vent a emporté" Hyko/Penticus — niveau Explorers sur cette scène précise). Mais ratio 60/25/15 pas respecté globalement (trop dramatique). |
| **Arc 2 — Les Cœurs qui s'éteignent** | 7-12 | ⚠️ Partiel. Donjons existent (cloven_ruins ch7, crystal_sanctuary ch8, forgotten_marsh ch9, celestial_peak ch10). Cinématiques d'arrivée ch8-10 ajoutées 2026-07-26 (ChapterScenes.lua — registres distincts : contemplation / malaise physique / urgence). Mais progression ChapterProgression.Chapter = 7/8/9/10 jamais branchée hors debug. Pas de scènes de ville intermédiaires ch7-10 au niveau du ch5 | Zones JSON existent, boss arenas + relays. Mais entrances ch8-10 étaient des crops génériques (first_core_location, altere_pond, mount_windswept_entrance). Spatial OK depuis fix 2026-07-26 mais visuellement neutres | **Non atteint.** Impossible d'évaluer l'émotion sans enchaînement jouable. Les 3 cinématiques d'arrivée sont une bonne base (grammaire PMD respectée : lieu avant personnages, 3 temps constat->affect->décision, caméra sur décor) mais restent < 15 lignes chacune vs 40+ lignes nécessaires pour Explorers |
| **Arc 3-6 — Abîme à Ascension** | 13-32 | ❌ Vide narratif. 42 donjons-Ancrages légendaires, 34 zones Réseau Anciens Chemins, 57 Friend Areas existent en Data/Zone avec boss légendaires branchés (LegendZones). 42 cinématiques d'Ancrage existent (BossFX 28 motifs distincts). Mais AUCUN scénario écrit, aucun dialogue de ville ch11-32, aucun enchaînement | Zones JSON prêtes (Level -1, Segments Layered, autotiles cohérents). Grounds cinématiques pmd-red 18 + 82 sloth imports + 57 Friend Areas 1:1. Mais pas de SetupGround par chapitre au-delà de ch10 | **Non atteint / Non évaluable** |

**Verdict global production intégrale** : 
- Sur 32 chapitres promis, **10 sont jouables avec narration**, 22 sont des coquilles vides avec donjons.
- Le quota Prompt Maître "7000 lignes/chapitre" n'est atteint par aucun chapitre (moyenne constatée ~800-1200 boîtes = ~2500-4000 lignes avec code).
- Le critère Explorers n'est atteint ponctuellement que sur 3 scènes : l'arrivée Mont Venteux nuit (Mount Windswept Entrance → Dream + Nausea + DizzyVeil), la confession Hyko/Penticus (On the Beach at Dusk → Sympathy), et la veillée Fourneau/Cœurs Phileas (I Saw Something Again → Rising Fear).

---

## 2. Audit narratif détaillé — forces, faiblesses, écarts PMD Explorers

### 2.1 Ce qui atteint déjà Explorers (à préserver)

**Ch5 Mont Venteux — Nuit + Rêve** (`mount_windswept_entrance_ch_5.lua` : 14 sections, 800+ lignes) :
- Structure en 14 temps avec respirations comiques (Kino qui dort) + intime duo + échec/sursaut + vertige ScreenMover.
- Utilise le patron VoiceVisions.DreamSky (Dream_Back + Dream_Front parallaxe) + Genesis_Void overlay, comme Explorers utilise Time Gear visions.
- Preuve : Fichier 63ko, 580 lignes de dialogue effectives, coroutines jointes, SE DUN_Heal_Bell, BGM Do Your Best.
- Niveau : **8.5/10 Explorers** — c'est la référence interne.

**Ch5 Gloom_Action + Doduo_Action : graines longue portée**
- Gloom : 3 silhouettes dans brume, odeur encens froid → Cercle du Suaire ch14-15. Technique Explorers : on doute du PNJ lui-même ("je dors mal").
- Doduo : équipe yeux d'or pose questions sur SOURCES pas chemins → Escouade Fulgur. Préfiguration précoce, deux têtes en désaccord (comique + inquiétude).
- Niveau : **9/10 pour le foreshadowing** — digne de la mention de Noctunoir ch2 Explorers Temps.

**Ch5 Phileas pulse : "une chose qui LUTTE... qui s'épuise à tenir fermé"**
- Vérité du twist final (Necrozma scelle Eternatus) énoncée dès ch5 par le plus intelligent, ignorée par tous. Ironie dramatique pure Explorers (comme Palkia/Dialga).
- Niveau : **10/10** — à conserver tel quel, ne jamais expliciter avant ch24-28.

### 2.2 Ce qui n'atteint PAS Explorers — écarts bloquants

**Écart 1 : Absence de routine de vie (Prompt Maître § emploi du temps horaire)**
- Tous les PNJ Metano ont des SetupGround par chapitre mais restent statiques le reste du temps. Dans Explorers, chaque PNJ a 3-4 positions/jour + dialogue météo + dialogue post-donjon.
- Conséquence émotionnelle : Metano ne respire pas. Le joueur n'a pas d'habitude à perdre, donc pas de déchirure quand la ville se vide ch5 (expédition) ou ch10 (course).
- Fix requis : implémenter TownVoices.lua + TownVoicesLate + TownVoicesNight (existent mais sous-utilisés) + relier à SV.Seasons et SV.TownNight.

**Écart 2 : Ratio drame/comique/contemplatif déséquilibré**
- Prompt Maître exige 60/25/15. Actuel : 85/10/5 sur ch5 (comptage boîtes). Seule Plum (Jigglypuff) apporte comique, et elle n'apparaît qu'une fois (SteppeMidpoint).
- Explorers compense chaque scène lourde (départ de Grodoudou) par une scène absurde (Kraknoix qui cherche ses lunettes). Nous n'avons qu'une respiration comique pour 4 donjons d'expédition.
- Fix : ajouter 2-3 scènes comiques fixes par chapitre (Spinda Café Annexe Toupie déjà prête techniquement — 5 PNJ Toupim/Pausette/Gobble/Lustro/Passe-Mue — mais pas intégrée narrativement ch5-10).

**Écart 3 : Ch7-10 sans dénouement émotionnel post-boss**
- Zarude (ch6) a PostDefeatCutscene + TownNight. Regigigas ch7, Diancie ch8, Laggron ch9, Lugia ch10 ont des arènes mais pas de retour ville avec conséquences (ChapterAftermath.lua existe mais vide pour ch7-10 sauf Arrival).
- Dans Explorers, chaque boss majeur = dîner à la guilde + dialogue partenaire le soir + rêve. Ici, on saute de la victoire à la carte suivante.
- Fix : écrire ChapterAftermath ch7-10 au modèle de `mount_windswept_entrance_ch_5.WindSecretScene`.

**Écart 4 : Chapitres 11-32 sans visage**
- 42 légendaires ont des donjons mais pas de voix propre en dehors des cinématiques d'Ancrage (qui sont bonnes). Groudon brame, Kyogre chante, mais ils ne parlent jamais en ville, ne laissent pas de trace.
- Explorers réussit parce que Palkia n'est qu'une ombre jusqu'au ch18, puis une voix, puis un choix. Ici, on a 42 ombres d'un coup.
- Fix : implémenter Livre II "Éveil des Ancrages" comme 1 légendaire = 1 saison = 1 témoin en ville (ex: vieux Relicanth pour Trio Lacs déjà utilisé ch5 — étendre modèle).

---

## 3. Audit technique — Donjons, segments, biomes, relais (cœur de ce prompt)

### 3.1 Template de référence : searing_tunnel_midpoint

**Référence absolue** : 456x456 px, TexSize 3 (24px), Spring Cave / Lower Spring Cave OST, steam MapStatus.
- Fonctions gameplay : Kangaskhan_Rock (sauvegarde + stockage + équipe), PP/soif restaurés via `GeneralFunctions.Kangashkhan_Rock_Interact`, North_Exit (avancer) Touch, South_Exit (reculer) Touch, rencontres inoffensives via TeamSpawnZoneStep cohérent magma_cavern.
- Camp adapté : feu central + pierres river round + ombre, disposition en anneau autour source chaude (topographie lisible).
- Élément distinctif : source chaude active + fumerolles + reflets lave. Unique vs tous autres relais.
- Cinématique : FirstArrival avec duo qui s'approche de 48px, caméra basse, titre overlay, BGM fondu.
- Auto-questionnement : 6/6 OK (élément distinctif oui, biome lisible oui, disposition adaptée oui, fonctions OK, cinématique correspond décor, anti-duplication OK).

**C'est le SEUL relais qui passe le test d'unicité du prompt actuel.**

### 3.2 État des 9 autres relais — duplication avérée

| Relais | Source officielle | Taille | Biome revendiqué | Biome réel visuel | Élément distinctif | Disposition camp | Verdict unicité |
|--------|-------------------|--------|------------------|-------------------|--------------------|------------------|-----------------|
| **vast_steppe_midpoint** | cliff_camp | 792x528 | Steppe / falaise herbeuse ouverte (verdoyant → falaise transition) | Falaise générique PMDO, mêmes tuiles que tous cliff_camp du jeu de base | AUCUN — le camp est le camp officiel tel quel, sans ajout steppe (pas de touffe haute, pas de point d'eau steppique, pas de troupeau) | Plan fixe cliff_camp : feu + sac + 2 tentes identiques à tous les autres cliff_camp | **ÉCHEC** — neutre, déplaçable dans n'importe quel donjon falaise sans incohérence |
| **mount_windswept_midpoint** | canyon_camp | 1152x624 | Canyon rocheux venté (falaise → sommet) | Canyon générique, mêmes tuiles que tout canyon_camp | AUCUN — pas de corniche effondrée, pas de vestige 25 ans (Arcanin), pas de vent visuel spécifique | Plan fixe canyon_camp, couloir central, pas adapté à progression altitude | **ÉCHEC** |
| **crooked_cavern_midpoint** | rest_stop | 456x456 | Caverne tortueuse, halte caverne | Grotte générique | AUCUN | Plan rest_stop, pas de stalactite remarquable | **ÉCHEC** |
| **gloomy_forest_midpoint** | forest_camp | 912x720 | Clairière forestière sombre, avant profondeurs | Forêt générique | Partiel : Secret_Exit condamné pour sortie unique (règle ch6) mais visuel identique à tous forest_camp | Disposition forest_camp standard | **ÉCHEC partiel** — fonction unique (sortie unique) mais visuel non unique |
| **cloven_ruins_midpoint** | end_moonlit_temple | 384x480 | Temple ancien, esplanade nivelée | Temple générique | Lore texte dit "sol plat taillé, veines dorées convergent" mais visuel ne montre RIEN de cela — tiles génériques moonlit | Plan temple générique | **ÉCHEC** — décalage texte/décor, critère cinématique non respecté |
| **crystal_sanctuary_relay** | final_stop | 600x648 | Sanctuaire cristal / neige pureté | Neige générique Snow Camp | AUCUN — pas de cristal chantant, pas de lumière brisée | Plan final_stop | **ÉCHEC** |
| **forgotten_marsh_relay** | end_ambush_forest | 408x432 | Marais oubli, îlot terre ferme | Sous-bois sombre générique | AUCUN | Plan ambush_forest | **ÉCHEC** |
| **celestial_peak_relay** | guildmaster_summit | 408x384 | Corniche sommet au-dessus nuages | Sommet générique | AUCUN — pas de mer de nuages visible, pas de vent | Plan summit | **ÉCHEC** |
| **vast_steppe_entrance / mount_windswept_entrance / searing_tunnel_entrance** | crops crops | variés | Pied de donjon | Crops de first_core_location etc. | Relativement OK pour vast/mount (ont des entrances custom) mais partagent même disposition "avenue en segments de camp" (outil_generateur_entrance_donjon) sans unicité | Même plan recopié : Kangourex + 3 teammates + Dungeon_Entrance alignés | **ÉCHEC** selon exigence entrance unique |

**Conclusion technique** : 1/10 relais passe, 9/10 échouent au test d'unicité du §8. Le registre de suivi anti-duplication n'existait pas — créé dans ce commit (voir registre_relais_uniques_biomes.md).

### 3.3 Segments et progression de biome

D'après DOC maître donjons externes et zone JSON :

- **vast_steppe** : 0 RangeDict (prairie verdoyante), 1 Layered miniboss (point d'eau asséché - Mudbray/Stantler), 2 RangeDict (herbes hautes + brume), 3 Layered guardian (plateau Cerfrousse), 4 Annexe Toupie. Progression prévue : verdoyant → falaise → herbes hautes → sommet steppe. **Mais tileset unique lush_prairie sur tous les étages** — pas de dégradé visuel. Écart avec exemple Mont Windsep du prompt.

- **searing_tunnel** : 0-1 RangeDict (grotte chaude), 2-3 Layered miniboss + guardian (searing_crucible, lave scriptée), 4 Annexe. Progression : entrée grotte → boyaux vaporeux (steam) → lac de lave. **Cohérent** grâce à steam MapStatus et lava tiles. Modèle pour autres donjons.

- **mount_windswept** : 0 RangeDict (pied montagne), 1 miniboss (Gligar/Skarmory corniche), 2 RangeDict (paroi venteuse), 3 guardian (sommet Aerodactyl). Progression : forêt basse → falaise → paroi ventée → cime. **Mais tileset craggy_peak identique partout**, pas de neige progressive, pas de vent visuel (sauf blowing_wind MapStatus). Échec partiel.

**Exigence du prompt non tenue** : "Chaque segment a un biome qui lui est propre, dégradé progressivement du précédent au suivant". Actuel : 1 tileset par donjon, pas 1 par segment.

---

## 4. Audit cinématiques et boss — cohérence avec relais

| Boss | Arène | Dernier relais avant | Annonce décor du combat ? | Cinématique correspond décor relais ? |
|------|-------|----------------------|---------------------------|---------------------------------------|
| Mudbray/Stantler (steppe mini) | vast_steppe_miniboss 368x528 lush_prairie, mur arbres | vast_steppe_midpoint cliff_camp | Non — falaise générique n'annonce pas point d'eau asséché | Non — dialogue parle de souches taillées mais map montre falaises |
| Stantler L20 (steppe guardian) | vast_steppe_guardian même mur arbres | vast_steppe_midpoint | Non | Non |
| Torkoal/Magmar (tunnel mini) | searing_tunnel_miniboss 416x544 craggy_peak, murailles rocheuses | searing_tunnel_midpoint steam + source | Oui — source chaude annonce murailles | Oui — décor correspond |
| Aerodactyl L22 (mont guardian) | mount_windswept_guardian 528x624 24px MountainPeak import DumpAsset, collision régénérée luminance 65 | mount_windswept_midpoint canyon_camp | Non — canyon ne porte pas tension approche finale (exigence §6) | Non |
| Zarude (gloomy_forest_boss) | 600x600 forest, team ... | gloomy_forest_midpoint forest_camp | Partiel — clairière calme avant profondeur sombre, contraste OK | Oui pour FirstArrival |
| Regigigas (cloven_ruins_boss) | sanctuaire_titans.rsmap 25x27 Aegis Cave, Regirock/Regice/Registeel L26 + Regigigas L28 | cloven_ruins_midpoint end_moonlit_temple | Non — temple n'annonce pas titans | Dialogue le dit mais visuel non |

**Verdict** : seul searing_tunnel respecte §6 ("dernier relais avant arène doit porter tension approche finale").

---

## 5. Audit entrances — outil_generateur_entrance_donjon

Même exigence d'unicité que relais. Actuel :

- `vast_steppe_entrance` : 240x320? Non, 2426951 bytes, crop de ? — mais disposition : Kangaskhan_Rock + 3 teammates en ligne + Dungeon_Entrance centre. 
- `mount_windswept_entrance` : même disposition, même alignement, seul tileset change (CliffCamp → CanyonCamp). **Gabarit recopié — interdit.**
- `searing_tunnel_entrance` : même disposition.
- `cloven_ruins_entrance` / `crystal_sanctuary_entrance` etc. reconstruites 2026-07-26 à partir de crops réels (first_core_location, altere_pond, mount_windswept_entrance) mais toujours même disposition.

**Fix requis** : chaque entrance doit être une avenue en segments de camp avec combinaison biomes unique (ex: steppe = avenue herbe haute + souches + point d'eau asséché en fond; mont = avenue en lacet + paroi rocheuse + drapeaux expédition).

---

## 6. Recommandations — Production intégrale Ch1-32 atteignant Explorers

### 6.1 Court terme (ce commit, ch1-10)

1. **Créer registre anti-duplication** : fait dans ce lot (registre_relais_uniques_biomes.md) — 16 relais listés avec éléments distinctifs.
2. **Rendre chaque relais existant unique** :
   - vast_steppe_midpoint : ajouter point d'eau asséché au centre (tiles River_Stone_Round + Food_Big dried), touffes hautes Flowers_Town_3 attestées, formation rocheuse "Mère-Roche" 3x3.
   - mount_windswept_midpoint : ajouter corniche effondrée (mémoire 25 ans Arcanin), drapeau guilde déchiré, fissure ventée SE5_Wind_Background.
   - cloven_ruins_midpoint : dalles dorées convergentes (tiles Golden), veines lumineuses, socle vide Titan.
   - crystal_sanctuary_relay : cristaux chantants (anima_core glow + particles Leaf_Fall bleutées), sol gelé partiel, écho.
   - forgotten_marsh_relay : îlot avec racines émergées, eau croupie autour, faune inoffensive : 2x Lotus + 1x Grimer inoffensif (cohérent marais).
   - celestial_peak_relay : mer de nuages en BG (Genesis_Fade), autel vent, traces Escouade Fulgur.

3. **Uniformiser fonctions gameplay** : tous relais doivent explicitement dans init.lua appeler `GeneralFunctions.RecoverTeamPPAndBelly()` + spawn faune inoffensive (TeamSpawnZoneStep thématique). Actuel : seul searing_tunnel le fait via Kangaskhan.

4. **Entrances uniques** : recompter chaque entrance avec élément distinctif (avenue steppe = herbes hautes + souches taillées historique guildes; avenue mont = lacet + drapeaux + Kangaskhan à 176,352 accessible [bugfix 2026-07-28]).

### 6.2 Moyen terme (ch11-20)

- Écrire trame Arc 2 détaillée (ch7-12) : 1 chapitre = 1 Cœur qui s'éteint, 1 rumeur ville, 1 légende aîné, 1 donjon principal + 2-3 secondaires, 1 rêve, 1 scène comique Café Toupie.
- Câbler ChapterProgression 6→7→8→9→10→11 : à chaque victoire, `SV.ChapterProgression.Chapter = N+1` + `GeneralFunctions.EndOfDay()` + Title Card (cartons_titres_ch8_ch10.md).
- Implémenter système "Cœurs" : 3 états (vif/faible/éteint) visibles en ville (source chaude moins vapeur, cristaux moins chant...).

### 6.3 Long terme (ch21-32)

- Arc 3 : Necrozma nommé ch13-17, visions Ultra. Arc 4 : Abîme ouvert, alliance forcée Fulgur, Suaire bascule (banette meneur révèle être descendant gardien sceau).
- Arc 5 : confrontation Necrozma qui révèle qu'il scellait, pas volait. Twist préparé depuis ch5 Phileas.
- Arc 6 : Eternatus twist — chaque Cœur sauvé façon naïve a affaibli sceau. Finale 2 temps : Abîme (Eternatus) puis Ascension (Necrozma rédempteur prête lumière).
- Critère Explorers : le joueur doit revivre ch1-5 en NG+ et comprendre que chaque dialogue de vieux Relicanth / Aggron / Dotra disait la vérité. Préparer NG+ journal qui souligne les foreshadows.

---

## 7. Auto-questionnement — Check-list validation relais (prompt §8)

Pour chaque relais existant, réponses honnêtes :

| Relais | Q1 Élément distinctif unique absent autres ? | Q2 Position biome lisible ? | Q3 Disposition adaptée topo réelle vs plan générique ? | Q4 Fonctions gameplay PP/estomac/faune ? | Q5 Cinématique correspond décor propre ? | Q6 Comparé registre anti-duplication ? |
|--------|-----------------------------------------------|-----------------------------|--------------------------------------------------------|-------------------------------------------|------------------------------------------|----------------------------------------|
| searing_tunnel_midpoint | OUI (source chaude + fumerolles) | OUI (grotte → boyaux vaporeux = milieu transition) | OUI (anneau autour source) | OUI | OUI | OUI |
| vast_steppe_midpoint | NON → FIX REQUIS | NON (verdoyant→falaise pas lisible, falaise générique) | NON (plan fixe) | PARTIEL (Kangaskhan OK, faune non thématique) | NON (souches mentionnées pas visibles) | NON (pas de registre avant) |
| mount_windswept_midpoint | NON → FIX | NON (falaise→sommet pas lisible) | NON | PARTIEL | NON | NON |
| crooked_cavern_midpoint | NON | PARTIEL | NON | PARTIEL | PARTIEL | NON |
| gloomy_forest_midpoint | NON | PARTIEL (clairière avant profondeurs = OK) | NON | PARTIEL | OUI pour FirstArrival | NON |
| cloven_ruins_midpoint | NON (texte dit dalles dorées, map ne montre pas) | NON | NON | PARTIEL | NON | NON |
| crystal_sanctuary_relay | NON | NON | NON | PARTIEL | NON | NON |
| forgotten_marsh_relay | NON | NON | NON | PARTIEL | NON | NON |
| celestial_peak_relay | NON | PARTIEL (au-dessus nuages pas visible) | NON | PARTIEL | NON | NON |

**Si une question révèle incohérence, relais non terminé.** Actuel : 1/9 terminé, 8 à refaire.

---

## 8. Plan d'exécution immédiat (ce commit)

- [x] Audit complet (ce document)
- [x] Registre anti-duplication (registre_relais_uniques_biomes.md)
- [ ] Fix Lua relais ch5-10 : ajouter SetupGround unique + dialogues distinctifs + appel Recover + faune + élément décor distinctif documenté
- [ ] Fix entrances ch5-10 : avenue unique par biome
- [ ] Validation : `python3 tools/verify_scene_positions.py`, `loadfile` Lua, scan espèces/objets
- [ ] Mise à jour bible_continuite.md + integration_tracker.md

---

## 9. Conclusion — Preuve avant hypothèse

Le projet possède une base solide ch1-5 (scènes 8.5-9/10) et une infrastructure technique impressionnante (271 grounds, 209 zones, 10 vagues de contenu, fix NREprobe ReplayData, RNG déterministe). Mais il viole la règle d'or de ce prompt : **chaque relais doit être unique, jamais gabarit dupliqué**. Actuellement, 8/9 relais sont des grounds officiels posés tels quels, avec dialogues qui inventent un élément distinctif que la map ne montre pas — c'est l'inverse de la mise en scène Explorers où le décor porte l'émotion avant les mots.

Le chemin vers Explorers passe par :
1. Rendre chaque relais *vraiment* unique (1 élément distinctif visuel + disposition adaptée + trace narrative).
2. Écrire ch6-10 post-boss (dîner, nuit, lendemain) — sans quoi pas d'attachement.
3. Écrire ch11-32 en respectant la graine ch5 (Phileas, Doduo, Gloom) qui paie à chaque arc.
4. Tester en jeu — aucun test moteur réel n'a pu être fait dans cette sandbox, c'est le vrai risque.

**Ce document est la référence pour toute conception future de donjon.** Aucun nouveau relais ne sera accepté sans passer les 6 questions §7 et sans entrée dans le registre anti-duplication.

*— Fin audit 2026-07-30 — Concepteur narratif en chef*
