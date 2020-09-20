INCLUDE "game/src/common/constants.asm"

SECTION "LCDC VBlank_IRQ", ROM0[$049E]
VBlankingIRQ::
  push af
  push bc
  push de
  push hl
  ldh a, [$FF92]
  or a
  jr z, .jpA
  ld a, [CoreStateIndex]
  ld [$C6D8], a
  ld a, [CoreSubStateIndex]
  ld [$C6D9], a

.jpA
  call $0451
  ldh a, [$FF92]
  or a
  jr nz, .setCompletedFlag
  ld a, [$C600]
  or a
  call nz,  $FF80 ; In-memory code: OAM DMA
  ei
  xor a
  ld [$C600], a

.setCompletedFlag
  ld a, 1
  ldh [$FF92], a
  call SoundFixHack
  pop hl
  pop de
  pop bc
  pop af
  reti

; LCDC Status Interrupt (INT 48)
LCDC_Status_IRQ: ; 4D3 (0:4D3)
  push af
  push bc
  push de
  push hl
  ld a, [$c7f9]
  or a
  jp nz, .asm_51f
  ld a, [$c6bf]
  or a
  jp nz, .draw_scroll
  call ResetIRQVars
  jr .draw_scroll_return
.draw_scroll: ; 4e8 (0:4e8)
  ld h, $c6
  ld a, [HackHBlankOffset]
  ld l, a
  ld a, [hl]
  or a
  jr nz, .draw_scroll_section
  ; Reset draw state back to normal
  ld a, [HackHBlankOriginal]
  or a
  jr nz, .hack_notzero ; A hack, which primarily affects robattles
  ld a, $8F ; When the original start point is 0, we can set the interrupt to occur at $8F, leaving 1 more than the vblank period to draw
  ld [HackHBlankOriginal], a
.hack_notzero
  ld [hRegLYC], a
  ld a, $b0
  ld [HackHBlankOffset], a
  ld de, -$03
  add hl, de
  ld a, [hl]
  ld b, a
  inc b
  call HBlankWaitForLine ; We might be here early, so wait
  xor a
  ld [hRegSCX], a
  ld [hRegSCY], a
  jr .draw_scroll_return
.draw_scroll_section
  ld a, l
  cp $b0
  jr nz, .draw_scroll_section_not_original
  ld a, [$c5aa] ; if c5aa is set, use that instead as the original point
  or a
  jr nz, .use_c5aa
  ld a, [hRegLYC] ; If c5aa isn't set, take the value of ff45
.use_c5aa
  ld [HackHBlankOriginal], a
.draw_scroll_section_not_original
  ; Starting at c6b0, there are sets of 3 bytes indicating which line to apply the scroll until, SCX, SCY
  ld a, [hli] ; [0] = Line to stop at
  ld [hRegLYC], a
  ld a, [hli] 
  ld [hRegSCX], a ; [1] = SCX
  ld a, [hli]
  ld [hRegSCY], a ; [2] = SCY
  ld a, l
  ld [HackHBlankOffset], a
  jr .draw_scroll_return
.asm_51f: ; 51f (0:51f)
  xor a
  ld [$c7fc], a
  ld de, $90
  ld hl, $c800
.asm_529
  ld a, [hli]
  ld [hRegSCX], a
  xor a
  ld [hRegSCY], a
  ld a, [$c7fc]
  ld b, a
.asm_534
  call WaitLCDController
  ld a, [hRegLY]
  sub b
  jr c, .asm_534
  ld a, [$c7fc]
  inc a
  ld [$c7fc], a
  dec de
  ld a, d
  or e
  jp nz, .asm_529
.draw_scroll_return
  pop hl
  pop de
  pop bc
  pop af
  reti
.end
REPT $565 - .end
  nop
ENDR
; 0x565

SECTION "IRQ Hacks", ROM0[$1F43]
ResetIRQVars::
  ld hl, $c6b0
  ld a, l
  ld [HackHBlankOffset], a
  xor a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ld [hli], a
  ret
HBlankWaitForLine::
.waitforline
  ld a, [hRegLY]
  cp b
  jr c, .waitforline
  ret
SoundFixHack::
  call $3B90 ; Original replaced call. Nothing to do with sound.
  ld a, 6
  ld [$2000], a ; Don't use rst10 in the IRQ since we'll restore the old bank
  call $4000
  ldh a, [hBank]
  ld [$2000], a
  ret