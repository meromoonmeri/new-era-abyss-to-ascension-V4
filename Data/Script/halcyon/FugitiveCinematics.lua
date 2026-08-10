-- Complete New Era adaptation of Rescue Team's fugitive arc.
require 'origin.common'
require 'halcyon.CharacterEssentials'
local C={}
C.BEATS={
 a02p01={title='Ceux que l’on accuse',lines={'Les cloches de Metano sonnent derrière nous. Pas pour une mission — pour une chasse.','Le Cercle du Suaire a retourné notre propre légende contre nous.','Alors on court. Mais on ne laissera personne écrire notre fin.'}},
 a02p02={lines={'La faille coupe la route. Derrière, les voix se rapprochent.','Les héros d’autrefois ont traversé ce pays en fugitifs. Aujourd’hui, leurs traces sont notre seule carte.'}},
 a02p03={lines={'Une lueur rouge dévore l’horizon.','Ils ferment les chemins un à un. Ils veulent que la peur choisisse notre direction.','La peur peut nous suivre. Elle ne nous guidera pas.'}},
 a02p04={lines={'Le volcan est devant nous. Revenir n’est plus possible.','À partir d’ici, chaque pas nous éloigne de l’accusation — et nous rapproche de la vérité.'}},
 d08p01={title='Grotte Lapis',lines={'Les parois bleues renvoient nos silhouettes comme des témoins silencieux.','Cette grotte protégea autrefois deux fugitifs. Qu’elle nous cache assez longtemps pour comprendre qui nous poursuit.'}},
 d08p02={lines={'La sortie est proche… et les poursuivants aussi.','On ne gagnera pas en courant plus vite. Il faut atteindre ceux qui se souviennent.'}},
 d09p01={title='Mont Ardent',lines={'La chaleur efface nos traces, pas nos doutes.','Au sommet vit un gardien qui a connu les anciens héros. S’il nous écoute, leur histoire parlera pour nous.'}},
 d09p02={lines={'Le feu devient blanc. Même la pierre semble respirer.','Encore un effort. Le sommet nous attend.'}},
 d09p03={title='Sulfura — Flamme du Mont Ardent',boss='Moltres',lines={'Trente années ont passé. La montagne, elle, n’a rien oublié.','Prouvez que votre fuite ne vous a pas dépouillés de votre courage.'}},
 a03p01={title='Vers le Nord Boréal',lines={'La cendre chaude s’est effacée sous le premier givre. Le froid mord les pattes.','Derrière nous, le mont brûle encore. Devant, la neige efface tout, même la peur.'}},
 a03p02={lines={'Les grands pins sont pétrifiés par la glace. Le vent ne siffle plus — il prévient.','Les héros d’autrefois ont failli mourir de froid ici. Nous tiendrons bon jusqu’à la clairière.'}},
 a03p03={title='La Voix du Blizzard',lines={'Le blizzard nous aveugle... Mes pas deviennent si lourds...','(Une voix dans le vent... douce et ancienne... « N’abandonnez pas... La vérité vous attend au sommet... »)','Tu as entendu, [player] ? Ce n’était pas le vent ! Quelqu’un veille sur nous !'}},
 d10p01={title='Forêt Givrée',lines={'Après le feu, le silence de la neige.','Artikodin se souvient du désordre climatique d’autrefois. Il saura si la menace qui revient est réelle.'}},
 d10p02={lines={'Le vent s’est tu. Même la neige attend.','Quelque chose nous observe depuis la clairière.'}},
 d10p03={title='Artikodin — Silence des Neiges',boss='Articuno',lines={'J’ai vu les anciens héros traverser cette clairière. Vous portez la même peur, mais pas la même solitude.','Montrez-moi ce que trente années ont appris à ceux qui viennent après eux.'}},
 d11p01={title='Mont Gelé',lines={'Feunard vit au-delà de ces pentes. Sa parole mit fin à une ancienne accusation.','Si le Suaire falsifie cette légende, son témoignage peut briser leur mensonge.'}},
 d11p02={lines={'Le sommet est là. Je sens une présence ancienne — calme, mais immense.','Cette fois, nous ne venons pas demander si nous sommes coupables. Nous venons demander la vérité.'}},
 d11p03={title='Feunard — Témoin de la Légende',boss='Ninetales',testimony=true,lines={'Il y a trente ans, deux fugitifs sont venus chercher ici la vérité sur une malédiction.','La malédiction n’était pas la leur. Leur humanité ne fut jamais la cause des catastrophes.','Emportez mon témoignage. Une vérité gardée trop longtemps devient l’arme de ceux qui mentent.'}},
 d12p01={title='Grotte Magma',lines={'Le témoignage de Feunard nous innocente, mais le monde tremble toujours.','Groudon s’est éveillé une seconde fois. Team ACT nous attend dans les profondeurs.'}},
 d12p02={lines={'Les vétérans ont ouvert la route. À nous d’atteindre la fosse.','La chaleur pulse comme un cœur sous la roche.'}},
 d12p04={title='Groudon — Cœur de la Terre',boss='Groudon',lines={'La terre ne juge ni les anciens héros ni leurs héritiers. Elle répond au déséquilibre.','Si nous voulons sauver ceux qui nous accusent, il faut d’abord calmer ce cœur.'}},
 d13p01={title='Tour Céleste',lines={'Groudon a confirmé le danger : quelque chose fracture encore le ciel.','La tour où Rayquaza arrêta le météore est notre dernier chemin.'}},
 d13p02={lines={'Au-dessus des nuages, les voix de Metano ne nous atteignent plus.','Il ne reste que la vérité, le ciel… et nous.'}},
 d13p03={title='Rayquaza — Arbitre du Ciel',boss='Rayquaza',lines={'Je me souviens des deux êtres qui vinrent demander au ciel de sauver un monde qui les rejetait.','Vous demandez la même chose, trente ans plus tard. Montrez que ce monde mérite encore votre choix.'}},
 t01p01={title='Le retour',lines={'Metano est en panique. Le ciel a parlé, mais la ville ne sait pas encore écouter.','Nous ne reviendrons pas en accusés. Nous revenons avec les témoins de toute une époque.'}},
 a04p01={lines={'Dans le rêve, Gardevoir ne donne pas de réponse. Elle montre deux silhouettes devant une lumière immense.','Leur héritage n’était pas d’être crus. C’était de choisir de sauver les autres malgré tout.'}},
 a05p03={title='Une vérité qui revient',lines={'La fuite s’achève là où commence notre décision.','Demain, nous retournerons devant Metano. Pas pour supplier — pour raconter toute l’histoire.'}},
}
function C.Play(id)
 local b=C.BEATS[id]; if not b then return end
 GAME:CutsceneMode(true); local hero,partner=CH('PLAYER'),CH('Teammate1')
 pcall(function() GROUND:TeleportTo(hero,176,240,Direction.Up) end); if partner then pcall(function() GROUND:TeleportTo(partner,152,240,Direction.Up) end) end
 pcall(function() GAME:MoveCamera(176,196,1,false) end); GAME:FadeIn(25)
 local boss=nil
 if b.boss then boss=CharacterEssentials.MakeCharactersFromList({{b.boss,176,136,Direction.Down}}); pcall(function() GROUND:CharSetAnim(boss,'Idle',true) end) end
 if b.title then UI:WaitShowTitle(b.title,20); GAME:WaitFrames(35); UI:WaitHideTitle(20) end
 for i,line in ipairs(b.lines) do
  if boss and i>0 then UI:SetSpeaker(boss) elseif partner and i%2==1 then UI:SetSpeaker(partner) else UI:ResetSpeaker(false) end
  UI:WaitShowDialogue(line)
 end
 if b.testimony then SV.CanonicalDungeons=SV.CanonicalDungeons or {};SV.CanonicalDungeons.NinetalesTestimony=true end
 GAME:CutsceneMode(false)
end
return C
