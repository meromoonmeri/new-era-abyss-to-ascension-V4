# MANIFESTE — CONVERSION PMD SKY → PMDO (depuis pret/pmd-sky, outil PMDSky_PMDO_Framework)

Source brute : `pret/pmd-sky` (files/MAP_BG, files/language-specific/EU/SCRIPT, files/GROUND).
Outil : `PMDSky_PMDO_Framework` (extracteurs + convertisseurs, à corriger pour la collision BMA).

## Donjons (dungeon.h)

| ID | Donjon | Maps MAP_BG | Scripts | Boss |
|---|---|---|---|---|
| 0 | Test Dungeon | d00p01<br>d00p02 | D00P01<br>D00P02 | — |
| 1 | Beach Cave | d01p11a<br>d01p11b<br>d01p41a | D01P11A<br>D01P11B<br>D01P41A | — |
| 2 | Beach Cave Pit | d02p11a<br>d02p31a | D02P11A<br>D02P31A | Cradily |
| 3 | Drenched Bluff | d03p11a<br>d03p41a | D03P11A<br>D03P41A | — |
| 4 | Mt Bristle | d04p11a<br>d04p12a<br>d04p31a | D04P11A<br>D04P12A<br>D04P31A | — |
| 5 | Mt Bristle Peak | d05p11a<br>d05p31a | D05P11A<br>D05P31A | Golem |
| 6 | Waterfall Cave | d06p11a | D06P11A | Cranidos duo |
| 7 | Apple Woods | d07p11a | D07P11A | — |
| 8 | Craggy Coast | d08p11a | D08P11A | — |
| 9 | Side Path | d09p11a | D09P11A | — |
| 10 | Mt Horn | d10p21a<br>d10p41a | D10P21A<br>D10P41A | — |
| 11 | Rock Path | d11p11a | D11P11A | — |
| 12 | Foggy Forest | d12p21a<br>d12p41a | D12P21A<br>D12P41A | — |
| 13 | Forest Path | d13p11a | D13P11A | — |
| 14 | Steam Cave | d14p11a<br>d14p12a | D14P11A<br>D14P12A | — |
| 15 | Upper Steam Cave | d15p21a<br>d15p41a | D15P21A<br>D15P41A | — |
| 16 | Steam Cave Peak | d16p11a<br>d16p31a | D16P11A<br>D16P31A | Heatran |
| 17 | Amp Plains | d17p11a<br>d17p31a<br>d17p32a<br>d17p33a<br>d17p34a<br>d17p45a | D17P11A<br>D17P31A<br>D17P32A<br>D17P33A<br>D17P34A<br>D17P45A | — |
| 18 | Far Amp Plains | d18p11a | D18P11A | — |
| 19 | Amp Clearing | d19p11a | D19P11A | Luxray |
| 20 | Northern Desert | d20p11a | D20P11A | — |
| 21 | Quicksand Cave | d21p21a<br>d21p41a | D21P21A<br>D21P41A | — |
| 22 | Quicksand Pit | d22p11a | D22P11A | Hippowdon |
| 23 | Underground Lake | d23p11a | D23P11A | — |
| 24 | Crystal Cave | d24p11a<br>d24p31a<br>d24p31b | D24P11A<br>D24P31A | — |
| 25 | Crystal Crossing | d25p11a | D25P11A | — |
| 26 | Crystal Lake | d26p21a<br>d26p31a<br>d26p43a | D26P21A<br>D26P31A<br>D26P43A | Froslass |
| 27 | Chasm Cave | d27p11a | D27P11A | — |
| 28 | Dark Hill | d28p21a<br>d28p31a<br>d28p32a<br>d28p33a<br>d28p33c<br>d28p34a<br>d28p44a | D28P21A<br>D28P31A<br>D28P32A<br>D28P33A<br>D28P34A<br>D28P44A | — |
| 29 | Sealed Ruin | d29p11a | D29P11A | — |
| 30 | Deep Sealed Ruin | d30p21a<br>d30p32a<br>d30p33a<br>d30p34a<br>d30p41a<br>d30p42a | D30P21A<br>D30P32A<br>D30P33A<br>D30P34A<br>D30P41A | Dusknoir |
| 31 | Sealed Ruin Pit | d31p11a<br>d31p31a<br>d31p41a | D31P11A<br>D31P31A<br>D31P41A | — |
| 32 | Dusk Forest | d32p11a<br>d32p12a<br>d32p13a<br>d32p14a<br>d32p31a<br>d32p32a<br>d32p33a<br>d32p41a<br>d32p42a<br>d32p43a<br>d32p44a | D32P11A<br>D32P12A<br>D32P13A<br>D32P14A<br>D32P31A<br>D32P32A<br>D32P33A<br>D32P44A | — |
| 33 | Deep Dusk Forest | d33p41a | — | — |
| 34 | Treeshroud Forest | d34p41a | D34P41A | — |
| 35 | Brine Cave | d35p21a<br>d35p41a | D35P21A<br>D35P41A | — |
| 36 | Lower Brine Cave | d36p11a<br>d36p41a | D36P11A<br>D36P41A | — |
| 37 | Brine Cave Pit | d37p11a<br>d37p41a | D37P11A<br>D37P41A | Azelf |
| 38 | Hidden Land | d38p11a<br>d38p12a | D38P11A<br>D38P12A | — |
| 39 | Hidden Highland | d39p21a<br>d39p32a<br>d39p41a | D39P21A<br>D39P32A<br>D39P41A | Mesprit |
| 40 | Old Ruins | d40p11a | D40P11A | — |
| 41 | Temporal Tower | d41p21a<br>d41p41a | D41P21A<br>D41P41A | — |
| 42 | Temporal Spire | d42p21a<br>d42p31a<br>d42p41a<br>d42p42a | D42P21A<br>D42P31A<br>D42P41A<br>D42P42A | — |
| 43 | Temporal Pinnacle | d43p31a | D43P31A | Primal Dialga |
| 44 | Mystifying Forest | d44p31a | D44P31A | — |
| 45 | Mystifying Forest Clearing | d45p21a<br>d45p31a<br>d45p42a | D45P21A<br>D45P31A<br>D45P42A | Celebi |
| 46 | Blizzard Island | d46p11a<br>d46p21a<br>d46p31a<br>d46p41a | D46P11A<br>D46P21A<br>D46P31A | — |
| 47 | Crevice Cave | d47p11a | D47P11A | — |
| 48 | Lower Crevice Cave | d48p11a<br>d48p21a | D48P11A<br>D48P21A | Regigigas |
| 49 | Crevice Cave Pit | d49p41a | — | Regigigas |
| 50 | Surrounded Sea | d50p11a | D50P11A | — |
| 51 | Miracle Sea | d51p11a<br>d51p21a<br>d51p41a | D51P11A<br>D51P21A<br>D51P41A | — |
| 52 | Deep Miracle Sea | d52p11a<br>d52p11c<br>d52p31a<br>d52p32a | D52P11A<br>D52P11C<br>D52P31A<br>D52P32A | Cresselia |
| 53 | Miracle Seabed | d53p11a<br>d53p11b<br>d53p21a<br>d53p41a<br>d53p41b<br>d53p41c | D53P11A<br>D53P11B<br>D53P21A<br>D53P41A<br>D53P41B<br>D53P41C | Darkrai |
| 54 | Ice Aegis Cave | d54p11a<br>d54p31a<br>d54p32a | D54P11A<br>D54P31A<br>D54P32A | — |
| 55 | Regice Chamber | d55p11a<br>d55p21a<br>d55p41a | D55P11A<br>D55P21A<br>D55P41A | Regice |
| 56 | Rock Aegis Cave | d56p11a<br>d56p12a<br>d56p21a<br>d56p41a | D56P11A<br>D56P12A<br>D56P21A<br>D56P41A | — |
| 57 | Regirock Chamber | d57p21a<br>d57p41a<br>d57p42a<br>d57p43a<br>d57p44a | D57P21A<br>D57P41A<br>D57P42A<br>D57P43A<br>D57P44A | Regirock |
| 58 | Steel Aegis Cave | d58p41a | — | — |
| 59 | Registeel Chamber | d59p41a | — | Registeel |
| 60 | Aegis Cave Pit | d60p41a | — | — |
| 61 | Regigigas Chamber | d61p41a | — | Regigigas |
| 62 | Mt Travail | d62p41a | — | — |
| 63 | The Nightmare | d63p41a | D63P41A | — |
| 64 | Spacial Rift | — | — | — |
| 65 | Deep Spacial Rift | d65p41a | D65P41A | Palkia |
| 66 | Spacial Rift Bottom | d66p41a | D66P41A | Palkia |
| 67 | Dark Crater | d67p41a | D67P41A | — |
| 68 | Deep Dark Crater | d68p41a | D68P41A | — |
| 69 | Dark Crater Pit | d69p41a | D69P41A | Darkrai |
| 70 | Concealed Ruins | d70p41a | D70P41A | — |
| 71 | Deep Concealed Ruins | d71p41a | D71P41A | Bronzong |
| 72 | Marine Resort | d72p41a | — | — |
| 73 | Bottomless Sea | d73p11a<br>d73p21a<br>d73p22a<br>d73p23a<br>d73p24a<br>d73p25a<br>d73p26a<br>d73p27a<br>d73p28a<br>d73p29a<br>d73p31a<br>d73p41a | D73P11A<br>D73P21A<br>D73P22A<br>D73P23A<br>D73P24A<br>D73P25A<br>D73P26A<br>D73P27A<br>D73P28A<br>D73P29A<br>D73P31A<br>D73P41A | — |
| 74 | Bottomless Sea Depths | — | — | Kyogre |
| 75 | Shimmer Desert | — | — | — |
| 76 | Shimmer Desert Pit | — | — | Groudon |
| 77 | Mt Avalanche | — | — | — |
| 78 | Mt Avalanche Peak | — | — | Articuno |
| 79 | Giant Volcano | d79p11a<br>d79p21a<br>d79p41a | D79P11A<br>D79P21A<br>D79P41A | — |
| 80 | Giant Volcano Peak | d80p41a | D80P41A | Heatran |
| 81 | World Abyss | d81p41a | D81P41A | — |
| 82 | World Abyss Pit | d82p41a | D82P41A | Giratina |
| 83 | Sky Stairway | d83p41a | D83P41A | — |
| 84 | Sky Stairway Apex | d84p41a | D84P41A | Rayquaza |
| 85 | Mystery Jungle | d85p41a | D85P41A | — |
| 86 | Deep Mystery Jungle | d86p41a | D86P41A | Mew |
| 87 | Serenity River | d87p41a | D87P41A | — |
| 88 | Landslide Cave | d88p41a | D88P41A | — |
| 89 | Lush Prairie | d89p41a | D89P41A | — |
| 90 | Tiny Meadow | d90p41a | D90P41A | — |
| 91 | Labyrinth Cave | d91p41a | — | — |
| 92 | Oran Forest | d92p41a | — | — |
| 93 | Lake Afar | d93p41a | — | — |
| 94 | Happy Outlook | d94p41a | — | Uxie |
| 95 | My Mistral | d95p41a | — | — |
| 96 | Shimmer Hill | — | — | — |
| 97 | Lost Wilderness | — | — | Regigigas |
| 98 | Midnight Forest | — | — | — |
| 99 | Zero Isle North | — | — | — |
| 100 | Zero Isle East | — | — | — |
| 101 | Zero Isle West | — | — | — |
| 102 | Zero Isle South | — | — | — |
| 103 | Zero Isle Center | — | — | Regigigas |
| 104 | Destiny Tower | — | — | Aegis trio |
| 107 | Oblivion Forest | — | — | — |
| 108 | Treacherous Waters | — | — | — |
| 109 | Southeastern Islands | — | — | — |
| 110 | Inferno Cave | — | — | — |
| 111 | 1St Station Pass | — | — | — |
| 112 | 2Nd Station Pass | — | — | — |
| 113 | 3Rd Station Pass | — | — | — |
| 114 | 4Th Station Pass | — | — | — |
| 115 | 5Th Station Pass | — | — | — |
| 116 | 6Th Station Pass | — | — | — |
| 117 | 7Th Station Pass | — | — | — |
| 118 | 8Th Station Pass | — | — | — |
| 119 | 9Th Station Pass | — | — | — |
| 120 | Sky Peak Summit Pass | — | — | — |
| 121 | 5Th Station Clearing | — | — | — |
| 122 | Sky Peak Summit | — | — | — |
| 123 | Star Cave Se1 | — | — | — |
| 124 | Deep Star Cave | — | — | — |
| 125 | Deep Star Cave Team Rogue | — | — | — |
| 126 | Star Cave Depths | — | — | — |
| 127 | Star Cave Pit | — | — | — |
| 128 | Murky Forest | — | — | — |
| 129 | Eastern Cave | — | — | — |
| 130 | Fortune Ravine | — | — | — |
| 131 | Fortune Ravine Depths | — | — | — |
| 132 | Fortune Ravine Pit | — | — | — |
| 133 | Barren Valley | — | — | — |
| 134 | Deep Barren Valley | — | — | — |
| 135 | Barren Valley Clearing | — | — | — |
| 136 | Dark Wasteland | — | — | — |
| 137 | Temporal Tower Se5 | — | — | — |
| 138 | Temporal Spire Se5 | — | — | — |
| 139 | Dusk Forest Se5 | — | — | — |
| 140 | Black Swamp | — | — | — |
| 141 | Spacial Cliffs | — | — | — |
| 142 | Dark Ice Mountain | — | — | — |
| 143 | Dark Ice Mountain Peak | — | — | — |
| 144 | Dark Ice Mountain Pinnacle | — | — | — |
| 145 | Icicle Forest | — | — | — |
| 146 | Vast Ice Mountain | — | — | — |
| 147 | Vast Ice Mountain Peak | — | — | — |
| 148 | Vast Ice Mountain Pinnacle | — | — | — |
| 149 | Southern Jungle | — | — | — |
| 150 | Boulder Quarry | — | — | — |
| 151 | Deep Boulder Quarry | — | — | — |
| 152 | Boulder Quarry Clearing | — | — | — |
| 153 | Right Cave Path | — | — | — |
| 154 | Left Cave Path | — | — | — |
| 155 | Limestone Cavern | — | — | — |
| 156 | Deep Limestone Cavern | — | — | — |
| 157 | Limestone Cavern Depths | — | — | — |
| 158 | Spring Cave | — | — | — |
| 159 | Upper Spring Cave Haunter | — | — | — |
| 160 | Upper Spring Cave | — | — | — |
| 161 | Middle Spring Cave | — | — | — |
| 162 | Lower Spring Cave | — | — | — |
| 163 | Spring Cave Depths | — | — | — |
| 164 | Spring Cave Pit | — | — | — |
| 165 | Little Plains | — | — | — |
| 166 | Mt Clear | — | — | — |
| 167 | Challenge River | — | — | — |
| 168 | Trial Forest | — | — | — |
| 169 | Guiding Sea | — | — | — |
| 170 | Hidden Shopkeeper Village | — | — | — |
| 174 | Star Cave | — | — | — |
| 175 | Shaymin Village | — | — | — |
| 176 | Armaldos Shelter | — | — | — |
| 177 | Luminous Spring | — | — | — |
| 178 | Hot Spring | — | — | — |
| 179 | Rescue | — | — | — |
| 180 | Normal Fly Maze | — | — | — |
| 181 | Dark Fire Maze | — | — | — |
| 182 | Rock Water Maze | — | — | — |
| 183 | Grass Maze | — | — | — |
| 184 | Elec Steel Maze | — | — | — |
| 185 | Ice Ground Maze | — | — | — |
| 186 | Fight Psych Maze | — | — | — |
| 187 | Poison Bug Maze | — | — | — |
| 188 | Dragon Maze | — | — | — |
| 189 | Ghost Maze | — | — | — |
| 190 | Explorer Maze | — | — | — |
| 191 | Final Maze | — | — | — |
| 212 | Rescue Dungeon | — | — | — |
| 213 | Base | — | — | — |
| 214 | Joined At Question Marks | — | — | — |
| 215 | Beach | — | — | — |
| 216 | Joined At Unknown | — | — | — |
| 217 | Joined At Bidoof | — | — | — |
| 218 | Joined At Grovyle | — | — | — |
| 219 | Joined At Celebi | — | — | — |
| 220 | Joined At Chatot | — | — | — |
| 221 | Joined At Cresselia | — | — | — |
| 241 | Joined At Manaphy Recruited | — | — | — |
| 242 | Joined At Cresselia Recruited | — | — | — |
| 243 | Joined At Shaymin Land Recruited | — | — | — |
| 249 | Outside | — | — | — |
| 250 | Client | — | — | — |
| 0 | Test Dungeon Idx | d00p01<br>d00p02 | D00P01<br>D00P02 | — |
| 1 | Beach Cave Idx | d01p11a<br>d01p11b<br>d01p41a | D01P11A<br>D01P11B<br>D01P41A | — |
| 2 | Beach Cave Pit Idx | d02p11a<br>d02p31a | D02P11A<br>D02P31A | — |
| 3 | Drenched Bluff Idx | d03p11a<br>d03p41a | D03P11A<br>D03P41A | — |
| 4 | Mt Bristle Idx | d04p11a<br>d04p12a<br>d04p31a | D04P11A<br>D04P12A<br>D04P31A | — |
| 5 | Mt Bristle Peak Idx | d05p11a<br>d05p31a | D05P11A<br>D05P31A | — |
| 6 | Waterfall Cave Idx | d06p11a | D06P11A | — |
| 7 | Apple Woods Idx | d07p11a | D07P11A | — |
| 8 | Craggy Coast Idx | d08p11a | D08P11A | — |
| 9 | Side Path Idx | d09p11a | D09P11A | — |
| 10 | Mt Horn Idx | d10p21a<br>d10p41a | D10P21A<br>D10P41A | — |
| 11 | Rock Path Idx | d11p11a | D11P11A | — |
| 12 | Foggy Forest Idx | d12p21a<br>d12p41a | D12P21A<br>D12P41A | — |
| 13 | Forest Path Idx | d13p11a | D13P11A | — |
| 14 | Steam Cave Idx | d14p11a<br>d14p12a | D14P11A<br>D14P12A | — |
| 15 | Upper Steam Cave Idx | d15p21a<br>d15p41a | D15P21A<br>D15P41A | — |
| 16 | Steam Cave Peak Idx | d16p11a<br>d16p31a | D16P11A<br>D16P31A | — |
| 17 | Amp Plains Idx | d17p11a<br>d17p31a<br>d17p32a<br>d17p33a<br>d17p34a<br>d17p45a | D17P11A<br>D17P31A<br>D17P32A<br>D17P33A<br>D17P34A<br>D17P45A | — |
| 18 | Far Amp Plains Idx | d18p11a | D18P11A | — |
| 19 | Amp Clearing Idx | d19p11a | D19P11A | — |
| 20 | Northern Desert Idx | d20p11a | D20P11A | — |
| 21 | Quicksand Cave Idx | d21p21a<br>d21p41a | D21P21A<br>D21P41A | — |
| 22 | Quicksand Pit Idx | d22p11a | D22P11A | — |
| 23 | Underground Lake Idx | d23p11a | D23P11A | — |
| 24 | Crystal Cave Idx | d24p11a<br>d24p31a<br>d24p31b | D24P11A<br>D24P31A | — |
| 25 | Crystal Crossing Idx | d25p11a | D25P11A | — |
| 26 | Crystal Lake Idx | d26p21a<br>d26p31a<br>d26p43a | D26P21A<br>D26P31A<br>D26P43A | — |
| 27 | Chasm Cave Idx | d27p11a | D27P11A | — |
| 28 | Dark Hill Idx | d28p21a<br>d28p31a<br>d28p32a<br>d28p33a<br>d28p33c<br>d28p34a<br>d28p44a | D28P21A<br>D28P31A<br>D28P32A<br>D28P33A<br>D28P34A<br>D28P44A | — |
| 29 | Sealed Ruin Idx | d29p11a | D29P11A | — |
| 30 | Deep Sealed Ruin Idx | d30p21a<br>d30p32a<br>d30p33a<br>d30p34a<br>d30p41a<br>d30p42a | D30P21A<br>D30P32A<br>D30P33A<br>D30P34A<br>D30P41A | — |
| 31 | Sealed Ruin Pit Idx | d31p11a<br>d31p31a<br>d31p41a | D31P11A<br>D31P31A<br>D31P41A | — |
| 32 | Dusk Forest Idx | d32p11a<br>d32p12a<br>d32p13a<br>d32p14a<br>d32p31a<br>d32p32a<br>d32p33a<br>d32p41a<br>d32p42a<br>d32p43a<br>d32p44a | D32P11A<br>D32P12A<br>D32P13A<br>D32P14A<br>D32P31A<br>D32P32A<br>D32P33A<br>D32P44A | — |
| 33 | Deep Dusk Forest Idx | d33p41a | — | — |
| 34 | Treeshroud Forest Idx | d34p41a | D34P41A | — |
| 35 | Brine Cave Idx | d35p21a<br>d35p41a | D35P21A<br>D35P41A | — |
| 36 | Lower Brine Cave Idx | d36p11a<br>d36p41a | D36P11A<br>D36P41A | — |
| 37 | Brine Cave Pit Idx | d37p11a<br>d37p41a | D37P11A<br>D37P41A | — |
| 38 | Hidden Land Idx | d38p11a<br>d38p12a | D38P11A<br>D38P12A | — |
| 39 | Hidden Highland Idx | d39p21a<br>d39p32a<br>d39p41a | D39P21A<br>D39P32A<br>D39P41A | — |
| 40 | Old Ruins Idx | d40p11a | D40P11A | — |
| 41 | Temporal Tower Idx | d41p21a<br>d41p41a | D41P21A<br>D41P41A | — |
| 42 | Temporal Spire Idx | d42p21a<br>d42p31a<br>d42p41a<br>d42p42a | D42P21A<br>D42P31A<br>D42P41A<br>D42P42A | — |
| 43 | Temporal Pinnacle Idx | d43p31a | D43P31A | — |
| 44 | Mystifying Forest Idx | d44p31a | D44P31A | — |
| 45 | Mystifying Forest Clearing Idx | d45p21a<br>d45p31a<br>d45p42a | D45P21A<br>D45P31A<br>D45P42A | — |
| 46 | Blizzard Island Idx | d46p11a<br>d46p21a<br>d46p31a<br>d46p41a | D46P11A<br>D46P21A<br>D46P31A | — |
| 47 | Crevice Cave Idx | d47p11a | D47P11A | — |
| 48 | Lower Crevice Cave Idx | d48p11a<br>d48p21a | D48P11A<br>D48P21A | — |
| 49 | Crevice Cave Pit Idx | d49p41a | — | — |
| 50 | Surrounded Sea Idx | d50p11a | D50P11A | — |
| 51 | Miracle Sea Idx | d51p11a<br>d51p21a<br>d51p41a | D51P11A<br>D51P21A<br>D51P41A | — |
| 52 | Deep Miracle Sea Idx | d52p11a<br>d52p11c<br>d52p31a<br>d52p32a | D52P11A<br>D52P11C<br>D52P31A<br>D52P32A | — |
| 53 | Miracle Seabed Idx | d53p11a<br>d53p11b<br>d53p21a<br>d53p41a<br>d53p41b<br>d53p41c | D53P11A<br>D53P11B<br>D53P21A<br>D53P41A<br>D53P41B<br>D53P41C | — |
| 54 | Ice Aegis Cave Idx | d54p11a<br>d54p31a<br>d54p32a | D54P11A<br>D54P31A<br>D54P32A | — |
| 55 | Regice Chamber Idx | d55p11a<br>d55p21a<br>d55p41a | D55P11A<br>D55P21A<br>D55P41A | — |
| 56 | Rock Aegis Cave Idx | d56p11a<br>d56p12a<br>d56p21a<br>d56p41a | D56P11A<br>D56P12A<br>D56P21A<br>D56P41A | — |
| 57 | Regirock Chamber Idx | d57p21a<br>d57p41a<br>d57p42a<br>d57p43a<br>d57p44a | D57P21A<br>D57P41A<br>D57P42A<br>D57P43A<br>D57P44A | — |
| 58 | Steel Aegis Cave Idx | d58p41a | — | — |
| 59 | Registeel Chamber Idx | d59p41a | — | — |
| 60 | Aegis Cave Pit Idx | d60p41a | — | — |
| 61 | Regigigas Chamber Idx | d61p41a | — | — |
| 62 | Mt Travail Idx | d62p41a | — | — |
| 63 | The Nightmare Idx | d63p41a | D63P41A | — |
| 64 | Spacial Rift Idx | — | — | — |
| 65 | Deep Spacial Rift Idx | d65p41a | D65P41A | — |
| 66 | Spacial Rift Bottom Idx | d66p41a | D66P41A | — |
| 67 | Dark Crater Idx | d67p41a | D67P41A | — |
| 68 | Deep Dark Crater Idx | d68p41a | D68P41A | — |
| 69 | Dark Crater Pit Idx | d69p41a | D69P41A | — |
| 70 | Concealed Ruins Idx | d70p41a | D70P41A | — |
| 71 | Deep Concealed Ruins Idx | d71p41a | D71P41A | — |
| 72 | Marine Resort Idx | d72p41a | — | — |
| 73 | Bottomless Sea Idx | d73p11a<br>d73p21a<br>d73p22a<br>d73p23a<br>d73p24a<br>d73p25a<br>d73p26a<br>d73p27a<br>d73p28a<br>d73p29a<br>d73p31a<br>d73p41a | D73P11A<br>D73P21A<br>D73P22A<br>D73P23A<br>D73P24A<br>D73P25A<br>D73P26A<br>D73P27A<br>D73P28A<br>D73P29A<br>D73P31A<br>D73P41A | — |
| 74 | Bottomless Sea Depths Idx | — | — | — |
| 75 | Shimmer Desert Idx | — | — | — |
| 76 | Shimmer Desert Pit Idx | — | — | — |
| 77 | Mt Avalanche Idx | — | — | — |
| 78 | Mt Avalanche Peak Idx | — | — | — |
| 79 | Giant Volcano Idx | d79p11a<br>d79p21a<br>d79p41a | D79P11A<br>D79P21A<br>D79P41A | — |
| 80 | Giant Volcano Peak Idx | d80p41a | D80P41A | — |
| 81 | World Abyss Idx | d81p41a | D81P41A | — |
| 82 | World Abyss Pit Idx | d82p41a | D82P41A | — |
| 83 | Sky Stairway Idx | d83p41a | D83P41A | — |
| 84 | Sky Stairway Apex Idx | d84p41a | D84P41A | — |
| 85 | Mystery Jungle Idx | d85p41a | D85P41A | — |
| 86 | Deep Mystery Jungle Idx | d86p41a | D86P41A | — |
| 87 | Serenity River Idx | d87p41a | D87P41A | — |
| 88 | Landslide Cave Idx | d88p41a | D88P41A | — |
| 89 | Lush Prairie Idx | d89p41a | D89P41A | — |
| 90 | Tiny Meadow Idx | d90p41a | D90P41A | — |
| 91 | Labyrinth Cave Idx | d91p41a | — | — |
| 92 | Oran Forest Idx | d92p41a | — | — |
| 93 | Lake Afar Idx | d93p41a | — | — |
| 94 | Happy Outlook Idx | d94p41a | — | — |
| 95 | My Mistral Idx | d95p41a | — | — |
| 96 | Shimmer Hill Idx | — | — | — |
| 97 | Lost Wilderness Idx | — | — | — |
| 98 | Midnight Forest Idx | — | — | — |
| 99 | Zero Isle North Idx | — | — | — |
| 100 | Zero Isle East Idx | — | — | — |
| 101 | Zero Isle West Idx | — | — | — |
| 102 | Zero Isle South Idx | — | — | — |
| 103 | Zero Isle Center Idx | — | — | — |
| 104 | Destiny Tower Idx | — | — | — |
| 107 | Oblivion Forest Idx | — | — | — |
| 108 | Treacherous Waters Idx | — | — | — |
| 109 | Southeastern Islands Idx | — | — | — |
| 110 | Inferno Cave Idx | — | — | — |
| 111 | 1St Station Pass Idx | — | — | — |
| 112 | 2Nd Station Pass Idx | — | — | — |
| 113 | 3Rd Station Pass Idx | — | — | — |
| 114 | 4Th Station Pass Idx | — | — | — |
| 115 | 5Th Station Pass Idx | — | — | — |
| 116 | 6Th Station Pass Idx | — | — | — |
| 117 | 7Th Station Pass Idx | — | — | — |
| 118 | 8Th Station Pass Idx | — | — | — |
| 119 | 9Th Station Pass Idx | — | — | — |
| 120 | Sky Peak Summit Pass Idx | — | — | — |
| 121 | 5Th Station Clearing Idx | — | — | — |
| 122 | Sky Peak Summit Idx | — | — | — |
| 123 | Star Cave Se1 Idx | — | — | — |
| 124 | Deep Star Cave Idx | — | — | — |
| 125 | Deep Star Cave Team Rogue Idx | — | — | — |
| 126 | Star Cave Depths Idx | — | — | — |
| 127 | Star Cave Pit Idx | — | — | — |
| 128 | Murky Forest Idx | — | — | — |
| 129 | Eastern Cave Idx | — | — | — |
| 130 | Fortune Ravine Idx | — | — | — |
| 131 | Fortune Ravine Depths Idx | — | — | — |
| 132 | Fortune Ravine Pit Idx | — | — | — |
| 133 | Barren Valley Idx | — | — | — |
| 134 | Deep Barren Valley Idx | — | — | — |
| 135 | Barren Valley Clearing Idx | — | — | — |
| 136 | Dark Wasteland Idx | — | — | — |
| 137 | Temporal Tower Se5 Idx | — | — | — |
| 138 | Temporal Spire Se5 Idx | — | — | — |
| 139 | Dusk Forest Se5 Idx | — | — | — |
| 140 | Black Swamp Idx | — | — | — |
| 141 | Spacial Cliffs Idx | — | — | — |
| 142 | Dark Ice Mountain Idx | — | — | — |
| 143 | Dark Ice Mountain Peak Idx | — | — | — |
| 144 | Dark Ice Mountain Pinnacle Idx | — | — | — |
| 145 | Icicle Forest Idx | — | — | — |
| 146 | Vast Ice Mountain Idx | — | — | — |
| 147 | Vast Ice Mountain Peak Idx | — | — | — |
| 148 | Vast Ice Mountain Pinnacle Idx | — | — | — |
| 149 | Southern Jungle Idx | — | — | — |
| 150 | Boulder Quarry Idx | — | — | — |
| 151 | Deep Boulder Quarry Idx | — | — | — |
| 152 | Boulder Quarry Clearing Idx | — | — | — |
| 153 | Right Cave Path Idx | — | — | — |
| 154 | Left Cave Path Idx | — | — | — |
| 155 | Limestone Cavern Idx | — | — | — |
| 156 | Deep Limestone Cavern Idx | — | — | — |
| 157 | Limestone Cavern Depths Idx | — | — | — |
| 158 | Spring Cave Idx | — | — | — |
| 159 | Upper Spring Cave Haunter Idx | — | — | — |
| 160 | Upper Spring Cave Idx | — | — | — |
| 161 | Middle Spring Cave Idx | — | — | — |
| 162 | Lower Spring Cave Idx | — | — | — |
| 163 | Spring Cave Depths Idx | — | — | — |
| 164 | Spring Cave Pit Idx | — | — | — |
| 165 | Little Plains Idx | — | — | — |
| 166 | Mt Clear Idx | — | — | — |
| 167 | Challenge River Idx | — | — | — |
| 168 | Trial Forest Idx | — | — | — |
| 169 | Guiding Sea Idx | — | — | — |
| 170 | Hidden Shopkeeper Village Idx | — | — | — |
| 174 | Star Cave Idx | — | — | — |
| 175 | Shaymin Village Idx | — | — | — |
| 176 | Armaldos Shelter Idx | — | — | — |
| 177 | Luminous Spring Idx | — | — | — |
| 178 | Hot Spring Idx | — | — | — |
| 179 | Rescue Idx | — | — | — |
| 180 | Normal Fly Maze Idx | — | — | — |
| 181 | Dark Fire Maze Idx | — | — | — |
| 182 | Rock Water Maze Idx | — | — | — |
| 183 | Grass Maze Idx | — | — | — |
| 184 | Elec Steel Maze Idx | — | — | — |
| 185 | Ice Ground Maze Idx | — | — | — |
| 186 | Fight Psych Maze Idx | — | — | — |
| 187 | Poison Bug Maze Idx | — | — | — |
| 188 | Dragon Maze Idx | — | — | — |
| 189 | Ghost Maze Idx | — | — | — |
| 190 | Explorer Maze Idx | — | — | — |
| 191 | Final Maze Idx | — | — | — |

