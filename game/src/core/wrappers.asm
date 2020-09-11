SECTION "Wrappers", ROM0[$059E]
Wrapper_59e::
  jp $0D8B
; 0x5a1

Wrapper_5a1::
  jp $0D99
; 0x5a4

Wrapper_5a4::
  jp $0DAC
; 0x5a7

Wrapper_5a7::
  call LoadTilemap
  rst $18
  ret
; 0x5ac

Wrapper_5ac::
  call LoadFont0
  rst $18
  ret
; 0x5b1

Wrapper_5b1::
  jp $1426
; 0x5b4

Wrapper_5b4::
  jp $156B
; 0x5b7

Wrapper_5b7::
  jp IncSubStateIndex
; 0x5ba

Wrapper_5ba::
  ld a, $1b
  rst $10
  call $42CC
  push af
  rst $18
  pop af
  ret
  nop
  nop
; 0x5c6

Wrapper_5c6::
  jp WaitLCDController
; 0x5c9

Wrapper_5c9::
  jp $0DBA
; 0x5cc

Wrapper_5cc::
  jp $17EA
; 0x5cf

Wrapper_5cf::
  jp $17F5
; 0x5d2

Wrapper_5d2::
  jp $1801
; 0x5d5

Wrapper_5d5::
  jp $1826
; 0x5d8

Wrapper_5d8::
  jp $1831
; 0x5db

Wrapper_5db::
  call LoadTilemapInWindow
  rst $18
  ret
; 0x5e0

Wrapper_5e0::
  call $3A3D
  rst $18
  ret
; 0x5e5

Wrapper_5e5::
  ld a, $03
  rst $10
  call $55C9
  rst $18
  ret
; 0x5ed

Wrapper_5ed::
  ld a, $03
  rst $10
  call $5251
  rst $18
  ret
; 0x5f5

Wrapper_5f5::
  jp $0D80
; 0x5f8

Wrapper_5f8::
  jp $0C93
; 0x5fb

Wrapper_5fb::
  call $4133
  rst $18
  ret
; 0x600

Wrapper_600::
  call $4169
  rst $18
  ret
; 0x605

Wrapper_605::
  jp $0CAB
; 0x608

Wrapper_608::
  call $3694
  rst $18
  ret
; 0x60d

Wrapper_60d::
  call $15A7
  rst $18
  ret
; 0x612

Wrapper_612::
  jp $0CCA
; 0x615

Wrapper_615::
  jp $0DFD
; 0x618

Wrapper_618::
  jp $0E10
; 0x61b

Wrapper_61b::
  rst $18
  ret
; 0x61d

Wrapper_61d::
  ret
; 0x61e

Wrapper_61e::
  jp $0C66
; 0x621

Wrapper_621::
  ret
; 0x622

Wrapper_622::
  call $19BE
  rst $18
  ret
; 0x627

Wrapper_627::
  jp $1B50
; 0x62a

Wrapper_62a::
  jp $1B60
; 0x62d

Wrapper_62d::
  jp $1B6D
; 0x630

Wrapper_630::
  jp $1B7B
; 0x633

Wrapper_633::
  call $1B89
  rst $18
  ret
; 0x638

Wrapper_638::
  call PutChar
  rst $18
  ret
; 0x63d

Wrapper_63d::
  call SetupDialog
  rst $18
  ret
; 0x642

Wrapper_642::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $01
  rst $10
  ld [$c6e0], a
  call $4D60
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0x65b

Wrapper_65b::
  jp $3540
; 0x65e

Wrapper_65e::
  call $2350
  rst $18
  ret
; 0x663

Wrapper_663::
  call LoadItemList
  rst $18
  ret
; 0x668

Wrapper_668::
  jp $30A3
; 0x66b

Wrapper_66b::
  jp $0DD9
; 0x66e

Wrapper_66e::
  call $3158
  rst $18
  ret
; 0x673

Wrapper_673::
  jp $3789
; 0x676

Wrapper_676::
  call $2161
  rst $18
  ret
; 0x67b

Wrapper_67b::
  call $23C7
  rst $18
  ret
; 0x680

Wrapper_680::
  call $250C
  rst $18
  ret
; 0x685

Wrapper_685::
  jp $2707
; 0x688

Wrapper_688::
  jp $236B
; 0x68b

Wrapper_68b::
  jp $2393
; 0x68e

Wrapper_68e::
  jp $1C7F
; 0x691

Wrapper_691::
  jp $1D1E
; 0x694

Wrapper_694::
  jp $27C6
; 0x697

Wrapper_697::
  jp $27FB
; 0x69a

Wrapper_69a::
  jp $2830
; 0x69d

Wrapper_69d::
  jp $0E23
; 0x6a0

