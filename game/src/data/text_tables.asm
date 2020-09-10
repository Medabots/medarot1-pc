INCLUDE "build/dialog/text_table_constants_{GAMEVERSION}.asm"

SECTION "Pointers", ROMX[$4000], BANK[$18]
TextSection0:
  INCBIN cTextSection0
TextSection1:
  INCBIN cTextSection1
TextSection2:
  INCBIN cTextSection2
TextSection3:
  INCBIN cTextSection3
TextSection4:
  INCBIN cTextSection4
TextSection5:
  INCBIN cTextSection5
TextSection6:
  INCBIN cTextSection6
TextSection7:
  INCBIN cTextSection7
TextSection8:
  INCBIN cTextSection8

SECTION "Text0", ROMX[$4000], BANK[$1a]
Text0:
  INCBIN cText0

SECTION "Text1", ROMX[$4000], BANK[$1d]
Text1:
  INCBIN cText1

;; These sections are all partially used, so we don't risk using them
; SECTION "TextSection1", ROMX[$7e00], BANK[$0d]
; SECTION "TextSection2", ROMX[$7e00], BANK[$0e]
; SECTION "TextSection3", ROMX[$7e00], BANK[$0f]
; SECTION "TextSection4", ROMX[$6000], BANK[$16]
; SECTION "TextSection5", ROMX[$7800], BANK[$13]

SECTION "Dialog Text Tables", ROM0[$1e14]
TextTableBanks:: ; 0x1e14
  db BANK(TextSection0)
  db BANK(TextSection1)
  db BANK(TextSection2)
  db BANK(TextSection3)
  db BANK(TextSection4)
  db BANK(TextSection5)
  db $00
  db $00
  db BANK(TextSection6)
  db $00
  db BANK(TextSection7)
  db $00
  db $00
  db BANK(TextSection8)
  db $00
  db $00

TextTableOffsets::
  dw TextSection0
  dw TextSection1
  dw TextSection2
  dw TextSection3
  dw TextSection4
  dw TextSection5
  dw $4000
  dw $4000
  dw TextSection6
  dw $4000
  dw TextSection7
  dw $4000
  dw $4000
  dw TextSection8
  dw $4000
  dw $4000
