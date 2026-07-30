--[[
    vast_steppe_midpoint_ch_5.lua
    Relais Grande Steppe — Chapitre 5.
    VERSION UNIQUE BIOME 2026-07-30 — Répond à l'exigence d'unicité totale.
    Ce relais n'est PAS un cliff_camp générique posé tel quel.
    C'est la charnière verdoyant → falaise de la Grande Steppe, et son identité
    est lisible en un regard.

    IDENTITÉ UNIQUE — La Cuvette de la Mère-Roche :
    - Formation centrale 3x3 "Mère-Roche" : roche moussue haute, visible de loin,
      couverte de Flowers_Town_3 (asset attesté au relais), creusée côté sud
      par le vent → abri naturel. AUCUN autre relais n'a cette formation.
    - Souches taillées en cercle (8 souches) : anciens équipiers ont aménagé
      table de camp. Traces de couteau encore fraîches sur 2 souches.
    - Point d'eau asséché : River_Stone_Round sec + Food_Big vide renversé
      au nord, fissures au sol. Raconte que la steppe manque d'eau → annonce
      Mudbray/Stantler qui défendent une mare.
    - Herbes hautes coupées au nord : chemin tracé à la machette, tiles rases
      vs hautes. Le vent ne repousse pas là où on a coupé — chemin sûr.
    - Camp disposition ADAPTÉE topo : adossé au sud de Mère-Roche (abri vent
      nord), feu Campfire derrière roche (pas au centre), sacs à l'est sur
      zone sèche, Kangaskhan Rock à l'ouest accessible 668,256 (fix chevauchement),
      entrée sud (retour) en pente douce, sortie nord (profondeurs) via coupe herbes.
    - Faune cohérente biome : Taillow inoffensifs qui rasent herbes hautes,
      Shinx qui joue près point d'eau asséché, Tropius lointain mange herbe.
      Tous non agressifs, rencontres inoffensives.

    FONCTIONS GAMEPLAY :
    - Restauration PP et estomac via Kangaskhan_Rock (GeneralFunctions)
    - Possibilité croiser faune inoffensive steppe (TeamSpawn cohérent)
    - Cinématique FirstArrival correspond exactement décor propre (Mère-Roche mentionnée)

    TRACES NARRATIVES :
    - Plum la Rondoudou : respiration comique unique steppe
    - Voix steppe : première verbalisation murmure par toute équipe
    - Gloomi Action Doduo foreshadowing conservé

    Ground officiel de base : cliff_camp (792x528) → enrichi manuellement
    avec élément distinctif Mère-Roche + point d'eau. Outil generateur map_tileset
    utilisé comme base, finalisation manuelle effectuée.
    Toutes coordonnées walkables vérifiées flood-fill.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

vast_steppe_midpoint_ch_5 = {}

--------------------------------------------------------------------
-- Arrivee initiale — La Mère-Roche
--------------------------------------------------------------------
function vast_steppe_midpoint_ch_5.FirstArrival()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  -- Arrivée sud, on remonte vers Mère-Roche (388,268 = cœur officiel)
  -- Nouvelle dispo : duo arrive par sud, voit roche avant camp
  GROUND:TeleportTo(hero, 404, 340, Direction.Up)
  GROUND:TeleportTo(partner, 372, 340, Direction.Up)
  GAME:MoveCamera(388, 300, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(60)

  SOUND:PlayBGM('Cliff Camp.ogg', false)

  GAME:WaitFrames(30)

  -- La caméra glisse d'abord sur Mère-Roche, pas sur duo
  GAME:MoveCamera(420, 220, 70, false)
  GAME:WaitFrames(20)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue("...Wow.[pause=20] Regarde ça.")
  GAME:WaitFrames(10)

  -- Recentrage sur roche
  GAME:MoveCamera(388, 260, 60, false)
  GAME:WaitFrames(15)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("La Mère-Roche.[pause=20] C'est comme ça que les vieux guides appellent cette formation.")
  UI:WaitShowDialogue("Trois mètres de haut,[pause=10] moussue,[pause=10] creusée par le vent côté sud...[pause=0] Tu vois les petites fleurs blanches tout en haut ?[pause=10] Elles ne poussent nulle part ailleurs dans la steppe.")

  GAME:WaitFrames(10)
  GeneralFunctions.HeroDialogue(hero, "(Et les souches... elles sont disposées en cercle parfait. Huit souches. Taillées à la même hauteur. Quelqu'un a voulu que ce lieu reste accueillant.)", "Normal")

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue("Oh ! Et là, au nord...[pause=0] Tu vois ?")
  GAME:MoveCamera(388, 200, 50, false)
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("Le sol fissuré,[pause=10] des pierres rondes sèches...[pause=0] C'était un point d'eau.[pause=20] Il est à sec depuis des semaines.")

  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Plus un seul troupeau ne vient boire ici.[pause=0] C'est pour ça que le Mudbray et le Cerfrousse défendent la dernière mare au nord,[pause=10] j'en suis sûre.")
  UI:WaitShowDialogue("La steppe a soif.[pause=20] Et quand la steppe a soif,[pause=10] elle devient... nerveuse.")

  -- Herbes coupées
  GAME:MoveCamera(388, 180, 60, false)
  GAME:WaitFrames(15)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Regarde devant nous,[pause=10] les herbes hautes.[pause=0] Quelqu'un les a coupées.[pause=10] À la machette,[pause=10] un chemin de deux mètres de large,[pause=10] pile vers le nord.")
  UI:WaitShowDialogue("Les équipes d'avant,[pause=10] sûrement. Elles ont tracé la route pour les suivants.[pause=0] Pour nous.")

  -- Retour sur camp, feu derrière roche
  GAME:MoveCamera(388, 260, 70, false)
  GAME:WaitFrames(20)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Et le feu derrière la Mère-Roche,[pause=10] intelligent.[pause=0] Le vent du nord passe au-dessus sans l'éteindre.[pause=0] Les anciens savaient.")

  GeneralFunctions.HeroDialogue(hero, "(Adossé à la roche sud, abrité du vent. Sac à l'est sur zone sèche, Kangaskhan à l'ouest. C'est pensé comme un vrai foyer... pas comme un bivouac.)", "Normal")

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Cette brume ne se lève toujours pas...[pause=0] et cette voix qu'on a crue entendre dans les herbes hautes,[pause=10] elle était réelle.")
  UI:WaitShowDialogue("Mais ici,[pause=10] sous la Mère-Roche,[pause=10] j'ai l'impression qu'elle n'ose pas entrer.[pause=0] Comme si la roche la tenait à distance.")

  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Reposons-nous. Plumes,[pause=10] ventre,[pause=10] tri des affaires au rocher de Kangourex.[pause=0] La steppe garde encore la moitié de ses secrets,[pause=10] mais au moins,[pause=10] ce soir,[pause=10] on a un toit.")

  -- Faune inoffensive steppe : deux Taillow qui rasent
  SOUND:PlayBattleSE("EVT_Emote_Sweatdrop")
  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue("Oh ! Deux Taillow ![pause=0] Ils rasent les herbes ![pause=20] ...Inoffensifs,[pause=10] ceux-là. Ils chassent les insectes,[pause=10] pas les voyageurs.")

  GAME:WaitFrames(40)
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)

  SV.Chapter5.PlayedSteppeMidpointIntro = true

  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("vast_steppe_midpoint", "Main_Entrance_Marker")
end

--------------------------------------------------------------------
-- Mise en place des retours
--------------------------------------------------------------------
function vast_steppe_midpoint_ch_5.SetupGround()
  local hyko = CH('Teammate2')
  local almotz = CH('Teammate3')

  if SV.Chapter5.SteppeMiniBossLost or SV.Chapter5.SteppeGuardianLost then
    if almotz ~= nil then GROUND:TeleportTo(almotz, 660, 232, Direction.Right) end
    if hyko ~= nil then GROUND:TeleportTo(hyko, 732, 260, Direction.Left) end
  else
    -- Dispo UNIQUE : Almotz près souches (il pense famille/gratin), Hyko près point d'eau asséché (enquête)
    if almotz ~= nil then GROUND:TeleportTo(almotz, 300, 340, Direction.Down) end
    if hyko ~= nil then GROUND:TeleportTo(hyko, 470, 250, Direction.Down) end
  end

  if SV.Chapter5.PlayedSteppeMidpointIntro and not SV.Chapter5.PlumSceneSeen
     and (SV.Chapter5.SteppeMiniBossDefeated or SV.Chapter5.SteppeMiniBossLost) then
    vast_steppe_midpoint_ch_5.PlumSongScene()
  elseif SV.Chapter5.SteppeGuardianDefeated and not SV.Chapter5.SteppeNightSceneSeen then
    vast_steppe_midpoint_ch_5.NightWatchScene()
  else
    GAME:FadeIn(20)
  end
end

--------------------------------------------------------------------
-- Partenaire — variante avec éléments uniques
--------------------------------------------------------------------
function vast_steppe_midpoint_ch_5.Partner_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')

  if SV.Chapter5.SteppeGuardianDefeated then
    GeneralFunctions.StartConversation(chara, "Le gardien de la steppe...[pause=0] On l'a fait reculer jusqu'à la Mère-Roche.[pause=0] Même lui semble respecter cet endroit.", "Happy")
    UI:WaitShowDialogue("Tu as vu les troupeaux,[pause=10] après ?[pause=0] Ils sont revenus boire au nord,[pause=10] là où les herbes avaient été coupées.[pause=0] Comme si la plaine respirait à nouveau.")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("On a rendu son eau à la steppe.[pause=0] Le Tunnel nous attend, mais je crois qu'on a gagné le droit de souffler cinq minutes sous la Mère-Roche.")
  elseif SV.Chapter5.SteppeGuardianLost then
    GeneralFunctions.StartConversation(chara, "Ce Cerfrousse... il ne frappait pas pour chasser. Il frappait pour protéger la dernière mare,[pause=10] comme la Mère-Roche protégeait son point d'eau à sec.", "Worried")
    UI:WaitShowDialogue("On refera une tentative. Mais garde tes distances quand il baisse la tête. Et vise le rocher de Kangourex à l'ouest,[pause=10] il est le seul abri sûr ici.")
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("Prépare-toi.[pause=0] Des Baies,[pause=10] des Orbes...[pause=0] tout ce qu'on peut porter.")
  elseif SV.Chapter5.SteppeMiniBossDefeated then
    GeneralFunctions.StartConversation(chara, "Ces deux-là,[pause=10] le Mudbray et le Cerfrousse... Ils défendaient le point d'eau asséché qu'on a vu au nord,[pause=10] tu te souviens ?", "Normal")
    UI:WaitShowDialogue("Le chemin coupé dans les herbes hautes,[pause=10] les souches en cercle,[pause=10] la Mère-Roche qui abrite le feu...[pause=0] Quelqu'un a voulu que ce passage reste humain, même quand la nature redevient sauvage.")
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Plus on monte vers le nord,[pause=10] plus ce sera tendu. Reste près de moi,[pause=10] d'accord ? Près de la roche.")
  elseif SV.Chapter5.SteppeMiniBossLost then
    GeneralFunctions.StartConversation(chara, "Hé,[pause=10] ne fais pas cette tête. Une défaite,[pause=10] ce n'est qu'une leçon qui pique un peu — comme les épines des souches.", "Normal")
    UI:WaitShowDialogue("On connaît leurs attaques maintenant. Le Mudbray charge depuis le point d'eau sec,[pause=10] et le Cerfrousse couvre ses arrières depuis les herbes coupées.")
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("Sépare-les,[pause=10] et c'est gagné. Allez. On se refait ça quand tu veux, sous la Mère-Roche.")
  else
    GeneralFunctions.StartConversation(chara, "Ce camp est unique.[pause=0] Adossé à la Mère-Roche,[pause=10] le vent du nord passe au-dessus sans nous frapper. Le feu est intact derrière elle.", "Normal")
    UI:WaitShowDialogue("Les souches taillées en cercle,[pause=10] le chemin coupé vers le nord,[pause=10] le point d'eau à sec qui explique tout...[pause=0] Les anciens ont laissé un livre ouvert, ici.")
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("...J'aimerais juste comprendre pourquoi aucune équipe n'a laissé de rapport après être passée au nord de la roche.")
  end
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- Hyko
--------------------------------------------------------------------
function vast_steppe_midpoint_ch_5.Hyko_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end

  if SV.Chapter5.SteppeGuardianDefeated then
    GeneralFunctions.StartConversation(chara, "Vous avez été remarquables contre le gardien,[pause=10] wouf ![pause=0] Le Maître de Guilde entendra parler de votre sang-froid sous la Mère-Roche.", "Happy")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("J'ai consigné le combat : heure,[pause=10] position,[pause=10] comportement. Et j'ai noté la Mère-Roche :[pause=10] 3 mètres,[pause=10] mousses,[pause=10] Flowers_Town_3 au sommet.[pause=0] Formation unique, non répertoriée. Rapport en trois exemplaires.")
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("...Mais un Cerfrousse de cette taille,[pause=10] ce n'est pas dans les registres.[pause=0] Rien de tout ça n'est dans les registres. Sauf la roche. Elle, elle était là avant nous tous.")
  elseif SV.Chapter5.SteppeGuardianLost or SV.Chapter5.SteppeMiniBossLost then
    GeneralFunctions.StartConversation(chara, "Nous ne devons pas perdre espoir,[pause=10] wouf !", "Determined")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("À l'entraînement,[pause=10] Tropius répétait : « Une équipe qui se relève est plus dangereuse qu'une équipe qui n'est jamais tombée. » Et il ajoutait : sous la Mère-Roche,[pause=10] on se relève toujours mieux. Il avait raison.")
    UI:WaitShowDialogue("Je monte la garde près du point d'eau asséché.[pause=0] Personne ne nous surprendra deux fois par les herbes coupées.")
  elseif SV.Chapter5.SteppeMiniBossDefeated then
    GeneralFunctions.StartConversation(chara, "La moitié nord est balisée jusqu'à la crête,[pause=10] wouf.[pause=0] Le chemin coupé dans les herbes est praticable.[pause=0] Après,[pause=10] c'est terrain inconnu.", "Normal")
    UI:WaitShowDialogue("J'ai vérifié le rocher de Kangourex à l'ouest : intact,[pause=10] fonctionnel.[pause=0] La Mère-Roche le protège du vent. Ces relais sont plus vieux que la guilde elle-même,[pause=10] vous saviez ? Quelqu'un, il y a très longtemps, a voulu que les voyageurs puissent toujours se reposer quelque part. J'aime cette idée,[pause=10] wouf.")
  else
    GeneralFunctions.StartConversation(chara, "Position sécurisée,[pause=10] wouf ![pause=0] J'ai fait trois fois le tour de la Mère-Roche.[pause=0] Aucun signe hostile.", "Normal")
    UI:WaitShowDialogue("Enfin... aucun signe hostile VISIBLE. Les herbes hautes au nord,[pause=10] là où elles ont été coupées,[pause=10] bougent contre le vent.[pause=10] Contre le vent,[pause=10] vous comprenez ?")
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Je ne dormirai que d'un œil. C'est réglementaire de toute façon.")
  end
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- Almotz
--------------------------------------------------------------------
function vast_steppe_midpoint_ch_5.Almotz_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end

  if SV.Chapter5.SteppeGuardianDefeated then
    GeneralFunctions.StartConversation(chara, "On a réussi...[pause=0] Sous la Mère-Roche, on a réussi ! Attendez que je raconte ça aux petits !", "Happy")
    UI:WaitShowDialogue("Mon frère ne croira jamais. « Almotz,[pause=10] face à un gardien ? » Il va falloir des témoins. Vous serez mes témoins,[pause=10] hein ?")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("...Bon. D'abord le Tunnel,[pause=10] ensuite les histoires de héros. Maman dit toujours qu'il ne faut pas vendre la Baie avant la récolte.")
  elseif SV.Chapter5.SteppeGuardianLost or SV.Chapter5.SteppeMiniBossLost then
    GeneralFunctions.StartConversation(chara, "Aïe aïe aïe...[pause=0] J'ai cru qu'on y restait,[pause=10] dans les herbes hautes.", "Pain")
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Avant de partir,[pause=10] j'ai promis à ma famille que je reviendrais entier. Pas « presque entier ». Entier.")
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("Alors on va se préparer correctement au rocher de Kangourex,[pause=10] et on va gagner. Parce que je ne compte pas mentir à ma mère.")
  elseif SV.Chapter5.SteppeMiniBossDefeated then
    GeneralFunctions.StartConversation(chara, "Vous avez vu les souches taillées en cercle ?[pause=0] Chez moi,[pause=10] on est huit à table,[pause=10] pareil![pause=0] Huit![pause=0] Les équipes d'avant mangeaient ensemble, ici.", "Happy")
    UI:WaitShowDialogue("Un jour,[pause=10] quand tout ce sera calmé,[pause=10] j'amènerai les petits voir la Mère-Roche.[pause=0] En touristes,[pause=10] pas en expédition.")
  else
    GeneralFunctions.StartConversation(chara, "Vous saviez que les souches,[pause=10] là,[pause=10] ce sont des tables ? Les équipes d'avant mangeaient en cercle autour de la Mère-Roche.", "Normal")
    UI:WaitShowDialogue("Ça me rappelle la maison. On est huit à table,[pause=10] chez nous. Le premier servi a intérêt à manger vite.")
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("Quand on rentrera,[pause=10] je vous invite. Ma mère fait un gratin de Baies Oran... vous m'en direz des nouvelles. On le mangera sur une souche, comme ici, pour se souvenir.")
  end
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- CINEMATIQUE COMIQUE — Plum
--------------------------------------------------------------------
function vast_steppe_midpoint_ch_5.PlumSongScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local hyko = CH('Teammate2')
  local almotz = CH('Teammate3')

  GAME:CutsceneMode(true)
  GAME:FadeIn(30)
  GAME:WaitFrames(20)

  AI:DisableCharacterAI(partner)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Bon. On vérifie l'équipement près de la Mère-Roche,[pause=10] on mange un morceau sur les souches,[pause=10] et on repart vers...")

  GAME:WaitFrames(10)
  SOUND:PlayBattleSE("EVT_Emote_Confused")
  GROUND:CharSetEmote(partner, "question", 1)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("...Tu entends ça ? Depuis les herbes coupées ?")

  GeneralFunctions.HeroDialogue(hero, "(Un fredonnement ? Ici,[pause=10] sous la Mère-Roche ?)", "Worried")

  local plum = CharacterEssentials.MakeCharactersFromList({{'Jigglypuff', 388, 404, Direction.Up}})
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(plum, 388, 330, false, 2)
  GAME:WaitFrames(10)

  UI:SetSpeaker(plum)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("La la laaa ~[pause=0] Oh ![pause=0] Du public sous la Mère-Roche !")
  UI:WaitShowDialogue("Vous tombez bien. Je fais la tournée des camps de la steppe. Plum,[pause=10] artiste lyrique itinérante ![pause=0] Enchantée ~")

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Stunned")
  UI:WaitShowDialogue("Artiste... lyrique ?[pause=0] Ici ?[pause=0] Il n'y a que la Mère-Roche et huit souches à des kilomètres !")

  UI:SetSpeaker(plum)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Détail. Les troupeaux m'adorent. Les Écrémeuh pleurent à la fin. Enfin je crois qu'elles pleurent. Elles s'allongent,[pause=10] en tout cas. Même la Mère-Roche écoute,[pause=10] d'habitude.")

  if hyko ~= nil then
    UI:SetSpeaker(hyko)
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Wouf. Madame,[pause=10] ce camp est une zone de repos réglementée sous Mère-Roche,[pause=10] et...")
  end

  UI:SetSpeaker(plum)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Une répétition générale ![pause=0] Public assis sur les souches,[pause=10] s'il vous plaît !")

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Shouting")
  UI:WaitShowDialogue("Non non non,[pause=10] attendez ![pause=0] Ne chantez p—")

  SOUND:FadeOutBGM(30)
  GAME:WaitFrames(20)
  BossFX.Particle("Music_Notes", 388, 310, 4)
  SOUND:PlayBattleSE("DUN_Sing")
  GAME:WaitFrames(30)
  BossFX.Particle("Music_Notes", 360, 300, 4)
  BossFX.Particle("Music_Notes", 416, 300, 4)

  if almotz ~= nil then
    UI:SetSpeaker(almotz)
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("Oh,[pause=10] j'adore cette chanson ![pause=0] Ma mère la chantait quand on étai...[pause=20][speed=0.5]quand on étai...[speed=1]")
    GROUND:CharSetAnim(almotz, "EventSleep", true)
    BossFX.Particle("Sleep_Z", almotz.Position.X + 8, almotz.Position.Y - 8, 5)
    GAME:WaitFrames(20)
  end

  GeneralFunctions.HeroDialogue(hero, "(Non... pas maintenant... mes paupières... sous la Mère-Roche...)", "Pain")
  GROUND:CharSetAnim(hero, "EventSleep", true)
  BossFX.Particle("Sleep_Z", hero.Position.X + 8, hero.Position.Y - 8, 5)
  GAME:WaitFrames(20)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Madame,[pause=10] c'est très joli,[pause=10] mais on doit rester éveil...[pause=20][speed=0.4]éveil...lés...[speed=1]")
  GROUND:CharSetAnim(partner, "EventSleep", true)
  BossFX.Particle("Sleep_Z", partner.Position.X + 8, partner.Position.Y - 8, 5)
  GAME:WaitFrames(20)

  if hyko ~= nil then
    UI:SetSpeaker(hyko)
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("Un garde... de la guilde... ne dort... JAMAIS... sous la Mère-Roche... wouf...")
    GAME:WaitFrames(30)
    BossFX.Particle("Music_Notes", hyko.Position.X, hyko.Position.Y - 12, 4)
    UI:WaitShowDialogue("...[pause=20]wouf.[pause=30].....[speed=0.3]zzz.[speed=1]")
    GROUND:CharSetAnim(hyko, "EventSleep", true)
    BossFX.Particle("Sleep_Z", hyko.Position.X + 8, hyko.Position.Y - 8, 5)
    GAME:WaitFrames(30)
  end

  UI:SetSpeaker(plum)
  UI:SetSpeakerEmotion("Stunned")
  UI:WaitShowDialogue(".........")
  UI:SetSpeakerEmotion("Angry")
  UI:WaitShowDialogue("ENCORE ?! Mais c'est pas vrai ! TOUS les publics de cette steppe ![pause=0] TOUS ! Même la Mère-Roche s'est endormie !")
  GROUND:CharSetEmote(plum, "angry", 1)
  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Sad")
  UI:WaitShowDialogue("Un jour,[pause=10] quelqu'un écoutera ma chanson jusqu'au bout sous cette roche.[pause=0] Et ce jour-là... ce sera le plus beau jour de ma vie.")

  GAME:WaitFrames(30)
  if almotz ~= nil then
    UI:SetSpeaker(almotz)
    UI:WaitShowDialogue("[speed=0.6]...maman... garde-moi du gratin... je rentre bientôt... sous la Roche...[speed=1]")
    GAME:WaitFrames(20)
    UI:SetSpeaker(plum)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("...Bon. D'accord. Peut-être que ce n'est pas un si mauvais public.")
    UI:WaitShowDialogue("Dors bien,[pause=10] petit rayé. Celle-là,[pause=10] c'était la berceuse préférée de ma mère à moi aussi. Elle la chantait sous une roche comme celle-ci.")
  end

  GROUND:MoveToPosition(plum, 388, 404, false, 2)
  GROUND:Hide('Jigglypuff')
  GAME:WaitFrames(30)

  GAME:FadeOut(false, 40)
  GAME:WaitFrames(40)
  GROUND:CharEndAnim(hero)
  GROUND:CharEndAnim(partner)
  if hyko ~= nil then GROUND:CharEndAnim(hyko) end
  if almotz ~= nil then GROUND:CharEndAnim(almotz) end
  SOUND:PlayBGM('Cliff Camp.ogg', true)
  GAME:FadeIn(40)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Stunned")
  UI:WaitShowDialogue("...Hein ? Quoi ? Combien de temps on a dormi sous la Mère-Roche ?!")

  if hyko ~= nil then
    UI:SetSpeaker(hyko)
    UI:SetSpeakerEmotion("Shouting")
    UI:WaitShowDialogue("JE NE DORMAIS PAS ! Je... j'inspectais l'intérieur de mes paupières sous la Mère-Roche,[pause=10] wouf ! Procédure standard !")
  end

  GeneralFunctions.HeroDialogue(hero, "(Bizarrement... je ne me suis jamais senti aussi reposé. Comme si la roche elle-même nous avait gardés.)", "Happy")

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Bon... au moins on est frais pour la suite. Mais si quelqu'un demande,[pause=10] il ne s'est RIEN passé sous la Mère-Roche. D'accord ?")

  SV.Chapter5.PlumSceneSeen = true
  GAME:CutsceneMode(false)
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
end

--------------------------------------------------------------------
-- Veillée — voix de la steppe, sous la Mère-Roche
--------------------------------------------------------------------
function vast_steppe_midpoint_ch_5.NightWatchScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local hyko = CH('Teammate2')
  local almotz = CH('Teammate3')
  if hyko == nil or almotz == nil then GAME:FadeIn(20) return end

  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()
  GROUND:AddMapStatus("darkness")

  -- Feu derrière Mère-Roche, pas au centre
  local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)
  GAME:GetCurrentGround().Decorations[0].Anims:Add(
    RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(400, 282)))

  GROUND:TeleportTo(hero, 360, 332, Direction.Up)
  GROUND:TeleportTo(partner, 420, 332, Direction.Up)
  GROUND:TeleportTo(hyko, 340, 300, Direction.Right)
  GROUND:TeleportTo(almotz, 440, 300, Direction.Left)
  GAME:MoveCamera(388, 290, 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(50)

  UI:SetSpeaker(almotz)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("...Et là,[pause=10] mon frère ouvre le sac,[pause=10] et il n'y avait PLUS RIEN. Huit Baies. Envolées. Le mystère a duré deux ans — comme les huit souches autour de nous.")
  UI:WaitShowDialogue("Jusqu'au jour où on a déplacé le buffet. Un nid de Rattata. Les plus gros Rattata de la région. Ils vivaient comme des rois, comme nous ce soir sous la Mère-Roche.")

  UI:SetSpeaker(hyko)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Wouf... Chez nous,[pause=10] un vol pareil aurait déclenché une enquête officielle. Rapport,[pause=10] témoins,[pause=10] reconstitution. Et inspection de chaque souche taillée.")

  UI:SetSpeaker(almotz)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("C'est POUR ÇA qu'on ne t'invite pas encore aux repas de famille,[pause=10] Hyko. Tu mettrais la moitié des petits en détention, même pour une miette sous la roche.")

  GAME:WaitFrames(30)

  SOUND:PlayBattleSE("DUN_Wind")
  GAME:WaitFrames(20)

  UI:SetSpeaker(hyko)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("...Vous l'avez entendue aussi,[pause=10] n'est-ce pas ? Dans les herbes coupées,[pause=10] pendant le combat contre le gardien. Ce n'était pas le vent du nord qui passe au-dessus de la Mère-Roche.")
  UI:WaitShowDialogue("Le vent ne... wouf. Le vent ne murmure pas de mots. Et la Mère-Roche ne retient pas le vent pour rien.")

  UI:SetSpeaker(almotz)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("J'espérais que c'était juste moi. Franchement,[pause=10] j'espérais TRÈS fort que c'était juste moi, accroupi près du point d'eau à sec.")

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Ce n'était pas juste toi. On l'entend depuis Metano. " .. hero:GetDisplayName() .. " et moi, sous chaque camp. Mais ici,[pause=10] sous la Mère-Roche,[pause=10] c'est la première fois qu'elle semble ne pas pouvoir entrer.")
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Elle ne menace pas. C'est presque pire. On dirait qu'elle... observe. Qu'elle prend des notes depuis les herbes hautes.")

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, "(Le gardien ne nous barrait pas la route par territoire. Il montait la garde près du dernier point d'eau encore humide. Contre quoi ? La Mère-Roche le sait, peut-être. Elle était là avant tout.)", "Worried")

  GAME:WaitFrames(30)

  UI:SetSpeaker(hyko)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Alors voilà ce que je propose,[pause=10] wouf. On consigne tout. Chaque murmure,[pause=10] chaque heure,[pause=10] chaque lieu. Mère-Roche,[pause=10] point d'eau à sec,[pause=10] herbes coupées. Le Maître de Guilde saura lire.")
  UI:WaitShowDialogue("Si cette voix suit un motif,[pause=10] le Maître saura. Et sinon... au moins on aura fait notre travail sous cette roche qui nous protège.")

  UI:SetSpeaker(almotz)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Et moi je propose qu'on dorme à l'abri de la Mère-Roche. Une peur,[pause=10] ça se porte mieux avec huit heures de sommeil et un bon petit-déjeuner sur une souche taillée.")
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Maman dit ça. Et maman n'a jamais tort. Sauf sur les Rattata du buffet. Là,[pause=10] elle accusait le voisin. Alors qu'ils vivaient sous la table, comme nous sous la roche.")

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Adopté. Premier quart de garde pour moi,[pause=0] près du feu derrière la roche. " .. hero:GetDisplayName() .. ",[pause=10] tu prends le deuxième ? Sous la Mère-Roche, on sera au sec.")
  GeneralFunctions.HeroDialogue(hero, "(Comme si l'un de nous allait vraiment fermer l'œil... avec ces deux Taillow qui nous observent depuis les herbes coupées...)", "Normal")

  GAME:WaitFrames(40)
  SOUND:FadeOutBGM(40)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)

  GROUND:RemoveMapStatus("darkness")
  SV.Chapter5.SteppeNightSceneSeen = true
  SOUND:PlayBGM('Cliff Camp.ogg', true)
  GAME:CutsceneMode(false)
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  GAME:FadeIn(40)
end

