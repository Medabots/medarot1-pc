INCLUDE "game/src/common/constants.asm"
INCLUDE "game/src/common/macros.asm"

SECTION "SGB Functions 1", ROMX[$4000], BANK[$1F]
SGB_InstallBorderAndHotpatches::
  ld bc, $78
  call SGB_AdjustableWait

  ld hl, SGB_PacketFreezeScreen
  call SGB_SendPackets
  ld bc, 4
  call SGB_AdjustableWait

  ld hl, SGB_PacketHotfix + ($10 * 0)
  call SGB_SendPackets
  ld bc, 4
  call SGB_AdjustableWait
  ld hl, SGB_PacketHotfix + ($10 * 1)
  call SGB_SendPackets
  ld bc, 4
  call SGB_AdjustableWait
  ld hl, SGB_PacketHotfix + ($10 * 2)
  call SGB_SendPackets
  ld bc, 4
  call SGB_AdjustableWait
  ld hl, SGB_PacketHotfix + ($10 * 3)
  call SGB_SendPackets
  ld bc, 4
  call SGB_AdjustableWait
  ld hl, SGB_PacketHotfix + ($10 * 4)
  call SGB_SendPackets
  ld bc, 4
  call SGB_AdjustableWait
  ld hl, SGB_PacketHotfix + ($10 * 5)
  call SGB_SendPackets
  ld bc, 4
  call SGB_AdjustableWait
  ld hl, SGB_PacketHotfix + ($10 * 6)
  call SGB_SendPackets
  ld bc, 4
  call SGB_AdjustableWait
  ld hl, SGB_PacketHotfix + ($10 * 7)
  call SGB_SendPackets
  ld bc, 4
  call SGB_AdjustableWait

  ld hl, SGB_PaletteData
  ld de, SGB_PacketPaletteTransfer
  call SGB_SendPacketsWithVRAM

  ld hl, SGB_AttrFileData
  ld de, SGB_PacketAttrTransfer
  call SGB_SendPacketsWithVRAM

  ld hl, SGB_BorderGfx
  ld de, SGB_PacketTileTransferLow
  call SGB_SendPacketsWithVRAM

  ld hl, SGB_BorderGfx + $1000
  ld de, SGB_PacketTileTransferHigh
  call SGB_SendPacketsWithVRAM

  ld hl, SGB_BorderTilemap
  ld de, SGB_PacketBorderTmapTransfer
  call SGB_SendPacketsWithVRAM

  ld hl, SGB_PacketUnfreezeScreen
  call SGB_SendPackets

  ld bc, $40
  call SGB_AdjustableWait

  ld b, 0
  ld c, 0
  ld d, 0
  ld e, 0
  ld a, 0
  jp $0309 ; JumpTable_309

SGB_ReinstallBorder::
  ld hl, SGB_PacketFreezeScreen
  call SGB_SendPackets
  ld bc, 4
  call SGB_AdjustableWait

  ld hl, SGB_BorderGfx
  ld de, SGB_PacketTileTransferLow
  call SGB_SendPacketsWithVRAM

  ld hl, SGB_BorderGfx + $1000
  ld de, SGB_PacketTileTransferHigh
  call SGB_SendPacketsWithVRAM

  ld hl, SGB_BorderTilemap
  ld de, SGB_PacketBorderTmapTransfer
  call SGB_SendPacketsWithVRAM

  ld hl, SGB_PacketUnfreezeScreen
  call SGB_SendPackets
  ld bc, $20
  call SGB_AdjustableWait
  ret

SGB_EnableDefaultScreenAttributes::
  ld hl, SGB_PacketFreezeScreen
  call SGB_SendPackets
  ld bc, 4
  call SGB_AdjustableWait

  ld hl, SGB_PacketSetDefaultPaletteAttrs
  call SGB_SendPackets
  ld bc, 4
  call SGB_AdjustableWait

  ret

SGB_SendConstructedPaletteSetPacket::
  ld hl, $C8D0
  call SGB_SendPackets
  ld bc, 3
  call SGB_AdjustableWait
  ret

