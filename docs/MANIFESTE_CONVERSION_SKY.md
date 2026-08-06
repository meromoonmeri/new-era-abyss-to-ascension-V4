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

### Ordre canonique des boss (EoS)

| Étape | Donjon | Chambre | Boss | Mot Zarbi (plaques) | Arène (ground converti) |
|---|---|---|---|---|---|
| 1 | Ice Aegis Cave (d54) | Regice Chamber (d55) | **Regice** niv ~40 | G-L-A-C-E (ICE) | `aegis_regice_arene` (d55p41a) |
| 2 | Rock Aegis Cave (d56) | Regirock Chamber (d57) | **Regirock** niv ~42 | R-O-C-H-E (ROCK) | `aegis_regirock_arene` (d56p41a) |
| 3 | Steel Aegis Cave (d58) | Registeel Chamber (d59) | **Registeel** niv ~44 | A-C-I-E-R (STEEL) | `aegis_registeel_arene` (d59p41a) |
| 4 | Aegis Cave Pit (d60) | Regigigas Chamber (d61) | **Regigigas** niv ~50 | (aucune — combat direct) | `aegis_regigigas_arene` (d61p41a) |

### Les 19 grounds convertis (pixel-perfect, collision BMA source)

| Map source | Ground converti | Rôle |
|---|---|---|
| d54p11a | aegis_glace_entree | Entrée Aegis Glace (63x54, 83% murs) |
| d54p31a | aegis_glace_salle_zarbi | Salle des plaques Unown Glace (63x57, animée 32f) |
| d54p32a | aegis_glace_antechambre | Antichambre de Regice (75x57) |
| d55p11a | aegis_regice_entree | Entrée Chambre de Regice (69x63) |
| d55p21a | aegis_regice_autel | Autel de Regice (57x57) |
| d55p41a | aegis_regice_arene | **Arène de Regice** (63x57, 7% murs = zone libre) |
| d56p11a | aegis_roche_entree | Entrée Aegis Roche (63x51) |
| d56p12a | aegis_roche_salle_zarbi | Salle des plaques Unown Roche (39x42, animée 32f) |
| d56p21a | aegis_roche_antechambre | Antichambre de Regirock (57x57) |
| d56p41a | aegis_regirock_arene | **Arène de Regirock** (57x60, animée 24f) |
| d57p21a | aegis_regirock_autel | Autel de Regirock (57x57) |
| d57p41a | aegis_roche_couloir_1 | Couloir Roche 1 (57x57) |
| d57p42a | aegis_roche_couloir_2 | Couloir Roche 2 (57x66, animé 64f) |
| d57p43a | aegis_roche_couloir_3 | Couloir Roche 3 (114x57, animé 84f) |
| d57p44a | aegis_roche_couloir_4 | Couloir Roche 4 (57x57, animé 84f) |
| d58p41a | aegis_acier_salle_zarbi | Salle des plaques Unown Acier (57x57) |
| d59p41a | aegis_registeel_arene | **Arène de Registeel** (57x57) |
| d60p41a | aegis_puits_fond | Puits d'Aegis — fond (57x57) |
| d61p41a | aegis_regigigas_arene | **Arène de Regigigas** (57x57) |

### Mécanique des plaques Unown (Zarbi)

Dans EoS, chaque labyrinthe (Glace/Roche/Acier) contient des **plaques Unown**
éparpillées dans les étages procéduraux. Le joueur doit les trouver puis les
poser sur les socles de la salle des plaques pour **épeler le mot** :
- Glace : G-L-A-C-E (ICE)
- Roche : R-O-C-H-E (ROCK)
- Acier : A-C-I-E-R (STEEL)

Une fois le mot complet, l'accès à la chambre du Regi s'ouvre. Sans le mot,
le donjon BOUCLE (le joueur ressort par l'entrée). — Le mod New Era possède
déjà `RuinesZarbi.lua` (mécanique des mots implémentée pour cloven_ruins) ;
il sera branché sur ces nouvelles salles.

### Scripts de scène (SSB) des maps Aegis

Les dossiers `files/language-specific/EU/SCRIPT/D5xPyy` contiennent les
scènes (entrée, apparition des Regi, cinématiques) :

| Map | Scripts SSB notables | Rôle |
|---|---|---|
| D54P11A | n06a0201/0301/0401/3902 | Cinématiques d'entrée Aegis Glace |
| D54P31A | n06a0501 | Salle des plaques (intro) |
| D54P32A | (enter) | Antichambre |
| D55P41A | n06a1301/1701/1801 | Apparition de Regice + combat |
| D56P11A | (enter + cinématiques) | Entrée Aegis Roche |
| D56P41A | n06a2201... | Apparition de Regirock |
| D57P41A-44A | (multi) | Couloirs Roche (pièges) |
| D58P41A | (enter) | Salle des plaques Acier |
| D59P41A | n06a3001... | Apparition de Registeel |
| D60P41A | (enter) | Puits d'Aegis |
| D61P41A | n06a3401... | **Cinématique finale Regigigas** (défaite → statue → effondrement) |

Les .ssb seront désassemblés (ssb_disassembler.py) puis réécrits en Lua
New Era (mécanisme conservé, dialogues réécrits).

### Items et musique

- Musique : `MUSIC_AEGIS_CAVE` (dungeon.h:2567) — à mapper sur un .ogg.
- Items : les étages procéduraux d'Aegis utilisent le spawner d'items du
  donjon (à reconfigurer dans la zone cloven_ruins).
