#!/bin/python

# Script to initially dump tilesets

import os, sys
from functools import partial
from pathlib import Path

sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils, tilesets, png, gfx

nametable = {}
namefile = None

Path("scripts/res/").mkdir(parents=True, exist_ok=True)
Path("game/src/gfx/").mkdir(parents=True, exist_ok=True)

if os.path.exists("scripts/res/tileset_names.tbl"):
	nametable = utils.read_table("scripts/res/tileset_names.tbl")
else:
	namefile = open("scripts/res/tileset_names.tbl","w")

tiletable = 0x1103
terminator = 0x122a # The last address in the TilesetInfo table, used instead of '0' to indicate that there's no actual entry there...
count = int((terminator - tiletable)/5) + 1

with open("baserom_parts_collection.gb", "rb") as rom, open("game/src/gfx/tileset_table.asm", "w") as output:
	rom.seek(tiletable)
	ptrs = [utils.read_short(rom) for i in range(0, count)]
	data = {}
	for ptr in ptrs:
		rom.seek(ptr) # Bank 0, no need to convert addresses
		# (Bank, Pointer, VRAM Offset, Name)
		if ptr != terminator:
			if namefile: # We assume the table file not existing is fine
				nametable[ptr] = "{:04X}".format(ptr)
				namefile.write("{:04X}={}\n".format(ptr, nametable[ptr]))
			data[ptr] = (utils.read_byte(rom), utils.read_short(rom), utils.read_short(rom), nametable[ptr])
	output.write('INCLUDE "game/src/common/macros.asm"\n\n')

	output.write('SECTION "Tileset Table", ROM0[${:04X}]\n'.format(tiletable))
	output.write('TilesetTable::\n')
	for x,i in enumerate(ptrs):
		if i == terminator:
			output.write("  dw TilesetInfoEnd ; {:X}\n".format(x))
		else:
			output.write("  dw TilesetInfo{} ; {:X}\n".format(data[i][3], x))
	output.write("TilesetTableEnd::\n");
	with open("game/src/gfx/tileset_files.asm", "w") as outputf:
		for ptr in sorted(data):
			output.write('SECTION "TilesetInfo {0}", ROM0[${1:04X}]\n'.format(data[ptr][3], ptr))
			output.write("TilesetInfo{}::\n".format(data[ptr][3]))
			with open("game/tilesets/{}.malias".format(data[ptr][3]),"wb") as compressed, \
					open("text/tilesets/{}.png".format(data[ptr][3]),"wb") as uncompressed:
				f = tilesets.decompress_tileset(rom, utils.rom2realaddr((data[ptr][0],data[ptr][1])))
				width, height, palette, greyscale, bitdepth, px_map = gfx.convert_2bpp_to_png(f[0])
				w = png.Writer(
					width,
					height,
					palette=palette,
					compression=9,
					greyscale=greyscale,
					bitdepth=bitdepth
				)
				w.write(uncompressed, px_map)
				compressed.write(bytearray(f[1]))

				output.write('  dbww BANK(Tileset{0}), Tileset{0}, ${1:04X}\n'.format(data[ptr][3], data[ptr][2]))
				outputf.write('SECTION "Tileset Data {0}", ROMX[${1:04X}], BANK[${2:02X}]\n'.format(data[ptr][3], data[ptr][1], data[ptr][0]))
				outputf.write("Tileset{}::\n".format(data[ptr][3]))
				outputf.write("TilesetStart{}::\n".format(data[ptr][3]))
				outputf.write('  INCBIN "build/tilesets/{}.malias"\n'.format(data[ptr][3]))
				outputf.write("TilesetEnd{}::\n\n".format(data[ptr][3]))

		output.write("TilesetInfoEnd::\n");
