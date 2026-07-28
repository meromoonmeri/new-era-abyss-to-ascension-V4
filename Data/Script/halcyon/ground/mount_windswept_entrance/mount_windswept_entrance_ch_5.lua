require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

mount_windswept_entrance_ch_5 = {}

-- Expedition members IDs
mount_windswept_entrance_ch_5.GUILD_MEMBERS = {
    'Tropius', 'Noctowl', 'Audino', 'Snubbull', 'Mareep', 
    'Cranidos', 'Breloom', 'Girafarig', 'Growlithe', 'Zigzagoon'
}

-- Bed assignments (1 to 12 in the circle)
-- 1:Growlithe, 2:Noctowl, 3:Snubbull, 4:Cranidos, 5:Girafarig, 6:Zigzagoon, 
-- 7:Partner, 8:Hero, 9:Breloom, 10:Mareep, 11:Audino, 12:Tropius
mount_windswept_entrance_ch_5.BED_MAP = {
    ['Growlithe'] = 1, ['Noctowl'] = 2, ['Snubbull'] = 3, ['Cranidos'] = 4,
    ['Girafarig'] = 5, ['Zigzagoon'] = 6, ['Teammate1'] = 7, ['PLAYER'] = 8,
    ['Breloom'] = 9, ['Mareep'] = 10, ['Audino'] = 11, ['Tropius'] = 12
}

-- Utility to get bed center position
function mount_windswept_entrance_ch_5.GetBedPos(index)
    local obj = OBJ('Bed_' .. index)
    return obj.Position.X + 4, obj.Position.Y + 4
end

-- Cleanup helper to avoid duplication
function mount_windswept_entrance_ch_5.Cleanup()
    local ground = GAME:GetCurrentGround()
    for _, id in ipairs(mount_windswept_entrance_ch_5.GUILD_MEMBERS) do
        local c = CH(id)
        if c ~= nil then ground:RemoveTempChar(c) end
    end
    -- teimate spawners are entity names, not IDs
    local others = {'TEAMMATE_1', 'TEAMMATE_2', 'TEAMMATE_3'}
    for _, id in ipairs(others) do
        local c = CH(id)
        if c ~= nil then ground:RemoveTempChar(c) end
    end
end

--------------------------------------------------------------------
-- SETUP GROUND (Living Camp Phase)
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.SetupGround()	
    local hero = CH('PLAYER')
    local partner = CH('Teammate1')

    mount_windswept_entrance_ch_5.Cleanup()

    -- Create guild members at their active positions
    -- Leaders near bags (260, 115)
    local m = CharacterEssentials.MakeCharactersFromList({
        {'Tropius', 256, 140, Direction.Right}, -- Penticus
        {'Noctowl', 296, 140, Direction.Left},  -- Phileas
        {'Audino', 230, 240, Direction.UpRight},-- Rin checking gear
        {'Snubbull', 332, 240, Direction.UpLeft}, -- Coco
        {'Mareep', 380, 220, Direction.Left},    -- Shuca
        {'Cranidos', 380, 250, Direction.Left},  -- Ganlon
        {'Breloom', 170, 220, Direction.DownRight}, -- Kino (Watcher)
        {'Girafarig', 380, 180, Direction.DownLeft}, -- Reinier (Watcher)
        {'Growlithe', 270, 280, Direction.Up},   -- Hyko
        {'Zigzagoon', 302, 280, Direction.Up}    -- Almotz
    }, true)

    -- Assign AI for movement and life
    for i=1, 10 do
        local friends = {}
        if i % 2 == 1 then table.insert(friends, m[i+1]) else table.insert(friends, m[i-1]) end
        AI:SetCharacterAI(m[i], "halcyon.ai.ground_talking", true, 180, 120, 0, true, 'Default', friends)
        GROUND:Unhide(m[i].EntName)
    end

    if SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind then
        GROUND:TeleportTo(m[3], 290, 260, Direction.Down) -- Rin moves to center
    end
end

