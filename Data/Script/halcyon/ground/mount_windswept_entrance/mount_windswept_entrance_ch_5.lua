require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

mount_windswept_entrance_ch_5 = {}

function mount_windswept_entrance_ch_5.SetupGround()	
	--Camp de base du Mont Venteux : toute l'expedition est presente.
	--Positions verifiees walkables (feu de camp decoratif en 256,220).
	local tropius, noctowl, audino, snubbull, mareep, cranidos, breloom, girafarig =
	CharacterEssentials.MakeCharactersFromList({
		{'Tropius', 212, 244, Direction.DownRight},
		{'Noctowl', 300, 244, Direction.DownLeft},
		{'Audino', 220, 276, Direction.UpRight},
		{'Snubbull', 292, 276, Direction.UpLeft},
		{'Mareep', 204, 312, Direction.Right},
		{'Cranidos', 308, 312, Direction.Left},
		{'Breloom', 160, 300, Direction.Right},
		{'Girafarig', 360, 300, Direction.Left}
	})

	--Le feu de camp reste allume tant que l'expedition campe ici.
	local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)
	GAME:GetCurrentGround().Decorations[0].Anims:Add(
		RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(256, 220)))

	--Apres une defaite en montagne, Rin se rapproche du feu pour soigner.
	if SV.Chapter5.LostMountain or SV.Chapter5.DiedToWind then
		GROUND:TeleportTo(audino, 244, 252, Direction.Down)
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
	GAME:MoveCamera(276, 248, 1, false)
	GROUND:AddMapStatus("darkness")--nighttime
	
	--for debug purposes
	GAME:FadeOut(false, 1)
	
	local hay_bed = RogueEssence.Content.ObjAnimData('Hay_Bed', 1)
	local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)

	GROUND:TeleportTo(hero, 252, 396, Direction.Up)
	GROUND:TeleportTo(partner, 284, 396, Direction.Right)
	
	local audino, snubbull, girafarig, breloom, growlithe, zigzagoon, tropius, noctowl, mareep, cranidos = 
	CharacterEssentials.MakeCharactersFromList({
		{'Audino'},
		{'Snubbull'},
		{'Girafarig'},
		{'Breloom'},
		{'Growlithe', 292, 428, Direction.Up},
		{'Zigzagoon', 244, 428, Direction.Up},
		{'Tropius'},
		{'Noctowl'},
		{'Mareep'},
		{'Cranidos'}
	})
	
	
	--This is done like this so I can copy and paste this code into other scenes that have a similar set up and only change one value
	--to get all the beds and campfire to spawn relative to that spot.
	local bedRelativeX = 178
	local bedRelativeY = 164
	local bed1X, bed6X = bedRelativeX + 78, bedRelativeX + 78
	local bed2X, bed5X = bedRelativeX + 123, bedRelativeX + 123
	local bed3X, bed4X = bedRelativeX + 156, bedRelativeX + 156
	local bed7X, bed10X = bedRelativeX + 33, bedRelativeX + 33
	local bed8X, bed9X = bedRelativeX, bedRelativeX
	
	local bed11X, bed11Y = 312, 108
	local bed12X, bed12Y = 344, 132
	
	local bed1Y = bedRelativeY
	local bed2Y, bed10Y = bedRelativeY + 11, bedRelativeY + 11
	local bed3Y, bed9Y = bedRelativeY + 44, bedRelativeY + 44
	local bed4Y, bed8Y = bedRelativeY + 84, bedRelativeY + 84
	local bed5Y, bed7Y = bedRelativeY + 117, bedRelativeY + 117
	local bed6Y = bedRelativeY + 128
	

	--Beds. Start with top center, go clockwise, then do the two off to the side.
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed1X, bed1Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed2X, bed2Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed3X, bed3Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed4X, bed4Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed5X, bed5Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed6X, bed6Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed7X, bed7Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed8X, bed8Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed9X, bed9Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed10X, bed10Y)))

	--bed 11/12 are a bit more free form in where they go.
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed11X, bed11Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed12X, bed12Y)))
	
	
	GAME:WaitFrames(40)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_001'], tunnel:GetColoredName()))
	GAME:WaitFrames(20)
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWE5_002']))
	GAME:WaitFrames(20)
	
	GAME:FadeIn(40)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 92, 176, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames (10) GROUND:MoveToPosition(hero, 92, 144, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(2) GROUND:MoveToPosition(growlithe, 60, 184, false, 1) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:MoveToPosition(zigzagoon, 60, 136, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
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

	-- The camp comes alive around the fire.  The expedition is no longer
	-- represented by only two sprites at the entrance.
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(256, 220)))
	for _, chara in ipairs({tropius, noctowl, audino, snubbull, mareep, cranidos}) do
		GROUND:Unhide(chara.EntName)
	end
	GROUND:TeleportTo(tropius, 212, 244, Direction.Right)
	GROUND:TeleportTo(noctowl, 300, 244, Direction.Left)
	GROUND:TeleportTo(audino, 220, 276, Direction.UpRight)
	GROUND:TeleportTo(snubbull, 292, 276, Direction.UpLeft)
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
	GAME:FadeOut(false, 40)
	GAME:WaitFrames(40)
	for _, chara in ipairs({audino, snubbull, girafarig, breloom, growlithe, zigzagoon, tropius, noctowl, mareep, cranidos}) do
		GAME:GetCurrentGround():RemoveTempChar(chara)
	end
	SV.Chapter5.FinishedMountWindsweptIntro = true
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
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
	local growlithe = CH('Teammate2')
	if tropius == nil or growlithe == nil then GAME:FadeIn(20) return end

	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	GROUND:AddMapStatus("darkness")

	-- Le heros se reveille seul ; deux silhouettes au bord du camp.
	GROUND:TeleportTo(hero, 256, 340, Direction.Up)
	GROUND:TeleportTo(tropius, 352, 200, Direction.Down)
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
	SOUND:PlayBGM('Mt. Travail.ogg', true)
	GAME:FadeIn(40)
end
