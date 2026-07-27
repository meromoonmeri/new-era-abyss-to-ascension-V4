require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

altere_pond_ch_5 = {}

function altere_pond_ch_5.SetupGround()
	--prevent player from going into relic forest before the expedition
	local forestBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
						RogueElements.Rect(904, 256, 8, 88),
						RogueElements.Loc(0, 0), 
						true, 
						"Event_Trigger_1")
																					
	forestBlock:ReloadEvents()

	GAME:GetCurrentGround():AddTempObject(forestBlock)
		
	GAME:FadeIn(20)
end

--Vieux Relicanth du lac : memoire vivante d'Altere, ton lent et sentencieux
function altere_pond_ch_5.Relicanth_Action(chara, activator)
	if SV.Chapter5.FinishedExpedition then
		GeneralFunctions.StartConversation(chara, "Mmm...[pause=0] Vous revoilà.[pause=0] L'étang m'a parlé de votre montagne bien avant votre retour.", "Normal", true, false)
		UI:WaitShowDialogue("L'eau descend des sommets,[pause=10] voyez-vous.[pause=0] Elle porte les nouvelles plus vite que les Roucool.")
		UI:WaitShowDialogue("Et ces temps-ci...[pause=0] l'eau qui descend du nord a un goût étrange.[pause=0] Un goût de lumière inquiète.[pause=0] Mmm.[pause=0] Vous savez de quoi je parle,[pause=10] je crois.")
	elseif SV.Chapter5.ReadyForExpedition or SV.Chapter5.FinishedExpeditionAddress then
		GeneralFunctions.StartConversation(chara, "Mmm...[pause=0] Une expédition vers le nord.[pause=0] J'ai vu partir la dernière,[pause=10] il y a bien longtemps.", "Normal", true, false)
		UI:WaitShowDialogue("Je nageais déjà dans cet étang quand vos grands-parents apprenaient à marcher.[pause=0] Mmm.[pause=0] Les jeunes partent toujours vers le nord.[pause=0] Les sages reviennent toujours par le sud.")
		UI:WaitShowDialogue("...Ne me demandez pas ce que ça signifie.[pause=0] À mon âge,[pause=10] on dit les choses,[pause=10] et c'est aux jeunes de les comprendre.")
	else
		GeneralFunctions.StartConversation(chara, "Mmm...[pause=0] L'étang est calme aujourd'hui.[pause=0] Trop calme.[pause=0] Même les Magicarpe se taisent.", "Normal", true, false)
		UI:WaitShowDialogue("Quand les Magicarpe se taisent,[pause=10] c'est que le monde retient son souffle.[pause=0] Mmm.[pause=0] Ou qu'ils dorment.[pause=0] C'est l'un ou l'autre.")
	end
	GeneralFunctions.EndConversation(chara, false)
end 


function altere_pond_ch_5.Event_Trigger_1_Touch(obj, activator)
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")

	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	
	GeneralFunctions.StartPartnerConversation(STRINGS:Format(STRINGS.MapStrings['AP5_004'], zone:GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP5_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP5_002']))
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['AP5_003'], hero:GetDisplayName()))
	GeneralFunctions.EndConversation(partner)

end
