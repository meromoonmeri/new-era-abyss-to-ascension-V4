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
	--
	-- CORRECTIF 2026-08-04 — trois ArgumentException dans le log de jeu :
	--     ScriptGround.Hide(Adagio): Couldn't find entity to hide!
	--     ScriptGround.Hide(Aria)  : ...
	--     ScriptGround.Hide(Sonata): ...
	--
	-- CAUSE : Adagio, Aria et Sonata n'existent PAS sur la carte au repos.
	-- Le .rsground ne déclare que TEAMMATE_1/2/3 (Spawners), trois
	-- marqueurs et Dungeon_Entrance. Le trio est créé À L'EXÉCUTION par
	-- CharacterEssentials.MakeCharactersFromList, uniquement dans
	-- ArrivalCutscene. Hors cinématique il n'y a donc rien à masquer.
	--
	-- Le pcall englobant ne supprimait pas le bruit : ScriptGround.Hide
	-- (Lua/ScriptGround.cs:29-40) attrape lui-même son exception et la
	-- passe à DiagManager.LogError. Elle est journalisée AVANT que Lua
	-- puisse la voir — pcall n'a jamais rien à rattraper.
	--
	-- Second effet du pcall unique : il masquait un vrai défaut. Les trois
	-- appels étaient dans le MÊME pcall, donc l'échec du premier sautait
	-- les deux autres. Si un jour le trio existe vraiment, seul Adagio
	-- aurait été masqué, Aria et Sonata seraient restés visibles.
	--
	-- On ne masque donc que ce qui existe. FindEntity est la méthode que
	-- Hide utilise lui-même (l.31) ; GROUND:CharSetEmote et GROUND:Hide
	-- sont déjà employés partout dans le mod, mais aucun test d'existence
	-- ne l'était : on passe par le ground courant, sans inventer d'API.
	for _, nom in ipairs({'Adagio', 'Aria', 'Sonata'}) do
		local present = false
		pcall(function()
			present = (GAME:GetCurrentGround():FindEntity(nom) ~= nil)
		end)
		if present then pcall(function() GROUND:Hide(nom) end) end
	end
end

