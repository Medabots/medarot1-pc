SECTION "CopyVRAMData", ROM0[$CCA]
;CopyVRAMData (copy with LCD interrupt)
; hl - address to copy from
; de - address to copy to
; bc - length
CopyVRAMData:: ;  cca
  ld a, [hli]
  di
  call WaitLCDController
  ld [de], a
  ei
  inc de
  dec bc
  ld a, b
  or c
  jr nz, CopyVRAMData
  ret
