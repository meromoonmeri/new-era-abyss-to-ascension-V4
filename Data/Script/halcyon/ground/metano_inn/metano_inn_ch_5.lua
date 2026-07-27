require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_inn_ch_5 = {}

function metano_inn_ch_5.SetupGround()
	local corvisquire, nidoqueen, nidoran_m, nidoking = 
		CharacterEssentials.MakeCharactersFromList({
			{'Corvisquire', 152, 200, Direction.UpLeft},
			{'Nidoqueen', 'Innkeeper_Right'},--Nidoqueen's spot 
			{'Nidoran_M', 240, 128, Direction.DownRight},
			{'Nidoking', 'Innkeeper_Left'}--Nidoking's spot
		})
	
	AI:SetCharacterAI(corvisquire, "halcyon.ai.ground_default", RogueElements.Loc(136, 184), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)
	AI:SetCharacterAI(nidoran_m, "halcyon.ai.ground_default", RogueElements.Loc(224, 112), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)

	GAME:FadeIn(20)
end

--Cory cracking lame jokes
function metano_inn_ch_5.Passerby_1_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "On dirait que toute la ville CROÂ-sse au sujet de l'expédition de la guilde.", "Happy")
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI5_001']))
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI5_002']))
	--GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI5_003']))
	GeneralFunctions.EndConversation(chara)
	--The whole town seems extra busy today! What's everyone CROWING about?
	--Hmm, looks like nobody's INN
	--proceed with caw tion on the expedition
	--Hope they find something pretty FLY!
	--Birds of a feather?
	--They seem talon-ted
end



function metano_inn_ch_5.Nidoran_M_Action(chara, activator)
	if SV.Chapter5.FinishedExpedition then
		GeneralFunctions.StartConversation(chara, "Bref ![pause=0] J'ai vu passer le cortège du retour.[pause=0] Bref,[pause=10] vous étiez couverts de poussière.[pause=0] Bref,[pause=10] c'était magnifique.", "Inspired")
		UI:WaitShowDialogue("Un jour je raconterai que je vous ai parlé.[pause=0] Ici même.[pause=0] Bref.[pause=0] Historique.")
	elseif SV.Chapter5.ReadyForExpedition or SV.Chapter5.FinishedExpeditionAddress then
		GeneralFunctions.StartConversation(chara, "Bref ![pause=0] Il paraît que vous partez au nord.[pause=0] Bref,[pause=10] c'est loin.[pause=0] Bref,[pause=10] bonne chance.", "Normal")
		UI:WaitShowDialogue("Moi,[pause=10] le plus loin où je suis allé,[pause=10] c'est la rivière.[pause=0] Bref.[pause=0] Chacun son rythme.")
	else
		GeneralFunctions.StartConversation(chara, "Bref ![pause=0] Je séjourne ici en attendant que le café rouvre une table.[pause=0] Bref,[pause=10] c'est complet partout.[pause=0] Bref,[pause=10] la ville bouge trop en ce moment.", "Normal")
	end
	GeneralFunctions.EndConversation(chara)
end


function metano_inn_ch_5.Innkeeper_Desk_Right_Action(chara, activator) 
	local nidoqueen = CH('Nidoqueen')
	GeneralFunctions.StartConversation(nidoqueen, "Je commence à m'inquiéter pour mon petit dernier.", "Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI5_004']))
	GeneralFunctions.EndConversation(nidoqueen)
end

function metano_inn_ch_5.Innkeeper_Desk_Left_Action(chara, activator) 
	local nidoking = CH('Nidoking')
	GeneralFunctions.StartConversation(nidoking, "Les affaires sont un peu calmes ces derniers temps...[pause=0] On ne reçoit qu'un ou deux clients par jour !", "Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MI5_005']))
	GeneralFunctions.EndConversation(nidoking)	
end
