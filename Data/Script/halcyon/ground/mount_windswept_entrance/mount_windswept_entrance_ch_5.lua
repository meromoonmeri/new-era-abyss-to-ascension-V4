require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.VoiceVisions'

mount_windswept_entrance_ch_5 = {}

--------------------------------------------------------------------
-- LE CAMP DE BASE — decor partage
--------------------------------------------------------------------
-- Un seul endroit qui dessine le bivouac, appele par SetupGround ET par
-- la cinematique d'arrivee. Avant, les deux posaient leur propre feu aux
-- MEMES coordonnees (256,220) : deux animations superposees des que la
-- scene se jouait.
--
-- LES PAILLASSES NE SONT PAS DU MOBILIER D'INTERIEUR. Verifie :
-- Hay_Bed.dir est range dans Content/Object/ juste a cote de
-- Campfire.dir, et la carte soeur mount_windswept_midpoint porte deja
-- 3 tentes et 4 feux poses en dur. Un bivouac EST le vocabulaire visuel
-- de ce donjon. On les garde donc, une par membre de l'expedition.
--
-- LE LIT 11 ETAIT DANS LA ROCHE. Sa position d'origine (312,108) tombe
-- sur une case dont Tags ~= 0, donc non marchable : une paillasse
-- flottait dans la falaise. Verifie case par case sur les 12 ; les 11
-- autres sont sur du sol libre. Il est ramene sur le terrain plat.
--------------------------------------------------------------------
-- LA VEILLEE AU CAMP — diner, conversations, coucher, matin
--------------------------------------------------------------------
-- Portee au niveau de la scene soeur du Tunnel Incandescent
-- (ArrivalDinnerNightAndAddressCutscene) : un cycle complet
--   1. LE DINER        les 12 mangent autour du feu, camera qui balaie
--   2. LES CONVERSATIONS  trois groupes paralleles (coroutines)
--   3. LE COUCHER      chacun rejoint sa paillasse, en decale
--   4. LE MATIN        reveil par Rin, gag de Kino, briefing de Penticus
--
-- Toutes les repliques vivent dans strings.resx / strings.fr.resx
-- (cles MWE5_021 a MWE5_071 + MWE5_201), comme les scenes du Tunnel.
--
-- APIs strictement attestees dans le depot (recherche par usage) :
--   Eat / eating / Sleep / EventSleep / Wake  -> searing_tunnel_entrance_ch_5
--   Food / Food_Flipped / Hay_Bed / Campfire  -> Content/Object/
--   'Dinner Eating' / 'AMB_Fire_Loud'          -> Content/Sound/
--   WaitShowTimedDialogue / WaitShowVoiceOver  -> searing_tunnel (STE5_213)
--   Shake / Complain / Hop / DoAnimation       -> GeneralFunctions
--
-- Qui dort ou (indices dans BEDS) :
--   1 Penticus  2 Phileas  3 Reinier  4 Ganlon   5 Shuca   6 partenaire
--   7 heros     8 Hyko     9 Almotz  10 Rin     11 Kino   12 Coco
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.CampNightfall(hero, partner, t)
	local B = mount_windswept_entrance_ch_5.BEDS
	local mountain = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('mount_windswept')
	local ruins = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('cloven_ruins')

	--LE CERCLE DU REPAS N'EST PAS LE CERCLE DES COUCHAGES.
	--
	--BUG CORRIGE (mesure en jeu) : le diner envoyait chaque convive sur
	--les coordonnees de SA PAILLASSE, a un rayon de ~100 px du feu. Douze
	--personnages disperses sur un diametre de 200 px « partageaient » un
	--repas qu'aucun d'eux ne pouvait atteindre du regard, et la camera ne
	--pouvait pas les cadrer ensemble (viewport 320x240). Pire : les
	--paillasses ne sont meme pas encore deployees a ce moment de la scene
	--(DeployBeds n'est appele qu'en section 7), donc on s'asseyait sur du
	--decor inexistant.
	--
	--On mange DONC autour du feu, en couronne serree (rayon ~44 px), et on
	--dort ENSUITE en couronne large. Les douze places ci-dessous ont ete
	--calculees puis verifiees une par une : sol libre, connexe depuis
	--l'entree du joueur, hors de l'empreinte du feu (36x36 en 256,220) et
	--hors de l'empreinte des paillasses (40x40), avec 18 px minimum entre
	--deux voisins pour que les sprites ne se penetrent pas.
	local MEAL = {
		{t.penticus, 254, 188, Direction.Down},
		{t.phileas,  278, 188, Direction.Down},
		{t.rin,      234, 198, Direction.DownRight},
		{t.coco,     306, 210, Direction.DownLeft},
		{t.shuca,    224, 218, Direction.Right},
		{t.ganlon,   310, 228, Direction.Left},
		{partner,    224, 242, Direction.Right},
		{hero,       308, 246, Direction.Left},
		{t.hyko,     234, 262, Direction.UpRight},
		{t.almotz,   294, 264, Direction.UpLeft},
		{t.kino,     256, 272, Direction.Up},
		{t.reinier,  276, 272, Direction.Up},
	}

	--ATTRIBUTION DES COUCHAGES — elle raconte quelque chose.
	--
	--Le fer a cheval s'ouvre au SUD : c'est par la qu'on arrive et qu'on
	--repart, personne ne dort en travers du sentier. Les couches sont
	--numerotees dans le sens horaire depuis le nord (1 = plein nord,
	--2 a 7 = flanc est, 8 = sud-est en bout de file, 9 a 12 = flanc
	--ouest).
	--
	--  * PENTICUS prend la couche 1, plein nord : entre les dormeurs et
	--    la porte du donjon. Un chef dort du cote d'ou vient le danger.
	--  * LE DUO prend les couches 6 et 7, les deux dernieres du flanc est
	--    avant l'ouverture sud. Elles sont distantes de 50 px, donc
	--    reellement VOISINES : la scene intime de la section 9 cadre les
	--    deux sprites ensemble. Les couches 7 et 8 encadrent au contraire
	--    l'ouverture du fer a cheval et sont a 101 px l'une de l'autre —
	--    le duo y aurait dormi de part et d'autre du passage, hors du
	--    meme plan de camera. Ce sont aussi les plus proches du sentier :
	--    ceux qui partiront en premier au matin.
	--  * HYKO et ALMOTZ sont voisins (8 et 9, 50 px) : ils chuchotent
	--    encore apres l'extinction du feu, il faut qu'ils s'entendent.
	--
	--  * PHILEAS N'A PAS DE PAILLASSE, ET C'EST VOULU. Il prend le
	--    premier tour de garde : il monte au nord du camp et y reste
	--    debout toute la nuit. Lui attribuer une couche qu'il n'occupe
	--    jamais laissait un couchage VIDE au milieu du cercle pendant
	--    toute la veillee, le reve et le reveil — un lit de trop pour
	--    onze dormeurs. C'est PENTICUS qui prend la couche 2, la sienne
	--    reste la 1 : le maitre de guilde dort plein nord, entre les
	--    dormeurs et la porte du donjon.
	--
	--    Conséquence directe : la table BEDS ne compte plus que ONZE
	--    couchages (voir sa definition). DeployBeds n'en pose que onze,
	--    donc plus aucune paillasse inutilisee a l'ecran.
	--Le +13/+10 place le sprite au centre de la paillasse (patron Tunnel).
	local seats = {
		{t.penticus, 1,  Direction.Down},
		{t.coco,     2,  Direction.Left},
		{t.ganlon,   3,  Direction.Left},
		{t.reinier,  4,  Direction.Left},
		{partner,    5,  Direction.Left},
		{hero,       6,  Direction.Up},
		{t.hyko,     7,  Direction.Up},
		{t.almotz,   8,  Direction.Right},
		{t.shuca,    9,  Direction.Right},
		{t.rin,      10, Direction.Right},
		{t.kino,     11, Direction.Right},
	}
	local function seatX(i) return B[i][1] + 13 end
	local function seatY(i) return B[i][2] + 10 end

	------------------------------------------------------------------
	-- LE CAMP ECOUTE — un cercle vivant, pas douze statues.
	------------------------------------------------------------------
	-- Mesure faite sur cette scene avant correction : 68 repliques, dont
	-- 22 (32 %) ou AUCUN personnage ne bougeait dans les six lignes
	-- precedentes. Le joueur voyait des boites de dialogue s'enchainer
	-- devant un cercle immobile.
	--
	-- Les deux helpers ci-dessous rendent l'ecoute automatique :
	--
	--   Listen(parleur, {auditeurs}, emote)
	--     Les auditeurs se tournent vers celui qui parle, EN DECALE
	--     (4 frames d'ecart) : un groupe qui pivote d'un seul bloc a
	--     l'air mecanique. C'est la regle deja appliquee aux departs
	--     de la scene, on l'etend a l'ecoute.
	--
	--   Says(parleur, emotion, cle, {auditeurs}, emote)
	--     Regroupe « le corps parle avant la bouche » (grammaire du
	--     projet, §4.6) : on tourne les tetes, PUIS on affiche la boite.
	--
	-- Toutes les API employees sont attestees dans le depot :
	-- CharTurnToCharAnimated (547 fichiers), CharSetEmote, BranchCoroutine,
	-- JoinCoroutines. Le tout sous pcall : un auditeur nil (personnage
	-- deja retire de la carte) ne doit jamais interrompre la veillee.
	local function Listen(speaker, listeners, emote)
		if speaker == nil or listeners == nil then return end
		local turns = {}
		for i, who in ipairs(listeners) do
			if who ~= nil and who ~= speaker then
				turns[#turns+1] = TASK:BranchCoroutine(function()
					pcall(function()
						GAME:WaitFrames((i - 1) * 4)
						GROUND:CharTurnToCharAnimated(who, speaker, 4)
						if emote ~= nil then GROUND:CharSetEmote(who, emote, 1) end
					end)
				end)
			end
		end
		if #turns > 0 then pcall(function() TASK:JoinCoroutines(turns) end) end
	end

	local function Says(speaker, emotion, key, listeners, emote)
		Listen(speaker, listeners, emote)
		UI:SetSpeaker(speaker)
		UI:SetSpeakerEmotion(emotion or "Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
	end

	--Index inverse « personnage -> sa couche », construit UNE fois a
	--partir de `seats`. Toute la scene passe par lui : plus aucune
	--section ne redeclare un numero de lit dans son coin, donc plus
	--aucune possibilite qu'elles divergent.
	local bedOf = {}
	for _, s in ipairs(seats) do bedOf[s[1]] = s[2] end

	---------------------------------------------------------------
	-- 1. KINO ET REINIER REJOIGNENT LE CAMP
	---------------------------------------------------------------
	--Ils fermaient la marche sur le sentier. Leur arrivee complete
	--l'expedition : les 12 paillasses ont enfin leurs 12 dormeurs.
	GROUND:Unhide(t.kino.EntName)
	GROUND:Unhide(t.reinier.EntName)
	GROUND:TeleportTo(t.kino, 236, 396, Direction.Up)
	GROUND:TeleportTo(t.reinier, 276, 396, Direction.Up)

	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	local coro1 = TASK:BranchCoroutine(function()
		GROUND:CharSetEmote(t.coco, "exclaim", 1)
		GROUND:CharAnimateTurnTo(t.coco, Direction.Down, 4)
	end)
	local coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:CharSetEmote(t.shuca, "happy", 1)
		GROUND:CharAnimateTurnTo(t.shuca, Direction.Down, 4)
	end)
	local coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		GROUND:CharTurnToCharAnimated(partner, t.kino, 4)
	end)
	local coro4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GROUND:CharTurnToCharAnimated(hero, t.kino, 4)
	end)
	------------------------------------------------------------------
	-- ILS CONTOURNENT LE DUO, ILS NE LE TRAVERSENT PAS.
	------------------------------------------------------------------
	-- BUG VU EN JEU. Kino montait en ligne droite de (236,396) vers
	-- (238,290) : un trajet qui passe EXACTEMENT sur Hyko (240,328) puis
	-- sur le HEROS (240,300), et qui s'arretait a 10 px de ce dernier —
	-- soit deux sprites de 16x16 imbriques. Reinier faisait de meme avec
	-- Almotz puis le partenaire. Les quatre se traversaient a l'ecran.
	--
	-- Cause : la colonne centrale (x=240 et x=272) est occupee par la
	-- file d'arrivee du duo, et ces deux trajets la remontaient tout
	-- droit. Ils passent desormais PAR LES COTES et s'arretent DEVANT :
	--
	--   Kino     (236,396) -> (216,372) -> (216,308) -> (208,300)
	--   Reinier  (276,396) -> (312,380) -> (312,308) -> (304,300)
	--
	-- Chaque segment est echantillonne et verifie : sol libre, connexe,
	-- et jamais a moins de 16 px (largeur de sprite) du heros, du
	-- partenaire, de Hyko ou d'Almotz. Le detour ouest passe par x=216
	-- et non x=200 : un obstacle bouche x=184..208 entre y=356 et y=380.
	local coro5 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(t.kino, 216, 372, false, 1)
		GROUND:MoveToPosition(t.kino, 216, 308, false, 1)
		GROUND:MoveToPosition(t.kino, 208, 300, false, 1)
		GROUND:CharTurnToCharAnimated(t.kino, hero, 4)
	end)
	local coro6 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:MoveToPosition(t.reinier, 312, 380, false, 1)
		GROUND:MoveToPosition(t.reinier, 312, 308, false, 1)
		GROUND:MoveToPosition(t.reinier, 304, 300, false, 1)
		GROUND:CharTurnToCharAnimated(t.reinier, hero, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6})

	GAME:WaitFrames(10)
	UI:SetSpeaker(t.kino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_021']))
	GAME:WaitFrames(15)
	--Reinier repond a Kino : les deux se font face, le camp les regarde
	--arriver. Avant, ces deux repliques tombaient sur des sprites figes.
	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(t.reinier, t.kino, 4) end)
		UI:SetSpeaker(t.reinier)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_022']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharTurnToCharAnimated(t.kino, t.reinier, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	---------------------------------------------------------------
	-- 2. LE DINER — tout le monde s'installe autour du feu
	---------------------------------------------------------------
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_023']))
	UI:SetCenter(false)
	UI:ResetSpeaker()

	--Chacun gagne sa place, en decale : un camp qui bouge d'un seul
	--bloc a l'air mecanique.
	local settle = {}
	for i, m in ipairs(MEAL) do
		local chara, mx, my, dir = m[1], m[2], m[3], m[4]
		settle[#settle+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(i * 6)
			GROUND:MoveToPosition(chara, mx, my, false, 1)
			GROUND:CharAnimateTurnTo(chara, dir, 4)
		end)
	end
	TASK:JoinCoroutines(settle)
	GAME:WaitFrames(20)

	--La nourriture apparait devant chaque convive, COTE FEU : l'ecuelle
	--se pose entre le convive et les flammes, jamais dans son dos.
	--L'ancienne version posait « +22 en Y » pour tout le monde, ce qui
	--plantait l'ecuelle DERRIERE les convives de la moitie haute du
	--cercle. On decale donc chaque plat d'un tiers de rayon vers le
	--centre du foyer (274,238), calcule par interpolation entiere.
	local foods = {}
	for i, m in ipairs(MEAL) do
		local mx, my = m[2], m[3]
		local fx = math.floor(mx + (274 - (mx + 8)) / 6)
		local fy = math.floor(my + (238 - (my + 8)) / 6)
		local anim = (my > 238) and "Food_Flipped" or "Food"
		local food = RogueEssence.Ground.GroundObject(
			RogueEssence.Content.ObjAnimData(anim, 1, 0, 0),
			RogueElements.Rect(fx, fy, 16, 16),
			RogueElements.Loc(0, 0),
			false,
			"CampFood" .. tostring(i))
		food:ReloadEvents()
		GAME:GetCurrentGround():AddTempObject(food)
		foods[#foods+1] = food
	end

	--Tout le monde mange en meme temps.
	for _, m in ipairs(MEAL) do
		GROUND:CharSetAnim(m[1], "Eat", true)
		GROUND:CharSetEmote(m[1], "eating", 0)
	end

	--La camera balaie le camp pendant le repas, la boite de dialogue
	--"scrontch" tourne en boucle jusqu'a la fin du panoramique.
	local stopEating = false
	UI:SetSpeaker('', false, "", -1, "", RogueEssence.Data.Gender.Unknown)
	SOUND:LoopSE('Dinner Eating')
	coro1 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(200, 180, 100, false)
		GAME:MoveCamera(312, 268, 140, false)
		GAME:MoveCamera(256, 228, 70, false)
		GAME:WaitFrames(30)
		stopEating = true
	end)
	coro2 = TASK:BranchCoroutine(function()
		while not stopEating do
			UI:WaitShowTimedDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_201']), 6)
		end
		SOUND:FadeOutSE('Dinner Eating', 90)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(30)

	--Fin du repas : on retire la nourriture, on coupe les animations.
	for _, food in ipairs(foods) do
		GAME:GetCurrentGround():RemoveTempObject(food)
	end
	for _, m in ipairs(MEAL) do
		GROUND:CharEndAnim(m[1])
		GROUND:CharSetEmote(m[1], "", 0)
	end
	SOUND:LoopSE('AMB_Fire_Loud')
	GAME:WaitFrames(20)

	---------------------------------------------------------------
	-- 3. LA TABLEE — la cuisiniere, le ronchon, la premiere fois
	---------------------------------------------------------------
	--Coco s'adresse au cercle entier : les tetes se tournent vers elle
	--en cascade AVANT qu'elle ouvre la bouche (le corps parle avant la
	--bouche). C'est ce qui manquait — la replique tombait sur douze
	--personnages immobiles qui regardaient ailleurs.
	Says(t.coco, "Happy", 'MWE5_024',
	     {t.rin, t.shuca, partner, hero, t.hyko, t.almotz, t.kino, t.reinier})
	GAME:WaitFrames(15)

	--Ganlon marmonne son compliment ; Coco a l'oreille fine. Les deux
	--reactions se jouent en parallele.
	UI:SetSpeaker(t.ganlon)
	UI:SetSpeakerEmotion("Normal")
	coro1 = TASK:BranchCoroutine(function()
		GROUND:CharAnimateTurnTo(t.ganlon, Direction.UpLeft, 4)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_025']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(t.coco, "notice", 1)
		GROUND:CharTurnToCharAnimated(t.coco, t.ganlon, 4)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(26)
		GROUND:CharSetEmote(t.shuca, "happy", 2)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(10)
	--Coco prend Ganlon en flagrant delit de compliment. Le cercle
	--proche se retourne pour voir sa tete — c'est un moment comique,
	--il a besoin de spectateurs.
	UI:SetSpeaker(t.coco)
	UI:SetSpeakerEmotion("Joyous")
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_026'], t.ganlon:GetDisplayName()))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		Listen(t.ganlon, {t.rin, t.kino, t.reinier})
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(22)
		pcall(function() GROUND:CharSetEmote(t.ganlon, "sweatdrop", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(15)

	--Shuca enchaine : les jeunes du cercle se tournent vers elle.
	Says(t.shuca, "Happy", 'MWE5_027', {partner, hero, t.hyko, t.almotz})
	GAME:WaitFrames(12)

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	coro1 = TASK:BranchCoroutine(function()
		GROUND:CharTurnToCharAnimated(partner, t.shuca, 4)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_028']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		GROUND:CharTurnToCharAnimated(t.shuca, partner, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	---------------------------------------------------------------
	-- 4. LES CONVERSATIONS PARALLELES — trois groupes autour du feu
	---------------------------------------------------------------
	--Groupe 1 : Almotz et son almanach, Hyko et ses etoiles.
	--La camera isole le duo, pendant qu'en arriere-plan le reste du
	--camp continue de vivre (animations cycliques sous coroutine,
	--meme patron 'stopTalking' que la nuit du Tunnel).
	local stopTalking = false
	coro1 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(196, 236, 50, false)
		GAME:WaitFrames(10)
		GROUND:CharTurnToCharAnimated(t.almotz, t.hyko, 4)
		GROUND:CharTurnToCharAnimated(t.hyko, t.almotz, 4)
		UI:SetSpeaker(t.almotz)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_029']))
		GAME:WaitFrames(10)
		UI:SetSpeaker(t.hyko)
		UI:SetSpeakerEmotion("Joyous")
		GROUND:CharSetEmote(t.hyko, "glowing", 0)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_030']))
		GROUND:CharSetEmote(t.hyko, "", 0)
		GAME:WaitFrames(10)
		UI:SetSpeaker(t.almotz)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_031'], mountain:GetColoredName()))
		stopTalking = true
	end)
	coro2 = TASK:BranchCoroutine(function()
		while not stopTalking do
			GROUND:CharSetAnim(t.shuca, "Idle", true)
			GROUND:CharSetEmote(t.shuca, "happy", 0)
			GAME:WaitFrames(60)
			GROUND:CharEndAnim(t.shuca)
			GROUND:CharSetEmote(t.shuca, "", 0)
			GAME:WaitFrames(40)
			if stopTalking then break end

			GROUND:CharSetAnim(t.coco, "Idle", true)
			GROUND:CharSetEmote(t.coco, "happy", 0)
			GAME:WaitFrames(60)
			GROUND:CharEndAnim(t.coco)
			GROUND:CharSetEmote(t.coco, "", 0)
			GAME:WaitFrames(40)
		end
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(15)

	--Groupe 2 : Reinier, sa queue, et les etincelles. La camera glisse
	--vers lui pendant que Coco lui repond de l'autre bord du feu.
	coro1 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(322, 214, 45, false)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(t.reinier, "question", 1)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	UI:SetSpeaker(t.reinier)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_032']))
	GAME:WaitFrames(12)
	UI:SetSpeaker(t.coco)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_033']))
	GAME:WaitFrames(15)

	--Groupe 3 : les anciens. Phileas et Penticus, en haut du cercle,
	--parlent a voix basse de ce que le vent transporte. La camera les
	--isole ; c'est le seul moment grave du repas.
	GAME:MoveCamera(278, 168, 50, false)
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function()
		GROUND:CharTurnToCharAnimated(t.phileas, t.penticus, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:CharTurnToCharAnimated(t.penticus, t.phileas, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(t.phileas)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_034']))
	GAME:WaitFrames(20)
	--Penticus donne la parole a Phileas : il se tourne vers lui EN le
	--nommant, et le cercle suit le mouvement. Le geste designe l'orateur
	--suivant avant que la boite ne le dise.
	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(t.penticus, t.phileas, 4) end)
		UI:SetSpeaker(t.penticus)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_035'], t.phileas:GetDisplayName()))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		Listen(t.phileas, {t.rin, t.coco, partner, hero})
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(15)
	UI:SetSpeaker(t.phileas)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_036']))
	GAME:WaitFrames(20)

	--Retour au plan large : Rin fait sa tournee de soins.
	GAME:MoveCamera(256, 228, 55, false)
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(t.rin, "Notice", true)
	UI:SetSpeaker(t.rin)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_037'], t.ganlon:GetDisplayName()))
	GAME:WaitFrames(10)

	--Rin se leve du cercle du repas et vient se planter devant Ganlon.
	--On vise SA PLACE DE TABLE (MEAL), pas sa paillasse : a cet instant
	--de la veillee les couchages ne sont pas encore deroules — c'est la
	--section 7 qui les deploie. L'ancienne version envoyait Rin sur des
	--coordonnees de lit inexistant, a l'autre bout du camp.
	coro1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(t.rin, 296, 232, false, 1)
		GROUND:CharTurnToCharAnimated(t.rin, t.ganlon, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(t.ganlon, "sweatdrop", 1)
		GROUND:CharTurnToCharAnimated(t.ganlon, t.rin, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(t.ganlon)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_038']))
	GAME:WaitFrames(10)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	coro1 = TASK:BranchCoroutine(function()
		GROUND:CharSetEmote(t.coco, "happy", 2)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(6)
		GROUND:CharSetEmote(t.shuca, "happy", 2)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:CharSetEmote(t.hyko, "happy", 2)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	UI:SetSpeaker(t.coco)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_039']))
	GAME:WaitFrames(25)

	--Rin retourne a SA PLACE AUTOUR DU FEU (cercle du repas, cf. MEAL),
	--pas sur une paillasse : elles ne sont pas encore deployees.
	GROUND:MoveToPosition(t.rin, 234, 198, false, 1)
	GROUND:CharAnimateTurnTo(t.rin, Direction.DownRight, 4)
	GAME:WaitFrames(15)

	---------------------------------------------------------------
	-- 5. LE SILENCE — le heros et la montagne
	---------------------------------------------------------------
	--La conversation retombe. Le heros fixe le sommet ; le partenaire
	--est le seul a le remarquer. Fil rouge de la « sensation etrange »
	--commence au camp du Tunnel : elle est plus forte ici.
	--PREMIER FRISSON DU VERTIGE DE SKY : intensite 1 (tangage leger,
	--sans voile — bareme NAUSEA de VoiceVisions, verifie). Le crescendo
	--est voulu : niveau 1 a la veillee, tangage dans le reve, niveau 2
	--au reveil. La montagne « appuie » de plus en plus fort.
	SOUND:FadeOutSE('AMB_Fire_Loud', 60)
	GAME:WaitFrames(30)
	GROUND:EntTurn(hero, Direction.Up)
	GAME:WaitFrames(20)
	GAME:MoveCamera(238, 258, 40, false)
	GAME:WaitFrames(15)
	pcall(function() VoiceVisions.Nausea(hero, 1) end)
	pcall(function() VoiceVisions.Recover(hero) end)
	GAME:WaitFrames(10)

	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_040'], hero:GetDisplayName()))
	GAME:WaitFrames(15)

	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_041']))
	GAME:WaitFrames(15)

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_042']))
	GAME:WaitFrames(10)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_043']))
	GAME:WaitFrames(20)
	SOUND:FadeInSE('AMB_Fire_Loud', 60)

	---------------------------------------------------------------
	-- 6. L'ORDRE DU SOIR — Penticus envoie tout le monde dormir
	---------------------------------------------------------------
	GAME:MoveCamera(256, 210, 45, false)
	GROUND:CharEndAnim(t.penticus)
	GAME:WaitFrames(10)

	--Tout le cercle se tourne vers le maitre de guilde, en decale.
	local listeners = {partner, hero, t.hyko, t.almotz, t.rin, t.coco, t.shuca, t.ganlon, t.reinier, t.kino}
	Listen(t.penticus, listeners)
	GAME:WaitFrames(10)

	UI:SetSpeaker(t.penticus)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_044'], mountain:GetColoredName()))
	UI:SetSpeakerEmotion("Happy")

	--« Demain, le sommet. » Le camp accuse le coup pendant qu'il parle,
	--chacun a sa maniere : les jeunes s'illuminent, le rale souffle, les
	--anciens hochent. Trois reactions simultanees, pas une file d'attente.
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_045']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharSetEmote(t.shuca, "glowing", 1) end)
		GAME:WaitFrames(8)
		pcall(function() GROUND:CharSetEmote(t.hyko, "determined", 1) end)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		pcall(function() GROUND:CharSetEmote(t.ganlon, "sweatdrop", 1) end)
	end)
	coro4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(24)
		pcall(function() GeneralFunctions.DoAnimation(t.reinier, 'Nod') end)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(15)

	--Coco a le dernier mot : le cercle se retourne vers elle.
	Says(t.coco, "Joyous", 'MWE5_046', {t.rin, t.shuca, t.ganlon, partner, hero})
	GAME:WaitFrames(20)

	---------------------------------------------------------------
	-- 7. LE DEPLOIEMENT DES COUCHAGES — puis la nuit
	---------------------------------------------------------------
	--Les paillasses n'existent PAS avant cet instant : c'est ici que
	--l'expedition ouvre les sacs et deroule les couchages (Prompt
	--Maitre 6.3 — aucun lit avant la fin de la veillee). Le passage
	--se fait sous un fondu court, comme le camp du Tunnel remanie son
	--decor sous FadeOut. Au meme moment, le crepuscule bascule en
	--nuit noire ("dusk" -> "darkness", patron exact du Tunnel).
	GAME:FadeOut(false, 40)
	GAME:WaitFrames(20)
	mount_windswept_entrance_ch_5.DeployBeds()
	GROUND:RemoveMapStatus("dusk")
	GROUND:AddMapStatus("darkness")
	GAME:WaitFrames(10)
	GAME:FadeIn(40)

	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_072']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_073']))
	UI:SetCenter(false)
	UI:ResetSpeaker()
	GAME:WaitFrames(20)

	---------------------------------------------------------------
	-- 8. LE COUCHER — un par un, respiration desynchronisee
	---------------------------------------------------------------
	--Phileas prend le premier tour de garde : il ne se couche pas.
	local vers = {}
	--L'ordre du coucher LIT la table `seats` (via bedOf) au lieu de
	--redeclarer les numeros de couche. Avant, les deux listes portaient
	--chacune leur copie des index : toute retouche de l'attribution
	--devait etre faite deux fois, et un oubli envoyait un dormeur sur la
	--paillasse d'un autre. On ne garde ici que « qui se couche, et apres
	--combien de frames ».
	local sleepOrder = {
		{t.penticus,  0},
		{t.coco,     14},
		{t.shuca,    26},
		{t.ganlon,   40},
		{t.reinier,  52},
		{t.rin,      66},
		{t.kino,     80},
	}
	for _, s in ipairs(sleepOrder) do
		local chara, bed, delay = s[1], bedOf[s[1]], s[2]
		vers[#vers+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(delay)
			GROUND:MoveToPosition(chara, seatX(bed), seatY(bed), false, 1)
			GROUND:CharSetAnim(chara, "Sleep", true)
		end)
	end
	--Phileas prend le premier tour de garde : il monte au nord du camp,
	--entre les dormeurs et la porte du donjon, et regarde le camp. Le
	--poste (240,142) est libre et hors de la couche 1 — l'ancien
	--(256,148) tombait dessus.
	vers[#vers+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GROUND:MoveToPosition(t.phileas, 240, 142, false, 1)
		GROUND:CharAnimateTurnTo(t.phileas, Direction.Down, 4)
	end)
	TASK:JoinCoroutines(vers)
	GAME:WaitFrames(20)

	--Hyko et Almotz rejoignent leurs couches — VOISINES, 9 et 10 sur le
	--flanc ouest — puis chuchotent encore un moment.
	--
	--BUG CORRIGE : ils s'endormaient DEBOUT A LEUR PLACE DE TABLE. La
	--boucle `sleepOrder` couche sept personnages ; ces deux-la n'y
	--figurent pas (ils ont leur propre scene), et personne ne les
	--deplacait. Le commentaire d'origine disait deja « chacun sur sa
	--couche » — c'etait l'intention, pas ce que faisait le code : ils
	--jouaient l'animation Sleep sur le cercle du repas, a cote du feu,
	--pendant que leurs deux paillasses restaient vides a l'ecran.
	local toBeds = {}
	toBeds[#toBeds+1] = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(t.hyko, seatX(bedOf[t.hyko]), seatY(bedOf[t.hyko]), false, 1)
	end)
	toBeds[#toBeds+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:MoveToPosition(t.almotz, seatX(bedOf[t.almotz]), seatY(bedOf[t.almotz]), false, 1)
	end)
	TASK:JoinCoroutines(toBeds)
	GAME:WaitFrames(10)

	GROUND:CharTurnToCharAnimated(t.hyko, t.almotz, 4)
	GROUND:CharTurnToCharAnimated(t.almotz, t.hyko, 4)
	UI:SetSpeaker(t.hyko)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_047'], t.almotz:GetDisplayName()))
	GAME:WaitFrames(10)
	UI:SetSpeaker(t.almotz)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_048'], t.hyko:GetDisplayName()))
	GAME:WaitFrames(15)
	GROUND:CharSetAnim(t.almotz, "EventSleep", true)
	GAME:WaitFrames(8)
	GROUND:CharSetAnim(t.hyko, "Sleep", true)
	GAME:WaitFrames(25)

	---------------------------------------------------------------
	-- 9. LA SCENE INTIME — le duo, seul face au sommet
	---------------------------------------------------------------
	--Le reste du camp dort. Le duo rejoint ses deux couches voisines et
	--la camera se resserre sur eux : c'est le moment calme obligatoire
	--du Prompt Maitre (6.5), APRES la veillee de groupe, AVANT le
	--sommeil du heros.
	--
	--BUG CORRIGE : le duo non plus ne rejoignait jamais ses paillasses.
	--Il jouait EventSleep depuis sa place de table, a cote du feu. Deux
	--couchages restaient vides pendant toute la nuit, le rêve et le
	--reveil — et au matin le heros se relevait a un endroit ou il ne
	--s'etait pas couche.
	local duoBeds = {}
	duoBeds[#duoBeds+1] = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(partner, seatX(bedOf[partner]), seatY(bedOf[partner]), false, 1)
	end)
	duoBeds[#duoBeds+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		GROUND:MoveToPosition(hero, seatX(bedOf[hero]), seatY(bedOf[hero]), false, 1)
	end)
	duoBeds[#duoBeds+1] = TASK:BranchCoroutine(function()
		GAME:MoveCamera(330, 300, 45, false)
	end)
	TASK:JoinCoroutines(duoBeds)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(15)

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_074']))
	GAME:WaitFrames(15)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_075']))
	GAME:WaitFrames(10)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(15)

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_049'], hero:GetDisplayName()))
	GAME:WaitFrames(15)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharSetAnim(partner, "EventSleep", true)
	GAME:WaitFrames(30)

	--Le heros reste eveille un instant de plus. C'est maintenant que
	--sa couche est deployee dans la fiction : il s'y allonge en
	--dernier, et c'est lui qui ferme la journee.
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWE5_050']), "Normal")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	GAME:WaitFrames(30)

	--La camera derive au-dessus du camp endormi. Phileas, seul
	--debout, pique du bec un instant — gag de sentinelle du Tunnel —
	--puis se redresse.
	SOUND:FadeOutSE('AMB_Fire_Loud', 90)
	coro1 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(256, 268, 90, false)
		GAME:MoveCamera(256, 160, 110, false)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(120)
		GROUND:CharSetAction(t.phileas, RogueEssence.Ground.FrameGroundAction(t.phileas.Position, t.phileas.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Sleep"), 0))
		GAME:WaitFrames(25)
		GROUND:CharEndAnim(t.phileas)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_051']))
	UI:SetCenter(false)
	UI:ResetSpeaker()

	GAME:FadeOut(false, 60)
	GAME:WaitFrames(60)

	---------------------------------------------------------------
	-- 10. LE REVE — l'ombre inconnue (Prompt Maitre 6.6)
	---------------------------------------------------------------
	--RETOUR DU TEST EN JEU : le reve se jouait sur ECRAN NOIR nu, les
	--effets ne se voyaient pas. Correction par le patron ATTESTE des
	--visions (VoiceVisions.Play, module verifie) :
	--  * DreamSky : les DEUX couches Dream_Back + Dream_Front de
	--    Content/BG defilent en parallaxe (l'animation superposee) ;
	--  * UI:WaitShowBG('Genesis_Void') : fond onirique 320x240 anime,
	--    affiche PAR-DESSUS le fondu noir (c'est ainsi que les
	--    planches des visions s'affichent) ;
	--  * haut-parleur anonyme « ??? » (\uE040), patron VoiceVisions.
	SOUND:PlayBGM('I Saw Something Again....ogg', true)
	GAME:WaitFrames(30)

	------------------------------------------------------------------
	-- STRUCTURE DU REVE — relevee dans pret/pmd-red, pas de memoire.
	------------------------------------------------------------------
	-- Fichier lu : src/data/ground/ground_data_a01p01_station.h, les huit
	-- reves successifs du heros. Le jeu d'origine suit toujours le meme
	-- ordre, et cet ordre EST l'effet :
	--
	--   1. MSG_QUIET "......" / "............" / ".................."
	--      Trois boites de points, de plus en plus longues. Personne ne
	--      parle : c'est le dormeur qui remonte vers la surface. C'est ce
	--      qui manquait le plus ici — l'ancienne version ouvrait sur la
	--      Voix, donc le joueur n'etait jamais « endormi ».
	--   2. "Where..." / "Where am I?" / "Is this a dream...?"
	--      La desorientation vient AVANT toute presence.
	--   3. TEXTBOX_CLEAR + WAIT : la boite se FERME, il ne reste que
	--      l'image. Un vrai silence, pas un blanc dans une boite ouverte.
	--   4. "...Oh? There's someone here." / "Who is it...? Someone I know?"
	--      La presence est apercue avant d'etre entendue.
	--   5. "......Hmm... I can't remember."
	--      L'oubli est pose DES le premier reve, avant meme le reveil.
	--   6. MSG_NPC : l'entite parle enfin. Phrases courtes, beaucoup de
	--      points de suspension, jamais plus de deux idees a la fois.
	--   7. Le heros pose LA question : "Why do you appear in my dreams?"
	--      C'est le pivot de la scene de Gardevoir, on le reprend tel quel.
	--   8. "It will be morning soon." puis reveil en sursaut, et l'oubli.
	--
	-- TRANSPOSITION NEW ERA : l'entite reste ANONYME (\uE040, ni nom ni
	-- portrait — regle projet), la ou Gardevoir est nommee et portraituree.
	-- Le heros ne doit RIEN comprendre : c'est au joueur de reconnaitre.
	------------------------------------------------------------------
	pcall(function() VoiceVisions.DreamSky(900) end)
	pcall(function() UI:WaitShowBG('Genesis_Void', 180, 30) end)
	GAME:WaitFrames(60)

	--1. L'EMERGENCE. Voix off centree, sans locuteur : le dormeur n'est
	--pas encore quelqu'un. Les trois boites s'allongent (pmd-red).
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_130']))
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_131']))
	GAME:WaitFrames(25)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_132']))
	GAME:WaitFrames(30)

	--2. LA DESORIENTATION, avant toute presence.
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_133']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_134']))
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_135']))

	--3. LE SILENCE. La boite se ferme vraiment (TEXTBOX_CLEAR + WAIT(30)
	--dans pmd-red) : l'image onirique reste seule a l'ecran.
	UI:SetCenter(false)
	UI:ResetSpeaker()
	GAME:WaitFrames(50)

	--4. LA PRESENCE EST APERCUE. Un souffle marque son entree — le vent
	--est le motif du chapitre, il tient lieu du SE de Gardevoir.
	pcall(function() SOUND:PlayBattleSE('_UNK_DUN_Water_Drop') end)
	GAME:WaitFrames(40)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_136']))
	GAME:WaitFrames(15)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_137']))
	GAME:WaitFrames(20)
	--5. L'OUBLI, pose des maintenant.
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_138']))
	UI:SetCenter(false)
	UI:ResetSpeaker()
	GAME:WaitFrames(40)

	--6. L'ENTITE PARLE. Speaker anonyme pose UNE fois (patron EoSO
	--SetSpeakerUnknown, cf. VoiceVisions) : ni nom, ni espece, ni portrait.
	local function voice(key)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
	end
	--Le heros repond en pensee, voix off centree : il rêve, il n'a pas
	--de corps ici. C'est aussi ce que fait pmd-red (MSG_QUIET, jamais un
	--portrait du heros pendant le reve).
	local function dreamer(key)
		UI:SetCenter(true)
		UI:ResetSpeaker(false)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
		UI:SetCenter(false)
		UI:ResetSpeaker()
	end

	pcall(function() SOUND:PlayBattleSE('DUN_Heal_Bell') end)
	GAME:WaitFrames(30)
	voice('MWE5_139')
	GAME:WaitFrames(20)
	voice('MWE5_140')
	GAME:WaitFrames(25)
	dreamer('MWE5_141')
	GAME:WaitFrames(20)
	voice('MWE5_142')
	GAME:WaitFrames(20)
	dreamer('MWE5_143')
	GAME:WaitFrames(25)
	--« ... Par toi. » — la reponse qui ne s'explique pas. Un battement
	--long avant et apres : c'est la phrase que le joueur doit entendre.
	GAME:WaitFrames(20)
	voice('MWE5_144')
	GAME:WaitFrames(45)

	--7. LA QUESTION. Pivot exact de la scene de Gardevoir.
	dreamer('MWE5_145')
	GAME:WaitFrames(25)
	voice('MWE5_146')
	GAME:WaitFrames(20)
	voice('MWE5_147')
	GAME:WaitFrames(35)

	--La montagne. Le tangage du reve arrive ICI, sur « pas avec ce
	--corps » : l'image vacille au moment ou le heros touche ce qu'il ne
	--doit pas encore comprendre.
	voice('MWE5_148')
	GAME:WaitFrames(20)
	voice('MWE5_149')
	pcall(function()
		SOUND:PlayBattleSE('EVT_Emote_Startled')
		GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 6, 40))
	end)
	GAME:WaitFrames(45)
	dreamer('MWE5_150')
	GAME:WaitFrames(25)
	voice('MWE5_151')
	GAME:WaitFrames(30)
	--Le dernier avertissement, garde de la version precedente : c'est la
	--phrase qui arme le sommet du chapitre. Le heros ne la comprend pas.
	voice('MWE5_083')
	GAME:WaitFrames(45)

	--8. LA SEPARATION. « Le jour va se lever » = « It will be morning
	--soon. Au revoir. » L'image commence a se dissoudre pendant que
	--l'entite parle encore : le fondu et la derniere phrase se terminent
	--ensemble (patron EoSO, trois coroutines jointes).
	voice('MWE5_152')
	GAME:WaitFrames(20)
	dreamer('MWE5_153')
	GAME:WaitFrames(25)

	local dc1 = TASK:BranchCoroutine(function()
		voice('MWE5_154')
	end)
	local dc2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(30)
		pcall(function() UI:WaitHideBG(60) end)
	end)
	local dc3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(30)
		SOUND:FadeOutBGM(90)
	end)
	TASK:JoinCoroutines({dc1, dc2, dc3})
	UI:ResetSpeaker()
	GAME:WaitFrames(50)

	--LE REVEIL. Le corps parle avant la bouche (grammaire du projet) :
	--le sursaut physique, puis seulement la pensee. Le heros dort, donc
	--on leve sa pose le temps du sursaut avant de le rendormir.
	--LE SURSAUT. Le heros se redresse d'un coup, et la piece tangue
	--autour de lui : c'est le reveil de Rouge/Bleu, ou l'on se reveille
	--MAL. On leve d'abord sa pose de sommeil (sinon Nausea joue sur un
	--personnage couche et le tangage ne se lit pas), puis on passe par
	--VoiceVisions.Nausea au lieu d'un ScreenMover isole : le niveau 1
	--donne l'amplitude DEGRESSIVE portee de pmd-sky (le vertige s'eteint
	--au lieu de se couper net) sans le voile noir des niveaux 2 et 3,
	--qui serait de trop ici — on est deja dans le noir de la nuit.
	pcall(function() SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') end)
	pcall(function() GROUND:CharEndAnim(hero) end)
	pcall(function() VoiceVisions.Nausea(hero, 1) end)
	GAME:WaitFrames(20)

	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_155']))
	GAME:WaitFrames(25)
	--L'OUBLI IMMEDIAT — le coeur du dispositif de Rouge/Bleu.
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_156']))
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_157']))
	UI:SetCenter(false)
	UI:ResetSpeaker()
	GAME:WaitFrames(30)

	--Il se rendort. Le trouble n'est pas resolu : il ressurgira au matin
	--(section 11) et sur le chemin du nord (section 15).
	pcall(function()
		GROUND:CharSetEmote(hero, "", 0)
		GROUND:CharSetAnim(hero, "EventSleep", true)
	end)
	GAME:WaitFrames(60)

	---------------------------------------------------------------
	-- 11. LE MATIN — reveil progressif, heros deboussole
	---------------------------------------------------------------
	--Mise en place sous le noir : le jour se leve, Rin et Coco sont
	--deja debout, Penticus et Phileas aussi. Le reste du camp dort.
	GROUND:RemoveMapStatus("darkness")

	GROUND:CharEndAnim(t.rin)
	GROUND:CharEndAnim(t.coco)
	GROUND:CharEndAnim(t.penticus)
	--Le feu est ETEINT au matin (BuildCampMorning ne repose pas le
	--foyer) : l'emplacement du foyer est donc libre, et Penticus peut
	--se tenir au centre du fer a cheval, face au sud — l'axe naturel de
	--l'adresse, avec le camp et le sentier devant lui.
	--Positions verifiees hors paillasses : Coco se tenait en (280,252),
	--dans l'empreinte du foyer, et Penticus en (256,152) sur la couche 1.
	GROUND:TeleportTo(t.rin, 228, 252, Direction.Right)
	GROUND:TeleportTo(t.coco, 298, 250, Direction.Left)
	GROUND:TeleportTo(t.penticus, 258, 196, Direction.Down)
	GROUND:TeleportTo(t.phileas, 292, 198, Direction.DownLeft)
	GAME:MoveCamera(256, 228, 1, false)

	UI:SetAutoFinish(true)
	UI:WaitShowVoiceOver(STRINGS:Format(STRINGS.MapStrings['MWE5_052']) .. "\n\n", -1)
	UI:SetAutoFinish(false)
	GAME:WaitFrames(40)

	--Rin lance le reveil : elle se tourne vers les dormeurs avant de
	--donner de la voix (le corps parle avant la bouche).
	pcall(function() GROUND:CharAnimateTurnTo(t.rin, Direction.Down, 4) end)
	pcall(function() GeneralFunctions.EmoteAndPause(t.rin, "Happy", true) end)
	UI:SetSpeaker(t.rin)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_053']))
	GAME:FadeIn(40)
	GAME:WaitFrames(20)

	SOUND:PlayBattleSE("DUN_Heal_Bell")
	GROUND:CharSetAction(t.rin, RogueEssence.Ground.PoseGroundAction(t.rin.Position, t.rin.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GAME:WaitFrames(100)
	GROUND:CharEndAnim(t.rin)
	GAME:WaitFrames(20)

	--Tout le monde se reveille... sauf Kino. Le HEROS, lui, se
	--reveille MAL : sursaut, regard perdu autour de lui (LookAround,
	--patron du reveil de DiedCutscene au Tunnel) — le reve colle.
	coro1 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GeneralFunctions.Shake(hero)
		GAME:WaitFrames(10)
		GeneralFunctions.Shake(hero)
		GAME:WaitFrames(10)
		GeneralFunctions.DoAnimation(hero, 'Wake')
		GAME:WaitFrames(20)
		GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Up)
		GAME:WaitFrames(10)
		GROUND:CharTurnToCharAnimated(hero, t.rin, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GeneralFunctions.Shake(partner)
		GAME:WaitFrames(20)
		GeneralFunctions.DoAnimation(partner, 'Wake')
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(partner, t.rin, 4)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GeneralFunctions.Shake(t.almotz)
		GAME:WaitFrames(20)
		GeneralFunctions.DoAnimation(t.almotz, 'Wake')
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(t.almotz, t.rin, 4)
	end)
	coro4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(4)
		GeneralFunctions.Shake(t.hyko)
		GAME:WaitFrames(70)
		GROUND:CharEndAnim(t.hyko)
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(t.hyko, t.rin, 4)
	end)
	coro5 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GeneralFunctions.Shake(t.shuca)
		GAME:WaitFrames(20)
		GeneralFunctions.DoAnimation(t.shuca, 'Wake')
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(t.shuca, t.rin, 4)
	end)
	coro6 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GeneralFunctions.Shake(t.ganlon)
		GAME:WaitFrames(10)
		GeneralFunctions.Shake(t.ganlon)
		GAME:WaitFrames(70)
		GROUND:CharEndAnim(t.ganlon)
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(t.ganlon, t.rin, 4)
	end)
	local coro7 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(6)
		GeneralFunctions.Shake(t.reinier)
		GAME:WaitFrames(80)
		GROUND:CharEndAnim(t.reinier)
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(t.reinier, t.rin, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7})

	SOUND:PlayBGM("Do Your Best, As Always!.ogg", true)
	UI:SetSpeaker(t.rin)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_054']))
	GAME:WaitFrames(20)

	--Le partenaire remarque la paleur du heros (Prompt Maitre 6.7).
	--LE VERTIGE DE SKY, cette fois a l'ecran : c'est l'effet des Cris
	--Temporels d'Explorateurs du Ciel, porte du depot EoSO dans
	--VoiceVisions (verifie, pas suppose). Niveau 2 = tangage de
	--l'ecran + voile noir semi-transparent qui monte et redescend
	--(DizzyVeil, alpha 128, RepeatX/Y) — le reve colle a la peau du
	--heros, visible par tous, comprehensible par lui seul.
	--Retour PROGRESSIF (modele de fondu de pmd-sky) : le tangage s'eteint
	--en paliers au lieu de se couper net. Le heros ne « redevient pas
	--normal » d'une image a l'autre — le malaise le lache lentement.
	pcall(function() VoiceVisions.Nausea(hero, 2) end)
	pcall(function() VoiceVisions.Recover(hero, true) end)
	GAME:WaitFrames(10)

	--CE QU'IL RESTE DU REVE. Le heros tente de rattraper l'image et n'y
	--arrive pas : deux pensees, en voix off centree (il ne parle a
	--personne). C'est la reprise du dispositif de Rouge/Bleu — le reve
	--s'efface a la seconde ou on se reveille, et seul le SENTIMENT reste.
	--Ces deux repliques portaient deja ce role dans la version
	--precedente ; elles reviennent ici, a leur vraie place.
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_085']))
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_086']))
	UI:SetCenter(false)
	UI:ResetSpeaker()
	GAME:WaitFrames(25)

	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_087'], hero:GetDisplayName()))
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_088']))
	GAME:WaitFrames(20)

	--Kino dort toujours. Comme au Tunnel. Comme toujours.
	GeneralFunctions.EmoteAndPause(t.rin, "Notice", true)
	GROUND:CharTurnToCharAnimated(t.rin, t.kino, 4)
	GAME:WaitFrames(10)
	UI:SetSpeaker(t.rin)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_055'], t.kino:GetDisplayName()))
	GAME:WaitFrames(15)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_056']))
	GAME:WaitFrames(15)

	--Rin va secouer Kino, le seul encore endormi. Elle s'arrete A COTE
	--de sa paillasse, cote feu, jamais dessus : l'ancien « seatX(11)-32 »
	--visait la couche 11 de l'ancienne numerotation, dont Kino n'est
	--plus l'occupant. On resout la couche depuis la table `seats`.
	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMoveRS(t.rin, B[bedOf[t.kino]][1] + 44,
		                                B[bedOf[t.kino]][2] + 10, false, 1)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GeneralFunctions.FaceMovingCharacter(hero, t.rin, 4, Direction.Right)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GeneralFunctions.FaceMovingCharacter(partner, t.rin, 4, Direction.Right)
	end)
	coro4 = TASK:BranchCoroutine(function()
		GeneralFunctions.FaceMovingCharacter(t.shuca, t.rin, 4, Direction.Right)
	end)
	coro5 = TASK:BranchCoroutine(function()
		GeneralFunctions.FaceMovingCharacter(t.ganlon, t.rin, 4, Direction.Right)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	GAME:WaitFrames(10)
	GeneralFunctions.Complain(t.rin)
	UI:SetSpeaker(t.rin)
	UI:SetSpeakerEmotion("Shouting")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_057'], t.kino:GetDisplayName()))
	GAME:WaitFrames(10)

	GeneralFunctions.Shake(t.kino)
	GAME:WaitFrames(30)
	GROUND:CharEndAnim(t.kino)
	GAME:WaitFrames(20)
	UI:SetSpeaker(t.kino)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_058']))
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(t.rin, "Sweatdrop", true)
	UI:SetSpeaker(t.rin)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_059']))
	GAME:WaitFrames(10)
	UI:SetSpeaker(t.ganlon)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_060']))
	GAME:WaitFrames(25)

	---------------------------------------------------------------
	-- 12. LE RASSEMBLEMENT — rangs par deux, face a Penticus
	---------------------------------------------------------------
	--Penticus appelle au rassemblement. Le camp se range sous un
	--fondu court (patron du matin du Tunnel : c'est SOUS FadeOut que
	--sa formation de depart se met en place). Pendant le noir, les
	--couchages sont ranges et remplaces par le materiel de jour
	--(BuildCampDay) : la Ground raconte le camp pret au depart.
	GROUND:CharEndAnim(t.kino)
	GAME:MoveCamera(256, 196, 40, false)
	--L'appel au rassemblement : tout le camp se retourne vers le maitre
	--de guilde AVANT qu'il parle. C'est l'ordre qui fait lever les tetes.
	Listen(t.penticus, {t.phileas, t.rin, t.coco, t.shuca, t.ganlon,
	                    t.kino, t.reinier, t.hyko, t.almotz, partner, hero})
	UI:SetSpeaker(t.penticus)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_089']))
	GAME:WaitFrames(20)

	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	GAME:WaitFrames(30)

	--Camp du matin : paillasses rangees, feu ETEINT, seul le sac commun
	--reste. Le foyer libere l'axe central : Penticus peut se tenir face
	--aux rangs sans chevaucher les flammes (bug vu en jeu).
	mount_windswept_entrance_ch_5.BuildCampMorning()

	--La formation : 5 rangs de 2, face au maitre de guilde, colonnes
	--x=240/272 (offset regulier de 32 px), rangs espaces de 28 px.
	--Chaque case a ete verifiee praticable ET atteignable depuis le
	--feu (BFS sur la grille d'obstacles du .rsground).
	GROUND:TeleportTo(t.penticus, 256, 240, Direction.Down)
	GROUND:TeleportTo(t.phileas, 296, 232, Direction.DownLeft)
	GROUND:TeleportTo(hero, 240, 284, Direction.Up)
	GROUND:TeleportTo(partner, 272, 284, Direction.Up)
	GROUND:TeleportTo(t.hyko, 240, 312, Direction.Up)
	GROUND:TeleportTo(t.almotz, 272, 312, Direction.Up)
	GROUND:TeleportTo(t.kino, 240, 340, Direction.Up)
	GROUND:TeleportTo(t.reinier, 272, 340, Direction.Up)
	GROUND:TeleportTo(t.rin, 240, 368, Direction.Up)
	GROUND:TeleportTo(t.coco, 272, 368, Direction.Up)
	GROUND:TeleportTo(t.ganlon, 240, 396, Direction.Up)
	GROUND:TeleportTo(t.shuca, 272, 396, Direction.Up)

	GAME:MoveCamera(256, 300, 1, false)
	GAME:WaitFrames(30)
	GAME:FadeIn(40)
	SOUND:PlayBGM("Spring Cave.ogg", true)
	GAME:WaitFrames(20)

	--La camera remonte la formation, du dernier rang au maitre de
	--guilde : le joueur voit CHAQUE binome avant le discours.
	GAME:MoveCamera(256, 380, 60, false)
	GAME:WaitFrames(20)
	GAME:MoveCamera(256, 268, 90, false)
	GAME:WaitFrames(15)

	--Il remercie Rin en la regardant : on ne remercie pas dans le vide.
	pcall(function() GROUND:CharTurnToCharAnimated(t.penticus, t.rin, 4) end)
	GAME:WaitFrames(8)
	UI:SetSpeaker(t.penticus)
	UI:SetSpeakerEmotion("Happy")
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_061'], t.rin:GetDisplayName()))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		pcall(function() GROUND:CharSetEmote(t.rin, "happy", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_062'], mountain:GetColoredName(), ruins:GetColoredName()))
	GAME:WaitFrames(15)
	GROUND:CharTurnToChar(t.penticus, t.kino)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_063'], t.kino:GetDisplayName()))
	GAME:WaitFrames(15)

	--Kino, specialiste des donjons, fait son briefing.
	UI:SetSpeaker(t.kino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_064']))
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_065']))
	GAME:WaitFrames(12)
	--Chacun rend son rapport au maitre de guilde : celui qui parle se
	--tourne vers Penticus, pas vers le vide.
	Says(t.reinier, "Normal", 'MWE5_066', {t.penticus, t.kino})
	GAME:WaitFrames(12)
	Says(t.phileas, "Normal", 'MWE5_067', {t.penticus, hero, partner})
	GAME:WaitFrames(20)

	---------------------------------------------------------------
	-- 13. LES CORDEES — la repartition propre au Mont Venteux
	---------------------------------------------------------------
	--Logique DIFFERENTE des donjons precedents du chapitre (verifie :
	--la steppe faisait DEUX GRANDES equipes de 4, VSE5_027/038 ; le
	--tunnel reprenait deux equipes de 4, STE5_105/208). Ici : des
	--CORDEES petites, reparties PAR ROLE, et Penticus justifie ce
	--choix DANS le dialogue (la montagne separe les grands groupes).
	GROUND:CharAnimateTurnTo(t.penticus, Direction.Down, 4)
	UI:SetSpeaker(t.penticus)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_092']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_093']))
	GAME:WaitFrames(20)

	--Cordee d'ouverture : Kino (lecture du donjon), Reinier (lecture
	--du terrain), Ganlon (le rythme). Chacun reagit a l'appel.
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_094'], t.kino:GetDisplayName(), t.reinier:GetDisplayName(), t.almotz:GetDisplayName()))
	coro1 = TASK:BranchCoroutine(function()
		GROUND:CharSetEmote(t.kino, "exclaim", 1)
		GeneralFunctions.Hop(t.kino, "Idle", 8, 16, 0, false)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:CharSetEmote(t.reinier, "notice", 1)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		GROUND:CharSetEmote(t.almotz, "notice", 1)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	UI:SetSpeaker(t.kino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_095']))
	GAME:WaitFrames(15)

	--Cordee de soutien : Rin (soins), Coco (provisions), Shuca (les
	--arrieres, et l'experience de sa premiere expedition encadree).
	--On ne nomme pas une cordee dans le vide : Penticus se tourne vers
	--celles qu'il designe, et elles se redressent en s'entendant nommer.
	pcall(function() GROUND:CharTurnToCharAnimated(t.penticus, t.rin, 4) end)
	Listen(t.penticus, {t.rin, t.coco, t.shuca})
	UI:SetSpeaker(t.penticus)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_096'], t.rin:GetDisplayName(), t.coco:GetDisplayName()))
	coro1 = TASK:BranchCoroutine(function()
		GROUND:CharSetEmote(t.rin, "happy", 1)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:CharSetEmote(t.coco, "glowing", 1)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	UI:SetSpeaker(t.coco)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_097']))
	GAME:WaitFrames(15)

	--Cordee du sommet : le duo, Ganlon et Shuca. C'est la composition
	--REELLE de l'equipe jouable dans le donjon (SetParty cree Ganlon
	--et Shuca en Teammate2/3 a la fin de cette cinematique).
	--La cordee du sommet, c'est le joueur : Penticus se tourne vers le
	--heros pour l'annoncer, et les quatre nommes se tournent vers lui.
	pcall(function() GROUND:CharTurnToCharAnimated(t.penticus, hero, 4) end)
	Listen(t.penticus, {hero, partner, t.ganlon, t.shuca})
	UI:SetSpeaker(t.penticus)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_098'], hero:GetDisplayName(), partner:GetDisplayName(), t.ganlon:GetDisplayName(), t.shuca:GetDisplayName()))
	coro1 = TASK:BranchCoroutine(function()
		GROUND:CharSetEmote(t.shuca, "glowing", 1)
		GeneralFunctions.Hop(t.shuca, "Idle", 8, 16, 0, false)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(6)
		GROUND:CharSetEmote(partner, "exclaim", 1)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:CharTurnToCharAnimated(t.shuca, t.ganlon, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	UI:SetSpeaker(t.shuca)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_099'], t.ganlon:GetDisplayName()))
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(t.ganlon, Direction.UpRight, 4)
	UI:SetSpeaker(t.ganlon)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_100']))
	GROUND:CharAnimateTurnTo(t.ganlon, Direction.Up, 4)
	GAME:WaitFrames(15)

	--HYKO RESTE AU CAMP DE BASE. C'est l'arc noue au Tunnel (l'auteur :
	--Penticus, apres sa panique, veut garder Hyko pres de lui) et la
	--condition de la WindSecretScene qui se joue ici meme, de nuit.
	GROUND:CharTurnToChar(t.penticus, t.hyko)
	UI:SetSpeaker(t.penticus)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_116'], t.hyko:GetDisplayName()))
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(t.hyko, "sweatdrop", 1)
	UI:SetSpeaker(t.hyko)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_117']))
	GROUND:CharAnimateTurnTo(t.penticus, Direction.Down, 4)
	GAME:WaitFrames(15)

	--Le camp de base : Penticus et Phileas. La justification est dans
	--le texte (les vents portent mal Phileas, le relais doit tenir).
	GROUND:CharTurnToCharAnimated(t.phileas, t.penticus, 4)
	UI:SetSpeaker(t.phileas)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_101'], t.penticus:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_102']))
	GAME:WaitFrames(20)

	--Le cri de ralliement.
	GROUND:CharAnimateTurnTo(t.phileas, Direction.DownLeft, 4)
	UI:SetSpeaker(t.penticus)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_068']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_069']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_103']))
	GAME:WaitFrames(10)

	local cheer = {}
	for i, c in ipairs({partner, t.hyko, t.almotz, t.shuca, t.coco, t.kino}) do
		cheer[#cheer+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(i * 3)
			GeneralFunctions.Hop(c, "Idle", 8, 20, 0, false)
		end)
	end
	TASK:JoinCoroutines(cheer)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_070']))
	UI:SetCenter(false)
	UI:ResetSpeaker()
	GAME:WaitFrames(20)

	---------------------------------------------------------------
	-- 14. LES DEPARTS — cordee par cordee, par le sentier nord
	---------------------------------------------------------------
	--Personne ne disparait sur place : chaque cordee remonte le
	--sentier est (x=284, seul couloir praticable vers l'entree,
	--verifie sur la grille : la colonne x=276 est bloquee en y=120)
	--et n'est masquee qu'une fois hors champ, au niveau de l'entree.
	--
	--PENTICUS S'ECARTE D'ABORD (bug vu en jeu : il restait plante au
	--centre du camp, sur l'axe). Il regarde ses cordees partir, il ne
	--leur barre pas la route.
	--
	--MAIS PAS SUR LE FLANC OUEST : il s'y postait en (216,240) avec
	--Phileas en (216,208), soit EXACTEMENT dans le couloir de sortie
	--ouest que Kino, Rin et Ganlon empruntent quelques secondes plus
	--tard. Les trois leur passaient au travers.
	--
	--Les deux se placent donc AU CENTRE, entre les deux couloirs
	--(ouest x=216, est x=320/336), sur l'axe du sentier qu'ils
	--regardent monter. Cases verifiees libres et connexes.
	coro1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(t.penticus, 248, 222, false, 1)
		GROUND:CharAnimateTurnTo(t.penticus, Direction.Up, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		GROUND:MoveToPosition(t.phileas, 240, 246, false, 1)
		GROUND:CharAnimateTurnTo(t.phileas, Direction.UpRight, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(15)

	UI:SetSpeaker(t.kino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_105']))
	------------------------------------------------------------------
	-- ILS SORTENT PAR LES COTES, PAS A TRAVERS LES RANGS.
	------------------------------------------------------------------
	-- Les partants quittaient la formation en diagonale et traversaient
	-- les camarades restes en rang. Mesure : Kino passait sur Hyko,
	-- Reinier sur Almotz, Rin sur Hyko, Coco sur le partenaire, Ganlon
	-- sur Hyko. Cinq traversees, toutes visibles a l'ecran.
	--
	-- La formation occupe DEUX colonnes, x=240 et x=272. On sort donc
	-- par l'exterieur — x=216 a l'ouest, x=320 a l'est — puis on rejoint
	-- le goulot nord (praticable seulement entre x=232 et x=312) en
	-- revenant vers le centre une fois la formation depassee.
	--
	-- Chaque segment est echantillonne contre les DOUZE positions de la
	-- formation : aucun ne passe a moins de 14 px d'un camarade.
	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(t.kino, 216, 336, false, 1)
		GeneralFunctions.EightWayMove(t.kino, 216, 216, false, 1)
		GeneralFunctions.EightWayMove(t.kino, 248, 196, false, 1)
		GeneralFunctions.EightWayMove(t.kino, 248, 124, false, 1)
		GROUND:Hide(t.kino.EntName)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GeneralFunctions.EightWayMove(t.reinier, 320, 336, false, 1)
		GeneralFunctions.EightWayMove(t.reinier, 320, 224, false, 1)
		GeneralFunctions.EightWayMove(t.reinier, 288, 200, false, 1)
		GeneralFunctions.EightWayMove(t.reinier, 288, 128, false, 1)
		GROUND:Hide(t.reinier.EntName)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(32)
		GeneralFunctions.EightWayMove(t.almotz, 336, 308, false, 1)
		GeneralFunctions.EightWayMove(t.almotz, 336, 224, false, 1)
		GeneralFunctions.EightWayMove(t.almotz, 296, 200, false, 1)
		GeneralFunctions.EightWayMove(t.almotz, 296, 132, false, 1)
		GROUND:Hide(t.almotz.EntName)
	end)
	coro4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GAME:MoveCamera(272, 240, 80, false)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(20)

	--Coco salue le duo avant de partir : un adieu se fait face a face.
	pcall(function() GROUND:CharTurnToCharAnimated(t.coco, hero, 4) end)
	pcall(function() GeneralFunctions.EmoteAndPause(t.coco, "Happy", true) end)
	UI:SetSpeaker(t.coco)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_106']))
	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(t.rin, 216, 364, false, 1)
		GeneralFunctions.EightWayMove(t.rin, 216, 216, false, 1)
		GeneralFunctions.EightWayMove(t.rin, 248, 196, false, 1)
		GeneralFunctions.EightWayMove(t.rin, 248, 124, false, 1)
		GROUND:Hide(t.rin.EntName)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GeneralFunctions.EightWayMove(t.coco, 320, 364, false, 1)
		GeneralFunctions.EightWayMove(t.coco, 320, 224, false, 1)
		GeneralFunctions.EightWayMove(t.coco, 288, 200, false, 1)
		GeneralFunctions.EightWayMove(t.coco, 288, 128, false, 1)
		GROUND:Hide(t.coco.EntName)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	------------------------------------------------------------------
	-- GANLON ET SHUCA NE PARTENT PAS. ILS NOUS ATTENDENT.
	------------------------------------------------------------------
	-- BUG DE CHRONOLOGIE CORRIGE. Cette scene les faisait monter le
	-- sentier PUIS disparaitre (GROUND:Hide) — « ils partent devant
	-- marquer la voie ». Or ce sont eux que SetParty transforme en
	-- Teammate2/3 quelques lignes plus bas : le joueur les voyait donc
	-- s'en aller seuls dans la montagne, et les retrouvait collés à lui
	-- dans le donjon deux secondes plus tard. La narration disait
	-- l'inverse de ce que le jeu faisait.
	--
	-- Desormais ils RESTENT, et c'est tout le sens de la cordee : on
	-- part ENSEMBLE. Ils se placent en tete du sentier, face au nord,
	-- et attendent que le duo les rejoigne — la formation de depart est
	-- deja constituee quand le joueur reprend la main.
	GROUND:CharTurnToCharAnimated(t.shuca, hero, 4)
	UI:SetSpeaker(t.shuca)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_104']))

	--Ils prennent leur poste d'attente. Colonnes espacees de 16 px (la
	--largeur d'un sprite) : ils ne se traversent pas, et ils laissent
	--libre la colonne centrale par laquelle le duo va remonter.
	coro1 = TASK:BranchCoroutine(function()
		--Ganlon contourne LARGEMENT par l'est : la montee directe depuis
		--(240,396) passait sur Hyko (240,312), et un contournement trop
		--serre passait sur le partenaire (272,284). Trajet verifie
		--contre les cinq personnages restes en place a cet instant.
		GeneralFunctions.EightWayMove(t.ganlon, 304, 380, false, 1)
		GeneralFunctions.EightWayMove(t.ganlon, 304, 240, false, 1)
		GeneralFunctions.EightWayMove(t.ganlon, 268, 208, false, 1)
		GeneralFunctions.EightWayMove(t.ganlon, 268, 200, false, 1)
		GROUND:CharAnimateTurnTo(t.ganlon, Direction.Up, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(18)
		GeneralFunctions.EightWayMove(t.shuca, 300, 232, false, 1)
		GeneralFunctions.EightWayMove(t.shuca, 300, 200, false, 1)
		GROUND:CharAnimateTurnTo(t.shuca, Direction.Up, 4)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GeneralFunctions.FaceMovingCharacter(hero, t.ganlon, 4, Direction.Up)
	end)
	coro4 = TASK:BranchCoroutine(function()
		GeneralFunctions.FaceMovingCharacter(partner, t.ganlon, 4, Direction.Up)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	--Ganlon rale une derniere fois, mais il attend : le geste dit
	--« on y va quand vous voulez », pas « on se retrouve la-haut ».
	GROUND:CharTurnToCharAnimated(t.ganlon, hero, 4)
	pcall(function() GeneralFunctions.EmoteAndPause(t.ganlon, "Sweating", true) end)
	GROUND:CharAnimateTurnTo(t.ganlon, Direction.Up, 4)
	GAME:WaitFrames(25)

	---------------------------------------------------------------
	-- 15. LE CHEMIN DU NORD — la remarque du partenaire
	---------------------------------------------------------------
	--Le duo remonte a son tour. A mi-chemin, le partenaire s'arrete :
	--il a REMARQUE. C'est la transition douce vers la scene finale
	--(Prompt Maitre 6.10) — le contenu du reve n'est pas revele.
	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(hero, 284, 216, false, 1)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		--Le partenaire remonte l'axe central AVANT d'obliquer : la
		--diagonale directe vers (300,168) passait sur Shuca, qui attend
		--en (300,200).
		GeneralFunctions.EightWayMove(partner, 284, 232, false, 1)
		GeneralFunctions.EightWayMove(partner, 284, 176, false, 1)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GAME:MoveCamera(280, 208, 70, false)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(15)

	--Le heros fixe le sommet — et LA VOIX REVIENT, en plein jour, une
	--seule phrase. C'est le rappel du reve que le heros a deja oublie :
	--le joueur, lui, reconnait la formule (« petit echo ») entendue cette
	--nuit. Personne d'autre ne l'entend, et le heros ne la commente pas.
	--
	--Ces cinq cles (MWE5_080..084) portaient l'ancienne version du reve.
	--Celui-ci a ete refondu sur la structure de pmd-red (cles 130+), mais
	--leur TEXTE etait juste : on ne le jette pas, on le rend a l'endroit
	--ou il fonctionne le mieux — la montagne en vue, le heros seul.
	GROUND:EntTurn(hero, Direction.Up)
	GAME:WaitFrames(30)

	local vc1 = TASK:BranchCoroutine(function()
		SOUND:FadeOutBGM(45)
	end)
	local vc2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(15)
		pcall(function() VoiceVisions.Nausea(hero, 1) end)
	end)
	TASK:JoinCoroutines({vc1, vc2})
	GAME:WaitFrames(20)

	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_082']))
	GAME:WaitFrames(25)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_084']))
	UI:ResetSpeaker()
	GAME:WaitFrames(30)

	pcall(function() VoiceVisions.Recover(hero, true) end)
	SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
	GAME:WaitFrames(20)

	--Le partenaire n'a RIEN entendu. Il a vu son ami s'arreter net.
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_107'], hero:GetDisplayName()))
	GAME:WaitFrames(20)

	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_108']))
	GAME:WaitFrames(15)

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_109']))
	GAME:WaitFrames(20)

	---------------------------------------------------------------
	-- 16. LA SCENE FINALE — Penticus, Phileas, et la porte du donjon
	---------------------------------------------------------------
	--Ne restent que quatre silhouettes devant l'entree (reference :
	--Grand Stepped Entrance). Plans larges sur la montagne, plans
	--rapproches sur les visages, silences.
	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(hero, 284, 160, false, 1)
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		GeneralFunctions.EightWayMove(partner, 300, 168, false, 1)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		--Penticus remonte a la verticale : la diagonale vers (256,196)
		--frolait Ganlon poste en (268,200).
		GeneralFunctions.EightWayMove(t.penticus, 248, 196, false, 1)
	end)
	coro4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(30)
		--Phileas longe par l'est pour ne pas couper devant Shuca (300,200).
		GeneralFunctions.EightWayMove(t.phileas, 316, 236, false, 1)
		GeneralFunctions.EightWayMove(t.phileas, 316, 196, false, 1)
	end)
	local coroH = TASK:BranchCoroutine(function()
		GAME:WaitFrames(36)
		GeneralFunctions.EightWayMove(t.hyko, 224, 220, false, 1)
		GROUND:CharAnimateTurnTo(t.hyko, Direction.UpRight, 4)
	end)
	coro5 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GAME:MoveCamera(280, 170, 80, false)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coroH})
	GAME:WaitFrames(20)

	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(40)

	--Derniere parole avant la porte : Penticus se tourne vers le duo.
	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(t.penticus, hero, 4) end)
		UI:SetSpeaker(t.penticus)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_110']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharTurnToCharAnimated(hero, t.penticus, 4) end)
		GAME:WaitFrames(6)
		pcall(function() GROUND:CharTurnToCharAnimated(partner, t.penticus, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	--Plan large : la camera monte vers la paroi, puis redescend sur
	--les visages. Le silence fait partie de la scene.
	GAME:MoveCamera(280, 90, 100, false)
	GAME:WaitFrames(50)
	GAME:MoveCamera(280, 180, 80, false)
	GAME:WaitFrames(20)

	GROUND:CharAnimateTurnTo(t.penticus, Direction.Up, 4)
	UI:SetSpeaker(t.penticus)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_111']))
	GAME:WaitFrames(25)

	UI:SetSpeaker(t.phileas)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_112']))
	GAME:WaitFrames(20)

	GROUND:CharAnimateTurnTo(t.penticus, Direction.UpRight, 4)
	UI:SetSpeaker(t.penticus)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_113'], hero:GetDisplayName(), partner:GetDisplayName()))
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_114']))
	GAME:WaitFrames(20)

	GROUND:CharTurnToCharAnimated(partner, t.penticus, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_115']))
	GAME:WaitFrames(10)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(30)
end

--------------------------------------------------------------------
-- LE RETOUR EN MAUVAISE POSTURE — KO / abandon dans la montagne
--------------------------------------------------------------------
-- Miroir des Died/Retreated Cutscenes du Tunnel (patron verifie ligne a
-- ligne). Jouees par PlotScripting quand SV.Chapter5.PlayTempMountScene
-- est vrai, APRES SetupGround : Penticus, Phileas et les autres membres
-- du camp existent deja sur la carte.
--
-- KODefeatCutscene : l'equipe s'est fait balayer dans la premiere
-- moitie du donjon. Elle git devant l'entree ; Rin accourt, soigne,
-- Penticus console et redonne des provisions (RewardItem, patron du
-- Tunnel). Toutes les positions et trajets sont verifies praticables.
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.KODefeatCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local ganlon = CH('Teammate2')   --cordee du sommet : Ganlon
	local shuca = CH('Teammate3')    --et Shuca (SetParty de l'intro)
	local penticus = CH('Tropius')
	local phileas = CH('Noctowl')
	--HYKO REMPLACE RIN. Rin (Audino) est partie avec la cordee de
	--soutien a la fin de l'intro : elle n'est plus sur la carte, et
	--CH('Audino') rendait nil. Toute la scene de secours reposait donc
	--sur un personnage absent — le soin ne se jouait pas, et la replique
	--MWE5_121 etait sautee en silence. Les trois presents au camp sont
	--Penticus, Phileas et Hyko ; c'est Hyko qui accourt et qui soigne.
	--Narrativement c'est meme plus juste : Penticus le garde au camp
	--precisement pour qu'il serve ICI, et pas la-haut.
	local hyko = CH('Growlithe')
	local coro1, coro2, coro3, coro4

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()

	--L'equipe git devant l'entree du donjon, la ou le vent l'a
	--rejetee. Cases verifiees libres (tx32-38 / ty19-20).
	GROUND:TeleportTo(hero, 268, 156, Direction.Down)
	GROUND:TeleportTo(partner, 292, 156, Direction.Down)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	GROUND:CharSetAnim(partner, "EventSleep", true)
	if ganlon ~= nil then
		GROUND:TeleportTo(ganlon, 244, 164, Direction.Down)
		GROUND:CharSetAnim(ganlon, "Sleep", true)
	end
	if shuca ~= nil then
		GROUND:TeleportTo(shuca, 308, 164, Direction.Down)
		GROUND:CharSetAnim(shuca, "EventSleep", true)
	end

	GAME:MoveCamera(276, 170, 1, false)
	GAME:FadeIn(40)
	SOUND:PlayBGM('Spring Cave.ogg', true)
	GAME:WaitFrames(40)

	--Phileas les repere depuis le camp et alerte Rin.
	if phileas ~= nil then
		SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
		GROUND:CharSetEmote(phileas, "exclaim", 1)
		UI:SetSpeaker(phileas)
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_120'], hyko ~= nil and hyko:GetDisplayName() or penticus:GetDisplayName()))
	end
	GAME:WaitFrames(15)

	--Penticus et Rin accourent depuis le camp. Trajets sur le couloir
	--central (praticable de bout en bout).
	coro1 = TASK:BranchCoroutine(function()
		if penticus ~= nil then
			GeneralFunctions.EightWayMove(penticus, 276, 184, true, 2)
			GROUND:CharTurnToCharAnimated(penticus, hero, 4)
		end
	end)
	coro2 = TASK:BranchCoroutine(function()
		if hyko ~= nil then
			GAME:WaitFrames(10)
			GeneralFunctions.EightWayMove(hyko, 244, 184, true, 2)
			GROUND:CharTurnToCharAnimated(hyko, hero, 4)
		end
	end)
	coro3 = TASK:BranchCoroutine(function()
		if phileas ~= nil then
			GAME:WaitFrames(22)
			GeneralFunctions.EightWayMove(phileas, 308, 184, true, 2)
			GROUND:CharTurnToCharAnimated(phileas, partner, 4)
		end
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(15)

	--Le soin : cloche et pose, patron du reveil au camp. C'est Hyko qui
	--l'administre — les baies de secours de la guilde, pas un don de
	--soigneuse. Penticus veille a cote, ce qui est tout le sens de sa
	--decision de le garder au camp.
	if hyko ~= nil then
		SOUND:PlayBattleSE("DUN_Heal_Bell")
		GROUND:CharSetAction(hyko, RogueEssence.Ground.PoseGroundAction(hyko.Position, hyko.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
		GAME:WaitFrames(100)
		GROUND:CharEndAnim(hyko)
	end
	GAME:WaitFrames(20)

	--L'equipe revient a elle, un par un, sonnee (Shake + Wake +
	--LookAround, patron de la DiedCutscene du Tunnel).
	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.Shake(hero)
		GAME:WaitFrames(20)
		GeneralFunctions.DoAnimation(hero, 'Wake')
		GAME:WaitFrames(20)
		GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Down)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GeneralFunctions.Shake(partner)
		GAME:WaitFrames(20)
		GeneralFunctions.DoAnimation(partner, 'Wake')
		GAME:WaitFrames(20)
		GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.Down)
	end)
	coro3 = TASK:BranchCoroutine(function()
		if ganlon ~= nil then
			GAME:WaitFrames(26)
			GeneralFunctions.DoAnimation(ganlon, 'Rumble')
			GAME:WaitFrames(12)
			GROUND:CharAnimateTurnTo(ganlon, Direction.Down, 4)
		end
	end)
	coro4 = TASK:BranchCoroutine(function()
		if shuca ~= nil then
			GAME:WaitFrames(6)
			GeneralFunctions.DoAnimation(shuca, 'Wake')
			GAME:WaitFrames(10)
			GROUND:CharAnimateTurnTo(shuca, Direction.Down, 4)
		end
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(20)

	if hyko ~= nil then
		pcall(function() GROUND:CharTurnToCharAnimated(hyko, hero, 4) end)
		pcall(function() GROUND:CharSetEmote(hyko, "sweatdrop", 1) end)
		UI:SetSpeaker(hyko)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_121']))
		GAME:WaitFrames(15)
	end

	--Le partenaire a mal : le corps le dit avant la boite.
	pcall(function() GeneralFunctions.Shake(partner) end)
	pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_122']))
	GAME:WaitFrames(20)

	if penticus ~= nil then
		--Penticus se penche sur les blesses avant de parler.
		pcall(function() GROUND:CharTurnToCharAnimated(penticus, hero, 4) end)
		pcall(function() GROUND:CharSetEmote(penticus, "sweatdrop", 1) end)
		GAME:WaitFrames(12)
		UI:SetSpeaker(penticus)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_123']))
		GAME:WaitFrames(15)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_124']))
		GAME:WaitFrames(15)
		GeneralFunctions.RewardItem("food_apple")
		GeneralFunctions.RewardItem("berry_oran")
		GeneralFunctions.RewardItem("berry_oran")
		GeneralFunctions.RewardItem("berry_leppa")
		GAME:WaitFrames(15)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_125']))
	end
	GAME:WaitFrames(20)

	--Penticus et Rin regagnent le camp ; le duo reste libre devant
	--l'entree, pret a retenter l'ascension.
	--Les trois regagnent EXACTEMENT leur poste de SetupGround : quand la
	--camera revient au joueur, le camp est dans l'etat ou il le trouvera
	--en se promenant. Avant, Penticus rentrait en (212,244) — une
	--position qui n'existe plus dans SetupGround depuis le recalcul du
	--camp : il se serait teleporte au premier rechargement de la carte.
	coro1 = TASK:BranchCoroutine(function()
		if penticus ~= nil then
			GeneralFunctions.EightWayMove(penticus, 230, 190, false, 1)
			GROUND:CharAnimateTurnTo(penticus, Direction.DownRight, 4)
		end
	end)
	coro2 = TASK:BranchCoroutine(function()
		if hyko ~= nil then
			GAME:WaitFrames(12)
			GeneralFunctions.EightWayMove(hyko, 224, 206, false, 1)
			GROUND:CharAnimateTurnTo(hyko, Direction.DownRight, 4)
		end
	end)
	coro3 = TASK:BranchCoroutine(function()
		if phileas ~= nil then
			GAME:WaitFrames(20)
			GeneralFunctions.EightWayMove(phileas, 288, 196, false, 1)
			GROUND:CharAnimateTurnTo(phileas, Direction.DownLeft, 4)
		end
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	SV.Chapter5.PlayTempMountScene = false

	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GROUND:CharTurnToChar(partner, hero)
	--La camera revient au joueur (forme attestee : searing_tunnel:1480).
	GAME:MoveCamera(0, 0, 1, true)
	GAME:CutsceneMode(false)
end

--------------------------------------------------------------------
-- RetreatReturnCutscene : l'equipe a fait demi-tour d'elle-meme.
-- Version courte et digne : pas de KO, Penticus salue la sagesse du
-- repli (l'exact oppose de la lecon du Tunnel, ou fuir etait un echec).
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.RetreatReturnCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local penticus = CH('Tropius')

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()

	GROUND:TeleportTo(hero, 268, 160, Direction.Down)
	GROUND:TeleportTo(partner, 292, 160, Direction.Down)
	GAME:MoveCamera(280, 180, 1, false)
	GAME:FadeIn(40)
	SOUND:PlayBGM('Spring Cave.ogg', true)
	GAME:WaitFrames(30)

	--Le repli volontaire : Penticus vient au-devant du duo, et Hyko le
	--suit a distance. Deux presents valent mieux qu'un seul PNJ qui
	--parle a des sprites immobiles — et Hyko a une raison d'etre la,
	--c'est lui le garde du camp.
	local hyko = CH('Growlithe')
	if penticus ~= nil then
		local c1 = TASK:BranchCoroutine(function()
			GeneralFunctions.EightWayMove(penticus, 276, 196, false, 1)
			GROUND:CharTurnToCharAnimated(penticus, hero, 4)
		end)
		local c2 = TASK:BranchCoroutine(function()
			if hyko ~= nil then
				GAME:WaitFrames(16)
				GeneralFunctions.EightWayMove(hyko, 244, 200, false, 1)
				GROUND:CharTurnToCharAnimated(hyko, hero, 4)
			end
		end)
		local c3 = TASK:BranchCoroutine(function()
			GAME:WaitFrames(8)
			pcall(function() GROUND:CharTurnToCharAnimated(hero, penticus, 4) end)
			GAME:WaitFrames(6)
			pcall(function() GROUND:CharTurnToCharAnimated(partner, penticus, 4) end)
		end)
		TASK:JoinCoroutines({c1, c2, c3})
		GAME:WaitFrames(10)

		UI:SetSpeaker(penticus)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_126']))
		GAME:WaitFrames(15)
		--Le partenaire encaisse la remarque pendant qu'elle tombe.
		local c4 = TASK:BranchCoroutine(function()
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_127']))
		end)
		local c5 = TASK:BranchCoroutine(function()
			GAME:WaitFrames(14)
			pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
		end)
		TASK:JoinCoroutines({c4, c5})
		GAME:WaitFrames(15)

		--Retour au poste EXACT de SetupGround. L'ancienne destination
		--(212,244) n'existe plus depuis le recalcul du camp : Penticus
		--se serait teleporte au premier rechargement de la carte.
		local c6 = TASK:BranchCoroutine(function()
			GeneralFunctions.EightWayMove(penticus, 230, 190, false, 1)
			GROUND:CharAnimateTurnTo(penticus, Direction.DownRight, 4)
		end)
		local c7 = TASK:BranchCoroutine(function()
			if hyko ~= nil then
				GAME:WaitFrames(14)
				GeneralFunctions.EightWayMove(hyko, 224, 206, false, 1)
				GROUND:CharAnimateTurnTo(hyko, Direction.DownRight, 4)
			end
		end)
		TASK:JoinCoroutines({c6, c7})
	end

	SV.Chapter5.PlayTempMountScene = false

	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GROUND:CharTurnToChar(partner, hero)
	--La camera revient au joueur (forme attestee : searing_tunnel:1480).
	GAME:MoveCamera(0, 0, 1, true)
	GAME:CutsceneMode(false)
end

function mount_windswept_entrance_ch_5.PurgeDecor()
	--Purge du calque. « Anims:Clear() » n'existe pas : la seule methode
	--de retrait attestee dans le depot est RemoveAt (event_single.lua:724).
	--On retire depuis la fin, index par index, sous pcall.
	pcall(function()
		local anims = GAME:GetCurrentGround().Decorations[0].Anims
		for i = anims.Count - 1, 0, -1 do
			anims:RemoveAt(i)
		end
	end)
end

--------------------------------------------------------------------
-- LE CAMP DE JOUR — feu + materiel d'expedition, AUCUNE paillasse.
--------------------------------------------------------------------
-- Prompt Maitre 6.3 : les couchages n'existent qu'apres la transition
-- jour -> soir, deployes par les personnages a la fin de la veillee.
-- Le camp de jour ne montre donc que le feu et le materiel range :
-- sacs (Grassy_Bag) et caisses (Yellow_Box), assets attestes dans
-- Content/Object/ et deja poses ailleurs (guild_guildmasters_room).
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.BuildCampDay()
	mount_windswept_entrance_ch_5.PurgeDecor()
	local ground = GAME:GetCurrentGround()
	local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)
	local bag  = RogueEssence.Content.ObjAnimData('Grassy_Bag', 1)

	--Le feu, centre du camp.
	ground.Decorations[0].Anims:Add(
		RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(256, 220)))
	--LE sac commun de l'expedition, contre la paroi ouest (case libre
	--verifiee). UN SEUL : le test en jeu montrait un empilement de
	--sacs et une caisse qui encombraient le camp pour rien.
	ground.Decorations[0].Anims:Add(
		RogueEssence.Ground.GroundAnim(bag, RogueElements.Loc(196, 224)))
end

--------------------------------------------------------------------
-- LE CAMP DU MATIN — feu eteint, sac pret au depart (Prompt 6.8).
--------------------------------------------------------------------
-- Distinct du camp de jour : au matin du depart, le feu est ETEINT
-- (aucune animation de flammes) et il ne reste que le sac commun.
-- C'est aussi ce qui libere l'axe du rassemblement : Penticus se
-- tient en (256,240), l'ancien feu (256,220) le chevauchait.
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.BuildCampMorning()
	mount_windswept_entrance_ch_5.PurgeDecor()
	local ground = GAME:GetCurrentGround()
	local bag = RogueEssence.Content.ObjAnimData('Grassy_Bag', 1)
	ground.Decorations[0].Anims:Add(
		RogueEssence.Ground.GroundAnim(bag, RogueElements.Loc(196, 224)))
end

--------------------------------------------------------------------
-- LE DEPLOIEMENT DES COUCHAGES — la nuit seulement.
--------------------------------------------------------------------
-- Appele par CampNightfall sous le fondu de la tombee de la nuit :
-- 12 paillasses = 12 membres presents (10 guilde + le duo), pas une
-- de plus. Le feu reste, le materiel de jour est remplace.
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.DeployBeds()
	mount_windswept_entrance_ch_5.PurgeDecor()
	local ground = GAME:GetCurrentGround()
	local hay_bed  = RogueEssence.Content.ObjAnimData('Hay_Bed', 1)
	local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)

	for _, b in ipairs(mount_windswept_entrance_ch_5.BEDS) do
		ground.Decorations[0].Anims:Add(
			RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(b[1], b[2])))
	end
	ground.Decorations[0].Anims:Add(
		RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(256, 220)))