SGB_PacketSetDefaultPaletteAttrs::
  db $51      ;PAL_SET
  dw 0,0,0,0    ;Use all palette 0
  db $C2      ;Use attribute file $2, unfreeze screen
  db 0,0,0,0,0,0

SGB_AdjustableWait::
  ld de, $6D6

.wasteCycles
  nop
  nop
  nop
  dec de

  ld a, d
  or e
  jr nz, .wasteCycles

  dec bc
  ld a, b
  or c
  jr nz, SGB_AdjustableWait
  ret

SGB_SendPackets::
  ld a, [hl]
  and 7
  ret z

  ld b, a
  ld c, 0

.beginPacket
  push bc

  ld a, 0
  ld [c], a
  ld a, $30
  ld [c], a

  ld b, $10

.beginByte
  ld e, 8

  ld a, [hli]
  ld d, a

.beginBit
  bit 0, d
  ld a, $10
  jr nz, .sendOneBit

.sendZeroBit
  ld a, $20

.sendOneBit
  ld [c], a

  ld a, $30
  ld [c], a

  rr d
  dec e
  jr nz, .beginBit

  dec b
  jr nz, .beginByte

  ld a, $20
  ld [c], a
  ld a, $30
  ld [c], a

  pop bc
  dec b
  ret z

.nextPacket
  call SGB_FrameWait
  jr .beginPacket

SGB_SendPacketsWithVRAM::
  di

  push de
  call $0192 ; JumpTable_192
  ld a, $E4
  ldh [hRegBGP], a

  ld de, $8800
  ld bc, $1000
  call SGB_CopyVRAMPacketData

  ld hl, $9800
  ld de, $C
  ld a, $80
  ld c, $D

.drawLine
  ld b, $14

.drawTile
  ld [hli], a
  inc a
  dec b
  jr nz, .drawTile

  add hl, de
  dec c
  jr nz, .drawLine

  ld a, $81
  ldh [hRegLCDC], a

  ld bc, 5
  call SGB_AdjustableWait

  pop hl
  call SGB_SendPackets
  ld bc, 6
  call SGB_AdjustableWait

  ei

  ret

SGB_CopyVRAMPacketData::
  ld a, [hli]
  ld [de], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, SGB_CopyVRAMPacketData
  ret

SGB_DetectICDPresence::
  ld hl, SGB_PacketEnableMultiplayer
  call SGB_SendPackets
  call SGB_FrameWait

  ldh a, [hRegJoyp]
  and 3
  cp 3
  jr nz, .sgbNotDetected

.secondarySgbCheck
  ld a, $20
  ldh [hRegJoyp], a

  ldh a, [hRegJoyp]
  ldh a, [hRegJoyp]

  ld a, $30
  ldh [hRegJoyp], a
  ld a, $10
  ldh [hRegJoyp], a

  ldh a, [hRegJoyp]
  ldh a, [hRegJoyp]
  ldh a, [hRegJoyp]
  ldh a, [hRegJoyp]
  ldh a, [hRegJoyp]
  ldh a, [hRegJoyp]

  ld a, $30
  ldh [hRegJoyp], a

  ldh a, [hRegJoyp]
  ldh a, [hRegJoyp]
  ldh a, [hRegJoyp]
  ldh a, [hRegJoyp]

  and 3
  cp 3
  jr nz, .sgbNotDetected

.sgbDetected
  ld hl, SGB_PacketDisableMultiplayer
  call SGB_SendPackets
  call SGB_FrameWait
  sub a
  ret

.sgbNotDetected
  ld hl, SGB_PacketDisableMultiplayer
  call SGB_SendPackets
  call SGB_FrameWait
  scf
  ret

SGB_PacketDisableMultiplayer::
  db $89
  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_PacketEnableMultiplayer::
  db $89
  db 1
  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_FrameWait::
  ld de, $1B58

.wasteCycles
  nop
  nop
  nop

  dec de
  ld a, d
  or e
  jr nz, .wasteCycles

  ret

