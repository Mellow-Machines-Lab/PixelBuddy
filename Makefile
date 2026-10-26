# PixelBuddy: Pixel, a character for Boop, the desk creature that watches
# your coding agents. Run everything from this folder.
#
# The character is character/, its pack (the contract is the engine's
# characters/CHARACTER.md). Boop itself, the engine that runs it, is
# engine/, Boop's repository as a submodule. Every target here runs the
# engine's own with this pack, which the engine finds as
# engine/characters/pixel, a link to character/, chosen in engine/.character
# (the engine's git ignores both).
.PHONY: setup flash bundle dev demo eval check media clean faces

ID := pixel
ENGINE := engine

# The engine checked out, with its own submodules, the first time, and
# this pack linked and chosen in it. Every other target runs this first.
setup:
	@[ -f $(ENGINE)/Package.swift ] && [ -f $(ENGINE)/agent-hooks/Package.swift ] && [ -f $(ENGINE)/mellowharness/Package.swift ] || \
	  git submodule update --init --recursive
	@cd $(ENGINE) && python3 internal/tools/packs.py $(ID)=../character && echo $(ID) > .character

# Build the firmware and upload it over USB to the board plugged in,
# the Cheap Yellow Display (MicroTech MTR024QV01A-V1) (env cyd24).
flash: setup
	$(MAKE) -C $(ENGINE) flash

# Boop.app with this character, as it ships, here in Boop.app. Open it to run it.
bundle: setup
	BUNDLE_OUT=$(CURDIR)/Boop.app $(MAKE) -C $(ENGINE) bundle

# The debug app, with the simulator, the studio and the live dashboard
# beside it (the engine's CONTRIBUTING.md). It uses Bluetooth, so run it
# from your own terminal.
dev: setup
	$(MAKE) -C $(ENGINE) dev

# A demo from character/demo/: it asks which, and where it plays (the
# simulator's page, from its checked-in recording, at once; a board; a real
# agent). NAME=… plays that one in the page without asking.
demo: setup
	$(MAKE) -C $(ENGINE) demo $(if $(NAME),NAME=$(NAME))

# character/evals/ against Jev, the brain; it needs BOOP_JEV_KEY.
eval: setup
	$(MAKE) -C $(ENGINE) eval

# Every check that needs no board, camera or Jev key, the engine's with
# this pack: the Swift tests, the firmware's (this pack's own first), the
# tools', the simulator's goldens and the Mac's mirror. The engine's own
# tests read the other character too, which this fetches into
# engine/characters/.
check: setup
	$(MAKE) -C $(ENGINE)/internal check

# The README's pictures again, from the simulator and the app: media/boop.gif,
# media/moods.gif and the popover's media/popover-*.png.
media: setup
	$(MAKE) -C $(ENGINE)/internal build tools
	cd $(ENGINE) && CHARACTER=$(ID) internal/tools/.venv/bin/python internal/tools/mediagen/mediagen.py --out ../media boop moods popover

# Pixel's faces, character/firmware/include/faces.h, from the animation bank's
# designs (character/design/boop-sound-bank-v4/, which facegen runs with
# node), checked against Chrome's drawing of them first, then its sounds,
# firmware/include/sfx.h. Rerun it when the bank changes. Needs Node and
# Google Chrome, and takes several minutes.
faces: setup
	$(MAKE) -C $(ENGINE)/internal tools
	$(ENGINE)/internal/tools/.venv/bin/python character/tools/facegen/facegen.py --check
	node character/tools/sfxgen/sfxgen.mjs

# Every build's output, the engine's and Boop.app here.
clean: setup
	$(MAKE) -C $(ENGINE) clean
	rm -rf Boop.app
