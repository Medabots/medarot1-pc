INCLUDE "game/src/common/constants.asm"

; Used to draw shop items, only thing I've seen that uses this so far (might need to move it elsewhere if it's used elsewhere)
; hl = text
; bc = index, added to $9800
SECTION "PutShopString", ROM0[$2E00]
PutShopString:: ; 2E00 (0:2E00)
  ld a, h
  ld [$c640], a
  ld a, l
  ld [$c641], a
  call $357A
  ld a, b
  and $1f
  ld b, a
  ld a, c
  and $1f
  ld c, a
  push bc
  ld c, b
  ld b, $00
  ld hl, $9800
  add hl, bc
  pop bc
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
  add hl, bc
  ld a, h
  ld [$c642], a
  ld a, l
  ld [$c643], a
.asm_3077
  ld a, [$c640]
  ld h, a
  ld a, [$c641]
  ld l, a
  ld a, [hl]
  cp $50
  ret z
  ld [$c64e], a
  call $2141
  ld a, [$c64f]
  or a
  jp z, .jpA
  ld a, [$c642]
  ld h, a
  ld a, [$c643]
  ld l, a
  ld bc, $ffe0
  add hl, bc
  call $2830
  ld a, [$c64f]
  di
  call WaitLCDController
  ld [hl], a
  ei

.jpA
  ld a, [$c642]
  ld h, a
  ld a, [$c643]
  ld l, a
  ld a, [$c64e]
  di
  call WaitLCDController
  ld [hl], a
  ei
  inc hl
  call $27C6
  ld a, h
  ld [$c642], a
  ld a, l
  ld [$c643], a
  ld a, [$c640]
  ld h, a
  ld a, [$c641]
  ld l, a
  inc hl
  ld a, h
  ld [$c640], a
  ld a, l
  ld [$c641], a
  jp .asm_3077
