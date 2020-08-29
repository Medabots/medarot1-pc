#!/bin/python
import csv
import os
import sys
from collections import OrderedDict

sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils

rom_info = [("baserom_parts_collection.gb", "pc", 0x1e14, 0x1e24, 0x10)] # [ROM File, Version Suffix, Text Table Bank Ptr, Address Ptr, Count]
ptrs = open("./scripts/res/ptrs.tbl", "a+")
table = utils.merge_dicts([utils.read_table("./scripts/res/tileset_MainSpecial.tbl"), utils.read_table("./scripts/res/tileset_MainDialog.tbl"), utils.read_table("./scripts/res/dakuten.tbl")])

ptrs.seek(0)
name_table = {}
for line in ptrs:
    n, p = line.strip().split("=")
    name_table[int(p, 16)] = n

for info in rom_info:
    filename = info[0]
    suffix = info[1]
    txt_bank_ptr = info[2]
    txt_tbl_ptr = info[3]
    entry_count = info[4]

    with open(filename, 'rb') as rom:
        rom.seek(txt_bank_ptr)
        banks = [utils.read_byte(rom) for i in range(0,entry_count)]

        rom.seek(txt_tbl_ptr)
        text_ptrs = list(zip(banks, [utils.read_short(rom) for i in range(0, entry_count)]))

        with open("./game/src/story/text_tables.asm", "w") as f:
            for i, entry in enumerate([t for t in text_ptrs if t[0] != 0]):
                f.write(f'SECTION "TextSection{i}", ROMX[${entry[1]:04x}], BANK[${entry[0]:02x}]\n')
                f.write(f'TextSection{i}:\n')
                #f.write(f'  INCBIN "build/TextSection{i}.bin"\n\n')

            f.write('\n\n')

            f.write(f'SECTION "Dialog Text Tables", ROM0[${txt_bank_ptr:04x}]\n')
            f.write(f'TextTableBanks:: ; 0x{txt_bank_ptr:04x}\n')
            
            i = 0
            for entry in text_ptrs:
                if entry[0] == 0:
                    f.write('  db $00')
                else:
                    f.write(f'  db BANK(TextSection{i})')
                    i += 1
                f.write('\n')

            f.write('\nTextTableOffsets::\n')

            i = 0
            for entry in text_ptrs:
                if entry[0] == 0:
                    f.write('  dw $4000')
                else:
                    f.write(f'  dw TextSection{i}')
                    i += 1
                f.write('\n')


        class SpecialCharacter():
            def __init__(self, symbol, default=0, bts=1, end=False, names=None, always_print=False):
                self.symbol = symbol
                self.default = default
                self.bts = bts
                self.end = end
                self.names = names
                self.always_print = always_print

        table[0x4a] = SpecialCharacter("4A", bts=0, always_print=True) # Clears previous text on a line (weird form of new line, used in battle text)
        table[0x4b] = SpecialCharacter("&", bts=2, names=name_table) # Pull text from RAM
        table[0x4c] = SpecialCharacter("4C", bts=0, always_print=True) # Create new text box
        table[0x4d] = SpecialCharacter('S', default=-1) # Text speed
        table[0x4e] = SpecialCharacter("4E", bts=0, always_print=True) # Moves to second line of text box
        table[0x4f] = SpecialCharacter('*', end=True) # End of text

        for i, entry in enumerate([t for t in text_ptrs if t[0] != 0]):
            realaddr = utils.rom2realaddr(entry)
            rom.seek(realaddr)
            end = utils.rom2realaddr((entry[0], utils.read_short(rom)))
            pointers = OrderedDict()
            pointers[realaddr] = end # Treat pointers[0] as the end of the list of addresses
            reverse_map = {}
            realaddr = rom.tell()
            while(realaddr < end):
                val = utils.rom2realaddr((entry[0], utils.read_short(rom)))
                if val in reverse_map:
                    val = f"=0x{reverse_map[val]:x}"
                else:
                    reverse_map[val] = realaddr
                pointers[realaddr] = val
                realaddr = rom.tell()

            for p in pointers:
                if type(pointers[p]) == str:
                    continue

                rom.seek(pointers[p])
                t = ""
                queued_ptrs_write = "" # Queue, but don't write immediately until we know it's ignored or not
                while True:
                    b = utils.read_byte(rom)
                    if b in table:
                        token = table[b]
                        if type(token) == str: # Normal character
                            t += token
                        elif isinstance(token, SpecialCharacter): # Special character
                            param = {0: lambda x: None, 1: utils.read_byte, 2: utils.read_short}[token.bts](rom)
                            if token.always_print or (param != None and param != token.default):
                                t += "<" + token.symbol
                            if param != None:
                                if (param != None and not token.end and param != token.default) or (token.end and param != token.default):
                                    if param != token.default:
                                        if token.names and param in token.names:
                                            t += token.names[param]
                                        else:
                                            if token.names is not None:
                                                n = f"BUF{len(token.names):02X}"
                                                token.names[param] = n
                                                queued_ptrs_write += f"{n}={hex(param)}\n"
                                                t += n
                                                # Write the names to the table later, just in case something is ignored
                                            else:
                                                t += hex(param)[2:]
                            if token.always_print or (param != None and param != token.default):
                                t += ">"
                            if token.end:
                                if not t:
                                    t = f"<{token.symbol}{param:02X}>"
                                break
                    else: # Not found, print literal
                        t += f"<${b:02X}>"
                if "  " in t: # This is a hack, but if we find multiple spaces, the data should be ignored
                    t = "<IGNORED>"
                elif queued_ptrs_write:
                    ptrs.write(queued_ptrs_write)
                pointers[p] = t

            with open(f"./text/dialog/TextSection{i}.csv", "w", encoding="utf-8") as fp:
                writer = csv.writer(fp, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
                writer.writerow(["Pointer[#version]","Original"])
                for p in pointers:
                    writer.writerow([hex(p), pointers[p]])