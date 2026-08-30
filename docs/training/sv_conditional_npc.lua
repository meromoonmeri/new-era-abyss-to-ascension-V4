-- LABORATOIRE UNIQUEMENT — ne pas require depuis la production.
--
-- Défaut à déclarer dans scriptvars.lua avant utilisation :
-- SV.Training = SV.Training or { MetGuide = false }
--
-- Puis, dans ground/<test_map>/init.lua :
-- require 'halcyon.ground.<test_map>.sv_conditional_npc'
-- et associer training_npc.Action à l'événement Action du NPC.

require 'origin.common'

training_npc = {}

function training_npc.Action(chara, activator)
  -- `or false` garde le script compatible avec une sauvegarde créée
  -- avant l'ajout du champ MetGuide.
  if SV.Training and (SV.Training.MetGuide or false) then
    UI:SetSpeaker(chara)
    UI:WaitShowDialogue("Nous nous sommes déjà rencontrés. Le drapeau SV a survécu à la sauvegarde.")
  else
    UI:SetSpeaker(chara)
    UI:WaitShowDialogue("Bonjour. Cette première conversation active un drapeau de sauvegarde.")
    SV.Training = SV.Training or {}
    SV.Training.MetGuide = true
  end
end
