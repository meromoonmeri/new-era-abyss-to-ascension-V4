require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

mount_windswept_entrance_ch_5 = {}

-- Coordinates for the circle of beds
-- Center at 290, 240
mount_windswept_entrance_ch_5.BED_POS = {
	{290, 170}, {335, 185}, {365, 225}, {365, 265},
	{335, 305}, {290, 320}, {245, 305}, {215, 265},
	{215, 225}, {245, 185},
	{160, 220}, {160, 250} -- Off-circle beds for the duo
}

-- Mapping characters to beds
-- 1:Growlithe, 2:Noctowl, 3:Snubbull, 4:Cranidos, 5:Girafarig, 6:Zigzagoon, 
-- 7:Partner, 8:Hero (Wait, I only have 10 guild members + 2 heroes = 12)
-- Assignments:
-- 1:Tropius, 2:Noctowl, 3:Audino, 4:Snubbull, 5:Mareep, 6:Cranidos, 7:Breloom, 8:Girafarig, 9:Growlithe, 10:Zigzagoon
-- 11:PLAYER, 12:Teammate1
mount_windswept_entrance_ch_5.ASSIGNMENTS = {
	['Tropius'] = 1, ['Noctowl'] = 2, ['Audino'] = 3, ['Snubbull'] = 4,
	['Mareep'] = 5, ['Cranidos'] = 6, ['Breloom'] = 7, ['Girafarig'] = 8,
	['Growlithe'] = 9, ['Zigzagoon'] = 10, ['PLAYER'] = 11, ['Teammate1'] = 12
}

--------------------------------------------------------------------
-- CAMP BUILDER (Dynamic Decorations like Searing Tunnel)
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.BuildCamp(withFire)
	local ground = GAME:GetCurrentGround()
	local hay_bed = RogueEssence.Content.ObjAnimData('Hay_Bed', 1)
	local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)
	local bags = RogueEssence.Content.ObjAnimData('Grassy_Bag', 1)

	-- Purge layer 0 anims
	pcall(function()
		local anims = ground.Decorations[0].Anims
		for i = anims.Count - 1, 0, -1 do anims:RemoveAt(i) end
	end)

	-- Add beds
	for _, pos in ipairs(mount_windswept_entrance_ch_5.BED_POS) do
		ground.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(pos[1]-12, pos[2]-12)))
	end

	-- Add fire if requested
	if withFire then
		ground.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(290-8, 240-8)))
	end

	-- Add expedition bags near leaders
	ground.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(bags, RogueElements.Loc(260, 110)))
end

--------------------------------------------------------------------
-- SETUP GROUND (Living Camp Phase)
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.SetupGround()	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	-- Create guild members
	local m = CharacterEssentials.MakeCharactersFromList({
		{'Tropius', 256, 140, Direction.Right}, -- 1
		{'Noctowl', 296, 140, Direction.Left},  -- 2
		{'Audino', 230, 240, Direction.UpRight},-- 3
		{'Snubbull', 332, 240, Direction.UpLeft}, -- 4
		{'Mareep', 380, 220, Direction.Left},    -- 5
		{'Cranidos', 380, 250, Direction.Left},  -- 6
		{'Breloom', 170, 220, Direction.DownRight}, -- 7
		{'Girafarig', 380, 180, Direction.DownLeft}, -- 8
		{'Growlithe', 270, 280, Direction.Up},   -- 9
		{'Zigzagoon', 302, 280, Direction.Up}    -- 10
	}, true)

	-- Static decorations
	mount_windswept_entrance_ch_5.BuildCamp(true)

	-- Ambient AI (Passive Life)
	-- Format: turn, IdleTime, EmoteIdleTime, InitialDelay, RandomTalk, personality, friends
	AI:SetCharacterAI(m[1], "halcyon.ai.ground_talking", true, 180, 120, 0, true, 'Default', {m[2]})
	AI:SetCharacterAI(m[2], "halcyon.ai.ground_talking", true, 180, 120, 0, true, 'Default', {m[1]})
	AI:SetCharacterAI(m[3], "halcyon.ai.ground_talking", true, 100, 80, 0, true, 'Default', {m[4]})
	AI:SetCharacterAI(m[4], "halcyon.ai.ground_talking", true, 100, 80, 0, true, 'Default', {m[3]})
	AI:SetCharacterAI(m[5], "halcyon.ai.ground_talking", true, 120, 100, 0, true, 'Default', {m[6]})
	AI:SetCharacterAI(m[6], "halcyon.ai.ground_talking", true, 120, 100, 0, true, 'Default', {m[5]})
	AI:SetCharacterAI(m[7], "halcyon.ai.ground_talking", true, 200, 120, 0, true, 'Default', {m[8]})
	AI:SetCharacterAI(m[8], "halcyon.ai.ground_talking", true, 200, 120, 0, true, 'Default', {m[7]})
	AI:SetCharacterAI(m[9], "halcyon.ai.ground_talking", true, 80, 60, 0, true, 'Default', {m[10]})
	AI:SetCharacterAI(m[10], "halcyon.ai.ground_talking", true, 80, 60, 0, true, 'Default', {m[9]})

	for _, c in ipairs(m) do GROUND:Unhide(c.EntName) end
	GAME:FadeIn(20)
