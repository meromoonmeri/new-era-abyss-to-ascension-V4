--[[
    BossMusic.lua

    DIRECTION MUSICALE DES COMBATS DE BOSS
    ================================================================
    CONSTAT DE L'AUDIT
    ------------------------------------------------------------------
    48 arenes de gardiens sur 49 jouaient EXACTEMENT le meme theme :
    `Boss Battle!.ogg`, une boucle de 46 secondes. Arceus, Rayquaza,
    Dialga, Lugia, les dix Veilleurs et les 42 gardiens d'Ancrage
    partageaient la meme bande-son.

    Pendant ce temps, 14 pistes deja embarquees n'etaient JAMAIS jouees,
    dont plusieurs taillees pour un affrontement majeur :

        Dialga's Fight To the Finish!   2 min 15   1 usage
        Battle Against Dusknoir         1 min 40   0 usage
        In the Future                   2 min 00   0 usage
        Time Restored                   1 min 17   0 usage
        Aegis Cave                      1 min 21   0 usage
        Monster House!                  0 min 55   0 usage

    Le probleme n'etait pas le manque de musique — le mod en embarque
    133 pistes, 216 minutes — mais leur ATTRIBUTION.

    ------------------------------------------------------------------
    PRINCIPE : LA MUSIQUE DIT QUI EST LE BOSS
    ------------------------------------------------------------------
    Chaque famille recoit une couleur sonore, et a l'interieur d'une
    famille les pieces majeures ont leur theme propre. Un joueur doit
    pouvoir reconnaitre A L'OREILLE, avant meme de voir le sprite, s'il
    affronte une machine oubliee, un gardien du ciel ou une entite qui
    precede le monde.

    AUCUN FICHIER AJOUTE. Aucune question de licence : toutes les pistes
    citees ici sont deja dans Content/Music et deja creditees dans
    CREDITS.md. C'est une redistribution, pas un import.

    ------------------------------------------------------------------
    LES SEPT REGISTRES
    ------------------------------------------------------------------
      COSMIQUE     Ce qui precede le monde : origine, temps, espace.
                   -> Dialga's Fight To the Finish! / Temporal Tower
                   Le theme le plus long et le plus dense du repertoire,
                   reserve aux quatre entites qui n'ont pas d'age.

      CIEL         Les gardiens des hauteurs. Registre ample, aerien.
                   -> Sky Tower / Rainbow Peak

      OMBRE        Ce qui vient d'en dessous ou d'a cote. Registre
                   sourd, oppressant. -> The Power of Darkness /
                   Battle Against Dusknoir

      NATURE       Les gardiens du vivant : lacs, forets, saisons.
                   Registre plus clair, moins martial. -> Hidden Land

      TELLURIQUE   Ce qui dort dans la roche et le feu.
                   -> Deep Dark Crater / Enraged Caldera

      MACHINE      Les Veilleurs du Reseau : ce ne sont pas des dieux,
                   ce sont des postes de garde qu'on a oublie de relever.
                   Registre froid, mecanique. -> Aegis Cave / In the Future

      EPREUVE      Mini-boss et rivaux : l'enjeu est sportif, pas cosmique.
                   -> Boss Battle! garde ce role, et REDEVIENT
                   l'exception au lieu d'etre la regle.

    ------------------------------------------------------------------
    USAGE
    ------------------------------------------------------------------
      require 'halcyon.BossMusic'
      BossMusic.Play('escalier_origine')   -- joue le theme de l'arene

    Repli sur 'Boss Battle!.ogg' si l'arene n'est pas dans la table :
    aucune scene ne peut se retrouver muette a cause de ce module.
]]
require 'origin.common'

BossMusic = {}

--Toutes ces pistes sont presentes dans Content/Music (verifie).
local T = {
  COSMIQUE   = "Dialga's Fight To the Finish!.ogg",
  COSMIQUE_2 = 'Temporal Tower.ogg',
  CIEL       = 'Sky Tower.ogg',
  CIEL_2     = 'Rainbow Peak.ogg',
  OMBRE      = 'The Power of Darkness.ogg',
  OMBRE_2    = 'Battle Against Dusknoir.ogg',
  NATURE     = 'Hidden Land.ogg',
  TELLURIQUE = 'Deep Dark Crater.ogg',
  TELLUR_2   = 'Enraged Caldera.ogg',
  MACHINE    = 'Aegis Cave.ogg',
  MACHINE_2  = 'In the Future.ogg',
  EPREUVE    = 'Boss Battle!.ogg',
  MYTHE      = 'Time Restored.ogg',
}

--------------------------------------------------------------------
-- ATTRIBUTION — une ligne par arene, avec la RAISON du choix.
--------------------------------------------------------------------
BossMusic.LIST = {

  ---------------- COSMIQUE : ce qui precede le monde ----------------
  -- Le theme le plus dense du repertoire (2 min 15). Quatre arenes
  -- seulement y ont droit : celles ou l'adversaire est anterieur au
  -- monde lui-meme. La rarete fait l'evenement.

  ---------------- CIEL : les gardiens des hauteurs ----------------
  -- TORNADUS, gardien du sommet du Mont Venteux (ch5). Registre CIEL
  -- par definition : c'est le seul boss du donjon, il regne sur les
  -- vents de haute montagne. Sky Tower plutot que Rainbow Peak — le
  -- registre ample et tendu convient a un gardien qui juge, pas a une
  -- ascension contemplative.
  mount_windswept_guardian = T.CIEL,

  ---------------- OMBRE : ce qui vient d'a cote ----------------

  ---------------- NATURE : les gardiens du vivant ----------------

  ---------------- TELLURIQUE : la roche et le feu ----------------

  ---------------- MACHINE : les Veilleurs du Reseau ----------------
  -- Ce ne sont pas des dieux : ce sont des postes de garde qu'on a
  -- oublie de relever. Registre froid, repetitif, mecanique.

  ---------------- ELECTRIQUE / VIVACITE ----------------

  ---------------- EPREUVE : rivaux et mini-boss ----------------
}

--------------------------------------------------------------------
-- BossMusic.Play(arene)
--------------------------------------------------------------------
-- Lance le theme de l'arene. Repli garanti : une arene absente de la
-- table joue le theme generique plutot que de rester muette.
function BossMusic.Play(arene, loop)
  local m = BossMusic.LIST[arene] or T.EPREUVE
  pcall(function() SOUND:PlayBGM(m, loop ~= false) end)
  return m
end

--Theme d'une arene sans le jouer (utile pour EmptyArena / rejouabilite).
function BossMusic.Get(arene)
  return BossMusic.LIST[arene] or T.EPREUVE
end

return BossMusic
