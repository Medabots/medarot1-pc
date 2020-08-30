INCLUDE "game/src/common/constants.asm"

SECTION "vblank",ROM0[$40] ; vblank interrupt
  jp $049E

SECTION "lcd",ROM0[$48] ; lcd interrupt
  jp $04D3

SECTION "timer",ROM0[$50] ; timer interrupt
  nop

SECTION "serial",ROM0[$58] ; serial interrupt
  jp $3BA9

SECTION "joypad",ROM0[$60] ; joypad interrupt
  reti

SECTION "WaitLCDController", ROM0[$17E1]
WaitLCDController:: ; 17E1 (0:17E1)
  push af
.wfb
  ld a, [hLCDStat]
  and 2
  jr nz, .wfb
  pop af
  ret