SGB_PacketPaletteTransfer::
  db $59
  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_PacketTileTransferLow::
  db $99
  db 0
  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_PacketTileTransferHigh::
  db $99
  db 1
  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_PacketBorderTmapTransfer::
  db $A1
  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_PacketAttrTransfer::
  db $A9
  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_PacketUnfreezeScreen::
  db $B9
  db 0
  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_PacketFreezeScreen::
  db $B9
  db 1
  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0

SGB_PacketHotfix::
  db $79
  dw $085D
  db 0
  db $B
  db $8C, $D0, $F4, $60, 0, 0, 0, 0, 0, 0, 0

  db $79
  dw $0852
  db 0
  db $B
  db $A9, $E7, $9F, $01, $C0, $7E, $E8, $E8, $E8, $E8, $E0

  db $79
  dw $0847
  db 0
  db $B
  db $C4, $D0, $16, $A5, $CB, $C9, $05, $D0, $10, $A2, $28

  db $79
  dw $083C
  db 0
  db $B
  db $F0, $12, $A5, $C9, $C9, $C8, $D0, $1C, $A5, $CA, $C9

  db $79
  dw $0831
  db 0
  db $B
  db $0C, $A5, $CA, $C9, $7E, $D0, $06, $A5, $CB, $C9, $7E

  db $79
  dw $0826
  db 0
  db $B
  db $39, $CD, $48, $0C, $D0, $34, $A5, $C9, $C9, $80, $D0

  db $79
  dw $081B
  db 0
  db $B
  db $EA, $EA, $EA, $EA, $EA, $A9, $01, $CD, $4F, $0C, $D0

  db $79
  dw $0810
  db 0
  db $B
  db $4C, $20, $08, $EA, $EA, $EA, $EA, $EA, $60, $EA, $EA

