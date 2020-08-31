#!/bin/python

# Script to dump pointer-less lists (ptr lists are a bit different)
# Shouldn't need to be run more than once, just here for reference

import os, sys
from functools import partial
sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils, tilesets

list_map = ({
	# 'Type' : (Ptr, Total Length, Terminator, PadByte, Number of Items)
	'Items' : ((0x17, 0x5af0), 0x10, 0x50, 0x0, 38),
	'Medals' : ((0x17, 0x5d50), 0x8, 0x50, 0x0, 28),
	'Medarots' : ((0x17, 0x6990), 0x10, 0x50, 0x0, 60),
	# Parts are [PartName:8+1][PartCode:6+1]
	'HeadParts' : ((0x1c, 0x6d50), (0x9, 0x7), 0x50, 0x50, 60),
	'RightParts' : ((0x1c, 0x7110), (0x9, 0x7), 0x50, 0x50, 60),
	'LeftParts' : ((0x1c, 0x74d0), (0x9, 0x7), 0x50, 0x50, 60),
	'LegParts' : ((0x1c, 0x7890), (0x9, 0x7), 0x50, 0x50, 60),
})

VERSIONS = [("baserom_parts_collection.gb", "parts_collection")]

tileset = utils.merge_dicts([
            tilesets.get_tileset("MainSpecial"),
            tilesets.get_tileset("MainDialog"),
            tilesets.get_tileset("dakuten", override_offset=0x0)
        ])

for lst in list_map:
	merged_dict = {}
	addr, length, term, pad, n = list_map[lst]
	for version in VERSIONS:
		with open(version[0], "rb") as rom:
				if isinstance(addr, tuple):
					addr = utils.rom2realaddr(addr)
				rom.seek(addr)
				for i in range(0, n):
					c = 0
					for l in length if isinstance(length, tuple) else (length,):
						b = list(iter(partial(utils.read_byte, rom), term))
						rom.seek(l-len(b)-1,1) # Account for the terminator
						value = "{}\n".format("".join(utils.bin2txt(bytearray(b), tileset)))
						key = "{:03}_{:02}".format(i, c)
						c += 1
						if key in merged_dict and merged_dict[key] != value: # Just assume 2 versions, so the existence of a previous entry must belong to the 'default' version
							merged_dict[key + VERSIONS[0][1]] = "[{}]{}".format(VERSIONS[0][1], merged_dict[key])
							del merged_dict[key]
							key = key + version[1]
							value = "[{}]{}".format(version[1], value)
						merged_dict[key] = value

	with open('text/lists/{}.txt'.format(lst), 'w', encoding = "utf-8") as output:
		output.write("{}|{}|{}\n".format(length, term, pad))
		for i in sorted(merged_dict.keys(), key=lambda x:x.lower()):
			output.write(merged_dict[i])