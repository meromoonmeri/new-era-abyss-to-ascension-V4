--[[ Sommet de la Tour Céleste (Sky Tower Summit).

     ------------------------------------------------------------------
     ORIGINE DU DÉCOR
     ------------------------------------------------------------------
     Converti depuis Sky_Tower_summit_RTRB.png (Rescue Team Red/Blue) par
     tools/png2tileset.py, planche « Sky_Tower_Summit_Base », grille de
     8 px, 4968 tuiles, relecture sans écart.

     Le PNG source fait 551 px de large — largeur IMPAIRE, donc non
     divisible par la maille de 8 px du moteur. Recadré en 552 par
     duplication de la dernière colonne (bord de ciel uni : le raccord
     est invisible). 576 px de haut, déjà multiple de 8.

     ------------------------------------------------------------------
     GÉOMÉTRIE
     ------------------------------------------------------------------
     Carte 552x576 px = 69x72 cases. Le sol praticable est le DISQUE DE
     NUAGE clair au centre, isolé par remplissage connexe depuis le
     pixel (276,300) : sans cela, les nuages du fond — teinte identique
     au plateau — passaient pour du sol atteignable alors qu'ils flottent
     dans le vide. 16 poches isolées écartées.

     Marqueurs reposés sur du sol vérifié libre (les 4 cases de 8 px de
     chaque boîte 16x16 testées) :
       Main_Entrance_Marker (268, 464)  bas du disque, le joueur monte
       Boss_Marker          (268, 288)  centre du disque

     Les marqueurs hérités du gabarit (entrance_1, Hero_Bed,
     Partner_Bed) ont été purgés : ils venaient de guild_heros_room et
     n'ont aucun sens ici.

     ------------------------------------------------------------------
     CE QUE CETTE CARTE N'EST PAS ENCORE
     ------------------------------------------------------------------
     Aucune cinématique n'y est écrite. Rayquaza reste pour l'instant
     dans autel_celeste (celestial_peak segment 5), dont la chaîne
     Lugia -> Rayquaza est câblée et fonctionnelle. Déplacer le climax
     ici est une décision de scénario en attente d'arbitrage : on ne
     débranche pas une séquence qui marche avant d'avoir la remplaçante.

     Cette Ground est donc, à ce stade, un décor jouable et atteignable,
     prêt à recevoir sa scène.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'

local tour_ciel_sommet = {}

function tour_ciel_sommet.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo('=>> Init_tour_ciel_sommet')
  COMMON.RespawnAllies()
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)
end

function tour_ciel_sommet.Enter(map)
  DEBUG.EnableDbgCoro()
  -- Pas de cinématique à ce stade : on rend la main immédiatement.
  -- Le FadeIn est OBLIGATOIRE — sans lui le joueur reste sur un écran
  -- noir, défaut relevé sur d'autres cartes du mod le 2026-08-02.
  pcall(function() SOUND:PlayBGM('Sky Tower.ogg', true) end)
  GAME:FadeIn(20)
end

function tour_ciel_sommet.Update(map, time) end

function tour_ciel_sommet.GameSave(map)
  pcall(function() PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end)
end

function tour_ciel_sommet.GameLoad(map)
  pcall(function() PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1')) end)
  tour_ciel_sommet.Enter(map)
end

return tour_ciel_sommet
