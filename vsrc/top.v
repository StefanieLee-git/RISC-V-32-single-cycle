module top (
  input clk,
  input reset,
  // 调试
  output [31:0] data_a0,
  output [19:0] PC
);

  // 调试
  assign PC = nextPC[19:0];

  wire [31:0] instr;
  /* verilator lint_off UNUSED */
  wire [31:0] nextPC;
  /* verilator lint_on UNUSED */
`ifdef VERILATOR
  // 仿真：大容量内存以容纳完整程序
  InstrMem #(.DEPTH(1048576)) top_InstrMem (
`else
  // 综合：使用默认小容量（4096）
  InstrMem top_InstrMem (
`endif
    .clk(clk),
    .reset(reset),
    .PC(nextPC[19:0]),
    .instr(instr)
  );

  wire [31:0] wdata, rdata;
  wire [31:0] addr;
  wire we;
  wire [2:0] MemOP;
  singleCPU top_CPU (
    .clk(clk),
    .reset(reset),
    .InstrMem_dout(instr),
    .InstrMem_addr(nextPC),
    .DataMem_dout(rdata),
    .DataMem_addr(addr),
    .DataMem_din(wdata),
    .MemWr(we),
    .MemOP(MemOP),
    // 调试
    .data_a0(data_a0)
  );

`ifdef VERILATOR
  // 仿真：大容量内存以容纳完整程序
  DataMem #(.DEPTH(1048576)) top_DataMem (
`else
  // 综合：使用默认小容量（4096）
  DataMem top_DataMem (
`endif
    .clk(clk),
    .addr(addr),
    .wdata(wdata),
    .MemOP(MemOP),
    .we(we),
    .rdata(rdata)
  );

endmodule
