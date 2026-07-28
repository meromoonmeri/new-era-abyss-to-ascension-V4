--[[ Canyon des Voix Eteintes — le Veilleur (Reseau des Anciens Chemins).

     Ground pmd-red importe 1:1 (D07P01 Great Canyon) : geometrie intouchee,
     casting et dialogues 100 % New Era.

     ------------------------------------------------------------------
     POURQUOI UN XATU ICI
     ------------------------------------------------------------------
     Dans les jeux d'origine, un Xatu se tient au bout du Grand Canyon. Sa
     fonction dramatique n'est pas de donner une information : c'est d'etre
     UN TEMOIN QUI SE TAIT. Il voit, il sait, et il refuse. Le joueur repart
     avec moins de reponses qu'en arrivant — et c'est le but.

     C'est cette FONCTION qu'on reprend, pas la scene. Ici :

       * le lieu s'appelle deja « Canyon des Voix Eteintes » (nom FR de
         new_era_zone_07) et la scene precedente disait deja que le canyon
         ne renvoie aucun echo. Le Veilleur EXPLIQUE pourquoi : ce n'est pas
         une curiosite geologique, c'est lui qui absorbe les voix.
       * il est le premier personnage EXTERIEUR a l'intrigue qui percoit la
         Voix du heros. Jusqu'ici, seuls le heros (et le joueur) savaient.
         Un tiers le confirme : ce n'est pas une hallucination.
       * il ne nomme rien. Aucun nom interdit, aucune revelation. Il donne
         une METHODE (« ne demande pas quoi, demande depuis quand »), ce qui
         relance la quete sans la resoudre.

     Placement : fin de new_era_zone_07, a la premiere victoire seulement
     (SV.Reseau.VoiesOuvertes). Cadre naturellement dans l'add-on Reseau, et
     compatible avec le Livre II (ch11+) ou la zone se debloque.

     ------------------------------------------------------------------
     TECHNIQUE
     ------------------------------------------------------------------
     Apparition par flash blanc (patron BossFX du mod), pas d'animation
     exotique. Sortie garantie en fin de scene ET en cas de rejeu : jamais
     de blocage. Corps sous pcall.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.VoiceVisions'
require 'halcyon.BossFX'

local grand_canyon_porte = {}

local function sortie()
  GAME:FadeOut(false, 40)
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 1, 0, true, true)
end

function grand_canyon_porte.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_grand_canyon_porte")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

