
ifneq ($(words $(CURDIR)),1)
 $(error Unsupported: GNU Make cannot build in directories containing spaces, build elsewhere: '$(CURDIR)')
endif

ifeq ($(VERILATOR_ROOT),)
VERILATOR = verilator
else
export VERILATOR_ROOT
VERILATOR = $(VERILATOR_ROOT)/bin/verilator
endif

default:
	$(VERILATOR) -Wall --trace --cc --exe --build *.cpp ../../src/*	--top-module ethernet_rx
	mv obj_dir/Vethernet_rx Vethernet_rx

clean:
	rm ethernet_rx.vcd
	rm Vethernet_rx
	rm -rf obj_dir