---

## SECTION SPÉCIALE — AEGIS CAVE (remplace les Ruines Tordues / cloven_ruins ch5)

> **MISE À JOUR 2026-08-07 — RÉVISION CRITIQUE.** La conversion initiale
> (19 grounds depuis files/MAP_BG/d54…d61, commit 2180945) partait de
> l'hypothèse « numéro de donjon == numéro de groupe de cartes ».
> Vérification faite sur les scènes SSB du jeu (désassemblées via
> skytemple-files, to_explorerscript) : **cette hypothèse est fausse** pour
> la plage d50-d61. Les cartes converties sont des donjons d'épisodes
> spéciaux, PAS Aegis Cave :
>
> | Groupe MAP_BG | Identité réelle (preuve) |
> |---|---|
> | d50 | Falaises Spatiales (ES5) — n08a2608 « entrée des Falaises Spatiales » |
> | d51-d52 | Mont de Glace Sombre / Forêt de Givre (ES5) — palettes glace, scènes n09 |
> | d53 | Mont de Glace Immense / Pinnacle (ES5) — n09a1801 : Primal Dialga « GIGI GIGIGIGI » |
> | d54 | Jungle Méridionale (ES4) — n06a0501 : « Nous sommes sorties de la Jungle Méridionale », BGM_SOUTHERN_JUNGLE |
> | d55 | Carrière Rocher (ES4) — BGM_BOULDER_QUARRY, n06a3401 coffre vide / Team AWD |
> | d56 | Caverne Calcaire (ES4) — n06a2802 : « I-in a limestone cavern! », BGM_LIMESTONE_CAVERN |
> | d57 | Mont Travail (ES3, Sunflora/Haunter) — n04a2001 : « Je vais t'arrêter, Haunter ! », « hot hot hot! » |
> | d58-d61 | **Un seul template** (md5 identiques .bma/.bpc/.bpl) — pas 4 salles distinctes |
>
> Les vrais étages fixes d'Aegis Cave (chambres des Regi, salles Zarbi,
> fond du puits) ne sont pas extractibles de ce dépôt : la table
> (donjon, étage) → (groupe de cartes, map) vit dans `DUNGEON/dungeon.bin`,
> absent de pret/pmd-sky. **Les 19 grounds convertis ont été purgés vers
> `RESERVE/aegis_non_canonique/`** (voir le README sur place).
> `tools/convert_sky_aegis.py` est conservé mais marqué NON CANONIQUE.

