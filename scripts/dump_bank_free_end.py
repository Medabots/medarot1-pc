# Utility script to dump free bytes at end of banks

from struct import unpack

with open('baserom_parts_collection.gb', 'rb') as rom, open('game/src/core/free.asm', 'w') as output:
	for i in range(1, 0x20):
		rom.seek(i * 0x4000 + 0x3fff - 1)
		x = 0
		while unpack("B", rom.read(1))[0] == 0x00:
			x += 1
			rom.seek(-2, 1)
		pos = 0x4000 + rom.tell() % 0x4000
		output.write(f'SECTION "BANK{i:02X}_END", ROMX[${pos:x}], BANK[${i:x}]\n')
		output.write(f'BANK{i:02X}_END::\n')
		output.write(f'REPT $8000 - BANK{i:02X}_END\n')
		output.write('  db 0\n')
		output.write('ENDR\n\n')