SGB_PaletteData::
  dw $7FFF, $6F7B, $5294, $0000 ; 00
  dw $7FFF, $35BB, $295B, $001B ; 01
  dw $7FFF, $43BF, $02DF, $0000 ; 02
  dw $7FFF, $035F, $019F, $0000 ; 03
  dw $7FFF, $77CF, $5F60, $0000 ; 04
  dw $7FFF, $7F44, $5122, $0000 ; 05
  dw $7FFF, $4791, $11A4, $0000 ; 06
  dw $7FFF, $335F, $017A, $0000 ; 07
  dw $7FFF, $56DF, $18F6, $0000 ; 08
  dw $7FFF, $1B7C, $2A12, $0000 ; 09
  dw $7FFF, $5BF6, $00E0, $0000 ; 0A
  dw $7FFF, $7A00, $4400, $0000 ; 0B
  dw $7FFF, $7ADB, $4990, $0000 ; 0C
  dw $7FFF, $7FCC, $6D8E, $0000 ; 0D
  dw $7FFF, $377F, $09FF, $0000 ; 0E
  dw $7FFF, $2BF4, $26CE, $0000 ; 0F
  dw $7FFF, $4B3E, $29F3, $0000 ; 10
  dw $7FFF, $3A7F, $1977, $0000 ; 11
  dw $7FFF, $4A98, $726F, $0000 ; 12
  dw $7FFF, $4B91, $4EB7, $0000 ; 13
  dw $7FFF, $73F5, $6681, $0000 ; 14
  dw $7FFF, $4EFF, $01BD, $0000 ; 15
  dw $7FFF, $47FC, $1ECE, $0000 ; 16
  dw $7FFF, $7F7D, $6515, $0000 ; 17
  dw $7FFF, $4AFF, $19B7, $0000 ; 18
  dw $7FFF, $7315, $5185, $0000 ; 19
  dw $7FFF, $6F74, $3624, $0000 ; 1A
  dw $7FFF, $4F9E, $0294, $0000 ; 1B
  dw $7FFF, $465B, $28F6, $0000 ; 1C
  dw $7FFF, $035F, $01BF, $0000 ; 1D
  dw $7FFF, $6EDB, $255B, $0000 ; 1E
  dw $7FFF, $62F9, $4A33, $0000 ; 1F
  dw $7FFF, $5EAB, $54E0, $0000 ; 20
  dw $7FFF, $7B1F, $493A, $0000 ; 21
  dw $7FFF, $7F74, $7D52, $0000 ; 22
  dw $7FFF, $1B7F, $0239, $0000 ; 23
  dw $7FFF, $4BB7, $6A0B, $0000 ; 24
  dw $7FFF, $6F58, $528A, $0000 ; 25
  dw $7FFF, $53F8, $0A3A, $0000 ; 26
  dw $7FFF, $4EDF, $199F, $0000 ; 27
  dw $7FFF, $573E, $2614, $0000 ; 28
  dw $7FFF, $7313, $51CC, $0000 ; 29
  dw $7FFF, $3FFE, $1F5C, $0000 ; 2A
  dw $7FFF, $62BF, $3158, $0000 ; 2B
  dw $7FFF, $6E73, $51A6, $0000 ; 2C
  dw $7FFF, $6276, $3137, $0000 ; 2D
  dw $7FFF, $5B7F, $2B1D, $0000 ; 2E
  dw $7FFF, $7F1B, $0000, $0000 ; 2F
  dw $7FFF, $6F0D, $51E0, $0000 ; 30
  dw $7FFF, $6F3F, $317A, $0000 ; 31
  dw $7FFF, $4B7F, $0A12, $0000 ; 32
  dw $7FFF, $2B76, $1E20, $0000 ; 33
  dw $7FFF, $3B3F, $0A12, $0000 ; 34
  dw $7FFF, $7F78, $5E2D, $0000 ; 35
  dw $7FFF, $4AFF, $1172, $0000 ; 36
  dw $7FFF, $774D, $51A0, $0000 ; 37
  dw $7FFF, $7F5F, $7E3F, $0000 ; 38
  dw $7FFF, $6B1F, $367F, $0008 ; 39
  dw $7FFF, $671F, $0017, $0000 ; 3A
  dw $7FFF, $631F, $0437, $0000 ; 3B
  dw $7FFF, $631F, $0858, $0000 ; 3C
  dw $7FFF, $633F, $0C98, $0000 ; 3D
  dw $7FFF, $5F3F, $10B9, $0000 ; 3E
  dw $7FFF, $5F3F, $14F9, $0000 ; 3F
  dw $7FFF, $5F5F, $191A, $0000 ; 40
  dw $7FFF, $5B5F, $1D5A, $0000 ; 41
  dw $7FFF, $5B7F, $217B, $0000 ; 42
  dw $7FFF, $5B7F, $25BB, $0000 ; 43
  dw $7FFF, $577F, $29DC, $0000 ; 44
  dw $7FFF, $579F, $2E1C, $0000 ; 45
  dw $7FFF, $579F, $323D, $0000 ; 46
  dw $7FFF, $53BF, $367D, $0000 ; 47
  dw $7FFF, $53BF, $3A9E, $0000 ; 48
  dw $7FFF, $53DF, $42DF, $0000 ; 49
  dw $7FFF, $53DE, $42BC, $0000 ; 4A
  dw $7FFF, $57DD, $46BA, $0000 ; 4B
  dw $7FFF, $5BDD, $4AB8, $0000 ; 4C
  dw $7FFF, $5BDC, $4E96, $0000 ; 4D
  dw $7FFF, $5FDC, $5294, $0000 ; 4E
  dw $7FFF, $63DB, $5692, $0000 ; 4F
  dw $7FFF, $67DA, $5A90, $0000 ; 50
  dw $7FFF, $67DA, $5E6E, $0000 ; 51
  dw $7FFF, $6BD9, $626C, $0000 ; 52
  dw $7FFF, $6FD9, $666A, $0000 ; 53
  dw $7FFF, $73D8, $6A68, $0000 ; 54
  dw $7FFF, $73D7, $6E46, $0000 ; 55
  dw $7FFF, $77D7, $7244, $0000 ; 56
  dw $7FFF, $7BD6, $7642, $0000 ; 57
  dw $7FFF, $7FF6, $7A40, $0000 ; 58
  dw $7FFF, $7BF6, $7240, $0000 ; 59
  dw $7FFF, $77F6, $6A41, $0000 ; 5A
  dw $7FFF, $73F6, $6242, $0000 ; 5B
  dw $7FFF, $6FF6, $5A63, $0000 ; 5C
  dw $7FFF, $6FF6, $5263, $0000 ; 5D
  dw $7FFF, $6BF6, $4A64, $0000 ; 5E
  dw $7FFF, $67F6, $4265, $0000 ; 5F
  dw $7FFF, $63F6, $3A86, $0000 ; 60
  dw $7FFF, $5FF6, $3287, $0000 ; 61
  dw $7FFF, $5FF6, $2A87, $0000 ; 62
  dw $7FFF, $5BF6, $2288, $0000 ; 63
  dw $7FFF, $57F6, $1AA9, $0000 ; 64
  dw $7FFF, $53F6, $12AA, $0000 ; 65
  dw $7FFF, $4FF6, $0AAB, $0000 ; 66
  dw $7FFF, $4FF6, $02CC, $0000 ; 67
  dw $7FFF, $4FD6, $028C, $0000 ; 68
  dw $7FFF, $4FD7, $026D, $0000 ; 69
  dw $7FFF, $53B7, $022E, $0000 ; 6A
  dw $7FFF, $53B8, $020E, $0000 ; 6B
  dw $7FFF, $5398, $01CF, $0000 ; 6C
  dw $7FFF, $5799, $01B0, $0000 ; 6D
  dw $7FFF, $577A, $0171, $0000 ; 6E
  dw $7FFF, $5B7A, $0151, $0000 ; 6F
  dw $7FFF, $5B5B, $0112, $0000 ; 70
  dw $7FFF, $5B5B, $00F3, $0000 ; 71
  dw $7FFF, $5F3C, $00B4, $0000 ; 72
  dw $7FFF, $5F3D, $0094, $0000 ; 73
  dw $7FFF, $631D, $0055, $0000 ; 74
  dw $7FFF, $631E, $0036, $0000 ; 75
  dw $0000, $0000, $0000, $0000 ; 76