### Ordre canonique des boss (EoS) — CE QUI EST INTÉGRÉ DANS cloven_ruins

| Étape | Labyrinthe | Chambre | Boss | Mot Zarbi (plaques) | Dans le mod |
|---|---|---|---|---|---|
| 1 | Ice Aegis Cave B1-B3 | Regice Chamber | **Regice** | G-L-A-C-E (ICE) | segment 0 → 1 (`cloven_ruins_regice.rsmap`) |
| 2 | Rock Aegis Cave B1-B3 | Regirock Chamber | **Regirock** | R-O-C-H-E (ROCK) | segment 2 → 3 (`cloven_ruins_regirock.rsmap`) |
| 3 | Steel Aegis Cave B1-B4 | Registeel Chamber | **Registeel** | A-C-I-E-R (STEEL) | segment 4 → 5 (`cloven_ruins_registeel.rsmap`) |
| 4 | Aegis Cave Pit B1-B5 | Regigigas Chamber | **Regigigas** + 4 Hitmonlee + 4 Bronzong | (aucune — combat direct) | segment 6 → 7 (`sanctuaire_titans.rsmap`) |

Sources canoniques vérifiées : Serebii (Ice Maze B3F / Rock Maze B3F /
Steel Maze B4F / Deepest Part B5F ; Unown sur IM B1-B3, RM B1-B3,
SM B1-B4, DP B1-B5 ; boss Regice → Regirock → Registeel → Regigigas +
4 Hitmonlee + 4 Bronzong) ; textes du jeu (text_e.str : les 8 noms de
sous-donjons dans cet ordre).

