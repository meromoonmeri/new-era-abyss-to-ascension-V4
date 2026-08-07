# Rendu final canonique — Sinister Woods D04P02

La BMA seule produisait 84,6 % de pixels noirs. La salle finale complète a été retrouvée dans le rip canonique Rescue Team (480×376), convertie en tuiles 8 px et alignée sur la collision D04P02.

- planche Ground : `SinisterWoodsFinalCanonical_Base` ;
- 2 631 entrées, 347 images uniques ;
- positions originales translatées uniformément de (-32,-48) ;
- Team Dazzling reste sur les slots Team Meanies ;
- arène combat 20×16 dérivée du même Ground ;
- aucun décor inventé.

`tools/verify_sinister_woods_final.py` exige 0 pixel différent entre le cœur du Ground et la feuille finale canonique.

## Affichage PMDO sans noir

La salle source 480×376 est plus petite que le viewport PMDO 640×480 et contient des coins transparents. Elle est désormais centrée dans un canvas 640×480 entièrement opaque. Les marges sont composées exclusivement à partir des tuiles de canopée présentes dans D04P02, sans couleur ni asset externe. Elles sont toutes bloquées par la collision. Les entités, markers, caméra et VFX reçoivent la même translation `(80,48)`.

`tools/verify_pmdo_viewport_sinister.py` exige : largeur ≥640, hauteur ≥480, 0 pixel transparent et 0 pixel noir.
