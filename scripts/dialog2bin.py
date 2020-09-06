from collections import OrderedDict
from functools import reduce
from struct import *
import os
import csv
import re
import sys

sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils, tilesets

output_file = sys.argv[1]
input_file = sys.argv[2]
data_file = sys.argv[3]
version_suffix = sys.argv[4] # TODO: Use this

# Setup

base_name = os.path.splitext(os.path.basename(input_file))[0]
char_table = utils.reverse_dict(utils.merge_dicts([
        tilesets.get_tileset("MainSpecial"),
        tilesets.get_tileset("MainDialog"),
        tilesets.get_tileset("dakuten", override_offset=0x0)
    ]))
ptr_names = utils.read_table(os.path.join(os.path.dirname(__file__), 'res', 'ptrs.tbl'), keystring=True)

# Process Text

bank = 0
base_offset = 0
with open(data_file, 'r') as src:
    for line in src:
        if line.startswith('SECTION') and f'"{base_name}"' in line:
            o = line.lstrip('SECTION ').replace(' ', '').replace('\n','').replace('\r\n','').replace('"','').split(',')
            #Name ROMX[$OFFSET] BANK[$BANK]
            bank = int(o[2].replace('BANK','').replace('[','').replace(']','').replace('$','0x'), 16)
            ptr_table_offset = int(o[1].replace('ROMX','').replace('[','').replace(']','').replace('$','0x'), 16)
            break
    else:
        raise Exception(f"Could not find {base_name} section in {data_file}")

with open(input_file, 'r', encoding='utf-8') as fp:
    reader = csv.reader(fp, delimiter=',', quotechar='"')
    header = next(reader, None)
    idx_pointer = header.index("Pointer[#version]")
    idx_text = header.index("Original")

    # Keep track of the offset from the start
    bintext = bytearray()
    pointer_offset_map = {}
    for line in reader:
        txt = line[idx_text]
    
        if txt[0] == '#': # Comment
            continue

        if txt.startswith('='): # Pointer to existing text
            pointer = int(txt.lstrip('='), 16)
            pointer_offset_map[int(line[idx_pointer], 16)] = pointer_offset_map[pointer]
            continue

        if line[idx_text].startswith('<OFFSET'): # A special case that starts in the middle of (probably) a section marked 'UNUSED_'
            _, src_ptr, offset = line[idx_text].strip('<').split(">", 1)[0].split(":")
            pointer = int(line[idx_pointer], 16)
            try:
                pointer_offset_map[pointer] = pointer_offset_map[int(src_ptr, 16)] + int(offset, 16)
            except ValueError:
                pointer_offset_map[pointer] = pointer_offset_map[src_ptr] + int(offset, 16)
            continue


        l = len(bintext)

        try:
            pointer_offset_map[int(line[idx_pointer], 16)] = l
        except ValueError:
            pointer_offset_map[line[idx_pointer]] = l

        if not txt.startswith('<IGNORED>'):
            length = len(txt)
            i = 0
            endcode = 0x00
            while i < length:
                try:
                    if txt[i] != '<':
                        try:
                            bintext.append(char_table[txt[i]])
                        except KeyError as e:
                            print(f"[{line[idx_pointer]}]: KeyError {e}")
                            print(f"\t{line[idx_text]}")
                            raise e
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
                        elif special_type == 'S': # Text Speed Change
                            bintext.append(0x4D)
                            bintext.append(int(''.join(special_data), 16))
                        elif special_type == '&': # Pull text from pointer
                            bintext.append(0x4B)
                            s = ''.join(special_data)
                            if s in ptr_names:
                                s = ptr_names[s].lstrip('0x')
                            bintext.append(int(s[2:4], 16))
                            bintext.append(int(s[0:2], 16))
                        elif special_type == '$': # Raw byte
                            bintext.append(int(''.join(special_data), 16))
                        elif special_type == '4': # The remaining types are just single byte control codes (i.e. 4C for new text box)
                            bintext.append(int( special_type + ''.join(special_data), 16))                       
                        else:
                            raise Exception(f"Unknown special_type {special_type} in {txt}")
                finally:
                    i += 1

            if len(txt):
                bintext.append(0x4F)
                if endcode in range(0, 4+1): # This is a hack to deal with reproducing how Natsume builds text
                    bintext.append(endcode)

# The lines are in order of how the text is actually laid out, not in order of how the pointers reference them, so we need to reorder the offsets by key

# Remove entries whose keys are strings (UNUSED or other special cases we don't want)
for key in list(pointer_offset_map.keys()):
    if isinstance(key, str):
        del pointer_offset_map[key]

offsets = [pointer_offset_map[key] for key in sorted(pointer_offset_map.keys())]
init_text_offsets = list(map(lambda x: pack("<H", x + (2 * (len(offsets))) + ptr_table_offset), offsets))

# Generate binary

with open(output_file, 'wb') as bin_file:
    init_text_offsets[0] = bytearray(init_text_offsets[0])
    b = reduce( (lambda x, y: x + bytearray(y)), init_text_offsets)
    bin_file.write(b)
    bin_file.write(bintext)