end

--------------------------------------------------------------------
-- POSITION DES COUCHAGES — 12 paillasses en fer a cheval
--------------------------------------------------------------------
-- Sortie en table pour que la cinematique et le decor permanent ne
-- puissent plus diverger.
--
-- CE QUI N'ALLAIT PAS DANS L'ANCIENNE DISPOSITION (tout mesure) :
--
--   * LE LIT 12 ETAIT INATTEIGNABLE. (344,132) est du sol libre, mais
--     il appartient a une POCHE ISOLEE au nord-est : un parcours en
--     largeur depuis l'entree du joueur ne l'atteint pas. La carte
--     compte 3 composantes connexes de sol libre ; ce lit tombait dans
--     la mauvaise. Son dormeur aurait ete injoignable, et l'animation
--     de coucher se serait terminee contre un mur.
--   * QUATRE PAIRES DE PAILLASSES SE CHEVAUCHAIENT. Le sprite Hay_Bed
--     fait 40x40 (verifie dans l'en-tete de Content/Object/Hay_Bed.dir,
--     frameW=frameH=40), or les lits 2/3, 4/5, 7/8 et 9/10 n'etaient
--     espaces que de 33 a 45 px en diagonale : 7x7 px de recouvrement
--     visible a chaque fois.
--   * DEUX LITS ETAIENT DES RUSTINES. Les 10 premiers dessinaient un
--     cercle parfait de rayon ~78 autour du feu, les lits 11 et 12
--     etaient poses a 130 et 124 px, hors du motif : le « cercle » que
--     le joueur voyait etait un cercle avec deux verrues.
--   * UN CERCLE FERME N'A PAS DE SENS ICI. On arrive par le sentier
--     SUD ; douze couchages en anneau complet obligeaient a enjamber
--     des dormeurs pour entrer ou sortir du camp.
--
-- LA NOUVELLE DISPOSITION est un FER A CHEVAL ouvert plein sud, rayon
-- ~100 px autour du foyer, dans le sens horaire depuis le nord. Chaque
-- position a ete verifiee programmatiquement sur quatre criteres :
--   1. les 40x40 px du sprite tombent sur des tuiles Tags == 0 ;
--   2. ces tuiles appartiennent a la composante connexe de l'entree ;
--   3. aucun recouvrement avec une autre paillasse ;
--   4. l'assise (+13,+10) est elle-meme libre et connexe.
-- L'ouverture sud (secteur 70-115 degres) reste vide : c'est le
-- passage vers le sentier, et l'axe de l'adresse du matin.
--
-- ONZE COUCHAGES, PAS DOUZE. Phileas prend le premier tour de garde et
-- passe la nuit DEBOUT au nord du camp : lui reserver une paillasse
-- laissait un lit vide au milieu du cercle pendant toute la veillee, le
-- reve et le reveil. On en pose donc onze, un par dormeur reel
-- (10 membres au sol + le heros), et Penticus garde la couche 1.
--
-- Le rocher de Kangaskhan est REVENU a sa position d'origine (160,144),
-- au pied de la montagne. Les onze positions ci-dessous sont donc aussi
-- verifiees NE PAS CHEVAUCHER son emprise de 32x32 — l'ancienne serie ne
-- pouvait pas l'etre, le rocher etait alors pose ailleurs.
--
-- La couche 11 est sur le flanc EST et non a l'ouest : l'emplacement
-- ouest (200,180) tombait sous Penticus (230,190) et sous Hyko (224,206),
-- qui se tiennent la de jour. Un couchage sous les pieds d'un PNJ est
-- invisible pour un lecteur du code et flagrant a l'ecran.
mount_windswept_entrance_ch_5.BEDS = {
	{248, 116}, {298, 168}, {344, 168}, {356, 214},
	{348, 260}, {322, 306}, {210, 310}, {164, 286},
	{154, 240}, {154, 194}, {362, 300},
}

