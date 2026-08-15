-- Native Pokémon life layer for rmvillage. Candidate only; no production hook.
require 'origin.common'
require 'halcyon.LivingWorld'
require 'halcyon.TownLife'
require 'halcyon.TownPlace'
require 'halcyon.TownNight'
local Life = {}
Life.SOCIAL = {
 NNV_Carpenter={role='charpentier',lines={"Je vérifie les charpentes avant que le vent se lève.","Le bois travaille différemment à chaque saison."}},
 NNV_Logger={role='bûcheron',lines={"Je ne coupe que les arbres marqués. La forêt doit pouvoir repousser.","Les sentiers sont encombrés après chaque tempête."}},
 NNV_Hunter={role='éclaireur',lines={"Je surveille les traces autour du village.","Les Pokémon sauvages changent de territoire avec les saisons."}},
 NNV_Herbalist={role='herboriste',lines={"Les plantes du sous-bois suffisent à soigner bien des blessures.","Certaines feuilles ne se récoltent qu'au lever du jour."}},
 NNV_Seamstress={role='couturière',lines={"Je répare les sacs avec des fibres de la forêt.","Le fil végétal résiste mieux quand l'air est humide."}},
}
Life.WILD={'NNV_Wild_Fletchling','NNV_Wild_Scatterbug','NNV_Wild_Caterpie','NNV_Wild_Hoppip','NNV_Wild_Oddish','NNV_Wild_Deerling'}
function Life.Setup()
 local day=TownLife.Today();local context=LivingWorld.Context('no_name_village','rmvillage')
 for name,_ in pairs(Life.SOCIAL) do local ch=CH(name);if ch then AI:SetCharacterAI(ch,'halcyon.ai.ground_default',RogueElements.Loc(ch.Position.X-32,ch.Position.Y-32),RogueElements.Loc(64,64),1,16,32,60,180) end end
 for _,name in ipairs(Life.WILD) do local ch=CH(name);if ch then AI:SetCharacterAI(ch,'halcyon.ai.ground_default',RogueElements.Loc(ch.Position.X-48,ch.Position.Y-48),RogueElements.Loc(96,96),1,16,40,40,140) end end
 return {day=day,context=context}
end
function Life.Talk(name)
 local cfg=Life.SOCIAL[name];local ch=CH(name);if not cfg or not ch then return false end
 local line=cfg.lines[(TownLife.Today()%#cfg.lines)+1]
 UI:SetSpeaker(ch);UI:WaitShowDialogue(line);return true
end
function Life.WildTalk(name)
 local ch=CH(name);if not ch then return false end
 UI:SetSpeaker(ch);UI:WaitShowDialogue("Le Pokémon sauvage vous observe, puis reprend son activité.");return true
end
return Life