### Mécanique des plaques Unown (Zarbi) — DÉJÀ INTÉGRÉE

`Data/Script/halcyon/RuinesZarbi.lua` reproduit fidèlement EoS :
- chaque labyrinthe ne livre la chambre QUE si le mot est épelé ;
- les Zarbi vaincus laissent PARFOIS leur pierre (drop aléatoire, lettres
  utiles au secteur en cours) — items `ruines_pierre_a/c/e/g/h/i/l/o/r`
  présents dans Data/Item (+ index.idx) ;
- tablette au camp : lecture des cavités → « fermer les yeux » → le mot
  s'illumine → l'escalier vers l'arène apparaît ;
- tant que le mot est incomplet, le donjon BOUCLE (retour au camp) ;
- le mot reste acquis après une défaite : on retraverse et on retrouve le
  gardien, sans re-collecter les pierres (comportement EoS).

### Scènes SSB — statut

Les scènes `n06a####`/`n04a####` des dossiers D54-D57 sont des scènes
d'épisodes spéciaux (Team Charm, Sunflora, Bidoof), PAS les cinématiques
d'Aegis Cave. Les scènes des vraies salles d'Aegis (D61P41A = chambre de
Regigigas) n'existent pas dans les SCRIPT/ du dépôt. La finale du mod vit
dans `RuinesTitan.lua` (éveil, huit gardes, renversement, question de
Regigigas, mise en statue, effondrement, fuite) puis `RuinesRenforts.lua`
(révélation de la Tour au camp) — conforme au cahier des charges du ch5.

