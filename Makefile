TOPNAME = top
NXDC_FILES = constr/top.nxdc
INC_PATH ?=

VERILATOR = verilator
VERILATOR_CFLAGS += -MMD --build -cc \
    -O3 --x-assign fast --x-initial fast --noassert \
		-Wall \
		-Wno-DECLFILENAME -Wno-GENUNNAMED 
LOGS_DIR = logs
BUILD_DIR = ./build
OBJ_DIR = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/$(TOPNAME)

default: $(BIN)

$(shell mkdir -p $(BUILD_DIR))

# constraint file
SRC_AUTO_BIND = $(abspath $(BUILD_DIR)/auto_bind.cpp)
$(SRC_AUTO_BIND): $(NXDC_FILES)
	python3 $(NVBOARD_HOME)/scripts/auto_pin_bind.py $^ $@

# project source
VSRCS = $(shell find $(abspath ./vsrc) -name "*.v")
CSRCS = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp")

# rules for NVBoard
include $(NVBOARD_HOME)/scripts/nvboard.mk

# rules for verilator
INCFLAGS = $(addprefix -I, $(INC_PATH))
CXXFLAGS += $(INCFLAGS) -DTOP_NAME="\"V$(TOPNAME)\""

$(BIN): $(VSRCS) $(CSRCS) $(SRC_AUTO_BIND) $(NVBOARD_ARCHIVE)
	@echo "=== Compile Verilator and NVBoard Simulation ==="
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(VERILATOR_CFLAGS) \
		--top-module $(TOPNAME) $^ \
		$(addprefix -CFLAGS , $(CXXFLAGS)) $(addprefix -LDFLAGS , $(LDFLAGS)) \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN))

all: default

run: $(BIN)
	@echo "=== Start NVboard Simulation ==="
	@$^

build: $(VSRCS) $(CSRCS)
	@echo "=== Start Build ==="
	@mkdir -p $(LOGS_DIR) $(OBJ_DIR)
	@rm -rf $(OBJ_DIR)
	@mkdir -p $(OBJ_DIR)
	$(VERILATOR) -Wall -build -cc -j 0 -x-assign fast --trace --trace-fst \
		--top-module $(TOPNAME) $^ \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN))

sim: build
				@echo "=== Start Simulation ==="
				@./$(BUILD_DIR)/$(TOPNAME)

check: $(VSRCS)
	@echo "=== Check Verilog syntax ==="
	$(VERILATOR) --lint-only -Wall \
				-Wno-DECLFILENAME -Wno-GENUNNAMED \
				--top-module $(TOPNAME) \
				$^

# 生成波形，如果启用了(--trace --trace-fst) 
wave: sim
				@if [ -f logs/wave.fst ]; then \
								echo "Wave File: logs/wave.fst"; \
								gtkwave logs/wave.fst & \
				else \
								echo "Cannot find the wave file, Please make sure --trace --trace-fst option has been turn on";
				fi

clean:
	rm -rf $(BUILD_DIR) logs/ obj_dir/ *.log *.fst

info:
			@echo "Verilog source files: $(VSRCS)"
			@echo "C++ source files: $(CSRCS)"
			@echo "Build directory: $(BUILD_DIR)"

.PHONY: default all clean run info wave build sim