end

--------------------------------------------------------------------
-- ARRIVAL & BEDTIME (Searing Tunnel Logic)
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.ArrivalCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	
	GAME:MoveCamera(290, 240, 1, false)
	GROUND:AddMapStatus("darkness")
	mount_windswept_entrance_ch_5.BuildCamp(true)

	local m = CharacterEssentials.MakeCharactersFromList({
		{'Tropius'}, {'Noctowl'}, {'Audino'}, {'Snubbull'}, {'Mareep'}, 
		{'Cranidos'}, {'Breloom'}, {'Girafarig'}, {'Growlithe'}, {'Zigzagoon'}
	}, true)

	-- Set characters at their beds, awake for the welcome
	for i, name in ipairs(mount_windswept_entrance_ch_5.MEMBER_LIST) do
		local pos = mount_windswept_entrance_ch_5.BED_POS[mount_windswept_entrance_ch_5.BED_MAP[name]]
		GROUND:TeleportTo(m[i], pos[1], pos[2], Direction.Down)
		GROUND:Unhide(m[i].EntName)
	end

	-- Heroes arrive from bottom
	GROUND:TeleportTo(hero, 270, 500, Direction.Up)
	GROUND:TeleportTo(partner, 310, 520, Direction.Up)

	GAME:FadeIn(40)
	SOUND:PlayBGM('At the End of the Day.ogg', true)

	-- Natural entrance walk
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 270, 360, false, 0.7) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 310, 380, false, 0.7) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("...Enfin le camp de base. Le vent souffle moins fort ici, mais le froid reste mordant.")

	-- Leader welcome
	GROUND:CharAnimateTurnTo(m[1], Direction.Down, 4)
	UI:SetSpeaker(m[1])
	UI:WaitShowDialogue("Équipe " .. GAME:GetTeamName() .. ". Vous voilà. Le Tunnel n'a pas été clément, je le vois à vos mines.")
	UI:WaitShowDialogue("Installez-vous. Demain, nous affrontons le sommet. Reposez-vous bien.")

	-- BEDTIME SEQUENCE
	GAME:WaitFrames(40)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("L'expédition s'installe pour une nuit nécessaire...")
	UI:SetCenter(false)
	
	local bedtime_tasks = {}
	-- Duo joins their beds (11 and 12)
	local h_bed = mount_windswept_entrance_ch_5.BED_POS[11]
	local p_bed = mount_windswept_entrance_ch_5.BED_POS[12]
	
	bedtime_tasks[1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GROUND:MoveToPosition(hero, h_bed[1], h_bed[2], false, 0.8)
		GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
		GROUND:CharSetAnim(hero, "Sleep", true)
	end)
	bedtime_tasks[2] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(45)
		GROUND:MoveToPosition(partner, p_bed[1], p_bed[2], false, 0.8)
		GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
		GROUND:CharSetAnim(partner, "Sleep", true)
	end)

	-- Everyone else sleeps with delays, except watchers (Kino 7, Reinier 8)
	for i, name in ipairs(mount_windswept_entrance_ch_5.MEMBER_LIST) do
		if i ~= 7 and i ~= 8 then
			bedtime_tasks[#bedtime_tasks+1] = TASK:BranchCoroutine(function()
				GAME:WaitFrames(60 + i * 15)
				GROUND:CharSetAnim(m[i], "Sleep", true)
			end)
		end
	end

	TASK:JoinCoroutines(bedtime_tasks)
	GAME:WaitFrames(100)
	GAME:FadeOut(false, 120)
	GAME:WaitFrames(60)
	
	mount_windswept_entrance_ch_5.MorningSequence()
end

