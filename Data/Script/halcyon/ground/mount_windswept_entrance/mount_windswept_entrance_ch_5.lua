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
--   4. LE SONGE        map 'songe_source' : le heros physiquement dans
--                      son reve, Gardevoir (docs/CONCEPTION_songe_source.md)
--   5. LE REVEIL       agite, dans la nuit du camp — la veille de Phileas
--   6. LE MATIN        reveil par Rin, gag de Kino, briefing de Penticus
--
-- La nuit se joue en TROIS cartes-coupures : la veillee (CampNightfall,
-- sections 1-9), le songe (songe_source.PlayDream), puis la fin de
-- nuit (DreamWakeAndMorning : reveil, veille, sections 11-16).
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

	--Assignation des couches. La cle est le personnage, la valeur est
	--{index de lit, direction assise}. Le +13/+10 du Tunnel place le
	--sprite au centre de la paillasse.
	local seats = {
		{t.penticus, 1,  Direction.Down},
		{t.phileas,  2,  Direction.Down},
		{t.reinier,  3,  Direction.Left},
		{t.ganlon,   4,  Direction.Up},
		{t.shuca,    5,  Direction.Up},
		{partner,    6,  Direction.Up},
		{hero,       7,  Direction.Up},
		{t.hyko,     8,  Direction.Up},
		{t.almotz,   9,  Direction.Right},
		{t.rin,      10, Direction.Down},
		{t.kino,     11, Direction.Left},
		{t.coco,     12, Direction.Down},
	}
	local function seatX(i) return B[i][1] + 13 end
	local function seatY(i) return B[i][2] + 10 end

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
	local coro5 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(t.kino, 236, 330, false, 1)
	end)
	local coro6 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:MoveToPosition(t.reinier, 276, 330, false, 1)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6})

	GAME:WaitFrames(10)
	UI:SetSpeaker(t.kino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_021']))
	GAME:WaitFrames(15)
	UI:SetSpeaker(t.reinier)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_022']))
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
	for i, s in ipairs(seats) do
		local chara, bed, dir = s[1], s[2], s[3]
		settle[#settle+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(i * 6)
			GROUND:MoveToPosition(chara, seatX(bed), seatY(bed), false, 1)
			GROUND:CharAnimateTurnTo(chara, dir, 4)
		end)
	end
	TASK:JoinCoroutines(settle)
	GAME:WaitFrames(20)

	--La nourriture apparait devant chaque convive, comme au Tunnel :
	--Food au sud du personnage pour la moitie haute du cercle,
	--Food_Flipped au nord pour la moitie basse.
	local foods = {}
	for i, s in ipairs(seats) do
		local bed, dir = s[2], s[3]
		local anim, fy
		if dir == Direction.Up then
			anim, fy = "Food_Flipped", B[bed][2]
		else
			anim, fy = "Food", B[bed][2] + 22
		end
		local food = RogueEssence.Ground.GroundObject(
			RogueEssence.Content.ObjAnimData(anim, 1, 0, 0),
			RogueElements.Rect(B[bed][1] + 13, fy, 16, 16),
			RogueElements.Loc(0, 0),
			false,
			"CampFood" .. tostring(i))
		food:ReloadEvents()
		GAME:GetCurrentGround():AddTempObject(food)
		foods[#foods+1] = food
	end

	--Tout le monde mange en meme temps.
	for _, s in ipairs(seats) do
		GROUND:CharSetAnim(s[1], "Eat", true)
		GROUND:CharSetEmote(s[1], "eating", 0)
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
	for _, s in ipairs(seats) do
		GROUND:CharEndAnim(s[1])
		GROUND:CharSetEmote(s[1], "", 0)
	end
	SOUND:LoopSE('AMB_Fire_Loud')
	GAME:WaitFrames(20)

	---------------------------------------------------------------
	-- 3. LA TABLEE — la cuisiniere, le ronchon, la premiere fois
	---------------------------------------------------------------
	--R2 : la cuisiniere rayonne, les convives reagissent (une replique =
	--un geste, standard du Tunnel).
	UI:SetSpeaker(t.coco)
	UI:SetSpeakerEmotion("Happy")
	coro1 = TASK:BranchCoroutine(function()
		GROUND:CharSetEmote(t.coco, "glowing", 1)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_024']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:CharSetEmote(partner, "happy", 1)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		GROUND:CharSetEmote(t.hyko, "happy", 1)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
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
	UI:SetSpeaker(t.coco)
	UI:SetSpeakerEmotion("Joyous")
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_026'], t.ganlon:GetDisplayName()))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(6)
		--pris sur le fait : son compliment a ete entendu
		GROUND:CharSetEmote(t.ganlon, "sweatdrop", 1)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(15)

	UI:SetSpeaker(t.shuca)
	UI:SetSpeakerEmotion("Happy")
	--elle pose sa question a la cuisiniere
	GROUND:CharTurnToCharAnimated(t.shuca, t.coco, 4)
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_027']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		--la premiere fois a la belle etoile, c'est aussi la sienne
		GROUND:CharSetEmote(hero, "notice", 1)
	end)
	TASK:JoinCoroutines({coro1, coro2})
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
	UI:SetSpeaker(t.penticus)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_035'], t.phileas:GetDisplayName()))
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

	coro1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(t.rin, seatX(4) - 24, seatY(4), false, 1)
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

	--Rin retourne a sa place.
	GROUND:MoveToPosition(t.rin, seatX(10), seatY(10), false, 1)
	GROUND:CharAnimateTurnTo(t.rin, Direction.Down, 4)
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
	local heads = {}
	local listeners = {partner, hero, t.hyko, t.almotz, t.rin, t.coco, t.shuca, t.ganlon, t.reinier, t.kino}
	for i, c in ipairs(listeners) do
		heads[#heads+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(i * 3)
			GROUND:CharTurnToCharAnimated(c, t.penticus, 4)
		end)
	end
	TASK:JoinCoroutines(heads)
	GAME:WaitFrames(10)

	UI:SetSpeaker(t.penticus)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_044'], mountain:GetColoredName()))
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_045']))
	GAME:WaitFrames(15)
	UI:SetSpeaker(t.coco)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_046']))
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
	local sleepOrder = {
		{t.penticus, 1,  0},
		{t.coco,     12, 14},
		{t.shuca,    5,  26},
		{t.ganlon,   4,  40},
		{t.reinier,  3,  52},
		{t.rin,      10, 66},
		{t.kino,     11, 80},
	}
	for _, s in ipairs(sleepOrder) do
		local chara, bed, delay = s[1], s[2], s[3]
		vers[#vers+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(delay)
			GROUND:MoveToPosition(chara, seatX(bed), seatY(bed), false, 1)
			GROUND:CharSetAnim(chara, "Sleep", true)
		end)
	end
	vers[#vers+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GROUND:MoveToPosition(t.phileas, 256, 148, false, 1)
		GROUND:CharAnimateTurnTo(t.phileas, Direction.Down, 4)
	end)
	TASK:JoinCoroutines(vers)
	GAME:WaitFrames(20)

	--Hyko et Almotz chuchotent encore, chacun sur sa couche.
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
	--Le reste du camp dort. La camera se resserre sur le duo : c'est
	--le moment calme obligatoire du Prompt Maitre (6.5), APRES la
	--veillee de groupe, AVANT le sommeil du heros.
	GAME:MoveCamera(238, 274, 45, false)
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

	--La musique du camp meurt avec l'image (audit I5) : le songe
	--(songe_source) montera sa propre plage sous le noir.
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	GAME:WaitFrames(60)

	---------------------------------------------------------------
	-- 10. LE SONGE — DEPLACE sur sa propre carte
	---------------------------------------------------------------
	--Regle 6 du mode operatoire (docs/CARTE_BLANCHE_CUTSCENES.md) : un
	--heros qui dort et reve est PHYSIQUEMENT present dans son reve —
	--jamais un ecran noir. L'ancien reve (planche Genesis_Void sur
	--fondu) a ete demoli ; le songe se joue sur la map 'songe_source'
	--(docs/CONCEPTION_songe_source.md). ArrivalCutscene enchaine sur
	--EnterGroundMap ; la nuit se termine au retour, dans
	--DreamWakeAndMorning ci-dessous.
end


--------------------------------------------------------------------
-- LA NUIT, DEUXIEME PARTIE — retour du songe
--------------------------------------------------------------------
--Jouee au retour de 'songe_source' (route : init.PlotScripting). La
--carte arrive FRAICHE : tout le camp de nuit est reconstruit sous le
--noir, a L'ETAT EXACT ou CampNightfall l'a laisse (qui dort ou, quel
--plan, dans quelle posture), puis :
--  a. LE REVEIL AGITE   le reve colle a la peau, le heros sursaute
--  b. LA VEILLE         Phileas a entendu : il quitte son poste,
--                       s'approche a distance credible, rassure, puis
--                       retourne veiller (trajet BFS prouve :
--                       corridor ouest, ~26 px des dormeurs max)
--  c. LE MATIN          reveil, rassemblement, cordees, departs,
--                       scene finale — reprises a l'identique de la
--                       veillee d'origine.
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.DreamWakeAndMorning()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local B = mount_windswept_entrance_ch_5.BEDS
	local mountain = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('mount_windswept')
	local ruins = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('cloven_ruins')
	local function seatX(i) return B[i][1] + 13 end
	local function seatY(i) return B[i][2] + 10 end

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	GAME:FadeOut(false, 1)

	--Mise en place sous le noir : paillasses + feu (constructeur
	--partage), nuit noire, et CHAQUE dormeur a SA couche dans SA
	--posture de fin de section 9 (Sleep / EventSleep identiques).
	--Phileas, lui, est a son poste de veille (256,148).
	mount_windswept_entrance_ch_5.DeployBeds()
	GROUND:AddMapStatus("darkness")

	local tropius, noctowl, audino, snubbull, girafarig, breloom, growlithe, zigzagoon, mareep, cranidos =
		CharacterEssentials.MakeCharactersFromList({
			{'Tropius',   seatX(1),  seatY(1),  Direction.Down},
			{'Audino',    seatX(10), seatY(10), Direction.Down},
			{'Snubbull',  seatX(12), seatY(12), Direction.Down},
			{'Girafarig', seatX(3),  seatY(3),  Direction.Left},
			{'Breloom',   seatX(11), seatY(11), Direction.Left},
			{'Growlithe', seatX(8),  seatY(8),  Direction.Up},
			{'Zigzagoon', seatX(9),  seatY(9),  Direction.Right},
			{'Mareep',    seatX(5),  seatY(5),  Direction.Up},
			{'Cranidos',  seatX(4),  seatY(4),  Direction.Up},
			{'Noctowl',   256, 148, Direction.Down}
		})
	local t = {penticus = tropius, phileas = noctowl,
	           rin = audino,      coco = snubbull,
	           shuca = mareep,    ganlon = cranidos,
	           hyko = growlithe,  almotz = zigzagoon,
	           reinier = girafarig, kino = breloom}

	GROUND:CharSetAnim(t.penticus, "Sleep", true)
	GROUND:CharSetAnim(t.rin, "Sleep", true)
	GROUND:CharSetAnim(t.coco, "Sleep", true)
	GROUND:CharSetAnim(t.reinier, "Sleep", true)
	GROUND:CharSetAnim(t.kino, "Sleep", true)
	GROUND:CharSetAnim(t.hyko, "Sleep", true)
	GROUND:CharSetAnim(t.almotz, "EventSleep", true)
	GROUND:CharSetAnim(t.shuca, "Sleep", true)
	GROUND:CharSetAnim(t.ganlon, "Sleep", true)
	GROUND:TeleportTo(partner, seatX(6), seatY(6), Direction.Up)
	GROUND:CharSetAnim(partner, "EventSleep", true)
	GROUND:TeleportTo(hero, seatX(7), seatY(7), Direction.Up)
	GROUND:CharSetAnim(hero, "EventSleep", true)

	GAME:MoveCamera(256, 230, 1, false)
	GAME:FadeIn(60)
	GAME:WaitFrames(50)

	---------------------------------------------------------------
	-- a. LE REVEIL AGITE — le reve colle a la peau
	---------------------------------------------------------------
	--Patron du reveil de la DiedCutscene du Tunnel : sursauts, Wake,
	--regard perdu. Personne d'autre ne bouge : il est seul a l'avoir vu.
	GeneralFunctions.Shake(hero)
	GAME:WaitFrames(10)
	GeneralFunctions.Shake(hero)
	GAME:WaitFrames(16)
	GeneralFunctions.DoAnimation(hero, 'Wake')
	GAME:WaitFrames(24)
	GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Up)
	GAME:WaitFrames(14)
	GAME:MoveCamera(232, 262, 70, false)
	GAME:WaitFrames(10)

	--Ses pensees dans la nuit : ce sont les anciennes MWE5_085/086,
	--qui ont plus de poids ICI, au pied du lit, que sur le fondu noir
	--de l'ancien reve.
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Shouting")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_085']))
	GAME:WaitFrames(18)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_086']))
	UI:ResetSpeaker()
	GAME:WaitFrames(26)

	---------------------------------------------------------------
	-- b. LA VEILLE — Phileas ne peut pas rester passif
	---------------------------------------------------------------
	--Le heros s'est reveille en sursaut sous sa fenetre : le veilleur a
	--ENTENDU. Un battement, puis il quitte son poste. Trajet verifie
	--BFS sur la grille du .rsground : corridor a l'ouest du maitre de
	--guilde, jamais a moins de 26 px d'un dormeur ; arret a deux cases
	--du lit (distance credible), tourne vers le heros.
	GROUND:CharSetEmote(t.phileas, "notice", 1)
	GAME:WaitFrames(22)
	GeneralFunctions.EightWayMove(t.phileas, 244, 156, false, 1)
	GeneralFunctions.EightWayMove(t.phileas, 244, 204, false, 1)
	GeneralFunctions.EightWayMove(t.phileas, 236, 268, false, 1)
	GROUND:CharTurnToCharAnimated(t.phileas, hero, 4)
	GAME:WaitFrames(12)

	UI:SetSpeaker(t.phileas)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_090']))
	GAME:WaitFrames(12)

	--Le heros sursaute : il croyait la nuit vide.
	GROUND:CharSetEmote(hero, "shock", 1)
	GROUND:CharTurnToCharAnimated(hero, t.phileas, 4)
	GAME:WaitFrames(10)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_091']))
	UI:ResetSpeaker()
	GAME:WaitFrames(14)

	UI:SetSpeaker(t.phileas)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_118']))
	GAME:WaitFrames(12)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_119']))
	GAME:WaitFrames(18)

	--Le heros rend les armes a la nuit ; Phileas le regarde se
	--recoucher, PUIS repart — on ne quitte jamais le plan avant la
	--fin du geste. Retour par le meme corridor, reposture de veille.
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	GAME:WaitFrames(24)
	GeneralFunctions.EightWayMove(t.phileas, 244, 204, false, 1)
	GeneralFunctions.EightWayMove(t.phileas, 244, 156, false, 1)
	GeneralFunctions.EightWayMove(t.phileas, 256, 148, false, 1)
	GROUND:CharAnimateTurnTo(t.phileas, Direction.Down, 4)
	GAME:WaitFrames(20)
	GAME:MoveCamera(256, 230, 80, false)
	GAME:WaitFrames(30)

	GAME:FadeOut(false, 60)
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
	GROUND:TeleportTo(t.rin, 232, 252, Direction.Right)
	GROUND:TeleportTo(t.coco, 280, 252, Direction.Left)
	GROUND:TeleportTo(t.penticus, 256, 152, Direction.Down)
	GROUND:TeleportTo(t.phileas, 296, 160, Direction.DownLeft)
	GAME:MoveCamera(256, 228, 1, false)

	UI:SetAutoFinish(true)
	UI:WaitShowVoiceOver(STRINGS:Format(STRINGS.MapStrings['MWE5_052']) .. "\n\n", -1)
	UI:SetAutoFinish(false)
	GAME:WaitFrames(40)

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
	pcall(function() VoiceVisions.Nausea(hero, 2) end)
	pcall(function() VoiceVisions.Recover(hero) end)
	GAME:WaitFrames(10)
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

	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMoveRS(t.rin, seatX(11) - 32, seatY(11), false, 1)
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
	UI:SetSpeaker(t.penticus)
	UI:SetSpeakerEmotion("Normal")
	--R2 : l'appel du maitre de guilde s'ENTEND dans tout le camp
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	GROUND:CharSetEmote(t.penticus, "exclaim", 1)
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

	--R2 : chaque replique du discours a sa reaction, chez celui qui
	--parle ou dans les rangs (une replique = un geste, standard Tunnel).
	UI:SetSpeaker(t.penticus)
	UI:SetSpeakerEmotion("Happy")
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_061'], t.rin:GetDisplayName()))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		--le reveil "energique", c'etait le sien
		GROUND:CharSetEmote(t.rin, "sweatdrop", 1)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		GROUND:CharSetEmote(partner, "happy", 1)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	UI:SetSpeakerEmotion("Normal")
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_062'], mountain:GetColoredName(), ruins:GetColoredName()))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:CharSetEmote(hero, "determined", 1)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GROUND:CharSetEmote(t.almotz, "notice", 1)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(15)
	GROUND:CharTurnToChar(t.penticus, t.kino)
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_063'], t.kino:GetDisplayName()))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		--"enfin REVEILLE" : la pique du matin le poursuit
		GROUND:CharSetEmote(t.kino, "sweatdrop", 1)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(15)

	--Kino, specialiste des donjons, fait son briefing.
	UI:SetSpeaker(t.kino)
	UI:SetSpeakerEmotion("Happy")
	coro1 = TASK:BranchCoroutine(function()
		GROUND:CharSetEmote(t.kino, "happy", 1)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_064']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:CharSetEmote(t.hyko, "notice", 1)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	UI:SetSpeakerEmotion("Normal")
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_065']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:CharSetEmote(partner, "notice", 1)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		GROUND:CharSetEmote(t.coco, "notice", 1)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(12)
	UI:SetSpeaker(t.reinier)
	UI:SetSpeakerEmotion("Normal")
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_066']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		--le maitre de guilde ecoute son second : il approuve
		GROUND:CharSetEmote(t.penticus, "notice", 1)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(12)
	UI:SetSpeaker(t.phileas)
	UI:SetSpeakerEmotion("Normal")
	--Penticus se tourne vers l'eclaireur : chaque prise de parole
	--fait reagir
	GROUND:CharTurnToChar(t.penticus, t.phileas)
	coro1 = TASK:BranchCoroutine(function()
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_067']))
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		GROUND:CharSetEmote(hero, "notice", 1)
	end)
	TASK:JoinCoroutines({coro1, coro2})
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
	--R2 : l'elan final s'allume au-dessus du maitre de guilde avant
	--que les cordées ne repondent (la clameur du groupe suit).
	GROUND:CharSetEmote(t.penticus, "glowing", 1)
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
	--centre du camp, sur l'axe). Il gagne le flanc ouest avec Phileas
	--et se tourne vers le sentier : le maitre de guilde REGARDE ses
	--cordees partir, il ne leur barre pas la route. Cases (216,240)
	--et (216,208) verifiees libres sur la grille d'obstacles.
	coro1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(t.penticus, 216, 240, false, 1)
		GROUND:CharAnimateTurnTo(t.penticus, Direction.UpRight, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		GROUND:MoveToPosition(t.phileas, 216, 208, false, 1)
		GROUND:CharAnimateTurnTo(t.phileas, Direction.Right, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(15)

	UI:SetSpeaker(t.kino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_105']))
	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(t.kino, 284, 200, false, 1)
		GeneralFunctions.EightWayMove(t.kino, 284, 124, false, 1)
		GROUND:Hide(t.kino.EntName)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GeneralFunctions.EightWayMove(t.reinier, 284, 208, false, 1)
		GeneralFunctions.EightWayMove(t.reinier, 284, 132, false, 1)
		GROUND:Hide(t.reinier.EntName)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(32)
		GeneralFunctions.EightWayMove(t.almotz, 284, 216, false, 1)
		GeneralFunctions.EightWayMove(t.almotz, 284, 140, false, 1)
		GROUND:Hide(t.almotz.EntName)
	end)
	coro4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GAME:MoveCamera(272, 240, 80, false)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(20)

	UI:SetSpeaker(t.coco)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_106']))
	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(t.rin, 284, 200, false, 1)
		GeneralFunctions.EightWayMove(t.rin, 284, 124, false, 1)
		GROUND:Hide(t.rin.EntName)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GeneralFunctions.EightWayMove(t.coco, 284, 208, false, 1)
		GeneralFunctions.EightWayMove(t.coco, 284, 132, false, 1)
		GROUND:Hide(t.coco.EntName)
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	--Ganlon et Shuca, la cordee du sommet, partent devant marquer la
	--voie : dans le donjon ils rejoignent l'equipe jouable (SetParty,
	--appele ci-dessous, cree Ganlon et Shuca en Teammate2/3 — la
	--narration et l'equipe de jeu racontent ENFIN la meme chose).
	GROUND:CharTurnToCharAnimated(t.shuca, hero, 4)
	UI:SetSpeaker(t.shuca)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_104']))
	coro1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(t.ganlon, 284, 200, false, 1)
		GeneralFunctions.EightWayMove(t.ganlon, 284, 124, false, 1)
		GROUND:Hide(t.ganlon.EntName)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(18)
		GeneralFunctions.EightWayMove(t.shuca, 284, 208, false, 1)
		GeneralFunctions.EightWayMove(t.shuca, 284, 132, false, 1)
		GROUND:Hide(t.shuca.EntName)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GeneralFunctions.FaceMovingCharacter(hero, t.ganlon, 4, Direction.Up)
	end)
	coro4 = TASK:BranchCoroutine(function()
		GeneralFunctions.FaceMovingCharacter(partner, t.ganlon, 4, Direction.Up)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
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
		GeneralFunctions.EightWayMove(partner, 284, 232, false, 1)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GAME:MoveCamera(280, 208, 70, false)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(15)

	--Le heros fixe le sommet ; le partenaire le rattrape.
	GROUND:EntTurn(hero, Direction.Up)
	GAME:WaitFrames(30)
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
		GeneralFunctions.EightWayMove(t.penticus, 256, 196, false, 1)
	end)
	coro4 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(30)
		GeneralFunctions.EightWayMove(t.phileas, 308, 196, false, 1)
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

	UI:SetSpeaker(t.penticus)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_110']))
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

	GAME:FadeOut(false, 40)
	GAME:WaitFrames(40)
	for _, chara in ipairs({audino, snubbull, girafarig, breloom, growlithe, zigzagoon, tropius, noctowl, mareep, cranidos}) do
		GAME:GetCurrentGround():RemoveTempChar(chara)
	end

	--L'EQUIPE DU DONJON = LA CORDEE DU SOMMET. SetParty retire Hyko et
	--Almotz (restes du Tunnel) et cree Ganlon et Shuca en Teammate2/3 :
	--la narration et l'equipe de jeu racontent la meme chose.
	mount_windswept_entrance_ch_5.SetParty()
	hero = CH('PLAYER')
	partner = CH('Teammate1')

	SV.Chapter5.MountDreamDone = false
	SV.Chapter5.FinishedMountWindsweptIntro = true
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	--LA CAMERA REVIENT AU JOUEUR (forme attestee : searing_tunnel:1480).
	GAME:MoveCamera(0, 0, 1, true)
	SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
	GAME:FadeIn(40)
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
	local rin = CH('Audino')
	local phileas = CH('Noctowl')
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
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_120'], rin ~= nil and rin:GetDisplayName() or penticus:GetDisplayName()))
	end
	GAME:WaitFrames(15)

	--Penticus et Rin accourent depuis le camp. Trajets sur le couloir
	--central (praticable de bout en bout).
	coro1 = TASK:BranchCoroutine(function()
		if penticus ~= nil then
			GeneralFunctions.EightWayMove(penticus, 276, 184, true, 2)
		end
	end)
	coro2 = TASK:BranchCoroutine(function()
		if rin ~= nil then
			GAME:WaitFrames(10)
			GeneralFunctions.EightWayMove(rin, 244, 184, true, 2)
		end
	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(15)

	--Le soin de Rin : cloche et pose, patron du reveil au camp.
	if rin ~= nil then
		SOUND:PlayBattleSE("DUN_Heal_Bell")
		GROUND:CharSetAction(rin, RogueEssence.Ground.PoseGroundAction(rin.Position, rin.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
		GAME:WaitFrames(100)
		GROUND:CharEndAnim(rin)
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

	if rin ~= nil then
		UI:SetSpeaker(rin)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_121']))
		GAME:WaitFrames(15)
	end

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_122']))
	GAME:WaitFrames(20)

	if penticus ~= nil then
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
	coro1 = TASK:BranchCoroutine(function()
		if penticus ~= nil then
			GeneralFunctions.EightWayMove(penticus, 212, 244, false, 1)
			GROUND:CharAnimateTurnTo(penticus, Direction.DownRight, 4)
		end
	end)
	coro2 = TASK:BranchCoroutine(function()
		if rin ~= nil then
			GAME:WaitFrames(12)
			GeneralFunctions.EightWayMove(rin, 244, 252, false, 1)
			GROUND:CharAnimateTurnTo(rin, Direction.Down, 4)
		end
	end)
	TASK:JoinCoroutines({coro1, coro2})

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

	if penticus ~= nil then
		GeneralFunctions.EightWayMove(penticus, 276, 196, false, 1)
		GAME:WaitFrames(10)
		UI:SetSpeaker(penticus)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_126']))
		GAME:WaitFrames(15)
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_127']))
		GAME:WaitFrames(15)
		GeneralFunctions.EightWayMove(penticus, 212, 244, false, 1)
		GROUND:CharAnimateTurnTo(penticus, Direction.DownRight, 4)
	end

	SV.Chapter5.PlayTempMountScene = false

	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GROUND:CharTurnToChar(partner, hero)
	--La camera revient au joueur (forme attestee : searing_tunnel:1480).
	GAME:MoveCamera(0, 0, 1, true)
	GAME:CutsceneMode(false)
end

--Decorations POSEES EN DUR dans le .rsground : 14 anims (8 fleurs, 6
--cailloux), mesurees le 2026-07-29. Le patron event_single.lua:724 montre
--qu'elles occupent les PREMIERS indices du calque ; les ajouts du script
--(feu, sac, paillasses) viennent APRES. La purge ne doit retirer QUE ces
--ajouts : vider le calque entier effacait silencieusement les 14 anims du
--decor naturel a chaque entree sur la carte.
local NB_ANIMS_EN_DUR = 14
function mount_windswept_entrance_ch_5.PurgeDecor()
	--Purge du calque. « Anims:Clear() » n'existe pas : la seule methode
	--de retrait attestee dans le depot est RemoveAt (event_single.lua:724).
	--On retire depuis la fin, index par index, sous pcall, en s'arretant
	--au stock en dur.
	pcall(function()
		local anims = GAME:GetCurrentGround().Decorations[0].Anims
		for i = anims.Count - 1, NB_ANIMS_EN_DUR, -1 do
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

--Position des couchages. Sortie en table pour que la cinematique et le
--decor permanent ne puissent plus diverger.
--Les deux dernieres (11 et 12) sont a l'ecart du cercle ; la 11 a ete
--deplacee de (312,108), qui tombait dans la roche, vers du sol libre.
mount_windswept_entrance_ch_5.BEDS = {
	{256, 164}, {301, 175}, {334, 208}, {334, 248},
	{301, 281}, {256, 292}, {211, 281}, {178, 248},
	{178, 208}, {211, 175},
	{384, 196}, {344, 132},
}

function mount_windswept_entrance_ch_5.SetupGround()	
	--Camp de base du Mont Venteux, APRES l'intro : la cordee du sommet
	--(hero, partenaire, Ganlon, Shuca) est DANS l'equipe du joueur — on
	--ne les spawne donc pas en PNJ. Restent au camp : Penticus, Phileas
	--(camp de base), Hyko (garde par Penticus — arc du Tunnel), Rin et
	--Coco (soutien, redescendues au relais entre deux rotations), Kino,
	--Reinier et Almotz (ouverture, idem). Positions verifiees libres.
	local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, breloom, girafarig =
	CharacterEssentials.MakeCharactersFromList({
		{'Tropius', 212, 244, Direction.DownRight},
		{'Noctowl', 300, 244, Direction.DownLeft},
		{'Audino', 220, 260, Direction.UpRight},
		{'Snubbull', 292, 260, Direction.UpLeft},
		{'Growlithe', 224, 220, Direction.UpRight},
		{'Zigzagoon', 204, 312, Direction.Right},
		{'Breloom', 160, 300, Direction.Right},
		{'Girafarig', 360, 300, Direction.Left}
	})

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

	--Apres une defaite en montagne, Rin se rapproche du feu pour soigner.
	if SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind then
		GROUND:TeleportTo(audino, 244, 252, Direction.Down)
	end
end

--L'EQUIPE DU DONJON = LA CORDEE DU SOMMET. Appele a la fin de la
--cinematique d'arrivee : retire Hyko et Almotz (restes du Tunnel) et cree
--Ganlon et Shuca en Teammate2/3, pour que la narration et l'equipe de jeu
--racontent la meme chose. (Reassigne hero/partner en global : des versions
--"fantomes" d'avant DefaultParty cassaient les teleports ulterieurs.)
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
	--ARRIVEE PAR LE SUD (retour du test en jeu : l'ancienne mise en place
	--teleportait l'equipe au milieu de la carte puis la faisait marcher
	--vers (92,176)/(60,136) — coordonnees HERITEES de la scene du Tunnel,
	--dans l'angle ouest. Desormais : l'expedition debouche du sentier sud,
	--le long de L'OCEAN qui borde la carte (rows 78-80, eau DuskBeach
	--animee, infranchissable), et remonte en LIGNE DROITE la colonne
	--x=256 (verifiee rectiligne et praticable rows 50-77).
	GAME:MoveCamera(256, 524, 1, false)
	--TRANSITION JOUR -> SOIR (Prompt Maitre 6.2). L'expedition arrive au
	--couchant : "dusk" d'abord (patron exact de l'arrivee au Tunnel), la
	--nuit noire ("darkness") ne tombe qu'au deploiement des couchages.
	GROUND:AddMapStatus("dusk")
	
	--for debug purposes
	GAME:FadeOut(false, 1)
	
	GROUND:TeleportTo(hero, 256, 540, Direction.Up)
	GROUND:TeleportTo(partner, 256, 556, Direction.Up)
	
	local audino, snubbull, girafarig, breloom, growlithe, zigzagoon, tropius, noctowl, mareep, cranidos = 
	CharacterEssentials.MakeCharactersFromList({
		{'Audino'},
		{'Snubbull'},
		{'Girafarig'},
		{'Breloom'},
		{'Growlithe', 256, 572, Direction.Up},
		{'Zigzagoon', 256, 588, Direction.Up},
		{'Tropius'},
		{'Noctowl'},
		{'Mareep'},
		{'Cranidos'}
	})
	
	
	--LE CAMP DE JOUR. Aucune paillasse a l'arrivee (Prompt Maitre 6.3) :
	--les couchages ne sont deployes qu'a la fin de la veillee, sous le
	--fondu de la tombee de la nuit (CampNightfall, section 7). Ici :
	--feu + materiel range, via le constructeur partage qui purge le
	--calque (le doublement de decor d'avant ne peut plus se produire).
	mount_windswept_entrance_ch_5.BuildCampDay()

	GAME:WaitFrames(40)
	--GRAMMAIRE DE TRANSITION (audit I5, 2026-07-29) : le son monte,
	--puis l'image, puis le mot. Avant, MWE5_001/002 se jouaient sur
	--ecran noir et l'image se levait ensuite sur des personnages deja
	--installes. La musique du camp (theme de la carte, attestee plus
	--bas dans LegendOfTheSkyArbiter) accompagne toute la veillee.
	SOUND:PlayBGM('Canyon Camp.ogg', true)
	GAME:FadeIn(40)
	GAME:WaitFrames(30)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_001'], tunnel:GetColoredName()))
	GAME:WaitFrames(20)
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_002']))
	GAME:WaitFrames(20)
	
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
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_003']))
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_004']))
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_005']))

	-- Le camp s'anime autour du feu. L'expedition n'est plus representee
	-- par deux sprites plantes a l'entree.
	--
	-- BUG CORRIGE : un second feu etait pose ici, aux MEMES coordonnees
	-- (256,220) que celui de BuildCamp. Deux animations superposees au
	-- pixel pres, ce qui doublait la luminosite des flammes. Le feu est
	-- desormais pose une seule fois, par le constructeur de camp.
	for _, chara in ipairs({tropius, noctowl, audino, snubbull, mareep, cranidos}) do
		GROUND:Unhide(chara.EntName)
	end
	GROUND:TeleportTo(tropius, 212, 244, Direction.Right)
	GROUND:TeleportTo(noctowl, 300, 244, Direction.Left)
	GROUND:TeleportTo(audino, 220, 260, Direction.UpRight)
	GROUND:TeleportTo(snubbull, 292, 260, Direction.UpLeft)
	GROUND:TeleportTo(mareep, 204, 312, Direction.Right)
	GROUND:TeleportTo(cranidos, 308, 312, Direction.Left)

	local camp1 = TASK:BranchCoroutine(function()
		GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
		GROUND:CharSetEmote(tropius, "notice", 1)
	end)
	local camp2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4)
	end)
	local camp3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GROUND:CharAnimateTurnTo(mareep, Direction.UpRight, 4)
		GROUND:CharSetEmote(mareep, "happy", 1)
	end)
	TASK:JoinCoroutines({camp1, camp2, camp3})

	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_006']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_007']))
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_008']))
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_009']))
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_010']))
	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_011']))
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_012']))
	UI:SetSpeaker(cranidos)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_013']))
	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_014']))
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_015']))
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_016']))
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_017']))
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_018']))
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_019']))
	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_020']))

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


	--------------------------------------------------------------------
	-- LA NUIT CONTINUE DANS LE SONGE
	--------------------------------------------------------------------
	--Le camp dort. Le heros est emporte sur la carte dediee au reve
	--(regle 6 du mode operatoire : physiquement present, jamais un
	--ecran noir ; docs/CONCEPTION_songe_source.md). Le drapeau est pose
	--AVANT le changement de carte : un rechargement en plein songe le
	--relance proprement (filet de songe_source.init). Au retour,
	--PlotScripting enchaine sur DreamWakeAndMorning (reveil, veille,
	--matin) : c'est elle qui termine l'ancienne queue de cette fonction
	--(nettoyage, SetParty, passage de relais au joueur).
	SV.Chapter5.MountDreamPending = true
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap('songe_source', 'Main_Entrance_Marker')
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

	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("...Maître,[pause=10] avec tout mon respect,[pause=10] je dois vous le demander.[pause=0] Pourquoi moi ?")
	UI:WaitShowDialogue("Vous m'avez gardé près de vous tout le voyage.[pause=0] Vous avez paniqué quand on a eu du retard au Tunnel.[pause=0] Les autres recrues n'ont pas ce traitement,[pause=10] wouf.")
	UI:WaitShowDialogue("Je ne suis pas en sucre.[pause=0] Je suis un garde de la guilde.[pause=0] Alors...[pause=10] pourquoi ?")

	GAME:WaitFrames(40)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(".........")
	GAME:WaitFrames(30)
	UI:WaitShowDialogue("...Tu as ses yeux,[pause=10] tu sais.")

	GROUND:CharSetEmote(growlithe, "question", 1)
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("...Les yeux de qui,[pause=10] Maître ?")

	GAME:WaitFrames(30)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Il y a vingt-cinq ans,[pause=10] j'avais un coéquipier.[pause=0] Un Arcanin.[pause=0] La tête brûlée la plus loyale que cette guilde ait jamais comptée.")
	UI:WaitShowDialogue("Cette nuit-là...[pause=10] le monde entier tremblait.[pause=0] La dernière des grandes catastrophes.[pause=0] Et cette montagne...[pause=20] cette montagne s'était ALLUMÉE,[pause=10] exactement comme aujourd'hui.")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Nous sommes montés tous les deux.[pause=0] Jeunes.[pause=0] Invincibles.[pause=0] Persuadés que le monde avait besoin de nous...[pause=10] et il avait besoin de nous.")
	GAME:WaitFrames(30)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("Une corniche a cédé sous moi,[pause=10] près du sommet.[pause=0] Il m'a rattrapé.[pause=0] Il m'a HISSÉ.[pause=0] Et le temps que je me retourne...")
	GAME:WaitFrames(40)
	UI:WaitShowDialogue("...le vent l'avait emporté.[pause=0] Voilà ce que le vent a pris,[pause=10] cette nuit-là.[pause=0] Le meilleur d'entre nous.[pause=0] Ton père,[pause=10] Hyko.")

	GAME:WaitFrames(50)
	GROUND:CharSetEmote(growlithe, "shock", 1)
	SOUND:PlayBattleSE("EVT_Emote_Shock_2")
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("Mon...[pause=20] mon père ?[pause=0] Mais...[pause=10] on m'a toujours dit qu'il était mort en mission de routine...")

	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("C'est moi qui ai demandé qu'on te dise ça.[pause=0] Un petit ne devrait pas grandir en sachant que son père est mort pour une corniche...[pause=10] et pour un imbécile qui marchait dessus.")
	GAME:WaitFrames(30)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Alors oui.[pause=0] Je te garde près de moi.[pause=0] Pas parce que tu es fragile,[pause=10] Hyko.[pause=0] Parce que je lui dois de te ramener.[pause=0] De CHAQUE expédition.[pause=0] Jusqu'à ma dernière.")

	-- Sympathy : la reponse de Hyko. Courage, pas larmes.
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(40)
	SOUND:PlayBGM('Sympathy.ogg', true)
	GAME:WaitFrames(30)

	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue(".........")
	GAME:WaitFrames(40)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("...Merci de me l'avoir dit,[pause=10] Maître.[pause=0] Mais je vais vous demander une chose,[pause=10] et c'est la dernière fois que je la demanderai.")
	UI:WaitShowDialogue("Ne me protégez plus DE la montagne.[pause=0] Apprenez-moi à la gravir.[pause=0] C'est comme ça qu'on honore ceux que le vent a pris,[pause=10] wouf.")
	UI:WaitShowDialogue("Pas en gardant leurs enfants au camp.[pause=0] En en faisant des Pokémon...[pause=10] que le vent n'emporte pas.")

	GAME:WaitFrames(50)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("...Tu as sa voix aussi,[pause=10] finalement.[pause=0] D'accord,[pause=10] Hyko.[pause=0] D'accord.")

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
