SECTION "Tilemaps", ROMX[$4000], BANK[$1e]
Tilemaps:
; The tilemap pointer table can reference the same data multiple times
; This data needs to be dumped.

SECTION "Load Tilemaps", ROM0[$E3F]
LoadTilemap::
  ld a, BANK(Tilemaps)
  rst $10
  push de
  ld a, b
  and $1f
  ld b, a
  ld a, c
  and $1f
  ld c, a
  ld d, $0
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
  ld hl, $9800
  ld c, b
  ld b, $0
  add hl, bc
  add hl, de
  pop de
  push hl
  ld hl, Tilemaps
  ld d, $0
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld d, [hl]
  ld e, a
  pop hl
  ld b, h
  ld c, l
  ld a, [de]
  cp $ff
  jp z, $0F96
  and $3
  jr z, .asm_e7d ; 0xe71 $a
  dec a
  jr z, .asm_eac ; 0xe74 $36
  dec a
  jp z, $0F33
  jp $0F64
.asm_e7d
  inc de
  ld a, [de]
  cp $ff
  jp z, $0F96
  cp $fe
  jr z, .asm_e97 ; 0xe86 $f
  cp $fd
  jr z, .asm_ea6 ; 0xe8a $1a
  di
  call WaitLCDController
  ld [hli], a
  ei
  call $27C6
  jr .asm_e7d ; 0xe95 $e6
.asm_e97
  push de
  ld de, $0020
  ld h, b
  ld l, c
  add hl, de
  call $2830
  ld b, h
  ld c, l
  pop de
  jr .asm_e7d ; 0xea4 $d7
.asm_ea6
  inc hl
  call $27C6
  jr .asm_e7d ; 0xeaa $d1
.asm_eac
  inc de
  ld a, [de]
  cp $ff
  jp z, $0F96
  ld a, [de]
  and $c0
  cp $c0
  jp z, $0F1B
  cp $80
  jp z, $0F03
  cp $40
  jp z, $0EEC
  push bc
  ld a, [de]
  inc a
  ld b, a

.loop
  inc de
  ld a, [de]
  di
  call WaitLCDController
  ld [hli], a
  ei
  dec b
  jp nz, .loop
  pop bc
  jp .asm_eac
; 0xed9

SECTION "Load Tilemap in Window", ROM0[$0F97]
LoadTilemapInWindow::
  ld a, BANK(Tilemaps)
  rst $10
  push de
  ld a, b
  and $1f
  ld b, a
  ld a, c
  and $1f
  ld c, a
  ld d, 0
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
  ld hl, $9c00
  ld c, b
  ld b, 0
  add hl, bc
  add hl, de
  pop de
  push hl
  ld hl, Tilemaps
  ld d, 0
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld d, [hl]
  ld e, a
  pop hl
  ld b, h
  ld c, l
  ld a, [de]
  cp $ff
  jp z, $10E5
  and 3
  jr z, .asm_fd5
  dec a
  jr z, .asm_ffb
  dec a
  jp z, $1082
  jp $10B3
.asm_fd5
  inc de
  ld a, [de]
  cp $ff
  jp z, $10E5
  cp $fe
  jr z, .asm_fec
  cp $fd
  jr z, .asm_ff8
  di
  call WaitLCDController
  ld [hli], a
  ei
  jr .asm_fd5
.asm_fec
  push de
  ld de, $0020
  ld h, b
  ld l, c
  add hl, de
  ld b, h
  ld c, l
  pop de
  jr .asm_fd5
.asm_ff8
  inc hl
  jr .asm_fd5
.asm_ffb
  inc de
  ld a, [de]
  cp $ff
  jp z, $10E5
  ld a, [de]
  and $c0
  cp $c0
  jp z, $106A
  cp $80
  jp z, $1052
  cp $40
  jp z, $103B
  push bc
  ld a, [de]
  inc a
  ld b, a

.loop
  inc de
  ld a, [de]
  di
  call WaitLCDController
  ld [hli], a
  ei
  dec b
  jp nz, .loop
  pop bc
  jp .asm_ffb
; 0x1028