Wrapper_6a0::
  jp $2848
; 0x6a3

Wrapper_6a3::
  jp $2871
; 0x6a6

Wrapper_6a6::
  jp $289C
; 0x6a9

Wrapper_6a9::
  jp $28FC
; 0x6ac

Wrapper_6ac::
  ld [$c64e], a
  ld a, $02
  rst $10
  ld a, [$c6e0]
  push af
  ld a, $02
  ld [$c6e0], a
  ld a, [$c64e]
  call $42D3
  pop af
  ld [$c6e0], a
  rst $18
  ret
; 0x6c7

Wrapper_6c7::
  ld [$c64e], a
  ld a, $02
  rst $10
  ld a, [$c6e0]
  push af
  ld a, $02
  ld [$c6e0], a
  ld a, [$c64e]
  call $441A
  pop af
  ld [$c6e0], a
  rst $18
  ret
; 0x6e2

Wrapper_6e2::
  jp $2915
; 0x6e5

Wrapper_6e5::
  jp $293B
; 0x6e8

Wrapper_6e8::
  jp $2141
; 0x6eb

Wrapper_6eb::
  call $196A
  ret
; 0x6ef

Wrapper_6ef::
  call $294E
  rst $18
  ret
; 0x6f4

Wrapper_6f4::
  call $2A65
  rst $18
  ret
; 0x6f9

Wrapper_6f9::
  call $0C4E
  ret
; 0x6fd

Wrapper_6fd::
  call $056E
  ret
; 0x701

Wrapper_701::
  call $3C4C
  ret
; 0x705

Wrapper_705::
  call DecompressAndLoadTiles
  rst $18
  ret
; 0x70a

Wrapper_70a::
  call LoadMainDialogTileset
  rst $18
  ret
; 0x70f

Wrapper_70f::
  call $2AB9
  rst $18
  ret
; 0x714

Wrapper_714::
  call $2B4F
  ret
; 0x718

Wrapper_718::
  call $2B7E
  rst $18
  ret
; 0x71d

Wrapper_71d::
  call $2CC5
  rst $18
  ret
; 0x722

Wrapper_722::
  call $2CF3
  rst $18
  ret
; 0x727

Wrapper_727::
  jp $2E9E
; 0x72a

Wrapper_72a::
  call $2F59
  rst $18
  ret
; 0x72f

Wrapper_72f::
  call PutString
  ret
; 0x733

Wrapper_733::
  call $33C4
  rst $18
  ret
; 0x738

Wrapper_738::
  ld a, $0b
  rst $10
  rst $18
  ret
  nop
  nop
; 0x73f

Wrapper_73f::
  ld a, $1b
  rst $10
  call $4000
  rst $18
  ret
  nop
  nop
; 0x749

Wrapper_749::
  ld a, $02
  rst $10
  call $7B8B
  rst $18
  ret
  nop
  nop
; 0x753

Wrapper_753::
  push af
  ld a, $02
  rst $10
  pop af
  call $7675
  push af
  rst $18
  pop af
  ret
  nop
  nop
; 0x761

Wrapper_761::
  call $2EDB
  rst $18
  ret
; 0x766

Wrapper_766::
  call $2F19
  rst $18
  ret
; 0x76b

Wrapper_76b::
  call $3026
  rst $18
  ret
; 0x770

Wrapper_770::
  call $30B1
  ret
; 0x774

Wrapper_774::
  call LoadMedalList
  rst $18
  ret
; 0x779

Wrapper_779::
  call $30D2
  ret
; 0x77d

Wrapper_77d::
  call $3244
  rst $18
  ret
; 0x782

Wrapper_782::
  call $3279
  rst $18
  ret
; 0x787

Wrapper_787::
  call PadTextTo8
  ret
; 0x78b

Wrapper_78b::
  call $329C
  rst $18
  ret
; 0x790

Wrapper_790::
  call LoadPartList
  rst $18
  ret
; 0x795

Wrapper_795::
  call $332E
  rst $18
  ret
; 0x79a

Wrapper_79a::
  call $336A
  rst $18
  ret
; 0x79f

Wrapper_79f::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  call $76F2
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0x7b8

Wrapper_7b8::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $4CB1
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0x7d3

Wrapper_7d3::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $77D0
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0x7ee

Wrapper_7ee::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $7805
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0x809

Wrapper_809::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $7BDA
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0x824

Wrapper_824::
  push af
  ld a, $02
  rst $10
  pop af
  call $4351
  rst $18
  ret
  nop
  nop
; 0x830

Wrapper_830::
  push af
  ld a, $02
  rst $10
  pop af
  call $445F
  rst $18
  ret
  nop
  nop
; 0x83c

Wrapper_83c::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $7BB6
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0x857

