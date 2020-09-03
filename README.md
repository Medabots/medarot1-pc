[![CircleCI](https://circleci.com/gh/Medabots/medarot1-pc/tree/master.svg?style=svg)](https://app.circleci.com/pipelines/github/Medabots/medarot1-pc?branch=master)

# Building

## Dependencies

* Medarot Parts Collection GB ROM (md5: a83d745ae8806a04d4a9e3c241f8c8cb)
	* Currently relies on the rgbds overlay feature as parts are disassembled and tacked on
* Make
* Python 3.6 or greater, aliased to 'python3'
* [rgbds](https://github.com/rednex/rgbds)

# Make

1. Name the ROM 'baserom_parts_collection.gb' and drop it in the project root
1. Execute make (optionally pass -j)
	* The master branch will execute cmp to verify the output matches the original

# Dumping

Execute 'make dump' (nothing should change, as the text files are checked in)

# Related Projects

[Medarot 1 Disassembly/Translation](https://github.com/VariantXYZ/medarot1)
