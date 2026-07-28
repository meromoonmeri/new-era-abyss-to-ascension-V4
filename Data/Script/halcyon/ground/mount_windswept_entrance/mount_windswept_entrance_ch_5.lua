require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

mount_windswept_entrance_ch_5 = {}

-- IDs mapping for characters
mount_windswept_entrance_ch_5.MEMBER_LIST = {
	'Tropius', 'Noctowl', 'Audino', 'Snubbull', 'Mareep', 'Cranidos', 'Breloom', 'Girafarig', 'Growlithe', 'Zigzagoon'
}

-- Bed assignments (1 to 12 in the circle)
-- Clockwise starting from top: 
-- 1:Growlithe, 2:Noctowl, 3:Snubbull, 4:Cranidos, 5:Girafarig, 6:Zigzagoon (Bottom), 
-- 7:Partner, 8:Hero, 9:Breloom, 10:Mareep, 11:Audino, 12:Tropius
mount_windswept_entrance_ch_5.BED_MAP = {
	['Growlithe'] = 1, ['Noctowl'] = 2, ['Snubbull'] = 3, ['Cranidos'] = 4,
	['Girafarig'] = 5, ['Zigzagoon'] = 6, ['Teammate1'] = 7, ['PLAYER'] = 8,
	['Breloom'] = 9, ['Mareep'] = 10, ['Audino'] = 11, ['Tropius'] = 12
}

function mount_windswept_entrance_ch_5.GetBedPos(index)
	local obj = OBJ('Bed_' .. index)
	return obj.Position.X + 4, obj.Position.Y + 4 -- Center of the 24x24 bed
end

--------------------------------------------------------------------
-- SETUP GROUND (Static & Exploration Phase)
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.SetupGround()	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	-- Create all guild members
	local m = CharacterEssentials.MakeCharactersFromList({
		{'Tropius'}, {'Noctowl'}, {'Audino'}, {'Snubbull'}, {'Mareep'}, 
		{'Cranidos'}, {'Breloom'}, {'Girafarig'}, {'Growlithe'}, {'Zigzagoon'}
	}, true)

	if SV.Chapter5.FinishedMountWindsweptIntro then
		-- 1. PENTICUS & PHILEAS : Discussion near bags (240, 110)
		GROUND:TeleportTo(m[1], 230, 135, Direction.Right) -- Tropius
		GROUND:TeleportTo(m[2], 280, 135, Direction.Left)  -- Noctowl
		AI:SetCharacterAI(m[1], "halcyon.ai.ground_talking", true, 180, 150, 0, true, 'Default', {m[2]})
		AI:SetCharacterAI(m[2], "halcyon.ai.ground_talking", true, 180, 150, 0, true, 'Default', {m[1]})

		-- 2. RIN & COCO : Checking health near center
		GROUND:TeleportTo(m[3], 210, 240, Direction.Right) -- Audino
		GROUND:TeleportTo(m[4], 302, 240, Direction.Left)  -- Snubbull
		AI:SetCharacterAI(m[3], "halcyon.ai.ground_talking", true, 100, 80, 0, true, 'Default', {m[4]})
		AI:SetCharacterAI(m[4], "halcyon.ai.ground_talking", true, 100, 80, 0, true, 'Default', {m[3]})

		-- 3. SHUCA & GANLON : Looking at the trail
		GROUND:TeleportTo(m[5], 256, 330, Direction.Up)    -- Mareep
		GROUND:TeleportTo(m[6], 280, 350, Direction.UpLeft)-- Cranidos
		AI:SetCharacterAI(m[5], "halcyon.ai.ground_talking", true, 120, 100, 0, true, 'Default', {m[6]})
		AI:SetCharacterAI(m[6], "halcyon.ai.ground_talking", true, 120, 100, 0, true, 'Default', {m[5]})

		-- 4. KINO & REINIER : Perimeter watch
		GROUND:TeleportTo(m[7], 150, 220, Direction.Right) -- Breloom
		GROUND:TeleportTo(m[8], 360, 220, Direction.Left)  -- Girafarig
		AI:SetCharacterAI(m[7], "halcyon.ai.ground_talking", true, 200, 120, 0, true, 'Default', {m[8]})
		AI:SetCharacterAI(m[8], "halcyon.ai.ground_talking", true, 200, 120, 0, true, 'Default', {m[7]})

		-- 5. HYKO & ALMOTZ : Ready to go
		GROUND:TeleportTo(m[9], 240, 280, Direction.Up)    -- Growlithe
		GROUND:TeleportTo(m[10], 272, 280, Direction.Up)   -- Zigzagoon
		AI:SetCharacterAI(m[9], "halcyon.ai.ground_talking", true, 80, 60, 0, true, 'Default', {m[10]})
		AI:SetCharacterAI(m[10], "halcyon.ai.ground_talking", true, 80, 60, 0, true, 'Default', {m[9]})

		for _, c in ipairs(m) do GROUND:Unhide(c.EntName) end
		GAME:FadeIn(20)
	end
end

