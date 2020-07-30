INCLUDE "game/src/common/macros.asm"

SECTION "Tileset Table", ROM0[$1103]
TilesetTable::
  dw TilesetInfo117B
  dw TilesetInfo1180
  dw TilesetInfo1185
  dw TilesetInfo118A
  dw TilesetInfo117B
  dw TilesetInfo118F
  dw TilesetInfo1194
  dw TilesetInfo1199
  dw TilesetInfo119E
  dw TilesetInfo11A3
  dw TilesetInfo11AD
  dw TilesetInfo11B2
  dw TilesetInfo11B7
  dw TilesetInfo11BC
  dw TilesetInfo11C1
  dw TilesetInfo11C6
  dw TilesetInfo11CB
  dw TilesetInfo11D0
  dw TilesetInfo11D5
  dw TilesetInfo11DA
  dw TilesetInfo11EE
  dw TilesetInfo11D0
  dw TilesetInfo11D0
  dw TilesetInfo11D0
  dw TilesetInfo11D0
  dw TilesetInfo11D0
  dw TilesetInfo11D0
  dw TilesetInfo11D0
  dw TilesetInfo11D0
  dw TilesetInfo11D0
  dw TilesetInfo11D0
  dw TilesetInfo11D0
  dw TilesetInfo1211
  dw TilesetInfo1216
  dw TilesetInfo121B
  dw TilesetInfo1220
  dw TilesetInfo1225
TilesetTableEnd::
SECTION "TilesetInfo 117B", ROM0[$117B]
TilesetInfo117B::
  dbww BANK(Tileset117B), Tileset117B, $8800
SECTION "TilesetInfo 1180", ROM0[$1180]
TilesetInfo1180::
  dbww BANK(Tileset1180), Tileset1180, $9500
SECTION "TilesetInfo 1185", ROM0[$1185]
TilesetInfo1185::
  dbww BANK(Tileset1185), Tileset1185, $9000
SECTION "TilesetInfo 118A", ROM0[$118A]
TilesetInfo118A::
  dbww BANK(Tileset118A), Tileset118A, $8800
SECTION "TilesetInfo 118F", ROM0[$118F]
TilesetInfo118F::
  dbww BANK(Tileset118F), Tileset118F, $8800
SECTION "TilesetInfo 1194", ROM0[$1194]
TilesetInfo1194::
  dbww BANK(Tileset1194), Tileset1194, $8000
SECTION "TilesetInfo 1199", ROM0[$1199]
TilesetInfo1199::
  dbww BANK(Tileset1199), Tileset1199, $8800
SECTION "TilesetInfo 119E", ROM0[$119E]
TilesetInfo119E::
  dbww BANK(Tileset119E), Tileset119E, $8000
SECTION "TilesetInfo 11A3", ROM0[$11A3]
TilesetInfo11A3::
  dbww BANK(Tileset11A3), Tileset11A3, $97C0
SECTION "TilesetInfo 11AD", ROM0[$11AD]
TilesetInfo11AD::
  dbww BANK(Tileset11AD), Tileset11AD, $8800
SECTION "TilesetInfo 11B2", ROM0[$11B2]
TilesetInfo11B2::
  dbww BANK(Tileset11B2), Tileset11B2, $8000
SECTION "TilesetInfo 11B7", ROM0[$11B7]
TilesetInfo11B7::
  dbww BANK(Tileset11B7), Tileset11B7, $9400
SECTION "TilesetInfo 11BC", ROM0[$11BC]
TilesetInfo11BC::
  dbww BANK(Tileset11BC), Tileset11BC, $9480
SECTION "TilesetInfo 11C1", ROM0[$11C1]
TilesetInfo11C1::
  dbww BANK(Tileset11C1), Tileset11C1, $9480
SECTION "TilesetInfo 11C6", ROM0[$11C6]
TilesetInfo11C6::
  dbww BANK(Tileset11C6), Tileset11C6, $9480
SECTION "TilesetInfo 11CB", ROM0[$11CB]
TilesetInfo11CB::
  dbww BANK(Tileset11CB), Tileset11CB, $9480
SECTION "TilesetInfo 11D0", ROM0[$11D0]
TilesetInfo11D0::
  dbww BANK(Tileset11D0), Tileset11D0, $9480
SECTION "TilesetInfo 11D5", ROM0[$11D5]
TilesetInfo11D5::
  dbww BANK(Tileset11D5), Tileset11D5, $9000
SECTION "TilesetInfo 11DA", ROM0[$11DA]
TilesetInfo11DA::
  dbww BANK(Tileset11DA), Tileset11DA, $9300
SECTION "TilesetInfo 11EE", ROM0[$11EE]
TilesetInfo11EE::
  dbww BANK(Tileset11EE), Tileset11EE, $9000
SECTION "TilesetInfo 1211", ROM0[$1211]
TilesetInfo1211::
  dbww BANK(Tileset1211), Tileset1211, $9000
SECTION "TilesetInfo 1216", ROM0[$1216]
TilesetInfo1216::
  dbww BANK(Tileset1216), Tileset1216, $9000
SECTION "TilesetInfo 121B", ROM0[$121B]
TilesetInfo121B::
  dbww BANK(Tileset121B), Tileset121B, $9000
SECTION "TilesetInfo 1220", ROM0[$1220]
TilesetInfo1220::
  dbww BANK(Tileset1220), Tileset1220, $9000
SECTION "TilesetInfo 1225", ROM0[$1225]
TilesetInfo1225::
  dbww BANK(Tileset1225), Tileset1225, $9000
TilesetInfoEnd::
