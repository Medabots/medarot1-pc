SECTION "TextSection0", ROMX[$7e00], BANK[$0c]
TextSection0:
  INCBIN "build/dialog/TextSection0_{GAMEVERSION}.bin"

SECTION "TextSection1", ROMX[$7e00], BANK[$0d]
TextSection1:
  INCBIN "build/dialog/TextSection1_{GAMEVERSION}.bin"

SECTION "TextSection2", ROMX[$7e00], BANK[$0e]
TextSection2:
  INCBIN "build/dialog/TextSection2_{GAMEVERSION}.bin"

SECTION "TextSection3", ROMX[$7e00], BANK[$0f]
TextSection3:
  INCBIN "build/dialog/TextSection3_{GAMEVERSION}.bin"

SECTION "TextSection4", ROMX[$6000], BANK[$16]
TextSection4:
  INCBIN "build/dialog/TextSection4_{GAMEVERSION}.bin"

SECTION "TextSection5", ROMX[$7800], BANK[$13]
TextSection5:
  INCBIN "build/dialog/TextSection5_{GAMEVERSION}.bin"

SECTION "TextSection6", ROMX[$4000], BANK[$18]
TextSection6:
  INCBIN "build/dialog/TextSection6_{GAMEVERSION}.bin"

SECTION "TextSection7", ROMX[$4000], BANK[$1a]
TextSection7:
  INCBIN "build/dialog/TextSection7_{GAMEVERSION}.bin"

SECTION "TextSection8", ROMX[$4000], BANK[$1d]
TextSection8:
  INCBIN "build/dialog/TextSection8_{GAMEVERSION}.bin"



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
