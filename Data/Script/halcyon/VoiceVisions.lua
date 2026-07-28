--[[
    VoiceVisions.lua

    LA VOIX ET LES VISIONS DU HEROS
    ================================================================
    Reprend le dispositif des jeux officiels :

      * PMD Rouge/Bleu — le heros fait des reves ou une voix lui parle
        directement, sans que personne d'autre ne l'entende.
      * PMD Ciel — quand le heros touche un objet ou un lieu charge, il est
        pris d'un vertige et voit un fragment d'un autre temps. Le partenaire
        le voit vaciller mais ne voit RIEN de la vision.

    Deux briques, utilisables partout :

      VoiceVisions.Speak{...}   la Voix parle au heros SEUL, avec nausee.
      VoiceVisions.Play{...}    une vision du passe, en planches.

    ------------------------------------------------------------------
    REGLE NARRATIVE — le heros est le seul a entendre
    ------------------------------------------------------------------
    C'est le coeur du dispositif. A chaque fois que la Voix parle :

      1. le monde se fige (BGM coupee net, ecran qui se voile) ;
      2. le heros a un haut-le-coeur — recul, tremblement d'ecran, l'ecran
         tangue (ScreenMover), emote de choc ;
      3. la Voix parle, speaker ANONYME (\uE040), aucun nom, aucun portrait ;
      4. le monde revient, et le partenaire n'a rien entendu. Il a seulement
         vu son ami s'arreter net et blemir.

    La 4e etape est la plus importante : c'est elle qui rend le heros seul.
    Le parametre `witness` permet de faire reagir un temoin — il s'inquiete
    de la PALEUR du heros, jamais de ce qui a ete dit.

    ------------------------------------------------------------------
    REGLES DU PROJET RESPECTEES
    ------------------------------------------------------------------
    * La Voix reste ANONYME. Jamais de nom dans le speaker.
    * Aucun nom interdit dans les textes appelants (verifie par
      tools/verify_no_forbidden_names.py).
    * Les visions montrent le PASSE d'un autre monde. Le heros ne comprend
      pas ce qu'il voit — c'est au joueur de reconnaitre.
    * Tout est sous pcall : une vision qui casse ne doit jamais bloquer le
      joueur sur une carte sans sortie.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

VoiceVisions = {}

--------------------------------------------------------------------
-- Resolution d'un texte.
--------------------------------------------------------------------
-- Deux usages coexistent dans le projet :
--   * appel depuis UN ground -> on passe des cles resx (STRINGS.MapStrings) ;
--   * appel depuis un MODULE GLOBAL -> on passe le texte en clair, car
--     STRINGS.MapStrings ne contient que les cles du ground courant et une
--     cle definie ailleurs serait introuvable (patron de SuaireArc.lua).
-- `literal = true` bascule sur le second mode.
local function resolve(cfg, txt)
  if txt == nil then return nil end
  if cfg.literal then return STRINGS:Format(txt) end
  local ms = cfg.strings or STRINGS.MapStrings
  return STRINGS:Format(ms[txt])
end

--------------------------------------------------------------------
-- Intensite de la nausee. 1 = gene passagere, 3 = le heros s'effondre.
--------------------------------------------------------------------
local NAUSEA = {
  [1] = { shake = 3,  frames = 20, fade = 15, recoil = false },
  [2] = { shake = 6,  frames = 34, fade = 25, recoil = true  },
  [3] = { shake = 10, frames = 50, fade = 40, recoil = true  },
}

--Le malaise physique. Extrait a part : les visions le reutilisent.
--`level` 1..3, `chara` le heros.
function VoiceVisions.Nausea(chara, level)
  local cfg = NAUSEA[level or 2] or NAUSEA[2]
  pcall(function()
    SOUND:PlayBattleSE('EVT_Emote_Startled')
    if chara ~= nil then
      GROUND:CharSetEmote(chara, "shock", 1)
      if cfg.recoil then
        GROUND:CharSetAnim(chara, "Hurt", true)
      end
    end
    --L'ecran tangue : c'est le vertige, pas un tremblement de terre.
    --Amplitude faible mais longue, contrairement a BossFX.ShakeScreen.
    GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, cfg.shake, cfg.frames))
    GAME:WaitFrames(cfg.frames)
  end)
