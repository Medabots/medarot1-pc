#!/bin/python

# Script to initially dump tilemaps, shouldn't really need to be run anymore, and is mainly here as a reference

import os, sys
from functools import partial

sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils, tilemaps, tilesets

# tilemap bank is 1e (0x78000)
BANK_SIZE = 0x4000
BANK = 0x1e
BASE = 0x4000
BASE_ADDR = utils.rom2realaddr((BANK, BASE))
MAX_ADDR = BASE_ADDR + BANK_SIZE - 1

tilemap_ptr = {}
tilemap_bytes = {}
tilemap_files = []
TERMINATOR = 0

with open("baserom_parts_collection.gb", "rb") as rom:
    rom.seek(BASE_ADDR)
    ptr = utils.read_short(rom)
    tilemap_ptr[0] = ptr
    end = utils.rom2realaddr((BANK, ptr))
    i = 1
    while rom.tell() < end: # The first tilemap is where the table should end
        tilemap_ptr[i] = utils.read_short(rom)
        i += 1
    TERMINATOR = tilemap_ptr[i-1] # A bit of a hack, but the last pointer is effectively a 'null', even though there's a list entry pointing to it

    ptrfile = None
    ptrtable = {}

    tileset_file = None
    tileset_table = {}
    tiletables = {}

    if os.path.exists("scripts/res/meta_tilemap_files.tbl"):
        ptrtable = utils.read_table("scripts/res/meta_tilemap_files.tbl")
    else:
        ptrfile = open("scripts/res/meta_tilemap_files.tbl","w")

    # Load previously generated/manually written tilemap <-> tileset mapping
    tileset_default = utils.merge_dicts([
            tilesets.get_tileset("MainDialog"),
            tilesets.get_tileset("MainSpecial"),
        ])
    tileset_default[0xFE] = '\n' # 0xFE is a special control code for a new line, not really a tile

    if os.path.exists("scripts/res/meta_tilemap_tilesets.tbl"):
        tileset_table = utils.read_table("scripts/res/meta_tilemap_tilesets.tbl", keystring=True)
        for fname in tileset_table:
            if tileset_table[fname] not in tiletables:
                tiletables[tileset_table[fname]] = utils.merge_dicts([utils.merge_dicts([tilesets.get_tileset(tbl) for tbl in filter(None, tileset_table[fname].split(","))])])
                tiletables[tileset_table[fname]][0xFE] = '\n' 
    else:
        tileset_file = open("scripts/res/meta_tilemap_tilesets.tbl", "w")

    try:
        for i in sorted(tilemap_ptr):
            ptr = tilemap_ptr[i]
            if ptr == TERMINATOR:
                print(f"{i:02x} is a null tilemap")
                if ptrfile:
                    ptrfile.write(f"{i:02X}=\n")
                continue
            addr = BASE_ADDR + ptr - BANK_SIZE
            rom.seek(addr)
            compressed = utils.read_byte(rom)
            assert compressed in [0x0, 0x1], f"Unexpected compression byte 0x{compressed:02x}"
            print(f"{i:02x} @ [{ptr:04X} / {rom.tell()-1:08X}] {'Compressed' if compressed else 'Uncompressed'} | ", end="")
            tilemap_bytes[i] = list(iter(partial(utils.read_byte, rom), 0xFF)) # Read ROM until 0xFF
            # tilemaps are all adjacent to each other, so we don't need to do anything more than make sure they're sorted
            fname = f"Tilemap_{ptr:04X}" if i not in ptrtable else ptrtable[i]
            txt_path = f"text/tilemaps/{fname}.txt"

            if not fname in tilemap_files:
                tilemap_files.append(fname)
                with open(txt_path, "w", encoding = "utf-8") as output:
                    # We can rebuild every non-compressed tilemap, but we need to keep every compressed one until we figure out the compression algorithm
                    if compressed:
                        tmap_path = f"game/tilemaps/{fname}.tmap"
                        with open(tmap_path, "wb") as binary:
                            binary.write(bytearray([compressed] + tilemap_bytes[i] + [0xFF]))
                        output.write("[DIRECT]\n")
                        tilemap_bytes[i] = tilemaps.decompress_tilemap(tilemap_bytes[i])
                    else:
                        output.write("[OVERLAY]\n")
                    # Assume tilesets[fname] in tiletables if fname is in tilesets
                    output.write("".join(utils.bin2txt(tilemap_bytes[i], tiletables[tileset_table[fname]] if fname in tileset_table else tileset_default)))
                print(f"total length 0x{len(tilemap_bytes[i]):02x}")
            else:
                print("Duplicate")
            if ptrfile:
                ptrfile.write(f"{i:02X}={os.path.basename(fname)}\n")
            if tileset_file:
                tileset_file.write(f"{fname}=MainDialog,MainSpecial\n")
    finally:
        if ptrfile:
            ptrfile.close()
        if tileset_file:
            tileset_file.close()