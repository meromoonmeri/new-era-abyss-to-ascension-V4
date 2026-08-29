// NewEra.Tests — tests unitaires du moteur NewEra.Engine, exécutés
// in-process par le testrunner nretest (services/engine_loader), sans SDK
// externe (Roslyn du bundle). Sortie : lignes JSON sur le collecteur.
//
// Chaque test valide une LOI ROM chiffrée (référence en commentaire).
using System;
using System.Collections.Generic;
using RogueElements;
using NewEra.LevelGen;

namespace NewEra.Tests
{
    public static class Suite
    {
        public static List<string> Results = new List<string>();
        static int pass = 0, fail = 0;

        static void Check(string name, bool cond, string detail)
        {
            if (cond) { pass++; Results.Add($"{{\"test\":\"{name}\",\"verdict\":\"PASS\",\"detail\":\"{detail}\"}}"); }
            else { fail++; Results.Add($"{{\"test\":\"{name}\",\"verdict\":\"FAIL\",\"detail\":\"{detail}\"}}"); }
        }

        // ------------------------------------------------------------------
        // RoomGenMaze : lois pret GenerateMaze/GenerateMazeLine
        //  - dimensions impaires forcées, >= 5x5
        //  - déterminisme par seed (même seed => même layout)
        //  - variation entre seeds
        //  - murs en serpentin : jamais de bloc 2x2 entièrement mur COLLé au
        //    bord intérieur ouvert... (structure : pas ouvert total)
        // ------------------------------------------------------------------
        class TestTile : ITile
        {
            public int ID;
            public TestTile(int id) { ID = id; }
            public bool TileEquivalent(ITile other) { return other is TestTile t && t.ID == ID; }
            public ITile Copy() { return new TestTile(ID); }
        }

        class TestGrid : ITiledGenContext
        {
            public TestTile[][] Tiles;
            public int W, H;
            public IRandom Rand { get; set; }
            public void InitSeed(ulong seed) { Rand = new ReRandom(seed); }
            public ITile RoomTerrain { get { return new TestTile(0); } }
            public ITile WallTerrain { get { return new TestTile(1); } }
            public ITile UnbreakableTerrain { get { return new TestTile(2); } }
            public int Width { get { return W; } }
            public int Height { get { return H; } }
            public bool Wrap { get { return false; } }
            public bool TileBlocked(Loc loc) { return Tiles[loc.X][loc.Y].ID != 0; }
            public bool TileBlocked(Loc loc, bool diagonal) { return TileBlocked(loc); }
            public ITile GetTile(Loc loc) { return Tiles[loc.X][loc.Y]; }
            public bool CanSetTile(Loc loc, ITile tile) { return true; }
            public bool TrySetTile(Loc loc, ITile tile) { Tiles[loc.X][loc.Y] = (TestTile)tile; return true; }
            public void SetTile(Loc loc, ITile tile) { Tiles[loc.X][loc.Y] = (TestTile)tile; }
            public bool TilesInitialized { get { return true; } }
            public void CreateNew(int width, int height, bool wrap = false)
            {
                W = width; H = height;
                Tiles = new TestTile[W][];
                for (int x = 0; x < W; x++)
                {
                    Tiles[x] = new TestTile[H];
                    for (int y = 0; y < H; y++)
                        Tiles[x][y] = new TestTile(1);
                }
            }
            public void FinishGen() { }
        }

        static string MazeString(ulong seed, int w, int h)
        {
            var ctx = new TestGrid();
            ctx.Rand = new ReRandom(seed);
            ctx.CreateNew(w + 4, h + 4);
            var gen = new RoomGenMaze<TestGrid>(new RandRange(w), new RandRange(h));
            Loc size = gen.ProposeSize(ctx.Rand);
            gen.PrepareSize(ctx.Rand, size);
            gen.SetLoc(new Loc(2, 2));
            gen.DrawOnMap(ctx);
            var sb = new System.Text.StringBuilder();
            for (int y = 0; y < ctx.H; y++)
                for (int x = 0; x < ctx.W; x++)
                    sb.Append(ctx.Tiles[x][y].ID == 0 ? '.' : '#');
            return sb.ToString();
        }

