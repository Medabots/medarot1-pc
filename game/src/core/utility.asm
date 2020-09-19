; Useful utility functions that don't necessarily belong in one place
INCLUDE "game/src/common/constants.asm"

SECTION "Draw Numbers", ROM0[$3158]
DrawNumber:: ; 3158 (0:3158)
  push hl
  push de
  push bc
  xor a
  ld [$c650], a
  ld a, b
  ld [$c642], a
  ld a, c
  ld [$c643], a
  ld bc, $3e8
  call $30D2
  ld a, [SerIO_ConnectionTestResult]
  or a
  jr nz, .asm_33b7
  ld b, a
  ld a, [$c650]
  or a
  jr z, .asm_33ce
  ld a, b
.asm_33b7
  add $6b
  push af
  ld a, [$c642]
  ld h, a
  ld a, [$c643]
  ld l, a
  pop af
  di
  call WaitLCDController
  ld [hl], a
  ei
  ld a, $01
  ld [$c650], a
.asm_33ce
  ld a, [$c640]
  ld h, a
  ld a, [$c641]
  ld l, a
  ld bc, $64
  call $30D2
  ld a, [SerIO_ConnectionTestResult]
  or a
  jr nz, .asm_33ea
  ld b, a
  ld a, [$c650]
  or a
  jr z, .asm_3408
  ld a, b
.asm_33ea
  add $6b
  push af
  ld a, [$c642]
  ld h, a
  ld a, [$c643]
  ld l, a
  ld bc, $1
  add hl, bc
  call $27C6
  pop af
  di
  call WaitLCDController
  ld [hl], a
  ei
  ld a, $01
  ld [$c650], a
.asm_3408
  ld a, [$c640]
  ld h, a
  ld a, [$c641]
  ld l, a
  ld bc, $a
  call $30D2
  ld a, [SerIO_ConnectionTestResult]
  or a
  jr nz, .asm_3424
  ld b, a
  ld a, [$c650]
  or a
  jr z, .asm_3444
  ld a, b
.asm_3424
  add $6b
  push af
  ld a, [$c642]
  ld h, a
  ld a, [$c643]
  ld l, a
  ld bc, $1
  add hl, bc
  call $27C6
  ld bc, $1
  add hl, bc
  call $27C6
  pop af
  di
  call WaitLCDController
  ld [hl], a
  ei
.asm_3444
  ld a, [$c640]
  ld h, a
  ld a, [$c641]
  ld l, a
  ld bc, $1
  call $30D2
  ld a, [SerIO_ConnectionTestResult]
  add $6b
  push af
  ld a, [$c642]
  ld h, a
  ld a, [$c643]
  ld l, a
  ld bc, $1
  add hl, bc
  call $27C6
  ld bc, $1
  add hl, bc
  call $27C6
  ld bc, $1
  add hl, bc
  call $27C6
  pop af
  di
  call WaitLCDController
  ld [hl], a
  ei
  pop bc
  pop de
  pop hl
  ret
