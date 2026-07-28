--[[
    mount_windswept_entrance_ch_5.lua
    Refonte cinématique officielle complète pour Mount Windswept Entrance (Camp du Mont Venteux - Ch.5).
    Réalise les 7 scènes majeures :
      1) Arrivée progressive au soir avec intentions et dîner au feu (CampNightfall)
      2) Scène intime du héros et du partenaire avant de dormir (CampNightfall_HeroMoment)
      3) Installation de nuit avec sacs, tentes et lits temporaires de paille (BuildCamp(true))
      4) Transition lendemain matin : carton « Le lendemain matin... », réveil échelonné, lits supprimés (BuildCamp(false))
      5) Rassemblement guilde et briefing d'expédition par Penticus, caméra dynamique
      6) Départ progressif et réaliste des équipes Cinabre puis Saphir vers le pic
      7) Scène mature et profonde entre Penticus et Phileas près des sacs d'expédition, avec don d'objet d'expédition
      + Protection et polissage complet de WindSecretScene() (le secret Hyko x Penticus) et LegendOfTheSkyArbiter()
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

mount_windswept_entrance_ch_5 = {}

-- Lits temporaires de paille (soirée uniquement) autour du feu (290, 240)
mount_windswept_entrance_ch_5.BED_POS = {
	{290, 170}, {335, 185}, {365, 225}, {365, 265},
	{335, 305}, {290, 320}, {245, 305}, {215, 265},
	{215, 225}, {245, 185},
	{160, 220}, {160, 250} -- Lits isolés pour Hero (11) et Partner (12)
}

-- Sacs et matériel d'expédition (présents soir et matin)
mount_windswept_entrance_ch_5.BAG_POS = {
	{250, 180}, {330, 180}, {220, 230}, {360, 230},
	{240, 280}, {340, 280}, {275, 310}, {315, 310}
}

mount_windswept_entrance_ch_5.MEMBER_LIST = {
	'Tropius', 'Noctowl', 'Audino', 'Snubbull', 'Mareep', 
	'Cranidos', 'Breloom', 'Girafarig', 'Growlithe', 'Zigzagoon'
}

mount_windswept_entrance_ch_5.BED_MAP = {
	['Tropius'] = 1, ['Noctowl'] = 2, ['Audino'] = 3, ['Snubbull'] = 4,
	['Mareep'] = 5, ['Cranidos'] = 6, ['Breloom'] = 7, ['Girafarig'] = 8,
	['Growlithe'] = 9, ['Zigzagoon'] = 10, ['PLAYER'] = 11, ['Teammate1'] = 12
}

--------------------------------------------------------------------
-- CAMP BUILDER (Décorations dynamiques : sacs permanents, lits au soir uniquement)
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.BuildCamp(isEvening)
	local ground = GAME:GetCurrentGround()
	local hay_bed = RogueEssence.Content.ObjAnimData('Hay_Bed', 1)
	local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)
	local grassy_bag = RogueEssence.Content.ObjAnimData('Grassy_Bag', 1)

	pcall(function()
		local anims = ground.Decorations[0].Anims
		for i = anims.Count - 1, 0, -1 do anims:RemoveAt(i) end
	end)

	pcall(function()
		-- Sacs et matériel d'expédition (présents soir et matin)
		for _, pos in ipairs(mount_windswept_entrance_ch_5.BAG_POS) do
			ground.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(grassy_bag, RogueElements.Loc(pos[1]-8, pos[2]-8)))
		end

		-- Au soir : pose du feu et des couchages temporaires. Au matin : lits et feu retirés.
		if isEvening then
			for _, pos in ipairs(mount_windswept_entrance_ch_5.BED_POS) do
				ground.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(pos[1]-12, pos[2]-12)))
			end
			ground.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(290-16, 240-16)))
		end
	end)
end

