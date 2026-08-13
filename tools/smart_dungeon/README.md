# Smart Dungeon Designer

Voir [`docs/SMART_DUNGEON_DESIGNER.md`](../../docs/SMART_DUNGEON_DESIGNER.md).

Démarrage rapide :

```bash
python3 tools/smart_dungeon.py create \
  --project WORK/mon_donjon \
  --name "Mon donjon" \
  --intent "25 étages, début ouvert, fin labyrinthique, deux mini-boss, trois relais et un boss final" \
  --boss --mini-bosses 2 --relays 3 --seed 42
python3 tools/smart_dungeon.py validate --project WORK/mon_donjon
```
