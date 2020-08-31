SECTION "Dialog Control Codes", ROM0[$1E44]
Char4F:: ; 1d6b end of text
  inc hl
  ld a, [hl]
  or a
  jp nz, .Char4fMore
  ld a, [$ff8d]
  and $3
  jr nz, .asm_1d8b
  ld a, [$ff8c]
  and $3
  jr z, .asm_1d89
  ld a, [$c6c5]
  cp $10
  jp z, .asm_1d8b
  inc a
  ld [$c6c5], a
.asm_1d89
  pop hl
  ret

.asm_1d8b
  ld a, $22
  ld [$ffa1], a
  xor a
  ld [$c5c7], a
  ld [$c6c5], a
  call $1B89
  ld a, $1
  ld [$c6c6], a
  pop hl
  ret

.Char4fMore:
  ld a, [hl]
  cp $1
  jr nz, .asm_1db6
  xor a
  ld [$c5c7], a
  ld [$c6c5], a
  call $1B89
  ld a, $1
  ld [$c6c6], a
  pop hl
  ret
.asm_1db6
  ld a, [hl]
  cp $2
  jr nz, .asm_1de4
  ld a, [$ff8d]
  and $3
  jr nz, .asm_1dd5
  ld a, [$ff8c]
  and $3
  jr z, .asm_1d89
  ld a, [$c6c5]
  cp $10
  jp z, .asm_1dd5
  inc a
  ld [$c6c5], a
  pop hl
  ret
.asm_1dd5
  ld a, $22
  ld [$ffa1], a
  xor a
  ld [$c6c5], a
  ld a, $1
  ld [$c6c6], a
  pop hl
  ret
.asm_1de4
  ld a, [hl]
  cp $3
  jr nz, .asm_1e1b
  ld a, [$ff8d]
  and $3
  jr nz, .asm_1e03
  ld a, [$ff8c]
  and $3
  jr z, .asm_1d89
  ld a, [$c6c5]
  cp $10
  jp z, .asm_1e03
  inc a
  ld [$c6c5], a
  pop hl
  ret
.asm_1e03
  ld a, $22
  ld [$ffa1], a
  ld b, $1
  ld c, $1
  ld e, $2f
  call LoadTilemapInWindow
  xor a
  ld [$c6c5], a
  ld a, $1
  ld [$c6c6], a
  pop hl
  ret
.asm_1e1b
  ld a, $1
  ld [$c6c6], a
  pop hl
  ret
Char4E::
  ld hl, $9c00
  ld bc, $0081
  ld a, [$c5c7]
  cp $1
  jr z, .asm_1e32
  ld bc, $0061
.asm_1e32
  add hl, bc
  ld a, h
  ld [$c6c2], a
  ld a, l
  ld [$c6c3], a
  ld a, [$c6c0]
  inc a
  ld [$c6c0], a
  pop hl
  jp PutCharLoop

Char4D::
; text speed
  inc hl
  ld a, [hl]
  ld [$c6c1], a
  ld [$c6c4], a
  ld a, [$c6c0]
  add $2
  ld [$c6c0], a
  pop hl
  ld a, [$c6c1]
  cp $ff
  ret nz
  xor a
  ld [$c6c1], a
  ret

Char4C::
; new text box
  pop hl
  ld hl, $9c00
  ld bc, $0092
  ld a, [$c5c7]
  cp $1
  jr z, .asm_1e73
  ld bc, $0072
.asm_1e73
  add hl, bc
  ld a, $fa
  di
  call WaitLCDController
  ld [hl], a
  ei
  ld a, [$ff8d]
  and $3
  jr nz, .asm_1e94
  ld a, [$ff8c]
  and $3
  ret z
  ld a, [$c6c5]
  cp $10
  jp z, .asm_1e94
  inc a
  ld [$c6c5], a
  ret
.asm_1e94
  ld a, $22
  ld [$ffa1], a
  xor a
  ld [$c6c5], a
  ld b, $1
  ld c, $1
  ld e, $2f
  call LoadTilemapInWindow
  ld a, [$c5c7]
  cp $1
  jr z, .asm_1eb5
  ld b, $0
  ld c, $0
  ld e, $30
  call LoadTilemapInWindow
.asm_1eb5
  ld hl, $9c00
  ld bc, $0041
  ld a, [$c5c7]
  cp $1
  jr z, .asm_1ec5
  ld bc, $0021
.asm_1ec5
  add hl, bc
  ld a, h
  ld [$c6c2], a
  ld a, l
  ld [$c6c3], a
  ld a, [$c6c0]
  inc a
  ld [$c6c0], a
  ret

Char4B::
; call subtext
  inc hl
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$c6c5]
  ld c, a
  ld b, $0
  add hl, bc
  ld a, [hl]
  cp $50
  jr nz, .asm_1f04 ; 0x1ee4 $1e
  ld a, [$c6c0]
  inc a
  inc a
  inc a
  ld [$c6c0], a
  xor a
  ld [$c6c5], a
  ld a, [$c6c4]
  ld [$c6c1], a
  pop hl
  cp $ff
  ret nz
  xor a
  ld [$c6c1], a
  jp PutCharLoop

.asm_1f04
  ld d, a
  ld a, $40
  sub d
  jp c, .asm_1f2f
  ld hl, $20CB
  ld c, d
  ld b, $0
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  push hl
  push af
  ld a, [$c6c2]
  ld h, a
  ld a, [$c6c3]
  ld l, a
  ld bc, $ffe0
  add hl, bc
  pop af
  di
  call WaitLCDController
  ld [hl], a
  ei
  pop hl
  ld a, [hl]
  ld d, a
.asm_1f2f
  ld a, [$c6c2]
  ld h, a
  ld a, [$c6c3]
  ld l, a
  ld a, d
  di
  call WaitLCDController
  ld [hl], a
  ei
  inc hl
  ld a, h
  ld [$c6c2], a
  ld a, l
  ld [$c6c3], a
  ld a, [$c6c5]
  inc a
  ld [$c6c5], a
  ld a, [$c6c4]
  ld [$c6c1], a
  pop hl
  cp $ff
  ret nz
  xor a
  ld [$c6c1], a
  jp PutCharLoop

Char4A::
; \r
  ld c, $1
  ld a, $41
  ld [$c650], a
  ld a, [$c5c7]
  cp $1
  jr z, .asm_1f74 ; 0x1f6b $7
  ld c, $0
  ld a, $21
  ld [$c650], a
.asm_1f74
  ld b, $1
  ld e, $2f
  call LoadTilemapInWindow
  ld hl, $9c00
  ld a, [$c650]
  ld b, $0
  ld c, a
  add hl, bc
  ld a, h
  ld [$c6c2], a
  ld a, l
  ld [$c6c3], a
  ld a, [$c6c0]
  inc a
  ld [$c6c0], a
  pop hl
  ret
