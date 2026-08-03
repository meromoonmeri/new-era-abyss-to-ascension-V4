--[[
    AubeFinale.lua

    CINEMATIQUE DE FIN DU CHAPITRE 5 — LE LEVER DE SOLEIL
    ================================================================
    Apres Regigigas, l'expedition sort des Ruines Tordues. Le jour se
    leve sur la prairie. Chaque membre de la guilde commente, avec sa
    voix propre : c'est le bilan de l'expedition, vu par huit
    caracteres differents.

    ------------------------------------------------------------------
    DISPOSITIF
    ------------------------------------------------------------------
    Fond plein ecran 'Aube_Finale' : planche 1280x960, frames 320x240,
    16 frames, verifie CONFORME par tools/verify_bg_format.py. Le
    viewport PMDO fait 320x240 : une frame plus petite donnerait des
    bandes noires (HeroVisions.lua:36).

    Le fond est un FLIPBOOK : UI:WaitShowBG lance l'animation et rend
    la main. Les repliques defilent PENDANT que le jour se leve. Le
    cycle complet dure 16 frames ; on tient le fond assez longtemps
    pour que le joueur voie la nuit reculer.

    Quatre calques de profondeur ont ete animes separement dans le
    fond : ciel, prairie lointaine, collines, avant-plan. La lumiere
    gagne le fond AVANT l'avant-plan — c'est ce decalage qui donne
    l'impression d'un vrai lever de soleil.

    ------------------------------------------------------------------
    REGLES DU PROJET RESPECTEES
    ------------------------------------------------------------------
    * Le heros ne parle jamais a voix haute : ses lignes sont des
      PENSEES entre parentheses (GeneralFunctions.HeroDialogue).
    * Repliques courtes, moins de 150 caracteres hors [pause=N].
    * Aucun nom interdit avant l'arc 6.
    * Emotions de portrait valides uniquement.
    * Toute la scene sous pcall, sortie garantie.
    * Texte LITTERAL : ce module est appele depuis un ground, mais les
      cles STRINGS.MapStrings ne contiennent que celles du ground
      courant. Un texte en dur est donc le seul moyen sur.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

AubeFinale = {}

-- Les huit voix de la guilde, dans l'ordre ou elles prennent la parole.
-- L'ordre n'est pas neutre : on commence par les plus bavards, on
-- finit par les deux qui portent le sens (Phileas, puis Penticus).
AubeFinale.VOIX = {
  { esp='Snubbull',   nom='Coco',     emo='Joyous',
    txt="Regardez-moi ça ![pause=15] J'ai marché toute la nuit et c'est MAINTENANT que je me réveille." },
  { esp='Zigzagoon',  nom='Almotz',   emo='Happy',
    txt="Ma mère va pas me croire.[pause=20] Faudra que quelqu'un vienne le raconter avec moi." },
  { esp='Growlithe',  nom='Hyko',     emo='Normal',
    txt="J'ai tenu le périmètre trois nuits.[pause=20] Je crois que je peux dormir, maintenant." },
  { esp='Audino',     nom='Rin',      emo='Happy',
    txt="Plus une seule blessure à soigner.[pause=15] C'est la première fois depuis le départ." },
  { esp='Breloom',    nom='Kino',     emo='Determined',
    txt="On a vu le fond des Ruines.[pause=20] Peu d'équipes peuvent en dire autant." },
  { esp='Girafarig',  nom='Reinier',  emo='Normal',
    txt="J'ai tout noté.[pause=15] Chaque salle, chaque gravure.[pause=20] Il faudra des mois pour les lire." },
  { esp='Noctowl',    nom='Phileas',  emo='Worried',
    txt="Le Cœur bat de nouveau.[pause=25] Mais quelque chose, là-dessous, m'échappe encore." },
  { esp='Tropius',    nom='Penticus', emo='Inspired',
    txt="Alors on cherchera.[pause=20] C'est ce que fait une guilde.[pause=15] Après le petit-déjeuner." },
}

--------------------------------------------------------------------
-- Joue la scene. `hero` et `partner` peuvent etre nil : la scene
-- s'adapte plutot que de casser.
--------------------------------------------------------------------
function AubeFinale.Play(hero, partner)
  hero = hero or CH('PLAYER')
  partner = partner or CH('Teammate1')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end

    --Fondu d'entree : on quitte la carte precedente.
    GAME:FadeOut(false, 40)
    GAME:WaitFrames(20)
    SOUND:FadeOutBGM(40)
    GAME:WaitFrames(30)

    --LE FOND PREND TOUT L'ECRAN. WaitShowBG lance le flipbook et rend
    --la main : les repliques defilent par-dessus, pendant que le jour
    --se leve derriere elles.
    pcall(function() UI:WaitShowBG('Aube_Finale', 40, 30) end)
    pcall(function() SOUND:PlayBGM('Heartwarming.ogg', true) end)
    GAME:WaitFrames(90)

    --Narration d'ouverture, centree, sans locuteur.
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue("Les Ruines sont derrière eux.[pause=30] Devant, la plaine n'en finit pas.")
    UI:WaitShowDialogue("Et le jour se lève.")
    UI:SetCenter(false)
    GAME:WaitFrames(40)

    --Les huit voix. Chaque membre parle avec son portrait.
    for _, v in ipairs(AubeFinale.VOIX) do
      --Le portrait est demande par ESPECE. Les usages attestes du mod
      --passent chara.CurrentForm.Species (une valeur du moteur), pas une
      --chaine. On cree donc le personnage hors champ pour recuperer sa
      --forme reelle, puis on le retire : c'est le seul moyen sur
      --d'obtenir un portrait correct sans inventer d'API.
      pcall(function()
        local c = CharacterEssentials.MakeCharactersFromList({{v.esp, -64, -64, Direction.Down}})
        if c ~= nil then
          pcall(function() GROUND:Hide(c.EntName) end)
          UI:SetSpeaker(v.nom, true, c.CurrentForm.Species, c.CurrentForm.Form,
                        c.CurrentForm.Skin, c.CurrentForm.Gender)
          GeneralFunctions.SetEmotion(v.emo)
          UI:WaitShowDialogue(v.txt)
          pcall(function() GAME:GetCurrentGround():RemoveTempChar(c) end)
        end
      end)
      GAME:WaitFrames(14)
    end

    --La pensee du heros ferme la scene : il ne parle jamais a voix
    --haute (regle du projet).
    GAME:WaitFrames(20)
    GeneralFunctions.HeroDialogue(hero,
      "(On a rendu son souffle à un Cœur.[pause=25] Et le soleil s'est levé quand même.)", "Normal")
    GAME:WaitFrames(30)

    --Le partenaire a le dernier mot : c'est lui qui ouvre la suite.
    if partner ~= nil then
      UI:SetSpeaker(partner)
      GeneralFunctions.SetEmotion("Determined")
      UI:WaitShowDialogue("Rentrons.[pause=20] On a une expédition à terminer.")
    end
    GAME:WaitFrames(40)

    --Fondu de sortie.
    pcall(function() UI:WaitHideBG(30) end)
    GAME:WaitFrames(20)
  end)

  if not ok then
    PrintInfo('[AubeFinale] scene ecourtee : ' .. tostring(err))
  end

  --SORTIE GARANTIE : le joueur reprend la main quoi qu'il arrive.
  pcall(function() UI:WaitHideBG(1) end)
  pcall(function()
    UI:ResetSpeaker()
    UI:SetCenter(false)
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
    GAME:FadeIn(30)
  end)
  return true
end

return AubeFinale
