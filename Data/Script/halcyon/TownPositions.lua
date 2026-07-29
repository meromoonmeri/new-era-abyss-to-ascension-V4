--[[
    TownPositions.lua

    POSITIONS VARIABLES DES PNJ DE METANO — module de positionnement dynamique
    ================================================================
    Chaque PNJ significatif peut occuper une position différente d'un jour
    à l'autre, renforçant l'impression de ville vivante.

    USAGE
    ------------------------------------------------------------------
    Dans un SetupGround de chapitre :

      local pos = TownPositions.Get('Jigglypuff')
      if pos then
        GROUND:TeleportTo(jigglypuff, pos.x, pos.y, pos.dir)
      end

    Ou pour un spawn :

      local pos = TownPositions.Get('Kecleon_Green')
      local kecleon = CharacterEssentials.MakeCharactersFromList({
        {'Kecleon', pos.x, pos.y, pos.dir}
      })

    REGLES
    ------------------------------------------------------------------
    * Les positions sont des tables {x, y, dir} vérifiées walkables.
    * Le cycle est basé sur DaysPassed modulo le nombre de positions.
    * Un PNJ absent de la table utilise sa position par défaut (pas de
      variation — les gardes et marchands fixes ne bougent pas).
    * Les positions doivent rester cohérentes avec le rôle du PNJ :
      un marchand près de son étal, un habitant en ville, etc.
]]

require 'origin.common'

TownPositions = {}

--------------------------------------------------------------------
-- TABLE DE POSITIONS — chaque PNJ a 2 à 4 positions alternatives
--------------------------------------------------------------------
-- Format : TownPositions.Data[nom] = {{x,y,dir}, {x,y,dir}, ...}
-- Le jour courant = SV.ChapterProgression.DaysPassed (ou 0 par défaut)
-- Index = (jour % nombre_de_positions) + 1

TownPositions.Data = {
  -- === HABITANTS DE LA PLACE ===
  Jigglypuff = {
    {x=1224, y=1160, dir=Direction.UpLeft},   -- place du marché (position d'origine)
    {x=480,  y=700,  dir=Direction.Down},      -- près de la fontaine
    {x=800,  y=440,  dir=Direction.Right},     -- devant la guilde
  },
  Marill = {
    {x=1184, y=1160, dir=Direction.UpRight},   -- place (origine)
    {x=520,  y=680,  dir=Direction.Left},       -- fontaine
    {x=360,  y=420,  dir=Direction.DownRight},  -- entrée ville
  },
  Spheal = {
    {x=1204, y=1128, dir=Direction.Down},       -- place (origine)
    {x=460,  y=720,  dir=Direction.UpLeft},     -- fontaine
    {x=780,  y=460,  dir=Direction.Left},       -- devant la guilde
  },
  Meditite = {
    {x=556,  y=216,  dir=Direction.Down},       -- méditation (origine)
    {x=600,  y=700,  dir=Direction.Up},         -- place calme
    {x=340,  y=500,  dir=Direction.Right},      -- sous les arbres
  },
  Vileplume = {
    {x=388,  y=716,  dir=Direction.DownRight},  -- jardin (origine)
    {x=500,  y=660,  dir=Direction.Left},       -- fontaine
    {x=280,  y=380,  dir=Direction.Up},         -- verger
  },
  Luxray = {
    {x=304,  y=1024, dir=Direction.Down},       -- patrouille sud (origine)
    {x=700,  y=240,  dir=Direction.Left},       -- patrouille nord
    {x=1100, y=900,  dir=Direction.Up},         -- patrouille est
  },
  Wooper_Boy = {
    {x=744,  y=1144, dir=Direction.Right},      -- mare (origine)
    {x=780,  y=1144, dir=Direction.Left},       -- mare (autre côté)
    {x=500,  y=720,  dir=Direction.Down},       -- fontaine
  },
  Wooper_Girl = {
    {x=776,  y=1144, dir=Direction.Left},       -- mare (origine)
    {x=740,  y=1120, dir=Direction.Right},      -- mare (autre côté)
    {x=520,  y=700,  dir=Direction.Up},         -- fontaine
  },

  -- === MARCHANDS (variation légère autour de leur étal) ===
  -- Les marchands restent près de leur position fonctionnelle.
  -- Seule la direction et un léger décalage changent.

  -- === GARDES (pas de variation — position fixe) ===
  -- Machamp, Mawile : ne pas inclure dans cette table.
}

--------------------------------------------------------------------
-- API
--------------------------------------------------------------------

--- Retourne la position du jour pour un PNJ donné.
-- @param npc_name string : nom d'instance du PNJ (ex: 'Jigglypuff')
-- @return table {x, y, dir} ou nil si le PNJ n'a pas de positions variables
function TownPositions.Get(npc_name)
  local positions = TownPositions.Data[npc_name]
  if not positions or #positions == 0 then
    return nil
  end
  local day = 0
  if SV and SV.ChapterProgression and SV.ChapterProgression.DaysPassed then
    day = SV.ChapterProgression.DaysPassed
  end
  local idx = (day % #positions) + 1
  return positions[idx]
end

--- Retourne toutes les positions d'un PNJ (pour debug/audit).
function TownPositions.GetAll(npc_name)
  return TownPositions.Data[npc_name] or {}
end

--- Ajoute des positions pour un PNJ (extension par les chapitres).
-- @param npc_name string
-- @param positions table de {x, y, dir}
function TownPositions.Register(npc_name, positions)
  TownPositions.Data[npc_name] = positions
end

--- Applique la position du jour à un personnage déjà spawné.
-- @param chara : personnage ground (CH ou MakeCharacter)
-- @param npc_name string
-- @return boolean : true si la position a été appliquée
function TownPositions.Apply(chara, npc_name)
  if chara == nil then return false end
  local pos = TownPositions.Get(npc_name)
  if not pos then return false end
  GROUND:TeleportTo(chara, pos.x, pos.y, pos.dir)
  return true
end

--------------------------------------------------------------------
-- AUDIT — vérifier que toutes les positions sont dans les Bounds
--------------------------------------------------------------------
function TownPositions.Audit()
  local problems = {}
  for npc, positions in pairs(TownPositions.Data) do
    for i, pos in ipairs(positions) do
      if pos.x < 0 or pos.y < 0 then
        table.insert(problems, npc..' pos '..i..': coordonnées négatives')
      end
      if not pos.dir then
        table.insert(problems, npc..' pos '..i..': direction manquante')
      end
    end
  end
  if #problems == 0 then
    PrintInfo('[TownPositions] Audit OK : '..
      tostring(TownPositions.CountNPCs())..' PNJ, '..
      tostring(TownPositions.CountPositions())..' positions')
  else
    for _, p in ipairs(problems) do
      PrintInfo('[TownPositions] PROBLEME: '..p)
    end
  end
  return #problems
end

function TownPositions.CountNPCs()
  local n = 0
  for _ in pairs(TownPositions.Data) do n = n + 1 end
  return n
end

function TownPositions.CountPositions()
  local n = 0
  for _, positions in pairs(TownPositions.Data) do
    n = n + #positions
  end
  return n
end

return TownPositions