--------------------------------------------------------------------
-- SETUP GROUND (Après la cinématique d'introduction ou en revisite)
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.SetupGround()
	local ground = GAME:GetCurrentGround()
	GROUND:AddMapStatus("blowing_wind")
	mount_windswept_entrance_ch_5.BuildCamp(false)

	local m = CharacterEssentials.MakeCharactersFromList({
		{'Tropius', 256, 196, Direction.Down},
		{'Noctowl', 320, 196, Direction.DownLeft},
		{'Growlithe', 232, 276, Direction.UpRight},
		{'Zigzagoon', 344, 276, Direction.UpLeft}
	})
	for _, ch in ipairs(m) do
		if ch ~= nil then GROUND:Unhide(ch.EntName) end
	end
end

--------------------------------------------------------------------
-- SCÈNE 1 à 3 : ARRIVAL CUTSCENE & CAMP NIGHTFALL
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.ArrivalCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	GAME:CutsceneMode(true)
	if partner ~= nil then AI:DisableCharacterAI(partner) end
	SOUND:StopBGM()
	
	GAME:MoveCamera(290, 240, 1, false)
	GROUND:AddMapStatus("darkness")
	mount_windswept_entrance_ch_5.BuildCamp(true)

	local m = CharacterEssentials.MakeCharactersFromList({
		{'Tropius'}, {'Noctowl'}, {'Audino'}, {'Snubbull'}, {'Mareep'}, 
		{'Cranidos'}, {'Breloom'}, {'Girafarig'}, {'Growlithe'}, {'Zigzagoon'}
	}, true)

	-- Penticus (m[1]) et Phileas (m[2]) étudient la carte au centre du camp
	GROUND:TeleportTo(m[1], 270, 190, Direction.Down)
	GROUND:TeleportTo(m[2], 310, 190, Direction.Down)
	GROUND:Unhide(m[1].EntName)
	GROUND:Unhide(m[2].EntName)

	-- Équipes arrivant du sentier Sud
	for i = 3, 10 do
		GROUND:TeleportTo(m[i], 256 + ((i-3)%4)*24, 472 + ((i-3)//4)*12, Direction.Up)
		GROUND:Unhide(m[i].EntName)
	end
	GROUND:TeleportTo(hero, 280, 488, Direction.Up)
	if partner ~= nil then GROUND:TeleportTo(partner, 312, 488, Direction.Up) end

	GAME:FadeIn(40)
	SOUND:PlayBGM('At the End of the Day.ogg', true)

	-- Arrivée progressive de l'Équipe Cinabre (Mareep, Cranidos)
	local cinabre_tasks = {}
	cinabre_tasks[1] = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(m[5], 250, 240, false, 0.8)
		GROUND:CharAnimateTurnTo(m[5], Direction.Right, 4)
	end)
	cinabre_tasks[2] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:MoveToPosition(m[6], 250, 270, false, 0.8)
		GROUND:CharAnimateTurnTo(m[6], Direction.UpRight, 4)
	end)
	TASK:JoinCoroutines(cinabre_tasks)
	GAME:WaitFrames(20)

	UI:SetSpeaker(m[5])
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("Bêêê... Ce vent du nord me traverse la laine jusqu'aux os !")
	
	UI:SetSpeaker(m[6])
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Approche-toi du brasier, Kino. La roche d'ici abrite au moins des rafales.")

	-- Arrivée de l'Équipe Saphir (Audino, Snubbull, Breloom, Girafarig)
	local saphir_tasks = {}
	saphir_tasks[1] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[3], 330, 240, false, 0.8) end)
	saphir_tasks[2] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[4], 330, 270, false, 0.8) end)
	saphir_tasks[3] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[7], 350, 255, false, 0.8) end)
	saphir_tasks[4] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[8], 350, 225, false, 0.8) end)
	TASK:JoinCoroutines(saphir_tasks)
	GAME:WaitFrames(20)

	UI:SetSpeaker(m[3])
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Tout le monde va bien ? Pas d'engelure après la montée du Tunnel ?")

	UI:SetSpeaker(m[4])
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Regardez ce sommet au-dessus de nous... Nous touchons au but !")

	-- Arrivée de l'Équipe de pointe (Growlithe, Zigzagoon, Hero, Partner)
	local pointe_tasks = {}
	pointe_tasks[1] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[9], 270, 295, false, 0.8) end)
	pointe_tasks[2] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[10], 310, 295, false, 0.8) end)
	pointe_tasks[3] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 270, 330, false, 0.8) end)
	if partner ~= nil then
		pointe_tasks[4] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 310, 330, false, 0.8) end)
	end
	TASK:JoinCoroutines(pointe_tasks)
	GAME:WaitFrames(25)

	if partner ~= nil then
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Pain")
		UI:WaitShowDialogue("...Enfin le camp de base. Le vent souffle moins fort ici, mais le froid reste mordant.")
	end

	-- Accueil de Penticus
	GROUND:CharAnimateTurnTo(m[1], Direction.Down, 4)
	UI:SetSpeaker(m[1])
	UI:WaitShowDialogue("Équipe " .. GAME:GetTeamName() .. ". Vous voilà tous arrivés.")
	UI:WaitShowDialogue("Le Tunnel Ardent a mis nos forces à l'épreuve, et le vent d'ici teste notre patience.")
	UI:WaitShowDialogue("Mais regardez : l'expédition entière est intacte. Installez-vous autour de l'âtre.")

	mount_windswept_entrance_ch_5.CampNightfall(hero, partner, m)