Wrapper_857::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $7BF1
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0x872

Wrapper_872::
  call GetListTextOffset
  ret
; 0x876

Wrapper_876::
  call $337F
  rst $18
  ret
; 0x87b

Wrapper_87b::
  call LoadMedarotList
  rst $18
  ret
; 0x880

Wrapper_880::
  ld a, $02
  rst $10
  call $7BA9
  rst $18
  ret
  nop
  nop
; 0x88a

Wrapper_88a::
  call $3402
  rst $18
  ret
; 0x88f

Wrapper_88f::
  call $34A5
  rst $18
  ret
; 0x894

Wrapper_894::
  call $3573
  rst $18
  ret
; 0x899

Wrapper_899::
  push af
  ld a, $05
  rst $10
  pop af
  rst $18
  ret
  nop
  nop
; 0x8a2

Wrapper_8a2::
  push af
  ld a, $1b
  rst $10
  pop af
  call $4029
  push af
  rst $18
  pop af
  ret
  nop
  nop
; 0x8b0

Wrapper_8b0::
  push af
  ld a, $1b
  rst $10
  pop af
  call $4071
  rst $18
  ret
  nop
  nop
; 0x8bc

Wrapper_8bc::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $79A4
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0x8d7

Wrapper_8d7::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $7A05
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0x8f2

Wrapper_8f2::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $6DE7
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0x90d

Wrapper_90d::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $6EC2
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0x928

Wrapper_928::
  push af
  ld a, $1b
  rst $10
  pop af
  call $4119
  push af
  rst $18
  pop af
  ret
  nop
  nop
; 0x936

Wrapper_936::
  push af
  ld a, $1b
  rst $10
  pop af
  call $41A5
  rst $18
  ret
  nop
  nop
; 0x942

Wrapper_942::
  push af
  ld a, $1b
  rst $10
  pop af
  call $4317
  push af
  rst $18
  pop af
  ret
  nop
  nop
; 0x950

Wrapper_950::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $1b
  rst $10
  ld [$c6e0], a
  pop af
  call $435A
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0x96b

Wrapper_96b::
  call $3591
  rst $18
  ret
; 0x970

Wrapper_970::
  call $35C0
  rst $18
  ret
; 0x975

Wrapper_975::
  call $2E00
  rst $18
  ret
; 0x97a

Wrapper_97a::
  call $35F1
  rst $18
  ret
; 0x97f

Wrapper_97f::
  call $3102
  rst $18
  ret
; 0x984

Wrapper_984::
  call $36BC
  rst $18
  ret
; 0x989

Wrapper_989::
  ld a, $03
  rst $10
  call $406F
  rst $18
  ret
; 0x991

Wrapper_991::
  call $3AFF
  ret
; 0x995

Wrapper_995::
  ld a, $03
  rst $10
  call $52AA
  rst $18
  ret
; 0x99d

Wrapper_99d::
  jp $3B48
; 0x9a0

Wrapper_9a0::
  call $36EA
  rst $18
  ret
; 0x9a5

Wrapper_9a5::
  push af
  ld a, $1b
  rst $10
  pop af
  call $40E4
  push af
  rst $18
  pop af
  ret
  nop
  nop
; 0x9b3

Wrapper_9b3::
  push af
  ld a, $1b
  rst $10
  pop af
  call $4247
  push af
  rst $18
  pop af
  ret
  nop
  nop
; 0x9c1

Wrapper_9c1::
  push af
  ld a, $1b
  rst $10
  pop af
  call $4434
  push af
  rst $18
  pop af
  ret
  nop
  nop
; 0x9cf

Wrapper_9cf::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  pop af
  call $7C37
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0x9ea

Wrapper_9ea::
  ret
; 0x9eb

Wrapper_9eb::
  push af
  ld a, $01
  rst $10
  pop af
  call $6CED
  rst $18
  ret
; 0x9f5

Wrapper_9f5::
  push af
  ld a, $1b
  rst $10
  pop af
  call $43B3
  rst $18
  ret
  nop
  nop
; 0xa01

Wrapper_a01::
  push af
  ld a, $01
  rst $10
  pop af
  call $7831
  rst $18
  ret
  nop
  nop
; 0xa0d

Wrapper_a0d::
  ld a, $03
  rst $10
  call $4BFC
  rst $18
  ret
; 0xa15

Wrapper_a15::
  ld a, $03
  rst $10
  call $4C92
  rst $18
  ret
; 0xa1d

Wrapper_a1d::
  ld a, [$c7f1]
  and $3f
  cp $02
  jp z, $0A2A
  jp $0A3E
; 0xa2a

