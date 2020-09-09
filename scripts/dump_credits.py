#!/bin/python
import csv
import os
import sys
from collections import OrderedDict

sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils, tilesets

rom_info = ("baserom_parts_collection.gb", "parts_collection", (0x16, 0x539b), 63) # [ROM File, Version Suffix, Credits Ptr, Entry Count]
table = utils.merge_dicts([
            tilesets.get_tileset("MainSpecial"),
            tilesets.get_tileset("MainDialog"),
            tilesets.get_tileset("dakuten", override_offset=0x0)
        ])

filename = rom_info[0]
suffix = rom_info[1]
text_ptr_table = rom_info[2] if isinstance(rom_info[2], int) else utils.rom2realaddr(rom_info[2])
bank = utils.real2romaddr(text_ptr_table)[0]
entry_count = rom_info[3]

with open(filename, 'rb') as rom, open(f"./text/credits/Credits.csv", "w", encoding="utf-8") as fp:
    writer = csv.writer(fp, lineterminator='\n', delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    writer.writerow(["Pointer","VRAMOffset","Original", "Translated"])
    
    rom.seek(text_ptr_table)
    pointers = [(rom.tell(), utils.read_short(rom)) for i in range(0, entry_count)]

    class SpecialCharacter():
        def __init__(self, symbol, default=0, bts=1, end=False, always_print=False):
            self.symbol = symbol
            self.default = default
            self.bts = bts
            self.end = end
            self.always_print = always_print

    # 0x4F is the only special character in the credits
    # It indicates end of text, and how many frames to wait until we start drawing the next line
    table[0x4f] = SpecialCharacter('*', end=True, always_print=False) 

    for ptr in pointers:
        pointer_tbl = ptr[0] # Pointer to table entry
        pointer_txt = utils.rom2realaddr((bank,ptr[1])) # Pointer to actual text
        rom.seek(pointer_txt)

        vram_off = utils.read_short(rom)
        t = ""
        while True:
            b = utils.read_byte(rom)
            if b in table:
                token = table[b]
                if type(token) == str: # Normal character
                    t += token
                elif isinstance(token, SpecialCharacter): # Special character
                    param = {0: lambda x: None, 1: utils.read_byte, 2: utils.read_short}[token.bts](rom)
                    if  (
                        (token.always_print) or
                        (token.end and param != token.default) or
                        (not token.end)
                        ):
                            t += "<" + token.symbol
                            if token.always_print or (param != None and param != token.default):
                                t += f"{param:02X}"
                            t += ">"
                    if token.end:
                        if not t:
                            t = f"<{token.symbol}{param:02X}>"
                        break
            else: # Not found, print literal
                t += f"<${b:02X}>"

        writer.writerow([f'0x{pointer_tbl:X}', f'0x{vram_off:X}', t, None])