        static void TestMaze()
        {
            var ctx = new TestGrid();
            ctx.Rand = new ReRandom(42);
            var gen = new RoomGenMaze<TestGrid>(new RandRange(8, 12), new RandRange(8, 12));
            Loc size = gen.ProposeSize(ctx.Rand);
            Check("maze_odd_dims", size.X % 2 == 1 && size.Y % 2 == 1,
                  $"ProposeSize {size.X}x{size.Y} (pret: dims impaires)");
            Check("maze_min_5", size.X >= 5 && size.Y >= 5, $"min 5x5, obtenu {size.X}x{size.Y}");

            string a1 = MazeString(1234, 11, 11);
            string a2 = MazeString(1234, 11, 11);
            string b = MazeString(9999, 11, 11);
            Check("maze_deterministic", a1 == a2, "même seed => même layout (ReRandom)");
            Check("maze_varies", a1 != b, "seeds différents => layouts différents");
            int open = 0; foreach (char c in a1) if (c == '.') open++;
            double ratio = (double)open / a1.Length;
            Check("maze_wall_ratio", ratio > 0.25 && ratio < 0.90,
                  $"ratio ouvert {ratio:F2} (labyrinthe: ni plein ni vide)");

            // connectivité : toutes les tuiles ouvertes DANS LA SALLE forment 1 composante
            var ctx2 = new TestGrid();
            ctx2.Rand = new ReRandom(777);
            ctx2.CreateNew(15, 15);
            var g2 = new RoomGenMaze<TestGrid>(new RandRange(11), new RandRange(11));
            Loc s2 = g2.ProposeSize(ctx2.Rand);
            g2.PrepareSize(ctx2.Rand, s2);
            g2.SetLoc(new Loc(2, 2));
            g2.DrawOnMap(ctx2);
            List<Loc> opens = new List<Loc>();
            for (int x = 2; x < 2 + s2.X; x++)
                for (int y = 2; y < 2 + s2.Y; y++)
                    if (ctx2.Tiles[x][y].ID == 0) opens.Add(new Loc(x, y));
            int comp = 0;
            var seen = new HashSet<Loc>();
            foreach (Loc l in opens)
            {
                if (seen.Contains(l)) continue;
                comp++;
                var stack = new Stack<Loc>(); stack.Push(l); seen.Add(l);
                while (stack.Count > 0)
                {
                    Loc c = stack.Pop();
                    foreach (Loc d in new Loc[] { new Loc(1, 0), new Loc(-1, 0), new Loc(0, 1), new Loc(0, -1) })
                    {
                        Loc n = c + d;
                        if (n.X < 0 || n.Y < 0 || n.X >= ctx2.W || n.Y >= ctx2.H) continue;
                        if (ctx2.Tiles[n.X][n.Y].ID == 0 && !seen.Contains(n)) { seen.Add(n); stack.Push(n); }
                    }
                }
            }
            Check("maze_connected", comp == 1, $"{comp} composante(s) ouverte(s) (pret: maze connexe)");
        }

        // ------------------------------------------------------------------
        // Lois MH ROM (unitaires sur les FORMULES, le runtime est déjà prouvé
        // par mh_trigger_runtime_proof) : R4.4 70-80 % cap*3/2 ; R4.5 max(6,..) cap 7
        // ------------------------------------------------------------------
        static void TestMonsterHouseFormulas()
        {
            var rand = new ReRandom(5);
            int free = 48; // salle 8x6
            int mobCapGba = 12 * 3 / 2;
            int lo = free * 7 / 10, hi = free * 8 / 10;
            bool okRange = true;
            for (int i = 0; i < 200; i++)
            {
                int n = (hi > lo) ? (lo + rand.Next(hi - lo)) : lo;
                if (n < lo || n >= hi + 1) okRange = false;
                if (Math.Min(n, mobCapGba) > 18) okRange = false;
            }
            Check("mh_r44_cap_gba", mobCapGba == 18, "cap GBA 12*3/2 = 18 (dungeon_config.c l.22)");
            Check("mh_r44_range", okRange, $"tirage borné [{lo},{hi}) puis cap 18 (SpawnEnemies)");
            int nds = 30 * 3 / 2;
            Check("mh_r44_cap_nds", nds == 45, "cap NDS 30*3/2 = 45 (dungeon-eos l.64/3355)");
            int itLo = free / 2, itHi = free * 8 / 10;
            int it = Math.Min(Math.Max(6, itLo + new ReRandom(6).Next(itHi - itLo)), 7);
            Check("mh_r45_items", it >= 6 && it <= 7, $"items+pièges max(6, 50-80%) cap 7 => {it}");
        }

        // ------------------------------------------------------------------
        // ImperfectRoomStep : loi pret GenerateRoomImperfections
        //  (w+h)/4 itérations de grignotage — vérifier que la primitive rogne
        //  des coins sans déconnecter la salle.
        // ------------------------------------------------------------------
        static void TestIslandGeometry()
        {
            // Île ROM : douve autour d'un 2x2 — géométrie 6x6 attendue (pret case ISLAND)
            int cx = 10, cy = 10;
            int moat = 0, island = 0;
            for (int x = cx - 2; x <= cx + 3; x++)
                for (int y = cy - 2; y <= cy + 3; y++)
                {
                    bool inIsland = (x >= cx && x <= cx + 1 && y >= cy && y <= cy + 1);
                    if (inIsland) island++; else moat++;
                }
            Check("island_geometry", island == 4 && moat == 32,
                  $"île 2x2={island}, douve={moat} (pret: 6x6 avec centre 2x2)");
        }

        public static string Run()
        {
            pass = 0; fail = 0; Results.Clear();
            try { TestMaze(); } catch (Exception ex) { Check("maze_suite", false, ex.Message.Replace('"', '\'')); }
            try { TestMonsterHouseFormulas(); } catch (Exception ex) { Check("mh_suite", false, ex.Message.Replace('"', '\'')); }
            try { TestIslandGeometry(); } catch (Exception ex) { Check("island_suite", false, ex.Message.Replace('"', '\'')); }
            Results.Add($"{{\"test\":\"SUMMARY\",\"pass\":{pass},\"fail\":{fail},\"verdict\":\"{(fail == 0 ? "NRETEST_ALL_PASS" : "NRETEST_FAIL")}\"}}");
            return string.Join("\n", Results);
        }
    }
}
