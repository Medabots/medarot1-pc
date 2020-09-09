from collections import OrderedDict
from functools import reduce
from struct import *
import os
import csv
import sys

sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils, tilesets

output_file = sys.argv[1]
input_file = sys.argv[2]
data_file = sys.argv[3]
column_name = sys.argv[4]

char_table = utils.reverse_dict(utils.merge_dicts([
        tilesets.get_tileset("MainSpecial"),
        tilesets.get_tileset("MainDialog"),
        tilesets.get_tileset("dakuten", override_offset=0x0)
    ]))

# Format is [Pointers xN][Strings xN]

bank = 0
base_offset = 0
with open(data_file, 'r') as src:
    for line in src:
        if line.startswith('SECTION'):
            o = line.lstrip('SECTION ').replace(' ', '').replace('\n','').replace('\r\n','').replace('"','').split(',')
            #Name ROMX[$OFFSET] BANK[$BANK]
            bank = int(o[2].replace('BANK','').replace('[','').replace(']','').replace('$','0x'), 16)
            ptr_table_offset = int(o[1].replace('ROMX','').replace('[','').replace(']','').replace('$','0x'), 16)
            break
    else:
        raise f"Could not find Credits section in {data_file}"

with open(input_file, 'r', encoding='utf-8') as fp:
    reader = csv.reader(fp, delimiter=',', quotechar='"')
    header = next(reader, None)
    idx_pointer = header.index("Pointer")
    idx_vramoff = header.index("VRAMOffset")
    idx_text = header.index(column_name)

    # Keep track of the offset from the start
    offsets = [0]
    bintext = bytearray()
    for line in reader:
        if line[0][0] == '#': # Comment
            continue

        vram_offset = int(line[idx_vramoff], 16)
        txt = line[idx_text]
        bintext += bytearray(pack("<H", vram_offset))

        if not txt:
            txt = f"={line[idx_pointer]}" # This will result in KeyErrors in JP though
        
        length = len(txt)
        i = 0
        endcode = 0x00
        while i < length:
            try:
                if txt[i] != '<':
                    bintext.append(char_table[txt[i]])
                else:
                    i += 1
                    special_type = txt[i]
                    i += 1
                    special_data = []
                    while txt[i] != '>':
                        special_data.append(txt[i])
                        i += 1
                    # The only special character to deal with is the endcode
                    if special_type == '*':
                        endcode = int(''.join(special_data), 16)
                        break
                    else:
                        raise f"Unknown special_type {special_type}"
            finally:
                i += 1

        if len(txt):
            bintext.append(0x4F)
            bintext.append(endcode)
        offsets.append(len(bintext))

offsets.pop() # Last entry isn't necessary
init_text_offsets = list(map(lambda x: pack("<H", x + (2 * (len(offsets))) + ptr_table_offset), offsets))

with open(output_file, 'wb') as bin_file:
    init_text_offsets[0] = bytearray(init_text_offsets[0])
    b = reduce( (lambda x, y: x + bytearray(y)), init_text_offsets)
    bin_file.write(b)
    bin_file.write(bintext)