local function Scene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  -- POSITIONS LUES DANS Data/Ground/grand_canyon_porte.rsground.
  -- Carte reelle : 456 x 240 px — lue dans `obstacles`, indexe [x][y].
  -- (Se fier a Layers[0].Tiles donne 240x456, soit les dimensions INVERSEES.
  --  Verifie sur les 269 cartes du depot : la lecture [x][y] produit 5
  --  ancrages aberrants contre 147 pour [y][x].)
  --   Main_Entrance_Marker  (208, 232)   <- point d'entree officiel
  --   TEAMMATE_1 spawner    (256, 232)   <- place prevue du partenaire
  --   Cutscene_Marker       (240, 120)   <- cadrage prevu pour la scene
  GROUND:TeleportTo(hero, 208, 232, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 256, 232, Direction.Up) end
  -- Camera cadree sur le Cutscene_Marker, entre le duo (y=232) et l'eperon
  -- rocheux ou se tient le Veilleur (y=120).
  GAME:MoveCamera(240, 176, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  local function say(emo, txt)
    if partner == nil then return end
    UI:SetSpeaker(partner); UI:SetSpeakerEmotion(emo)
    UI:WaitShowDialogue(txt); GAME:WaitFrames(10)
  end
  local function narrate(txt)
    UI:ResetSpeaker(false); UI:SetCenter(true)
    UI:WaitShowDialogue(txt); UI:SetCenter(false); GAME:WaitFrames(10)
  end
  local function think(emo, txt)
    GeneralFunctions.HeroDialogue(hero, txt, emo); GAME:WaitFrames(10)
  end

  ------------------------------------------------------------------
  -- 1. Le lieu, avant le personnage (regle tiree de EoSO/beach).
  ------------------------------------------------------------------
  say("Normal", "Quelle vue...[pause=20] On voit le canyon sur des lieues.")
  narrate("Le vent s'engouffre entre les parois sans produire le moindre écho.")
  say("Worried", "C'est ça qui me dérange depuis tout à l'heure.[pause=25] Un canyon devrait renvoyer chaque mot.")
  think("Worried", "(J'ai crié tout à l'heure, en tombant.[pause=25] Je ne me suis même pas entendu.)")
  GAME:WaitFrames(15)

  ------------------------------------------------------------------
  -- 2. Le Veilleur. Il etait deja la — il n'arrive pas.
  ------------------------------------------------------------------
  narrate("Sur l'éperon rocheux, en face,[pause=20] une silhouette immobile.[pause=25] Elle ne s'est pas posée : elle était là.")
  -- Le Veilleur se tient exactement sur le Cutscene_Marker (240,120) :
  -- l'eperon rocheux que ce marqueur designe, bien dans la carte de 456x240.
  local xatu = CharacterEssentials.MakeCharactersFromList({{'Canyon_Xatu', 240, 120, Direction.Down}})
  GAME:WaitFrames(20)
  say("Surprised", "Depuis quand est-ce qu'il...[pause=25] Non. Il n'a pas bougé. C'est nous qui ne l'avions pas vu.")
  GAME:WaitFrames(15)

  UI:SetSpeaker(xatu); UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Le canyon ne mange pas vos voix.[pause=30] C'est moi.")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("Je les écoute depuis si longtemps que je les garde.[pause=25] Toutes.[pause=20] Y compris celles qu'on ne devrait pas entendre.")
  GAME:WaitFrames(20)

  ------------------------------------------------------------------
  -- 3. Le basculement : un TIERS confirme la Voix.
  --    C'est la premiere fois de tout le jeu.
  ------------------------------------------------------------------
  UI:SetSpeaker(xatu); UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Toi.[pause=30] Approche.")
  GAME:WaitFrames(15)
  say("Normal", "Moi ?[pause=20] ...Non. Il te regarde, toi.")
  GAME:WaitFrames(15)

  UI:SetSpeaker(xatu)
  UI:WaitShowDialogue("Tu en portes une.[pause=30] Une voix qui n'est pas la tienne,[pause=20] et que personne d'autre n'entend.")
  GAME:WaitFrames(20)

  -- Reaction physique : le heros a mal quand on en parle. Reprend le
  -- dispositif etabli (VoiceVisions.Nausea) au lieu d'une simple replique.
  pcall(function() VoiceVisions.Nausea(hero, 2) end)
  pcall(function() VoiceVisions.Recover(hero) end)
  GAME:WaitFrames(15)

  say("Shock", "Comment vous...[pause=25] Il ne l'a dit à PERSONNE.[pause=20] Même à moi, il ne l'a dit qu'à moitié.")
  GAME:WaitFrames(15)
  UI:SetSpeaker(xatu); UI:SetSpeakerEmotion("Sad")
  UI:WaitShowDialogue("Il ne l'a pas dit.[pause=25] Elle, si.[pause=30] Elle parle fort, pour qui sait écouter le silence.")
  GAME:WaitFrames(20)

  think("Worried", "(Alors ce n'est pas dans ma tête.[pause=30] Quelqu'un d'autre l'entend.[pause=20] Je ne sais pas si je suis soulagé ou terrifié.)")
  GAME:WaitFrames(20)

  ------------------------------------------------------------------
  -- 4. Il refuse de nommer. Il donne une METHODE, pas une reponse.
  ------------------------------------------------------------------
  say("Worried", "Alors dites-nous ![pause=20] Qu'est-ce que c'est ?[pause=25] Qu'est-ce qu'elle veut ?")
  GAME:WaitFrames(15)
  UI:SetSpeaker(xatu); UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Non.")
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("Je vois loin.[pause=25] Assez loin pour savoir que nommer une chose,[pause=20] c'est lui ouvrir la porte.")
  GAME:WaitFrames(20)
  say("Angry", "C'est tout ?![pause=20] Vous nous laissez avec ÇA ?")
  GAME:WaitFrames(15)

  UI:SetSpeaker(xatu); UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Je vous laisse avec mieux qu'une réponse.[pause=30] Une bonne question.")
  GAME:WaitFrames(20)
  -- La replique-pivot : elle relance la quete sans rien resoudre.
  UI:WaitShowDialogue("Vous demandez tous CE QUE c'est.[pause=30] Demandez plutôt DEPUIS QUAND elle lui parle.")
  GAME:WaitFrames(25)

  think("Shock", "(Depuis quand...[pause=30] ...Je ne me souviens pas d'un seul jour sans elle.)")
  GAME:WaitFrames(20)
  say("Sad", "Attends.[pause=25] Tu veux dire que même avant qu'on se rencontre—")
  GAME:WaitFrames(20)

  ------------------------------------------------------------------
  -- 5. Il repart comme il est venu : sans mouvement.
  ------------------------------------------------------------------
  UI:SetSpeaker(xatu); UI:SetSpeakerEmotion("Sad")
  UI:WaitShowDialogue("La voie est ouverte.[pause=25] Passez.[pause=30] Et quand vous reviendrez,[pause=20] rapportez-moi la réponse.")
  GAME:WaitFrames(20)

  SOUND:PlayBattleSE("EVT_Battle_Flash")
  BossFX.Flash(240, 120, 3, 5, 20)
  pcall(function() GROUND:Hide('Canyon_Xatu') end)
  GAME:WaitFrames(25)
  narrate("Il n'est pas parti.[pause=25] Il a simplement cessé d'être visible,[pause=20] comme le reste des voix d'ici.")
  GAME:WaitFrames(15)

  narrate("Deux piliers taillés dans la roche s'éveillent de part et d'autre du passage.")
  say("Normal", "Le Réseau ne traverse pas le canyon...[pause=20] il le franchit.")
  GAME:WaitFrames(12)
  think("Normal", "(Et le gardien de la porte savait qui allait venir.)")
  GAME:WaitFrames(15)
  say("Determined", "Une voie de plus.[pause=25] Et beaucoup plus de questions.")
  GAME:WaitFrames(20)
end

function grand_canyon_porte.Enter(map)
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(Scene)
  if not ok then PrintInfo('[grand_canyon_porte] scene ecourtee : '..tostring(err)) end
  pcall(function()
    UI:ResetSpeaker()
    local partner = CH('Teammate1')
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
  --Sortie garantie, hors du pcall : jamais de blocage sur cette carte.
  sortie()
end

function grand_canyon_porte.Update(map, time) end
function grand_canyon_porte.GameSave(map) end
function grand_canyon_porte.GameLoad(map) end

return grand_canyon_porte
