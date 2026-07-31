--[[
    guild_second_floor_ch_6.lua
    Chapitre 6 : Vie de guilde (Le Réveil de Metano)
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_second_floor_ch_6 = {}

function guild_second_floor_ch_6.SetupGround()
  local npcs = CharacterEssentials.MakeCharactersFromList({
    {"Chimecho", 184, 152, Direction.Down},
    {"Marowak",  328, 168, Direction.Left},
    {"Sunflora", 216, 216, Direction.Right}
  })

  for _, c in ipairs(npcs) do
    GAME:GetCurrentGround():AddTempChar(c)
  end
end

function guild_second_floor_ch_6.Chimecho_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "Le dîner sera prêt à l'heure ce soir ![pause=15] J'espère que l'inspection dans la Forêt Lugubre se passera sans encombre.", "Happy")
  UI:WaitShowDialogue("Faites attention à Zarude...[pause=15] Il n'aime pas qu'on s'aventure trop loin sous les arbres.")
  GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_6.Marowak_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "L'entraînement au Dojo porte ses fruits.[pause=15] J'ai vu une équipe extérieure s'entraîner dur ce matin...", "Normal")
  UI:WaitShowDialogue("Elles se font appeler la Team Dazzling.[pause=15] Ne vous laissez pas impressionner par leurs manières.")
  GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_6.Sunflora_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "Oh là là ![pause=15] Quel soulagement d'être de retour au frais à la guilde !", "Happy")
  GeneralFunctions.EndConversation(chara)
end

return guild_second_floor_ch_6
