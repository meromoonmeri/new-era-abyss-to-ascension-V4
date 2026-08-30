# Seal of Ancients — visuels récupérables (état 2026-08-30)

**Ce ne sont PAS les renders de ground complets du hack.** À ce jour, les
seuls visuels du mode ground de *PMD: Seal of Ancients* récupérables depuis
cet environnement sont des captures de son fil PokéCommunity (récupérées via
le proxy d'index d'images, résolution de cache 256×192).

| fichier | source | ce que c'est |
|---|---|---|
| `soa_screenshot_inforest_hooray.png` | i.imgur.com/w5Ht7WY.png (fil PC#499279) | scène in-game sur ground forestier (clairière, arbres, buissons/fleurs, PNJ « Everyone: Hooray! ») |
| `soa_screenshot_ground_map_ruins.png` | i.imgur.com/FcX0te6.png (même fil) | plan large d'un ground « ruines/jardin » — passerelles bois, sol pierre, lisières d'arbres |

## Pourquoi pas les renders complets

La chaîne officielle existe et est validée ici même
(`tools/skyhacks/ground_retriever.py`, tests PASS sur vanilla EoS et sur
hack synthétique MODIFIED/NEW_GROUND). Elle exige le `.nds` patché (ou
`.ips` + ROM US propre). L'archive `PMD-Seal-of-Ancients.rar` n'est hébergée
QUE sur Dropbox, et la sandbox n'a de sortie réseau que vers
`github.com`/`api.github.com`/`pypi.org` — Dropbox/Drive/Discord CDN/
hacks.skytemple.org renvoient un code de connexion 000 (prouvé le
2026-08-30, voir `../SEAL_OF_ANCIENTS_GROUNDS_2026-08-30.md` §5).

Dès que le `.nds` patché (ou le dossier `files/` exporté de SkyTemple) est
disponible, `--baseline-manifest docs/skyhacks/eos_grounds/manifest.json`
produit automatiquement les renders PNG + GIF + collision de chaque ground,
et la liste exacte des grounds exclusifs (`MODIFIED`/`NEW_GROUND`).

## Lecture utile des deux captures (pré-analyse, non contractuelle)

- Le hack **reteint les grounds vanilla** plutôt que d'inventer des tuiles :
  palette de gris « ruines » sur base herbe/arbre EoS, passerelles bois
  (vocabulaire `S`/planche), roc clair en chemin — cohérent avec une carte
  retouchée dans SkyTemple (BPL/BPC modifiés).
- Bord de carte net sur fond vert plein à droite de la deuxième capture :
  attention, à vérifier au render complet avant d'en conclure quoi que ce
  soit (peut être un artifact de la capture, pas de la map).