### Musique

`MUSIC_AEGIS_CAVE` (dungeon.h:2567) = piste « In the Depths of the Pit »
dans EoS. Le mod possède déjà `Content/Music/Aegis Cave.ogg` et l'utilise
sur les segments 0-6 de cloven_ruins ; `Boss Battle!.ogg` sur le segment 7.

---

## IMPORT COMPLET SKY — 186 maps de donjon (2026-08-07)

> Généré par `tools/convert_sky_all.py` depuis pret/pmd-sky `files/MAP_BG/`
> (BPL/BPC/BMA/BPA via skytemple-files 1.8.5). Rendu SANS overlay de debug
> (include_collision=False, include_unknown_data_block=False), TOUTES les
> frames d'animation encodées par tuile (période locale, FrameLength 8 sur
> maps animées / 60 sinon), collision BMA source (par tuile ou chunk 3x3,
> bordure bloquée sinon), marqueur Main_Entrance_Marker sur zone libre.

| Indicateur | Valeur |
|---|---|
| Maps converties | 186 |
| Maps animées (frames > 1) | 37 |
| Frames max par map | 16 (d53p41b) |
| Poids .rsground | 214 Mo |
| Poids planches .tile | 59 Mo |
| Dépôt | RESERVE/sky_grounds/ + RESERVE/sky_tiles/ (format PMDO, restituable) |

### Table des 186 maps

