SECTION "Load Dialogue Font", ROM0[$2B49]
LoadMainDialogTileset::
  ld a, 3
  call DecompressAndLoadTiles ; Decompress
  ret

SECTION "Load Font sub", ROM0[$10E6]
LoadFont0:: ; 10E6 (0:10E6)
  ld hl, TilesetTable
  ld d, $00
  ld e, a
  sla e
  rl d
  add hl, de
  ld a, [hli] ;Follow pointer in table to struct
  ld h, [hl]
  ld l, a
  ld a, [hli] ;Retrieve bank
  rst $10 ;Bank swap
  ld a, [hli] ;Retrieve offset low bytes
  ld e, a
  ld a, [hli] ;Retrieve offset high bytes
  ld d, a
  ld a, [hli] ;For font type 2, this is 8800 (VRAM)
  ld h, [hl]
  ld l, a
  ld a, [de] ;Load first byte at bank:offset (01 is compressed, 00 is not)
  inc de
  jp LoadTiles
; 0x10ef

SECTION "Load Tiles", ROM0[$122A]
LoadTiles:: ; 122A (0:122A)
  cp $0
  jp z, NoDecompressLoadTiles
  ld a, h
  ld [$c5f6], a
  ld a, l
  ld [$c5f7], a
  ld a, [de]
  ld c, a
  inc de
  ld a, [de]
  ld b, a
  inc de
.read_next
  ld a, b
  or c
  jp z, NoDecompressLoadTiles.return
  ld a, [de]
  ld [$c5f5], a
  inc de
  ld a, [de]
  ld [$c5f4], a
  inc de
  ld a, $11
  ld [$c5f3], a
.loop
  ld a, b
  or c
  jp z, NoDecompressLoadTiles.return
  ld a, [$c5f3]
  dec a
  jp z, .read_next
  ld [$c5f3], a
  push de
  ld a, [$c5f4]
  ld d, a
  ld a, [$c5f5]
  ld e, a
  srl d
  ld a, d
  ld [$c5f4], a
  rr e
  ld a, e
  ld [$c5f5], a
  jp c, .break_loop
  pop de
  ld a, [$c5f6]
  ld h, a
  ld a, [$c5f7]
  ld l, a
  ld a, [de]
  di
  call WaitLCDController
  ld [hli], a
  ei
  ld a, h
  ld [$c5f6], a
  ld a, l
  ld [$c5f7], a
  dec bc
  inc de
  jp .loop
.break_loop
  pop de
  push de
  ld a, [de]
  ld l, a
  inc de
  ld a, [de]
  and $7
  ld h, a
  ld a, [de]
  srl a
  srl a
  srl a
  and $1f
  add $3
  ld [$c5f2], a
  ld a, h
  cpl
  ld d, a
  ld a, l
  cpl
  ld e, a
  ld a, [$c5f6]
  ld h, a
  ld a, [$c5f7]
  ld l, a
  add hl, de
  push hl
  pop de
  ld a, [$c5f6]
  ld h, a
  ld a, [$c5f7]
  ld l, a
.write_to_vram
  di
  call WaitLCDController
  ld a, [de]
  ei
  ld [hli], a
  dec bc
  inc de
  ld a, [$c5f2]
  dec a
  ld [$c5f2], a
  jp nz, .write_to_vram
  ld a, h
  ld [$c5f6], a
  ld a, l
  ld [$c5f7], a
  pop de
  inc de
  inc de
  jp .loop
NoDecompressLoadTiles:
  ld a, [de]
  ld c, a
  inc de
  ld a, [de]
  ld b, a
  inc de
.loop
  ld a, b
  or c
  jp z, .return
  ld a, [de]
  di
  call WaitLCDController
  ld [hli], a
  ei
  inc de
  dec bc
  jp .loop
.return:
  ret

DecompressAndLoadTiles::
  ld [$c650], a ;Store font type
  ld a, b
  ld [$c6d3], a
  xor a
  ld [$c64e], a
  ld a, [$c6ce]
  or a
  jp nz, .asm_132e
  ld a, $01
  ld [$c6ce], a
  ld a, [$c650]
  ld hl, TilesetTable
  ld d, $00
  ld e, a
  sla e
  rl d
  add hl, de
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [hli]
  ld [$c6d4], a
  rst $10
  ld a, [hli]
  ld e, a
  ld a, [hli]
  ld d, a
  ld a, [hli]
  ld h, [hl]
  ld l, a
  inc de
  ld a, h
  ld [$c5f6], a
  ld a, l
  ld [$c5f7], a
  ld a, [de]
  ld c, a
  inc de
  ld a, [de]
  ld b, a
  inc de
  jp .asm_1342

.asm_132e
  ld a, [$c6d4]
  rst $10
  ld a, [$c6cf]
  ld b, a
  ld a,[$c6d0]
  ld c, a
  ld a,[$c6d1]
  ld d, a
  ld a,[$c6d2]
  ld e, a

.asm_1342
  ld a, [$c6d3]
  or a
  jr nz, .asm_135e
  ld a, b
  ld [$c6cf], a
  ld a, c
  ld [$c6d0], a
  ld a, d
  ld [$c6d1], a
  ld a, e
  ld [$c6d2], a
  ld a, $01
  ld [$c64e], a
  ret
.asm_135e
