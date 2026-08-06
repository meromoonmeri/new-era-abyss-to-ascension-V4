require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

local foret_givree_fond = {}
local MapStrings = ""

function foret_givree_fond.Init(map)
  DEBUG.EnableDbgCoro()
  MapStrings = COMMON.AutoLoadLocalizedStrings()
end

function foret_givree_fond.Enter(map)
  if SV.chapter12.ArticunoDefeated == false then
    -- We assume the boss fight is handled by entering the floor as an Area or similar, 
    -- but if it's a map boss:
    foret_givree_fond.PlayBossIntro()
  else
    if SV.chapter12.AbsolRecruited == false then
      foret_givree_fond.PlayPostBossScene()
    end
  end
end

function foret_givree_fond.PlayPostBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local articuno = CH('Boss_Marker') -- Assuming Articuno is spawned here or spawned dynamically
  if articuno == nil then
      articuno = CharacterEssentials.MakeCharactersFromList({
          {"Articuno", 160, 160, Direction.Down}
      })[1]
  end

  local absol = CharacterEssentials.MakeCharactersFromList({
      {"Absol", 160, 200, Direction.Up}
  })[1]
  
  GAME:CutsceneMode(true)
  GROUND:CharSetAnim(articuno, "Pain", true)
  
  UI:SetSpeaker(articuno)
  -- In a real environment, we'd use MapStrings. We use explicit for the proof.
  UI:WaitShowDialogue("Ggrr...[pause=15] Mortels insolents...[pause=20] Mon gel éternel aurait dû vous purifier !")
  
  UI:SetSpeaker(absol)
  UI:WaitShowDialogue("Assez, Artikodin.[pause=20] Ces enfants ne portent pas la souillure de la brume.")
  
  UI:SetSpeaker(articuno)
  UI:WaitShowDialogue("Absol...?[pause=15] Toi, le messager des catastrophes, tu prends leur défense ?")
  
  UI:SetSpeaker(absol)
  UI:WaitShowDialogue("Je ressens les battements de la terre depuis des siècles.[pause=20] Eux ne provoquent pas les séismes... Ils les traquent.")
  UI:WaitShowDialogue("Laisse-les passer.[pause=15] Le temps presse pour nous tous.")
  
  -- Artikodin s'envole dans un cri de blizzard
  SOUND:PlayBattleSE("EVT_Roar") -- Replacement for DUN_Fly in PMDO native
  GAME:FadeOut(false, 30)
  GROUND:Hide('Articuno')
  GAME:FadeIn(30)
  
  -- Absol se tourne vers le joueur
  GROUND:EntTurn(absol, Direction.Right)
  
  UI:SetSpeaker(absol)
  UI:WaitShowDialogue("Vous fuyez la vallée, je le sais.[pause=20] La Fédération a les yeux aveuglés par la panique.")
  UI:WaitShowDialogue("Je m'appelle Absol.[pause=15] Je connais le chemin secret vers le sommet du Mont Gel.")
  UI:WaitShowDialogue("Permettez-moi de vous guider.[pause=20] Ma lame et mon flair sont à votre service.")
  
  -- Recrutement officiel d'Absol
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  SOUND:PlayBattleSE("DUN_Level_Up")
  UI:WaitShowDialogue("Absol rejoint votre équipe de secours légendaire !")
  UI:SetCenter(false)
  
  SV.chapter12.AbsolRecruited = true
  GAME:CutsceneMode(false)
  
  -- Transition to next map (Fugitive Road)
  GAME:EnterGroundMap("mont_gel_entree", "Main_Entrance_Marker")
end

return foret_givree_fond
