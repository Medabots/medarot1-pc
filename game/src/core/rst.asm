SECTION "rst0", ROM0[$0]
  pop hl
  add a ;a = a+a
  rst $28
  ld a, [hli] ; a = *hl++
  ld h, [hl] ; h = *hl
  ld l, a ;l = a
  jp hl

SECTION "rst8",ROM0[$8] ;Return, enable interrupt
  reti

SECTION "rst10, bank swap",ROM0[$10]
  ld [$2000], a
  ret

SECTION "rst18",ROM0[$18] ;Bank swap from memory
  ld a, [$c6e0]
  ld [$2000], a
  ret

SECTION "rst20",ROM0[$20]
  add l ;a = l+a
  ld l, a ;l = a
  ret c ;Return if 'c'
  dec h ;h--
  ret

SECTION "rst28",ROM0[$28] ; hl += a
  add l
  ld l, a
  ret nc 
  inc h
  ret

SECTION "rst30",ROM0[$30] ; hl = [hl + a*2], useful for loading data from pointer tables
  add a
  rst $28
  ld a, [hli]
  ld h, [hl]
  ld l, a
  ret

SECTION "rst38",ROM0[$38] ; hl = [hl]
  ld a, [hli]
  ld l, [hl]
  ld h, a
  ret
