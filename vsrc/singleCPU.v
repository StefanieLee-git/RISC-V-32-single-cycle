module singleCPU (
  input clk,
  input reset,
  input [31:0] InstrMem_dout,
  output [31:0] InstrMem_addr,
  input [31:0] DataMem_dout,
  output [31:0] DataMem_addr,
  output [31:0] DataMem_din,
  output MemWr,
  output [2:0] MemOP,
  // 调试
  output [31:0] data_a0 
);

  // 指令译码
  wire [31:0] Instr;
  assign Instr = InstrMem_dout;

  wire [6:0] op;
  wire [4:0] rs1, rs2, rd;
  wire [2:0] func3;
  wire [6:0] func7;

  assign op = Instr[6:0];
  assign rs1 = Instr[19:15];
  assign rs2 = Instr[24:20];
  assign rd = Instr[11:7];
  assign func3 = Instr[14:12];
  assign func7 = Instr[31:25];

  // 产生控制信号
  wire [2:0] ExtOP;
  wire RegWr;
  wire [2:0] Branch;
  wire MemtoReg;
  wire ALUAsrc;
  wire [1:0] ALUBsrc;
  wire [3:0] ALUctr;
  ContrGen CPU_ContrGen (
    .op(op),
    .func3(func3),
    .func7(func7),
    .ExtOP(ExtOP),
    .RegWr(RegWr),
    .Branch(Branch),
    .MemtoReg(MemtoReg),
    .MemWr(MemWr),
    .MemOP(MemOP),
    .ALUAsrc(ALUAsrc),
    .ALUBsrc(ALUBsrc),
    .ALUctr(ALUctr) 
  );

  // 产生立即数
  wire [31:0] imm;
  ImmGen CPU_immGen (
    .instr(Instr),
    .ExtOP(ExtOP),
    .imm(imm)
  );

  // 读两个源寄存器的数据
  wire [31:0] bus_rs1;
  wire [31:0] bus_rs2;
  wire [31:0] bus_rd;
  GPR CPU_GPR (
    .clk(clk),
    .clear(reset),
    .wen(RegWr),
    .rs1(rs1),
    .bus_rs1(bus_rs1),
    .rs2(rs2),
    .bus_rs2(bus_rs2),
    .rd(rd),
    .bus_rd(bus_rd),
    // 调试
    .data_a0(data_a0)
  );

  // 计算数据存储器读取地址，或写入寄存器的数据
  wire [31:0] nowPC;
  reg [31:0] A;
  reg [31:0] B;
  always@(*)
  begin
    case (ALUAsrc)
      0: A = bus_rs1;
      1: A = nowPC;
      default:
          A = 32'b0;
    endcase

    case (ALUBsrc)
      2'b00: B = bus_rs2;
      2'b01: B = imm;
      2'b10: B = 32'd4; 
      default:
          B = 32'b0;
    endcase
  end
  
  wire [31:0] ALUout;
  wire Zero;
  wire Less;
  ALU CPU_ALU (
    .ALUctr(ALUctr),
    .A(A),
    .B(B),
    .ALUout(ALUout),
    .Zero(Zero),
    .Less(Less)
  );

  // 更新PC
  wire PCAsrc;
  wire PCBsrc;
  BranchCond CPU_BranchCond (
    .Branch(Branch),
    .Zero(Zero),
    .Less(Less),
    .PCAsrc(PCAsrc),
    .PCBsrc(PCBsrc)
  ); 

  PC CPU_PC (
    .clk(clk),
    .reset(reset),
    .nextPC(nextPC),
    .nowPC(nowPC) 
  );

  wire [31:0] nextPC;
  GenNextPC CPU_GenNextPC (
    .PCAsrc(PCAsrc),
    .imm(imm),
    .PCBsrc(PCBsrc),
    .bus_rs1(bus_rs1),
    .nowPC(nowPC),
    .nextPC(nextPC)
  );

  // 取下周期指令
  assign InstrMem_addr = nextPC;

  // 读 或 写 数据存储器 地址
  assign DataMem_addr = ALUout; 

  // 判段，写寄存器数据
  assign bus_rd = MemtoReg ? DataMem_dout : ALUout;

  // 写 数据存储器 数据
  assign DataMem_din = bus_rs2; 

endmodule