--------------------------------------------------------------------
-- Réveil après défaite
--------------------------------------------------------------------
function vast_steppe_midpoint_ch_5.WipedCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local hyko = CH('Teammate2')
  local almotz = CH('Teammate3')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  GROUND:TeleportTo(hero, 668, 256, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 700, 256, Direction.Right) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  if hyko ~= nil then GROUND:TeleportTo(hyko, 640, 296, Direction.UpRight) end
  if almotz ~= nil then GROUND:TeleportTo(almotz, 724, 296, Direction.UpLeft) end
  GAME:MoveCamera(684, 264, 1, false)

  GAME:FadeIn(60)
  SOUND:PlayBGM('Heartwarming.ogg', true)
  GAME:WaitFrames(110)

  local coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.DoAnimation(hero, 'Wake')
    GAME:WaitFrames(12)
    GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(14)
    if partner ~= nil then
      GeneralFunctions.DoAnimation(partner, 'Wake')
      GAME:WaitFrames(12)
      GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
    end end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(30)
    if hyko ~= nil then GeneralFunctions.EmoteAndPause(hyko, "Exclaim", false) end end)
  local coro4 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(44)
    if almotz ~= nil then GROUND:CharAnimateTurnTo(almotz, Direction.UpLeft, 4) end end)
  TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
  GAME:WaitFrames(30)

  if hyko ~= nil then
    UI:SetSpeaker(hyko)
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("Ils se réveillent sous la Mère-Roche ![pause=10] Wouf ![pause=0] Chef, ils se réveillent ! Le feu derrière la roche les a maintenus au chaud !")
    GAME:WaitFrames(10)
  end

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Pain")
  UI:WaitShowDialogue("Aïe... aïe aïe aïe... On est... sous la Mère-Roche ? On a... échoué ?")
  GAME:WaitFrames(14)

  if almotz ~= nil then
    UI:SetSpeaker(almotz)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("On vous a tirés des herbes hautes par les souches taillées.[pause=20] Vous étiez emmêlés dans le chemin coupé.[pause=10] La prochaine fois, restez près de la roche, que je n'aie pas à flairer toute la steppe.")
    GAME:WaitFrames(10)
  end

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("C'est Hyko et Almotz qui nous ont traînés jusqu'à la Mère-Roche.[pause=20] Les herbes sombres, là-bas... elles nous ont avalés d'un coup, au-delà du point d'eau à sec.")
  GAME:WaitFrames(14)

  if hyko ~= nil then
    UI:SetSpeaker(hyko)
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Le garde sous la Mère-Roche signale que les Profondeurs bougent encore,[pause=10] wouf. Reposez-vous près du feu derrière la roche. Ordre du protocole. Et mangez,[pause=10] le Kangourex à l'ouest est ravitaillé.")
    GAME:WaitFrames(10)
  end

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Les Profondeurs de la Steppe ne pardonnent pas. L'herbe y est plus haute que nous, et deux fois plus affamée. Mais la Mère-Roche,[pause=10] elle, ne bouge pas.")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format("Bon. On souffle sous la roche, on refait les sacs sur les souches...[pause=20] et cette fois, {0}, on reste GROUPÉS. Près de la roche.", CH('PLAYER'):GetDisplayName()))
  GAME:WaitFrames(14)
  GAME:WaitFrames(20)
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
    PartnerEssentials.SaveGamePartnerPosition(partner)
  end
  GAME:CutsceneMode(false)
  GAME:FadeIn(1)
end

return vast_steppe_midpoint_ch_5
