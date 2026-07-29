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
function mount_windswept_entrance_ch_5.CampNightfall(hero, partner, t)
	local B = mount_windswept_entrance_ch_5.BEDS
	local mountain = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('mount_windswept')
	local ruins = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('cloven_ruins')

	--LE CERCLE DU REPAS N'EST PAS LE CERCLE DES COUCHAGES.
	local MEAL = {
		{t.penticus, 284, 158, Direction.Down},
		{t.phileas,  318, 176, Direction.DownLeft},
		{t.coco,     338, 210, Direction.Left},
		{t.ganlon,   338, 248, Direction.Left},
		{t.reinier,  320, 282, Direction.UpLeft},
		{t.kino,     286, 302, Direction.Up},
		{hero,       248, 302, Direction.Up},
		{partner,    214, 284, Direction.UpRight},
		{t.hyko,     194, 250, Direction.Right},
		{t.almotz,   194, 212, Direction.Right},
		{t.shuca,    212, 178, Direction.DownRight},
		{t.rin,      246, 158, Direction.Down},
	}

	--ATTRIBUTION DES COUCHAGES — elle raconte quelque chose.
	--Le fer a cheval s'ouvre au SUD : c'est par la qu'on arrive et qu'on
	--repart, personne ne dort en travers du sentier. Les couches sont
	--numerotees dans le sens horaire depuis le nord (1 = plein nord,
	--2 a 7 = flanc est, 8 = sud-est en bout de file, 9 a 12 = flanc
	--ouest).
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
	--  * PHILEAS N'A PAS DE PAILLASSE, ET C'EST VOULU. Il prend le
	--    premier tour de garde : il monte au nord du camp et y reste
	--    debout toute la nuit. Lui attribuer une couche qu'il n'occupe
	--    jamais laissait un couchage VIDE au milieu du cercle pendant
	--    toute la veillee, le reve et le reveil — un lit de trop pour
	--    onze dormeurs. C'est PENTICUS qui prend la couche 2, la sienne
	--    reste la 1 : le maitre de guilde dort plein nord, entre les
	--    dormeurs et la porte du donjon.
	--    Conséquence directe : la table BEDS ne compte plus que ONZE
	--    couchages (voir sa definition). DeployBeds n'en pose que onze,
	--    donc plus aucune paillasse inutilisee a l'ecran.
	--Le +13/+10 place le sprite au centre de la paillasse (patron Tunnel).
	--COUCHAGES ALIGNES SUR LES PLACES DE TABLE (voir MEAL ci-dessus).
	--Chacun dort face au foyer, a 49 px maximum de l'endroit ou il a
	--mange. Les directions sont calculees depuis l'angle reel vers le
	--centre (274,238), pas posees a la main.
	local seats = {
		{t.penticus, 2,  Direction.DownLeft},
		{t.coco,     3,  Direction.DownLeft},
		{t.ganlon,   4,  Direction.Left},
		{t.reinier,  5,  Direction.Left},
		{partner,    8,  Direction.UpRight},
		{hero,       7,  Direction.UpRight},
		{t.hyko,     9,  Direction.Right},
		{t.almotz,   11, Direction.Right},
		{t.shuca,    10, Direction.Right},
		{t.rin,      1,  Direction.Down},
		{t.kino,     6,  Direction.UpLeft},
	}
	local function seatX(i) return B[i][1] + 13 end
	local function seatY(i) return B[i][2] + 10 end

	-- LE CAMP ECOUTE — un cercle vivant, pas douze statues.
	-- Mesure faite sur cette scene avant correction : 68 repliques, dont
	-- 22 (32 %) ou AUCUN personnage ne bougeait dans les six lignes
	-- precedentes. Le joueur voyait des boites de dialogue s'enchainer
	-- devant un cercle immobile.
	-- Les deux helpers ci-dessous rendent l'ecoute automatique :
	--   Listen(parleur, {auditeurs}, emote)
	--     Les auditeurs se tournent vers celui qui parle, EN DECALE
	--     (4 frames d'ecart) : un groupe qui pivote d'un seul bloc a
	--     l'air mecanique. C'est la regle deja appliquee aux departs
	--     de la scene, on l'etend a l'ecoute.
	--   Says(parleur, emotion, cle, {auditeurs}, emote)
	--     Regroupe « le corps parle avant la bouche » (grammaire du
	--     projet, §4.6) : on tourne les tetes, PUIS on affiche la boite.
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

	-- 1. KINO ET REINIER REJOIGNENT LE CAMP
	--Ils fermaient la marche sur le sentier. Leur arrivee complete
	--l'expedition : les 12 paillasses ont enfin leurs 12 dormeurs.
	GROUND:Unhide(t.kino.EntName)
	GROUND:Unhide(t.reinier.EntName)
	GROUND:TeleportTo(t.kino, 236, 396, Direction.Up)
	GROUND:TeleportTo(t.reinier, 276, 396, Direction.Up)

	-- TOUT LE CAMP LES REGARDE ARRIVER, ET LES SUIT DU REGARD.
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	local greetKino = {}
	--Ceux qui reagissent VIVEMENT : Coco (elle a garde le repas au
	--chaud), Shuca (elle s'inquietait), Rin (elle compte ses blesses).
	for i, r in ipairs({{t.coco, "exclaim"}, {t.shuca, "happy"}, {t.rin, "notice"}}) do
		greetKino[#greetKino+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames((i - 1) * 6)
			pcall(function()
				GROUND:CharTurnToCharAnimated(r[1], t.kino, 4)
				GROUND:CharSetEmote(r[1], r[2], 1)
			end)
		end)
	end
	--Les autres se contentent de lever la tete, un peu plus tard.
	for i, who in ipairs({partner, hero, t.penticus, t.phileas, t.hyko, t.almotz, t.ganlon}) do
		greetKino[#greetKino+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(10 + (i - 1) * 4)
			pcall(function() GROUND:CharTurnToCharAnimated(who, t.kino, 4) end)
		end)
	end
	TASK:JoinCoroutines(greetKino)
	GAME:WaitFrames(10)

	--LE SUIVI DU REGARD pendant toute la remontee. Ces coroutines
	--tournent EN MEME TEMPS que les deplacements de Kino et Reinier
	--(lances juste apres) : chaque tete pivote au fil de leur avancee.
	--Elles s'arretent d'elles-memes quand la cible cesse de bouger.
	--Declares ICI parce que le reste de la scene les reutilise sans le
	--mot-cle `local` : sans cette declaration, coro1..coro4 deviendraient
	--des GLOBALES fuyant hors de la fonction (le bloc qui les declarait
	--a ete remplace par les regards ci-dessus).
	local coro1, coro2, coro3, coro4
	local watch = {}
	for _, who in ipairs({t.coco, t.shuca, t.rin, t.penticus}) do
		watch[#watch+1] = TASK:BranchCoroutine(function()
			pcall(function() GeneralFunctions.FaceMovingCharacter(who, t.kino, 4) end)
		end)
	end
	for _, who in ipairs({partner, hero, t.almotz}) do
		watch[#watch+1] = TASK:BranchCoroutine(function()
			pcall(function() GeneralFunctions.FaceMovingCharacter(who, t.reinier, 4) end)
		end)
	end
	-- ILS CONTOURNENT LE DUO, ILS NE LE TRAVERSENT PAS.
	local coro5 = TASK:BranchCoroutine(function()
		--Trois segments, le dernier fusionne : (216,308) puis (208,300)
		--ne faisait que 8 px et produisait un sautillement d'arrivee.
		GROUND:MoveToPosition(t.kino, 216, 372, false, 1)
		GROUND:MoveToPosition(t.kino, 208, 300, false, 1)
		GROUND:CharTurnToCharAnimated(t.kino, hero, 4)
	end)
	local coro6 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:MoveToPosition(t.reinier, 312, 380, false, 1)
		GROUND:MoveToPosition(t.reinier, 304, 300, false, 1)
		GROUND:CharTurnToCharAnimated(t.reinier, hero, 4)
	end)
	--On joint les deux marcheurs ET les regards qui les suivent : les
	--coroutines de suivi s'arretent d'elles-memes quand la cible cesse
	--de bouger, mais il faut les attendre pour ne pas les laisser
	--tourner par-dessus la replique suivante.
	TASK:JoinCoroutines({coro5, coro6})
	pcall(function() TASK:JoinCoroutines(watch) end)

	GAME:WaitFrames(10)
	UI:SetSpeaker(t.kino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_021']))
	GAME:WaitFrames(15)
	--Reinier repond a Kino : les deux se font face, le camp les regarde
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

	-- 2. LE DINER — tout le monde s'installe autour du feu
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_023']))
	UI:SetCenter(false)
	UI:ResetSpeaker()

	-- ON GAGNE SA PLACE SANS TRAVERSER PERSONNE.
	local MEAL_ROUTES = {
		{t.penticus, {{260,192},{284,158}}, Direction.Down},
		{t.shuca,    {{230,168},{212,178}}, Direction.DownRight},
		{t.rin,      {{188,232},{228,192},{228,176},{246,158}}, Direction.Down},
		{partner,    {{194,212}}, Direction.Right},
		{hero,       {{284,256},{320,282}}, Direction.UpLeft},
		{t.hyko,     {{224,312},{224,286},{194,250}}, Direction.Right},
		{t.kino,     {{214,284}}, Direction.UpRight},
		{t.reinier,  {{278,274},{248,302}}, Direction.Up},
		{t.phileas,  {{318,176}}, Direction.DownLeft},
		{t.coco,     {{320,194},{338,210}}, Direction.Left},
		{t.almotz,   {{286,302}}, Direction.Up},
		{t.ganlon,   {{338,248}}, Direction.Left},
	}
	local settle = {}
	for i, r in ipairs(MEAL_ROUTES) do
		local chara, route, dir = r[1], r[2], r[3]
		settle[#settle+1] = TASK:BranchCoroutine(function()
			--Le decalage suit l'ordre calcule : celui qui doit liberer
			--une place part le premier.
			GAME:WaitFrames(i * 9)
			pcall(function()
				for _, w in ipairs(route) do
					GROUND:MoveToPosition(chara, w[1], w[2], false, 1)
				end
				GROUND:CharAnimateTurnTo(chara, dir, 4)
			end)
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
	--LE SERVICE SE FAIT SOUS UN FONDU COURT.
	GAME:FadeOut(false, 30)
	GAME:WaitFrames(20)

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

	--Les convives sont deja attables quand la lumiere revient : on met
	--la pose de repas AVANT le FadeIn, pas apres.
	for _, m in ipairs(MEAL) do
		pcall(function() GROUND:CharAnimateTurnTo(m[1], m[4], 1) end)
	end
	GAME:FadeIn(30)
	GAME:WaitFrames(10)

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

	--Fin du repas : la desserte se fait sous fondu, comme le service.
	--Douze ecuelles qui disparaissent d'un coup a l'ecran font le meme
	--effet de « pop » que douze qui apparaissent.
	GAME:FadeOut(false, 30)
	GAME:WaitFrames(20)
	for _, food in ipairs(foods) do
		GAME:GetCurrentGround():RemoveTempObject(food)
	end
	for _, m in ipairs(MEAL) do
		GROUND:CharEndAnim(m[1])
		GROUND:CharSetEmote(m[1], "", 0)
	end
	GAME:FadeIn(30)
	SOUND:LoopSE('AMB_Fire_Loud')
	GAME:WaitFrames(20)

	-- 3. LA TABLEE — le faux debat solennel, puis la chute
	-- LE GAG DU CAMP. Structure de Donjon Mystere : le comique ne vient
	-- pas d'une blague, il vient du DECALAGE entre la solennite affichee
	-- et la futilite du sujet. On installe donc le serieux d'abord — et
	-- surtout, on le laisse durer assez longtemps pour que le joueur y
	-- croie — avant de le faire tomber d'un coup.
	-- Quatre temps, avec la musique qui joue le contrepoint :
	--   1. le duo remarque le conciliabule ; on n'entend pas le sujet,
	--      seulement le TON. La musique du camp s'efface.
	--   2. la camera QUITTE le duo pour aller au groupe : le silence
	--      musical dure pendant tout le mouvement — c'est ce vide qui
	--      fait croire a une scene importante.
	--   3. la chute : le sujet tombe, et la musique comique demarre
	--      EXACTEMENT dessus. Pas avant : la musique ne doit pas
	--      annoncer la blague, elle doit la ponctuer.
	--   4. l'escalade, puis Penticus qui tranche — et se trahit.
	-- « Guildmaster Wigglytuff.ogg » est le theme comique canonique de la
	-- guilde dans Explorateurs du Ciel : c'est celui qui accompagne les

	--1. LE CONSTAT. Le duo entend des voix graves sans distinguer les mots.
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(30)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_158']))
	UI:SetCenter(false)
	UI:ResetSpeaker()

	--2. LA CAMERA VA VOIR. Mouvement lent et appuye vers le groupe, dans
	--le silence. Pendant ce temps les trois se tournent les uns vers les
	--autres : de loin, ca ressemble a un conseil de guerre.
	coro1 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(268, 240, 90, false)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		pcall(function() GROUND:CharTurnToCharAnimated(t.ganlon, t.kino, 4) end)
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharTurnToCharAnimated(t.kino, t.ganlon, 4) end)
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharTurnToCharAnimated(t.reinier, t.ganlon, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	--Le ton grave, toujours sans le sujet. Ganlon a l'air en colere.
	Says(t.ganlon, "Angry", 'MWE5_159', {t.kino, t.reinier})
	GAME:WaitFrames(15)
	Says(t.ganlon, "Determined", 'MWE5_160', {t.kino})
	GAME:WaitFrames(15)
	coro1 = TASK:BranchCoroutine(function()
		Says(t.reinier, "Normal", 'MWE5_161', {t.ganlon, t.kino})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		pcall(function() GeneralFunctions.DoAnimation(t.kino, 'Nod') end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(25)

	--3. LA CHUTE. Le sujet tombe, et la musique comique demarre DESSUS.
	coro1 = TASK:BranchCoroutine(function()
		Says(t.kino, "Determined", 'MWE5_162', {t.ganlon, t.reinier})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(30)
		SOUND:PlayBGM('Guildmaster Wigglytuff.ogg', true)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	--Le duo accuse le coup. Le partenaire pose la question du joueur.
	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GeneralFunctions.EmoteAndPause(partner, "Sweating", true) end)
		Says(partner, "Sigh", 'MWE5_163', {t.ganlon, t.kino, t.reinier})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(12)

	Says(t.hyko, "Sigh", 'MWE5_164', {partner, hero})
	GAME:WaitFrames(18)

	--4. L'ESCALADE. Tout le monde a un avis, personne ne lache rien.
	coro1 = TASK:BranchCoroutine(function()
		Says(t.reinier, "Happy", 'MWE5_165', {t.coco, t.shuca, t.almotz})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		pcall(function() GROUND:CharSetEmote(t.shuca, "happy", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	coro1 = TASK:BranchCoroutine(function()
		Says(t.ganlon, "Shouting", 'MWE5_166', {t.reinier, t.kino, t.coco})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GeneralFunctions.Hop(t.ganlon, "Idle", 8, 18, 0, false) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(12)

	Says(t.coco, "Surprised", 'MWE5_167', {t.ganlon})
	GAME:WaitFrames(12)
	coro1 = TASK:BranchCoroutine(function()
		Says(t.ganlon, "Normal", 'MWE5_168', {t.coco, t.rin})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		pcall(function() GROUND:CharSetEmote(t.coco, "sweatdrop", 1) end)
		GAME:WaitFrames(8)
		pcall(function() GROUND:CharSetEmote(t.rin, "sweatdrop", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(25)

	--PENTICUS TRANCHE. Tout le cercle se tourne vers lui : enfin une
	--voix de raison. Il repond du tac au tac — et c'est justement ca,
	--la chute finale : il y avait deja pense.
	Listen(t.penticus, {t.ganlon, t.kino, t.reinier, t.coco, t.rin,
	                    t.shuca, t.almotz, t.hyko, partner, hero})
	GAME:WaitFrames(20)
	UI:SetSpeaker(t.penticus)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_169']))

	coro1 = TASK:BranchCoroutine(function()
		pcall(function() GeneralFunctions.Hop(t.reinier, "Idle", 10, 20, 0, false) end)
		Says(t.reinier, "Joyous", 'MWE5_170', {t.ganlon})
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		pcall(function() GROUND:CharSetEmote(t.ganlon, "angry", 1) end)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	--La pensee du heros, seul a avoir remarque le detail qui tue.
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWE5_171']), "Sigh")
	GAME:WaitFrames(25)

	--Retour au cercle et au repas : la camera revient sur le feu.
	GAME:MoveCamera(256, 228, 60, false)
	GAME:WaitFrames(15)

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

	-- 4. LES CONVERSATIONS PARALLELES — trois groupes autour du feu
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

	-- 5. LE SILENCE — le heros et la montagne
	--La conversation retombe. Le heros fixe le sommet ; le partenaire
	--est le seul a le remarquer. Fil rouge de la « sensation etrange »
	--commence au camp du Tunnel : elle est plus forte ici.
	--PREMIER FRISSON DU VERTIGE DE SKY : intensite 1 (tangage leger,
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

	-- 6. L'ORDRE DU SOIR — Penticus envoie tout le monde dormir
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

	-- 7. LE DEPLOIEMENT DES COUCHAGES — puis la nuit
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

	-- 8. LE COUCHER — un par un, respiration desynchronisee
	--Phileas prend le premier tour de garde : il ne se couche pas.
	local vers = {}
	--L'ordre du coucher LIT la table `seats` (via bedOf) au lieu de
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
		--(241,166) et non (240,142) : cette derniere case est SUR UN
		GeneralFunctions.EightWayMove(t.phileas, 241, 166, false, 1)
		GROUND:CharAnimateTurnTo(t.phileas, Direction.Down, 4)
	end)
	TASK:JoinCoroutines(vers)
	GAME:WaitFrames(20)

	--Hyko et Almotz rejoignent leurs couches — VOISINES, 9 et 10 sur le
	--flanc ouest — puis chuchotent encore un moment.
	local toBeds = {}
	toBeds[#toBeds+1] = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(t.hyko, seatX(bedOf[t.hyko]), seatY(bedOf[t.hyko]), false, 1)
	end)
	toBeds[#toBeds+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:MoveToPosition(t.almotz, seatX(bedOf[t.almotz]), seatY(bedOf[t.almotz]), false, 1)
	end)
	-- LE DUO NE RESTE PAS PLANTE PENDANT QUE LES AUTRES SE COUCHENT.
	toBeds[#toBeds+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		pcall(function()
			--Le partenaire s'etire avant de bouger : le corps dit la
			--fatigue avant que la scene ne le dise.
			GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", false)
			GROUND:MoveToPosition(partner, seatX(bedOf[partner]), seatY(bedOf[partner]), false, 1)
			GROUND:CharTurnToCharAnimated(partner, hero, 4)
		end)
	end)
	toBeds[#toBeds+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(34)
		pcall(function()
			--Le heros s'attarde : il regarde le sommet une derniere fois
			--avant de suivre. C'est ce qui prepare le reve.
			GROUND:CharAnimateTurnTo(hero, Direction.Up, 6)
			GAME:WaitFrames(24)
			GROUND:MoveToPosition(hero, seatX(bedOf[hero]), seatY(bedOf[hero]), false, 1)
		end)
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

	-- 9. LA SCENE INTIME — le duo, seul face au sommet
	--Le reste du camp dort. Le duo rejoint ses deux couches voisines et
	--la camera se resserre sur eux : c'est le moment calme obligatoire
	--du Prompt Maitre (6.5), APRES la veillee de groupe, AVANT le
	--sommeil du heros.
	local duoBeds = {}
	duoBeds[#duoBeds+1] = TASK:BranchCoroutine(function()
		pcall(function() GROUND:MoveToPosition(partner, seatX(bedOf[partner]), seatY(bedOf[partner]), false, 1) end)
	end)
	duoBeds[#duoBeds+1] = TASK:BranchCoroutine(function()
		pcall(function() GROUND:MoveToPosition(hero, seatX(bedOf[hero]), seatY(bedOf[hero]), false, 1) end)
	end)
	duoBeds[#duoBeds+1] = TASK:BranchCoroutine(function()
		-- LA CAMERA SUIT LE DUO, ELLE NE VISE PLUS UN POINT FIXE.
		local cx, cy = 256, 268
		pcall(function()
			cx = (seatX(bedOf[hero]) + seatX(bedOf[partner])) // 2
			cy = (seatY(bedOf[hero]) + seatY(bedOf[partner])) // 2
		end)
		GAME:MoveCamera(cx, cy, 45, false)
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

	-- 10. LE REVE — sur sa propre carte
	-- LA SCENE DU REVE A ETE ENTIEREMENT REFAITE, ET DEPLACEE SUR UNE
	-- CARTE DEDIEE : Data/Ground/hero_dream.rsground, script
	-- Data/Script/halcyon/ground/hero_dream/init.lua.
	-- Pourquoi une carte plutot qu'un overlay pose ici :
	--     son OverlayAnim avec omnipresent = false ; GetDrawSize() rend
	--     Loc(TileSize) = 24x24, et IterateRelevantDraw ne dessine que
	--     si ce rectangle touche le ViewRect. Emis en (0,0) avec la
	--     camera sur le camp, il disparaissait du rendu ;
	--   * meme visible, il fallait masquer douze dormeurs, un feu, onze
	--     paillasses et une falaise pour faire croire a un ailleurs.
	-- Sur la carte dediee, le ciel onirique n'est plus un overlay :
	-- c'est le FOND DE CARTE (Background.Layers / LayeredBG), copie
	-- structurelle de personality_test.rsground. Le moteur le dessine
	-- avant tout le reste, sans condition de culling — il ne peut plus
	-- disparaitre. Et le heros y est SEUL, couche au centre.
	-- Le reve se termine par un retour ici meme, ecran noir conserve :
	-- c'est hero_dream qui rappelle mount_windswept_entrance, et
	-- PlotScripting enchaine sur MorningAfterDream (section 11).
	--LE MODE CINEMATIQUE RESTE ACTIF PENDANT LA BASCULE. Le couper ici
	--pendant que SceneOutcome attend d'etre consomme au tour suivant
	--une fraction de seconde avant de partir. hero_dream.DreamScene le
	--repose immediatement de son cote.
	SV.Chapter5.CampNightWatchDone = true
	GAME:EnterGroundMap('hero_dream', 'Main_Entrance_Marker', true)
end

-- LE MATIN — apres le reve, de retour au camp
-- Scindee de CampNightfall : un changement de carte doit etre la
-- DERNIERE instruction d'une scene (le moteur poursuit la coroutine en
-- arriere-plan pendant le chargement). Tout ce qui suivait le reve est
-- donc devenu une fonction a part, rappelee par PlotScripting quand on
-- revient de hero_dream.
-- RETOUR DU REVE — on recompose le camp endormi, puis le matin.
-- Passer par une carte dediee a un cout : les dix PNJ du camp sont des
-- personnages TEMPORAIRES (AddTempChar), ils n'existent plus au retour.
-- Cette fonction les recree EXACTEMENT sur leur couche, dans la pose de
-- sommeil, avant de rendre la main au matin. Le joueur ne voit rien de
-- cette reconstruction : tout se passe sous l'ecran noir laisse par
-- hero_dream et maintenu par Init.
-- L'ordre des couchages est celui de la table `seats` de CampNightfall,
-- recopie ici a l'identique. Les deux doivent rester d'accord : si l'un
-- change, l'autre aussi.
function mount_windswept_entrance_ch_5.ResumeAfterDream()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local B = mount_windswept_entrance_ch_5.BEDS

	GAME:CutsceneMode(true)
	pcall(function() GAME:FadeOut(false, 1) end)
	--La nuit est encore la : le matin se leve dans MorningAfterDream.
	pcall(function() GROUND:AddMapStatus("darkness") end)

	--Le bivouac de la nuit : paillasses + foyer (et son bloqueur).
	mount_windswept_entrance_ch_5.DeployBeds()

	--Les dix membres du camp, recrees a leur place.
	local audino, snubbull, girafarig, breloom, growlithe, zigzagoon, tropius, noctowl, mareep, cranidos =
	CharacterEssentials.MakeCharactersFromList({
		--Attribution synchronisee avec la table `seats` de CampNightfall
		--(realignee sur le cercle du repas) : Rin 1, Penticus 2, Coco 3,
		--Ganlon 4, Reinier 5, Kino 6, heros 7, partenaire 8, Hyko 9,
		--Shuca 10, Almotz 11. Les deux listes DOIVENT rester d'accord :
		--si l'une change, l'autre aussi.
		{'Audino',    B[1][1]  + 13, B[1][2]  + 10, Direction.Down},
		{'Snubbull',  B[3][1]  + 13, B[3][2]  + 10, Direction.DownLeft},
		{'Girafarig', B[5][1]  + 13, B[5][2]  + 10, Direction.Left},
		{'Breloom',   B[6][1]  + 13, B[6][2]  + 10, Direction.UpLeft},
		{'Growlithe', B[9][1]  + 13, B[9][2]  + 10, Direction.Right},
		{'Zigzagoon', B[11][1] + 13, B[11][2] + 10, Direction.Right},
		{'Tropius',   B[2][1]  + 13, B[2][2]  + 10, Direction.DownLeft},
		{'Noctowl',   241, 166, Direction.Down},
		{'Mareep',    B[10][1] + 13, B[10][2] + 10, Direction.Right},
		{'Cranidos',  B[4][1]  + 13, B[4][2]  + 10, Direction.Left}
	})

	--Le duo sur ses couches : partenaire 5, heros 6 (voisines de 50 px,
	--pour que la camera puisse les cadrer ensemble).
	GROUND:TeleportTo(partner, B[8][1] + 13, B[8][2] + 10, Direction.UpRight)
	GROUND:TeleportTo(hero,    B[7][1] + 13, B[7][2] + 10, Direction.UpRight)

	--Tout le monde dort. Phileas, lui, VEILLE debout a son poste : il
	--n'a pas de couchage, c'est tout son role de la nuit.
	for _, c in ipairs({audino, snubbull, girafarig, breloom, growlithe,
	                    zigzagoon, tropius, mareep, cranidos}) do
		pcall(function() GROUND:CharSetAnim(c, "Sleep", true) end)
	end
	pcall(function() GROUND:CharSetAnim(partner, "EventSleep", true) end)
	pcall(function() GROUND:CharSetAnim(hero, "EventSleep", true) end)

	--Puis le matin, avec la meme table de personnages que la veillee.
	mount_windswept_entrance_ch_5.MorningAfterDream(
		hero, partner, {penticus = tropius, phileas = noctowl,
		                rin = audino,      coco = snubbull,
		                shuca = mareep,    ganlon = cranidos,
		                hyko = growlithe,  almotz = zigzagoon,
		                reinier = girafarig, kino = breloom})
end

function mount_windswept_entrance_ch_5.MorningAfterDream(hero, partner, t)
	local B = mount_windswept_entrance_ch_5.BEDS
	local mountain = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('mount_windswept')
	local ruins = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('cloven_ruins')
	local coro1, coro2, coro3, coro4, coro5, coro6

	--Helpers d'ecoute, identiques a ceux de la veillee : le corps parle
	--avant la bouche. Redefinis ici car ils etaient locaux a
	--CampNightfall, dont cette fonction a ete detachee.
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
	--LA COUCHE DU HEROS. C'est la 6 : voir la table `seats` de
	--CampNightfall, ou le duo occupe les couches 5 (partenaire) et 6
	--(heros), les deux dernieres du flanc est avant l'ouverture sud.
	--On ne partage pas `seats` entre les deux fonctions : elle est
	--construite a partir des personnages `t`, qui n'existent que le
	--temps de la veillee. Une constante nommee vaut mieux qu'une table
	--reconstruite a moitie.
	local HERO_BED = 7
	local function seatX(i) return B[i][1] + 13 end
	local function seatY(i) return B[i][2] + 10 end

	GAME:CutsceneMode(true)
	if partner ~= nil then AI:DisableCharacterAI(partner) end

	--L'ECRAN EST DEJA NOIR : hero_dream est parti dessus, et Init l'a
	--repose ici. La mise en place du matin se fait donc a l'abri.
	pcall(function() GAME:FadeOut(false, 1) end)

	--LE SURSAUT DU REVEIL. Le heros se redresse d'un coup : c'est la
	--seule trace que le reve laisse dans son corps. Il joue MAINTENANT,
	--au retour, et non plus dans le reve — le reveil appartient au
	--monde reel.
	GAME:MoveCamera(seatX(HERO_BED), seatY(HERO_BED), 1, false)
	GAME:FadeIn(45)
	GAME:WaitFrames(25)

	pcall(function() SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') end)
	pcall(function() GROUND:CharEndAnim(hero) end)
	pcall(function() VoiceVisions.Nausea(hero, 1) end)
	GAME:WaitFrames(25)

	--L'OUBLI IMMEDIAT — le coeur du dispositif de Rouge/Bleu. Trois
	--pensees, entrecoupees de silences : il tente de rattraper l'image
	--et n'y arrive pas.
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_155']))
	GAME:WaitFrames(30)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_156']))
	GAME:WaitFrames(25)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_157']))
	UI:SetCenter(false)
	UI:ResetSpeaker()
	GAME:WaitFrames(35)

	-- PHILEAS NE PEUT PAS RESTER PASSIF.
	-- RETOUR DE L'UTILISATEUR, et il a entierement raison : le heros
	-- vient de se redresser en criant au milieu de la nuit, et le seul
	-- personnage EVEILLE du camp — celui dont c'est precisement le
	-- tour de garde — ne bougeait pas d'un pixel. Le joueur ne pouvait
	-- que se demander « pourquoi il ne reagit pas ? ». C'est le test de
	-- credibilite, et la scene le ratait.
	-- Ce que Phileas FAIT, dans l'ordre ou un veilleur le ferait :
	--   1. il entend (il est de garde, c'est son role) et leve la tete ;
	--   2. il se tourne vers la source du bruit AVANT de bouger ;
	--   3. il traverse le camp — 128 px, quatre segments, trajet calcule
	--      pour ne pieter aucun des dix dormeurs (seuil 14 px) ni le
	--      foyer ;
	--   4. il s'arrete a distance de conversation (26 px), pas colle ;
	--   5. il parle bas — il ne reveille pas le camp pour un cauchemar ;
	--   6. il REPREND SON POSTE. Un veilleur ne s'installe pas au
	--      chevet : il retourne guetter la porte du donjon.
	-- Son registre est celui etabli ailleurs sur la carte (« Hou... »,
	-- le vieux voilier qui observe avant de conclure) : il ne dramatise
	-- pas, il constate, et c'est ce qui rassure.
	if t.phileas ~= nil then
		--1-2. IL ENTEND ET SE TOURNE. La camera s'ecarte un peu pour le
		--faire entrer dans le cadre : il ne doit pas parler hors champ.
		local pw1 = TASK:BranchCoroutine(function()
			pcall(function()
				GROUND:CharEndAnim(t.phileas)
				GeneralFunctions.EmoteAndPause(t.phileas, "Notice", true)
				GROUND:CharTurnToCharAnimated(t.phileas, hero, 4)
			end)
		end)
		local pw2 = TASK:BranchCoroutine(function()
			GAME:WaitFrames(10)
			GAME:MoveCamera(324, 268, 60, false)
		end)
		TASK:JoinCoroutines({pw1, pw2})
		GAME:WaitFrames(20)

		--3. IL TRAVERSE LE CAMP. Waypoints calcules par recherche de
		--chemin sur la grille d'obstacles, en tenant les dix dormeurs a
		--14 px minimum : il slalome entre les paillasses au lieu de
		--marcher dessus.
		pcall(function()
			GeneralFunctions.EightWayMove(t.phileas, 287, 212, false, 1)
			GeneralFunctions.EightWayMove(t.phileas, 287, 248, false, 1)
			GeneralFunctions.EightWayMove(t.phileas, 313, 294, false, 1)
			--4. Il s'arrete et se tourne vers lui.
			GROUND:CharTurnToCharAnimated(t.phileas, hero, 4)
		end)
		GAME:WaitFrames(15)

		--Le heros le regarde arriver.
		pcall(function() GROUND:CharTurnToCharAnimated(hero, t.phileas, 4) end)
		GAME:WaitFrames(12)

		--5. IL PARLE BAS. Trois repliques, entrecoupees de silences : il
		--laisse le heros reprendre son souffle entre chaque.
		UI:SetSpeaker(t.phileas)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_193']))
		GAME:WaitFrames(25)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_194']))
		GAME:WaitFrames(35)

		--Il devine, parce qu'il a vu ca cent fois.
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_195']))
		GAME:WaitFrames(20)

		--Le heros ne repond pas a voix haute : il pense. C'est un
		--cauchemar qu'on ne raconte pas, et Phileas ne le force pas.
		UI:ResetSpeaker(false)
		UI:SetCenter(true)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_196']))
		UI:SetCenter(false)
		UI:ResetSpeaker()
		GAME:WaitFrames(30)

		UI:SetSpeaker(t.phileas)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_197']))
		GAME:WaitFrames(25)

		--La phrase qui rassure vraiment : elle ne nie pas le cauchemar,
		--elle dit juste que quelqu'un veille.
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_198']))
		GAME:WaitFrames(30)

		--Le heros acquiesce, puis se recouche.
		pcall(function() GeneralFunctions.DoAnimation(hero, 'Nod') end)
		GAME:WaitFrames(20)

		--6. IL REPREND SON POSTE. Meme trajet en sens inverse : il ne
		--disparait pas, il ne reste pas plante la. La camera le suit
		--jusqu'a ce qu'il reparte, puis revient sur le dormeur.
		local pb1 = TASK:BranchCoroutine(function()
			pcall(function()
				GROUND:CharTurnToCharAnimated(t.phileas, hero, 4)
				GAME:WaitFrames(20)
				GeneralFunctions.EightWayMove(t.phileas, 287, 248, false, 1)
				GeneralFunctions.EightWayMove(t.phileas, 287, 212, false, 1)
				GeneralFunctions.EightWayMove(t.phileas, 241, 166, false, 1)
				GROUND:CharAnimateTurnTo(t.phileas, Direction.Down, 4)
			end)
		end)
		local pb2 = TASK:BranchCoroutine(function()
			GAME:WaitFrames(60)
			GAME:MoveCamera(seatX(HERO_BED), seatY(HERO_BED), 90, false)
		end)
		TASK:JoinCoroutines({pb1, pb2})
		GAME:WaitFrames(20)
	end

	--Il se rendort. Le trouble n'est pas resolu : il ressurgira au matin
	--et sur le chemin du nord.
	pcall(function()
		GROUND:CharSetEmote(hero, "", 0)
		GROUND:CharSetAnim(hero, "EventSleep", true)
	end)
	GAME:WaitFrames(60)

	--LA NUIT PASSE.
	GAME:FadeOut(false, 50)
	GAME:WaitFrames(30)

	-- 11. LE MATIN — reveil progressif, heros deboussole
	--Mise en place sous le noir : le jour se leve, Rin et Coco sont
	--deja debout, Penticus et Phileas aussi. Le reste du camp dort.
	GROUND:RemoveMapStatus("darkness")

	GROUND:CharEndAnim(t.rin)
	GROUND:CharEndAnim(t.coco)
	GROUND:CharEndAnim(t.penticus)
	-- LE FEU BRULE ENCORE AU REVEIL, ET LES SPRITES SONT GRANDS.
	GROUND:TeleportTo(t.rin, 240, 262, Direction.UpRight)
	GROUND:TeleportTo(t.coco, 298, 250, Direction.Left)
	GROUND:TeleportTo(t.penticus, 252, 268, Direction.Up)
	GROUND:TeleportTo(t.phileas, 240, 166, Direction.Down)
	pcall(function() GROUND:CharSetAnim(t.phileas, "Sleep", true) end)
	GAME:MoveCamera(256, 240, 1, false)

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

	--Rin va secouer Kino, le seul encore endormi.
	--DEUX DEFAUTS CORRIGES, mesures sur la nouvelle disposition :
	--  * elle visait « +44 en X », soit 31 px a l'est de l'assise de
	--    Kino. Trop loin pour le secouer : elle l'engueulait a distance.
	--  * pire, ce point est de l'AUTRE COTE de la paillasse : le trajet
	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMoveRS(t.rin, B[bedOf[t.kino]][1] + 13,
		                                B[bedOf[t.kino]][2] - 14, false, 1)
		GROUND:CharAnimateTurnTo(t.rin, Direction.Down, 4)
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

	-- 12. LE RASSEMBLEMENT — rangs par deux, face a Penticus
	--Penticus appelle au rassemblement. Le camp se range sous un
	--fondu court (patron du matin du Tunnel : c'est SOUS FadeOut que
	--sa formation de depart se met en place). Pendant le noir, les
	--couchages sont ranges et remplaces par le materiel de jour
	--(BuildCampDay) : la Ground raconte le camp pret au depart.
	GROUND:CharEndAnim(t.kino)
	GAME:MoveCamera(256, 196, 40, false)
	--PHILEAS SE REVEILLE EN DERNIER — et c'est un gag, pas un oubli.
	--Il dort depuis le reveil du camp (il a veille toute la nuit). Le
	--sortir du sommeil ICI, au moment ou l'ordre tombe, sert deux
	--choses a la fois : techniquement il faut lever son animation
	--bouclee avant que Listen ne le fasse pivoter (un dormeur qui se
	--tourne vers le maitre de guilde sans se reveiller, c'est le genre
	--de detail qui casse une scene) ; narrativement, le savant pris en
	--flagrant delit de somnolence, c'est tout son personnage.
	pcall(function()
		GROUND:CharEndAnim(t.phileas)
		GeneralFunctions.EmoteAndPause(t.phileas, "Exclaim", true)
	end)
	GAME:WaitFrames(10)
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
	mount_windswept_entrance_ch_5.BuildCampMorning()

	-- LA FORMATION DE LA GUILDE — celle des chapitres 3 et 4.
	-- RETOUR DE L'UTILISATEUR : « tu as deja des exemples de
	-- rassemblement matinal dans les chapitres 3/4 ou la guilde a une
	-- disposition de rangee differente de ce que tu as fait ».

	--Le maitre de guilde fait face a ses troupes, seul au centre ; le
	--savant se tient en retrait sur sa gauche. Ecart de 40 px : ils ne
	--forment pas une rangee, on lit tout de suite qui commande.
	GROUND:TeleportTo(t.penticus, 256, 232, Direction.Down)
	GROUND:TeleportTo(t.phileas,  216, 240, Direction.DownRight)

	--Rang de devant : le duo, puis la cordee du sommet, puis Rin.
	GROUND:TeleportTo(partner,   192, 272, Direction.Up)
	GROUND:TeleportTo(t.shuca,   224, 272, Direction.Up)
	GROUND:TeleportTo(t.kino,    256, 272, Direction.Up)
	GROUND:TeleportTo(t.rin,     288, 272, Direction.Up)
	GROUND:TeleportTo(t.hyko,    320, 272, Direction.Up)

	--Rang de derriere, chacun aligne sur son binome de devant.
	GROUND:TeleportTo(hero,      192, 304, Direction.Up)
	GROUND:TeleportTo(t.ganlon,  224, 304, Direction.Up)
	GROUND:TeleportTo(t.reinier, 256, 304, Direction.Up)
	GROUND:TeleportTo(t.coco,    288, 304, Direction.Up)
	GROUND:TeleportTo(t.almotz,  320, 304, Direction.Up)

	--UN SEUL PLAN SUFFIT DESORMAIS. La formation tient dans le cadre :
	--on cadre entre le chef (y=232) et le rang arriere (y=304), et tout
	--le monde est visible d'un coup. Les deux mouvements de camera qui
	--balayaient l'ancienne colonne n'ont plus lieu d'etre — ils
	--serviraient a montrer du vide.
	GAME:MoveCamera(256, 268, 1, false)
	GAME:WaitFrames(30)
	GAME:FadeIn(40)
	SOUND:PlayBGM("Spring Cave.ogg", true)
	GAME:WaitFrames(20)

	--Le plan reste fixe. Il y avait ici un MoveCamera(256, 276, 70) : huit
	--pixels de descente etales sur 70 frames, soit un neuvieme de pixel par
	--frame — rigoureusement invisible, mais un mouvement de camera de plus
	--a lire dans la scene. Halcyon en compte QUATRE sur toute sa scene de
	--boss ; on ne garde donc que les cadrages qui montrent quelque chose.
	--L'attente, elle, est conservee : elle fait partie du rythme.
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

	-- 13. LES CORDEES — la repartition propre au Mont Venteux
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

	-- 14. LES DEPARTS — cordee par cordee, par le sentier nord
	--Personne ne disparait sur place : chaque cordee remonte le
	--sentier est (x=284, seul couloir praticable vers l'entree,
	coro1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(t.penticus, 208, 232, false, 1)
		GROUND:CharAnimateTurnTo(t.penticus, Direction.UpRight, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		GROUND:MoveToPosition(t.phileas, 184, 240, false, 1)
		GROUND:CharAnimateTurnTo(t.phileas, Direction.UpRight, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(15)

	UI:SetSpeaker(t.kino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_105']))
	-- ILS SORTENT PAR LES COTES, PAS A TRAVERS LES RANGS.
	-- Les partants quittaient la formation en diagonale et traversaient
	-- les camarades restes en rang. Mesure : Kino passait sur Hyko,
	-- Reinier sur Almotz, Rin sur Hyko, Coco sur le partenaire, Ganlon
	-- sur Hyko. Cinq traversees, toutes visibles a l'ecran.
	-- La formation occupe desormais DEUX RANGEES DE CINQ (colonnes 192 a
	-- 320, rangees y=272 et y=304), et le couloir du nord n'est
	-- praticable QUE entre x=248 et x=288 — releve sur la grille : a
	-- x=232 et x=296 la roche ferme des y=128.
	-- Les trajets ci-dessous ont donc ete entierement recalcules pour
	-- cette disposition : chacun descend ou contourne par l'exterieur,
	-- puis rejoint le goulot une fois les rangs depasses. Tous les
	-- segments sont reechantillonnes contre les DOUZE positions de la
	-- formation (Penticus et Phileas inclus, a leur nouveau poste
	-- ouest) : aucun ne passe a moins de 14 px d'un camarade, aucun ne
	-- traverse un obstacle.
	coro1 = TASK:BranchCoroutine(function()
		--Kino est en tete de rang, pile dans l'axe : il monte tout droit.
		GeneralFunctions.EightWayMove(t.kino, 256, 240, false, 1)
		GeneralFunctions.EightWayMove(t.kino, 256, 140, false, 1)
		GeneralFunctions.EightWayMove(t.kino, 252, 112, false, 1)
		GROUND:Hide(t.kino.EntName)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		--Reinier est au rang arriere, derriere Kino : il s'ecarte d'une
		--demi-colonne a l'est avant de remonter, pour ne pas lui coller.
		GeneralFunctions.EightWayMove(t.reinier, 272, 296, false, 1)
		GeneralFunctions.EightWayMove(t.reinier, 272, 232, false, 1)
		GeneralFunctions.EightWayMove(t.reinier, 272, 140, false, 1)
		GeneralFunctions.EightWayMove(t.reinier, 268, 112, false, 1)
		GROUND:Hide(t.reinier.EntName)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(32)
		--Almotz ferme le rang est : il contourne largement par l'exterieur
		--(x=344) avant de revenir prendre le goulot.
		GeneralFunctions.EightWayMove(t.almotz, 344, 296, false, 1)
		GeneralFunctions.EightWayMove(t.almotz, 344, 240, false, 1)
		GeneralFunctions.EightWayMove(t.almotz, 284, 216, false, 1)
		GeneralFunctions.EightWayMove(t.almotz, 284, 140, false, 1)
		GeneralFunctions.EightWayMove(t.almotz, 284, 112, false, 1)
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
		GeneralFunctions.EightWayMove(t.rin, 288, 240, false, 1)
		GeneralFunctions.EightWayMove(t.rin, 280, 160, false, 1)
		GeneralFunctions.EightWayMove(t.rin, 260, 112, false, 1)
		GROUND:Hide(t.rin.EntName)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		-- AUCUN DETOUR : ELLE MONTE TOUT DROIT.
		GeneralFunctions.EightWayMove(t.coco, 288, 160, false, 1)
		GeneralFunctions.EightWayMove(t.coco, 272, 112, false, 1)
		GROUND:Hide(t.coco.EntName)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	-- GANLON ET SHUCA NE PARTENT PAS. ILS NOUS ATTENDENT.
	GROUND:CharTurnToCharAnimated(t.shuca, hero, 4)
	UI:SetSpeaker(t.shuca)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_104']))

	--Ils prennent leur poste d'attente. Colonnes espacees de 16 px (la
	--largeur d'un sprite) : ils ne se traversent pas, et ils laissent
	--libre la colonne centrale par laquelle le duo va remonter.
	coro1 = TASK:BranchCoroutine(function()
		--Ganlon est au rang arriere, deuxieme colonne. Les rangs qui le
		--genaient sont partis : il remonte en biais vers l'entree du
		--goulot. Segments >= 32 px, aucun pas plus court qu'une case
		--(c'est ce qui faisait sautiller le sprite auparavant).
		GeneralFunctions.EightWayMove(t.ganlon, 240, 288, false, 1)
		GeneralFunctions.EightWayMove(t.ganlon, 264, 248, false, 1)
		GeneralFunctions.EightWayMove(t.ganlon, 264, 204, false, 1)
		GROUND:CharAnimateTurnTo(t.ganlon, Direction.Up, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(18)
		--Shuca le suit, une colonne a l'est : les deux tetes de cordee
		--attendent cote a cote, sans se chevaucher (16 px d'ecart) et
		--sans boucher l'axe par lequel le duo va monter.
		GeneralFunctions.EightWayMove(t.shuca, 240, 256, false, 1)
		GeneralFunctions.EightWayMove(t.shuca, 280, 232, false, 1)
		GeneralFunctions.EightWayMove(t.shuca, 280, 204, false, 1)
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

	-- 15. LE CHEMIN DU NORD — la remarque du partenaire
	--Le duo remonte a son tour. A mi-chemin, le partenaire s'arrete :
	--il a REMARQUE. C'est la transition douce vers la scene finale
	--(Prompt Maitre 6.10) — le contenu du reve n'est pas revele.
	--Le duo part du bout ouest de la formation (hero 192,304 ; partenaire
	--192,272) et remonte en biais vers le pied du sentier. Les trajets
	--sont verifies contre les cinq personnages encore presents a cet
	--instant : Ganlon et Shuca en tete de cordee (264/280, 204), Penticus
	--et Phileas retires a l'ouest, Hyko reste au camp.
	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(hero, 216, 280, false, 1)
		GeneralFunctions.EightWayMove(hero, 248, 240, false, 1)
		GeneralFunctions.EightWayMove(hero, 248, 216, false, 1)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		--Le partenaire prend une ligne plus a l'ouest et s'avance un peu
		--plus haut : c'est lui qui va s'arreter et se retourner.
		GeneralFunctions.EightWayMove(partner, 224, 248, false, 1)
		GeneralFunctions.EightWayMove(partner, 232, 224, false, 1)
		GeneralFunctions.EightWayMove(partner, 232, 192, false, 1)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GAME:MoveCamera(256, 212, 70, false)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(15)

	--Le heros fixe le sommet — et LA VOIX REVIENT, en plein jour, une
	--seule phrase. C'est le rappel du reve que le heros a deja oublie :
	--le joueur, lui, reconnait la formule (« petit echo ») entendue cette
	--nuit. Personne d'autre ne l'entend, et le heros ne la commente pas.
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
	GAME:WaitFrames(20)

	-- LA CORDEE S'IMPATIENTE — et le serieux s'effondre.
	-- Demande de l'utilisateur, mise en scene sur le patron comique du
	-- gag du camp (section 3) : le rire ne vient pas d'une blague, il
	-- vient de la CHUTE DE TENSION. On sort d'une minute de silence, de
	-- vertige et d'une voix que personne d'autre n'entend — puis Ganlon
	-- gueule depuis le sentier, et tout retombe d'un coup.
	-- Ce que la scene doit reussir :
	--   1. L'insulte arrive de HORS CHAMP. La camera est sur le heros ;
	--      on entend Ganlon avant de le voir, comme le camp entendait
	--      le conciliabule sans distinguer les mots.
	--   2. La musique comique demarre EXACTEMENT sur l'insulte, pas
	--      avant : elle ponctue la chute, elle ne l'annonce pas.
	--      « Guildmaster Wigglytuff.ogg » est le theme comique canonique
	--      de la guilde, deja pose sur la chute du gag du camp — c'est
	--      la meme signature sonore pour le meme type de rupture.
	--   3. Shuca se RETOURNE avant de parler (le corps parle avant la
	--      bouche) : c'est le mouvement qui fait la menace, pas la
	--      replique.
	--   4. Ganlon se degonfle en une phrase, sans transition. Il ne
	--      s'excuse pas : il reecrit ce qu'il vient de dire.
	--   5. Le partenaire conclut en voix off — il commente pour le
	--      joueur, ce qui referme le gag.
	local gag1 = TASK:BranchCoroutine(function()
		SOUND:PlayBGM('Guildmaster Wigglytuff.ogg', true)
	end)
	local gag2 = TASK:BranchCoroutine(function()
		--Ganlon crie depuis son poste : il ne bouge pas, il beugle.
		pcall(function() GROUND:CharTurnToCharAnimated(t.ganlon, hero, 4) end)
		pcall(function() GROUND:CharSetEmote(t.ganlon, "angry", 1) end)
		UI:SetSpeaker(t.ganlon)
		UI:SetSpeakerEmotion("Angry")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_181']))
	end)
	TASK:JoinCoroutines({gag1, gag2})
	GAME:WaitFrames(20)

	--LE TEMPS DE LATENCE. C'est lui qui fait rire : Shuca ne repond pas
	--tout de suite. La camera glisse sur les deux tetes de cordee
	--pendant que le silence s'installe.
	local gag3 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(272, 204, 60, false)
	end)
	local gag4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(30)
		--Elle se tourne LENTEMENT (8 frames par cran au lieu de 4).
		pcall(function() GROUND:CharTurnToCharAnimated(t.shuca, t.ganlon, 8) end)
	end)
	TASK:JoinCoroutines({gag3, gag4})
	GAME:WaitFrames(25)

	UI:SetSpeaker(t.shuca)
	UI:SetSpeakerEmotion("Angry")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_182']))
	GAME:WaitFrames(30)

	local gag5 = TASK:BranchCoroutine(function()
		pcall(function() GeneralFunctions.EmoteAndPause(t.ganlon, "Sweatdrop", true) end)
		UI:SetSpeaker(t.ganlon)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_183']))
	end)
	local gag6 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		--Il regarde ailleurs. N'importe ou sauf Shuca.
		pcall(function() GROUND:CharAnimateTurnTo(t.ganlon, Direction.Up, 6) end)
	end)
	TASK:JoinCoroutines({gag5, gag6})
	GAME:WaitFrames(20)

	pcall(function() GROUND:CharAnimateTurnTo(t.shuca, Direction.Up, 6) end)
	UI:SetSpeaker(t.shuca)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_184']))
	GAME:WaitFrames(25)

	--Le duo a tout vu. Le partenaire commente pour le joueur.
	local gag7 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(248, 208, 60, false)
	end)
	local gag8 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
		pcall(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	end)
	TASK:JoinCoroutines({gag7, gag8})
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_185']))
	GAME:WaitFrames(25)

	--Retour au theme de la montagne : le gag est clos, la scene reprend
	--son cours. FadeOutBGM avant PlayBGM pour que la bascule s'entende
	--comme une fin de parenthese et non comme une coupure.
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(30)
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

	-- 16. LA SCENE FINALE — Penticus, Phileas, et la porte du donjon
	--Ne restent que quatre silhouettes devant l'entree (reference :
	--Grand Stepped Entrance). Plans larges sur la montagne, plans
	--rapproches sur les visages, silences.
	--Positions recalculees pour la nouvelle formation. Les cinq trajets
	--sont verifies contre Ganlon (264,204) et Shuca (280,204), restes en
	--tete de cordee, et les uns contre les autres dans l'ordre ou ils se
	--mettent en place : aucun contact a moins de 14 px.
	coro1 = TASK:BranchCoroutine(function()
		--Le heros monte plein nord dans l'axe du goulot, entre les deux
		--tetes de cordee sans les toucher.
		GeneralFunctions.EightWayMove(hero, 248, 160, false, 1)
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		--Le partenaire se poste a sa droite, un peu en retrait. Il monte
		--d'abord droit (24 px) puis oblique (48 px) : aucun segment plus
		--court qu'une case, sinon le sprite pivote sur place au lieu de
		--marcher. Le detour evite Penticus, poste en (248,200).
		GeneralFunctions.EightWayMove(partner, 232, 168, false, 1)
		GeneralFunctions.EightWayMove(partner, 280, 172, false, 1)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		--Penticus remonte depuis son poste ouest jusqu'au pied du sentier.
		GeneralFunctions.EightWayMove(t.penticus, 232, 224, false, 1)
		GeneralFunctions.EightWayMove(t.penticus, 248, 200, false, 1)
	end)
	coro4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(30)
		--Phileas le suit, en retrait sur sa gauche : la place qu'il tient
		--depuis le debut de l'adresse.
		GeneralFunctions.EightWayMove(t.phileas, 200, 224, false, 1)
		GeneralFunctions.EightWayMove(t.phileas, 216, 208, false, 1)
	end)
	local coroH = TASK:BranchCoroutine(function()
		GAME:WaitFrames(36)
		--Hyko reste au camp mais s'avance pour les regarder partir : il
		--remonte par l'est, sans couper la route de personne.
		--Un seul segment de 32 px : les deux appels precedents faisaient
		--un premier pas de 8 px, plus court qu'une case.
		GeneralFunctions.EightWayMove(t.hyko, 312, 240, false, 1)
		GROUND:CharAnimateTurnTo(t.hyko, Direction.UpLeft, 4)
	end)
	coro5 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GAME:MoveCamera(264, 190, 80, false)
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
	--Recadre sur l'axe du groupe (x=264) apres le deplacement de la
	--formation : a x=280 le plan de retour laissait Phileas (216,208)
	--hors champ par la gauche.
	GAME:MoveCamera(264, 90, 100, false)
	GAME:WaitFrames(50)
	GAME:MoveCamera(264, 190, 80, false)
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

	-- CLOTURE DE L'INTRO — deplacee ici depuis ArrivalCutscene.
	-- CampNightfall se termine par un changement de carte (le reve) :
	-- tout ce qui suivait dans ArrivalCutscene ne s'executait donc plus.
	-- SetParty, le drapeau de fin et le rendu du controle vivent
	-- desormais ici, a la seule fin de parcours reellement atteinte.
	-- SetParty retire Hyko et Almotz (restes du Tunnel) et cree Ganlon
	-- et Shuca en Teammate2/3 : c'est la cordee du sommet annoncee par
	-- Penticus, et donc l'equipe reelle du donjon.
	mount_windswept_entrance_ch_5.SetParty()
	hero = CH('PLAYER')
	partner = CH('Teammate1')

	SV.Chapter5.FinishedMountWindsweptIntro = true
	SV.Chapter5.CampNightWatchDone = false
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	--La camera revient au joueur (forme attestee : searing_tunnel:1480).
	GAME:MoveCamera(0, 0, 1, true)
	SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
	GAME:FadeIn(40)
end

-- LE RETOUR EN MAUVAISE POSTURE — KO / abandon dans la montagne
function mount_windswept_entrance_ch_5.KODefeatCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local ganlon = CH('Teammate2')   --cordee du sommet : Ganlon
	local shuca = CH('Teammate3')    --et Shuca (SetParty de l'intro)
	local penticus = CH('Tropius')
	local phileas = CH('Noctowl')
	--RIN N'EST PLUS LA — ET PERSONNE NE LA REMPLACE COMME SOIGNEUSE.
	--Rin (Audino) est partie avec la cordee de soutien a la fin de
	--l'intro : CH('Audino') rend nil, et toute la scene de secours
	--reposait a l'origine sur elle (soin non joue, MWE5_121 sautee en
	--silence). Ma premiere correction avait donne son role a Hyko —
	local hyko = CH('Growlithe')
	local coro1, coro2, coro3, coro4

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()

	--ECRAN NOIR D'ABORD. Le moteur ne pose aucun fondu entre deux cartes
	--(GameManager.moveToZoneInit : « no fade; the script handles that
	--itself ») : ce que le script laisse a l'ecran y reste. Sans ce
	--FadeOut en tete, la carte est visible pendant qu'on y teleporte les
	--personnages et qu'on deplace la camera — le joueur voit la mise en
	--place. Instantane (1 frame) et idempotent.
	GAME:FadeOut(false, 1)

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

	-- HYKO NE SOIGNE PAS. IL VA CHERCHER CELUI QUI SAIT.
	-- RETOUR DE L'UTILISATEUR : « Hyko est incapable de soigner ».
	-- Exact, et ma correction precedente n'allait pas au bout : j'avais
	-- change le SON (DUN_Heal au lieu de DUN_Heal_Bell) et ajoute des
	-- repliques, mais Hyko restait celui qui administrait le secours,
	-- avec une pose de 100 frames en gros plan. Un Growlithe de la
	-- garde ne soigne pas — il n'a ni capacite de soin, ni formation,
	-- ni objet. Le son n'etait que le symptome ; le probleme etait le
	-- ROLE.
	-- Nouvelle repartition, conforme a ce que chacun sait faire :
	--   * HYKO donne l'alerte et degage l'espace. C'est un garde :
	--     il court, il crie, il fait de la place. Sa force, c'est la
	--     vitesse de reaction.
	--   * PENTICUS soigne — en donnant une BAIE ORAN, pas une capacite.
	--     C'est le maitre de guilde : il porte les provisions, il
	--     s'agenouille, il parle doucement. Aucun effet magique.
	--   * HYKO conclut en assumant sa limite a voix haute. C'est ce qui
	--     rend le personnage attachant plutot que decoratif : il sait
	--     ce qu'il ne sait pas faire, et il propose autre chose.
	-- Plus aucun SE de soin : une baie qu'on mange ne sonne pas comme
	-- une capacite. Seul le fanfare d'objet de RewardItem se fait
	-- entendre, ce qui est exactement le bon signal.
	if hyko ~= nil then
		pcall(function() GROUND:CharTurnToCharAnimated(hyko, penticus, 4) end)
		pcall(function() GeneralFunctions.EmoteAndPause(hyko, "Exclaim", true) end)
		UI:SetSpeaker(hyko)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_186']))
		GAME:WaitFrames(12)

		--Il s'ecarte pour laisser passer le maitre de guilde : le
		--mouvement raconte le passage de relais mieux qu'une phrase.
		local h1 = TASK:BranchCoroutine(function()
			pcall(function() GeneralFunctions.EightWayMove(hyko, 224, 192, false, 1) end)
			pcall(function() GROUND:CharTurnToCharAnimated(hyko, hero, 4) end)
		end)
		local h2 = TASK:BranchCoroutine(function()
			GAME:WaitFrames(14)
			UI:SetSpeaker(hyko)
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_187']))
		end)
		TASK:JoinCoroutines({h1, h2})
		GAME:WaitFrames(15)
	end

	--PENTICUS S'OCCUPE DES BLESSES. Il se penche d'abord, il parle
	--ensuite : le corps avant la bouche.
	if penticus ~= nil then
		pcall(function() GROUND:CharTurnToCharAnimated(penticus, hero, 4) end)
		pcall(function() GROUND:CharSetEmote(penticus, "sweatdrop", 1) end)
		GAME:WaitFrames(12)
		UI:SetSpeaker(penticus)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_188']))
		GAME:WaitFrames(15)

		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_189']))
		--UNE seule baie Oran, remise en main propre. Le 3e argument de
		--RewardItem est la quantite (GeneralFunctions.lua:1245) : sans
		--lui, la fonction donne un stack entier.
		GeneralFunctions.RewardItem("berry_oran", false, 1)
		GAME:WaitFrames(20)
	end

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

	--PENTICUS constate le mieux : c'est lui qui a donne la baie, c'est
	--donc lui qui en lit l'effet. MWE5_121 (« Respirez... voila. Le vent
	--vous a battus, pas brises. ») est une phrase de soignant : elle
	--etait attribuee a Hyko, qui ne soigne pas. Elle revient au maitre
	--de guilde, dont c'est exactement le registre.
	if penticus ~= nil then
		pcall(function() GROUND:CharSetEmote(penticus, "", 0) end)
		UI:SetSpeaker(penticus)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_190']))
		GAME:WaitFrames(12)
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
		--LES PROVISIONS DE REPART, ET RIEN DE PLUS.
		--La Baie Oran du secours a deja ete remise plus haut, une seule,
		--en main propre : c'est le geste de soin. Ce lot-ci est autre
		--chose — de quoi RETENTER l'ascension. Les redonner en double
		--(l'ancien code remettait une Pomme, DEUX Oran et une Mepo,
		--stacks entiers) noyait le geste de secours sous un inventaire.
		GeneralFunctions.RewardItem("food_apple", false, 1)
		GeneralFunctions.RewardItem("berry_leppa", false, 1)
		GAME:WaitFrames(15)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_125']))
	end
	GAME:WaitFrames(20)

	--HYKO ASSUME SA LIMITE. C'est le coeur du correctif demande : il ne
	--soigne pas, il le SAIT, et il le dit lui-meme. Ce qui aurait pu
	--n'etre qu'une contrainte technique devient un trait de caractere,
	--et prepare l'arc du personnage (il veut monter avec l'equipe).
	if hyko ~= nil then
		pcall(function() GROUND:CharTurnToCharAnimated(hyko, hero, 4) end)
		pcall(function() GeneralFunctions.EmoteAndPause(hyko, "Sweatdrop", true) end)
		UI:SetSpeaker(hyko)
		UI:SetSpeakerEmotion("Sigh")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_191']))
		GAME:WaitFrames(15)
		--Puis il se redresse : la promesse, pas la plainte.
		pcall(function() GROUND:CharSetEmote(hyko, "determined", 1) end)
		UI:SetSpeakerEmotion("Determined")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_192']))
		GAME:WaitFrames(20)
	end

	--Penticus et Rin regagnent le camp ; le duo reste libre devant
	--l'entree, pret a retenter l'ascension.
	--Les trois regagnent EXACTEMENT leur poste de SetupGround : quand la
	--camera revient au joueur, le camp est dans l'etat ou il le trouvera
	coro1 = TASK:BranchCoroutine(function()
		if penticus ~= nil then
			--Contourne le foyer par l'ouest, puis descend a son poste sud.
			GeneralFunctions.EightWayMove(penticus, 232, 196, false, 1)
			GeneralFunctions.EightWayMove(penticus, 232, 256, false, 1)
			GeneralFunctions.EightWayMove(penticus, 252, 268, false, 1)
			GROUND:CharAnimateTurnTo(penticus, Direction.Up, 4)
		end
	end)
	coro2 = TASK:BranchCoroutine(function()
		if hyko ~= nil then
			GAME:WaitFrames(12)
			--Contourne par l'est pour rejoindre son poste de garde.
			GeneralFunctions.EightWayMove(hyko, 308, 196, false, 1)
			GeneralFunctions.EightWayMove(hyko, 300, 236, false, 1)
			GROUND:CharAnimateTurnTo(hyko, Direction.Left, 4)
		end
	end)
	coro3 = TASK:BranchCoroutine(function()
		if phileas ~= nil then
			GAME:WaitFrames(20)
			GeneralFunctions.EightWayMove(phileas, 212, 180, false, 1)
			GROUND:CharAnimateTurnTo(phileas, Direction.Down, 4)
			--Il se rendort : il a veille toute la nuit.
			GROUND:CharSetAnim(phileas, "Sleep", true)
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

-- RetreatReturnCutscene : l'equipe a fait demi-tour d'elle-meme.
-- Version courte et digne : pas de KO, Penticus salue la sagesse du
-- repli (l'exact oppose de la lecon du Tunnel, ou fuir etait un echec).
function mount_windswept_entrance_ch_5.RetreatReturnCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local penticus = CH('Tropius')

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()

	--ECRAN NOIR D'ABORD. Le moteur ne pose aucun fondu entre deux cartes
	--(GameManager.moveToZoneInit : « no fade; the script handles that
	--itself ») : ce que le script laisse a l'ecran y reste. Sans ce
	--FadeOut en tete, la carte est visible pendant qu'on y teleporte les
	--personnages et qu'on deplace la camera — le joueur voit la mise en
	--place. Instantane (1 frame) et idempotent.
	GAME:FadeOut(false, 1)

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

		--Retour au poste EXACT de SetupGround, foyer contourne (le trajet
		--direct traversait le bloqueur de collision du feu).
		local c6 = TASK:BranchCoroutine(function()
			GeneralFunctions.EightWayMove(penticus, 232, 196, false, 1)
			GeneralFunctions.EightWayMove(penticus, 232, 256, false, 1)
			GeneralFunctions.EightWayMove(penticus, 252, 268, false, 1)
			GROUND:CharAnimateTurnTo(penticus, Direction.Up, 4)
		end)
		local c7 = TASK:BranchCoroutine(function()
			if hyko ~= nil then
				GAME:WaitFrames(14)
				GeneralFunctions.EightWayMove(hyko, 308, 196, false, 1)
				GeneralFunctions.EightWayMove(hyko, 300, 236, false, 1)
				GROUND:CharAnimateTurnTo(hyko, Direction.Left, 4)
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
	--Le foyer disparait avec le decor : son bloqueur de collision aussi.
	mount_windswept_entrance_ch_5.RemoveFireBlocker()
end

-- LE FEU DE CAMP BLOQUE LE PASSAGE.
function mount_windswept_entrance_ch_5.AddFireBlocker()
	pcall(function()
		--Idempotent : deux appels de suite ne doivent pas empiler deux
		--boites (BuildCampDay est rejoue par plusieurs branches).
		mount_windswept_entrance_ch_5.RemoveFireBlocker()
		local blocker = RogueEssence.Ground.GroundObject(
			RogueEssence.Content.ObjAnimData("", 1),
			RogueElements.Rect(mount_windswept_entrance_ch_5.CAMP_X + 6,
			                   mount_windswept_entrance_ch_5.CAMP_Y + 6, 24, 24),
			RogueElements.Loc(0, 0),
			false,
			"Campfire_Blocker")
		blocker:ReloadEvents()
		GAME:GetCurrentGround():AddTempObject(blocker)
		mount_windswept_entrance_ch_5.fireBlocker = blocker
	end)
end

function mount_windswept_entrance_ch_5.RemoveFireBlocker()
	pcall(function()
		local b = mount_windswept_entrance_ch_5.fireBlocker
		if b ~= nil then
			GAME:GetCurrentGround():RemoveTempObject(b)
			mount_windswept_entrance_ch_5.fireBlocker = nil
		end
	end)
end

-- LE CAMP DE JOUR — feu + materiel d'expedition, AUCUNE paillasse.
-- Prompt Maitre 6.3 : les couchages n'existent qu'apres la transition
-- jour -> soir, deployes par les personnages a la fin de la veillee.
-- Le camp de jour ne montre donc que le feu et le materiel range :
-- sacs (Grassy_Bag) et caisses (Yellow_Box), assets attestes dans
-- Content/Object/ et deja poses ailleurs (guild_guildmasters_room).
function mount_windswept_entrance_ch_5.BuildCampDay()
	mount_windswept_entrance_ch_5.PurgeDecor()
	local ground = GAME:GetCurrentGround()
	local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)

	--Le feu, centre du camp.
	ground.Decorations[0].Anims:Add(
		RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(
			mount_windswept_entrance_ch_5.CAMP_X, mount_windswept_entrance_ch_5.CAMP_Y)))
	--Et sa collision : une GroundAnim seule se traverse (cf. AddFireBlocker).
	mount_windswept_entrance_ch_5.AddFireBlocker()

	--SAC RETIRE A LA DEMANDE. Le Grassy_Bag pose en (260,196), juste au
	--nord du foyer, encombrait le centre du camp — c'est precisement la
	--zone ou se joue le repas, ou Penticus tient son adresse et ou passe
	--tout le trafic vers le sentier nord. Le materiel d'expedition reste
	--raconte par les couchages et le foyer.
end

-- LE CAMP DU MATIN — feu eteint, sac pret au depart (Prompt 6.8).
-- Distinct du camp de jour : au matin du depart, le feu est ETEINT
-- (aucune animation de flammes) et il ne reste que le sac commun.
-- C'est aussi ce qui libere l'axe du rassemblement : Penticus se
-- tient en (256,240), l'ancien feu (256,220) le chevauchait.
function mount_windswept_entrance_ch_5.BuildCampMorning()
	mount_windswept_entrance_ch_5.PurgeDecor()
	--Camp du matin : le feu est eteint, le sac a ete retire (il genait le
	--centre du camp). Le calque est donc VIDE, et l'axe du rassemblement
	--entierement degage — Penticus peut tenir son adresse en (256,232)
	--sans se cogner au bloqueur du foyer, qui n'existe plus a ce moment.
	--PurgeDecor a deja retire ce bloqueur.
end

-- LE DEPLOIEMENT DES COUCHAGES — la nuit seulement.
-- Appele par CampNightfall sous le fondu de la tombee de la nuit :
-- 12 paillasses = 12 membres presents (10 guilde + le duo), pas une
-- de plus. Le feu reste, le materiel de jour est remplace.
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
		RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(
			mount_windswept_entrance_ch_5.CAMP_X, mount_windswept_entrance_ch_5.CAMP_Y)))
	--Le foyer de la nuit bloque lui aussi : on ne traverse pas les braises
	--pour aller se coucher.
	mount_windswept_entrance_ch_5.AddFireBlocker()
end

-- POSITION DES COUCHAGES — 12 paillasses en fer a cheval
-- Sortie en table pour que la cinematique et le decor permanent ne
-- puissent plus diverger.
-- CE QUI N'ALLAIT PAS DANS L'ANCIENNE DISPOSITION (tout mesure) :
--   * LE LIT 12 ETAIT INATTEIGNABLE. (344,132) est du sol libre, mais
--     il appartient a une POCHE ISOLEE au nord-est : un parcours en
--     largeur depuis l'entree du joueur ne l'atteint pas. La carte
--     compte 3 composantes connexes de sol libre ; ce lit tombait dans
--     la mauvaise. Son dormeur aurait ete injoignable, et l'animation
--     de coucher se serait terminee contre un mur.
--   * QUATRE PAIRES DE PAILLASSES SE CHEVAUCHAIENT. Le sprite Hay_Bed
--LE CAMP EST DEFINI PAR RAPPORT A SON FOYER.
--Procede repris d'Halcyon (mount_windswept_entrance_ch_5.lua de la branche
--working-copy, l.128-131), ou les douze paillasses derivent de deux
--constantes `bedRelativeX/bedRelativeY`, avec ce commentaire de l'auteur :
--« so I can copy and paste this code into other scenes and only change one
--value ». Deplacer le bivouac ne demande alors qu'une seule modification.
--
--Ici l'origine est le foyer lui-meme, puisque c'est autour de lui que tout
--s'organise : les couchages, le cercle du repas, les places de garde.
mount_windswept_entrance_ch_5.CAMP_X = 256
mount_windswept_entrance_ch_5.CAMP_Y = 220

local CX = mount_windswept_entrance_ch_5.CAMP_X
local CY = mount_windswept_entrance_ch_5.CAMP_Y

--Les onze couchages, en decalage par rapport au foyer. Valeurs identiques
--aux anciennes coordonnees absolues, au pixel pres : le placement verifie
--(sol libre, sprite 40x40, aucun recouvrement) est donc conserve tel quel.
mount_windswept_entrance_ch_5.BEDS = {
	{CX -  8, CY - 104}, {CX + 42, CY -  52}, {CX + 88, CY - 52},
	{CX + 100, CY -  6}, {CX + 92, CY +  40}, {CX + 66, CY + 86},
	{CX -  46, CY + 90}, {CX - 92, CY +  66}, {CX - 102, CY + 20},
	{CX - 102, CY - 26}, {CX - 60, CY +   4},
}
--LA COUCHE 11 (Kino) EST A LA PLACE DU SAC, contre le feu.
--Elle etait reléguee en (362,300), a 136 px du foyer, sur le flanc est
--— le plus loin de tous. Or c'est la couche qui compte : au matin, Rin
--vient y secouer Kino qui dort encore, et toute la scene comique se joue
--autour. La jouer a l'autre bout du camp obligeait la camera a quitter
--le foyer, et Rin a traverser tout le bivouac.
--Elle occupe donc l'emplacement du sac commun (196,224) : 58 px du feu

function mount_windswept_entrance_ch_5.SetupGround()	
	-- LE CAMP APRES LE DEPART DE L'EXPEDITION — QUI RESTE, ET POURQUOI
	-- INCOHERENCE MAJEURE CORRIGEE. Cette fonction respawnait HUIT PNJ,
	-- dont CINQ que la cinematique d'intro venait de faire partir en
	-- expedition sous les yeux du joueur (GROUND:Hide en fin d'intro) :
	--     Kino (Breloom), Reinier (Girafarig), Almotz (Zigzagoon)
	--     -> vague d'ouverture, montent tracer la voie
	--     Rin (Audino), Coco (Snubbull)
	--     -> cordee de soutien, montent au relais
	-- Le joueur les regardait remonter le sentier nord et disparaitre,
	-- puis reprenait la main... devant les cinq memes, plantes au camp.
	-- Le commentaire d'origine s'en justifiait par « redescendues au
	-- relais entre deux rotations » — sauf que la scene ne montre AUCUNE
	-- redescente : elle les montre MONTER.
	-- NE RESTENT DONC QUE CEUX QUE LA SCENE LAISSE SUR PLACE :
	--   * PENTICUS (Tropius) : il tient le camp de base, il l'a dit.
	--   * PHILEAS (Noctowl)  : idem, les vents le portent mal.
	--   * HYKO (Growlithe)   : garde au camp par Penticus (arc du Tunnel,
	--                          paye par la scene du vent).
	-- Trois PNJ, exactement les trois que la cinematique finale laisse
	-- devant la porte du donjon. La cordee du sommet (heros, partenaire,
	-- Ganlon, Shuca) est dans l'equipe du joueur, pas en PNJ.
	-- POSITIONS : verifiees sol libre, connexes depuis l'entree, hors
	-- empreinte du feu (36x36 en 256,220), hors rocher de Kangaskhan
	-- (32x32 en 160,144) et hors des onze paillasses.
	-- COMPOSITION DU CAMP — trois postes qui racontent trois roles.
	-- RETOUR DE L'UTILISATEUR : « Penticus et Hyko devraient etre
	-- positionnes esthetiquement ». Les trois etaient agglutines au
	-- nord-ouest (230,190 / 288,196 / 224,206), tous tournes vers le
	-- bas, sans rapport au foyer : un alignement de PNJ, pas un camp.
	-- Nouvelle composition, construite AUTOUR DU FEU (dessine
	-- x256..291 / y220..255, foyer au centre en 274,238) :
	--        Phileas (endormi, en retrait nord-ouest)
	--                    .
	--                 [ FEU ]        Hyko  (garde, a l'est, face au feu)
	--                    .
	--            Penticus (au sud, face au sentier d'arrivee)
	--   * PENTICUS au SUD, tourne vers le HAUT : il fait face au sentier
	--     par lequel on arrive. Le maitre de guilde guette le retour de
	--     ses equipes — c'est sa premiere replique de la carte
	--     (« j'ai guette ce sentier toute la soiree ») rendue visible.
	--   * HYKO a l'EST, tourne vers le feu : en poste, mais au chaud.
	--   * PHILEAS en RETRAIT au nord-ouest, ENDORMI. Il a veille la
	--     nuit (section 7) ; patron du Tunnel, searing_tunnel_entrance
	--     _ch_5.lua:36-37, ou Noctowl dort pendant que Tropius assure.
	-- Toutes verifiees SPRITE COMPRIS (Tropius 40x40, Noctowl 38x32,
	-- Growlithe 32x28, ancrage GroundAction.GetDrawLoc:116) : aucune ne
	-- recouvre les flammes, ni le bloqueur du foyer, ni le rocher de
	-- Kangaskhan, ni aucune des onze paillasses. Ecarts de 48 a 88 px :
	-- lisibles a l'ecran, et tous les trois tiennent dans un plan.
	local tropius, noctowl, growlithe =
	CharacterEssentials.MakeCharactersFromList({
		{'Tropius', 252, 268, Direction.Up},
		{'Noctowl', 212, 180, Direction.Down},
		{'Growlithe', 300, 236, Direction.Left}
	})
	--Phileas dort a son poste : il n'est pas alle se coucher, il s'est
	--assoupi la ou il veillait.
	pcall(function() GROUND:CharSetAnim(noctowl, "Sleep", true) end)
	--Rendus nil explicitement : plusieurs branches de ce fichier les
	--testent encore (if rin ~= nil...), et un nil franc vaut mieux
	--qu'un PNJ fantome qui n'a rien a faire la.
	local audino, snubbull, zigzagoon, breloom, girafarig = nil, nil, nil, nil, nil

	--Ganlon et Shuca voyagent avec le joueur : s'ils sont dans l'equipe
	--(post-intro), on les fait apparaitre pres du duo via les spawners
	--TEAMMATE_2/3 (patron exact du camp du Tunnel, spawners presents
	if GAME:GetPlayerPartyCount() > 3 then
		GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
		GROUND:SpawnerDoSpawn("TEAMMATE_2")
		GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
		GROUND:SpawnerDoSpawn("TEAMMATE_3")
	end

	-- LE CAMP DE JOUR — ET PAS DE FEU APRES UNE DEFAITE.
	if SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind
	   or SV.Chapter5.PlayTempMountScene then
		mount_windswept_entrance_ch_5.BuildCampMorning()
	else
		mount_windswept_entrance_ch_5.BuildCampDay()
	end

	--Apres une defaite en montagne, PHILEAS descend de son perchoir
	--pour veiller sur les blesses : il ne dort plus, il surveille.
	--DEUX BUGS ICI. Le bloc deplacait a l'origine Rin, partie avec la
	--cordee de soutien : le TeleportTo s'appliquait a un `audino` nil,
	--donc a rien. Puis, une fois reporte sur Phileas, il le posait en
	--(276,236) — soit 756 px de son sprite DANS les flammes, et son
	--collider EN PLEIN dans le bloqueur du foyer : il s'y serait
	--retrouve coince des le retour du controle au joueur.
	--Il se poste donc a l'ouest du foyer, tourne vers lui, sprite
	if SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind then
		pcall(function()
			GROUND:CharEndAnim(noctowl)
			GROUND:TeleportTo(noctowl, 224, 236, Direction.Right)
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
	-- L'OST D'ARRIVEE — le camp s'entend avant de se voir.
	SOUND:PlayBGM('Cliff Camp.ogg', true)
	--ARRIVEE PAR LE SUD. L'expedition debouche du sentier au bas de la
	--carte et remonte en ligne droite la colonne x=256, verifiee
	--praticable en continu de y=488 jusqu'au camp.
	GAME:FadeOut(false, 1)

	GAME:MoveCamera(256, 456, 1, false)
	--TRANSITION JOUR -> SOIR (Prompt Maitre 6.2). L'expedition arrive au
	--couchant : "dusk" d'abord (patron exact de l'arrivee au Tunnel), la
	--nuit noire ("darkness") ne tombe qu'au deploiement des couchages.
	GROUND:AddMapStatus("dusk")
	
	GROUND:TeleportTo(hero, 256, 456, Direction.Up)
	GROUND:TeleportTo(partner, 256, 472, Direction.Up)
	
	-- LE CAMP EXISTE AVANT NOUS.
	local audino, snubbull, girafarig, breloom, growlithe, zigzagoon, tropius, noctowl, mareep, cranidos = 
	CharacterEssentials.MakeCharactersFromList({
		{'Audino',    222, 266, Direction.UpRight},
		{'Snubbull',  300, 214, Direction.Left},
		{'Girafarig', 292, 276, Direction.Up},
		{'Breloom',   240, 276, Direction.Up},
		{'Growlithe', 240, 488, Direction.Up},
		{'Zigzagoon', 272, 488, Direction.Up},
		{'Tropius',   230, 190, Direction.DownRight},
		{'Noctowl',   288, 196, Direction.DownLeft},
		{'Mareep',    246, 176, Direction.Down},
		{'Cranidos',  310, 236, Direction.Left}
	})

	--KINO ET REINIER NE SONT PAS ENCORE LA.
	GROUND:Hide(breloom.EntName)
	GROUND:Hide(girafarig.EntName)
	
	--LE CAMP DE JOUR. Aucune paillasse a l'arrivee (Prompt Maitre 6.3) :
	--les couchages ne sont deployes qu'a la fin de la veillee, sous le
	--fondu de la tombee de la nuit (CampNightfall, section 7). Ici :
	--feu + materiel range, via le constructeur partage qui purge le
	--calque (le doublement de decor d'avant ne peut plus se produire).
	mount_windswept_entrance_ch_5.BuildCampDay()

	--RESPIRATION NOIRE (transition depuis le Crucible, PROMPT_MAITRE.md) :
	--le joueur arrive en noir complet apres 90 frames de silence dans le
	--Crucible. La musique du camp monte DANS le noir — grammaire "le son,
	--puis l'image, puis le mot". 30 frames de respiration avant les mots.
	GAME:WaitFrames(30)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_001'], tunnel:GetColoredName()))
	GAME:WaitFrames(15)
	-- Growlithe se tourne vers l'arrivee (sous le noir, prepare le FadeIn :
	-- quand l'image monte, il regarde deja le duo).
	pcall(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Down, 4) end)
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_002']))
	GAME:WaitFrames(15)
	
	GAME:FadeIn(40)
	
	-- LE CAMP VIT PENDANT QU'ON MONTE.
	-- Pendant toute la remontee du sentier, le camp continue ses
	-- occupations SANS savoir qu'on arrive : Coco s'affaire au feu, Rin
	-- range, Ganlon fait les cent pas, Penticus surveille la montagne.
	-- Le joueur voit donc un lieu deja habite, avec sa propre vie, avant
	-- d'y entrer — c'est exactement ce que fait un Donjon Mystere.
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
		GAME:MoveCamera(264, 262, 110, false)
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

	-- LE CAMP REMARQUE QU'ON ARRIVE.
	-- Les six sont deja en place et visibles depuis le debut de la scene
	-- (cf. MakeCharactersFromList plus haut) : plus aucun Unhide en bloc,
	-- plus aucun TeleportTo qui les ferait sauter d'un point a l'autre
	-- sous les yeux du joueur. Il ne reste donc ici qu'une chose a
	-- jouer — le moment ou ils LEVENT LA TETE.
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

	-- SIX ACCUEILS, SIX CARACTERES.
	-- RETOUR DE L'UTILISATEUR : « faut des reactions diverses selon
	-- leurs personnalites ». Le camp levait bien la tete, mais tout le
	-- monde faisait EXACTEMENT le meme geste — se tourner — avant
	-- d'enchainer sur un dialogue logistique. Six Pokemon, une seule
	-- reaction : le groupe n'existait pas comme groupe de personnes.
	-- Chacun accueille donc a sa maniere, et cette maniere est deja
	-- ecrite ailleurs dans le mod (on ne reinvente aucun caractere) :
	--   * PENTICUS le maitre de guilde a guette toute la soiree —
	--     soulagement, mais il tient sa facade (c'est tout son arc du
	--     chapitre : la panique sous le calme).
	--   * PHILEAS l'archiviste a COMPTE les heures. Il donne un chiffre.
	--   * SHUCA la recrue explose de joie, se reprend a mi-phrase.
	--   * RIN l'infirmiere ne dit pas bonjour : elle inspecte.
	--   * COCO la cuisiniere parle nourriture, immediatement.
	--   * GANLON le raleur ne felicite personne, il tacle.
	-- Puis Phileas donne l'explication meteo — la vraie raison du
	-- retard — ce qui enchaine naturellement sur MWE5_006 juste apres.
	-- Les gestes sont tous des API attestees du depot (CharSetEmote,
	-- Hop, DoAnimation, EmoteAndPause, CharTurnToCharAnimated) et tout
	-- passe par SaysA, qui tourne les tetes AVANT d'ouvrir la boite.
	--Helpers d'ecoute, definis AVANT leur premiere utilisation (le bloc
	--d'accueil ci-dessous s'en sert). En Lua un `local function` n'est
	--visible qu'apres sa definition : les laisser plus bas rendait
	--SaysA nil au moment des accueils.
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

	local function greet(who, emotion, key, gesture)
		local g = TASK:BranchCoroutine(function()
			GAME:WaitFrames(8)
			pcall(gesture)
		end)
		local s = TASK:BranchCoroutine(function()
			SaysA(who, emotion, key, {hero, partner})
		end)
		TASK:JoinCoroutines({g, s})
		GAME:WaitFrames(12)
	end

	--Penticus : le soulagement d'abord, la contenance ensuite.
	greet(tropius, "Happy", 'MWE5_172', function()
		--"Exclaim" et non "Relieved" : ce dernier n'existe NULLE PART
		--ailleurs dans le depot (0 occurrence), c'etait une invention.
		GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true)
	end)

	--Phileas : il annonce un chiffre, il ne se rejouit pas.
	greet(noctowl, "Normal", 'MWE5_173', function()
		GROUND:CharSetEmote(noctowl, "notice", 1)
	end)

	--Shuca : elle bondit. Litteralement.
	greet(mareep, "Joyous", 'MWE5_174', function()
		GeneralFunctions.Hop(mareep, "Idle", 10, 22, 0, false)
		GROUND:CharSetEmote(mareep, "glowing", 1)
	end)

	--Rin : elle s'avance sur le duo au lieu de parler de loin.
	local rinWalk = TASK:BranchCoroutine(function()
		pcall(function()
			--(216,286) et non (234,288) : ce dernier passait sur le heros,
			--poste en (240,300). Trajet et case verifies sur la grille.
			GeneralFunctions.EightWayMove(audino, 216, 286, false, 1)
			GROUND:CharTurnToCharAnimated(audino, hero, 4)
		end)
	end)
	TASK:JoinCoroutines({rinWalk})
	greet(audino, "Worried", 'MWE5_175', function()
		GROUND:CharSetEmote(audino, "sweatdrop", 1)
	end)

	--Coco : la soupe. Toujours la soupe.
	greet(snubbull, "Happy", 'MWE5_176', function()
		GeneralFunctions.EmoteAndPause(snubbull, "Happy", true)
	end)

	--Ganlon : il ne se retourne meme pas tout de suite.
	greet(cranidos, "Normal", 'MWE5_177', function()
		GROUND:CharSetEmote(cranidos, "sweatdrop", 1)
	end)

	--Phileas conclut par l'explication meteo : elle amene MWE5_006.
	greet(noctowl, "Normal", 'MWE5_178', function()
		GROUND:CharAnimateTurnTo(noctowl, Direction.Up, 4)
		GAME:WaitFrames(10)
		GROUND:CharTurnToCharAnimated(noctowl, hero, 4)
	end)

	-- L'ACCUEIL AU CAMP — quinze repliques, et personne ne bougeait.
	-- C'ETAIT LE PIRE PASSAGE DE LA CARTE. Mesure avant correction :
	-- ArrivalCutscene comptait 18 repliques dont 17 SANS la moindre
	-- reaction corporelle (94 %). Quinze boites de dialogue defilaient
	-- d'affilee devant huit sprites parfaitement immobiles, qui ne se
	-- tournaient meme pas vers celui qui parlait.
	-- Les helpers Listen/Says de la veillee sont locaux a CampNightfall.
	-- On redefinit ici les memes, sur les variables locales de cette
	-- scene (tropius, noctowl... et non t.penticus, t.phileas...).

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

	-- LA VEILLEE — le camp mange, puis s'endort
	mount_windswept_entrance_ch_5.CampNightfall(
		hero, partner, {penticus = tropius, phileas = noctowl,
		                rin = audino,      coco = snubbull,
		                shuca = mareep,    ganlon = cranidos,
		                hyko = growlithe,  almotz = zigzagoon,
		                reinier = girafarig, kino = breloom})

	GAME:FadeOut(false, 40)
	GAME:WaitFrames(40)
	-- LE CAMP NE DOIT PAS SE VIDER.
	for _, chara in ipairs({audino, snubbull, girafarig, breloom, zigzagoon, mareep, cranidos}) do
		GAME:GetCurrentGround():RemoveTempChar(chara)
	end

	--Les trois qui tiennent le camp reprennent le poste exact que leur
	--donne SetupGround, pour que rien ne bouge quand le joueur reviendra
	--du donjon : Penticus (230,190), Phileas (288,196), Hyko (224,206).
	pcall(function()
		GROUND:TeleportTo(tropius,   252, 268, Direction.Up)
		GROUND:TeleportTo(noctowl,   212, 180, Direction.Down)
		GROUND:TeleportTo(growlithe, 300, 236, Direction.Left)
		--Phileas a veille la nuit : au matin, il dort a son poste.
		GROUND:CharSetAnim(noctowl, "Sleep", true)
	end)

	--LA SCENE NE SE TERMINE PAS ICI. CampNightfall part desormais vers
	--la carte du reve (hero_dream) : la cloture de l'intro — SetParty,
	--le drapeau FinishedMountWindsweptIntro, le rendu du controle — a
	--donc ete deplacee a la FIN de MorningAfterDream, seule fonction
	--qui s'execute encore apres le retour du reve. La laisser ici
	--l'aurait rendue inatteignable, et l'intro se serait rejouee en
	--boucle a chaque entree sur la carte.

end 

--Ganlon hasn't been getting to act like a jerk much this expedition; give him some opportunies for his jerkiness to shine through here
-- PNJ du camp de base — dialogues a variantes (Prompt Maitre §4.2)
-- Etats : avant l'entree / apres defaite / apres mini-boss / apres gardien.

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
	--ON LE REVEILLE AVANT QU'IL PARLE. Phileas dort a son poste depuis
	--SetupGround (il a veille toute la nuit). Sans cette levee, son
	--animation « Sleep » est BOUCLEE : il tiendrait tout son dialogue
	--les yeux fermes, couche. Le sursaut fait aussi le gag — on prend
	--l'archiviste en flagrant delit de sieste.
	pcall(function()
		GROUND:CharEndAnim(chara)
		GeneralFunctions.EmoteAndPause(chara, "Exclaim", true)
		GROUND:CharTurnToCharAnimated(chara, CH('PLAYER'), 4)
	end)
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

-- LÉGENDE : « L'Arbitre du Ciel » (Reinier, veteran des caravanes)
-- Mentions : Rayquaza (l'Arbitre, nomme a la fin seulement), Kyogre et
-- Groudon evoques comme « la mer et la terre en guerre ». Motif New Era :
-- l'Arbitre n'intervient que si le ciel est franchi — echo au Fragment
-- (Meteno) tombe pres du relais, et prefiguration lointaine du lore
-- Fil du Destin reserve a l'arc Jirachi.
-- OST : Sky Peak Cave -> Rising Fear (bref) -> retour.
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
	GAME:FadeOut(false, 1)

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
