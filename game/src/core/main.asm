INCLUDE "game/src/common/constants.asm"

SECTION "Main", ROM0[$0393]
Main::
; Disable LCD
  call $0c93
  di

; Disable all interrupts
  xor a
  ldh [hRegIF], a
  ldh [hRegIE], a
  ld sp, $fffe

; Enable SRAM
  ld a, $a
  ld [$0000], a

; Swap to bank 1
  ld a, $1
  rst $10

; Switch to SRAM Bank 0
  ld a, $0
  ld [$4000], a

  call $0cbb
  call $0d80
  call $0d8b

; Clear OAM
  ld hl, $fe00
  ld c, $0

.clearOAMLoop
  ld [hli], a
  dec c
  jr nz, .clearOAMLoop ; 0x3be $fc

; Clear HRAM
  ld hl, $ff80
  ld c, $7f

.clearHRAMLoop
  ld [hli], a
  dec c
  jr nz, .clearHRAMLoop ; 0x3c7 $fc


  call $0c4e
  call $056e
  ld a, $1
  ld [$c600], a
  call $17ea
  ld a, $83
  ld [$c5a9], a
  ld [hRegLCDC], a
  xor a
  ld [hRegIF], a
  ld a, $d
  ld [hRegIE], a
  ei
  call $3c4c
  ld a, $40
  ld [hLCDStat], a
  xor a
  ld [hRegIF], a
  ld a, $b
  ld [hRegIE], a
  ld a, BANK(SGB_DetectICDPresence)
  ld [$c6e0], a
  rst $10
  ld a, $0
  ld [$c5fa], a
  call SGB_DetectICDPresence
  jp nc, .jpA
  ld a, $1
  ld [$c5fa], a
  call SGB_InstallBorderAndHotpatches

.jpA
  ld a, $1
  ld [$c5c0], a
  ld a, $1
  rst $18

.gameLoop
  ld a, [$c5a0]
  inc a
  ld [$c5a0], a
  call $0485
  ld a, [$c5a1]
  or a
  jr nz, .jpB ; 0x423 $1a
  call SerIO_RecvBufferPull
  call SerIO_SendBufferPush
  call SerIO_SendConnectPacket
  call $0c1c
  call $38e7
  call $0cd8
  call $19b3
  ld a, $1
  ld [$c5a1], a
.jpB
  call $0590 ; Audio handling.
.waitForNextFrame
  ldh a, [$ff92]
  and a
  jr z, .waitForNextFrame ; 0x445 $fb
  xor a
  ldh [$ff92], a
  xor a
  ld [$c5a1], a
  jp .gameLoop
  nop
  nop
; 0x451