function mount_windswept_entrance_ch_5.SetupGround()	
	--------------------------------------------------------------------
	-- LE CAMP APRES LE DEPART DE L'EXPEDITION — QUI RESTE, ET POURQUOI
	--------------------------------------------------------------------
	-- INCOHERENCE MAJEURE CORRIGEE. Cette fonction respawnait HUIT PNJ,
	-- dont CINQ que la cinematique d'intro venait de faire partir en
	-- expedition sous les yeux du joueur (GROUND:Hide en fin d'intro) :
	--
	--     Kino (Breloom), Reinier (Girafarig), Almotz (Zigzagoon)
	--     -> vague d'ouverture, montent tracer la voie
	--     Rin (Audino), Coco (Snubbull)
	--     -> cordee de soutien, montent au relais
	--
	-- Le joueur les regardait remonter le sentier nord et disparaitre,
	-- puis reprenait la main... devant les cinq memes, plantes au camp.
	-- Le commentaire d'origine s'en justifiait par « redescendues au
	-- relais entre deux rotations » — sauf que la scene ne montre AUCUNE
	-- redescente : elle les montre MONTER.
	--
	-- NE RESTENT DONC QUE CEUX QUE LA SCENE LAISSE SUR PLACE :
	--   * PENTICUS (Tropius) : il tient le camp de base, il l'a dit.
	--   * PHILEAS (Noctowl)  : idem, les vents le portent mal.
	--   * HYKO (Growlithe)   : garde au camp par Penticus (arc du Tunnel,
	--                          paye par la scene du vent).
	-- Trois PNJ, exactement les trois que la cinematique finale laisse
	-- devant la porte du donjon. La cordee du sommet (heros, partenaire,
	-- Ganlon, Shuca) est dans l'equipe du joueur, pas en PNJ.
	--
	-- POSITIONS : verifiees sol libre, connexes depuis l'entree, hors
	-- empreinte du feu (36x36 en 256,220), hors rocher de Kangaskhan
	-- (32x32 en 160,144) et hors des onze paillasses.
	local tropius, noctowl, growlithe =
	CharacterEssentials.MakeCharactersFromList({
		{'Tropius', 230, 190, Direction.DownRight},
		{'Noctowl', 288, 196, Direction.DownLeft},
		{'Growlithe', 224, 206, Direction.DownRight}
	})
	--Rendus nil explicitement : plusieurs branches de ce fichier les
	--testent encore (if rin ~= nil...), et un nil franc vaut mieux
	--qu'un PNJ fantome qui n'a rien a faire la.
	local audino, snubbull, zigzagoon, breloom, girafarig = nil, nil, nil, nil, nil

	--Ganlon et Shuca voyagent avec le joueur : s'ils sont dans l'equipe
	--(post-intro), on les fait apparaitre pres du duo via les spawners
	--TEAMMATE_2/3 (patron exact du camp du Tunnel, spawners presents
	--dans le .rsground — verifie).
	if GAME:GetPlayerPartyCount() > 3 then
		GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
		GROUND:SpawnerDoSpawn("TEAMMATE_2")
		GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
		GROUND:SpawnerDoSpawn("TEAMMATE_3")
	end

	--LE CAMP. Repose a neuf a chaque entree.
	--
	--BUG CORRIGE : SetupGround est rappele par PlotScripting a CHAQUE
	--arrivee sur la carte (branche 'else'), et le fichier comptait 14
	--appels Anims:Add pour ZERO purge. Chaque retour au camp empilait
	--donc un feu de plus au meme endroit. On vide le calque avant de
	--redessiner : le decor est identique, mais il ne se duplique plus.
	mount_windswept_entrance_ch_5.BuildCampDay()

	--Apres une defaite en montagne, c'est PHILEAS qui se rapproche du
	--feu pour veiller sur les blesses. Ce bloc deplacait Rin — mais Rin
	--est partie avec la cordee de soutien et n'est plus sur la carte :
	--le TeleportTo s'appliquait a un `audino` desormais nil, donc a
	--rien du tout. Le camp reduit doit assumer ce role avec les trois
	--presents, pas avec un fantome.
	if SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind then
		pcall(function()
			GROUND:TeleportTo(noctowl, 276, 236, Direction.DownLeft)
		end)
	end
end

--for testing 
function mount_windswept_entrance_ch_5.SetParty()
	--Clean up the existing spawns, then call SetupGround to spawn them in.
	--Record the level of Hyko and Almotz for later use. Check to make sure they exist before doing so (mostly just so I can run this scene without needing them in the party)
	if GAME:GetPlayerPartyCount() > 2 then 
		SV.GuildSidequests.GrowlitheLevel = GAME:GetPlayerPartyMember(2).Level
		SV.GuildSidequests.ZigzagoonLevel = GAME:GetPlayerPartyMember(3).Level
	end
	
	--Default the party DESTRUCTIVELY to delete Hyko and Almotz.
	GeneralFunctions.DefaultParty(false, true)
	--reinitialize the hero and partner variables after respawning the party.
	--Failing to do this has later functions try to teleport the "old" versions of them, causing a phantom glitch. dunno why, since i thought i fixed default party...
	hero = CH('PLAYER')
	partner = CH('Teammate1')
	partner.CollisionDisabled = true
	
	--Setup Ganlon and Shuca.
	local cranidos_id = RogueEssence.Dungeon.MonsterID("cranidos", 0, "normal", Gender.Male)
	local cranidos_monster = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, cranidos_id, SV.GuildSidequests.CranidosLevel, "mold_breaker", 0)
	cranidos_monster.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	cranidos_monster.Nickname = CharacterEssentials.GetCharacterName('Cranidos', true)
	cranidos_monster.MetAt = "Adventurer's Guild"
	cranidos_monster.IsPartner = true
	cranidos_monster.IsFounder = true
	
	cranidos_monster:ReplaceSkill("headbutt", 0, true)
	cranidos_monster:ReplaceSkill("pursuit", 1, false)
	cranidos_monster:ReplaceSkill("iron_head", 2, true)
	cranidos_monster:ReplaceSkill("smack_down", 3, true)
		
	GAME:AddPlayerTeam(cranidos_monster)
	cranidos_monster:FullRestore()
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("GuildmateInteract")
    cranidos_monster.ActionEvents:Add(talk_evt)
	cranidos_monster:RefreshTraits()

	local mareep_id = RogueEssence.Dungeon.MonsterID("mareep", 0, "normal", Gender.Female)
	local mareep_monster = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mareep_id, SV.GuildSidequests.MareepLevel, "static", 0)
	mareep_monster.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	mareep_monster.Nickname = CharacterEssentials.GetCharacterName('Mareep', true)
	mareep_monster.MetAt = "Adventurer's Guild"
	mareep_monster.IsPartner = true
	mareep_monster.IsFounder = true
	
	mareep_monster:ReplaceSkill("thunder_shock", 0, true)
	mareep_monster:ReplaceSkill("thunder_wave", 1, false)
	mareep_monster:ReplaceSkill("take_down", 2, true)
	mareep_monster:ReplaceSkill("flatter", 3, false)
		
	GAME:AddPlayerTeam(mareep_monster)
	mareep_monster:FullRestore()
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("GuildmateInteract")
    mareep_monster.ActionEvents:Add(talk_evt)
	mareep_monster:RefreshTraits()
	
	
	--Assign importances to identify who they are. Do this instead of just checking species just in case randomizers down the road or something.
	local cTbl = LTBL(GAME:GetPlayerPartyMember(2))
	local mTbl = LTBL(GAME:GetPlayerPartyMember(3))
	
	cTbl.Importance = "Cranidos"
	mTbl.Importance = "Mareep"