end

--------------------------------------------------------------------
-- CAMP NIGHTFALL (Dîner, moment intime du héros & coucher échelonné)
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.CampNightfall(hero, partner, membres)
	local B = mount_windswept_entrance_ch_5.BED_POS

	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("Le feu prend.[pause=30] Les provisions sont partagées autour des flammes.")
	UI:SetCenter(false)
	GAME:WaitFrames(25)

	local tours = {}
	for i, c in ipairs(membres) do
		tours[#tours+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(i * 3)
			GROUND:CharTurnToCharAnimated(c, hero, 4)
		end)
	end
	TASK:JoinCoroutines(tours)
	GAME:WaitFrames(20)

	UI:SetSpeaker(membres[7])
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Servez-vous tant que c'est chaud ! En altitude, ça refroidit en deux minutes !")

	UI:SetSpeaker(membres[8])
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Ce bouillon nous redonne des forces. Demain, l'ascension sera rude.")

	if partner ~= nil then
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("C'est le vent... Il met du froid dans tout, même dans la soupe !")
	end

	GAME:WaitFrames(25)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("Peu à peu, les voix s'apaisent.[pause=30] Il ne reste que le crépitement du feu.")
	UI:SetCenter(false)
	GAME:WaitFrames(30)

	UI:SetSpeaker(membres[1])
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Demain, le sommet du Mont Venteux. Dormez pendant que la montagne vous laisse dormir.")

	-- SCÈNE 2 : LE MOMENT INTIME DU HÉROS AVANT DE DORMIR
	GAME:MoveCamera(240, 240, 1, false)
	GAME:WaitFrames(30)

	if partner ~= nil then
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		GAME:WaitFrames(20)

		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("...Tu ne dors pas non plus, " .. hero:GetDisplayName() .. " ?")
		UI:WaitShowDialogue("Quand nous avons quitté Metano, je ne savais pas si nous arriverions jusqu'ici. Le vent, les crêtes, le froid...")
		UI:SetSpeakerEmotion("Determined")
		UI:WaitShowDialogue("Mais chaque fois, tu as su garder le cap. Demain, le pic nous révélera son secret. Quoi qu'il y ait là-haut... nous ferons face ensemble.")
	end

	GeneralFunctions.HeroDialogue(hero, "(...Onze respirations autour d'un feu.[pause=25] Je n'avais jamais rien entendu d'aussi calme.)", "Determined")
	GAME:WaitFrames(30)

	-- SCÈNE 3 : COUCHER NATUREL ÉCHELONNÉ
	GAME:MoveCamera(290, 240, 1, false)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("L'expédition rejoint ses couchages temporaires à l'abri des rafales...")
	UI:SetCenter(false)

	local bedtime_tasks = {}
	for i, c in ipairs(membres) do
		local b = B[mount_windswept_entrance_ch_5.BED_MAP[c.EntName] or i]
		if b ~= nil then
			bedtime_tasks[#bedtime_tasks+1] = TASK:BranchCoroutine(function()
				GAME:WaitFrames(i * 12)
				GROUND:MoveToPosition(c, b[1], b[2], false, 1)
				GROUND:CharAnimateTurnTo(c, Direction.Down, 4)
				GROUND:CharSetAnim(c, "Sleep", true)
			end)
		end
	end

	local h_bed = B[11]
	local p_bed = B[12]
	if partner ~= nil then
		bedtime_tasks[#bedtime_tasks+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(140)
			GROUND:MoveToPosition(partner, p_bed[1], p_bed[2], false, 1)
			GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
			GROUND:CharSetAnim(partner, "EventSleep", true)
		end)
	end
	bedtime_tasks[#bedtime_tasks+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(155)
		GROUND:MoveToPosition(hero, h_bed[1], h_bed[2], false, 1)
		GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
		GROUND:CharSetAnim(hero, "EventSleep", true)
	end)

	TASK:JoinCoroutines(bedtime_tasks)
	GAME:WaitFrames(40)

	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("Le feu baisse.[pause=30] La montagne attend au-dessus, patiente.")
	UI:SetCenter(false)
	GAME:WaitFrames(30)

	GAME:FadeOut(false, 90)
	GAME:WaitFrames(60)

	mount_windswept_entrance_ch_5.MorningSequence()
