SECTION "SetupDialog", ROM0[$1D60]
SetupDialog::
  ld [$c5c7], a
  xor a
  ld [$c5c8], a
  inc a
  ld [VWFIsInit], a
  call $1B89
  xor a
  ld a, $2
  rst $8 ; ZeroTextOffset
  ld [$c6c5], a
  ld [$c6c6], a
  ld hl, .undumpedtable
  ld b, 0
  ld a, [$c765]
  ld c, a
  add hl, bc
  ld a, [hl]
  ld [$c6c1], a
  ld [$c6c4], a
  ld h, $9c
  ld l, $41
  ld a, [$c5c7]
  cp 1
  jr z, .asm_1cbc
  ld l, $21
.asm_1cbc
  ld a, h
  ld [$c6c2], a
  ld a, l
  ld [$c6c3], a
  ret
.undumpedtable

SECTION "PutChar", ROM0[$1DA2]
PutChar::
  ld a, [$c6c6]
  or a
  ret nz
  ld a, [VWFTilesDrawn]
  sub $2
  jr nc, .asm_1cda ; 0x1cd3 $5
  ld a, $1
  ld [$c600], a
.asm_1cda
  ld a, [$c6c1]
  or a
  jr z, .asm_1ce5 ; 0x1cde $5
  dec a
  ld [$c6c1], a
  ret
.asm_1ce5
  push bc
  ld a, b
  and $f0
  swap a
  push af
  ld hl, TextTableBanks
  rst $28
  ld a, [hl]
  rst $10 ;Swap to the correct bank
  pop af
  ld hl, TextTableOffsets ;Go to the start of the dialog in this bank
  ld b, 0
  ld c, a
  add hl, bc
  add hl, bc
  rst $38
  pop bc
  ld a, b
  and $f
  ld b, a
  add hl, bc ;Pointers to text in each of the banks now also have the bank offset, so instead of logical shifts just add it 3 times 
  add hl, bc
  add hl, bc
  ld a, [hli] ;To have more room for text, change the pointer table to include banks ({Bank:1, Address:2 (LE)})
  push af
  rst $38
  pop af
  ld [VWFTrackBank], a
  rst $10

PutCharLoop:: ; things jump to here after the control code
  push hl
  ld a, $1 ; GetTextOffset
  rst $8
  add hl, bc
  call GetNextChar

  ; Store the current character index as well as potential arguments for control codes in WRAM. Point hl to WRAM location.
  ld b, h
  ld c, l
  call VWFWordLengthTest
  ld hl, VWFCurrentLetter
  ld a, [bc]
  ld [hli], a
  inc bc
  ld a, [bc]
  ld [hli], a
  inc bc
  ld a, [bc]
  ld [hld], a
  dec l

  ; Switch to the bank where the vwf font is located.
  ld a, BANK(VWFFont)
  rst $10
  
  ; From here on out there is no reason for us to operate in bank 0 until the next character is required.
  jp VWFDrawCharLoop

PutCharLoopWithBankSwitch::
  ; Swap to the bank with the text before jumping back
  ld a, [VWFTrackBank]
  rst $10
  jr PutCharLoop
  nop
  nop
  nop
  nop
  nop

hPSTextAddrHi          EQU $c640
hPSTextAddrLo          EQU $c641
hPSVRAMAddrHi          EQU $c642
hPSVRAMAddrLo          EQU $c643
hPSCurrChar            EQU $c64e
hPSCurrCharTile        EQU $c64f
SECTION "PutString", ROM0[$2D93]
PutString:: ; 2D93
  ld a, h
  ld [hPSTextAddrHi], a
  ld a, l
  ld [hPSTextAddrLo], a
  ld a, b
  ld [hPSVRAMAddrHi], a
  ld a, c
  ld [hPSVRAMAddrLo], a
.char
  ld a, [hPSTextAddrHi]
  ld h, a
  ld a, [hPSTextAddrLo]
  ld l, a
  ld a, [hl]
  cp $50
  ret z
  ld [hPSCurrChar], a
  call $2141
  ld a, [hPSCurrCharTile]
  or a
  jp z, .write_vram
  ld a, [hPSVRAMAddrHi]
  ld h, a
  ld a, [hPSVRAMAddrLo]
  ld l, a
  ld bc, $ffe0
  add hl, bc
  ld a, [hPSCurrCharTile]
  di
  call WaitLCDController
  ld [hl], a
  ei
.write_vram
  ld a, [hPSVRAMAddrHi]
  ld h, a
  ld a, [hPSVRAMAddrLo]
  ld l, a
  ld a, [hPSCurrChar]
  di
  call WaitLCDController
  ld [hl], a
  ei
  inc hl
  ld a, h
  ld [hPSVRAMAddrHi], a
  ld a, l
  ld [hPSVRAMAddrLo], a
  ld a, [hPSTextAddrHi]
  ld h, a
  ld a, [hPSTextAddrLo]
  ld l, a
  inc hl
  ld a, h
  ld [hPSTextAddrHi], a
  ld a, l
  ld [hPSTextAddrLo], a
  jp .char

SECTION "PadTextTo8", ROM0[$3288]
; Centers text given 8 tiles
; [hl] = text
PadTextTo8:: ; 3288
  push hl
  push bc
  ld b, $0
.asm_34c8
  ld a, [hli]
  cp $50
  jr z, .asm_34d0 ; 0x34cb $3
  inc b
  jr .asm_34c8 ; 0x34ce $f8
.asm_34d0
  ld a, $8
  sub b
  srl a
  pop bc
  pop hl
  ret
; 0x34d8
