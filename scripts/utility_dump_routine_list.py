# Python 2

import re
import subprocess
import sys

output_file = sys.argv[1]
prefix = sys.argv[2]
address_list = [int(i.strip(),16) for i in sys.argv[3].split(",")]

new_symbols = []
REGEX_PATTERN = re.compile(".*(Func_[a-f,A-F,0-9]{1,4}).*")

with open(output_file,'w') as output:
    for i, value in enumerate(address_list):
        output.write('SECTION "{}_{:02X}", ROM0[${:04X}]\n'.format(prefix, i, value))
        o = subprocess.check_output("python -m pokemontools.gbz80disasm --no-write -r medarot_parts_collection.gb {:X}".format(value).split(" "))
        label, asm = o.split(":", 1)
        label.replace("Func_", "{}_".format(prefix), 1)
        new_symbols.append(label)
        output.write("{}:".format(label))
        for line in asm.split("\n"):
            output.write("\n")
            captures = REGEX_PATTERN.search(line)
            if captures:
                if captures.group(1) not in new_symbols:
                    line = line.replace("Func_", "$")
            output.write(line)
        output.write("\n")