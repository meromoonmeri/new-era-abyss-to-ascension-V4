local Voices=require 'halcyon.no_name_village.PokemonVoices';local B={}
B.Roster={objbmob0={species='ursaluna',title='Gardien de la lisière',level=42},objbmobsm={species='volcarona',title='Cœur de l’été',level=44},objbmobau={species='trevenant',title='Sire de l’automne',level=46},objbmobwn2={species='baxcalibur',title='Crocs de l’hiver',level=48},objbmobwn={species='froslass',title='Dame du blizzard',level=47},objbmoben={species='darkrai',title='Ombre sans nom',level=50},objboss={species='darkrai',title='Contrôleur de confrontation',level=50}}
local K={ursaluna='Ursaluna',volcarona='Volcarona',trevenant='Trevenant',froslass='Froslass',baxcalibur='Baxcalibur',darkrai='Darkrai'}
function B.Get(prefix)return B.Roster[prefix]end
function B.Talk(chara,prefix)local r=B.Get(prefix);if not r then return false end;local lines=Voices.Bosses[K[r.species]];if not lines then return false end;UI:SetSpeaker(chara);for _,line in ipairs(lines)do UI:WaitShowDialogue(line)end;return true end
return B