| Map | Identité canonique (scènes SSB : BGM/lieux) | Cellules | Frames | Poids |
|---|---|---|---|---|
| d00p01 | *(à confirmer)* | 57x57 | 1 | 0.6 Mo |
| d00p02 | *(à confirmer)* | 57x57 | 1 | 0.6 Mo |
| d01p11a | Hautes Terres Cachées [HIDDEN_HIGHLAND] | 99x48 | 16 | 1.2 Mo |
| d01p11b | Terre Cachée (Hidden Land) | 99x48 | 16 | 1.2 Mo |
| d01p41a | Grotte Plage (Beach Cave) | 57x60 | 16 | 0.9 Mo |
| d02p11a | Falaise Trempée [DRENCHED_BLUFF] | 66x51 | 1 | 0.7 Mo |
| d02p31a | Falaise Trempée (Drenched Bluff) | 60x48 | 1 | 0.6 Mo |
| d03p11a | Mont Bristle [MT_BRISTLE] | 69x60 | 1 | 0.8 Mo |
| d03p41a | Mont Bristle (Mt. Bristle) | 87x81 | 1 | 1.4 Mo |
| d04p11a | Rain2 (BGM) | 63x57 | 1 | 0.7 Mo |
| d04p12a | Grotte Cascade [WATERFALL_CAVE] | 51x69 | 12 | 0.8 Mo |
| d04p31a | Rain2 (BGM) | 63x54 | 16 | 1.1 Mo |
| d05p11a | Bois Pommier [APPLE_WOODS] | 69x51 | 1 | 0.7 Mo |
| d05p31a | Bois Pommier (Apple Woods) | 69x69 | 1 | 0.9 Mo |
| d06p11a | Côte Escarpée [CRAGGY_COAST] | 69x54 | 6 | 0.7 Mo |
| d07p11a | Mont Corne [MT_HORN] | 69x45 | 1 | 0.6 Mo |
| d08p11a | Forêt Brumeuse [FOGGY_FOREST] | 75x99 | 1 | 1.5 Mo |
| d09p11a | Grotte Vapeur [STEAM_CAVE] | 63x63 | 1 | 0.8 Mo |
| d10p21a | Haute Grotte Vapeur [UPPER_STEAM_CAVE] | 57x57 | 1 | 0.6 Mo |
| d10p41a | Grotte Vapeur [STEAM_CAVE] | 81x78 | 1 | 1.2 Mo |
| d11p11a | Plaines Amp [AMP_PLAINS] | 57x51 | 1 | 0.6 Mo |
| d12p21a | Ampériques Lointaines [FAR_AMP_PLAINS] | 57x57 | 1 | 0.6 Mo |
| d12p41a | Plaines Amp (Amp Plains) | 69x63 | 1 | 0.9 Mo |
| d13p11a | Désert Boréal [NORTHERN_DESERT] | 57x57 | 1 | 0.6 Mo |
| d14p11a | Lac des Brumes (Fogbound Lake) | 57x48 | 6 | 0.7 Mo |
| d14p12a | Grotte des Sables [QUICKSAND_CAVE] | 75x51 | 4 | 0.8 Mo |
| d15p21a | Gouffre des Sables [QUICKSAND_PIT] | 57x57 | 1 | 0.6 Mo |
| d15p41a | Lac des Brumes (Fogbound Lake) | 75x75 | 16 | 1.7 Mo |
| d16p11a | Grotte Cristal [CRYSTAL_CAVE] | 75x51 | 16 | 0.8 Mo |
| d16p31a | Lac Cristal (Shining Lake) | 75x60 | 16 | 1.0 Mo |
| d17p11a | Croisement Cristal [CRYSTAL_CROSSING] | 75x60 | 16 | 1.0 Mo |
| d17p31a | Croisement Cristal (Crystal Crossing) | 45x51 | 1 | 0.5 Mo |
| d17p32a | Croisement Cristal (Crystal Crossing) | 51x57 | 1 | 0.6 Mo |
| d17p33a | Croisement Cristal (Crystal Crossing) | 57x63 | 1 | 0.7 Mo |
| d17p34a | Croisement Cristal (Crystal Crossing) | 87x75 | 1 | 1.3 Mo |
| d17p45a | Croisement Cristal (Crystal Crossing) | 87x63 | 1 | 1.1 Mo |
| d18p11a | Gouffre [CHASM_CAVE] | 75x48 | 1 | 0.7 Mo |
| d19p11a | Colline Sombre [DARK_HILL] | 96x48 | 1 | 0.9 Mo |
| d20p11a | Ruine Scellée [SEALED_RUIN] | 75x48 | 1 | 0.7 Mo |
| d21p21a | Gouffre de la Ruine Scellée [SEALED_RUIN_PIT] | 57x57 | 1 | 0.6 Mo |
| d21p41a | Sealed Ruin Pit (BGM) | 81x66 | 1 | 1.1 Mo |
| d22p11a | Forêt Crépusculaire [DUSK_FOREST] | 69x69 | 1 | 0.9 Mo |
| d23p11a | Forêt Crépusculaire Profonde [DEEP_DUSK_FOREST] | 69x69 | 1 | 0.9 Mo |
| d24p11a | Forêt des Cimes [TREESHROUD_FOREST] | 63x54 | 1 | 0.7 Mo |
| d24p31a | Forêt des Cimes (Treeshroud Forest) | 63x60 | 1 | 0.7 Mo |
| d24p31b | Treeshroud Forest (BGM) | 63x60 | 1 | 0.7 Mo |
| d25p11a | Grotte Saumure [BRINE_CAVE] | 81x63 | 15 | 2.0 Mo |
| d26p21a | Basse Grotte Saumure [LOWER_BRINE_CAVE] | 57x57 | 1 | 0.6 Mo |
| d26p31a | Lower Brine Cave (BGM) | 69x93 | 4 | 1.3 Mo |
| d26p43a | Terre Cachée (Hidden Land) | 69x93 | 4 | 1.3 Mo |
| d27p11a | Terre Cachée [HIDDEN_LAND] | 57x69 | 4 | 0.8 Mo |
| d28p21a | Hautes Terres Cachées [HIDDEN_HIGHLAND] | 57x57 | 1 | 0.6 Mo |
| d28p31a | Hautes Terres Cachées [HIDDEN_HIGHLAND] | 102x45 | 1 | 0.9 Mo |
| d28p32a | Hautes Terres Cachées [HIDDEN_HIGHLAND] | 60x54 | 1 | 0.6 Mo |
| d28p33a | Hautes Terres Cachées [HIDDEN_HIGHLAND] | 75x54 | 1 | 0.8 Mo |
| d28p33c | Tour Temporelle (Temporal Tower) | 75x54 | 1 | 0.8 Mo |
| d28p34a | Tour Temporelle (Temporal Tower) | 81x66 | 1 | 1.1 Mo |
| d28p44a | Hautes Terres Cachées [HIDDEN_HIGHLAND] | 63x66 | 1 | 0.8 Mo |
| d29p11a | Tour Temporelle [TEMPORAL_TOWER] | 75x69 | 16 | 1.9 Mo |
| d30p21a | Flèche Temporelle [TEMPORAL_SPIRE] | 57x57 | 1 | 0.6 Mo |
| d30p32a | Tour Temporelle (Temporal Tower) | 69x72 | 12 | 1.0 Mo |
| d30p33a | Tour Temporelle (Temporal Tower) | 69x72 | 7 | 1.0 Mo |
| d30p34a | Tour Temporelle (Temporal Tower) | 69x72 | 7 | 1.0 Mo |
| d30p41a | Pinacle Temporel [TEMPORAL_PINNACLE] | 69x72 | 7 | 1.0 Mo |
| d30p42a | Tour Temporelle (Temporal Tower) | 69x72 | 12 | 1.0 Mo |
| d31p11a | Forêt Mystifiante [MYSTIFYING_FOREST] | 75x63 | 1 | 0.9 Mo |
| d31p31a | Forêt Mystifiante (Mystifying Forest) | 57x63 | 1 | 0.7 Mo |
| d31p41a | Forêt Mystifiante (Mystifying Forest) | 69x63 | 1 | 0.9 Mo |
| d32p11a | Aegis Cave [AEGIS_CAVE] | 126x57 | 1 | 1.4 Mo |
| d32p12a | Ruines Cachées (Concealed Ruins) | 126x57 | 1 | 1.4 Mo |
| d32p13a | Ruines Cachées (Concealed Ruins) | 126x57 | 1 | 1.4 Mo |
| d32p14a | Terre Cachée [HIDDEN_LAND] | 72x51 | 1 | 0.7 Mo |
| d32p31a | Ruine Scellée [SEALED_RUIN] | 114x57 | 1 | 1.3 Mo |
| d32p32a | Ruine Scellée [SEALED_RUIN] | 114x57 | 1 | 1.3 Mo |
| d32p33a | Ruine Scellée [SEALED_RUIN] | 114x57 | 1 | 1.3 Mo |
| d32p41a | Ruines Cachées (Concealed Ruins) | 180x120 | 1 | 4.3 Mo |
| d32p42a | Ruines Cachées (Concealed Ruins) | 180x120 | 1 | 4.3 Mo |
| d32p43a | Ruines Cachées (Concealed Ruins) | 180x120 | 1 | 4.3 Mo |
| d32p44a | Basse Grotte Saumure [LOWER_BRINE_CAVE] | 75x81 | 1 | 1.2 Mo |
| d33p41a | Fond de la Mer Miracle (Miracle Seabed) | 180x120 | 1 | 4.3 Mo |
| d34p41a | Mont Travail (Mt. Travail) | 57x57 | 1 | 0.6 Mo |
| d35p21a | Mer Miracle [MIRACLE_SEA] | 57x57 | 1 | 0.6 Mo |
| d35p41a | Forêt Mystifiante [MYSTIFYING_FOREST] | 180x120 | 1 | 4.3 Mo |
| d36p11a | Mont Travail [MT_TRAVAIL] | 51x36 | 1 | 0.4 Mo |
| d36p41a | Mont Travail (Mt. Travail) | 63x60 | 1 | 0.7 Mo |
| d37p11a | Welcome To The World Of Pokemon (BGM) | 60x60 | 1 | 0.7 Mo |
| d37p41a | Welcome To The World Of Pokemon (BGM) | 57x57 | 1 | 0.6 Mo |
| d38p11a | Gouffre de la Ruine Scellée [SEALED_RUIN_PIT] | 60x57 | 1 | 0.7 Mo |
| d38p12a | Gouffre [CHASM_CAVE] | 57x57 | 1 | 0.6 Mo |
| d39p21a | Ruine Scellée [SEALED_RUIN] | 57x57 | 1 | 0.6 Mo |
| d39p32a | Gouffre de la Ruine Scellée [SEALED_RUIN_PIT] | 60x60 | 1 | 0.7 Mo |
| d39p41a | Cratère des Ténèbres (Dark Crater) | 180x120 | 1 | 4.3 Mo |
| d40p11a | Cratère des Ténèbres [DARK_CRATER] | 45x57 | 16 | 0.5 Mo |
| d41p21a | Cratère des Ténèbres Profond [DEEP_DARK_CRATER] | 57x57 | 1 | 0.6 Mo |
| d41p41a | Hautes Terres Cachées [HIDDEN_HIGHLAND] | 69x72 | 13 | 2.9 Mo |
| d42p21a | Grotte Étoile Profonde [DEEP_STAR_CAVE] | 57x57 | 1 | 0.6 Mo |
| d42p31a | Grotte Étoile (Star Cave) | 126x63 | 16 | 1.7 Mo |
| d42p41a | Grotte Étoile (Star Cave) | 63x63 | 16 | 0.9 Mo |
| d42p42a | Grotte Étoile (Star Cave) | 63x57 | 16 | 0.8 Mo |
| d43p31a | Rising Fear (BGM) | 51x54 | 1 | 0.5 Mo |
| d44p31a | Fire Crackling (BGM) | 114x69 | 16 | 1.6 Mo |
| d45p21a | Profondeurs du Ravin [FORTUNE_RAVINE_DEPTHS] | 57x57 | 1 | 0.6 Mo |
| d45p31a | Fortune Ravine Depths (BGM) | 102x51 | 1 | 1.0 Mo |
| d45p42a | Fortune Ravine Depths (BGM) | 63x63 | 1 | 0.8 Mo |
| d46p11a | Vallée Stérile [BARREN_VALLEY] | 57x51 | 1 | 0.6 Mo |
| d46p21a | Vallée Stérile [BARREN_VALLEY] | 57x57 | 1 | 0.6 Mo |
| d46p31a | Hautes Terres Cachées [HIDDEN_HIGHLAND] | 57x63 | 1 | 0.7 Mo |
| d46p41a | Tour Temporelle (Temporal Tower) | 57x63 | 1 | 0.7 Mo |
| d47p11a | Terre Dévastée [DARK_WASTELAND] | 57x36 | 1 | 0.4 Mo |
| d48p11a | Tour Temporelle [TEMPORAL_TOWER] | 75x69 | 1 | 1.0 Mo |
| d48p21a | Flèche Temporelle [TEMPORAL_SPIRE] | 57x57 | 1 | 0.6 Mo |
| d49p41a | Abîme du Monde (World Abyss) | 57x54 | 1 | 0.6 Mo |
| d50p11a | Falaises Spatiales [SPACIAL_CLIFFS] | 63x45 | 1 | 0.6 Mo |
| d51p11a | Mont de Glace Sombre [DARK_ICE_MOUNTAIN] | 63x39 | 1 | 0.5 Mo |
| d51p21a | Mont de Glace Sombre [DARK_ICE_MOUNTAIN] | 57x57 | 1 | 0.6 Mo |
| d51p41a | Pinacle Temporel [TEMPORAL_PINNACLE] | 63x51 | 1 | 0.6 Mo |
| d52p11a | Forêt de Givre [ICICLE_FOREST] | 63x51 | 1 | 0.6 Mo |
| d52p11c | Forêt de Givre (Icicle Forest) | 63x51 | 1 | 0.6 Mo |
| d52p31a | Forêt de Givre (Icicle Forest) | 63x51 | 1 | 0.6 Mo |
| d52p32a | Hautes Terres Cachées [HIDDEN_HIGHLAND] | 63x63 | 1 | 0.8 Mo |
| d53p11a | Mont de Glace Immense [VAST_ICE_MOUNTAIN] | 63x45 | 1 | 0.6 Mo |
| d53p11b | Vast Ice Mountain Peak (BGM) | 63x45 | 1 | 0.6 Mo |
| d53p21a | Vast Ice Mountain Peak (BGM) | 57x57 | 1 | 0.6 Mo |
| d53p41a | Vast Ice Mountain Peak (BGM) | 63x60 | 1 | 0.7 Mo |
| d53p41b | Vast Ice Mountain Peak (BGM) | 63x60 | 16 | 3.7 Mo |
| d53p41c | Vast Ice Mountain Peak (BGM) | 63x60 | 1 | 0.7 Mo |
| d54p11a | Jungle Méridionale [SOUTHERN_JUNGLE] | 63x54 | 1 | 0.7 Mo |
| d54p31a | Jungle Méridionale — sortie (ES4, n06a0501) | 63x57 | 1 | 0.7 Mo |
| d54p32a | Antichambre ES4 (Team Charm, n06a0502) | 75x57 | 1 | 0.8 Mo |
| d55p11a | Carrière Rocher [BOULDER_QUARRY] | 69x63 | 1 | 0.9 Mo |
| d55p21a | Carrière Rocher [BOULDER_QUARRY] | 57x57 | 1 | 0.6 Mo |
| d55p41a | Thème de l'Équipe Charme [TEAM_CHARMS_THEME] | 63x57 | 1 | 0.7 Mo |
| d56p11a | Salle de la Pierre Illusoire [ILLUSION_STONE_CHAMBER] | 63x51 | 1 | 0.6 Mo |
| d56p12a | Caverne Calcaire [LIMESTONE_CAVERN] | 39x42 | 16 | 0.5 Mo |
| d56p21a | Caverne Calcaire Profonde [DEEP_LIMESTONE_CAVERN] | 57x57 | 1 | 0.6 Mo |
| d56p41a | Salle du coffre ES4 (Team Charm, n06a3401) | 57x60 | 12 | 1.1 Mo |
| d57p21a | Profondeurs de la Grotte Source [SPRING_CAVE_DEPTHS] | 57x57 | 1 | 0.6 Mo |
| d57p41a | Heavy Wind2 (BGM) | 57x57 | 1 | 0.6 Mo |
| d57p42a | Heavy Wind2 (BGM) | 57x66 | 16 | 0.8 Mo |
| d57p43a | Grotte Source — poursuite Haunter (ES3, n04a2001) | 114x57 | 16 | 1.9 Mo |
| d57p44a | Grotte Source — fond chaud (ES3, n04a2501/2601) | 57x57 | 16 | 1.1 Mo |
| d58p41a | *(à confirmer)* | 57x57 | 1 | 0.6 Mo |
| d59p41a | *(à confirmer)* | 57x57 | 1 | 0.6 Mo |
| d60p41a | *(à confirmer)* | 57x57 | 1 | 0.6 Mo |
| d61p41a | *(à confirmer)* | 57x57 | 1 | 0.6 Mo |
| d62p41a | Dojo d'Ossatueur (Marowak Dojo) | 57x57 | 1 | 0.6 Mo |
| d63p41a | Tour du Destin (Destiny Tower) | 57x57 | 1 | 0.6 Mo |
| d65p41a | Volcan Géant (Giant Volcano) | 180x120 | 1 | 4.3 Mo |
| d66p41a | Désert Scintillant (Shimmer Desert) | 180x120 | 1 | 4.3 Mo |
| d67p41a | Mont Avalanche (Mt. Avalanche) | 180x120 | 1 | 4.3 Mo |
| d68p41a | Mer sans Fond (Bottomless Sea) | 180x120 | 1 | 4.3 Mo |
| d69p41a | Abîme du Monde (World Abyss) | 180x120 | 1 | 4.3 Mo |
| d70p41a | Jungle Mystère (Mystery Jungle) | 180x120 | 1 | 4.3 Mo |
| d71p41a | Escalier du Ciel (Sky Stairway) | 180x120 | 1 | 4.3 Mo |
| d72p41a | Pré Fleuri (Tiny Meadow) | 180x120 | 1 | 4.3 Mo |
| d73p11a | Village Shaymin (Shaymin Village) | 81x69 | 1 | 1.1 Mo |
| d73p21a | Forêt du Pic du Ciel [SKY_PEAK_FOREST] | 57x63 | 1 | 0.7 Mo |
| d73p22a | Grotte du Pic du Ciel [SKY_PEAK_CAVE] | 57x63 | 1 | 0.7 Mo |
| d73p23a | Prairie du Pic du Ciel [SKY_PEAK_PRAIRIE] | 57x63 | 1 | 0.7 Mo |
| d73p24a | Prairie du Pic du Ciel [SKY_PEAK_PRAIRIE] | 57x63 | 1 | 0.7 Mo |
| d73p25a | Prairie du Pic du Ciel [SKY_PEAK_PRAIRIE] | 57x57 | 1 | 0.6 Mo |
| d73p26a | Champs de Neige du Pic du Ciel [SKY_PEAK_SNOWFIELD] | 57x63 | 1 | 0.7 Mo |
| d73p27a | Champs de Neige du Pic du Ciel [SKY_PEAK_SNOWFIELD] | 57x57 | 1 | 0.6 Mo |
| d73p28a | Village Shaymin (Shaymin Village) | 57x63 | 4 | 0.7 Mo |
| d73p29a | Dernier Col du Pic du Ciel [SKY_PEAK_FINAL_PASS] | 57x57 | 1 | 0.6 Mo |
| d73p31a | Pic du Ciel (Sky Peak) | 63x63 | 4 | 1.0 Mo |
| d73p41a | Pic du Ciel (Sky Peak) | 63x63 | 8 | 0.8 Mo |
| d79p11a | Grotte de la Faille (Crevice Cave) | 75x63 | 1 | 0.9 Mo |
| d79p21a | Grotte de la Faille (Crevice Cave) | 57x57 | 1 | 0.6 Mo |
| d79p41a | Grotte de la Faille (Crevice Cave) | 180x120 | 1 | 4.3 Mo |
| d80p41a | Grotte du Labyrinthe (Labyrinth Cave) | 180x120 | 1 | 4.3 Mo |
| d81p41a | Belvédère (Happy Outlook) | 57x57 | 1 | 0.6 Mo |
| d82p41a | Mont Mistral | 57x57 | 1 | 0.6 Mo |
| d83p41a | Colline Scintillante (Shimmer Hill) | 57x57 | 1 | 0.6 Mo |
| d84p41a | Terre Sauvage Perdue (Lost Wilderness) | 57x57 | 1 | 0.6 Mo |
| d85p41a | Forêt de Minuit (Midnight Forest) | 57x57 | 1 | 0.6 Mo |
| d86p41a | Île Zéro Nord (Zero Isle North) | 57x57 | 1 | 0.6 Mo |
| d87p41a | Île Zéro Est (Zero Isle East) | 57x57 | 1 | 0.6 Mo |
| d88p41a | Île Zéro Ouest (Zero Isle West) | 57x57 | 1 | 0.6 Mo |
| d89p41a | Île Zéro Sud (Zero Isle South) | 57x57 | 1 | 0.6 Mo |
| d90p41a | Île Zéro Centre (Zero Isle Center) | 57x57 | 1 | 0.6 Mo |
| d91p41a | Tour du Destin (Destiny Tower) | 90x60 | 1 | 1.1 Mo |
| d92p41a | Petites Plaines (Little Plains) | 90x60 | 1 | 1.1 Mo |
| d93p41a | Mont Clair (Mt. Clear) | 90x60 | 1 | 1.1 Mo |
| d94p41a | Rivière Défi (Challenge River) | 90x60 | 1 | 1.1 Mo |
| d95p41a | Forêt d'Épreuve (Trial Forest) | 90x60 | 1 | 1.1 Mo |