end

--Retour au calme apres un malaise.
function VoiceVisions.Recover(chara)
  pcall(function()
    if chara ~= nil then
      GROUND:CharSetEmote(chara, "", 0)
      GROUND:CharSetAnim(chara, "Idle", true)
    end
  end)
end

--------------------------------------------------------------------
-- VoiceVisions.Speak — la Voix s'adresse au heros, lui seul l'entend.
--------------------------------------------------------------------
--  cfg = {
--    lines   = {'CLE_001', 'CLE_002'},  -- cles resx, dans l'ordre
--    strings = STRINGS.MapStrings,      -- table de cles (defaut MapStrings)
--    level   = 2,                       -- intensite de la nausee (1..3)
--    music   = true,                    -- couper puis rendre la BGM
--    witness = partner,                 -- temoin inquiet (optionnel)
--    witnessLines = {'CLE_003'},        -- ce que dit le temoin apres coup
--    heroLine = 'CLE_004',              -- pensee du heros apres coup
--  }
function VoiceVisions.Speak(cfg)
  local hero = CH('PLAYER')
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if cfg.witness ~= nil then AI:DisableCharacterAI(cfg.witness) end

    --1. Le monde se fige.
    if cfg.music ~= false then SOUND:FadeOutBGM(20) end
    GAME:WaitFrames(10)

    --2. Le haut-le-coeur.
    VoiceVisions.Nausea(hero, cfg.level)

    --Voile sombre : le heros ne voit plus tres bien.
    local center = GAME:GetCameraCenter()
    local veil = RogueEssence.Content.FlashEmitter()
    veil.FadeInTime = 6; veil.HoldTime = 10; veil.FadeOutTime = 30
    veil.StartColor = Color(20, 10, 40, 0)
    veil.Layer = DrawLayer.Top
    veil.Anim = RogueEssence.Content.BGAnimData("White", 0)
    GROUND:PlayVFX(veil, center.X, center.Y)
    GAME:WaitFrames(16)

    --3. La Voix. Speaker anonyme : ni nom, ni espece, ni portrait.
    UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
    for _, key in ipairs(cfg.lines or {}) do
      UI:WaitShowDialogue(resolve(cfg, key))
      GAME:WaitFrames(10)
    end

    --4. Retour au monde.
    GAME:WaitFrames(20)
    VoiceVisions.Recover(hero)

    if cfg.heroLine ~= nil then
      GeneralFunctions.HeroDialogue(hero, resolve(cfg, cfg.heroLine), "Worried")
    end

    --Le temoin n'a RIEN entendu. Il a vu son ami blemir, c'est tout.
    if cfg.witness ~= nil and cfg.witnessLines ~= nil then
      UI:SetSpeaker(cfg.witness)
      UI:SetSpeakerEmotion("Worried")
      for _, key in ipairs(cfg.witnessLines) do
        UI:WaitShowDialogue(resolve(cfg, key))
      end
    end
  end)

  if not ok then PrintInfo('[VoiceVisions.Speak] ecourte : '..tostring(err)) end

  --Sortie garantie hors du pcall.
  pcall(function()
    UI:ResetSpeaker()
    if cfg.witness ~= nil then
      AI:EnableCharacterAI(cfg.witness)
      AI:SetCharacterAI(cfg.witness, 'origin.ai.ground_partner', CH('PLAYER'), cfg.witness.Position)
    end
    GAME:CutsceneMode(false)
  end)
end

