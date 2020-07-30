INCLUDE "game/src/common/macros.asm"

SECTION "Tileset Table", ROM0[$1103]
TilesetTable::
  dw TilesetInfo117B ; 0
  dw TilesetInfo1180 ; 1
  dw TilesetInfo1185 ; 2
  dw TilesetInfo118A ; 3
  dw TilesetInfo117B ; 4
  dw TilesetInfo118F ; 5
  dw TilesetInfo1194 ; 6
  dw TilesetInfo1199 ; 7
  dw TilesetInfo119E ; 8
  dw TilesetInfo11A3 ; 9
  dw TilesetInfo11AD ; A
  dw TilesetInfo11B2 ; B
  dw TilesetInfo11B7 ; C
  dw TilesetInfo11BC ; D
  dw TilesetInfo11C1 ; E
  dw TilesetInfo11C6 ; F
  dw TilesetInfo11CB ; 10
  dw TilesetInfo11D0 ; 11
  dw TilesetInfo11D5 ; 12
  dw TilesetInfo11DA ; 13
  dw TilesetInfo11EE ; 14
  dw TilesetInfo11D0 ; 15
  dw TilesetInfo11D0 ; 16
  dw TilesetInfo11D0 ; 17
  dw TilesetInfo11D0 ; 18
  dw TilesetInfo11D0 ; 19
  dw TilesetInfo11D0 ; 1A
  dw TilesetInfo11D0 ; 1B
  dw TilesetInfo11D0 ; 1C
  dw TilesetInfo11D0 ; 1D
  dw TilesetInfo11D0 ; 1E
  dw TilesetInfo11D0 ; 1F
  dw TilesetInfo1211 ; 20
  dw TilesetInfo1216 ; 21
  dw TilesetInfo121B ; 22
  dw TilesetInfo1220 ; 23
  dw TilesetInfo1225 ; 24
  dw TilesetInfoEnd ; 25
  dw TilesetInfoEnd ; 26
  dw TilesetInfoEnd ; 27
  dw TilesetInfoEnd ; 28
  dw TilesetInfoEnd ; 29
  dw TilesetInfoEnd ; 2A
  dw TilesetInfoEnd ; 2B
  dw TilesetInfoEnd ; 2C
  dw TilesetInfoEnd ; 2D
  dw TilesetInfoEnd ; 2E
  dw TilesetInfoEnd ; 2F
  dw TilesetInfoEnd ; 30
  dw TilesetInfoEnd ; 31
  dw TilesetInfo11A8 ; 32
  dw TilesetInfo11DF ; 33
  dw TilesetInfo11E4 ; 34
  dw TilesetInfo11E9 ; 35
  dw TilesetInfo11F3 ; 36
  dw TilesetInfo11F8 ; 37
  dw TilesetInfo11FD ; 38
  dw TilesetInfo1202 ; 39
  dw TilesetInfo1207 ; 3A
  dw TilesetInfo120C ; 3B
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
SECTION "TilesetInfo 11A8", ROM0[$11A8]
TilesetInfo11A8::
  dbww BANK(Tileset11A8), Tileset11A8, $8000
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
SECTION "TilesetInfo 11DF", ROM0[$11DF]
TilesetInfo11DF::
  dbww BANK(Tileset11DF), Tileset11DF, $9000
SECTION "TilesetInfo 11E4", ROM0[$11E4]
TilesetInfo11E4::
  dbww BANK(Tileset11E4), Tileset11E4, $9000
SECTION "TilesetInfo 11E9", ROM0[$11E9]
TilesetInfo11E9::
  dbww BANK(Tileset11E9), Tileset11E9, $9000
SECTION "TilesetInfo 11EE", ROM0[$11EE]
TilesetInfo11EE::
  dbww BANK(Tileset11EE), Tileset11EE, $9000
SECTION "TilesetInfo 11F3", ROM0[$11F3]
TilesetInfo11F3::
  dbww BANK(Tileset11F3), Tileset11F3, $8000
SECTION "TilesetInfo 11F8", ROM0[$11F8]
TilesetInfo11F8::
  dbww BANK(Tileset11F8), Tileset11F8, $8000
SECTION "TilesetInfo 11FD", ROM0[$11FD]
TilesetInfo11FD::
  dbww BANK(Tileset11FD), Tileset11FD, $8000
SECTION "TilesetInfo 1202", ROM0[$1202]
TilesetInfo1202::
  dbww BANK(Tileset1202), Tileset1202, $81F0
SECTION "TilesetInfo 1207", ROM0[$1207]
TilesetInfo1207::
  dbww BANK(Tileset1207), Tileset1207, $9000
SECTION "TilesetInfo 120C", ROM0[$120C]
TilesetInfo120C::
  dbww BANK(Tileset120C), Tileset120C, $9000
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
