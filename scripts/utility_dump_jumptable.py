# Python 2

import re
import subprocess

jump_table_addr_start = 0x150
jump_table_addr_end = 0x393


with open('game/src/core/jump_table.asm','w') as jump_table:
    jump_table.write('SECTION "Jump Table", ROM0[${:04X}]\n'.format(jump_table_addr_start))

    for i in range(jump_table_addr_start, jump_table_addr_end, 0x3):
        o = subprocess.check_output("python -m pokemontools.gbz80disasm --no-write -r medarot_parts_collection.gb {:X}".format(i).split(" "))
        label, _, jmp, _, _, _ = re.split(';|\n',o)
        label = label.strip("\n\t: ")
        jmp_label = label.replace("Func_", "JumpTable_")
        jmp = jmp.strip("\n\t: ").split(" ")[1]

        if jmp.startswith("Func_"): # Needs to be disassembled
            ptr = int(jmp.split("_")[1], 16)
            jmp = jmp.replace("Func_", "Wrapper_")
        jump_table.write("{}:: jp {}\n".format(jmp_label, jmp))



wrapper_table_addr_start = 0x59e
wrapper_table_addr_end = 0xc1c

def modify_disasm(x):
    if "Func_" in x:
        a = x.split("Func_")
        return "{}${:04X}".format(a[0], int(a[-1], 16)) # It will always be something like 'jp Func_####'
    return x

with open('game/src/core/wrappers.asm','w') as wrappers:
    wrappers.write('SECTION "Wrappers", ROM0[${:04X}]\n'.format(wrapper_table_addr_start))
    ptr = wrapper_table_addr_start
    while ptr < wrapper_table_addr_end:
        o = subprocess.check_output("python -m pokemontools.gbz80disasm --no-write -r medarot_parts_collection.gb {:X}".format(ptr).split(" ")).replace("\t", "  ")
        ptr = int(o.split(";")[-1].strip(), 16)

        disasm = o.split("\n")
        label = disasm[0].split(';')[0].strip().replace("Func_", "Wrapper_")
        wrappers.write("{}:\n".format(label)) #Tacks on an extra ':' to make the symbol global
        disasm = list(map(modify_disasm, disasm[1:]))
        
        wrappers.write("\n".join(disasm))
        wrappers.write("\n")