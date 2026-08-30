// LABORATOIRE UNIQUEMENT — blueprint C# pour un checkout PMDC/RogueEssence.
// Ce n'est pas compilé ni référencé par le mod. Les types de données PMDC
// (MapGenContext, MapGenEntrance et MapGenExit) doivent provenir de la même
// version que le moteur qui chargera ensuite le JSON de zone.
//
// Pipeline conceptuel d'un étage, à instancier trois fois (ou à sérialiser
// comme trois GridFloorGen) avec des seeds distincts :
//
//   -4 InitGridPlanStep<MapGenContext>
//   -4 GridPathBranch<MapGenContext> + RoomGen/RoomGenAngledHall
//   -2 DrawGridToFloorStep<MapGenContext>
//    0 DrawFloorToTileStep<MapGenContext>
//    3 PerlinWaterStep<MapGenContext> (facultatif)
//    5 FloorStairsStep<MapGenContext,MapGenEntrance,MapGenExit>
//    6 DetectIsolatedStairsStep<...>
//    7 spawn items / teams sur les free tiles
//
// Les quatre premiers steps sont reproduits par l'exemple officiel
// SkyTemple/rogueelements-pmd-asp. Les deux suivants sont les types exacts
// relevés dans Data/Zone/chasm_cave.json de ce mod.

using RogueElements;
using RogueEssence.LevelGen;

namespace NewEra.Training
{
    internal static class MinimalThreeFloorSpecification
    {
        internal const int FloorCount = 3;
        internal const int RoomGenerationPriority = -4;
        internal const int PlanToFloorPriority = -2;
        internal const int DrawTilesPriority = 0;
        internal const int StairsPriority = 5;
        internal const int StairSafetyPriority = 6;

        // Contrat à vérifier dans le générateur de test :
        // 1. le contexte est IRoomGridGenContext avant DrawGridToFloorStep;
        // 2. il est ITiledGenContext après DrawFloorToTileStep;
        // 3. il est IFloorPlanGenContext + IPlaceableGenContext<entrée/sortie>
        //    avant FloorStairsStep;
        // 4. chaque seed produit une entrée et une sortie joignables.
        //
        // Le code de production n'a pas besoin de cette classe : le même
        // pipeline est sérialisé dans Data/Zone/*.json et exécuté par PMDO.
        internal static string ExplainSeed(ulong seed) =>
            $"Training floor seed {seed}: rooms -> tiles -> stairs -> safety -> spawns";
    }
}