### Identités par groupe (synthèse des scènes SSB décompilées)

| Groupe | Donjon canonique | Preuves |
|---|---|---|
| d01 | Grotte Plage | BGM_IN_THE_DEPTHS_OF_THE_PIT |
| d02 | Falaise Trempée | BGM_DRENCHED_BLUFF |
| d03 | Mont Bristle | BGM_MT_BRISTLE |
| d04 | Grotte Cascade | BGM_WATERFALL_CAVE ; "That water's pounding down!" |
| d05 | Bois Pommier | BGM_APPLE_WOODS ; lieu "Apple Woods" |
| d06 | Côte Escarpée | BGM_CRAGGY_COAST |
| d07 | Mont Corne | BGM_MT_HORN ; lieu "Mt. Horn" |
| d08 | Forêt Brumeuse / Lac des Brumes | BGM_FOGGY_FOREST ; lieu "Fogbound Lake" |
| d09 | Grotte Vapeur | BGM_STEAM_CAVE |
| d10 | Haute Grotte Vapeur | BGM_UPPER_STEAM_CAVE ; "We've climbed way up high!" |
| d11 | Plaines Amp | BGM_AMP_PLAINS |
| d12 | Ampériques Lointaines | BGM_FAR_AMP_PLAINS |
| d13 | Désert Boréal | BGM_NORTHERN_DESERT ; "If a Time Gear really is here" |
| d14 | Grotte des Sables | BGM_QUICKSAND_CAVE ; "It's quicksand!" |
| d15 | Gouffre des Sables | BGM_QUICKSAND_PIT |
| d16 | Grotte Cristal | BGM_CRYSTAL_CAVE ; "So this is Crystal Cave!" |
| d17 | Croisement Cristal | BGM_CRYSTAL_CROSSING |
| d18 | Gouffre (Chasm Cave) | BGM_CHASM_CAVE |
| d19 | Colline Sombre | BGM_DARK_HILL |
| d20 | Ruine Scellée | BGM_SEALED_RUIN |
| d21 | Ruine Scellée Profonde | BGM_SEALED_RUIN_PIT |
| d22 | Forêt Crépusculaire | BGM_DUSK_FOREST |
| d23 | Forêt Crépusculaire Profonde | BGM_DEEP_DUSK_FOREST |
| d24 | Forêt des Cimes | BGM_TREESHROUD_FOREST |
| d25 | Grotte Saumure | BGM_BRINE_CAVE |
| d26 | Basse Grotte Saumure | BGM_LOWER_BRINE_CAVE |
| d27 | Terre Cachée | BGM_HIDDEN_LAND |
| d28 | Pic du Ciel (Sky Peak) | lieu "Sky Peak" (105 occ.) ; Village Shaymin |
| d50 | Falaises Spatiales (ES5) | BGM_SPACIAL_CLIFFS |
| d51 | Mont de Glace Sombre (ES5) | BGM_DARK_ICE_MOUNTAIN |
| d52 | Forêt de Givre (ES5) | BGM_ICICLE_FOREST |
| d53 | Mont de Glace Immense (ES5) | BGM_VAST_ICE_MOUNTAIN ; Primal Dialga "GIGI GIGIGIGI" (n09a1801) |
| d54 | Jungle Méridionale (ES4) | BGM_SOUTHERN_JUNGLE ; n06a0501 "sorties de la Jungle Méridionale" |
| d55 | Carrière Rocher (ES4) | BGM_BOULDER_QUARRY ; scènes Team Charm |
| d56 | Caverne Calcaire (ES4) | BGM_LIMESTONE_CAVERN / DEEP_LIMESTONE_CAVERN ; "limestone cavern!" |
| d57 | Grotte Source (ES3) | BGM_SPRING_CAVE_DEPTHS ; "Je vais t'arrêter, Haunter!" ; "hot hot hot!" |
| d58 | Template unique d58-d61 (md5 identiques) — identité à confirmer | — |
| d59 | Template unique d58-d61 (md5 identiques) — identité à confirmer | — |
| d60 | Template unique d58-d61 (md5 identiques) — identité à confirmer | — |
| d61 | Template unique d58-d61 (md5 identiques) — identité à confirmer | — |
| d62 | Dojo d'Ossatueur | BGM_MAROWAK_DOJO |

