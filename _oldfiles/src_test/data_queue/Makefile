SIM = icarus

TOPLEVEL_LANG = verilog

SOURCES_DIR = ../../src

VERILOG_SOURCES = $(SOURCES_DIR)/dual_port_fifo.sv 
VERILOG_SOURCES += $(SOURCES_DIR)/gray2bin.sv  
VERILOG_SOURCES += $(SOURCES_DIR)/bin2gray.sv
VERILOG_SOURCES += $(SOURCES_DIR)/data_queue.sv
VERILOG_SOURCES += data_queue_tb.sv

TOPLEVEL = data_queue_tb

MODULE = data_queue_tb

include $(shell cocotb-config --makefiles)/Makefile.sim




