module InstrMem (
  input clk,
  input reset,
  input [19:0] PC,
  output reg [31:0] instr
); 

  initial
  begin
    $readmemh("resource/mem_standard.hex", rom_memory);
  end

  reg [31:0] rom_memory [0:1048575];

  always @(negedge clk) 
  begin
    if (reset)
    begin
      instr <= rom_memory[0];
    end
    else
    begin
      instr <= rom_memory[PC >> 2]; // 这里需要注意: 不同架构不同的offset
    end
  end

endmodule
