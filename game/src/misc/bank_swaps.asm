; Uncategorized functions that swap banks
INCLUDE "game/src/common/constants.asm"

SECTION "MiscBankSwaps_00", ROM0[$2350]
MiscBankSwaps_00:
 ; 2350 (0:2350)
  ld a, $12
  ld [$2000], a
  ld a, [$c8f9]
  ld hl, $417c
  ld b, $00
  ld c, a
  add hl, bc
  ld a, [hl]
  ld [$c932], a
  dec a
  ld [$c933], a
  call $3750
  ret
; 0x236b

SECTION "MiscBankSwaps_02", ROM0[$2951]
MiscBankSwaps_02:
 ; 2951 (0:2951)
  ld a, $0b
  ld [$2000], a
  xor a
  ld [SerIO_ConnectionTestResult], a
  ld a, [$c6ce]
  or a
  jp nz, MiscBankSwaps_04.asm_29f6
  ld a, $01
  ld [$c6ce], a
  xor a
  ld [$c6d6], a
.asm_296a
  ld a, $0b
  ld [$2000], a
  push bc
  ld hl, $7110
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld b, $00
  ld a, [$c6d6]
  ld c, a
  sla c
  rl b
  add hl, bc
  pop bc
  ld a, [hl]
  cp $ff
  jp z, MiscBankSwaps_04.asm_2a60
  cp $fe
  jp nz, .asm_29bf
  inc hl
  ld a, [hl]
  push bc
  ld hl, $8000
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  pop bc
  ld a, h
  ld [$c6cf], a
  ld a, l
  ld [$c6d0], a
  ld a, [$c6d6]
  inc a
  ld [$c6d6], a
  jp MiscBankSwaps_02.asm_296a
; 0x29bf
.asm_29bf

SECTION "MiscBankSwaps_04", ROM0[$29C3]
MiscBankSwaps_04:
 ; 29c3 (0:29c3)
  ld a, $0b
  ld [$c6d4], a
  ld [$2000], a
  ld a, [hli]
  ld h, a
  sub $40
  jr c, .asm_29e0
  push af
  ld a, $11
  ld [$c6d4], a
  ld [$2000], a
  pop af
  ld hl, $45be
  jr .asm_29e4
.asm_29e0
  ld a, h
  ld hl, $4090
.asm_29e4
  push bc
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  pop bc
  ld a, [hli]
  ld [$c6d2], a
  ld a, [hl]
  ld [$c6d1], a
.asm_29f6
  ld a, [$c6d3]
  or a
  jr nz, .asm_2a02
  ld a, $01
  ld [SerIO_ConnectionTestResult], a
  ret
.asm_2a02
  dec a
  ld [$c6d3], a
  ld a, [$c6d4]
  ld [$2000], a
  push bc
  ld a, [$c6d1]
  ld h, a
  ld a, [$c6d2]
  ld l, a
  ld a, [$c6cf]
  ld d, a
  ld a, [$c6d0]
  ld e, a
  ld bc, $10
  call CopyVRAMData
  pop bc
  ld a, [$c6d1]
  ld h, a
  ld a, [$c6d2]
  ld l, a
  ld de, $10
  add hl, de
  ld a, h
  ld [$c6d1], a
  ld a, l
  ld [$c6d2], a
  ld a, [$c6cf]
  ld h, a
  ld a, [$c6d0]
  ld l, a
  ld de, $10
  add hl, de
  ld a, h
  ld [$c6cf], a
  ld a, l
  ld [$c6d0], a
  ld a, [$c6d5]
  dec a
  ld [$c6d5], a
  jp nz, MiscBankSwaps_04.asm_29f6
  ld a, [$c6d6]
  inc a
  ld [$c6d6], a
  jp MiscBankSwaps_02.asm_296a
; 0x2a60
.asm_2a60

SECTION "MiscBankSwaps_07", ROM0[$2A65]
MiscBankSwaps_07:
 ; 2a65 (0:2a65)
  ld a, $10
  ld [$2000], a
  ld a, [$c92c]
  ld h, a
  ld a, [$c92d]
  ld l, a
.asm_2a72
  ld a, [hli]
  cp $ff
  jp z, .asm_2ab3
  ld b, a
  ld a, [SerIO_ConnectionTestResult]
  cp b
  jr z, .asm_2a89
  inc hl
  inc hl
  inc hl
  inc hl
  inc hl
  inc hl
  inc hl
  jp .asm_2a72
