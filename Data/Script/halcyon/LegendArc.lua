--[[
    LegendArc.lua

    LES 42 GARDIENS D'ANCRAGE — APRES-BOSS
    ================================================================
    Dernier bloc signale par tools/audit_boss_cinematics.py :

        histoire    11 scenes · 82.0/100 · 25.8 boites de boss
        reseau      11 scenes · 24.3/100 ·  3.5
        legendaire  38 scenes · 17.3/100 ·  2.0   <-- ici

    Ce qui manquait n'etait PAS l'entree en scene : chaque arene a deja son
    signal, son irruption typee, son titre et sa replique d'accroche. Il
    manquait la SORTIE. On battait Arceus, Dialga ou Rayquaza et... rien :
    `LegendZones.SetDefeated(...)`, un fondu, retour en ville. Le gardien
    posait une question avant le combat et n'y repondait jamais.

    ------------------------------------------------------------------
    LA REGLE DES ANCRAGES (docs/reseau_veilleurs_dialogues.md)
    ------------------------------------------------------------------
    Un gardien d'Ancrage n'est pas un ennemi : il TIENT une faille. Le
    combat ne le tue pas et ne le soumet pas — il le STABILISE. Le joueur
    ne prend rien : il prouve qu'il peut porter ce que l'autre portait.

    Consequence : les 42 scenes disent toutes « la garde change », mais
    aucune ne le dit de la meme facon. C'est la seule regle commune ; tout
    le reste est propre a chaque gardien.

    ------------------------------------------------------------------
    CE QUI EST REPRIS DES SOURCES
    ------------------------------------------------------------------
    * pmd-red (intro.inc) : cascade d'animations. Le gardien traverse
      Hurt -> Idle avec des temps morts au lieu de s'eteindre d'un bloc.
    * Tunnel Ardent (reference interne, 97/100) : la camera REMONTE sur
      qui parle, se RESSERRE sur la phrase-pivot, REDESCEND en cadre
      commun pour la reponse du duo. Le vaincu TRANSMET quelque chose.
    * EoSO (beach) : on laisse le lieu respirer avant de parler.

    ------------------------------------------------------------------
    PRUDENCE TECHNIQUE (leçons des lots precedents)
    ------------------------------------------------------------------
    * Positions RELUES dans chaque ground/init.lua, jamais recopiees d'un
      gabarit — l'erreur commise sur 3 fiches de VeilleurArc.
    * Cameras calculees depuis la position reelle et bornees a la taille
      de la carte, verifiee dans le .rsground correspondant.
    * Aucune animation inventee : un nom inexistant echoue EN SILENCE.
    * Texte LITTERAL (module global) — STRINGS.MapStrings ne contient que
      les cles du ground courant.
    * Jamais « Necrozma », « Eternatus », « l'Abime », « prison » dans un
      dialogue joueur. Les gardiens portant ces noms d'espece existent
      dans le casting, mais AUCUN texte affiche ne les nomme.
    * Tout sous pcall, sortie garantie.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.EngineKit'

LegendArc = {}

--Face a face natif (cf. EngineKit.lua).
local function say(who, txt)
  if who == nil then return end
  local ally = (who == CH('PLAYER') or who == CH('Teammate1'))
  EngineKit.Say(who, nil, txt, ally)
  GAME:WaitFrames(10)
end

local function narrate(txt)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(txt)
  UI:SetCenter(false)
  GAME:WaitFrames(10)
end

--------------------------------------------------------------------
-- LES 42 FICHES
--------------------------------------------------------------------
-- ground / inst / pos : RELUS dans les ground/*/init.lua (source de verite).
-- lines  : ce que dit le gardien apres le combat (2 a 3 boites).
-- ask    : la reponse du partenaire ou du duo (1 boite).
-- last   : la derniere phrase du gardien — celle qui doit rester.
-- close  : narration de sortie.
LegendArc.LIST = {

  ---------------- EAU ----------------






  ---------------- FEU ----------------



  ---------------- SOL / ROCHE / ACIER ----------------






  ---------------- ELECTRIQUE ----------------



  ---------------- PSY / ESPACE / TEMPS ----------------






  ---------------- LUMIERE / DIVIN ----------------







  ---------------- TENEBRES / SPECTRE ----------------





  ---------------- VOL / GLACE ----------------


  ---------------- PLANTE / FEE ----------------


  -- Duo joueur : ils n'ont jamais combattu serieusement. Le seul gardien
  -- qui traite l'Ancrage comme un jeu — et dont la derniere phrase revele
  -- que le jeu etait exactement le test.

}

--------------------------------------------------------------------
-- LegendArc.Victory(key)
--------------------------------------------------------------------
-- Appelee depuis zone/<zone>/init.lua juste apres LegendZones.SetDefeated.
-- Idempotente : la ceremonie ne se joue qu'UNE fois par gardien, meme si
-- le joueur revient l'affronter (revanche via Grodoudou).
--
-- Rejoue la scene sur le GROUND de la cinematique, avec les positions
-- relues dans son init.lua. Les cameras sont bornees a la carte.
function LegendArc.Victory(key)
  local f = LegendArc.LIST[key]
  if f == nil then return false end

  if SV.Anchors == nil then SV.Anchors = {} end
  if SV.Anchors.Adieux == nil then SV.Anchors.Adieux = {} end
  if SV.Anchors.Adieux[key] then return false end
  SV.Anchors.Adieux[key] = true

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end

    local g = CharacterEssentials.MakeCharactersFromList({
      { f.inst, f.pos[1], f.pos[2], Direction.Down }
    })
    pcall(function() AI:DisableCharacterAI(g) end)
    local g2 = nil
    if f.inst2 ~= nil then
      g2 = CharacterEssentials.MakeCharactersFromList({
        { f.inst2, f.pos2[1], f.pos2[2], Direction.Down }
      })
      pcall(function() AI:DisableCharacterAI(g2) end)
    end

    -- Cadrage : proche = sur le gardien, large = gardien + duo.
    local cx = f.pos[1]
    if f.pos2 ~= nil then cx = (f.pos[1] + f.pos2[1]) // 2 end
    local near = { cx, f.pos[2] + 18 }
    local wide = { cx, f.pos[2] + 48 }

    GAME:MoveCamera(wide[1], wide[2], 1, false)
    GAME:FadeIn(40)
    -- EoSO/beach : le lieu s'installe avant qu'on parle.
    GAME:WaitFrames(35)

    -- Cascade d'animations (pmd-red) : une SUITE d'etats, pas un bloc.
    pcall(function()
      GROUND:CharSetAnim(g, "Hurt", true)
      if g2 ~= nil then GROUND:CharSetAnim(g2, "Hurt", true) end
      GAME:WaitFrames(26)
      BossFX.ShakeScreen(4, 18)
      GAME:WaitFrames(16)
      GROUND:CharSetAnim(g, "Idle", true)
      if g2 ~= nil then GROUND:CharSetAnim(g2, "Idle", true) end
    end)
    GAME:WaitFrames(18)

    -- La camera remonte sur qui parle (patron du Tunnel).
    GAME:MoveCamera(near[1], near[2], 40, false)
    GAME:WaitFrames(10)

    if g2 ~= nil then
      local a, b = f.lines or {}, f.lines2 or {}
      for i = 1, math.max(#a, #b) do
        if a[i] ~= nil then say(g, a[i]) end
        if b[i] ~= nil then say(g2, b[i]) end
      end
    else
      for _, t in ipairs(f.lines or {}) do say(g, t) end
    end
    GAME:WaitFrames(12)

    -- Le duo repond : cadre commun.
    GAME:MoveCamera(wide[1], wide[2], 40, false)
    if partner ~= nil and f.ask ~= nil then
      UI:SetSpeaker(partner)
      GeneralFunctions.SetEmotion("Worried")
      UI:WaitShowDialogue(f.ask)
      GAME:WaitFrames(12)
    end

    -- La phrase qui doit rester : plan resserre.
    if f.last ~= nil then
      GAME:MoveCamera(near[1], near[2], 40, false)
      say(g, f.last)
      GAME:WaitFrames(20)
    end

    if f.close ~= nil then
      GAME:MoveCamera(wide[1], wide[2], 40, false)
      narrate(f.close)
    end
    GAME:WaitFrames(20)
  end)

  if not ok then PrintInfo('[LegendArc] scene ecourtee : '..tostring(err)) end

  pcall(function()
    UI:ResetSpeaker()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
  return true
end

return LegendArc
