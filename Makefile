roms := \
	repurpled.gbc \
	repurpled_debug.gbc \
	repurpled_red.gbc \
	repurpled_red_debug.gbc \
	repurpled_blue.gbc \
	repurpled_blue_debug.gbc
patches := \
	repurpled_red.patch \
	repurpled_blue.patch

rom_obj := \
	audio.o \
	home.o \
	main.o \
	maps.o \
	ram.o \
	text.o \
	gfx/pics.o \
	gfx/sprites.o \
	gfx/tilesets.o

repurpled_obj            := $(rom_obj:.o=_repurpled.o)
repurpled_debug_obj      := $(rom_obj:.o=_repurpled_debug.o)
repurpled_red_obj        := $(rom_obj:.o=_repurpled_red.o)
repurpled_red_debug_obj  := $(rom_obj:.o=_repurpled_red_debug.o)
repurpled_blue_obj       := $(rom_obj:.o=_repurpled_blue.o)
repurpled_blue_debug_obj := $(rom_obj:.o=_repurpled_blue_debug.o)
repurpled_red_vc_obj     := $(rom_obj:.o=_repurpled_red_vc.o)
repurpled_blue_vc_obj    := $(rom_obj:.o=_repurpled_blue_vc.o)


### Build tools

ifeq (,$(shell which sha1sum))
SHA1 := shasum
else
SHA1 := sha1sum
endif

RGBDS ?=
RGBASM  ?= $(RGBDS)rgbasm
RGBFIX  ?= $(RGBDS)rgbfix
RGBGFX  ?= $(RGBDS)rgbgfx
RGBLINK ?= $(RGBDS)rgblink


### Build targets

.SUFFIXES:
.SECONDEXPANSION:
.PRECIOUS:
.SECONDARY:
.PHONY: all repurpled repurpled_debug red red_debug blue blue_debug red_vc blue_vc clean tidy compare tools

repurpled:       repurpled.gbc
repurpled_debug: repurpled_debug.gbc
red:            repurpled_red.gbc
red_debug:      repurpled_red_debug.gbc
blue:           repurpled_blue.gbc
blue_debug:     repurpled_blue_debug.gbc
red_vc:         repurpled_red.patch
blue_vc:        repurpled_blue.patch
all: $(roms) $(patches)

clean: tidy
	find gfx \
	     \( -iname '*.1bpp' \
	        -o -iname '*.2bpp' \
	        -o -iname '*.pic' \) \
	     -delete

tidy:
	$(RM) $(roms) \
	      $(roms:.gbc=.sym) \
	      $(roms:.gbc=.map) \
	      $(patches) \
	      $(patches:.patch=_vc.gbc) \
	      $(patches:.patch=_vc.sym) \
	      $(patches:.patch=_vc.map) \
	      $(patches:%.patch=vc/%.constants.sym) \
		  $(repurpled_obj) \
	      $(repurpled_red_obj) \
	      $(repurpled_blue_obj) \
	      $(repurpled_red_vc_obj) \
	      $(repurpled_blue_vc_obj) \
		  $(repurpled_debug_obj) \
		  $(repurpled_red_debug_obj) \
	      $(repurpled_blue_debug_obj) \
	      rgbdscheck.o
	$(MAKE) clean -C tools/

compare: $(roms) $(patches)
	@$(SHA1) -c roms.sha1

tools:
	$(MAKE) -C tools/


RGBASMFLAGS = -Q8 -P includes.asm -Weverything -Wtruncation=1
# Create a sym/map for debug purposes if `make` run with `DEBUG=1`
ifeq ($(DEBUG),1)
RGBASMFLAGS += -E
endif

$(repurpled_obj):            RGBASMFLAGS += -D _REPURPLED
$(repurpled_debug_obj):      RGBASMFLAGS += -D _REPURPLED -D _DEBUG
$(repurpled_red_obj):        RGBASMFLAGS += -D _RED
$(repurpled_red_debug_obj):  RGBASMFLAGS += -D _RED -D _DEBUG
$(repurpled_blue_obj):       RGBASMFLAGS += -D _BLUE
$(repurpled_blue_debug_obj): RGBASMFLAGS += -D _BLUE -D _DEBUG
$(repurpled_red_vc_obj):     RGBASMFLAGS += -D _RED -D _RED_VC
$(repurpled_blue_vc_obj):    RGBASMFLAGS += -D _BLUE -D _BLUE_VC

%.patch: vc/%.constants.sym %_vc.gbc %.gbc vc/%.patch.template
	tools/make_patch $*_vc.sym $^ $@

rgbdscheck.o: rgbdscheck.asm
	$(RGBASM) -o $@ $<

# Build tools when building the rom.
# This has to happen before the rules are processed, since that's when scan_includes is run.
ifeq (,$(filter clean tidy tools,$(MAKECMDGOALS)))

$(info $(shell $(MAKE) -C tools))

# The dep rules have to be explicit or else missing files won't be reported.
# As a side effect, they're evaluated immediately instead of when the rule is invoked.
# It doesn't look like $(shell) can be deferred so there might not be a better way.
preinclude_deps := includes.asm $(shell tools/scan_includes includes.asm)
define DEP
$1: $2 $$(shell tools/scan_includes $2) $(preinclude_deps) | rgbdscheck.o
	$$(RGBASM) $$(RGBASMFLAGS) -o $$@ $$<