.asm_2a89
  ld a, [hli]
  ld b, a
  ld a, [$c64f]
  cp b
  jr z, .asm_2a9a
  inc hl
  inc hl
  inc hl
  inc hl
  inc hl
  inc hl
  jp .asm_2a72
.asm_2a9a
  ld a, [hli]
  ld [SerIO_ConnectionTestResult], a
  ld a, [hli]
  ld [$c650], a
  ld a, [hli]
  ld [$c652], a
  ld a, [hli]
  ld [$c654], a
  ld a, [hli]
  ld [$c656], a
  ld a, [hli]
  ld [$c658], a
  ret
; 0x2ab3
.asm_2ab3

SECTION "MiscBankSwaps_08", ROM0[$2AE9]
MiscBankSwaps_08:
 ; 2ae9 (0:2ae9)
  ld a, $03
  ld [$2000], a
  ld a, [$c0d8]
  ld b, $00
  ld c, a
  sla c
  rl b
  ld hl, $400f
  add hl, bc
  ld a, [hli]
  ld b, a
  ld a, [$c0d4]
  add b
  ld [$c650], a
  ld a, [hli]
  ld b, a
  ld a, [$c0d5]
  add b
  ld [$c651], a
  ld a, $10
  ld [$2000], a
  ld a, [$c92f]
  ld h, a
  ld a, [$c930]
  ld l, a
.asm_2b1b
  ld a, [hli]
  cp $ff
  ret z
  ld b, a
  ld a, [$c650]
  cp b
  jr z, .asm_2b2b
  inc hl
  inc hl
  jp .asm_2b1b
.asm_2b2b
  ld a, [hli]
  ld b, a
  ld a, [$c651]
  cp b
  jr z, .asm_2b37
  inc hl
  jp .asm_2b1b
.asm_2b37
  ld a, [hli]
  ld [$c650], a
  ld a, $03
  ld [$2000], a
  call $4000
  ld a, $01
  ld [SerIO_ConnectionTestResult], a
  ret
; 0x2b49

SECTION "MiscBankSwaps_0B", ROM0[$2B7E]
MiscBankSwaps_0B:
 ; 2b7e (0:2b7e)
  ld a, $17
  ld [$2000], a
  ld hl, $c933
  ld a, [$c936]
  cp $ff
  jr z, .asm_2b90
  ld hl, $c936
.asm_2b90
  ld a, [hl]
  ld hl, $62a2
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [hli]
  or a
  jp z, .asm_2bbf
  ld [SerIO_ConnectionTestResult], a
  ld a, [hli]
  ld [$c650], a
  ld a, $12
  ld [$2000], a
  ld hl, $429c
  ld b, $00
  ld a, [$c8f9]
  ld c, a
  add hl, bc
  ld a, [hl]
  ld [$c64f], a
  ret
; 0x2bbf
.asm_2bbf

SECTION "MiscBankSwaps_0D", ROM0[$2C03]
MiscBankSwaps_0D:
 ; 2c03 (0:2c03)
  ld a, $14
  ld [$2000], a
  ld hl, $4000
  ld de, $9010
  ld bc, $100
  call CopyVRAMData
  ld a, [$c740]
  inc a
  ld [$c740], a
  ret
; 0x2c1c

SECTION "MiscBankSwaps_0E", ROM0[$2C1C]
MiscBankSwaps_0E:
 ; 2c1c (0:2c1c)
  ld a, $17
  ld [$2000], a
  ld a, [$c753]
  ld hl, $63e2
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [hl]
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  ld a, $14
  ld [$2000], a
  ld hl, $4000
  add hl, bc
  ld de, $9110
  ld bc, $100
  call CopyVRAMData
  ld a, [$c740]
  inc a
  ld [$c740], a
  xor a
  ld [$c741], a
  ret
; 0x2c74

SECTION "MiscBankSwaps_10", ROM0[$2C74]
MiscBankSwaps_10:
 ; 2c74 (0:2c74)
  ld a, $1b
  ld [$2000], a
  ld a, [$c752]
  ld b, $00
  ld c, a
  sla c
  rl b
  ld hl, .asm_2cbb
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld b, $00
  ld a, [$c741]
  ld c, a
  ld a, $08
  call GetListTextOffset
  push hl
  ld hl, $9210
  ld b, $00
  ld a, [$c741]
  ld c, a
  ld a, $08
  call GetListTextOffset
  pop hl
  ld bc, $100
  call CopyVRAMData
  ld a, [$c741]
  inc a
  ld [$c741], a
  cp $03
  ret nz
  ld a, $ff
  ld [$c740], a
  ret
; 0x2cbb
.asm_2cbb

