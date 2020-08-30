; TODO: Will need to move this into a separate versions directory if we do pc2 (search VERSIONSPECIFIC)

SECTION "Part Names", ROMX[$7627], BANK[$1]
PartTypesPtr::
INCLUDE "build/ptrlists/PartTypes_{GAMEVERSION}.asm"

SECTION "Attributes", ROMX[$7ef3], BANK[$2]
AttributesPtr::
INCLUDE "build/ptrlists/Attributes_{GAMEVERSION}.asm"

SECTION "Part Descriptions", ROMX[$74d8], BANK[$1f]
PartDescriptionsPtr::
INCLUDE "build/ptrlists/PartDescriptions_{GAMEVERSION}.asm"

SECTION "Skill", ROMX[$7fb0], BANK[$2]
SkillsPtr::
INCLUDE "build/ptrlists/Skills_{GAMEVERSION}.asm"

SECTION "Attacks", ROMX[$742c], BANK[$17]
AttacksPtr::
INCLUDE "build/ptrlists/Attacks_{GAMEVERSION}.asm"

SECTION "Medarotters", ROMX[$63e2], BANK[$17]
MedarottersPtr::
INCLUDE "build/ptrlists/Medarotters_{GAMEVERSION}.asm"

; They actually maintain a separate copy of all the skills in 1B
;SECTION "Skills_1B", ROMX[$7019], BANK[$1b]
;SkillsPtr_1B::
;INCLUDE "build/ptrlists/Skills_{GAMEVERSION}.asm"