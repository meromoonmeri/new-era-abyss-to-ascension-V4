#!/usr/bin/env python3
from pathlib import Path
import sys
bad=[]
for p in Path('Data/Zone').glob('*.json'):
 s=p.read_text(encoding='utf-8-sig')
 if 'FloorStairsStep' in s and 'RogueElements.TeamSpawner' in s:bad.append(str(p))
print('unresolved FloorStairsStep generic types:',len(bad))
for p in bad:print(p)
sys.exit(1 if bad else 0)