endef

# Dependencies for objects (drop _red and _blue from asm file basenames)
$(foreach obj, $(repurpled_obj), $(eval $(call DEP,$(obj),$(obj:_repurpled.o=.asm))))
$(foreach obj, $(repurpled_debug_obj), $(eval $(call DEP,$(obj),$(obj:_repurpled_debug.o=.asm))))
$(foreach obj, $(repurpled_red_obj), $(eval $(call DEP,$(obj),$(obj:_repurpled_red.o=.asm))))
$(foreach obj, $(repurpled_red_debug_obj), $(eval $(call DEP,$(obj),$(obj:_repurpled_red_debug.o=.asm))))
$(foreach obj, $(repurpled_blue_obj), $(eval $(call DEP,$(obj),$(obj:_repurpled_blue.o=.asm))))
$(foreach obj, $(repurpled_blue_debug_obj), $(eval $(call DEP,$(obj),$(obj:_repurpled_blue_debug.o=.asm))))
$(foreach obj, $(repurpled_red_vc_obj), $(eval $(call DEP,$(obj),$(obj:_repurpled_red_vc.o=.asm))))
$(foreach obj, $(repurpled_blue_vc_obj), $(eval $(call DEP,$(obj),$(obj:_repurpled_blue_vc.o=.asm))))

# Dependencies for VC files that need to run scan_includes
%.constants.sym: %.constants.asm $(shell tools/scan_includes %.constants.asm) $(preinclude_deps) | rgbdscheck.o
	$(RGBASM) $(RGBASMFLAGS) $< > $@

endif


%.asm: ;

repurpled_pad            = 0x00
repurpled_debug_pad      = 0x00
repurpled_red_pad        = 0x00
repurpled_red_debug_pad  = 0xff
repurpled_blue_pad       = 0x00
repurpled_red_vc_pad     = 0x00
repurpled_blue_vc_pad    = 0x00
repurpled_blue_debug_pad = 0xff

repurpled_opt            = -jsv -n 0 -k 01 -l 0x33 -m 0x13 -r 03 -t "PK REPURPLED E"
repurpled_debug_opt      = -jsv -n 0 -k 01 -l 0x33 -m 0x13 -r 03 -t "PK REPURPLED E"
repurpled_red_opt        = -jsv -n 0 -k 01 -l 0x33 -m 0x13 -r 03 -t "POKEMON RED"
repurpled_red_debug_opt  = -jsv -n 0 -k 01 -l 0x33 -m 0x13 -r 03 -t "POKEMON RED"
repurpled_blue_opt       = -jsv -n 0 -k 01 -l 0x33 -m 0x13 -r 03 -t "POKEMON BLUE"
repurpled_blue_debug_opt = -jsv -n 0 -k 01 -l 0x33 -m 0x13 -r 03 -t "POKEMON BLUE"
repurpled_red_vc_opt     = -jsv -n 0 -k 01 -l 0x33 -m 0x13 -r 03 -t "POKEMON RED"
repurpled_blue_vc_opt    = -jsv -n 0 -k 01 -l 0x33 -m 0x13 -r 03 -t "POKEMON BLUE"

%.gbc: $$(%_obj) layout.link
	$(RGBLINK) -p $($*_pad) -d -m $*.map -n $*.sym -l layout.link -o $@ $(filter %.o,$^)
	$(RGBFIX) -p $($*_pad) $($*_opt) $@


### Misc file-specific graphics rules

gfx/battle/move_anim_0.2bpp: tools/gfx += --trim-whitespace
gfx/battle/move_anim_1.2bpp: tools/gfx += --trim-whitespace

gfx/intro/blue_jigglypuff_1.2bpp: rgbgfx += --columns
gfx/intro/blue_jigglypuff_2.2bpp: rgbgfx += --columns
gfx/intro/blue_jigglypuff_3.2bpp: rgbgfx += --columns
gfx/intro/red_nidorino_1.2bpp: rgbgfx += --columns
gfx/intro/red_nidorino_2.2bpp: rgbgfx += --columns
gfx/intro/red_nidorino_3.2bpp: rgbgfx += --columns
gfx/intro/gengar.2bpp: rgbgfx += --columns
gfx/intro/gengar.2bpp: tools/gfx += --remove-duplicates --preserve=0x19,0x76

gfx/credits/the_end.2bpp: tools/gfx += --interleave --png=$<

gfx/slots/red_slots_1.2bpp: tools/gfx += --trim-whitespace
gfx/slots/blue_slots_1.2bpp: tools/gfx += --trim-whitespace

gfx/tilesets/%.2bpp: tools/gfx += --trim-whitespace
gfx/tilesets/reds_house.2bpp: tools/gfx += --preserve=0x48

gfx/trade/game_boy.2bpp: tools/gfx += --remove-duplicates


### Catch-all graphics rules

%.png: ;

%.2bpp: %.png
	$(RGBGFX) $(rgbgfx) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -o $@ $@)

%.1bpp: %.png
	$(RGBGFX) $(rgbgfx) --depth 1 -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) --depth 1 -o $@ $@)

%.pic: %.2bpp
	tools/pkmncompress $< $@
