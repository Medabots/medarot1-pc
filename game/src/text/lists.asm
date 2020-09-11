; Includes logic for dealing with "list" text (Medals, Items, Medarots)
; Data is fixed size, so no need for a pointer table

INCLUDE "game/src/common/constants.asm"

SECTION "Load from Item List", ROM0[$3053]
LoadItemList::
  push af
  ld a, BANK(ItemList)
  rst $10
  pop af
  ld hl, ItemList - $10
  ld b, $0
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
  ld de, cBUF01
  ld b, $9 ; Despite having 16 bytes per item, it only looks at 10
.asm_32b2
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_32b2 ; 0x32b6 $fa
  ret
  nop
  nop
; 0x32b9

SECTION "Load from Medal List", ROM0[$307d]
LoadMedalList::
  push af
  ld a, BANK(MedalList)
  rst $10
  pop af
  ld hl, MedalList
  ld b, $0
  ld c, a
  sla c
  rl b
  sla c
  rl b
  sla c
  rl b
  add hl, bc
  ld de, cBUF01
  ld b, $7
.asm_32d8
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_32d8 ; 0x32dc $fa
  ret
  nop
  nop
; 0x32df

SECTION "Load from Medarot List", ROM0[$33a0]
LoadMedarotList::
  push hl
  push de
  ld a, BANK(MedarotList)
  rst $10
  ld hl, MedarotList
  ld b, $0
  ld a, $4
  call GetListTextOffset
  ld de, cBUF01
.loop
  ld a, [hli]
  cp $50
  jr z, .asm_35fa ; 0x35f3 $5
  ld [de], a
  inc de
  jp .loop
.asm_35fa
  ld a, $50
  ld [de], a
  pop de
  pop hl
  ret
  nop
  nop
; 0x3600

SECTION "Load from Part List", ROM0[$32b4]
LoadPartList::
  ld [$c64e], a
  ld a, BANK(PartList)
  rst $10
  ld a, b
  or a
  jp nz, .load_model_no
  ld hl, .part_list_table
  ld b, $0
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$c64e]
  ld b, $0
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
  ld de, cBUF01
  ld b, $9
.asm_3526
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_3526 ; 0x352a $fa
  ret
.load_model_no
  ld hl, .part_list_table
  ld b, $0
  sla c
  rl b
  add hl, bc
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ld a, [$c64e]
  ld b, $0
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
  ld b, $0
  ld c, $9
  add hl, bc
  ld de, cBUF01
  ld b, $7
.asm_355b
  ld a, [hli]
  ld [de], a
  inc de
  dec b
  jr nz, .asm_355b ; 0x355f $fa
  ret
  nop
  nop
.part_list_table
; Actually quite surprising it's in ROM0, since there's no need for flexibility with banks (all part lists are in 1c)
  dw HeadPartList
  dw RightPartList
  dw LeftPartList
  dw LegPartList

SECTION "GetListTextOffset", ROM0[$3745]
GetListTextOffset:: ; 34c4
.asm_3981
  sla c
  rl b
  dec a
  jr nz, .asm_3981 ; 0x3986 $f9
  add hl, bc
  ld d, h
  ld e, l
  ret
; 0x398c