SECTION "MiscBankSwaps_11", ROM0[$2D07]
MiscBankSwaps_11:
 ; 2d07 (0:2d07)
  ld a, $17
  ld [$2000], a
  ld a, [$c753]
  ld hl, $63e2
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  inc hl
  ld a, [hli]
  push hl
  push af
  ld a, [$c74e]
  ld hl, $d0c0
  ld b, $00
  ld c, a
  ld a, $06
  call GetListTextOffset
  ld b, $00
  pop af
  ld c, a
  add hl, bc
  ld a, h
  ld [$c754], a
  ld a, l
  ld [$c755], a
  pop hl
  ld a, [hli]
  ld [$c76b], a
  ld a, [$c776]
  or a
  jr nz, .asm_2d59
  push hl
  call PadTextTo8
  ld h, $00
  ld l, a
  ld bc, $984b
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  call PutString
  ret
.asm_2d59
  ld hl, $c778
  push hl
  call PadTextTo8
  ld h, $00
  ld l, a
  ld bc, $984b
  add hl, bc
  ld b, h
  ld c, l
  pop hl
  call PutString
  ret
; 0x2d6e

SECTION "MiscBankSwaps_12", ROM0[$2D6E]
MiscBankSwaps_12:
 ; 2d6e (0:2d6e)
  ld a, $17
  ld [$2000], a
  ld a, [$c753]
  ld hl, $63e2
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  inc hl
  inc hl
  inc hl
  ld de, cBUF01
  ld b, $09
.asm_2d8c
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_2d8c
  ret
; 0x2d93

SECTION "MiscBankSwaps_13", ROM0[$2EDE]
MiscBankSwaps_13:
 ; 2ede (0:2ede)
  ld a, $17
  ld [$2000], a
  ld hl, .asm_2f11
  ld d, $00
  ld e, b
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld d, $00
  ld e, c
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  add hl, de
  ld a, [SerIO_ConnectionTestResult]
  ld d, $00
  ld e, a
  add hl, de
  ld a, [hl]
  ld [SerIO_ConnectionTestResult], a
  ret
; 0x2f11
 .asm_2f11

SECTION "MiscBankSwaps_14", ROM0[$2F1C]
MiscBankSwaps_14:
 ; 2f1c (0:2f1c)
  ld a, $17
  ld [$2000], a
  ld hl, .asm_2f53
  ld d, $00
  ld e, b
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld d, $00
  ld e, c
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  add hl, de
  ld a, [SerIO_ConnectionTestResult]
  ld d, $00
  ld e, a
  add hl, de
  ld a, [hl]
  ld [SerIO_ConnectionTestResult], a
  ret
; 0x2f53
.asm_2f53

SECTION "MiscBankSwaps_15", ROM0[$2F64]
MiscBankSwaps_15:
 ; 2f64 (0:2f64)
  ld [$2000], a
  ld hl, .asm_3020
  ld b, $00
  ld a, [$a00e]
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$a00f]
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  ld bc, $986b
  call PutString
  ld hl, .asm_3020
  ld b, $00
  ld a, [$a010]
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$a011]
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  ld bc, $98ab
  call PutString
  ld hl, .asm_3020
  ld b, $00
  ld a, [$a012]
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$a013]
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  ld bc, $98eb
  call PutString
  ld hl, .asm_3020
  ld b, $00
  ld a, [$a014]
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$a015]
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  ld bc, $992b
  call PutString
  ret
; 0x3020
.asm_3020

SECTION "MiscBankSwaps_16", ROM0[$3027]
MiscBankSwaps_16:
 ; 3027 (0:3027)
  ld a, $08
  ld [$2000], a
  pop af
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  ld hl, $4e4f
  add hl, bc
  ld bc, $40
  call CopyVRAMData
  ret
; 0x3053

SECTION "MiscBankSwaps_19", ROM0[$3244]
MiscBankSwaps_19:
 ; 3244 (0:3244)
  push af
  ld a, $0a
  ld [$2000], a
  pop af
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  ld hl, $4000
  add hl, bc
  ld bc, $100
  call CopyVRAMData
  ret
; 0x3279

SECTION "MiscBankSwaps_1A", ROM0[$3279]
MiscBankSwaps_1A:
 ; 3279 (0:3279)
  ld a, $0a
  ld [$2000], a
  ld hl, $7900
  ld bc, $1a0
  call CopyVRAMData
  ret
; 0x3288

