#!/bin/python

import os, sys
from ast import literal_eval
sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils, tilesets

if __name__ == '__main__':
	input_file = sys.argv[1]
	output_file = sys.argv[2]
	version_suffix = sys.argv[3]

	char_table = utils.reverse_dict(utils.merge_dicts([
            tilesets.get_tileset("MainSpecial"),
            tilesets.get_tileset("MainDialog"),
            tilesets.get_tileset("dakuten", override_offset=0x0)
        ]))

	char_table2 = char_table

	with open(output_file, 'wb') as o, open(input_file, 'r', encoding="utf-8") as i:
		length,term,padbyte = (int(x) if x.isdigit() else literal_eval(x) for x in i.readline().split("|"))
		char_table['\n'] = term
		char_table2['\n'] = term

		prefix = "[{}]".format(version_suffix)
		line = i.readline()
		while line:
			for x,l in enumerate(length) if isinstance(length, tuple) else enumerate((length,)):
				if not line.startswith("[") or line.startswith(prefix):
					line = line.replace(prefix,"") # Not the best way to do it, but it's good enough
					o.write(bytearray(utils.txt2bin(line, char_table if x == 0 else char_table2, pad=l, padbyte=padbyte)))
				line = i.readline()
