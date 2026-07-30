--[[
    init.lua
    Carte : hero_dream — LE REVE DU HEROS (chapitre 5, nuit du Mont Venteux)
    ------------------------------------------------------------------
    CARTE DEDIEE, et voici pourquoi.

    Le reve se jouait auparavant SUR la carte du camp, en superposant un
    overlay au bivouac endormi. Deux problemes structurels, tous deux
    constates en jeu :

      1. L'overlay etait cull par le moteur. OverlayEmitter.cs:83 cree
         son OverlayAnim avec omnipresent = false ; GetDrawSize() rend
         alors Loc(TileSize) = 24x24, et BaseScene.IterateRelevantDraw ne
         dessine que si ce rectangle touche le ViewRect. Un overlay pose
         en (0,0) alors que la camera cadre le camp disparait purement et
         simplement du rendu.
      2. Meme visible, il fallait masquer douze dormeurs, un feu, onze
         paillasses et une falaise. On empilait des couches pour cacher
         un decor qui n'avait rien a faire la.

    Sur une carte dediee, le decor onirique n'est plus un overlay : c'est
    le FOND DE CARTE (Background.Layers de type LayeredBG). C'est
    exactement ce que fait le test de personnalite du jeu d'origine,
    Data/Ground/personality_test.rsground, dont ce .rsground est une
    copie structurelle : deux planches Dream_Back (alpha 255, derive
    +30) et Dream_Front (alpha 128, derive -30) qui glissent en sens
    CONTRAIRES. Le croisement des deux derives EST la profondeur
    onirique que le joueur reconnait.

    Le moteur dessine ce fond avant tout le reste, sans condition de
    culling. Il ne peut donc pas disparaitre.

    Carte de 320x240 px : un ecran pile. Sol entierement libre (Tags=0
    partout) — dans un reve, rien ne bloque. Marqueur unique au centre
    exact (152,112).
]]--
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

local hero_dream = {}

-- Map Callbacks
function hero_dream.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_hero_dream <<=')

  --L'ECRAN EST NOIR AVANT LE PREMIER RENDU.
  --Le moteur ne pose aucun fondu entre deux cartes : moveToZoneInit
  --commente explicitement « no fade; the script handles that itself ».
  --Ce que le script precedent a laisse a l'ecran y reste. Sans ce
  --FadeOut, le joueur verrait le ciel de reve apparaitre d'un coup,
  --avec la camera en train de sauter a sa place. Instantane et
  --idempotent : si l'ecran est deja noir, il ne se passe rien.
  pcall(function() GAME:FadeOut(false, 1) end)

  -- LE JOUEUR DOIT EXISTER SUR LA CARTE.
  COMMON.RespawnAllies()

  -- LE MODE CINEMATIQUE EST POSE DES L'INIT, PAS DANS LA SCENE.
  --     if (GameManager.Instance.SceneOutcome == null)
  --         yield return ... ZoneManager.Instance.CurrentGround.OnCheck();
  -- `CurrentGround` y est nul. Il l'est parce que la bascule de carte
  -- SetPlayerChar(null) puis SetCurrentMap(SegLoc.Invalid) — et
  -- SetCurrentMap appelle exitMap(), qui pose CurrentGround = null
  -- Ce que ProcessInput ne fait PAS quand le mode cinematique est actif :
  -- la garde `if (DataManager.Instance.Save.CutsceneMode) yield break;`
  -- n'atteigne OnCheck. Mode cinematique actif = aucun risque.
  -- Or DreamScene ne posait CutsceneMode(true) qu'apres son test
  -- `if hero == nil`, donc APRES Init et APRES le premier tour de boucle
  -- possible. Entre l'Init de cette carte et le Enter qui lance la
  -- scene, la boucle principale peut tourner (ScreenMainCoroutine
  -- l.505-507 appelle ProcessInput tant que SceneOutcome est nul), et
  -- elle tombe alors sur un CurrentGround en cours de remplacement.
  -- On le pose donc ICI, comme le fait la carte dont hero_dream est
  -- copie : personality_test/init.lua:86 ouvre CharacterSelect par
  -- GAME:CutsceneMode(true). C'est le patron atteste du depot.
  -- DreamScene le repose (idempotent, simple booleen de sauvegarde —
  pcall(function() GAME:CutsceneMode(true) end)
end

function hero_dream.Enter(map)
  hero_dream.DreamScene()
end

function hero_dream.Exit(map) end
function hero_dream.Update(map) end
function hero_dream.GameSave(map) end

function hero_dream.GameLoad(map)
  --Sauvegarder PENDANT le reve ne devrait pas arriver (CutsceneMode est
  --actif du debut a la fin), mais si un joueur y parvient, on ne le
  --laisse pas coince dans un decor sans sortie : on rejoue la scene.
  hero_dream.DreamScene()
end

-- LA SCENE
-- Structure en huit temps, relevee dans pret/pmd-red
-- (src/data/ground/ground_data_a01p01_station.h, les reves successifs
-- du heros). L'ordre du jeu d'origine EST l'effet :
--   1. Trois boites de points de plus en plus longues. Personne ne
--      parle : c'est le dormeur qui remonte vers la surface.
--   2. La desorientation vient AVANT toute presence.
--   3. La boite se FERME. Un vrai silence, pas un blanc.
--   4. La presence est APERCUE avant d'etre entendue.
--   5. L'oubli est pose des le premier reve.
--   6. L'entite parle. Phrases courtes, beaucoup de suspension.
--   7. Le heros pose LA question : « pourquoi mes reves ? »
--   8. « Le jour se leve », puis le reveil et l'oubli.
-- MISE EN SCENE. Une cinematique de Donjon Mystere ne se joue pas en
-- enchainant des boites. Chaque replique de cette scene est portee par
-- au moins un element non textuel :
--   * le heros DORT au centre et ne se leve jamais — il reve ;
--   * la camera respire (derives de 6 a 12 px sur 90 a 180 frames), et
--     ne quitte JAMAIS le heros du cadre ;
--   * l'entite apparait par CLIGNOTEMENT (Absent -> Transparent ->
--     visible), jamais d'un coup ;
--   * les silences sont ecrits comme des repliques : WaitFrames longs,
--     boite fermee, rien a l'ecran que le ciel qui derive.

