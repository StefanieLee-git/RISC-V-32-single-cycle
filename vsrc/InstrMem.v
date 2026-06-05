module InstrMem #(
    parameter DEPTH = 4096  // 综合用小容量，仿真时由 top.v 覆盖为大容量
) (
  input clk,
  input reset,
  input [19:0] PC,
  output reg [31:0] instr
);

  localparam ADDR_W = $clog2(DEPTH);

  reg [31:0] rom_memory [0:DEPTH-1];

  wire [ADDR_W-1:0] word_addr;
  assign word_addr = (PC >> 2);

`ifdef VERILATOR
  initial
  begin
    $readmemh("resource/mem_standard.hex", rom_memory);
  end
`endif

  always @(negedge clk)
  begin
    if (reset)
    begin
      instr <= rom_memory[0];
    end
    else
    begin
      instr <= rom_memory[word_addr]; // 这里需要注意: 不同架构不同的offset
    end
  end

endmodule