SGB_AttrFileData::
; ATF File 00

  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000

; ATF File 01

  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000

; ATF File 02

  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000

; ATF File 03

  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 2222,2222,2222,2222,2222
  atfline 2222,2222,2222,2222,2222
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000

; ATF File 04

  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 1112,2122,1111,2211,1111
  atfline 1112,2122,1111,2211,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1112,2122,1221,2212,2111
  atfline 1112,2122,1221,2212,2000
  atfline 1111,1100,0111,1101,1000
  atfline 1111,1022,1221,2212,2000
  atfline 1111,0022,1221,2212,2000
  atfline 1110,0000,0110,0001,1000
  atfline 0000,0022,0220,0022,2000
  atfline 0000,0022,0220,0222,2000
  atfline 0000,0000,0110,0200,0000
  atfline 0000,0000,0220,0000,0000
  atfline 0000,0000,0220,0000,0000

; ATF File 05

  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0010,0000,0001
  atfline 1111,1111,1110,0000,0001
  atfline 1221,2212,2110,0000,0001
  atfline 1221,2212,2110,0000,0001
  atfline 1111,1111,1110,0000,0001
  atfline 1221,2212,2110,0000,0001
  atfline 1221,2212,2110,0000,0001
  atfline 1111,1111,1111,1111,1111
  atfline 1221,2212,2111,1111,1111
  atfline 1221,2212,2111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111

; ATF File 06

  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0012,2222,2221
  atfline 0000,0000,0012,2222,2221
  atfline 0000,0000,0012,2222,2221
  atfline 0000,0000,0012,2222,2221
  atfline 0000,0000,0012,2222,2221
  atfline 0000,0000,0012,2222,2221
  atfline 0000,0000,0012,2222,2221
  atfline 0000,0000,0012,2222,2221
  atfline 0000,0000,0012,2222,2221
  atfline 0000,0000,0012,2222,2221
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0012,2222,2221
  atfline 0000,0000,0012,2222,2221
  atfline 0000,0000,0012,2222,2221
  atfline 0000,0000,0012,2222,2221
  atfline 0000,0000,0011,1111,1111

