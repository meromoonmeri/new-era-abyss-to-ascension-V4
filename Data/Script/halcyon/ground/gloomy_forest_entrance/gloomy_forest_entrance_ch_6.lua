--[[
    gloomy_forest_entrance_ch_6.lua
    Created: 2026-08-01
    Description: Séquence cinématographique d'ouverture du Chapitre 6 — Forêt Lugubre.
    Arrivée de la Team Dazzling, chamailleries comiques, piques de rivalité.
]]--
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

gloomy_forest_entrance_ch_6 = {}

function gloomy_forest_entrance_ch_6.SetupGround()
	-- Lors d'un retour ordinaire (gameplay), pas de PNJ gênant l'entrée.
	pcall(function()
		GROUND:Hide('Adagio')
		GROUND:Hide('Aria')
		GROUND:Hide('Sonata')
	end)
end

function gloomy_forest_entrance_ch_6.ArrivalCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	-- 1. INITIALISATION DE LA SCÈNE (SOUS LE NOIR)
	pcall(function() GAME:FadeOut(false, 1) end)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)

	-- Spawners de la Team Dazzling (créées masquées pour l'introduction)
	local adagio, aria, sonata = CharacterEssentials.MakeCharactersFromList({
		{'Adagio', 40, 280, Direction.Right},
		{'Aria', 20, 300, Direction.Right},
		{'Sonata', 40, 320, Direction.Right}
	})
	GROUND:Hide('Adagio')
	GROUND:Hide('Aria')
	GROUND:Hide('Sonata')

	-- Positionnement d'ouverture du duo
	GROUND:TeleportTo(hero, 312, 480, Direction.Up)
	GROUND:TeleportTo(partner, 328, 480, Direction.Up)

	-- Caméra focalisée sur l'entrée sombre de la forêt pour poser l'ambiance
	GAME:MoveCamera(280, 220, 1, false)
	GROUND:AddMapStatus("clouds_overhead")

	GAME:FadeIn(60)
	SOUND:PlayBGM('Mystifying Forest.ogg', true)
	GAME:WaitFrames(40)

	-- La caméra descend pour accompagner l'entrée du duo
	local cam1 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(296, 360, 100, false)
	end)
	local walk1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(hero, 312, 320, false, 1)
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	end)
	local walk2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GeneralFunctions.EightWayMove(partner, 328, 320, false, 1)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	end)
	TASK:JoinCoroutines({cam1, walk1, walk2})
	GAME:WaitFrames(25)

	-- 2. DIALOGUE PRÉPARATOIRE DU DUO
	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A01']))
	GAME:WaitFrames(12)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A02']))
	GAME:WaitFrames(15)

	-- Pensée du héros
	GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GF6E_A03']), "Normal")
	GAME:WaitFrames(20)

	-- 3. INTERRUPTION BRUTALE : LA VOIX DE LA TEAM DAZZLING
	SOUND:FadeOutBGM(30)
	GAME:WaitFrames(10)

	-- Cri hors-champ d'Aria
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, aria.CurrentForm.Species, aria.CurrentForm.Form, aria.CurrentForm.Skin, aria.CurrentForm.Gender)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A04']))

	-- Le duo sursaute et se tourne immédiatement vers la source (gauche)
	local s1 = TASK:BranchCoroutine(function()
		GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
		pcall(function() GeneralFunctions.EmoteAndPause(partner, "Shock", false) end)
	end)
	local s2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(6)
		GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
		pcall(function() GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	end)
	TASK:JoinCoroutines({s1, s2})
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	GAME:WaitFrames(10)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A05']))
	GAME:WaitFrames(15)

	-- Deuxième et troisième voix hors-champ
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, adagio.CurrentForm.Species, adagio.CurrentForm.Form, adagio.CurrentForm.Skin, adagio.CurrentForm.Gender)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A06']))
	GAME:WaitFrames(10)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, sonata.CurrentForm.Species, sonata.CurrentForm.Form, sonata.CurrentForm.Skin, sonata.CurrentForm.Gender)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A07']))
	GAME:WaitFrames(15)

	-- 4. ENTRÉE EN SCÈNE COMIQUE ET DÉSORDONNÉE (CHAMAILLERIE)
	SOUND:PlayBGM("Team_Dazzling.ogg", true)
	GROUND:Unhide('Adagio')
	GROUND:Unhide('Aria')
	GROUND:Unhide('Sonata')

	local walkD1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(aria, 160, 300, false, 1.2)
		GROUND:CharAnimateTurnTo(aria, Direction.Right, 4)
	end)
	local walkD2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GeneralFunctions.EightWayMove(sonata, 160, 330, false, 1.1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Right, 4)
	end)
	local walkD3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GeneralFunctions.EightWayMove(adagio, 130, 270, false, 1.0)
		GROUND:CharAnimateTurnTo(adagio, Direction.Right, 4)
	end)
	local cam2 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(240, 310, 80, false)
	end)
	TASK:JoinCoroutines({walkD1, walkD2, walkD3, cam2})
	GAME:WaitFrames(12)

	-- Aria se chamaille
	UI:SetSpeaker(aria)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A08']))
	pcall(function() GeneralFunctions.Hop(aria) end)
	GAME:WaitFrames(10)

	-- Sonata râle
	UI:SetSpeaker(sonata)
	GeneralFunctions.SetEmotion("Angry")
	pcall(function() GROUND:CharSetEmote(sonata, "angry", 1) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A09']))
	GAME:WaitFrames(10)

	-- Adagio remet de l'ordre
	pcall(function() GROUND:CharTurnToCharAnimated(adagio, aria, 4) end)
	pcall(function() GROUND:CharTurnToCharAnimated(aria, adagio, 4) end)
	pcall(function() GROUND:CharTurnToCharAnimated(sonata, adagio, 4) end)
	UI:SetSpeaker(adagio)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A10']))
	pcall(function() GROUND:CharSetEmote(adagio, "determined", 1) end)
	GAME:WaitFrames(15)

	-- 5. REPRISE D'ATTITUDE FIÈRE ET DÉFILÉ DEVANT LE COMPTOIR
	-- Elles s'alignent proprement devant le duo
	local align1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(adagio, 200, 280, false, 1)
		GROUND:CharAnimateTurnTo(adagio, Direction.Right, 4)
	end)
	local align2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(6)
		GeneralFunctions.EightWayMove(aria, 220, 310, false, 1)
		GROUND:CharAnimateTurnTo(aria, Direction.Right, 4)
	end)
	local align3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		GeneralFunctions.EightWayMove(sonata, 210, 340, false, 1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Right, 4)
	end)
	local cam3 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(260, 310, 60, false)
	end)
	TASK:JoinCoroutines({align1, align2, align3, cam3})
	GAME:WaitFrames(15)

	-- Orientation relative du duo vers la meneuse Adagio
	pcall(function() GROUND:CharTurnToCharAnimated(hero, adagio, 4) end)
	pcall(function() GROUND:CharTurnToCharAnimated(partner, adagio, 4) end)

	-- Elles s'adressent au duo
	UI:SetSpeaker(adagio)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A11']))
	GAME:WaitFrames(10)

	pcall(function() GROUND:CharTurnToCharAnimated(hero, aria, 4) end)
	pcall(function() GROUND:CharTurnToCharAnimated(partner, aria, 4) end)
	UI:SetSpeaker(aria)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A12']))
	pcall(function() GeneralFunctions.Hop(aria) end)
	GAME:WaitFrames(10)

	pcall(function() GROUND:CharTurnToCharAnimated(hero, sonata, 4) end)
	pcall(function() GROUND:CharTurnToCharAnimated(partner, sonata, 4) end)
	UI:SetSpeaker(sonata)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A13']))
	pcall(function() GROUND:CharSetEmote(sonata, "glowing", 1) end)
	GAME:WaitFrames(12)

	pcall(function() GROUND:CharTurnToCharAnimated(hero, adagio, 4) end)
	pcall(function() GROUND:CharTurnToCharAnimated(partner, adagio, 4) end)
	UI:SetSpeaker(adagio)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A14']))
	GAME:WaitFrames(12)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Angry")
	pcall(function() GROUND:CharSetEmote(partner, "angry", 1) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A15']))
	GAME:WaitFrames(10)

	-- 6. DÉPART SANS PITIÉ DE LA TEAM DAZZLING
	local exitD1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(aria, 248, 220, false, 1.2)
		GeneralFunctions.EightWayMove(aria, 248, 172, false, 1.2)
		GROUND:Hide('Aria')
	end)
	local exitD2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GeneralFunctions.EightWayMove(sonata, 248, 220, false, 1.2)
		GeneralFunctions.EightWayMove(sonata, 248, 172, false, 1.2)
		GROUND:Hide('Sonata')
	end)
	local exitD3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GeneralFunctions.EightWayMove(adagio, 248, 220, false, 1.2)
		GeneralFunctions.EightWayMove(adagio, 248, 172, false, 1.2)
		GROUND:Hide('Adagio')
	end)
	local cam4 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(248, 220, 100, false)
	end)
	
	UI:SetSpeaker(aria)
	GeneralFunctions.SetEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A16']))
	
	UI:SetSpeaker(sonata)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A17']))
	
	UI:SetSpeaker(adagio)
	GeneralFunctions.SetEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A18']))

	TASK:JoinCoroutines({exitD1, exitD2, exitD3, cam4})
	GAME:WaitFrames(25)

	-- 7. LE PARTENAIRE EXPRIME SA DÉTERMINATION
	pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	GAME:MoveCamera(296, 320, 60, false)
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Angry")
	pcall(function() GROUND:CharSetEmote(partner, "angry", 1) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A19']))
	GAME:WaitFrames(15)

	GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GF6E_A20']), "Normal")
	GAME:WaitFrames(15)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	pcall(function() GROUND:CharSetEmote(partner, "determined", 1) end)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A21'], hero:GetDisplayName()))
	GAME:WaitFrames(20)

	-- Pivot final du duo face à l'entrée du donjon
	local f1 = TASK:BranchCoroutine(function()
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	end)
	local f2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(6)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	end)
	TASK:JoinCoroutines({f1, f2})
	GAME:WaitFrames(15)

	SV.Chapter6.FinishedGloomyForestIntro = true
	GAME:WaitFrames(20)
	GAME:FadeOut(false, 40)
	SOUND:FadeOutBGM(40)
	GAME:WaitFrames(40)
	
	-- Fin de la cinématique : redonner le contrôle
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:FadeIn(40)
	SOUND:PlayBGM('Mystifying Forest.ogg', true)
end

function gloomy_forest_entrance_ch_6.Butterfree_Action(chara, activator)
	if SV.Chapter6.MissionAccepted then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['GF6E_008']), "Worried")
		GeneralFunctions.EndConversation(chara)
	end
end

return gloomy_forest_entrance_ch_6
