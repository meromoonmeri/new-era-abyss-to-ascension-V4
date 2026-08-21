#!/usr/bin/env python3
import hashlib,re
from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1]
SCRIPT=ROOT/'Data/Script/halcyon/ground/gloomy_forest_entrance/gloomy_forest_entrance_ch_6.lua'
CLEARING=ROOT/'Data/Script/halcyon/ground/sinister_woods_clearing/init.lua'
MUSIC=ROOT/'Content/Music/PMD Red EU - In The Depths Of The Pit.ogg'
class Tests(unittest.TestCase):
 def test_exact_rom_music_is_promoted_and_selected(self):
  self.assertEqual(hashlib.sha256(MUSIC.read_bytes()).hexdigest(),'7bef2eda74b112f08c9d04f67f5a0f76a6284356571c292913008117b3d46293');text=SCRIPT.read_text();self.assertIn("SOUND:PlayBGM('PMD Red EU - Sinister Woods.ogg', true)",text);self.assertNotIn("SOUND:PlayBGM('Mystifying Forest.ogg', true)",text);self.assertIn("SOUND:PlayBGM('PMD Red EU - In The Depths Of The Pit.ogg',true)",text);self.assertNotIn("SOUND:PlayBGM('In the Depths of the Pit.ogg',true)",text)
 def test_d04p02_source_slots_are_recast_not_recomposed(self):
  text=SCRIPT.read_text();
  for token in ["TeleportTo(hero, 256, 260", "TeleportTo(partner, 296, 260", "MoveToPosition(adagio,272,192", "MoveToPosition(aria,312,224", "MoveToPosition(sonata,240,224", "MoveCamera(276,220,35,false)"]:self.assertIn(token,text)
  for cast in ["{'Adagio',272,128", "{'Aria',312,144", "{'Sonata',240,144"]:self.assertIn(cast,text)
 def test_nine_source_dialogue_slots_and_native_transition_are_wired(self):
  text=SCRIPT.read_text();keys=re.findall(r"dialogue\([^\n]*'GF6E_A(0[4-9]|1[0-2])'",text);self.assertEqual(keys,['04','05','06','07','08','09','10','11','12']);self.assertIn("GAME:ContinueDungeon('gloomy_forest', 4, 0, 0",text)
  clearing=CLEARING.read_text();self.assertIn('gloomy_forest_entrance_ch_6.DazzlingClearingCutscene()',clearing)
 def test_choreography_keeps_joined_entry_and_reactions(self):
  text=SCRIPT.read_text();self.assertEqual(len(re.findall(r'local enter[123]=TASK:BranchCoroutine',text)),3);self.assertIn('TASK:JoinCoroutines({enter1,enter2,enter3,cam})',text);self.assertIn('CharTurnToCharAnimated',text);self.assertIn("CharSetEmote(aria, 'exclaim'",text);self.assertIn("CharSetEmote(sonata, 'angry'",text)
if __name__=='__main__':unittest.main()
