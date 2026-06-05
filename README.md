# 🖥️ RISC-V 32位 CPU 实验

> 基于 Verilator + Yosys 的 RTL 设计、综合与评估项目

---

## 📁 项目结构

```
.
├── constr/                    # 约束文件
│   └── top.nxdc               #   Nexus 约束文件
│
├── csrc/                      # C++ 仿真源文件
│   └── main.cpp               #   Verilator 仿真顶层
│
├── vsrc/                      # Verilog RTL 源码
│   ├── top.v                  #   顶层模块
│   ├── singleCPU.v            #   单周期 CPU
│   ├── PC.v                   #   程序计数器
│   ├── GPR.v                  #   通用寄存器组
│   ├── ALU.v                  #   算术逻辑单元
│   ├── Adder.v                #   加法器
│   ├── ImmGen.v               #   立即数生成器
│   ├── barrel_shifter.v       #   桶形移位器
│   ├── BranchCond.v           #   分支条件判断
│   ├── ContrGen.v             #   控制器生成
│   ├── GenNextPC.v            #   下一条 PC 生成
│   ├── DataMem.v              #   数据存储器
│   └── InstrMem.v             #   指令存储器
│
├── resource/                  # 测试资源文件
│   ├── mem.bin                #   内存映像 (binary)
│   ├── mem.hex                #   内存映像 (hex)
│   ├── mem.txt                #   内存映像 (text)
│   ├── mem_standard.hex       #   标准内存映像
│   ├── sum.bin                #   求和测试 (binary)
│   ├── sum.hex                #   求和测试 (hex)
│   ├── sum.txt                #   求和测试 (text)
│   ├── sum_standard.hex       #   标准求和测试
│   ├── test.hex               #   测试用例
│   ├── vga.bin                #   VGA 测试 (binary)
│   ├── vga.hex                #   VGA 测试 (hex)
│   ├── vga.txt                #   VGA 测试 (text)
│   └── picture.hex            #   图像数据
│
├── result/                    # 综合结果
│   └── top-500MHz/            #   500MHz 目标综合
│       └── yosys.log          #     Yosys 综合日志
│
├── logs/                      # 仿真波形
│   └── top.fst                #   FST 波形文件
│
├── Makefile                   # 构建脚本
├── convert.sh                 # 格式转换脚本
└── README.md                  # 本文件
```

> **7 个目录，33 个文件**

---

## 🛠️ 项目工具

| 工具 | 用途 |
|------|------|
| **Verilator** | RTL 编译与仿真 |
| **Yosys** | 开源综合器 |
| **icsprout55** | 综合工艺库 |

> 基于开源 EDA 的综合评估项目：[yosys-sta](https://github.com/OSCPU/yosys-sta)

---

## 📝 项目说明

1. ✅ 完成 **RISC-V 32 位** RTL 代码编写
2. ✅ 对少数重要指令进行了测试，详见 `resource/*.txt`
   - 📋 后续计划：使用官方指令集完整测试
3. ✅ 使用 Verilator 编译并生成波形：`logs/top.fst`
4. ⚠️ 使用 Yosys 综合时因 `InstrMem` 过大导致综合失败
   - 📋 后续计划：优化 InstrMem 规模
5. 📊 `yosys-sta` 项目提供面积、时序、功耗的分析与检查命令