--------------------------------------------------------------------
-- MORNING TRANSITION & ASSEMBLY (The Race)
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
	mount_windswept_entrance_ch_5.BuildCamp(false) -- Fire is out in the morning

	local m = CharacterEssentials.MakeCharactersFromList({
		{'Tropius'}, {'Noctowl'}, {'Audino'}, {'Snubbull'}, {'Mareep'}, 
		{'Cranidos'}, {'Breloom'}, {'Girafarig'}, {'Growlithe'}, {'Zigzagoon'}
	}, true)

	-- Everyone starting asleep at their beds
	for i, name in ipairs(mount_windswept_entrance_ch_5.MEMBER_LIST) do
		local pos = mount_windswept_entrance_ch_5.BED_POS[mount_windswept_entrance_ch_5.BED_MAP[name]]
		GROUND:TeleportTo(m[i], pos[1], pos[2], Direction.Down)
		GROUND:Unhide(m[i].EntName)
		if i ~= 7 and i ~= 8 then GROUND:CharSetAnim(m[i], "Sleep", true) end
	end
	
	local h_bed = mount_windswept_entrance_ch_5.BED_POS[11]
	local p_bed = mount_windswept_entrance_ch_5.BED_POS[12]
	GROUND:TeleportTo(hero, h_bed[1], h_bed[2], Direction.Down)
	GROUND:TeleportTo(partner, p_bed[1], p_bed[2], Direction.Down)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	GROUND:CharSetAnim(partner, "EventSleep", true)

	GAME:FadeIn(60)
	SOUND:PlayBGM('Heartwarming.ogg', true)
	GAME:WaitFrames(60)

	-- Awakening (PMD Standard)
	GAME:WaitFrames(30)
	GROUND:CharEndAnim(partner)
	GeneralFunctions.DoAnimation(partner, 'Wake')
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("...Mmm. " .. hero:GetDisplayName() .. ". Allez, réveille-toi. Le jour se lève.")
	
	GAME:WaitFrames(20)
	GROUND:CharEndAnim(hero)
	GeneralFunctions.DoAnimation(hero, 'Wake')
	GAME:WaitFrames(40)
	
	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("...Mmm. J'ai l'impression d'avoir dormi dans un bloc de glace.")

	-- Assembly Call
	GAME:WaitFrames(30)
	GROUND:CharEndAnim(m[1]) -- Penticus wakes
	GeneralFunctions.DoAnimation(m[1], 'Wake')
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(m[1])
	UI:WaitShowDialogue("Le soleil se lève ! Tout le monde debout ! On se rassemble !")

	-- Everyone wakes up
	local wake_tasks = {}
	for i=2, 6 do
		wake_tasks[#wake_tasks+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(i * 12)
			GROUND:CharEndAnim(m[i])
			GeneralFunctions.DoAnimation(m[i], 'Wake')
		end)
	end
	wake_tasks[#wake_tasks+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(70)
		GROUND:CharEndAnim(m[9]); GeneralFunctions.DoAnimation(m[9], 'Wake')
	end)
	wake_tasks[#wake_tasks+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(85)
		GROUND:CharEndAnim(m[10]); GeneralFunctions.DoAnimation(m[10], 'Wake')
	end)
	TASK:JoinCoroutines(wake_tasks)

	-- ASSEMBLY AT THE BAGS
	GAME:WaitFrames(30)
	local assemble_tasks = {}
	assemble_tasks[1] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[1], 256, 140, false, 1) end)
	assemble_tasks[2] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[2], 296, 140, false, 1) end)
	
	local circ_pts = {{210, 180}, {372, 180}, {190, 220}, {392, 220}, {210, 260}, {372, 260}, {240, 290}, {342, 290}}
	for i=3, 10 do
		local p = circ_pts[i-2]
		assemble_tasks[#assemble_tasks+1] = TASK:BranchCoroutine(function() 
			GAME:WaitFrames(i*3)
			GROUND:MoveToPosition(m[i], p[1], p[2], false, 1) 
			GROUND:CharTurnToCharAnimated(m[i], m[1], 4)
		end)
	end
	assemble_tasks[#assemble_tasks+1] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 270, 240, false, 1) GROUND:CharTurnToCharAnimated(hero, m[1], 4) end)
	assemble_tasks[#assemble_tasks+1] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 310, 240, false, 1) GROUND:CharTurnToCharAnimated(partner, m[1], 4) end)
	TASK:JoinCoroutines(assemble_tasks)

	-- BRIEFING
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

	-- THE RACE (MASSIVE DEPARTURE)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	local race_tasks = {}
	-- Cinabre and Saphir teams run away
	for i=3, 8 do
		race_tasks[#race_tasks+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames((i-2)*8)
			GROUND:MoveInDirection(m[i], Direction.Up, 300, false, 1.4)
			GAME:GetCurrentGround():RemoveTempChar(m[i])
		end)
	end
	TASK:JoinCoroutines(race_tasks)

	GAME:WaitFrames(40)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Ils ne perdent pas de temps ! Allez, " .. hero:GetDisplayName() .. ", on ne va pas se laisser distancer !")

	GAME:FadeOut(false, 60)
	GAME:WaitFrames(60)

	-- Transition to exploration
	SV.Chapter5.FinishedMountWindsweptIntro = true
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
	
	mount_windswept_entrance_ch_5.SetupGround()
end

--------------------------------------------------------------------
-- INTERACTIONS
--------------------------------------------------------------------

function mount_windswept_entrance_ch_5.Tropius_Action(chara, activator)
    DEBUG.EnableDbgCoro()
    GeneralFunctions.StartConversation(chara)
    UI:SetSpeaker(chara)
    UI:WaitShowDialogue("L'itinéraire vers le pic est risqué. Restez groupés avec Hyko et Almotz.")
    GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Noctowl_Action(chara, activator)
    DEBUG.EnableDbgCoro()
    GeneralFunctions.StartConversation(chara)
    UI:SetSpeaker(chara)
    
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

return mount_windswept_entrance_ch_5