; ATF File 07

  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1101
  atfline 1111,1111,1111,1111,1101
  atfline 1111,1111,1111,1111,1101
  atfline 1111,1111,1111,1111,1101
  atfline 1111,1111,1111,1111,1101
  atfline 1111,1111,1111,1111,1101
  atfline 1111,1111,1111,1111,1101
  atfline 1111,1111,1111,1111,1101
  atfline 1111,1111,1111,1111,1111

; ATF File 08

  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 2222,2222,2211,1111,1111
  atfline 2222,2222,2211,1111,1111
  atfline 2222,2222,2211,1111,1111
  atfline 2222,2222,2211,1111,1111
  atfline 2222,2222,2211,1111,1111
  atfline 2222,2222,2211,1111,1111
  atfline 2222,2222,2211,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111

; ATF File 09

  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 0000,0000,0011,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111

; ATF File 0A

  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 2222,2222,2222,2222,2222
  atfline 2222,2222,2222,2222,2222
  atfline 2222,2222,2222,2222,2222
  atfline 2222,2222,2222,2222,2222
  atfline 2222,2222,2222,2222,2222
  atfline 2222,2222,2222,2222,2222
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111

; ATF File 0B

  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 2222,2111,1111,1113,3333
  atfline 2222,2111,1111,1113,3333
  atfline 2222,2111,1111,1113,3333
  atfline 2222,2111,1111,1113,3333
  atfline 2222,2111,1111,1113,3333
  atfline 2222,2111,1111,1113,3333
  atfline 2222,2111,1111,1113,3333
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000

; ATF File 0C

  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0111,1111,1000,0000,0000
  atfline 0111,1111,1000,0000,0000
  atfline 0111,1111,1000,0000,0000
  atfline 0111,1111,1000,0000,0000
  atfline 0111,1111,1000,0000,0000
  atfline 0111,1111,1000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000

; ATF File 0D

  atfline 1111,1111,1111,1111,1110
  atfline 1111,1111,1111,1111,1110
  atfline 1111,1111,1111,1111,1110
  atfline 1111,1111,1111,1111,1110
  atfline 1111,1111,1111,1111,1110
  atfline 1111,1111,1111,1111,1110
  atfline 1111,1111,1111,1111,1110
  atfline 1111,1111,1111,1111,1110
  atfline 1111,1111,1111,1111,1110
  atfline 1111,1111,1111,1111,1110
  atfline 1111,1111,1111,1111,1110
  atfline 1111,1111,1111,1111,1110
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111
  atfline 1111,1111,1111,1111,1111

; ATF File 0E

  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033
  atfline 2200,0000,0000,0000,0033

; ATF File 10

  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0000,0000,0000,0000,0000
  atfline 0011,1111,1110,0000,0000
  atfline 0011,1111,1110,0000,0000
  atfline 0000,0000,0000,0000,0000

SGB_BorderGfx::
  INCBIN "text/tilesets/sgb/border.4bpp"

