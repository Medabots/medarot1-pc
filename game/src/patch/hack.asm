INCLUDE "game/src/common/constants.asm"
INCLUDE "game/src/common/macros.asm"

SECTION "User Functions (Hack)", ROMX[$4000], BANK[$24]
HackPredef::
  push af
  ld a, h
  ld [TempH], a
  ld a, l
  ld [TempL], a
  pop af
  ld hl, HackPredefTable
  rst $30
  push hl ; Change return pointer to Hack function
  ld a, [TempH]
  ld h, a
  ld a, [TempL]
  ld l, a
  ret

HackPredefTable:
  dw VWFPadTextInit ;0
  dw GetTextOffset ;1
  dw ZeroTextOffset ;2
  dw VWFCountCharForCentring ;3
  dw VWFPutStringInit ;4
  dw VWFWriteCharLimited ;5
  dw VWFMapRenderedString ; 6
  dw $0000 ; 7
  dw SetNextChar ; 8
  dw VWFCalculateCentredTextOffsets ; 9
  dw LeftShiftBC ; A
  dw LeftShiftBC5 ; B
  dw VWFCalculateRightAlignedTextOffsets ; C
  dw VWFCalculateAutoNarrow ; D
  dw AddHLShiftBC5 ; E
  dw $0000 ; F
  dw $0000 ; 10
  dw $0000 ; 11
  dw VWFPutStringInitFullTileLocation ; 12
  dw $0000 ; 13
  dw $0000 ; 14
  dw $0000 ; 15
  dw $0000 ; 16
  dw $0000 ; 17
  dw $0000 ; 18
  dw $0000 ; 19
  dw $0000 ; 1A
  dw $0000 ; 1B
  dw $0000 ; 1C
  dw $0000 ; 1D
  dw $0000 ; 1E
  dw $0000 ; 1f
  dw $0000 ; 20
  dw $0000 ; 21
  dw $0000 ; 22
  dw $0000 ; 23
  dw $0000 ; 24
  dw $0000 ; 25
  dw $0000 ; 26
  dw $0000 ; 27
  dw $0000 ; 28
  dw $0000 ; 29

; bc = [WTextOffsetHi][$c6c0]
GetTextOffset:
  ld a, [$c6c0]
  ld c, a
  ld a, [WTextOffsetHi]
  ld b, a
  ret

ZeroTextOffset:
  xor a
  ld [$c6c0], a
  ld [WTextOffsetHi], a
  ld [FlagClearText], a
  ld [FlagNewLine], a
  ret

hLineMax           EQU $11 ;Max offset from start of line
hLineOffset        EQU $20 ;Bytes between line tiles
hLineCount         EQU $04 ;Total number of lines
hLineVRAMStart     EQU $9C00 ;Initial Tile VRAM location

SetNextChar: ; Override next character based on flags
  ld a, [FlagDo4C]
  cp $0
  jr z, .return
  ld a, [NextChar]
  cp $4c
  jr z, .is_4c
  ld a, $4c
  ld [TmpChar], a
  ld hl, TmpChar
.return
  ret
.is_4c
  xor a
  ld [FlagDo4C], a
  ret

; bc = bc << l
LeftShiftBC:
.loop
  sla c
  rl b
  dec l
  jr nz, .loop
.return
  ret

; bc = bc << 5
LeftShiftBC5:
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
  ret

AddHLShiftBC5:
  sla c
  rl b
  add hl, bc
  add hl, bc
  add hl, bc
  add hl, bc
  add hl, bc
  ret