--Helper local : la Voix. Anonyme (\uE040), sans nom, sans portrait.
--Regle projet non negociable — c'est au joueur de reconnaitre, jamais
--au jeu de nommer.
local function voice(key)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
end

--Helper local : le dormeur. Voix off centree, jamais de portrait — il
--reve, il n'a pas de corps ici. C'est aussi ce que fait pmd-red
--(MSG_QUIET, jamais de portrait du heros pendant un reve).
local function dreamer(key)
  UI:SetCenter(true)
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
  UI:SetCenter(false)
  UI:ResetSpeaker()
end

--Helper local : un silence. La boite se ferme et il ne reste que
--l'image. C'est le TEXTBOX_CLEAR + WAIT de pmd-red, et c'est ce qui
--manque le plus aux scenes qui « enchainent les dialogues ».
local function silence(frames)
  UI:SetCenter(false)
  UI:ResetSpeaker()
  GAME:WaitFrames(frames or 40)
end

--Corps du reve. Scinde de DreamScene pour que la SORTIE soit garantie :
--une erreur au milieu de la scene laissait auparavant le joueur sur un
--ecran noir sans issue, exactement le symptome signale (« le moment du
--reve est toujours un crash black screen »). Le contenu est inchange.
local function DreamSceneBody()
  --LE MODE CINEMATIQUE D'ABORD, AVANT MEME DE LIRE LE JOUEUR.
  --Il est deja pose par Init ; on le repose ici car GameLoad appelle
  --aussi cette fonction sans repasser par Init. C'est un simple booleen
  --Il doit surtout preceder la sortie de secours ci-dessous : celle-ci
  --appelle EnterGroundMap, qui ARME la bascule de carte
  --et toute frame executee sans mode cinematique tombe sur
  --jeu au moment du coucher.
  pcall(function() GAME:CutsceneMode(true) end)

  local hero = CH('PLAYER')

  --SORTIE DE SECOURS. Si le joueur n'est pas sur la carte, on ne joue
  --RIEN et on renvoie immediatement au camp : mieux vaut sauter le reve
  --que bloquer la partie sur une carte vide et sans sortie.
  --On se contente de SORTIR DU CORPS : le retour au camp est desormais
  --assure par DreamScene, apres le pcall. Appeler EnterGroundMap ici
  --aurait arme la bascule une premiere fois, puis le wrapper une seconde
  --— deux SceneOutcome pour un seul changement de carte.
  if hero == nil then
    PrintInfo("[hero_dream] PLAYER introuvable — reve saute, retour au camp")
    return
  end

  SOUND:StopBGM()

  -- MISE EN PLACE, SOUS LE NOIR
  --LE HEROS REVE SEUL. RespawnAllies a pu faire apparaitre le
  --partenaire (il est dans l'equipe) : on le retire de la carte, il
  --n'a rien a faire dans ce reve. GROUND:Hide suffit — le supprimer
  --casserait sa restauration au retour.
  pcall(function()
    local partner = CH('Teammate1')
    if partner ~= nil then GROUND:Hide(partner.EntName) end
  end)

  --Le heros au centre exact de l'ecran (152,112), couche. « EventSleep »
  --est la pose de sommeil utilisee par tout le mod pour le heros
  --(searing_tunnel_entrance, mount_windswept_entrance).
  GROUND:TeleportTo(hero, 152, 112, Direction.Down)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GAME:WaitFrames(10) -- Stabilisation avant FadeIn (structure chapitres 1-4)

  --La camera est centree sur lui et NE LE QUITTERA PAS. Tous les
  --mouvements de cette scene sont des derives de quelques pixels
  --autour de ce point.
  GAME:MoveCamera(160, 120, 1, false)

  --L'ENTITE. Creee des maintenant, mais INVISIBLE (DrawEffect.Absent
  --met l'opacite a 0 — GroundAction.UpdateDrawEffects:79). Elle est
  --posee au nord du heros, legerement decalee : elle le domine sans
  --l'ecraser, et les deux tiennent dans le meme plan.
  --Le sprite est celui de Gardevoir (index national 282). PMDO fournit
  --nativement les sprites d'especes : Content/Chara/ d'un mod
  --ModType=Quest n'est qu'une SURCHARGE partielle, pas la liste des
  local entity = nil
  pcall(function()
    local id = RogueEssence.Dungeon.MonsterID("gardevoir", 0, "normal", Gender.Female)
    entity = RogueEssence.Ground.GroundChar(id, RogueElements.Loc(152, 48), Direction.Down, "DreamEntity", "DreamEntity")
    entity:ReloadEvents()
    GAME:GetCurrentGround():AddTempChar(entity)
    GROUND:CharSetDrawEffect(entity, DrawEffect.Absent)
  end)

  --Le ciel de reve tourne deja derriere le noir. On leve la lumiere
  --DESSUS : le joueur voit le noir s'ouvrir directement sur le ciel
  --onirique, sans jamais entrapercevoir le camp.
  SOUND:PlayBGM('I Saw Something Again....ogg', true)
  GAME:FadeIn(70)
  GAME:WaitFrames(60)

  -- 1. L'EMERGENCE — le dormeur remonte vers la surface
  --Trois respirations, de plus en plus longues, entrecoupees de
  --silences croissants. Rien ne bouge a l'ecran que le ciel : c'est
  --voulu, le joueur doit se sentir endormi avant qu'il se passe quoi
  --que ce soit.
  UI:SetCenter(true)
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['DRM_001']))
  GAME:WaitFrames(25)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['DRM_002']))
  GAME:WaitFrames(35)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['DRM_003']))
  UI:SetCenter(false)
  UI:ResetSpeaker()
  GAME:WaitFrames(45)

  -- 2. LA DESORIENTATION — avant toute presence
  --La camera commence a deriver, tres lentement, vers le haut : le
  --regard du dormeur cherche quelque chose qui n'est pas encore la.
  --12 px sur 150 frames = un mouvement qu'on ressent sans le voir.
  local d1 = TASK:BranchCoroutine(function()
    GAME:MoveCamera(160, 108, 150, false)
  end)
  local d2 = TASK:BranchCoroutine(function()
    dreamer('DRM_004')
    GAME:WaitFrames(20)
    dreamer('DRM_005')
  end)
  TASK:JoinCoroutines({d1, d2})
  silence(35)
  dreamer('DRM_006')
  silence(50)

  -- 3. LA PRESENCE — elle apparait par clignotement
  --L'APPARITION. Trois paliers d'opacite, exactement comme les
  --apparitions des jeux officiels : rien -> fantome -> presence.
  --Le moteur n'expose que trois etats (UpdateDrawEffects:78-82) :
  --   DrawEffect.Absent      -> opacite 0
  --   DrawEffect.Transparent -> opacite 128
  --   aucun effet            -> opacite 255
  --On les enchaine en alternance pour obtenir un CLIGNOTEMENT : elle
  --vacille trois fois avant de se stabiliser, comme une image qui
  --peine a se former.
  local se_ok = pcall(function() SOUND:PlayBattleSE('_UNK_DUN_Water_Drop') end)
  GAME:WaitFrames(30)

  if entity ~= nil then
    local blink = TASK:BranchCoroutine(function()
      for i = 1, 3 do
        pcall(function()
          GROUND:CharEndDrawEffect(entity, DrawEffect.Absent)
          GROUND:CharSetDrawEffect(entity, DrawEffect.Transparent)
        end)
        GAME:WaitFrames(10 + i * 4)
        pcall(function()
          GROUND:CharEndDrawEffect(entity, DrawEffect.Transparent)
          GROUND:CharSetDrawEffect(entity, DrawEffect.Absent)
        end)
        GAME:WaitFrames(8)
      end
      --Elle se stabilise : d'abord fantome, puis pleinement la.
      pcall(function()
        GROUND:CharEndDrawEffect(entity, DrawEffect.Absent)
        GROUND:CharSetDrawEffect(entity, DrawEffect.Transparent)
      end)
      GAME:WaitFrames(50)
      pcall(function() GROUND:CharEndDrawEffect(entity, DrawEffect.Transparent) end)
    end)
    --Pendant qu'elle se forme, la camera glisse tres legerement vers
    --elle — 6 px : le dormeur tourne la tete, il ne se leve pas.
    local look = TASK:BranchCoroutine(function()
      GAME:WaitFrames(40)
      GAME:MoveCamera(160, 102, 120, false)
    end)
    TASK:JoinCoroutines({blink, look})
  end
  GAME:WaitFrames(30)

  --Le heros la remarque. Trois pensees separees par des silences : il
  --cherche, il croit reconnaitre, il abandonne.
  dreamer('DRM_007')
  silence(40)
  dreamer('DRM_008')
  silence(45)
  dreamer('DRM_009')
  silence(55)

  -- 4. ELLE PARLE — accueil, pas menace
  --Sa premiere phrase tombe apres un long silence : c'est elle qui
  --rompt le vide, et cela suffit a la rendre presente.
  voice('DRM_010')
  GAME:WaitFrames(35)
  voice('DRM_011')
  silence(40)

  dreamer('DRM_012')
  GAME:WaitFrames(30)
  voice('DRM_013')
  silence(45)

  dreamer('DRM_014')
  --LE BATTEMENT LE PLUS LONG DE LA SCENE. « Pas encore. Et pourtant
  --si. » est la phrase qui doit rester au joueur : on la laisse
  --arriver dans le vide, et on la laisse resonner apres.
  silence(60)
  voice('DRM_015')
  silence(70)

  -- 5. LA QUESTION PIVOT
  --Le heros pose enfin la question. La camera se recentre doucement
  --sur lui pendant qu'il parle : le plan revient a celui qui demande.
  local q1 = TASK:BranchCoroutine(function()
    GAME:MoveCamera(160, 116, 110, false)
  end)
  local q2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(15)
    dreamer('DRM_016')
  end)
  TASK:JoinCoroutines({q1, q2})
  silence(40)

  voice('DRM_017')
  GAME:WaitFrames(30)
  voice('DRM_018')
  silence(55)

  -- 6. L'AVERTISSEMENT — demain, la montagne
  voice('DRM_019')
  GAME:WaitFrames(35)
  voice('DRM_020')

  --« Pas avec ce corps. » L'image vacille au moment ou le heros touche
  --ce qu'il ne doit pas encore comprendre. Tangage court et doux : on
  --est dans un reve, pas dans un combat.
  pcall(function()
    SOUND:PlayBattleSE('EVT_Emote_Startled')
    GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 34))
  end)
  GAME:WaitFrames(50)

  dreamer('DRM_021')
  silence(45)
  voice('DRM_022')
  silence(40)
  --La derniere consigne, celle qui arme le sommet du chapitre.
  voice('DRM_023')
  silence(65)

  -- 7. LA SEPARATION — elle s'efface pendant qu'elle parle
  voice('DRM_024')
  GAME:WaitFrames(25)

  --Le heros tend la main. Elle s'efface EN MEME TEMPS qu'elle repond :
  --le fondu de sa silhouette et sa derniere phrase se terminent
  --ensemble. C'est la seule facon de rendre un adieu qu'on ne choisit
  --pas.
  local f1 = TASK:BranchCoroutine(function()
    dreamer('DRM_025')
    GAME:WaitFrames(20)
    voice('DRM_026')
  end)
  local f2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(30)
    if entity ~= nil then
      pcall(function() GROUND:CharSetDrawEffect(entity, DrawEffect.Transparent) end)
      GAME:WaitFrames(70)
      pcall(function() GROUND:CharSetDrawEffect(entity, DrawEffect.Absent) end)
    end
  end)
  local f3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(40)
    SOUND:FadeOutBGM(120)
  end)
  TASK:JoinCoroutines({f1, f2, f3})
  silence(50)

  --Le ciel s'eteint. Tout part ensemble : l'image, la musique, le reve.
  GAME:FadeOut(false, 70)
  GAME:WaitFrames(40)

  -- 8. LE REVEIL — de l'autre cote, au camp
  --La scene ne se termine PAS ici : elle rend la main a la carte du
  --camp, qui joue le sursaut et l'oubli. Le drapeau dit au camp que le
  --reve a eu lieu.
  SV.Chapter5.DreamSceneSeen = true

  --Le heros ne doit pas rester couche sur la carte suivante.
  pcall(function() GROUND:CharEndAnim(hero) end)

  --On repart vers le camp, ecran noir conserve (3e argument =
  --preserveMusic : il n'y a plus de musique a preserver, mais il evite
  --que le moteur relance celle de la carte d'arrivee avant le reveil).
  --On NE relache PAS le mode cinematique ici : ResumeAfterDream le
  --reprend des l'arrivee, et le couper laisserait le joueur bouger sur
  --la carte du reve pendant que la bascule se prepare.
end

function hero_dream.DreamScene()
  --SORTIE GARANTIE.
  --Le corps est joue sous pcall : si une seule de ses instructions echoue,
  --le moteur avorte la coroutine (xpcall, LuaEngine.cs:895) et plus rien
  --ne s'execute — l'ecran reste noir et la partie est bloquee, sans
  --sortie ni message. C'est ce qui se passait.
  --
  --Desormais l'erreur est tracee, puis on repart vers le camp quoi qu'il
  --arrive. Un reve rate vaut mieux qu'une partie perdue.
  local ok, err = pcall(DreamSceneBody)
  if not ok then
    PrintInfo('[hero_dream] reve ecourte : '..tostring(err))
  end

  --Le drapeau est pose meme en cas d'echec : sans lui, PlotScripting du
  --camp rejouerait la veillee en boucle et on repartirait vers le reve.
  SV.Chapter5.DreamSceneSeen = true

  --Ecran noir avant la bascule, et mode cinematique conserve : la carte
  --d'arrivee (ResumeAfterDream) les reprend a son compte.
  pcall(function() GAME:CutsceneMode(true) end)
  pcall(function() GAME:FadeOut(false, 1) end)
  GAME:EnterGroundMap('mount_windswept_entrance', 'Main_Entrance_Marker', true)
end

return hero_dream
