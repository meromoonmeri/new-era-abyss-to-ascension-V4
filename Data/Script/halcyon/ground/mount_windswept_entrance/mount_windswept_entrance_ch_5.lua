--[[
    mount_windswept_entrance_ch_5.lua
    Refonte complète officielle pour le Camp du Mont Venteux (Chapitre 5).
    Contient :
      - BuildCamp(withFire) : décorations dynamiques de lits et feu
      - ArrivalCutscene() : arrivée progressive, intentions PNJ, soirée au feu (CampNightfall)
      - MorningSequence() : réveil échelonné, assemblée, course des équipes
      - SetupGround() : placement PNJ vivants sur le ground
      - Actions PNJ (dont Phileas / Noctowl et son soutien logistique)
      - WindSecretScene() : cinématique secrète de nuit (Hyko x Penticus)
      - LegendOfTheSkyArbiter() : légende du gardien
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

mount_windswept_entrance_ch_5 = {}

-- Coordinates for the circle of beds around center (290, 240)
mount_windswept_entrance_ch_5.BED_POS = {
	{290, 170}, {335, 185}, {365, 225}, {365, 265},
	{335, 305}, {290, 320}, {245, 305}, {215, 265},
	{215, 225}, {245, 185},
	{160, 220}, {160, 250} -- Off-circle beds for the duo (Hero: 11, Partner: 12)
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
-- CAMP BUILDER (Dynamic Decorations)
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.BuildCamp(withFire)
	local ground = GAME:GetCurrentGround()
	local hay_bed = RogueEssence.Content.ObjAnimData('Hay_Bed', 1)
	local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)

	pcall(function()
		local anims = ground.Decorations[0].Anims
		for i = anims.Count - 1, 0, -1 do anims:RemoveAt(i) end
	end)

	pcall(function()
		for _, pos in ipairs(mount_windswept_entrance_ch_5.BED_POS) do
			ground.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(pos[1]-12, pos[2]-12)))
		end
		if withFire then
			ground.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(290-16, 240-16)))
		end
	end)
end

--------------------------------------------------------------------
-- SETUP GROUND (After intro cutscene)
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.SetupGround()
	local ground = GAME:GetCurrentGround()
	GROUND:AddMapStatus("blowing_wind")
	mount_windswept_entrance_ch_5.BuildCamp(false)

	-- Place interactive characters on walkable camp positions
	local m = CharacterEssentials.MakeCharactersFromList({
		{'Tropius', 256, 200, Direction.Down},
		{'Noctowl', 320, 200, Direction.DownLeft},
		{'Growlithe', 232, 280, Direction.UpRight},
		{'Zigzagoon', 344, 280, Direction.UpLeft}
	})
	for _, ch in ipairs(m) do
		if ch ~= nil then GROUND:Unhide(ch.EntName) end
	end
end

--------------------------------------------------------------------
-- ARRIVAL CUTSCENE (Evening arrival, progressive entries, campfire, bedtime)
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

	-- Penticus (m[1]) and Phileas (m[2]) waiting near center campfire
	GROUND:TeleportTo(m[1], 270, 200, Direction.Down)
	GROUND:TeleportTo(m[2], 310, 200, Direction.Down)
	GROUND:Unhide(m[1].EntName)
	GROUND:Unhide(m[2].EntName)

	-- Teams starting south of camp for progressive arrival
	for i = 3, 10 do
		GROUND:TeleportTo(m[i], 290, 480 + (i-3)*16, Direction.Up)
		GROUND:Unhide(m[i].EntName)
	end
	GROUND:TeleportTo(hero, 270, 520, Direction.Up)
	if partner ~= nil then GROUND:TeleportTo(partner, 310, 520, Direction.Up) end

	GAME:FadeIn(40)
	SOUND:PlayBGM('At the End of the Day.ogg', true)

	-- Progressive entries with character intentions
	local enter_tasks = {}
	-- Cinabre team (5: Mareep, 6: Cranidos) arrives first, shivering from wind
	enter_tasks[1] = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(m[5], 250, 240, false, 0.8)
		GROUND:CharAnimateTurnTo(m[5], Direction.Right, 4)
	end)
	enter_tasks[2] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:MoveToPosition(m[6], 250, 270, false, 0.8)
		GROUND:CharAnimateTurnTo(m[6], Direction.UpRight, 4)
	end)
	TASK:JoinCoroutines(enter_tasks)
	GAME:WaitFrames(20)

	UI:SetSpeaker(m[5])
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("Bêêê... Ce vent est glacial, j'ai la laine glacée jusqu'aux racines !")
	
	UI:SetSpeaker(m[6])
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Approche-toi du brasier, Kino. Au moins la roche d'ici abrite des rafales.")

	-- Saphir team (3: Audino, 4: Snubbull, 7: Breloom, 8: Girafarig) arrives
	local saphir_tasks = {}
	saphir_tasks[1] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[3], 330, 240, false, 0.8) end)
	saphir_tasks[2] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[4], 330, 270, false, 0.8) end)
	saphir_tasks[3] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[7], 350, 255, false, 0.8) end)
	saphir_tasks[4] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[8], 350, 225, false, 0.8) end)
	TASK:JoinCoroutines(saphir_tasks)
	GAME:WaitFrames(20)

	UI:SetSpeaker(m[3])
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Tout le monde va bien ? Pas de blessure après la montée du Tunnel ?")

	UI:SetSpeaker(m[4])
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Regardez ce pic au-dessus de nous... Nous touchons au but !")

	-- Pointe team + Hero & Partner arrive
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

	-- Penticus welcomes the expedition
	GROUND:CharAnimateTurnTo(m[1], Direction.Down, 4)
	UI:SetSpeaker(m[1])
	UI:WaitShowDialogue("Équipe " .. GAME:GetTeamName() .. ". Vous voilà tous rassemblés.")
	UI:WaitShowDialogue("Le Tunnel Ardent a mis nos forces à l'épreuve, et le vent d'ici teste notre patience.")
	UI:WaitShowDialogue("Mais regardez : l'expédition entière est intacte. Installez-vous et partageons ce repas.")

	-- Call evening campfire scene
	mount_windswept_entrance_ch_5.CampNightfall(hero, partner, m)