### Doublons et priorité Sky

- Aucun ground existant n'a été écrasé : préfixe **sky_** (sky_d54p11a…). Les
  7 IDs Red du dépôt (d09p02…, t01p01 — exports officiels PMD Red, arc fugitif
  ch11 + SceneDebug) restent intacts : les ID de maps Red et Sky ne se
  recouvrent pas canoniquement.
- **bourg_comptoir** (« Trading Burg », 48x21, Treasure Town.ogg) : port existant
  d'une ville de type Bourg-Comptoir, assignée à la réserve ville 2 (ch11+).
  La carte source Sky (GROUND/*.sir0) n'est PAS dans pret/pmd-sky (binaire de
  ROM) : la version Sky ne peut pas encore être importée. Règle actée :
  **l'importation Sky est prioritaire** — quand le .sir0 sera disponible, il
  remplacera bourg_comptoir (scènes ch11 à recaler).
- Doublons internes assumés : arc_parvis_celeste/parvis_celeste,
  arc_palier_celeste/palier_celeste, arc_tour_ciel_sommet/tour_ciel_sommet,
  bois_sombres_oree/gloomy_forest_entrance, carrefour_assemblee/carrefour_nord,
  vast_steppe_guardian/vast_steppe_miniboss, chambres de guilde, 4 midpoints.

### Restitution (au cas par cas)

1. Copier `RESERVE/sky_grounds/sky_X.rsground` → `Data/Ground/` (nom canonique
   FR) et `RESERVE/sky_tiles/sky_X_Base.tile` → `Content/Tile/`.
2. `python3 tools/rebuild_tile_index.py` ; déclarer dans la zone (index.idx +
   GroundMaps) ; brancher les scènes (patron cloven_ruins).
3. `python3 tools/audit_grounds_correlation.py` — 0 bloquant exigé.

### Limites

- 5 maps (d17p31a-d34a, d73p11a) rendues SANS leurs BPA (assertion skytemple) :
  frame unique, animations à reprendre quand le handler sera compatible.
- FrameLength uniformisé (8) : les durées BPA originales ne sont pas exportées
  par to_pil (LCM des longueurs).
- 6 cartes sans dossier SCRIPT dans le dépôt decompilé → identité à confirmer.