--------------------------------------------------------------------
-- ARRIVAL & BEDTIME (QUALITATIVE)
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.ArrivalCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	
	GAME:MoveCamera(256, 220, 1, false)
	GROUND:AddMapStatus("darkness")

	local m = CharacterEssentials.MakeCharactersFromList({
		{'Tropius'}, {'Noctowl'}, {'Audino'}, {'Snubbull'}, {'Mareep'}, 
		{'Cranidos'}, {'Breloom'}, {'Girafarig'}, {'Growlithe'}, {'Zigzagoon'}
	}, true)

	-- Everyone starts at their beds, awake for arrival
	for i, name in ipairs(mount_windswept_entrance_ch_5.MEMBER_LIST) do
		local bx, by = mount_windswept_entrance_ch_5.GetBedPos(mount_windswept_entrance_ch_5.BED_MAP[name])
		GROUND:TeleportTo(m[i], bx, by, Direction.Down)
		GROUND:Unhide(m[i].EntName)
	end

	-- Hero party enters from below
	GROUND:TeleportTo(hero, 240, 500, Direction.Up)
	GROUND:TeleportTo(partner, 272, 520, Direction.Up)

	GAME:FadeIn(40)
	SOUND:PlayBGM('At the End of the Day.ogg', true)

	-- Natural entrance
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 240, 340, false, 0.7) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 272, 360, false, 0.7) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("...Pfiou. C'est rude de grimper après ce tunnel.")

	-- Leader greeting
	GROUND:CharAnimateTurnTo(m[1], Direction.Down, 4)
	UI:SetSpeaker(m[1])
	UI:WaitShowDialogue("Équipe " .. GAME:GetTeamName() .. ". Vous voilà enfin. Installez-vous, nous avons tous besoin de repos.")

	-- BEDTIME SEQUENCE
	GAME:WaitFrames(40)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("L'expédition s'installe pour la nuit...")
	UI:SetCenter(false)
	
	local bedtime_tasks = {}
	-- Hero party joins their beds (Bed 8 and 7)
	local h_bx, h_by = mount_windswept_entrance_ch_5.GetBedPos(8)
	local p_bx, p_by = mount_windswept_entrance_ch_5.GetBedPos(7)
	
	bedtime_tasks[1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(20)
		GROUND:MoveToPosition(hero, h_bx, h_by, false, 0.8)
		GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
		GROUND:CharSetAnim(hero, "Sleep", true)
	end)
	bedtime_tasks[2] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(45)
		GROUND:MoveToPosition(partner, p_bx, p_by, false, 0.8)
		GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
		GROUND:CharSetAnim(partner, "Sleep", true)
	end)

	-- Guild members sleep with delays
	for i, name in ipairs(mount_windswept_entrance_ch_5.MEMBER_LIST) do
		if name ~= 'Breloom' and name ~= 'Girafarig' then -- Watchers stay awake
			bedtime_tasks[#bedtime_tasks+1] = TASK:BranchCoroutine(function()
				GAME:WaitFrames(60 + i * 12)
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
-- MORNING TRANSITION & ASSEMBLY
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.MorningSequence()
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("Le lendemain matin...")
	UI:SetCenter(false)
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	GAME:MoveCamera(256, 220, 1, false)
	GROUND:RemoveMapStatus("darkness")
	GROUND:AddMapStatus("dusk")
	
	local m = CharacterEssentials.MakeCharactersFromList({
		{'Tropius'}, {'Noctowl'}, {'Audino'}, {'Snubbull'}, {'Mareep'}, 
		{'Cranidos'}, {'Breloom'}, {'Girafarig'}, {'Growlithe'}, {'Zigzagoon'}
	}, true)

	-- Setup morning sleep states
	for i, name in ipairs(mount_windswept_entrance_ch_5.MEMBER_LIST) do
		local bx, by = mount_windswept_entrance_ch_5.GetBedPos(mount_windswept_entrance_ch_5.BED_MAP[name])
		GROUND:TeleportTo(m[i], bx, by, Direction.Down)
		GROUND:Unhide(m[i].EntName)
		if name ~= 'Breloom' and name ~= 'Girafarig' then
			GROUND:CharSetAnim(m[i], "Sleep", true)
		end
	end
	
	-- Hero party on beds
	local h_bx, h_by = mount_windswept_entrance_ch_5.GetBedPos(8)
	local p_bx, p_by = mount_windswept_entrance_ch_5.GetBedPos(7)
	GROUND:TeleportTo(hero, h_bx, h_by, Direction.Down)
	GROUND:TeleportTo(partner, p_bx, p_by, Direction.Down)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	GROUND:CharSetAnim(partner, "EventSleep", true)

	GAME:FadeIn(60)
	SOUND:PlayBGM('Heartwarming.ogg', true)
	GAME:WaitFrames(60)

	-- Progressive awakening (PMD Standard)
	GAME:WaitFrames(30)
	GROUND:CharEndAnim(partner)
	GeneralFunctions.DoAnimation(partner, 'Wake')
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("...Hé. " .. hero:GetDisplayName() .. ". Réveille-toi.")
	
	GAME:WaitFrames(20)
	GROUND:CharEndAnim(hero)
	GeneralFunctions.DoAnimation(hero, 'Wake')
	GAME:WaitFrames(40)
	
	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("Mmm... Le vent ne s'arrête donc jamais ?")

	-- Assembly Call
	GAME:WaitFrames(30)
	GROUND:CharEndAnim(m[1]) -- Tropius wakes up
	GeneralFunctions.DoAnimation(m[1], 'Wake')
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(m[1])
	UI:WaitShowDialogue("L'aube est là. Tout le monde debout ! On plie le camp !")

	-- Waking up everyone else
	local wake_tasks = {}
	for i=2, 6 do -- Except watchers and leader
		wake_tasks[#wake_tasks+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(i * 10)
			GROUND:CharEndAnim(m[i])
			GeneralFunctions.DoAnimation(m[i], 'Wake')
		end)
	end
	wake_tasks[#wake_tasks+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(70)
		GROUND:CharEndAnim(m[9]); GeneralFunctions.DoAnimation(m[9], 'Wake')
	end)
	wake_tasks[#wake_tasks+1] = TASK:BranchCoroutine(function()
		GAME:WaitFrames(80)
		GROUND:CharEndAnim(m[10]); GeneralFunctions.DoAnimation(m[10], 'Wake')
	end)
	TASK:JoinCoroutines(wake_tasks)

	-- ASSEMBLY AT THE BAGS
	GAME:WaitFrames(30)
	local assemble_tasks = {}
	-- Leaders to bags
	assemble_tasks[1] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[1], 240, 135, false, 1) end)
	assemble_tasks[2] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[2], 280, 135, false, 1) end)
	
	-- Team circle
	local circ_pts = {{180, 180}, {332, 180}, {160, 220}, {352, 220}, {180, 260}, {332, 260}, {210, 290}, {302, 290}}
	for i=3, 10 do
		local p = circ_pts[i-2]
		assemble_tasks[#assemble_tasks+1] = TASK:BranchCoroutine(function() 
			GAME:WaitFrames(i*3)
			GROUND:MoveToPosition(m[i], p[1], p[2], false, 1) 
			GROUND:CharTurnToChar(m[i], m[1])
		end)
	end
	-- Hero party
	assemble_tasks[#assemble_tasks+1] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 240, 240, false, 1) GROUND:CharTurnToChar(hero, m[1]) end)
	assemble_tasks[#assemble_tasks+1] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 272, 240, false, 1) GROUND:CharTurnToChar(partner, m[1]) end)
	
	TASK:JoinCoroutines(assemble_tasks)

	-- THE BRIEFING
	UI:SetSpeaker(m[1])
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Pokémon ! Nous sommes au pied du sommet. Ce que nous cherchons est là-haut.")
	UI:WaitShowDialogue("Nous allons nous diviser pour quadriller les sentiers.")
	UI:WaitShowDialogue("Équipe Cinabre : Kino, Reinier. Vous prenez le versant Est, surveillez les éboulements.")
	UI:WaitShowDialogue("Équipe Saphir : Shuca, Ganlon, Rin, Coco. Vous restez sur les crêtes inférieures pour assurer nos arrières.")
	UI:WaitShowDialogue("Équipe de pointe : Hyko, Almotz, " .. hero:GetDisplayName() .. " et " .. partner:GetDisplayName() .. ". Vous visez le sommet direct.")

	GAME:WaitFrames(20)
	UI:SetSpeaker(m[7]) -- Breloom
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Hé hé ! Le dernier arrivé paie sa tournée de Baies au retour ! Bonne chance, les petits !")

	-- THE RACE (MASSIVE DEPARTURE)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	local race_tasks = {}
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
	UI:WaitShowDialogue("Ils ne perdent pas de temps ! On ne va pas se laisser distancer !")

	GAME:FadeOut(false, 60)
	GAME:WaitFrames(60)

	-- Transition to LIVING CAMP
	SV.Chapter5.FinishedMountWindsweptIntro = true
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
	
	mount_windswept_entrance_ch_5.SetupGround()
end

--------------------------------------------------------------------
-- LIVING CAMP INTERACTIONS
--------------------------------------------------------------------

function mount_windswept_entrance_ch_5.Tropius_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	GeneralFunctions.StartConversation(chara)
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("L'itinéraire vers le sommet est dangereux. Restez groupés avec Hyko et Almotz.")
	UI:WaitShowDialogue("Nous maintenons la position ici avec Phileas pour sécuriser la zone de repli.")
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
		
		UI:WaitShowDialogue("Le vent là-haut est tranchant. Ne sous-estimez pas le froid, il épuise les forces plus vite que n'importe quel combat.")
	else
		UI:WaitShowDialogue("Prenez garde aux courants d'air ascendants. Ils peuvent vous désorienter en un instant.")
	end
	
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Growlithe_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Wouf ! Je suis prêt ! Le sommet n'a qu'à bien se tenir !", "Determined")
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Zigzagoon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "J'ai bien serré mon sac. Rien ne tombera, même si on doit courir !", "Happy")
	GeneralFunctions.EndConversation(chara)
end

return mount_windswept_entrance_ch_5