end

--------------------------------------------------------------------
-- SCÈNES 4 à 7 : MORNING SEQUENCE (Aube, assemblée, course, Penticus/Phileas)
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.MorningSequence()
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("Le lendemain matin...")
	UI:SetCenter(false)
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	GAME:MoveCamera(290, 240, 1, false)
	GROUND:RemoveMapStatus("darkness")
	GROUND:AddMapStatus("dusk")
	mount_windswept_entrance_ch_5.BuildCamp(false) -- Lits retirés, ne restent que sacs et équipement !

	local m = CharacterEssentials.MakeCharactersFromList({
		{'Tropius'}, {'Noctowl'}, {'Audino'}, {'Snubbull'}, {'Mareep'}, 
		{'Cranidos'}, {'Breloom'}, {'Girafarig'}, {'Growlithe'}, {'Zigzagoon'}
	}, true)

	for i, name in ipairs(mount_windswept_entrance_ch_5.MEMBER_LIST) do
		local pos = mount_windswept_entrance_ch_5.BED_POS[mount_windswept_entrance_ch_5.BED_MAP[name]]
		GROUND:TeleportTo(m[i], pos[1], pos[2], Direction.Down)
		GROUND:Unhide(m[i].EntName)
		GROUND:CharSetAnim(m[i], "Sleep", true)
	end
	
	local h_bed = mount_windswept_entrance_ch_5.BED_POS[11]
	local p_bed = mount_windswept_entrance_ch_5.BED_POS[12]
	GROUND:TeleportTo(hero, h_bed[1], h_bed[2], Direction.Down)
	if partner ~= nil then
		GROUND:TeleportTo(partner, p_bed[1], p_bed[2], Direction.Down)
		GROUND:CharSetAnim(partner, "EventSleep", true)
	end
	GROUND:CharSetAnim(hero, "EventSleep", true)

	GAME:FadeIn(60)
	SOUND:PlayBGM('Heartwarming.ogg', true)
	GAME:WaitFrames(60)

	-- Réveil progressif (Partenaire en premier)
	if partner ~= nil then
		GAME:WaitFrames(30)
		GROUND:CharEndAnim(partner)
		GeneralFunctions.DoAnimation(partner, 'Wake')
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("...Mmm. " .. hero:GetDisplayName() .. ". Allez, réveille-toi. Le jour se lève.")
	end
	
	GAME:WaitFrames(20)
	GROUND:CharEndAnim(hero)
	GeneralFunctions.DoAnimation(hero, 'Wake')
	GAME:WaitFrames(40)
	
	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("...Mmm. J'ai l'impression d'avoir dormi dans un bloc de glace.")

	if partner ~= nil then
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Haha ! Le froid réveille mieux qu'une Baie Maron ! Regarde... Le ciel est dégagé au-dessus du pic.")
	end

	-- SCÈNE 5 : APPEL À L'ASSEMBLÉE PAR PENTICUS
	GAME:WaitFrames(30)
	GROUND:CharEndAnim(m[1])
	GeneralFunctions.DoAnimation(m[1], 'Wake')
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(m[1])
	UI:WaitShowDialogue("Le soleil se lève ! Tout le monde debout ! On se rassemble !")

	local wake_tasks = {}
	for i = 2, 10 do
		wake_tasks[#wake_tasks+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(i * 10)
			GROUND:CharEndAnim(m[i])
			GeneralFunctions.DoAnimation(m[i], 'Wake')
		end)
	end
	TASK:JoinCoroutines(wake_tasks)

	GAME:WaitFrames(30)
	local assemble_tasks = {}
	assemble_tasks[1] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[1], 256, 200, false, 1) end)
	assemble_tasks[2] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[2], 324, 200, false, 1) end)
	
	local circ_pts = {{210, 180}, {372, 180}, {190, 220}, {392, 220}, {210, 260}, {372, 260}, {240, 290}, {342, 290}}
	for i = 3, 10 do
		local p = circ_pts[i-2]
		assemble_tasks[#assemble_tasks+1] = TASK:BranchCoroutine(function() 
			GAME:WaitFrames(i*3)
			GROUND:MoveToPosition(m[i], p[1], p[2], false, 1) 
			GROUND:CharTurnToCharAnimated(m[i], m[1], 4)
		end)
	end
	assemble_tasks[#assemble_tasks+1] = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(hero, 270, 240, false, 1)
		GROUND:CharTurnToCharAnimated(hero, m[1], 4)
	end)
	if partner ~= nil then
		assemble_tasks[#assemble_tasks+1] = TASK:BranchCoroutine(function()
			GROUND:MoveToPosition(partner, 310, 240, false, 1)
			GROUND:CharTurnToCharAnimated(partner, m[1], 4)
		end)
	end
	TASK:JoinCoroutines(assemble_tasks)

	UI:SetSpeaker(m[1])
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Équipe " .. GAME:GetTeamName() .. ". Équipe Cinabre. Équipe Saphir. L'ascension finale commence.")
	UI:WaitShowDialogue("Le sommet du Mont Venteux ne pardonne aucune erreur. Nous allons nous diviser en trois voies.")
	UI:WaitShowDialogue("Équipe Cinabre : Kino, Reinier. Vous ouvrez le sentier Est pour sécuriser les corniches.")
	UI:WaitShowDialogue("Équipe Saphir : Shuca, Ganlon, Rin, Coco. Surveillance des falaises inférieures.")
	UI:WaitShowDialogue("Et l'équipe de pointe : Hyko, Almotz, " .. hero:GetDisplayName() .. " et " .. partner:GetDisplayName() .. ". Droit vers le pic !")

	GAME:WaitFrames(20)
	UI:SetSpeaker(m[7])
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Hé hé ! Le premier arrivé là-haut gagne une Baie Grena ! La course est lancée !")

	-- SCÈNE 6 : DÉPART PROGRESSIF DES ÉQUIPES (Pas de disparition instantanée !)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	
	-- 1er départ : Équipe Cinabre (Mareep, Cranidos)
	UI:SetSpeaker(m[5])
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Bêêê ! On ouvre la marche ! En route, Reinier !")
	
	local dept1 = {}
	dept1[1] = TASK:BranchCoroutine(function() GROUND:MoveInDirection(m[5], Direction.Up, 320, false, 1.5); GAME:GetCurrentGround():RemoveTempChar(m[5]) end)
	dept1[2] = TASK:BranchCoroutine(function() GROUND:MoveInDirection(m[6], Direction.Up, 320, false, 1.5); GAME:GetCurrentGround():RemoveTempChar(m[6]) end)
	TASK:JoinCoroutines(dept1)
	GAME:WaitFrames(20)

	-- 2e départ : Équipe Saphir (Audino, Snubbull, Breloom, Girafarig)
	UI:SetSpeaker(m[4])
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Le sommet est à nous ! Bonne ascension à tous !")
	
	local dept2 = {}
	for i = 3, 4 do
		dept2[#dept2+1] = TASK:BranchCoroutine(function()
			GROUND:MoveInDirection(m[i], Direction.Up, 320, false, 1.5)
			GAME:GetCurrentGround():RemoveTempChar(m[i])
		end)
	end
	for i = 7, 8 do
		dept2[#dept2+1] = TASK:BranchCoroutine(function()
			GROUND:MoveInDirection(m[i], Direction.Up, 320, false, 1.5)
			GAME:GetCurrentGround():RemoveTempChar(m[i])
		end)
	end
	TASK:JoinCoroutines(dept2)
	GAME:WaitFrames(30)

	if partner ~= nil then
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("Ils ne perdent pas de temps ! Allez, " .. hero:GetDisplayName() .. ", on ne va pas se laisser distancer !")
	end

	-- SCÈNE 7 : SCÈNE MATURE ENTRE PENTICUS ET PHILEAS (Près du sac d'expédition)
	GAME:MoveCamera(290, 190, 1, false)
	GAME:WaitFrames(30)

	GROUND:CharTurnToCharAnimated(m[1], m[2], 4)
	GROUND:CharTurnToCharAnimated(m[2], m[1], 4)
	GAME:WaitFrames(20)

	UI:SetSpeaker(m[1])
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue(".........")
	UI:WaitShowDialogue("Le vent de ce sommet... Il porte exactement la même complainte qu'à l'époque, Phileas.")

	UI:SetSpeaker(m[2])
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Hoo... Je l'entends aussi. L'Ancrage ne s'est pas réveillé seul. Quelqu'un ou quelque chose force le passage au pic.")
	UI:WaitShowDialogue("Nos recrues sont pleines de courage... mais elles ignorent ce que retient un sceau des anciens bâtisseurs.")

	UI:SetSpeaker(m[1])
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("C'est notre rôle d'être leur bouclier. Nous ne laisserons pas la montagne répéter ses drames passés.")

	-- Phileas s'adresse au joueur et remet l'aide d'expédition
	GROUND:CharAnimateTurnTo(m[2], Direction.Down, 4)
	UI:SetSpeaker(m[2])
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Hoo... Vous deux. Approchez un instant avant de rejoindre Hyko et Almotz.")

	if not SV.Chapter5.PhileasGiftGiven then
		local item = "berry_oran"
		if math.random(1,2) == 1 then item = "seed_reviver" end
		SOUND:PlayFanfare("Item")
		UI:WaitShowDialogue("Vous recevez une " .. _DATA:GetItem(item):GetColoredName() .. " !")
		GAME:GivePlayerStorageItem(item)
		SV.Chapter5.PhileasGiftGiven = true
	end

	UI:SetSpeaker(m[2])
	UI:WaitShowDialogue("Le vent là-haut coupe comme une lame. Ne gaspillez pas vos forces dans les premiers paliers.")

	if partner ~= nil then
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Determined")
		UI:WaitShowDialogue("Merci, Maître Phileas ! On ne vous décevra pas !")
	end

	UI:SetSpeaker(m[1])
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("La voie est libre. Équipe de pointe... en avant !")

	GAME:FadeOut(false, 60)
	GAME:WaitFrames(60)

	SV.Chapter5.FinishedMountWindsweptIntro = true
	GAME:CutsceneMode(false)
end

--------------------------------------------------------------------
-- ACTIONS PNJ (Camp jouable vivant avec soutien Phileas)
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.Tropius_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Le sommet vous attend, " .. GAME:GetTeamName() .. ". Faites honneur à la guilde.", "Inspired")
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Noctowl_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Hoo...", "Normal")
	if not SV.Chapter5.PhileasGiftGiven then
		UI:WaitShowDialogue("Hou... Approchez. Avant cette ultime montée, une aide ne sera pas de trop.")
		local item = "berry_oran"
		if math.random(1,2) == 1 then item = "seed_reviver" end
		SOUND:PlayFanfare("Item")
		UI:WaitShowDialogue("Vous recevez une " .. _DATA:GetItem(item):GetColoredName() .. " !")
		GAME:GivePlayerStorageItem(item)
		SV.Chapter5.PhileasGiftGiven = true
		UI:WaitShowDialogue("Le vent là-haut est tranchant. Soyez prudents.")
	else
		UI:WaitShowDialogue("Le Cœur du Mont Venteux pulse différemment ce matin. Ne tardez pas.")
	end
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Growlithe_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Wouf ! Je suis prêt ! Le sommet n'a qu'à bien se tenir !", "Determined")
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Zigzagoon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "J'ai bien serré mon sac. Rien ne tombera !", "Happy")
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Audino_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Mes bandages sont prêts !", "Worried")
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Snubbull_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Regardez-moi ce pic... Il a l'air si fier !", "Inspired")
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Mareep_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Bêêê... L'électricité statique ici est incroyable !", "Happy")
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Cranidos_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Plus c'est haut, plus la chute est dure. Alors on ne tombera pas !", "Normal")
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Breloom_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "En route pour le sommet !", "Happy")
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Girafarig_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Mes sens sont en alerte.", "Normal")
	GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- LEGEND OF THE SKY ARBITER
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.LegendOfTheSkyArbiter(chara)
	UI:SetSpeaker(chara)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Tu regardes ce rocher taillé ? Il porte la marque des bâtisseurs du Réseau.")
	UI:WaitShowDialogue("On raconte que l'arbitre des nuages veillait ici avant que le ciel ne se déchire.")