SECTION "MiscBankSwaps_2B", ROM0[$332e]
MiscBankSwaps_2B:
 ; 0x332e
  push af
  ld b, $0c
  add b
  ld [$2000], a
  ld b, $00
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  ld hl, $4000
  add hl, bc
  ld bc, $100
  pop af
  cp $03
  jr nz, .asm_3366
  ld bc, $c0
.asm_3366
  call CopyVRAMData
  ret
; 0x336a

SECTION "MiscBankSwaps_1D", ROM0[$336D]
MiscBankSwaps_1D:
 ; 336d (0:336d)
  ld a, $0b
  ld [$2000], a
  ld hl, $4000
  ld bc, $90
  call CopyVRAMData
  pop bc
  pop de
  pop hl
  ret
; 0x337f

SECTION "MiscBankSwaps_1E", ROM0[$337F]
MiscBankSwaps_1E:
 ; 337f (0:337f)
  push af
  ld a, $17
  ld [$2000], a
  pop af
  ld hl, $66d4
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld b, $09
  ld de, SerIO_ConnectionTestResult
.asm_3399
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_3399
  ret
; 0x33a0

SECTION "MiscBankSwaps_20", ROM0[$3591]
MiscBankSwaps_20:
 ; 3591 (0:3591)
  push hl
  push de
  push bc
  push af
  ld a, $17
  ld [$2000], a
  pop af
  ld hl, $6e30
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  ld bc, $1f
  call CopyVRAMData
  pop bc
  pop de
  pop hl
  ret
; 0x35c0

SECTION "MiscBankSwaps_21", ROM0[$35C0]
MiscBankSwaps_21:
 ; 35c0 (0:35c0)
  push hl
  push de
  push bc
  push af
  ld a, $17
  ld [$2000], a
  pop af
  ld hl, $6d50
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  push hl
  ld hl, $c
  add hl, de
  ld d, h
  ld e, l
  pop hl
  ld b, $08
.asm_35e7
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_35e7
  pop bc
  pop de
  pop hl
  ret
; 0x35f1

SECTION "MiscBankSwaps_22", ROM0[$35F1]
MiscBankSwaps_22:
 ; 35f1 (0:35f1)
  push de
  ld de, $a410
  or a
  jr z, .asm_35fb
  ld de, $a420
.asm_35fb
  ld a, $17
  ld [$2000], a
  ld hl, $4
  add hl, de
  ld a, [hl]
  cp $03
  jr nz, .asm_3643
  ld hl, $6
  add hl, de
  ld a, [hl]
  ld hl, $71b0
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  push hl
  ld hl, $7
  add hl, de
  ld a, [hl]
  pop hl
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  push hl
  ld hl, $8
  add hl, de
  ld a, [hl]
  pop hl
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  jp .asm_3687
.asm_3643
  ld hl, $4
  add hl, de
  ld a, [hl]
  cp $02
  jr nz, .asm_3674
  ld hl, $6
  add hl, de
  ld a, [hl]
  ld hl, $724e
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  push hl
  ld hl, $7
  add hl, de
  ld a, [hl]
  pop hl
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  jp .asm_3687
.asm_3674
  ld hl, $6
  add hl, de
  ld a, [hl]
  ld hl, $7296
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
.asm_3687
  ld de, $a084
  ld b, $08
.asm_368c
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_368c
  pop de
  ret
; 0x3694

SECTION "MiscBankSwaps_23", ROM0[$3694]
MiscBankSwaps_23:
 ; 3694 (0:3694)
  push de
  push af
  ld a, $17
  ld [$2000], a
  pop af
  ld hl, $72b4
  ld b, $00
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  ld de, $a084
  ld b, $08
.asm_36b4
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_36b4
  pop de
  ret
; 0x36bc

SECTION "MiscBankSwaps_24", ROM0[$36BC]
MiscBankSwaps_24:
 ; 36bc (0:36bc)
  push hl
  push de
  ld a, $17
  ld [$2000], a
  ld hl, $737c
  ld d, $00
  ld e, b
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  sla e
  rl d
  add hl, de
  ld d, $00
  ld e, c
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  push hl
  pop bc
  pop de
  pop hl
  ret
; 0x36ea

SECTION "MiscBankSwaps_25", ROM0[$36EA]
MiscBankSwaps_25:
 ; 36ea (0:36ea)
  push af
  ld a, $1f
  ld [$2000], a
  pop af
  ld hl, $74d8
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld bc, $9a01
  call PutString
  ret
; 0x3706