--------------------------------------------------------------------
-- ARRIVAL & BEDTIME (QUALITATIVE)
--------------------------------------------------------------------
function mount_windswept_entrance_ch_5.ArrivalCutscene()
    local hero = CH('PLAYER')
    local partner = CH('Teammate1')

    mount_windswept_entrance_ch_5.Cleanup()
    GAME:CutsceneMode(true)
    AI:DisableCharacterAI(partner)
    SOUND:StopBGM()
    
    -- Center on fire (290, 240)
    GAME:MoveCamera(290, 240, 1, false)
    GROUND:AddMapStatus("darkness")

    local m = CharacterEssentials.MakeCharactersFromList({
        {'Tropius'}, {'Noctowl'}, {'Audino'}, {'Snubbull'}, {'Mareep'}, 
        {'Cranidos'}, {'Breloom'}, {'Girafarig'}, {'Growlithe'}, {'Zigzagoon'}
    }, true)

    -- Everyone at their beds
    for i, name in ipairs(mount_windswept_entrance_ch_5.GUILD_MEMBERS) do
        local bx, by = mount_windswept_entrance_ch_5.GetBedPos(mount_windswept_entrance_ch_5.BED_MAP[name])
        GROUND:TeleportTo(m[i], bx, by, Direction.Down)
        GROUND:Unhide(m[i].EntName)
        if name ~= 'Breloom' and name ~= 'Girafarig' then 
            GROUND:CharSetAnim(m[i], "Sleep", true)
        else
            GROUND:CharSetAnim(m[i], "Idle", true)
        end
    end

    -- Heroes enter from below (Marker is at 256, 472)
    GROUND:TeleportTo(hero, 270, 500, Direction.Up)
    GROUND:TeleportTo(partner, 310, 520, Direction.Up)

    GAME:FadeIn(40)
    SOUND:PlayBGM('At the End of the Day.ogg', true)

    -- Natural walk in
    local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 270, 360, false, 0.7) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 310, 380, false, 0.7) end)
    TASK:JoinCoroutines({coro1, coro2})

    GAME:WaitFrames(20)
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Pain")
    UI:WaitShowDialogue("...Enfin le camp de base. Le vent souffle moins fort ici, mais le froid reste mordant.")

    -- Leader welcome (Penticus wakes)
    GROUND:CharEndAnim(m[1])
    GeneralFunctions.DoAnimation(m[1], 'Wake')
    GAME:WaitFrames(20)
    GROUND:CharAnimateTurnTo(m[1], Direction.Down, 4)
    UI:SetSpeaker(m[1])
    UI:WaitShowDialogue("Équipe " .. GAME:GetTeamName() .. ". Vous voilà. Le Tunnel n'a pas été clément, je le vois à vos mines.")
    UI:WaitShowDialogue("Installez-vous. Demain, nous affrontons le sommet. Reposez-vous bien.")

    -- Heroes to their beds (Bed 8 and 7)
    local h_bx, h_by = mount_windswept_entrance_ch_5.GetBedPos(8)
    local p_bx, p_by = mount_windswept_entrance_ch_5.GetBedPos(7)
    
    local bedtime_tasks = {}
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
    
    mount_windswept_entrance_ch_5.Cleanup()
    GAME:MoveCamera(290, 240, 1, false)
    GROUND:RemoveMapStatus("darkness")
    GROUND:AddMapStatus("dusk")
    
    local m = CharacterEssentials.MakeCharactersFromList({
        {'Tropius'}, {'Noctowl'}, {'Audino'}, {'Snubbull'}, {'Mareep'}, 
        {'Cranidos'}, {'Breloom'}, {'Girafarig'}, {'Growlithe'}, {'Zigzagoon'}
    }, true)

    -- Setup sleep states
    for i, name in ipairs(mount_windswept_entrance_ch_5.GUILD_MEMBERS) do
        local bx, by = mount_windswept_entrance_ch_5.GetBedPos(mount_windswept_entrance_ch_5.BED_MAP[name])
        GROUND:TeleportTo(m[i], bx, by, Direction.Down)
        GROUND:Unhide(m[i].EntName)
        if name ~= 'Breloom' and name ~= 'Girafarig' then
            GROUND:CharSetAnim(m[i], "Sleep", true)
        end
    end
    
    -- Heroes on beds
    local h_bx, h_by = mount_windswept_entrance_ch_5.GetBedPos(8)
    local p_bx, p_by = mount_windswept_entrance_ch_5.GetBedPos(7)
    GROUND:TeleportTo(hero, h_bx, h_by, Direction.Down)
    GROUND:TeleportTo(partner, p_bx, p_by, Direction.Down)
    GROUND:CharSetAnim(hero, "EventSleep", true)
    GROUND:CharSetAnim(partner, "EventSleep", true)

    GAME:FadeIn(60)
    SOUND:PlayBGM('Heartwarming.ogg', true)
    GAME:WaitFrames(60)

    -- Awakening
    GAME:WaitFrames(30)
    GROUND:CharEndAnim(partner)
    GeneralFunctions.DoAnimation(partner, 'Wake')
    GAME:WaitFrames(20)
    GROUND:CharTurnToCharAnimated(partner, hero, 4)
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue("...Hé. " .. hero:GetDisplayName() .. ". Réveille-toi. Le jour se lève.")
    
    GAME:WaitFrames(20)
    GROUND:CharEndAnim(hero)
    GeneralFunctions.DoAnimation(hero, 'Wake')
    GAME:WaitFrames(40)
    UI:SetSpeaker(hero)
    UI:SetSpeakerEmotion("Pain")
    UI:WaitShowDialogue("...Mmm. J'ai l'impression d'avoir dormi dans un bloc de glace.")

    -- Assembly
    GAME:WaitFrames(30)
    GROUND:CharEndAnim(m[1]) -- Penticus wakes
    GeneralFunctions.DoAnimation(m[1], 'Wake')
    GAME:WaitFrames(20)
    UI:SetSpeaker(m[1])
    UI:WaitShowDialogue("Tout le monde debout ! On se rassemble !")

    local wake_tasks = {}
    for i=2, 6 do
        wake_tasks[#wake_tasks+1] = TASK:BranchCoroutine(function() GAME:WaitFrames(i * 12) GROUND:CharEndAnim(m[i]); GeneralFunctions.DoAnimation(m[i], 'Wake') end)
    end
    wake_tasks[#wake_tasks+1] = TASK:BranchCoroutine(function() GAME:WaitFrames(70) GROUND:CharEndAnim(m[9]); GeneralFunctions.DoAnimation(m[9], 'Wake') end)
    wake_tasks[#wake_tasks+1] = TASK:BranchCoroutine(function() GAME:WaitFrames(85) GROUND:CharEndAnim(m[10]); GeneralFunctions.DoAnimation(m[10], 'Wake') end)
    TASK:JoinCoroutines(wake_tasks)

    GAME:WaitFrames(30)
    local assemble_tasks = {}
    assemble_tasks[1] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[1], 256, 140, false, 1) end)
    assemble_tasks[2] = TASK:BranchCoroutine(function() GROUND:MoveToPosition(m[2], 296, 140, false, 1) end)
    -- Circle pts around fire (290, 240)
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

    UI:SetSpeaker(m[1])
    UI:SetSpeakerEmotion("Inspired")
    UI:WaitShowDialogue("L'ascension finale commence maintenant. Le Cœur d'Anima nous appelle.")
    UI:WaitShowDialogue("Nous allons nous diviser en trois groupes pour maximiser nos chances.")
    UI:WaitShowDialogue("Équipe Cinabre : Kino, Reinier. Le versant Est.")
    UI:WaitShowDialogue("Équipe Saphir : Shuca, Ganlon, Rin, Coco. Les crêtes inférieures.")
    UI:WaitShowDialogue("Et l'équipe de pointe : Hyko, Almotz, " .. hero:GetDisplayName() .. " et " .. partner:GetDisplayName() .. ". Droit vers le pic !")

    GAME:WaitFrames(20)
    UI:SetSpeaker(m[7]) -- Breloom
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("C'est parti ! On va voir qui arrive en haut en premier !")

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
    UI:WaitShowDialogue("Allez ! On ne peut pas les laisser gagner !")

    GAME:FadeOut(false, 60)
    GAME:WaitFrames(60)

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
    UI:WaitShowDialogue("L'itinéraire vers le pic est risqué. Restez groupés.")
    GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Noctowl_Action(chara, activator)
    DEBUG.EnableDbgCoro()
    GeneralFunctions.StartConversation(chara)
    UI:SetSpeaker(chara)
    if not SV.Chapter5.PhileasGiftGiven then
        UI:WaitShowDialogue("Hou... Prenez ceci avant l'ascension. Cela pourrait vous sauver la mise.")
        local item = "berry_oran"
        if math.random(1,2) == 1 then item = "seed_reviver" end
        SOUND:PlayFanfare("Item")
        UI:WaitShowDialogue("Vous recevez une " .. _DATA:GetItem(item):GetColoredName() .. " !")
        GAME:GivePlayerStorageItem(item)
        SV.Chapter5.PhileasGiftGiven = true
        UI:WaitShowDialogue("La montagne ne pardonne pas les erreurs. Soyez prudents.")
    else
        UI:WaitShowDialogue("Le Cœur d'Anima pulse avec une intensité croissante. Ne tardez pas.")
    end
    GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Growlithe_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, "Wouf ! Prêt au combat !", "Determined")
    GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Zigzagoon_Action(chara, activator)
    GeneralFunctions.StartConversation(chara, "J'ai bien serré mon sac. Rien ne tombera, même si on doit courir !", "Happy")
    GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Audino_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Mes bandages sont prêts !", "Normal")
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Snubbull_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Regardez-moi ce pic... Il a l'air si fier !", "Inspired")
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Mareep_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Bêêê ! Quelle vue !", "Happy")
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Cranidos_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Rien n'est plus solide que mon crâne !", "Normal")
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Breloom_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "En route pour le sommet !", "Happy")
	GeneralFunctions.EndConversation(chara)
end

function mount_windswept_entrance_ch_5.Girafarig_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Le sommet vibre d'énergie.", "Normal")
	GeneralFunctions.EndConversation(chara)
end

return mount_windswept_entrance_ch_5