Wrapper_a2a::
  ld a, [$c7f0]
  ld e, a
  ld a, [$c7f1]
  and $3f
  sub $02
  ld d, a
  ld hl, $4000
  ld a, $16
  jp $0A4D
; 0xa3e

Wrapper_a3e::
  ld a, [$c7f0]
  ld e, a
  ld a, [$c7f1]
  and $3f
  ld d, a
  ld hl, $4000
  ld a, $13
  rst $10
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$c7f5]
  ld d, $00
  ld e, a
  add hl, de
  inc a
  ld [$c7f5], a
  ld a, [hl]
  push af
  rst $18
  pop af
  ret
; 0xa66

Wrapper_a66::
  ld a, $03
  rst $10
  call $4C6F
  rst $18
  ret
; 0xa6e

Wrapper_a6e::
  call $2D6E
  rst $18
  ret
; 0xa73

Wrapper_a73::
  call $379E
  rst $18
  ret
; 0xa78

Wrapper_a78::
  push af
  ld a, $03
  rst $10
  pop af
  call $4D39
  rst $18
  ret
; 0xa82

Wrapper_a82::
  push af
  ld a, $1b
  rst $10
  pop af
  call $4477
  push af
  rst $18
  pop af
  ret
  nop
  nop
; 0xa90

Wrapper_a90::
  push af
  ld a, $1b
  rst $10
  pop af
  call $44AB
  rst $18
  ret
  nop
  nop
; 0xa9c

Wrapper_a9c::
  ret
; 0xa9d

Wrapper_a9d::
  ld a, $1f
  rst $10
  call $4105
  rst $18
  ret
; 0xaa5

Wrapper_aa5::
  ld a, $03
  rst $10
  call $531D
  rst $18
  ret
; 0xaad

Wrapper_aad::
  ld a, $03
  rst $10
  call $5334
  rst $18
  ret
; 0xab5

Wrapper_ab5::
  ld a, $02
  rst $10
  call $52D5
  rst $18
  ret
  nop
  nop
; 0xabf

Wrapper_abf::
  call $3841
  rst $18
  ret
; 0xac4

Wrapper_ac4::
  call $3861
  rst $18
  ret
; 0xac9

Wrapper_ac9::
  call $388C
  rst $18
  ret
; 0xace

Wrapper_ace::
  push af
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $01
  rst $10
  ld [$c6e0], a
  pop af
  call $6898
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0xae9

Wrapper_ae9::
  call $3706
  rst $18
  ret
; 0xaee

Wrapper_aee::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $1b
  rst $10
  ld [$c6e0], a
  call $4521
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0xb07

Wrapper_b07::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $1b
  rst $10
  ld [$c6e0], a
  call $4AD0
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0xb20

Wrapper_b20::
  ld a, $02
  rst $10
  call $7DB7
  rst $18
  ret
  nop
  nop
; 0xb2a

Wrapper_b2a::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $02
  rst $10
  ld [$c6e0], a
  call $7DDB
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0xb43

Wrapper_b43::
  ld a, $02
  rst $10
  call $7EEA
  rst $18
  ret
  nop
  nop
; 0xb4d

Wrapper_b4d::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $1b
  rst $10
  ld [$c6e0], a
  call $4FDF
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0xb66

Wrapper_b66::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $1b
  rst $10
  ld [$c6e0], a
  call $53CF
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0xb7f

Wrapper_b7f::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $1b
  rst $10
  ld [$c6e0], a
  call $531A
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0xb98

Wrapper_b98::
  ld a, $1b
  rst $10
  call $5478
  rst $18
  ret
  nop
  nop
; 0xba2

Wrapper_ba2::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $1b
  rst $10
  ld [$c6e0], a
  call $55BA
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0xbbb

Wrapper_bbb::
  ld a, $1b
  rst $10
  call $574A
  rst $18
  ret
  nop
  nop
; 0xbc5

Wrapper_bc5::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $1b
  rst $10
  ld [$c6e0], a
  call $53E7
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0xbde

Wrapper_bde::
  call $38A0
  rst $18
  ret
; 0xbe3

Wrapper_be3::
  ld a, $07
  rst $10
  call $60B6
  rst $18
  ret
  nop
  nop
; 0xbed

Wrapper_bed::
  ld a, $1b
  rst $10
  call $5772
  rst $18
  ret
  nop
  nop
; 0xbf7

Wrapper_bf7::
  push af
  ld a, $01
  rst $10
  pop af
  call $7607
  rst $18
  ret
  nop
  nop
; 0xc03

Wrapper_c03::
  ld a, [$c6e0]
  ld [$c6e1], a
  ld a, $12
  rst $10
  ld [$c6e0], a
  call $689F
  ld a, [$c6e1]
  ld [$c6e0], a
  rst $18
  ret
  nop
  nop
; 0xc1c