end


function mount_windswept_entrance_ch_5.ArrivalCutscene()
	--It's already night when you arrive. Penticus is pacing around nervously wondering where you are before he realizes you're here
	--He runs up to hyko relieved and asks wtf happened. He went through the dungeon since it got late and you guys weren't here when he arrived.
	--You explain and he's super concerned that you had to fight an entire clan of Slugma.
	--He's impressed that you did it, and thanks the player team for doing a good job but he tells hyko that he pretty much had a panic attack wondering where he was and wants him to stay close for the rest of the expedition.
	--Hyko protests but eventually gives in seeing how worked up Penticus is. Penticus isn't acting entirely out of character, but obviously this is 
	--Phileas will explain at one point that the reason he and Penticus didn't find you when coming through the dungeon once it started late was probably because of how mystery dungeons shift. They're different everytime, it probably caused them to be brought a different way and so they didnt find you.
	
	--Partner at some point could say something like "I'd be really worked up too if something happened to player!". Player may be able to say something similar back. Could be laying it on too thick?

	--Later on, I was thinking of having Almotz/Rin/Coco kinda like, limp into camp after Windswept because they really struggled with it, and maybe they needed a save from Penticus for this, but this
	--may be a bit too drastic or rough on them. The expedition shouldn't be TOO depressing...


	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local tunnel = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('searing_tunnel')
	local steppe = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('vast_steppe')
	local mountain = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('mount_windswept')
	local ruins = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('cloven_ruins')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	--ARRIVEE PAR LE SUD. L'expedition debouche du sentier au bas de la
	--carte et remonte en ligne droite la colonne x=256, verifiee
	--praticable en continu de y=488 jusqu'au camp.
	--
	--BUG BLOQUANT CORRIGE : cette mise en place jouait ENTIEREMENT HORS
	--CARTE. Elle cadrait la camera en (256,524) et teleportait le duo en
	--(256,540) / (256,556), Hyko en (256,572) et Almotz en (256,588) —
	--alors que la carte ne mesure que 552x504 px, donc Y max 503.
	--
	--Origine de l'erreur, tracee dans l'historique : un lot precedent a
	--voulu ajouter une bande d'ocean « au sud, rows 78-80 » et a
	--rallonge la table `obstacles`. Or dans un .rsground `obstacles` est
	--indexe [x][y] : allonger la table du dessus agrandit la LARGEUR,
	--pas la hauteur. La carte est passee de 552x504 a 648x504 — 12
	--colonnes de plus a l'EST, aucune rangee de plus au sud — et les
	--2520 tuiles d'eau (tileset DuskBeach, une plage au crepuscule) se
	--sont retrouvees plaquees sur le flanc de la montagne. Le marqueur
	--d'entree du joueur avait suivi en Y=592, hors carte lui aussi.
	--La geometrie saine 552x504 a ete restauree et l'ocean retire.
	GAME:MoveCamera(256, 456, 1, false)
	--TRANSITION JOUR -> SOIR (Prompt Maitre 6.2). L'expedition arrive au
	--couchant : "dusk" d'abord (patron exact de l'arrivee au Tunnel), la
	--nuit noire ("darkness") ne tombe qu'au deploiement des couchages.
	GROUND:AddMapStatus("dusk")
	
	--for debug purposes
	GAME:FadeOut(false, 1)
	
	GROUND:TeleportTo(hero, 256, 456, Direction.Up)
	GROUND:TeleportTo(partner, 256, 472, Direction.Up)
	
	--------------------------------------------------------------------
	-- LE CAMP EXISTE AVANT NOUS.
	--------------------------------------------------------------------
	-- BUG D'IMMERSION CORRIGE. Les six membres du camp etaient crees SANS
	-- POSITION (« {'Tropius'} » tout court, donc en 0,0), laisses caches,
	-- puis reveles d'un bloc par une boucle Unhide au milieu de la scene.
	-- Le joueur voyait six Pokemon se materialiser d'un coup devant lui,
	-- alors qu'ils sont censes camper la depuis des heures.
	--
	-- Desormais ils sont POSES A LEUR PLACE des la creation, chacun a son
	-- occupation, et ils sont VISIBLES avant meme que le duo arrive. La
	-- montee du sentier se fait donc vers un camp deja vivant : c'est ce
	-- que fait un vrai Donjon Mystere, le lieu preexiste au heros.
	--
	-- Positions verifiees sol libre + connexes, hors emprise du feu
	-- (36x36 en 256,220), hors rocher de Kangaskhan (32x32 en 160,144),
	-- et espacees d'au moins 16 px (largeur de sprite) entre voisins.
	local audino, snubbull, girafarig, breloom, growlithe, zigzagoon, tropius, noctowl, mareep, cranidos = 
	CharacterEssentials.MakeCharactersFromList({
		{'Audino',    232, 258, Direction.UpRight},
		{'Snubbull',  300, 214, Direction.Left},
		{'Girafarig', 292, 276, Direction.Up},
		{'Breloom',   240, 276, Direction.Up},
		{'Growlithe', 240, 488, Direction.Up},
		{'Zigzagoon', 272, 488, Direction.Up},
		{'Tropius',   230, 190, Direction.DownRight},
		{'Noctowl',   288, 196, Direction.DownLeft},
		{'Mareep',    226, 232, Direction.Right},
		{'Cranidos',  310, 236, Direction.Left}
	})
	
	
	--LE CAMP DE JOUR. Aucune paillasse a l'arrivee (Prompt Maitre 6.3) :
	--les couchages ne sont deployes qu'a la fin de la veillee, sous le
	--fondu de la tombee de la nuit (CampNightfall, section 7). Ici :
	--feu + materiel range, via le constructeur partage qui purge le
	--calque (le doublement de decor d'avant ne peut plus se produire).
	mount_windswept_entrance_ch_5.BuildCampDay()

	--Ces deux repliques se jouent SOUS LE NOIR (FadeOut juste avant) :
	--aucun sprite n'est visible, donc aucun geste a jouer. C'est le seul
	--endroit de la carte ou l'immobilite est justifiee — on le note pour
	--que personne ne « corrige » ce faux positif plus tard.
	GAME:WaitFrames(40)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_001'], tunnel:GetColoredName()))
	GAME:WaitFrames(20)
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_002']))
	GAME:WaitFrames(20)
	
	GAME:FadeIn(40)
	
	--------------------------------------------------------------------
	-- LE CAMP VIT PENDANT QU'ON MONTE.
	--------------------------------------------------------------------
	-- Pendant toute la remontee du sentier, le camp continue ses
	-- occupations SANS savoir qu'on arrive : Coco s'affaire au feu, Rin
	-- range, Ganlon fait les cent pas, Penticus surveille la montagne.
	-- Le joueur voit donc un lieu deja habite, avec sa propre vie, avant
	-- d'y entrer — c'est exactement ce que fait un Donjon Mystere.
	--
	-- La boucle tourne en tache de fond et s'arrete d'elle-meme quand la
	-- montee est finie (verrou `campBusy`, meme patron `stopTalking` que
	-- la veillee). Tout est sous pcall : la vie de fond ne doit JAMAIS
	-- pouvoir interrompre l'arrivee du joueur.
	local campBusy = true
	local campLife = TASK:BranchCoroutine(function()
		while campBusy do
			pcall(function()
				GROUND:CharSetAnim(snubbull, "Idle", true)
				GROUND:CharSetEmote(snubbull, "happy", 0)
			end)
			GAME:WaitFrames(50)
			if not campBusy then break end
			pcall(function()
				GROUND:CharEndAnim(snubbull)
				GROUND:CharSetEmote(snubbull, "", 0)
				GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4)
			end)
			GAME:WaitFrames(40)
			if not campBusy then break end
			pcall(function()
				GROUND:CharAnimateTurnTo(cranidos, Direction.Left, 4)
				GROUND:CharSetAnim(audino, "Idle", true)
			end)
			GAME:WaitFrames(50)
			if not campBusy then break end
			pcall(function()
				GROUND:CharEndAnim(audino)
				GROUND:CharAnimateTurnTo(tropius, Direction.Up, 6)
			end)
			GAME:WaitFrames(60)
			if not campBusy then break end
			pcall(function()
				GROUND:CharAnimateTurnTo(tropius, Direction.DownRight, 6)
				GROUND:CharSetEmote(mareep, "happy", 0)
			end)
			GAME:WaitFrames(50)
			pcall(function() GROUND:CharSetEmote(mareep, "", 0) end)
			GAME:WaitFrames(30)
		end
		--Remise a plat : aucune animation de fond ne doit survivre a la
		--montee, sinon elle se superpose a l'accueil.
		pcall(function()
			GROUND:CharEndAnim(snubbull)
			GROUND:CharEndAnim(audino)
			GROUND:CharSetEmote(snubbull, "", 0)
			GROUND:CharSetEmote(mareep, "", 0)
		end)
	end)

	--LA MONTEE. File indienne du sud vers le camp, sans zigzag ; la
	--camera GLISSE avec la colonne (deux paliers longs, pas de saut).
	--Au bord sud du camp, la file s'ouvre en eventail sur 4 positions
	--verifiees libres.
	local coro1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(hero, 256, 316, false, 1)
		GROUND:MoveToPosition(hero, 240, 300, false, 1)
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	end)
	local coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		GROUND:MoveToPosition(partner, 256, 332, false, 1)
		GROUND:MoveToPosition(partner, 272, 300, false, 1)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	end)
	local coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(28)
		GROUND:MoveToPosition(growlithe, 256, 348, false, 1)
		GROUND:MoveToPosition(growlithe, 240, 328, false, 1)
		GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
	end)
	local coro4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(42)
		GROUND:MoveToPosition(zigzagoon, 256, 364, false, 1)
		GROUND:MoveToPosition(zigzagoon, 272, 328, false, 1)
		GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
	end)
	local coro5 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GAME:MoveCamera(256, 430, 150, false)
		GAME:MoveCamera(256, 310, 110, false)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	--La vie de fond s'arrete ICI : le camp a fini ses occupations, il va
	--maintenant reagir a l'arrivee. On joint la coroutine avant de
	--continuer pour qu'aucune animation cyclique ne se superpose a
	--l'accueil (sinon Coco continuerait de s'agiter en pleine scene).
	campBusy = false
	pcall(function() TASK:JoinCoroutines({campLife}) end)
	GAME:WaitFrames(20)

	--LA PREMIERE VUE DU SOMMET. Le partenaire leve la tete AVANT de
	--parler (le corps parle avant la bouche) ; Hyko le rejoint du
	--regard, puis lui repond. Avant, ces trois repliques tombaient sur
	--quatre sprites fixes qui regardaient tous dans la meme direction.
	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GeneralFunctions.EmoteAndPause(partner, "Sweating", true) end)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_003']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(18)
		pcall(function() GROUND:CharTurnToCharAnimated(growlithe, partner, 4) end)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(26)
		pcall(function() GROUND:CharTurnToCharAnimated(zigzagoon, partner, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	coro1 = TASK:BranchCoroutine(function()
		UI:SetSpeaker(growlithe)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_004']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(partner, growlithe, 4) end)
		GAME:WaitFrames(14)
		pcall(function() GROUND:CharTurnToCharAnimated(hero, growlithe, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	--Le partenaire se retourne vers le heros : la relance est pour lui.
	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_005']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	--------------------------------------------------------------------
	-- LE CAMP REMARQUE QU'ON ARRIVE.
	--------------------------------------------------------------------
	-- Les six sont deja en place et visibles depuis le debut de la scene
	-- (cf. MakeCharactersFromList plus haut) : plus aucun Unhide en bloc,
	-- plus aucun TeleportTo qui les ferait sauter d'un point a l'autre
	-- sous les yeux du joueur. Il ne reste donc ici qu'une chose a
	-- jouer — le moment ou ils LEVENT LA TETE.
	--
	-- Et ils ne la levent pas tous en meme temps : Penticus le premier
	-- (il guettait), Phileas ensuite, Shuca en dernier parce qu'elle
	-- etait occupee ailleurs. Trois temps decales, comme un vrai groupe.
	local camp1 = TASK:BranchCoroutine(function()
		GROUND:CharTurnToCharAnimated(tropius, hero, 4)
		GROUND:CharSetEmote(tropius, "notice", 1)
	end)
	local camp2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:CharTurnToCharAnimated(noctowl, hero, 4)
	end)
	local camp3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(18)
		GROUND:CharTurnToCharAnimated(audino, hero, 4)
	end)
	local camp4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(24)
		GROUND:CharTurnToCharAnimated(snubbull, hero, 4)
	end)
	local camp5 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(30)
		GROUND:CharTurnToCharAnimated(mareep, hero, 4)
		GROUND:CharSetEmote(mareep, "happy", 1)
	end)
	local camp6 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(36)
		GROUND:CharTurnToCharAnimated(cranidos, hero, 4)
	end)
	TASK:JoinCoroutines({camp1, camp2, camp3, camp4, camp5, camp6})

	--------------------------------------------------------------------
	-- L'ACCUEIL AU CAMP — quinze repliques, et personne ne bougeait.
	--------------------------------------------------------------------
	-- C'ETAIT LE PIRE PASSAGE DE LA CARTE. Mesure avant correction :
	-- ArrivalCutscene comptait 18 repliques dont 17 SANS la moindre
	-- reaction corporelle (94 %). Quinze boites de dialogue defilaient
	-- d'affilee devant huit sprites parfaitement immobiles, qui ne se
	-- tournaient meme pas vers celui qui parlait.
	--
	-- Les helpers Listen/Says de la veillee sont locaux a CampNightfall.
	-- On redefinit ici les memes, sur les variables locales de cette
	-- scene (tropius, noctowl... et non t.penticus, t.phileas...).
	local function ListenA(speaker, listeners, emote)
		if speaker == nil or listeners == nil then return end
		local turns = {}
		for i, who in ipairs(listeners) do
			if who ~= nil and who ~= speaker then
				turns[#turns+1] = TASK:BranchCoroutine(function()
					pcall(function()
						GAME:WaitFrames((i - 1) * 4)
						GROUND:CharTurnToCharAnimated(who, speaker, 4)
						if emote ~= nil then GROUND:CharSetEmote(who, emote, 1) end
					end)
				end)
			end
		end
		if #turns > 0 then pcall(function() TASK:JoinCoroutines(turns) end) end
	end
	local function SaysA(speaker, emotion, key, listeners, emote)
		ListenA(speaker, listeners, emote)
		UI:SetSpeaker(speaker)
		UI:SetSpeakerEmotion(emotion or "Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
	end

	local arrivals = {hero, partner, growlithe, zigzagoon}
	local campers  = {tropius, noctowl, audino, snubbull, mareep, cranidos}

	--Phileas s'inquiete : le camp entier se tourne vers lui.
	SaysA(noctowl, "Worried", 'MWE5_006', {tropius, audino, snubbull, mareep, cranidos})
	--Il enchaine, et c'est LE DUO qui reagit — la remarque les concerne.
	ListenA(noctowl, arrivals)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_007']))
	GAME:WaitFrames(12)

	--Penticus reprend la main. Tout le monde se tourne vers le maitre
	--de guilde : c'est lui qui tranche, la posture du camp le dit.
	SaysA(tropius, "Normal", 'MWE5_008',
	      {noctowl, audino, snubbull, mareep, cranidos, hero, partner, growlithe, zigzagoon})
	--Son inquietude : il baisse la tete vers le duo pendant qu'il parle.
	coro1 = TASK:BranchCoroutine(function()
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_009']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(tropius, hero, 4) end)
		GAME:WaitFrames(14)
		pcall(function() GROUND:CharSetEmote(audino, "sweatdrop", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(10)

	--Le partenaire repond, le heros appuie : les deux se font face, et
	--le camp les regarde. Le duo parle d'une seule voix, on le montre.
	coro1 = TASK:BranchCoroutine(function()
		SaysA(partner, "Determined", 'MWE5_010', campers)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	coro1 = TASK:BranchCoroutine(function()
		UI:SetSpeaker(hero)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_011']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
		GAME:WaitFrames(16)
		pcall(function() GeneralFunctions.DoAnimation(partner, 'Nod') end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(12)

	--Hyko s'enflamme (il rebondit), Ganlon le rabroue, Shuca s'illumine.
	--Trois temperaments, trois gestes differents — pas trois boites.
	coro1 = TASK:BranchCoroutine(function()
		SaysA(growlithe, "Happy", 'MWE5_012', {zigzagoon, mareep, cranidos})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		pcall(function() GeneralFunctions.Hop(growlithe) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	coro1 = TASK:BranchCoroutine(function()
		SaysA(cranidos, "Normal", 'MWE5_013', {growlithe, mareep})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		pcall(function() GROUND:CharSetEmote(growlithe, "sweatdrop", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(10)

	coro1 = TASK:BranchCoroutine(function()
		SaysA(mareep, "Happy", 'MWE5_014', {hero, partner, growlithe})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharSetEmote(mareep, "glowing", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(10)

	--Rin ramene tout le monde sur terre : elle s'avance vers le duo.
	SaysA(audino, "Worried", 'MWE5_015', {hero, partner, tropius})
	GAME:WaitFrames(12)

	SaysA(partner, "Happy", 'MWE5_016', {audino, snubbull})
	GAME:WaitFrames(12)

	--Le cri de ralliement de Penticus : le camp entier converge vers lui
	--et s'immobilise APRES avoir tourne — l'immobilite devient un choix
	--de mise en scene au lieu d'un oubli.
	ListenA(tropius, {noctowl, audino, snubbull, mareep, cranidos, growlithe,
	                  zigzagoon, hero, partner})
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Inspired")
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_017']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		pcall(function() GROUND:CharSetEmote(mareep, "glowing", 1) end)
		GAME:WaitFrames(8)
		pcall(function() GROUND:CharSetEmote(growlithe, "determined", 1) end)
		GAME:WaitFrames(8)
		pcall(function() GROUND:CharSetEmote(zigzagoon, "happy", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	SaysA(noctowl, "Normal", 'MWE5_018', {tropius, hero, partner})
	GAME:WaitFrames(12)

	--Le dernier echange du duo, en tete a tete : la camera est deja sur
	--eux, ils se tournent l'un vers l'autre et le camp s'efface.
	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_019']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	coro1 = TASK:BranchCoroutine(function()
		UI:SetSpeaker(hero)
		UI:SetSpeakerEmotion("Determined")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_020']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		pcall(function() GeneralFunctions.DoAnimation(partner, 'Nod') end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(tropius, "", 0)
	GAME:WaitFrames(20)

	--------------------------------------------------------------------
	-- LA VEILLEE — le camp mange, puis s'endort
	--------------------------------------------------------------------
	-- Avant, la scene s'arretait sur la derniere replique et coupait au
	-- noir : les douze paillasses restaient a l'ecran sans que personne
	-- ne s'en serve. Le joueur voyait un cercle de foin inexplique.
	--
	-- On montre donc ce a quoi elles servent. Trois temps, dans l'ordre
	-- ou ca se passe vraiment dans un bivouac : on partage le repas, la
	-- conversation retombe, chacun rejoint sa couche.
	mount_windswept_entrance_ch_5.CampNightfall(
		hero, partner, {penticus = tropius, phileas = noctowl,
		                rin = audino,      coco = snubbull,
		                shuca = mareep,    ganlon = cranidos,
		                hyko = growlithe,  almotz = zigzagoon,
		                reinier = girafarig, kino = breloom})

	GAME:FadeOut(false, 40)
	GAME:WaitFrames(40)
	for _, chara in ipairs({audino, snubbull, girafarig, breloom, growlithe, zigzagoon, tropius, noctowl, mareep, cranidos}) do
		GAME:GetCurrentGround():RemoveTempChar(chara)
	end

	--L'EQUIPE DU DONJON = LA CORDEE DU SOMMET. SetParty retire Hyko et
	--Almotz (restes du Tunnel) et cree Ganlon et Shuca en Teammate2/3.
	--C'etait le bug de coherence vu en jeu : la cinematique annoncait
	--une cordee, le donjon en donnait une autre. Patron du Tunnel :
	--l'echange d'equipe se fait DANS la cinematique d'arrivee.
	mount_windswept_entrance_ch_5.SetParty()
	hero = CH('PLAYER')
	partner = CH('Teammate1')

	SV.Chapter5.FinishedMountWindsweptIntro = true
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	--LA CAMERA REVIENT AU JOUEUR (bug vu en jeu : elle restait figee au
	--dernier plan de la cinematique). Forme attestee : searing_tunnel
	--_entrance_ch_5.lua:1480 « return camera control ».
	GAME:MoveCamera(0, 0, 1, true)
	SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
	GAME:FadeIn(40)

end 

--Ganlon hasn't been getting to act like a jerk much this expedition; give him some opportunies for his jerkiness to shine through here
--------------------------------------------------------------------
-- PNJ du camp de base — dialogues a variantes (Prompt Maitre §4.2)
-- Etats : avant l'entree / apres defaite / apres mini-boss / apres gardien.
--------------------------------------------------------------------

--Penticus (Tropius), Maitre de Guilde : la facade sereine se fissure
function mount_windswept_entrance_ch_5.Tropius_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	local hero = CH('PLAYER')
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Le sommet est ouvert.[pause=0] Vous avez fait ce qu'aucune équipe avant nous n'avait réussi.", "Happy")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Quand nous serons là-haut,[pause=10] restez près de moi.[pause=0] Quoi que nous y trouvions...[pause=10] nous le découvrirons ensemble.")
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("...Et si je vous semble inquiet,[pause=10] c'est que je le suis.[pause=0] Un bon chef ne ment pas à ses équipes sur ce point.")
	elseif SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "L'Aérodactyle vous a repoussés ?[pause=0] Ne baissez pas la tête.[pause=0] Ce gardien veille sur ce col depuis des générations.", "Normal")
		UI:WaitShowDialogue("Les anciens l'appelaient «[pause=5] la Serre du Ciel[pause=5] ».[pause=0] On disait qu'il ne laissait passer que ceux dont le cœur ne tremble pas.")
		UI:SetSpeakerEmotion("Determined")
		UI:WaitShowDialogue("Votre cœur ne tremble pas.[pause=0] Il apprend.[pause=0] Retournez-y quand vous serez prêts.")
	elseif SV.Chapter5.MountMiniBossDefeated then
		GeneralFunctions.StartConversation(chara, "La crête est franchie...[pause=0] Nous approchons du but,[pause=10] et je sens la montagne changer d'humeur.", "Worried")
		UI:WaitShowDialogue("Le vent ne souffle plus au hasard.[pause=0] Il tourne autour du sommet.[pause=10] Comme une sentinelle.")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Reposez-vous.[pause=0] Ce que nous cherchons est tout près maintenant,[pause=10] et il nous faudra toutes nos forces.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind then
		GeneralFunctions.StartConversation(chara, "Vous voilà.[pause=0] La montagne vous a renvoyés...[pause=10] C'est qu'elle vous a jugés trop pressés.", "Normal")
		UI:WaitShowDialogue("Ne vous battez pas contre le vent.[pause=0] Avancez quand il respire,[pause=10] abritez-vous quand il crie.[pause=0] C'est ainsi qu'on gravit le Mont Venteux.")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Mangez quelque chose avant de repartir.[pause=0] Un estomac vide rend le froid deux fois plus mordant.")
	else
		GeneralFunctions.StartConversation(chara, "Le dernier tronçon de notre expédition,[pause=10] " .. hero:GetDisplayName() .. ".[pause=0] Le Mont Venteux.", "Normal")
		UI:WaitShowDialogue("De là-haut,[pause=10] par temps clair,[pause=10] on voit toute la région d'un seul regard.[pause=0] La steppe,[pause=10] le tunnel,[pause=10] Metano...")
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Et depuis quelques nuits,[pause=10] on y voit aussi autre chose.[pause=0] Cette lueur,[pause=10] au sommet.[pause=0] C'est elle que nous sommes venus comprendre.")
	end
	GeneralFunctions.EndConversation(chara)
end

--Phileas (Noctowl) : l'erudit qui en sait plus qu'il ne dit
function mount_windswept_entrance_ch_5.Noctowl_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Hou...[pause=0] L'Aérodactyle s'est incliné.[pause=0] Voilà qui confirme une vieille théorie personnelle.", "Normal")
		UI:WaitShowDialogue("Les gardiens de cette région ne défendent pas un territoire.[pause=0] Ils défendent quelque chose DANS le territoire.[pause=0] Nuance capitale.")
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Ce que la lueur du sommet protège...[pause=10] ou ce dont elle se protège...[pause=0] nous le saurons très bientôt.[pause=0] Trop vite,[pause=10] peut-être.")
	elseif SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "Repoussés par le gardien ?[pause=0] Intéressant.[pause=0] Douloureux pour vous,[pause=10] mais intéressant.", "Normal")
		UI:WaitShowDialogue("Un Aérodactyle territorial attaque au premier contact.[pause=0] Celui-ci vous a laissés approcher AVANT de frapper.[pause=0] Il évalue.[pause=10] Il choisit.")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Montrez-lui une escouade digne de ce nom,[pause=10] et je pense qu'il vous ouvrira le ciel lui-même.")
	elseif SV.Chapter5.MountMiniBossDefeated then
		GeneralFunctions.StartConversation(chara, "Hou hou...[pause=0] Un Scorplane et une Airmure en binôme défensif.[pause=0] Vous rendez-vous compte ?", "Normal")
		UI:WaitShowDialogue("Deux espèces qui ne coopèrent JAMAIS à l'état sauvage.[pause=0] Sauf ici.[pause=0] Sauf maintenant.")
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Quelque chose au sommet réorganise les comportements de toute la faune locale.[pause=0] J'ai des hypothèses.[pause=0] Aucune ne me plaît.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind then
		GeneralFunctions.StartConversation(chara, "Le vent vous a eus,[pause=10] n'est-ce pas ?[pause=0] Ne vous en veuillez pas.[pause=0] Il a eu tout le monde,[pause=10] un jour ou l'autre.", "Normal")
		UI:WaitShowDialogue("Petit conseil d'un vieux voilier :[pause=10] les rafales suivent un cycle.[pause=0] Trois fortes,[pause=10] une faible.[pause=0] Comptez-les,[pause=10] et avancez sur la quatrième.")
	else
		GeneralFunctions.StartConversation(chara, "Ah,[pause=10] notre jeune équipe.[pause=0] Savez-vous que ce camp est bâti sur un ancien poste d'observation ?", "Normal")
		UI:WaitShowDialogue("Bien avant la guilde,[pause=10] des Pokémon montaient déjà ici pour étudier le ciel.[pause=0] Leurs archives mentionnent des «[pause=5] nuits où la montagne s'allume[pause=5] ».")
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("J'ai longtemps cru à une exagération poétique.[pause=0] Depuis que j'ai vu la lueur de mes propres yeux...[pause=10] je présente mes excuses posthumes à ces archivistes.")
	end
	GeneralFunctions.EndConversation(chara)
end

--Rin (Audino), soigneuse : douce, precise, un brin maternelle
function mount_windswept_entrance_ch_5.Audino_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Laissez-moi regarder...[pause=0] Pas de fracture,[pause=10] pas d'engelure.[pause=0] Vous m'impressionnez,[pause=10] vraiment.", "Happy")
		UI:WaitShowDialogue("Pour le sommet,[pause=10] je vous prépare un baume contre le froid.[pause=0] Recette de ma grand-mère.[pause=0] Ça sent affreusement fort,[pause=10] mais ça marche.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind or SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "Asseyez-vous près du feu.[pause=0] Tout de suite.[pause=0] Ce n'est pas une suggestion,[pause=10] c'est une prescription.", "Worried")
		UI:WaitShowDialogue("Vos coussinets sont gelés et vous tremblez encore.[pause=0] On ne repart pas dans cet état.")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("...Voilà.[pause=0] Buvez ça.[pause=0] Et la prochaine fois,[pause=10] revenez AVANT d'être à bout,[pause=10] pas après.")
	else
		GeneralFunctions.StartConversation(chara, "L'air est si sec,[pause=10] ici.[pause=0] Buvez régulièrement,[pause=10] même sans soif.[pause=0] Le froid déshydrate autant que le soleil.", "Normal")
		UI:WaitShowDialogue("J'ai installé mon infirmerie près du feu.[pause=0] Première tente à droite.[pause=0] En espérant ne voir personne y entrer,[pause=10] évidemment.")
	end
	GeneralFunctions.EndConversation(chara)
end

--Coco (Snubbull) : franche, râleuse, loyale
function mount_windswept_entrance_ch_5.Snubbull_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Vous avez battu le fossile volant ?[pause=0] Bon.[pause=0] Je retire officiellement la moitié de ce que je disais sur vous.", "Normal")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("La moitié seulement.[pause=0] L'autre moitié attend de voir ce que vous ferez au sommet.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind or SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "Ha ![pause=0] Vous aussi,[pause=10] le vent vous a fait valser ?[pause=0] Bienvenue au club.[pause=0] On a des badges.", "Normal")
		UI:WaitShowDialogue("Moi j'ai volé sur trois mètres au premier jour.[pause=0] TROIS mètres.[pause=0] Kino a ri pendant une heure.[pause=0] Je n'ai pas oublié,[pause=10] Kino.")
	else
		GeneralFunctions.StartConversation(chara, "Cette montagne est ridicule.[pause=0] Le vent,[pause=10] le froid,[pause=10] la pente...[pause=0] Qui a eu l'idée de mettre une expédition ICI ?", "Angry")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("...Oui,[pause=10] je sais,[pause=10] c'est le Maître de Guilde.[pause=0] Et oui,[pause=10] je le suivrais jusqu'en haut.[pause=0] Mais je RÂLERAI jusqu'en haut aussi.[pause=0] C'est mon droit le plus strict.")
	end
	GeneralFunctions.EndConversation(chara)
end

--Shuca (Mareep) : optimiste electrisante, un peu tete en l'air
function mount_windswept_entrance_ch_5.Mareep_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Vous sentez ?[pause=0] Ma laine crépite deux fois plus fort depuis qu'on approche du sommet !", "Happy")
		UI:WaitShowDialogue("Ganlon dit que c'est l'altitude.[pause=0] Moi je dis que la montagne est CONTENTE qu'on soit là.[pause=0] On verra qui a raison !")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind or SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "Oh,[pause=10] vous êtes tombés sur l'orage vous aussi ?[pause=0] Enfin,[pause=10] moi les orages,[pause=10] ça me recharge...", "Normal")
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Pardon.[pause=0] Ce n'était pas très solidaire.[pause=0] Tenez,[pause=10] touchez ma laine,[pause=10] ça réchauffe ![pause=0] Attention aux étincelles.[pause=0] Petit défaut de fabrication.")
	else
		GeneralFunctions.StartConversation(chara, "Ma laine n'a jamais été aussi gonflée ![pause=0] L'électricité statique de la montagne,[pause=10] c'est MERVEILLEUX !", "Happy")
		UI:WaitShowDialogue("Ganlon refuse de dormir à côté de moi maintenant.[pause=0] Il dit que je l'ai électrocuté dans son sommeil.[pause=0] C'était UNE fois.[pause=0] Une fois et demie.")
	end
	GeneralFunctions.EndConversation(chara)
end

--Ganlon (Cranidos) : fier, bourru, secretement protecteur envers Shuca
function mount_windswept_entrance_ch_5.Cranidos_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Alors c'est vous qui avez couché le fossile.[pause=0] Hmph.[pause=0] J'aurais pu le faire.[pause=10] Si on m'avait laissé y aller.", "Normal")
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("...Bon.[pause=0] D'accord.[pause=0] C'était du beau travail.[pause=0] Voilà.[pause=0] Je l'ai dit.[pause=0] N'en parlez à personne.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind or SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "Revenus en morceaux,[pause=10] hein.[pause=0] La montagne ne fait pas de cadeaux.[pause=0] C'est pour ça que je la respecte.", "Normal")
		UI:WaitShowDialogue("Un conseil de crâne dur à crâne mou :[pause=10] quand le vent charge,[pause=10] on ne recule pas.[pause=0] On se PLANTE.[pause=0] Tête baissée,[pause=10] pattes écartées.[pause=0] Le vent contourne ce qui ne cède pas.")
	else
		GeneralFunctions.StartConversation(chara, "Quoi ?[pause=0] Non,[pause=10] je ne «[pause=5] surveillais[pause=5] » pas Shuca.[pause=0] Je surveillais le périmètre.[pause=0] Elle était DANS le périmètre.[pause=0] Nuance.", "Angry")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("...Cette montagne rend sa laine complètement folle.[pause=0] Si elle se colle au mauvais rocher,[pause=10] elle va se retrouver soudée.[pause=0] Quelqu'un doit bien y penser à sa place.")
	end
	GeneralFunctions.EndConversation(chara)
end

--Kino (Breloom) : blagueur, jamais fatigue... en apparence
function mount_windswept_entrance_ch_5.Breloom_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Le gardien est battu ?[pause=0] Parfait,[pause=10] parfait.[pause=0] J'allais m'en occuper,[pause=10] mais je vous l'ai laissé.[pause=0] Par générosité.", "Happy")
		UI:WaitShowDialogue("Sérieusement :[pause=10] chapeau.[pause=0] Et gardez cette énergie pour le sommet.[pause=0] J'ai comme l'impression que le plus étrange reste à venir.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind or SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "Vous savez ce qu'on dit :[pause=10] ce qui ne vous emporte pas vous rend plus lourd ![pause=0] ...Non ?[pause=0] Ce n'est pas ça ?", "Happy")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Entre nous,[pause=10] j'ai fait le même vol plané hier.[pause=0] Coco a ri.[pause=0] Fort.[pause=0] Alors je vous propose un pacte :[pause=10] on ne rit de personne,[pause=10] et tout le monde garde sa dignité.")
	else
		GeneralFunctions.StartConversation(chara, "Un camp,[pause=10] un feu,[pause=10] des rations...[pause=0] Il ne manque qu'une chose :[pause=10] quelqu'un qui sait raconter les histoires.[pause=0] Ça tombe bien,[pause=10] je suis là.", "Happy")
		UI:WaitShowDialogue("Ce soir :[pause=10] «[pause=5] La légende de la Serre du Ciel[pause=5] ».[pause=0] Véridique à quarante pour cent.[pause=0] Les soixante autres,[pause=10] c'est du talent.")
	end
	GeneralFunctions.EndConversation(chara)
end

--Reinier (Girafarig) : le veteran calme qui pense a l'arriere-garde
function mount_windswept_entrance_ch_5.Girafarig_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		if not SV.Chapter5.LegendSkyArbiterHeard then
			GeneralFunctions.StartConversation(chara, "Le col est sécurisé.[pause=0] Demain,[pause=10] le sommet.[pause=0] Et cette lumière...", "Normal")
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("...Vous savez,[pause=10] avant d'être escorteur,[pause=10] j'ai servi sur les routes du grand Est.[pause=0] Et là-bas,[pause=10] les caravaniers racontent une histoire sur ce qui vit AU-DESSUS du ciel.")
			UI:ResetSpeaker()
			UI:ChoiceMenuYesNo("Écouter l'histoire de Reinier ?", false)
			UI:WaitForChoice()
			if UI:ChoiceResult() then
				mount_windswept_entrance_ch_5.LegendOfTheSkyArbiter(chara)
				return
			end
			GeneralFunctions.EndConversation(chara)
			return
		end
		GeneralFunctions.StartConversation(chara, "Le col est sécurisé.[pause=0] Je fais passer le mot aux équipes restées en arrière :[pause=10] la voie du retour est balisée.", "Normal")
		UI:WaitShowDialogue("Quoi qu'il arrive là-haut,[pause=10] sachez qu'on tiendra le camp.[pause=0] Vous aurez toujours un feu où revenir.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind or SV.Chapter5.MountGuardianLost then
		GeneralFunctions.StartConversation(chara, "Mon arrière-tête vous a vus arriver de loin.[pause=0] Pratique,[pause=10] un deuxième cerveau,[pause=10] pour surveiller les retours difficiles.", "Normal")
		UI:WaitShowDialogue("Il dit que vous reviendrez plus forts.[pause=0] Mon arrière-tête ne se trompe jamais sur ces choses-là.[pause=0] Sur le reste,[pause=10] souvent.[pause=0] Mais pas sur ça.")
	else
		GeneralFunctions.StartConversation(chara, "Depuis ce poste,[pause=10] je couvre les deux sentiers du camp.[pause=0] Vieille habitude d'escorte.", "Normal")
		UI:WaitShowDialogue("Un conseil :[pause=10] au sommet,[pause=10] ne vous fiez pas à vos yeux.[pause=0] Le vent y transporte des sons de très loin.[pause=0] Fiez-vous à vos oreilles.")
	end
	GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- LÉGENDE : « L'Arbitre du Ciel » (Reinier, veteran des caravanes)
-- Mentions : Rayquaza (l'Arbitre, nomme a la fin seulement), Kyogre et
-- Groudon evoques comme « la mer et la terre en guerre ». Motif New Era :
-- l'Arbitre n'intervient que si le ciel est franchi — echo au Fragment
-- (Meteno) tombe pres du relais, et prefiguration lointaine du lore
-- Fil du Destin reserve a l'arc Jirachi.
-- OST : Sky Peak Cave -> Rising Fear (bref) -> retour.
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.LegendOfTheSkyArbiter(chara)
	local hero = CH('PLAYER')
	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(50)
	SOUND:PlayBGM('Sky Peak Cave.ogg', true)
	GAME:WaitFrames(30)

	--Le conteur prend son public : il se tourne vers le heros, marque un
	--temps, PUIS commence. Une legende ne se recite pas de dos.
	pcall(function() GROUND:CharTurnToCharAnimated(chara, hero, 4) end)
	GAME:WaitFrames(16)
	UI:SetSpeaker(chara)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("On raconte...[pause=20] qu'il y a très longtemps,[pause=10] la mer et la terre se sont fait la guerre.")
	UI:WaitShowDialogue("La mer voulait tout recouvrir.[pause=0] La terre voulait tout soulever.[pause=0] Les tempêtes ont duré si longtemps que les Pokémon oubliaient la couleur du ciel calme.")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(chara, "glowing", 1)
	UI:WaitShowDialogue("Et quand tout semblait perdu...[pause=10] QUELQUE CHOSE est descendu de plus haut que les nuages.[pause=0] De plus haut que le haut.")
	UI:WaitShowDialogue("Un serpent de jade,[pause=10] long comme un fleuve,[pause=10] qui vit là où l'air s'arrête.[pause=0] Il n'a pas pris parti.[pause=0] Il a JUGÉ.[pause=0] Et la mer et la terre se sont tues.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Les caravaniers l'appellent l'Arbitre du Ciel.[pause=0] Les archives lui donnent un nom :[pause=10] [color=#00C060]Rayquaza[color].")

	-- Bref frisson : le lien avec le present.
	SOUND:FadeOutBGM(30)
	GAME:WaitFrames(30)
	SOUND:PlayBGM('Rising Fear.ogg', true)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Il ne descend JAMAIS pour les querelles du sol.[pause=0] Une seule chose le fait bouger :[pause=10] quand quelque chose FRANCHIT son ciel.[pause=0] Dans un sens...[pause=20] ou dans l'autre.")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Quelque chose qui franchit le ciel...[pause=0] Le Météno est tombé.[pause=0] Et la lumière du sommet,[pause=10] elle,[pause=10] cherche peut-être à monter.)", "Worried")

	--Il redescend de sa legende et revient sur le heros : le ton change,
	--la posture aussi.
	pcall(function() GROUND:CharSetEmote(chara, "", 0) end)
	pcall(function() GROUND:CharTurnToCharAnimated(chara, hero, 4) end)
	UI:SetSpeaker(chara)
	SOUND:FadeOutBGM(30)
	GAME:WaitFrames(30)
	SOUND:PlayBGM('Canyon Camp.ogg', true)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Mon arrière-tête n'aime pas cette histoire.[pause=0] Il ne l'a jamais aimée.[pause=0] Mais il insiste toujours pour que je la raconte aux équipes qui montent.")
	UI:WaitShowDialogue("Allez dormir.[pause=0] Et là-haut...[pause=10] quoi que vous voyiez dans le ciel,[pause=10] saluez-le poliment.[pause=0] On ne sait jamais qui regarde.")

	SV.Chapter5.LegendSkyArbiterHeard = true
	GeneralFunctions.EndConversation(chara)
end

--Hyko (Growlithe) et Almotz (Zigzaton) : membres de l'equipe au camp
function mount_windswept_entrance_ch_5.Growlithe_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Le sommet nous attend,[pause=10] wouf ![pause=0] J'ai vérifié trois fois mon équipement.[pause=0] Puis une quatrième,[pause=10] par acquit de conscience.", "Determined")
		UI:WaitShowDialogue("Le Maître de Guilde veut que je reste près de lui là-haut.[pause=0] Alors...[pause=10] soyez prudents.[pause=0] C'est un ordre.[pause=0] Enfin,[pause=10] une demande.[pause=0] Une demande TRÈS appuyée,[pause=10] wouf.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind then
		GeneralFunctions.StartConversation(chara, "Vous êtes rentrés ![pause=0] Wouf ![pause=0] J'allais organiser une patrouille de secours.[pause=0] J'avais déjà l'itinéraire.[pause=0] En trois exemplaires.", "Worried")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Reposez-vous.[pause=0] La montagne sera encore là demain.[pause=0] Et nous aussi,[pause=10] wouf.")
	else
		GeneralFunctions.StartConversation(chara, "Ce feu de camp est réglementaire à quatre-vingt-quinze pour cent,[pause=10] wouf.[pause=0] Les cinq pour cent manquants me tourmentent.", "Normal")
		UI:WaitShowDialogue("Almotz dit que je devrais «[pause=5] lâcher prise[pause=5] ».[pause=0] J'ai demandé si c'était une procédure officielle.[pause=0] Il a soupiré très fort.")
	end
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Zigzagoon_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	if SV.Chapter5.MountGuardianDefeated then
		GeneralFunctions.StartConversation(chara, "Le dernier tronçon...[pause=0] On y est presque.[pause=0] Après ça,[pause=10] on rentre TOUS à la maison.", "Determined")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("J'ai ramassé un caillou du col pour chacun des petits.[pause=0] Sept cailloux.[pause=0] Mon sac pèse une tonne et je regrette rien.")
	elseif SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind then
		GeneralFunctions.StartConversation(chara, "Vous avez une mine affreuse.[pause=0] Venez,[pause=10] j'ai gardé de la soupe au chaud près du feu.", "Worried")
		UI:WaitShowDialogue("C'est la recette de ma mère.[pause=0] Enfin,[pause=10] presque :[pause=10] il manque trois ingrédients sur cinq.[pause=0] Mais l'intention y est,[pause=10] et l'intention réchauffe.")
	else
		GeneralFunctions.StartConversation(chara, "La montagne,[pause=10] c'est pas mon élément.[pause=0] Trop de cailloux,[pause=10] pas assez de terre meuble.[pause=0] Où est-ce qu'on creuse,[pause=10] ici ?!", "Normal")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Mais la vue,[pause=10] par contre...[pause=0] La vue,[pause=10] je l'emporterais bien à la maison.[pause=0] Avec un caillou ou deux.[pause=0] Pour les petits.")
	end
	GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- CINÉMATIQUE ÉMOTIONNELLE — « Ce que le vent a emporté »
-- Le secret Hyko × Penticus, en paiement de la dette narrative posée
-- au Tunnel (« ce n'est pas mon histoire » — Phileas). Surprise nocturne :
-- le joueur, sorti prendre l'air, surprend une conversation qu'il
-- n'aurait pas dû entendre. Penticus revele pourquoi il protege Hyko :
-- le pere de Hyko etait son coequipier — mort en le sauvant, sur CETTE
-- montagne, il y a 25 ans (la nuit de la derniere grande catastrophe).
-- Foreshadowing : « la montagne s'etait allumee cette nuit-la aussi ».
-- Courage/sacrifice : le coeur thematique du jeu, incarne 20 chapitres
-- avant que le heros n'ait a faire le meme choix.
-- OST : silence -> On the Beach at Dusk -> Sympathy.
-- Declencheur : nuit au camp du Mont, apres le gardien, apres la veillee.
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.WindSecretScene()
	local hero = CH('PLAYER')
	local tropius = CH('Tropius')
	--Hyko est reste au camp de base (garde par Penticus) : c'est le PNJ
	--'Growlithe' pose par SetupGround, plus un Teammate.
	local growlithe = CH('Growlithe')
	if tropius == nil or growlithe == nil then GAME:FadeIn(20) return end

	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	GROUND:AddMapStatus("darkness")

	-- Le heros se reveille seul ; deux silhouettes au bord du camp.
	-- (Penticus etait pose en (352,200), case NON praticable — verifie
	-- sur la grille d'obstacles : Tags ~= 0. Descendu en (352,216).)
	GROUND:TeleportTo(hero, 256, 340, Direction.Up)
	GROUND:TeleportTo(tropius, 352, 216, Direction.Down)
	GROUND:TeleportTo(growlithe, 352, 240, Direction.Up)
	GAME:MoveCamera(256, 320, 1, false)

	GAME:FadeIn(60)
	GAME:WaitFrames(40)

	GeneralFunctions.HeroDialogue(hero, "(Impossible de dormir...[pause=0] Ce vent n'arrête jamais.[pause=20] ...Tiens ?[pause=0] Des voix ?)", "Normal")
	GAME:WaitFrames(20)

	-- Le heros s'approche sans etre vu ; la camera glisse vers les deux autres.
	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 300, 290, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, 90, 340, 230) end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(30)

	SOUND:PlayBGM('On the Beach at Dusk.ogg', true)
	GAME:WaitFrames(30)

	--LA SCENE LA PLUS INTIME DE LA CARTE — et les deux personnages ne se
	--regardaient jamais. Corrige ici temps par temps : chaque changement
	--de locuteur s'accompagne du geste qui va avec, et les DEUX SILENCES
	--(".........") sont joues comme des silences — Penticus se detourne
	--vers la montagne avant de repondre, Hyko encaisse avant de parler.
	GROUND:CharTurnToCharAnimated(growlithe, tropius, 4)
	GAME:WaitFrames(10)
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("...Maître,[pause=10] avec tout mon respect,[pause=10] je dois vous le demander.[pause=0] Pourquoi moi ?")

	--Penticus ne se retourne pas tout de suite : il sait ce qui vient.
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue("Vous m'avez gardé près de vous tout le voyage.[pause=0] Vous avez paniqué quand on a eu du retard au Tunnel.[pause=0] Les autres recrues n'ont pas ce traitement,[pause=10] wouf.")
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		pcall(function() GROUND:CharSetEmote(tropius, "sweatdrop", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue("Je ne suis pas en sucre.[pause=0] Je suis un garde de la guilde.[pause=0] Alors...[pause=10] pourquoi ?")
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		pcall(function() GROUND:CharTurnToCharAnimated(tropius, growlithe, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	--LE SILENCE. Penticus se detourne vers la montagne : c'est la qu'est
	--son mort. Le geste dit ce que la boite ne dit pas encore.
	GAME:WaitFrames(40)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(".........")
	end)
	coro2 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharAnimateTurnTo(tropius, Direction.Up, 6) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(40)

	--Il revient sur Hyko pour la phrase qui bascule tout.
	GROUND:CharTurnToCharAnimated(tropius, growlithe, 4)
	GAME:WaitFrames(12)
	UI:WaitShowDialogue("...Tu as ses yeux,[pause=10] tu sais.")

	GeneralFunctions.EmoteAndPause(growlithe, "Question", true)
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("...Les yeux de qui,[pause=10] Maître ?")

	GAME:WaitFrames(30)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Il y a vingt-cinq ans,[pause=10] j'avais un coéquipier.[pause=0] Un Arcanin.[pause=0] La tête brûlée la plus loyale que cette guilde ait jamais comptée.")

	--« Cette montagne s'etait ALLUMEE » : il la regarde en le disant, et
	--Hyko suit son regard. Deux tetes qui se levent vers le sommet.
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue("Cette nuit-là...[pause=10] le monde entier tremblait.[pause=0] La dernière des grandes catastrophes.[pause=0] Et cette montagne...[pause=20] cette montagne s'était ALLUMÉE,[pause=10] exactement comme aujourd'hui.")
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(30)
		pcall(function() GROUND:CharAnimateTurnTo(tropius, Direction.Up, 6) end)
		GAME:WaitFrames(20)
		pcall(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 6) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	UI:WaitShowDialogue("Nous sommes montés tous les deux.[pause=0] Jeunes.[pause=0] Invincibles.[pause=0] Persuadés que le monde avait besoin de nous...[pause=10] et il avait besoin de nous.")
	GAME:WaitFrames(30)

	--La chute. Le corps parle avant la bouche : Penticus flanche PUIS
	--raconte la corniche.
	UI:SetSpeakerEmotion("Pain")
	coro1 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		UI:WaitShowDialogue("Une corniche a cédé sous moi,[pause=10] près du sommet.[pause=0] Il m'a rattrapé.[pause=0] Il m'a HISSÉ.[pause=0] Et le temps que je me retourne...")
	end)
	coro2 = TASK:BranchCoroutine(function()
		pcall(function() GeneralFunctions.Shake(tropius) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(40)

	--« ...le vent l'avait emporte. » Un souffle passe sur les deux.
	pcall(function() SOUND:PlayBattleSE('EVT_Battle_Flash') end)
	pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end)
	UI:WaitShowDialogue("...le vent l'avait emporté.[pause=0] Voilà ce que le vent a pris,[pause=10] cette nuit-là.[pause=0] Le meilleur d'entre nous.[pause=0] Ton père,[pause=10] Hyko.")

	--LE CHOC. Hyko encaisse physiquement avant d'articuler : il recule
	--d'un pas (Shake), l'emote tombe, PUIS la phrase sort.
	GAME:WaitFrames(50)
	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(growlithe, tropius, 4) end)
		pcall(function() GeneralFunctions.Shake(growlithe) end)
	end)
	coro2 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharSetEmote(growlithe, "shock", 1) end)
		pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(25)

	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("Mon...[pause=20] mon père ?[pause=0] Mais...[pause=10] on m'a toujours dit qu'il était mort en mission de routine...")

	--L'aveu. Penticus ne soutient pas son regard en le disant.
	coro1 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		UI:SetSpeaker(tropius)
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("C'est moi qui ai demandé qu'on te dise ça.[pause=0] Un petit ne devrait pas grandir en sachant que son père est mort pour une corniche...[pause=10] et pour un imbécile qui marchait dessus.")
	end)
	coro2 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharAnimateTurnTo(tropius, Direction.Down, 6) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(30)

	--Et il releve la tete pour la promesse. Le geste EST la promesse.
	GROUND:CharTurnToCharAnimated(tropius, growlithe, 4)
	GAME:WaitFrames(14)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Alors oui.[pause=0] Je te garde près de moi.[pause=0] Pas parce que tu es fragile,[pause=10] Hyko.[pause=0] Parce que je lui dois de te ramener.[pause=0] De CHAQUE expédition.[pause=0] Jusqu'à ma dernière.")

	-- Sympathy : la reponse de Hyko. Courage, pas larmes.
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(40)
	SOUND:PlayBGM('Sympathy.ogg', true)
	GAME:WaitFrames(30)

	--LE SECOND SILENCE. Hyko baisse la tete, encaisse, et c'est en
	--RELEVANT la tete qu'il repond — le redressement precede la
	--determination, il ne la commente pas.
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Teary-Eyed")
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(".........")
	end)
	coro2 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Down, 6) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(40)

	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(growlithe, tropius, 4) end)
		pcall(function() GROUND:CharSetEmote(growlithe, "determined", 1) end)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		UI:SetSpeakerEmotion("Determined")
		UI:WaitShowDialogue("...Merci de me l'avoir dit,[pause=10] Maître.[pause=0] Mais je vais vous demander une chose,[pause=10] et c'est la dernière fois que je la demanderai.")
	end)
	TASK:JoinCoroutines({coro1, coro2})

	--« Ne me protegez plus DE la montagne » : il se tourne vers elle.
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue("Ne me protégez plus DE la montagne.[pause=0] Apprenez-moi à la gravir.[pause=0] C'est comme ça qu'on honore ceux que le vent a pris,[pause=10] wouf.")
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(24)
		pcall(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 6) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GROUND:CharTurnToCharAnimated(growlithe, tropius, 4) end)
		UI:WaitShowDialogue("Pas en gardant leurs enfants au camp.[pause=0] En en faisant des Pokémon...[pause=10] que le vent n'emporte pas.")
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		pcall(function() GROUND:CharSetEmote(tropius, "notice", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(50)
	coro1 = TASK:BranchCoroutine(function()
		UI:SetSpeaker(tropius)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("...Tu as sa voix aussi,[pause=10] finalement.[pause=0] D'accord,[pause=10] Hyko.[pause=0] D'accord.")
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(18)
		pcall(function() GeneralFunctions.DoAnimation(tropius, 'Nod') end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	-- Le heros se retire sans bruit.
	GAME:WaitFrames(40)
	GeneralFunctions.PanCamera()
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Je n'aurais pas dû entendre ça.[pause=0] Mais je ne l'oublierai jamais.[pause=20] Il y a vingt-cinq ans...[pause=10] la montagne s'était déjà allumée.[pause=0] La nuit de la dernière grande catastrophe.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Ce n'est pas la première fois.[pause=0] Tout ça est déjà arrivé.[pause=0] Et quelqu'un est déjà mort là-haut...[pause=10] pour que quelqu'un d'autre vive.)", "Sad")

	GAME:WaitFrames(40)
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	GAME:WaitFrames(30)

	GROUND:RemoveMapStatus("darkness")
	SV.Chapter5.WindSecretSceneSeen = true
	GAME:CutsceneMode(false)
	--La camera revient au joueur (forme attestee : searing_tunnel:1480).
	GAME:MoveCamera(0, 0, 1, true)
	SOUND:PlayBGM('Mt. Travail.ogg', true)
	GAME:FadeIn(40)
end