end

--------------------------------------------------------------------
-- WIND SECRET SCENE (Scène secrète de nuit - Hyko x Penticus)
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.WindSecretScene()
	local hero = CH('PLAYER')
	local tropius = CH('Tropius')
	local growlithe = CH('Teammate2')
	if tropius == nil or growlithe == nil then GAME:FadeIn(20) return end

	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	GROUND:AddMapStatus("darkness")

	GROUND:TeleportTo(hero, 256, 340, Direction.Up)
	GROUND:TeleportTo(tropius, 352, 200, Direction.Down)
	GROUND:TeleportTo(growlithe, 352, 240, Direction.Up)
	GAME:MoveCamera(256, 320, 1, false)

	GAME:FadeIn(60)
	GAME:WaitFrames(40)

	GeneralFunctions.HeroDialogue(hero, "(Impossible de dormir... Ce vent n'arrête jamais. ...Tiens ? Des voix ?)", "Normal")
	GAME:WaitFrames(20)

	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 300, 290, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, 90, 340, 230) end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(30)

	SOUND:PlayBGM('On the Beach at Dusk.ogg', true)
	GAME:WaitFrames(30)

	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("...Maître, avec tout mon respect, je dois vous le demander. Pourquoi moi ?")
	UI:WaitShowDialogue("Vous m'avez gardé près de vous tout le voyage. Vous avez paniqué quand on a eu du retard au Tunnel. Les autres recrues n'ont pas ce traitement, wouf.")
	UI:WaitShowDialogue("Je ne suis pas en sucre. Je suis un garde de la guilde. Alors... pourquoi ?")

	GAME:WaitFrames(40)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(".........")
	GAME:WaitFrames(30)
	UI:WaitShowDialogue("...Tu as ses yeux, tu sais.")

	GROUND:CharSetEmote(growlithe, "question", 1)
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("...Les yeux de qui, Maître ?")

	GAME:WaitFrames(30)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("D'un garde qui m'a accompagné ici, il y a de nombreuses années.")
	UI:WaitShowDialogue("Il était courageux. Trop courageux. Quand la brume a englouti le sentier supérieur, il s'est placé entre la faille et la guilde.")
	UI:WaitShowDialogue("Nous avons survécu. Lui n'est jamais redescendu.")
	GAME:WaitFrames(30)
	UI:WaitShowDialogue("Je sais que tu es un garde, Hyko. Je sais que tu connais ton devoir.")
	UI:WaitShowDialogue("Mais je ne perdrai pas une seconde fois un cœur comme le tien sur cette montagne.")

	GAME:WaitFrames(40)
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("...Maître...")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("Je redescendrai, Maître. Avec vous, et avec toute l'équipe. C'est une promesse, wouf !")

	GAME:WaitFrames(40)
	GAME:FadeOut(false, 90)
	GAME:WaitFrames(60)

	SV.Chapter5.WindSecretSceneSeen = true
	GAME:CutsceneMode(false)
	mount_windswept_entrance_ch_5.SetupGround()
	GAME:FadeIn(30)
end

return mount_windswept_entrance_ch_5
