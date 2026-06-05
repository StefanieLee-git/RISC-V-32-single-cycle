# 项目结构

.
├── constr
│   └── top.nxdc
├── csrc
│   └── main.cpp
├── logs
│   └── top.fst
├── resource
│   ├── mem.bin
│   ├── mem.hex
│   ├── mem.txt
│   ├── mem_standard.hex
│   ├── picture.hex
│   ├── sum.bin
│   ├── sum.hex
│   ├── sum.txt
│   ├── sum_standard.hex
│   ├── test.hex
│   ├── vga.bin
│   ├── vga.hex
│   └── vga.txt
├── result
│   └── top-500MHz
│       └── yosys.log
├── vsrc
│   ├── ALU.v
│   ├── Adder.v
│   ├── BranchCond.v
│   ├── ContrGen.v
│   ├── DataMem.v
│   ├── GPR.v
│   ├── GenNextPC.v
│   ├── ImmGen.v
│   ├── InstrMem.v
│   ├── PC.v
│   ├── barrel_shifter.v
│   ├── singleCPU.v
│   └── top.v
├── Makefile
├── README.md
└── convert.sh

7 directories, 33 files

# 项目工具
1. 编译器：verilator

2. 基于开源EDA的综合和评估项目：
	- git clone git@github.com:OSCPU/yosys-sta.git
	- 综合器：yosys
	- 工艺库：icsprout55

# 项目说明
1. 完成了 RSIC-V 32位 RTL 代码的编写

2. 对少数重要指令进行了测试，具体见 /resource/*.txt
	- 后续有时间会用官方指令集测试一遍

3. 使用verialtor编译并生成了波形，logs/top.fst

4. 使用yosys综合时，由于 InstrMem 过大，导致综合失败
	- 后续有时间再改吧

5. yosys-sta 项目里有对应指令，进行面积，时序，功耗分析和检查