--------------------------------------------------------------------
-- VoiceVisions.Play — une vision du passe, en planches.
--------------------------------------------------------------------
--  cfg = {
--    strings = STRINGS.MapStrings,
--    level   = 3,                    -- nausee d'entree
--    music   = 'Temporal Tower.ogg', -- musique de la vision (nil = silence)
--    witness = partner,
--    plates  = {                     -- les planches, dans l'ordre
--      { bg='Dream_Back', hold=200, lines={'CLE_010','CLE_011'} },
--      { bg='Dusknoir',   hold=180, lines={'CLE_012'}, shake=6 },
--    },
--    heroLine     = 'CLE_020',
--    witnessLines = {'CLE_021'},
--  }
--
--Les repliques d'une planche passent en VOIX OFF (WaitShowVoiceOver) : pas de
--boite de dialogue, pas de speaker. C'est le format des visions de Ciel, et ca
--evite d'attribuer la parole a un personnage que le joueur ne connait pas.
function VoiceVisions.Play(cfg)
  local hero = CH('PLAYER')
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if cfg.witness ~= nil then AI:DisableCharacterAI(cfg.witness) end

    --Le vertige, plus violent que pour une simple parole.
    SOUND:FadeOutBGM(30)
    VoiceVisions.Nausea(hero, cfg.level or 3)
    GAME:WaitFrames(10)

    --Bascule : ecran blanc puis noir, on quitte le present.
    local center = GAME:GetCameraCenter()
    local flash = RogueEssence.Content.FlashEmitter()
    flash.FadeInTime = 4; flash.HoldTime = 6; flash.FadeOutTime = 20
    flash.StartColor = Color(255, 255, 255, 0)
    flash.Layer = DrawLayer.Top
    flash.Anim = RogueEssence.Content.BGAnimData("White", 0)
    GROUND:PlayVFX(flash, center.X, center.Y)
    GAME:WaitFrames(20)
    GAME:FadeOut(false, 40)
    GAME:WaitFrames(40)

    UI:ResetSpeaker()
    if cfg.music ~= nil then SOUND:PlayBGM(cfg.music, true) end

    --Les planches.
    for _, plate in ipairs(cfg.plates or {}) do
      UI:WaitShowBG(plate.bg, plate.hold or 180, 20)
      if plate.shake ~= nil then
        pcall(function()
          GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, plate.shake, 20))
        end)
      end
      for _, key in ipairs(plate.lines or {}) do
        UI:WaitShowVoiceOver(resolve(cfg, key), -1)
        GAME:WaitFrames(16)
      end
      UI:WaitHideBG(20)
      GAME:WaitFrames(10)
    end

    --Retour au present.
    SOUND:FadeOutBGM(60)
    GAME:WaitFrames(40)
    GAME:FadeIn(40)
    VoiceVisions.Nausea(hero, 2)
    VoiceVisions.Recover(hero)
    GAME:WaitFrames(20)

    if cfg.heroLine ~= nil then
      GeneralFunctions.HeroDialogue(hero, resolve(cfg, cfg.heroLine), "Worried")
    end
    if cfg.witness ~= nil and cfg.witnessLines ~= nil then
      UI:SetSpeaker(cfg.witness)
      UI:SetSpeakerEmotion("Worried")
      for _, key in ipairs(cfg.witnessLines) do
        UI:WaitShowDialogue(resolve(cfg, key))
      end
    end
  end)

  if not ok then
    PrintInfo('[VoiceVisions.Play] ecourte : '..tostring(err))
    --Filet : on ne laisse jamais le joueur dans le noir.
    pcall(function() UI:WaitHideBG(1) end)
    pcall(function() GAME:FadeIn(20) end)
  end

  pcall(function()
    UI:ResetSpeaker()
    if cfg.witness ~= nil then
      AI:EnableCharacterAI(cfg.witness)
      AI:SetCharacterAI(cfg.witness, 'origin.ai.ground_partner', CH('PLAYER'), cfg.witness.Position)
    end
    GAME:CutsceneMode(false)
  end)
end

--------------------------------------------------------------------
-- Suivi : combien de visions le heros a-t-il deja eues ?
--------------------------------------------------------------------
function VoiceVisions.EnsureSV()
  if SV.Visions == nil then SV.Visions = {} end
  if SV.Visions.Seen == nil then SV.Visions.Seen = {} end
  if SV.Visions.Count == nil then SV.Visions.Count = 0 end
end

--Joue une vision UNE SEULE FOIS, identifiee par `id`.
--Renvoie true si la vision a effectivement ete jouee.
function VoiceVisions.PlayOnce(id, cfg)
  VoiceVisions.EnsureSV()
  if SV.Visions.Seen[id] then return false end
  SV.Visions.Seen[id] = true
  SV.Visions.Count = SV.Visions.Count + 1
  VoiceVisions.Play(cfg)
  return true
end

function VoiceVisions.HasSeen(id)
  VoiceVisions.EnsureSV()
  return SV.Visions.Seen[id] == true
end

return VoiceVisions
