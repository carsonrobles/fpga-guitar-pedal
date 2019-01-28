PROJ_PATH = /home/carson/poly/senior_project/fpga-guitar-pedal
PART      = xc7a100tcsg324-1

CONSTR    = $(PROJ_PATH)/src/xdc/constraints.xdc
HDR       = $(wildcard $(PROJ_PATH)/src/rtl/*/*.svh)
SRC       = $(wildcard $(PROJ_PATH)/src/rtl/*.sv $(PROJ_PATH)/src/rtl/*/*.sv)
#TB        = $(PROJ_PATH)/sim/top_tb.sv

TOP       = top
SYNTH_DCP = $(PROJ_PATH)/fab/$(TOP)_synth.dcp
PLACE_DCP = $(PROJ_PATH)/fab/$(TOP)_place.dcp
ROUTE_DCP = $(PROJ_PATH)/fab/$(TOP)_route.dcp
BIT       = $(PROJ_PATH)/fab/$(TOP).bit

.PHONY: compile
.PHONY: synth
.PHONY: place
.PHONY: route
.PHONY: bit
.PHONY: clean

# TODO: this is the flow, but polish it
#.PHONY:sim
#sim:
#	xvlog --sv $(TB) $(SRC)
	#xelab --debug wave top_tb
	#xsim --gui top_tb

compile: $(BIT)

synth: $(SYNTH_DCP)
place: $(PLACE_DCP)
route: $(ROUTE_DCP)
bit  : $(BIT)

# synthesis
$(SYNTH_DCP): $(PROJ_PATH)/scripts/synth.tcl Makefile $(CONSTR) $(HDR) $(SRC)
	# synth.tcl args
	#   0: part
	#   1: top level module name
	#   2: constraints file
	#   3: sources
	#   4: output dcp file name
	vivado -nojournal -log $(PROJ_PATH)/fab/synth.log -mode batch \
		-source $< -tclargs $(PART) $(TOP) $(CONSTR) "$(HDR) $(SRC)" $@

# place
$(PLACE_DCP): $(PROJ_PATH)/scripts/place.tcl Makefile $(SYNTH_DCP)
	# place.tcl args
	#   0: synthesis checkpoint (dcp)
	#   1: output dcp file name
	vivado -nojournal -log $(PROJ_PATH)/fab/place.log -mode batch \
		-source $< -tclargs $(SYNTH_DCP) $@

# route
$(ROUTE_DCP): $(PROJ_PATH)/scripts/route.tcl Makefile $(PLACE_DCP)
	# route.tcl args
	#   0: placement checkpoint (dcp)
	#   1: output dcp file name
	vivado -nojournal -log $(PROJ_PATH)/fab/route.log -mode batch \
		-source $< -tclargs $(PLACE_DCP) $@


# generate bitstream
$(BIT): $(PROJ_PATH)/scripts/bitstream.tcl Makefile $(ROUTE_DCP)
	# bitstream.tcl args
	#   0: routed checkpoint (dcp)
	#   1: output bit file name
	vivado -nojournal -log $(PROJ_PATH)/fab/bitstream.log -mode batch \
		-source $< -tclargs $(ROUTE_DCP) $@

# remove output files
clean:
	# remove misc Xilinx files
	rm -rf .Xil usage_statistics_webtalk.*
	rm -rf $(PROJ_PATH)/fab/vivado* $(PROJ_PATH)/fab/*.log
	rm -rf vivado* webtalk* xsim* *.log *.pb

	# remove generated checkpoint files and bit file
	rm -rf $(SYNTH_DCP) $(PLACE_DCP) $(ROUTE_DCP) $(BIT)