SGB_BorderTilemap::
  dw $01|P6, $02|P6, $03|P6, $04|P6, $05|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $01|P6, $02|P6, $03|P6, $04|P6, $05|P6, $01|P6
  dw $06|P6, $07|P6, $08|P6, $09|P6, $0A|P6, $0B|P6, $0C|P6, $0D|P6, $0D|P6, $0D|P6, $0D|P6, $0D|P6, $0D|P6, $0D|P6, $0D|P6, $0D|P6, $0D|P6, $0D|P6, $0D|P6, $0D|P6, $0D|P6, $0D|P6, $0D|P6, $0D|P6, $0D|P6, $0D|P6, $06|P6, $07|P6, $08|P6, $09|P6, $0A|P6, $0B|P6
  dw $0E|P6, $0F|P6, $10|P6, $11|P6, $12|P6, $13|P6, $14|P6, $15|P6, $16|P6, $17|P6, $18|P6, $19|P6, $1A|P6, $1B|P6, $1C|P6, $1D|P6, $1D|P6, $1D|P6, $1D|P6, $1D|P6, $1D|P6, $1D|P6, $1D|P6, $1D|P6, $1D|P6, $1D|P6, $0E|P6, $0F|P6, $10|P6, $11|P6, $12|P6, $13|P6
  dw $0E|P6, $1E|P6, $1F|P6, $20|P6, $21|P6, $13|P6, $22|P6, $23|P6, $23|P6, $23|P6, $23|P6, $23|P6, $23|P6, $23|P6, $24|P6, $25|P6, $25|P6, $25|P6, $25|P6, $25|P6, $25|P6, $25|P6, $25|P6, $25|P6, $25|P6, $25|P6, $0E|P6, $1E|P6, $1F|P6, $20|P6, $21|P6, $13|P6
  dw $0E|P6, $26|P6, $27|P6, $28|P6, $29|P6, $13|P6, $2A|P6, $2A|P6, $2A|P6, $2B|P6, $2C|P6, $2C|P6, $2D|P6, $2A|P6, $2A|P6, $2A|P6, $2A|P6, $2A|P6, $2A|P6, $2B|P6, $2C|P6, $2C|P6, $2D|P6, $2A|P6, $2A|P6, $2A|P6, $0E|P6, $2E|P6, $2F|P6, $28|P6, $29|P6, $13|P6
  dw $30|P6, $31|P6, $32|P6, $33|P6, $34|P6, $35|P6, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $36|P6, $37|P6, $32|P6, $33|P6, $38|P6, $39|P6
  dw $3A|P6, $3B|P6, $3C|P6, $3D|P6, $3E|P6, $3F|P6, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $3F|P6, $40|P6, $41|P6, $42|P6, $43|P6, $44|P6
  dw $45|P4, $45|P4, $45|P4, $45|P4, $45|P4, $3F|P6, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $3F|P6, $45|P5, $45|P5, $45|P5, $45|P5, $45|P5
  dw $46|P4, $46|P4, $46|P4, $47|P4, $48|P4, $3F|P6, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $3F|P6, $49|P5, $4A|P5, $46|P5, $46|P5, $46|P5
  dw $4B|P4, $4B|P4, $4C|P4, $4D|P4, $4E|P4, $4F|P6, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $50|P6, $51|P5, $52|P5, $53|P5, $4B|P5, $4B|P5
  dw $54|P4, $55|P4, $56|P4, $57|P4, $58|P4, $59|P6, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $5A|P6, $5B|P5, $5C|P5, $5D|P5, $5E|P5, $54|P5
  dw $5F|P4, $60|P4, $61|P4, $62|P4, $63|P4, $59|P6, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $5A|P6, $64|P5, $65|P5, $66|P5, $67|P5, $68|P5
  dw $69|P4, $6A|P4, $6B|P4, $6C|P4, $6D|P4, $59|P6, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $5A|P6, $6E|P5, $6F|P5, $70|P5, $71|P5, $72|P5
  dw $73|P4, $74|P4, $75|P4, $76|P4, $77|P4, $59|P6, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $5A|P6, $78|P5, $79|P5, $7A|P5, $7B|P5, $7C|P5
  dw $7D|P4, $7E|P4, $7F|P4, $80|P4, $81|P4, $59|P6, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $00|P2, $5A|P6, $82|P5, $83|P5, $84|P5, $85|P5, $86|P5
  dw $87|P4, $88|P4, $89|P4, $8A|P4, $8B|P4, $59|P6, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $5A|P6, $8C|P5, $8D|P5, $8E|P5, $8F|P5, $90|P5
  dw $91|P4, $92|P4, $93|P4, $94|P4, $95|P4, $59|P6, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $5A|P6, $96|P5, $97|P5, $98|P5, $99|P5, $9A|P5
  dw $9B|P4, $9C|P4, $9D|P4, $9E|P4, $9F|P4, $59|P6, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $5A|P6, $A0|P5, $A1|P5, $A2|P5, $A3|P5, $A4|P5
  dw $A5|P4, $A6|P4, $A7|P4, $A8|P4, $A9|P4, $AA|P6, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $AB|P6, $A9|P5, $AC|P5, $AD|P5, $AE|P5, $AF|P5
  dw $B0|P4, $B1|P4, $B2|P4, $B3|P4, $B4|P4, $3F|P6, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $3F|P6, $B5|P5, $B6|P5, $B7|P5, $B8|P5, $B9|P5
  dw $BA|P4, $BB|P4, $BC|P4, $BD|P4, $BE|P4, $3F|P6, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $3F|P6, $BF|P5, $C0|P5, $C1|P5, $C2|P5, $C3|P5
  dw $C4|P4, $C5|P4, $C6|P4, $C7|P4, $C8|P4, $3F|P6, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $3F|P6, $C9|P5, $CA|P5, $CB|P5, $CC|P5, $C4|P5
  dw $CD|P4, $CE|P6, $08|P6, $09|P6, $CF|P6, $D0|P6, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $00|P1, $D1|P6, $CE|P6, $08|P6, $09|P6, $CF|P6, $D2|P6
  dw $0E|P4, $0F|P6, $10|P6, $11|P6, $12|P6, $13|P6, $2A|P6, $2A|P6, $2A|P6, $D3|P6, $D4|P6, $D4|P6, $D5|P6, $2A|P6, $2A|P6, $2A|P6, $2A|P6, $2A|P6, $2A|P6, $D3|P6, $D4|P6, $D4|P6, $D5|P6, $2A|P6, $2A|P6, $2A|P6, $0E|P6, $0F|P6, $10|P6, $11|P6, $12|P6, $13|P4
  dw $0E|P6, $1E|P6, $1F|P6, $20|P6, $21|P6, $13|P6, $D6|P6, $D6|P6, $D6|P6, $D6|P6, $D6|P6, $D6|P6, $D6|P6, $D6|P6, $D6|P6, $D6|P6, $D6|P6, $D6|P6, $D6|P6, $D6|P6, $D7|P6, $D8|P6, $D8|P6, $D8|P6, $D8|P6, $D9|P6, $0E|P6, $1E|P6, $1F|P6, $20|P6, $21|P6, $13|P6
  dw $0E|P6, $2E|P6, $2F|P6, $28|P6, $29|P6, $13|P6, $DA|P6, $DA|P6, $DA|P6, $DA|P6, $DA|P6, $DA|P6, $DA|P6, $DA|P6, $DA|P6, $DA|P6, $DA|P6, $DA|P6, $DA|P6, $DA|P6, $DB|P6, $DC|P6, $DD|P6, $DE|P6, $DF|P6, $E0|P6, $0E|P6, $2E|P6, $2F|P6, $28|P6, $29|P6, $13|P6
  dw $E1|P6, $E2|P6, $32|P6, $33|P6, $E3|P6, $E4|P6, $E5|P6, $E5|P6, $E5|P6, $E5|P6, $E5|P6, $E5|P6, $E5|P6, $E5|P6, $E5|P6, $E5|P6, $E5|P6, $E5|P6, $E5|P6, $E5|P6, $E5|P6, $E6|P6, $E6|P6, $E6|P6, $E6|P6, $E7|P6, $E1|P6, $E2|P6, $32|P6, $33|P6, $E3|P6, $E4|P6
  dw $E8|P6, $E9|P6, $EA|P6, $EB|P6, $EC|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E8|P6, $E9|P6, $EA|P6, $EB|P6, $EC|P6, $E8|P6

SGB_BorderTilemapTransferSpacer::
REPT $80
  db 0, $10
ENDR

SGB_BorderPalettes::
  dw $0000,$7F7F,$4A7E,$31FD,$7F5F,$6A7F,$597F,$62FE,$0D1D,$0057,$6F7B,$4E73,$197D,$0000,$00FD,$7FFF
  dw $0000,$3FFF,$26FD,$1A7D,$27FF,$2B9F,$0278,$337E,$010D,$01F3,$6F7B,$4E73,$0DFC,$0000,$017C,$7FFF
  dw $0000,$5540,$5DC2,$6645,$6EC8,$774B,$7FEE,$021F,$011D,$0057,$6F7B,$4E73,$017C,$0000,$00FD,$7FFF
