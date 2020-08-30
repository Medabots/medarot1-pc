#!/bin/python

# Script to dump text lists with pointers
# We make an assumption that objects will be adjacent to each other

import os, sys
from functools import partial
sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils

list_map = ({
	# 'Type' : (Start of Pointers, Terminator, Number of Items, Prefix Length)
	'PartTypes' : ((0x1, 0x7627), 0x50, 4, 0),
	'Attributes' : ((0x2, 0x7ef3), 0x50, 28, 0),
	'PartDescriptions' : ((0x1f, 0x74d8), 0x50, 50, 0),
	'Skills' : ((0x2, 0x7fb0), 0x50, 8, 0),
	'Attacks' : ((0x17, 0x742c), 0x50, 19, 0),
	# Medarotters have a 3-byte prefix before the names
	'Medarotters' : ((0x17, 0x63e2), 0x50, 80, 3),
})

tileset = utils.merge_dicts([utils.read_table("scripts/res/tileset_MainSpecial.tbl"), utils.read_table("scripts/res/tileset_MainDialog.tbl"), utils.read_table("scripts/res/tileset_dakuten.tbl")])
with open("baserom_parts_collection.gb", "rb") as rom:
	for l in list_map:
		addr, term, n, prefixlen = list_map[l]
		if isinstance(addr, tuple):
			bank = addr[0]
			addr = utils.rom2realaddr(addr)
		else:
			bank = utils.real2romaddr(addr)[0]
		rom.seek(addr)
		with open('text/ptrlists/{}.txt'.format(l), 'w', encoding = "utf-8") as output:
			output.write(f"({term},{prefixlen})\n")
			ptrs = [utils.read_short(rom) for i in range(0, n)]
			for ptr in ptrs:
				rom.seek(utils.rom2realaddr((bank, ptr)))
				prefix = [utils.read_byte(rom) for i in range(0, prefixlen)]
				# If the first 2 are 00, there's no data
				if prefixlen > 0 and prefix[0] == 0x0:
					b = []
				else: 
					b = list(iter(partial(utils.read_byte, rom), term))
					# In the case of an empty string, print out at least the terminator
					# Doing this allows the ptrlist2asm script to properly identify when to actually skip the terminator
					# (Medarotters with a null prefix shouldn't have a terminator, but empty part descriptions should)
					if len(b) == 0:
						b = [term]
				p = "".join(utils.bin2txt(bytearray(prefix), {}))
				t = "".join(utils.bin2txt(bytearray(b), tileset))
				output.write(f"{p}{t}\n")