function gloomy_forest_entrance_ch_6.ArrivalCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	-- 1. INITIALISATION DE LA SCÈNE (SOUS LE NOIR)
	pcall(function() GAME:FadeOut(false, 1) end)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)

	-- Spawners de la Team Dazzling (créées masquées pour l'introduction)
	-- Depart du trio : bord gauche du plateau, hors du champ de la camera
	-- d'ouverture (centree en 280,220 puis 296,360). Les positions d'origine
	-- (40,280 / 20,300 / 40,320) tombaient dans une poche libre mais ISOLEE
	-- du plateau : la marche vers le duo etait impossible, les trois PNJ
	-- restaient plantes sur place.
	local adagio, aria, sonata = CharacterEssentials.MakeCharactersFromList({
		{'Adagio', 120, 136, Direction.Right},
		{'Aria', 96, 136, Direction.Right},
		{'Sonata', 72, 136, Direction.Right}
	})
	GROUND:Hide('Adagio')
	GROUND:Hide('Aria')
	GROUND:Hide('Sonata')

	-- Positionnement d'ouverture du duo
	-- (328,480) mettait le partenaire a cheval sur un mur (2 des 4 cases de
	-- 8 px a Tags=1) : sprite encastre et depart de marche incertain.
	GROUND:TeleportTo(hero, 56, 168, Direction.Right)
	GROUND:TeleportTo(partner, 56, 184, Direction.Right)

	-- Caméra focalisée sur l'entrée sombre de la forêt pour poser l'ambiance
	GAME:MoveCamera(120, 168, 1, false)
	--Protege : GetMapStatus (DataManager.cs:1302) AVALE l'exception et
	--renvoie null, puis MapStatus.LoadFromData (Maps/MapStatus.cs:44)
	--dereference entry.StatusStates -> NullReferenceException qui tue la
	--fonction appelante AVANT son FadeIn. C'est la cause de l'ecran noir
	--constate en jeu. Le MapStatus existe desormais, le pcall reste en
	--garde-fou : un ID absent ne doit jamais pouvoir noircir l'ecran.
	pcall(function() GROUND:AddMapStatus("clouds_overhead") end)

	GAME:FadeIn(60)
	SOUND:PlayBGM('Mystifying Forest.ogg', true)
	GAME:WaitFrames(40)

	-- La caméra descend pour accompagner l'entrée du duo
	local cam1 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(200, 168, 100, false)
	end)
	local walk1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(hero, 200, 168, false, 1)
		GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
	end)
	local walk2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GeneralFunctions.EightWayMove(partner, 200, 184, false, 1)
		GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
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
		GeneralFunctions.EightWayMove(aria, 240, 152, false, 1.2)
		GROUND:CharAnimateTurnTo(aria, Direction.Right, 4)
	end)
	local walkD2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GeneralFunctions.EightWayMove(sonata, 240, 176, false, 1.1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Right, 4)
	end)
	local walkD3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GeneralFunctions.EightWayMove(adagio, 216, 136, false, 1.0)
		GROUND:CharAnimateTurnTo(adagio, Direction.Right, 4)
	end)
	local cam2 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(220, 164, 80, false)
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
		GeneralFunctions.EightWayMove(adagio, 256, 152, false, 1)
		GROUND:CharAnimateTurnTo(adagio, Direction.Right, 4)
	end)
	local align2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(6)
		GeneralFunctions.EightWayMove(aria, 256, 168, false, 1)
		GROUND:CharAnimateTurnTo(aria, Direction.Right, 4)
	end)
	local align3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		GeneralFunctions.EightWayMove(sonata, 256, 184, false, 1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Right, 4)
	end)
	local cam3 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(230, 168, 60, false)
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
		GeneralFunctions.EightWayMove(aria, 400, 160, false, 1.2)
		GeneralFunctions.EightWayMove(aria, 496, 160, false, 1.2)
		GROUND:Hide('Aria')
	end)
	local exitD2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GeneralFunctions.EightWayMove(sonata, 400, 160, false, 1.2)
		GeneralFunctions.EightWayMove(sonata, 496, 160, false, 1.2)
		GROUND:Hide('Sonata')
	end)
	local exitD3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GeneralFunctions.EightWayMove(adagio, 400, 160, false, 1.2)
		GeneralFunctions.EightWayMove(adagio, 496, 160, false, 1.2)
		GROUND:Hide('Adagio')
	end)
	local cam4 = TASK:BranchCoroutine(function()
		GAME:MoveCamera(360, 164, 100, false)
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
	-- Recadrage 2026-08-02 : (296,320) datait de la carte 600x600 et
	-- tombait sous le bord inferieur de la nouvelle (600x312). La camera
	-- revient desormais sur le duo, reste au centre de la clairiere.
	GAME:MoveCamera(216, 172, 60, false)
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

	-- 8. LA GROTTE LES A AVALES — nouveau beat (2026-08-02).
	-- La Team Dazzling part desormais VERS l'est, c'est-a-dire DANS le
	-- donjon. On ne peut pas les laisser disparaitre hors champ sans que
	-- le duo en tire la consequence : ils sont devant, on court derriere.
	-- Ce beat sert de charniere vers le gameplay : il amene physiquement
	-- le duo au seuil, la ou le joueur reprendra la main.
	-- La camera suit le trio jusqu'a la bouche de la grotte : ce que la
	-- boite de narration decrivait, le cadrage le MONTRE. Le guide des
	-- cutscenes proscrit la narration en cours de scene (section 4) ;
	-- GF6E_A22 devient donc la replique du partenaire, qui constate.
	GAME:MoveCamera(480, 160, 70, false)
	GAME:WaitFrames(25)
	SOUND:PlayBattleSE("EVT_Emote_Startled_2")
	pcall(function() GROUND:CharAnimateTurnTo(hero, Direction.Right, 5) end)
	GAME:WaitFrames(6)
	pcall(function() GROUND:CharAnimateTurnTo(partner, Direction.Right, 5) end)
	pcall(function() GeneralFunctions.EmoteAndPause(partner, "Shock", false) end)
	GAME:WaitFrames(18)
	UI:SetSpeaker(partner)
	-- "Shock" est une EMOTE DE BULLE (EmoteAndPause, ligne au-dessus),
	-- pas une emotion de portrait : SetEmotion l'aurait fait planter en
	-- boucle a chaque frame (meme classe de bug que le correctif 7715486,
	-- Shock -> Surprised sur autel_celeste).
	GeneralFunctions.SetEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A22']))
	GAME:WaitFrames(15)

	-- Le duo remonte la clairiere vers la grotte, en deux temps.
	local avance1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(hero, 320, 168, false, 1)
	end)
	local avance2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GeneralFunctions.EightWayMove(partner, 320, 184, false, 1)
	end)
	local camAvance = TASK:BranchCoroutine(function()
		GAME:MoveCamera(360, 168, 90, false)
	end)
	TASK:JoinCoroutines({avance1, avance2, camAvance})
	GAME:WaitFrames(15)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A23']))
	GAME:WaitFrames(12)

	GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GF6E_A24']), "Worried")
	GAME:WaitFrames(15)

	UI:SetSpeaker(partner)
	GeneralFunctions.SetEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6E_A25']))
	GAME:WaitFrames(18)

	-- Derniers pas jusqu'au seuil : le joueur reprendra la main ici.
	local seuil1 = TASK:BranchCoroutine(function()
		GeneralFunctions.EightWayMove(hero, 440, 160, false, 1)
		GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
	end)
	local seuil2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GeneralFunctions.EightWayMove(partner, 440, 176, false, 1)
		GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	end)
	TASK:JoinCoroutines({seuil1, seuil2})
	GAME:WaitFrames(20)

	-- Pivot final du duo face à l'entrée du donjon
	local f1 = TASK:BranchCoroutine(function()
		GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
	end)
	local f2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(6)
		GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
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
