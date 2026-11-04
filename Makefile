IVERILOG ?= iverilog
VVP ?= vvp
YOSYS ?= yosys
.PHONY: test synth clean
test:
	mkdir -p build
	$(IVERILOG) -g2012 -Wall -s tb_sgdma_axi4_read -o build/sim rtl/sgdma_axi4_read.sv tb/tb_sgdma_axi4_read.sv
	$(VVP) build/sim
synth:
	mkdir -p build
	$(YOSYS) -Q -T -l build/synthesis.log -p 'read_verilog -sv rtl/sgdma_axi4_read.sv; hierarchy -check -top sgdma_axi4_read; synth -top sgdma_axi4_read; stat'
clean:
	rm -f build/sim