end

--------------------------------------------------------------------
-- CAMP NIGHTFALL (Heartwarming soup around the fire & natural bedtime)
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.CampNightfall(hero, partner, membres)
	local B = mount_windswept_entrance_ch_5.BED_POS

	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("Le feu prend.[pause=30] Les provisions sont partagées autour des flammes.")
	UI:SetCenter(false)
	GAME:WaitFrames(25)

	-- Everyone turns toward the campfire
	local tours = {}
	for i, c in ipairs(membres) do
		tours[#tours+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(i * 3)
			GROUND:CharTurnToCharAnimated(c, hero, 4)
		end)
	end
	TASK:JoinCoroutines(tours)
	GAME:WaitFrames(20)

	UI:SetSpeaker(membres[7]) -- Breloom
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Servez-vous tant que c'est chaud ! En altitude, ça refroidit en deux minutes !")

	UI:SetSpeaker(membres[8]) -- Girafarig
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

	UI:SetSpeaker(membres[1]) -- Penticus
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Demain, le sommet du Mont Venteux. Dormez pendant que la montagne vous laisse dormir.")

	-- NATURAL BEDTIME (Staggered walking to hay beds)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("L'expédition rejoint ses lits de paille à l'abri des rafales...")
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

	-- Transition directly to MorningSequence
	mount_windswept_entrance_ch_5.MorningSequence()
end

--------------------------------------------------------------------
-- MORNING SEQUENCE (Emotional morning, assembly, team race)
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
	mount_windswept_entrance_ch_5.BuildCamp(false) -- Fire out in morning

	local m = CharacterEssentials.MakeCharactersFromList({
		{'Tropius'}, {'Noctowl'}, {'Audino'}, {'Snubbull'}, {'Mareep'}, 
		{'Cranidos'}, {'Breloom'}, {'Girafarig'}, {'Growlithe'}, {'Zigzagoon'}
	}, true)

	-- Everyone starting asleep at their beds
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

	-- Awakening (Partner first, nudging Hero)
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

	-- Assembly Call by Penticus
	GAME:WaitFrames(30)
	GROUND:CharEndAnim(m[1])
	GeneralFunctions.DoAnimation(m[1], 'Wake')
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(m[1])
	UI:WaitShowDialogue("Le soleil se lève ! Tout le monde debout ! On se rassemble !")

	-- Everyone wakes up in staggered branch coroutines (no one static!)
	local wake_tasks = {}
	for i = 2, 10 do
		wake_tasks[#wake_tasks+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(i * 10)
			GROUND:CharEndAnim(m[i])
			GeneralFunctions.DoAnimation(m[i], 'Wake')
		end)
	end
	TASK:JoinCoroutines(wake_tasks)

	-- Assembly around center campfire circle
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

	-- Briefing
	UI:SetSpeaker(m[1])
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Équipe " .. GAME:GetTeamName() .. ". Équipe Cinabre. Équipe Saphir. L'ascension finale commence.")
	UI:WaitShowDialogue("Nous allons nous diviser pour ne laisser aucun sentier inexploré.")
	UI:WaitShowDialogue("Équipe Cinabre : Kino, Reinier. Vous ouvrez la voie vers l'Est.")
	UI:WaitShowDialogue("Équipe Saphir : Shuca, Ganlon, Rin, Coco. Crêtes inférieures.")
	UI:WaitShowDialogue("Et l'équipe de pointe : Hyko, Almotz, " .. hero:GetDisplayName() .. " et " .. partner:GetDisplayName() .. ". Droit vers le pic !")

	GAME:WaitFrames(20)
	UI:SetSpeaker(m[7]) -- Breloom
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Hé hé ! Le premier arrivé là-haut gagne une Baie Grena ! La course est lancée !")

	-- The Race (Massive Departure)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	local race_tasks = {}
	for i = 3, 8 do
		race_tasks[#race_tasks+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames((i-2)*8)
			GROUND:MoveInDirection(m[i], Direction.Up, 320, false, 1.5)
			GAME:GetCurrentGround():RemoveTempChar(m[i])
		end)
	end
	TASK:JoinCoroutines(race_tasks)

	GAME:WaitFrames(40)
	if partner ~= nil then
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("Ils ne perdent pas de temps ! Allez, " .. hero:GetDisplayName() .. ", on ne va pas se laisser distancer !")
	end

	GAME:FadeOut(false, 60)
	GAME:WaitFrames(60)

	SV.Chapter5.FinishedMountWindsweptIntro = true
	GAME:CutsceneMode(false)
end

--------------------------------------------------------------------
-- NPC ACTIONS (Living Camp with Phileas's Gift)
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
-- WIND SECRET SCENE (Emotional Night Scene - Hyko x Penticus)
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