SECTION "MiscBankSwaps_26", ROM0[$3706]
MiscBankSwaps_26:
 ; 3706 (0:3706)
  push af
  push bc
  ld b, $01
  ld c, $01
  ld e, $2f
  call LoadTilemapInWindow
  pop bc
  pop af
  ld c, a
  ld a, $01
  call $2edb
  ld a, $02
  ld [$2000], a
  ld hl, $6827
  ld b, $00
  ld a, [SerIO_ConnectionTestResult]
  ld c, a
  add hl, bc
  ld a, [hl]
  push af
  ld a, $1f
  ld [$2000], a
  pop af
  ld hl, $74d8
  ld b, $00
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld bc, $9c41
  call PutString
  ret
; 0x3745

SECTION "MiscBankSwaps_2C", ROM0[$3752]
MiscBankSwaps_2C: ; 3752 (0:3752)
  ld [$2000], a
  ld hl, $420c
  ld b, $00
  ld a, [$c8f9]
  ld c, a
  add hl, bc
  ld a, [hl]
  push af
  and $f0
  swap a
  ld b, a
  ld a, [$c939]
  ld hl, .asm_3784
  ld d, $00
  ld e, a
  add hl, de
  ld a, [hl]
  add b
  ld c, a
  sub $0b
  jr c, .asm_3779
  ld c, $0a
.asm_3779
  ld a, c
  ld [$c934], a
  pop af
  and $0f
  ld [$c935], a
  ret
; 0x3784
.asm_3784

SECTION "MiscBankSwaps_28", ROM0[$388C]
MiscBankSwaps_28:
 ; 388c (0:388c)
  ld a, $12
  ld [$2000], a
  ld a, [$c8f9]
  ld hl, $432c
  ld b, $00
  ld c, a
  add hl, bc
  ld a, [hl]
  ld [SerIO_ConnectionTestResult], a
  ret
; 0x38a0

SECTION "MiscBankSwaps_29", ROM0[$38A0]
MiscBankSwaps_29:
 ; 38a0 (0:38a0)
  push hl
  push de
  push bc
  ld hl, $ca
  add hl, de
  ld a, [hl]
  ld [$c652], a
  ld hl, $d
  ld b, $00
  ld c, a
  add hl, bc
  add hl, de
  ld a, [hl]
  and $7f
  ld c, a
  ld a, [$c652]
  ld b, a
  ld a, $0f
  push de
  call $2edb
  pop de
  ld a, $17
  ld [$2000], a
  ld hl, $742c
  ld b, $00
  ld a, [SerIO_ConnectionTestResult]
  ld c, a
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld de, cBUF04
  ld b, $09
.asm_38dd
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_38dd
  pop bc
  pop de
  pop hl
  ret
; 0x38e7

SECTION "MiscBankSwaps_2A", ROM0[$3A3D]
MiscBankSwaps_2A:
 ; 3a3d (0:3a3d)
  call $283a
  ld a, $1d
  ld [$2000], a
  ld a, [$c8f9]
  ld hl, $6400
  ld d, $00
  ld e, a
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$c939]
  ld d, $00
  ld e, a
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  push hl
  ld a, $1d
  ld [$2000], a
  ld a, [hl]
  cp $ff
  jp z, $3afd
  call $3aff
  cp $00
  jp nz, $3afd
  pop hl
  ld a, [hli]
  push hl
  ld hl, $14
  add hl, de
  ld [hl], a
  pop hl
  ld a, [hli]
  push hl
  ld hl, $15
  add hl, de
  ld [hl], a
  pop hl
  ld a, [hli]
  push hl
  ld hl, $17
  add hl, de
  ld [hl], a
  pop hl
  ld a, [hli]
  push hl
  ld hl, $18
  add hl, de
  ld [hl], a
  ld [$c8b0], a
  pop hl
  call $3b23
  cp $00
  jp nz, $3af6
  ld a, [hli]
  cp $ff
  jp z, $3aea
  push hl
  ld hl, $4
  add hl, de
  ld [hl], a
  push af
  ld hl, $1b
  add hl, de
  and $f0
  ld [hl], a
  pop af
  ld hl, $1c
  add hl, de
  and $0f
  ld [hl], a
  pop hl
  ld a, $09
  push hl
  ld hl, $0
  add hl, de
  ld [hl], a
  pop hl
  push hl
  ld hl, $14
  add hl, de
  ld a, [hli]
  ld b, a
  ld a, [hl]
  ld c, a
  ld a, $01
  ld [$2000], a
  ld a, [$c8b0]
  and $80
  jp z, .asm_3ae4
  pop hl
  jp $3aea
; 0x3ae4
.asm_3ae4