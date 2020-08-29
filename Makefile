export LC_CTYPE=C
export PYTHONIOENCODING=utf-8

VERSIONS := parts_collection
OUTPUT_PREFIX := medarot_
ORIGINAL_PREFIX := baserom_

PYTHON := python3

# Types
ROM_TYPE := gb
SYM_TYPE := sym
MAP_TYPE := map

SOURCE_TYPE := asm
INT_TYPE := o

RAW_TSET_SRC_TYPE := png
TSET_SRC_TYPE := 2bpp
TSET_TYPE := malias

# Directories
BASE := .
BUILD := $(BASE)/build
GAME := $(BASE)/game
TEXT := $(BASE)/text
SCRIPT := $(BASE)/scripts

# Build Directories
TILESET_OUT := $(BUILD)/tilesets

# Game Source Directories
SRC := $(GAME)/src
TILESET_BIN := $(GAME)/tilesets
COMMON := $(SRC)/common

# Text Directories
TILESET_TEXT := $(TEXT)/tilesets
DIALOG_TEXT := $(TEXT)/dialog

# Source Modules (directories in SRC)
MODULES := core gfx story

# Toolchain
CC := rgbasm
CC_ARGS :=
LD := rgblink
LD_ARGS :=
FIX := rgbfix
FIX_ARGS :=
CCGFX := rgbgfx
CCGFX_ARGS := 

# Helper
TOUPPER = $(shell echo '$1' | tr '[:lower:]' '[:upper:]')

# Inputs
ORIGINALS := $(foreach VERSION,$(VERSIONS),$(BASE)/$(ORIGINAL_PREFIX)$(VERSION).$(ROM_TYPE))

# Outputs (used by clean)
TARGETS := $(foreach VERSION,$(VERSIONS),$(BASE)/$(OUTPUT_PREFIX)$(VERSION).$(ROM_TYPE))
SYM_OUT := $(foreach VERSION,$(VERSIONS),$(BASE)/$(OUTPUT_PREFIX)$(VERSION).$(SYM_TYPE))
MAP_OUT := $(foreach VERSION,$(VERSIONS),$(BASE)/$(OUTPUT_PREFIX)$(VERSION).$(MAP_TYPE))

# Sources
OBJNAMES := $(foreach MODULE,$(MODULES),$(addprefix $(MODULE)., $(addsuffix .$(INT_TYPE), $(notdir $(basename $(wildcard $(SRC)/$(MODULE)/*.$(SOURCE_TYPE)))))))
COMMON_SRC := $(wildcard $(COMMON)/*.$(SOURCE_TYPE))

TILESETS := $(notdir $(basename $(wildcard $(TILESET_TEXT)/*.$(RAW_TSET_SRC_TYPE))))

# Intermediates
OBJECTS := $(foreach OBJECT,$(OBJNAMES), $(addprefix $(BUILD)/,$(OBJECT)))

TILESET_FILES := $(foreach FILE,$(TILESETS),$(TILESET_OUT)/$(FILE).$(TSET_TYPE))

# Additional dependencies, per module granularity (i.e. story, gfx, core) or per file granularity (e.g. story_text_tables_ADDITIONAL)
# core_ADDITIONAL :=
# core_main_ADDITIONAL :=
shared_ADDITIONAL := 
gfx_ADDITIONAL := $(TILESET_FILES)

.PHONY: $(VERSIONS) all clean default dump dump_tilesets dump_text
default: parts_collection
all: $(VERSIONS)

# Support building specific versions
# Unfortunately make has no real good way to do this dynamically from VERSIONS so we just manually set CURVERSION here to propagate to the rgbasm call
parts_collection: CURVERSION:=parts_collection

$(VERSIONS): %: $(OUTPUT_PREFIX)%.$(ROM_TYPE)

# $| is a hack, we cannot have any other order-only prerequisites
.SECONDEXPANSION:
$(BASE)/$(OUTPUT_PREFIX)%.$(ROM_TYPE): $(OBJECTS) $$(addprefix $(BUILD)/$$*., $$(addsuffix .$(INT_TYPE), $$(notdir $$(basename $$(wildcard $(SRC)/$$*/*.$(SOURCE_TYPE)))))) | $(BASE)/$(ORIGINAL_PREFIX)%.$(ROM_TYPE)
	$(LD) $(LD_ARGS) --dmg -n $(OUTPUT_PREFIX)$*.$(SYM_TYPE) -m $(OUTPUT_PREFIX)$*.$(MAP_TYPE) -O $| -o $@ $^
	$(FIX) $(FIX_ARGS) -v -k 9C -l 0x33 -m 0x03 -p 0 -r 3 $@ -t "$(subst _, ,$(call TOUPPER,$(CURVERSION)))"
	cmp -l $| $@

# Don't delete intermediate files
.SECONDEXPANSION:
.SECONDARY:
$(BUILD)/%.$(INT_TYPE): $(SRC)/$$(firstword $$(subst ., ,$$*))/$$(lastword $$(subst ., ,$$*)).$(SOURCE_TYPE) $(COMMON_SRC) $(shared_ADDITIONAL) $$(wildcard $(SRC)/$$(firstword $$(subst ., ,$$*))/include/*.$(SOURCE_TYPE)) $$($$(firstword $$(subst ., ,$$*))_ADDITIONAL) $$($$(firstword $$(subst ., ,$$*))_$$(lastword $$(subst ., ,$$*))_ADDITIONAL) | $(BUILD)
	$(CC) $(CC_ARGS) -DGAMEVERSION=$(CURVERSION) -o $@ $<

# build/tilesets/*.malias from built 2bpp
$(TILESET_OUT)/%.$(TSET_TYPE): $(TILESET_OUT)/%.$(TSET_SRC_TYPE) | $(TILESET_OUT)
	$(PYTHON) $(SCRIPT)/tileset2malias.py $< $@

# build/tilesets/*.2bpp from source png
$(TILESET_OUT)/%.$(TSET_SRC_TYPE): $(TILESET_TEXT)/%.$(RAW_TSET_SRC_TYPE) | $(TILESET_OUT)
	$(CCGFX) $(CCGFX_ARGS) -d 2 -o $@ $<

clean:
	rm -r $(BUILD) $(TARGETS) $(SYM_OUT) $(MAP_OUT) || exit 0

dump: dump_tilesets dump_text

dump_tilesets: | $(TILESET_TEXT) $(TILESET_BIN)
	$(PYTHON) $(SCRIPT)/dump_tilesets.py	

dump_text: | $(DIALOG_TEXT)
	$(PYTHON) $(SCRIPT)/dump_text.py

#Make directories if necessary
$(BUILD):
	mkdir -p $(BUILD)

$(TILESET_BIN):
	mkdir -p $(TILESET_BIN)

$(TILESET_TEXT):
	mkdir -p $(TILESET_TEXT)

$(TILESET_OUT):
	mkdir -p $(TILESET_OUT)

$(DIALOG_TEXT):
	mkdir -p $(DIALOG_TEXT)