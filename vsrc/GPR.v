// 同步写，异步读
module GPR #(
  parameter WIDTH = 32,
  parameter NUM_REG = 32
)(
  input clk,
  input wen,
  input clear,
  input [$clog2(NUM_REG) - 1:0] rs1,
  output reg [WIDTH - 1:0] bus_rs1,
  input [$clog2(NUM_REG) - 1:0] rs2,
  output reg [WIDTH - 1:0] bus_rs2,
  input [$clog2(NUM_REG) - 1:0] rd,
  input reg [WIDTH - 1:0] bus_rd,
  // 调试
  output [WIDTH - 1:0] data_a0
);

  reg [WIDTH - 1:0] GPR_reg [NUM_REG - 1:0];

  // 同步写和清零
  integer i;
  always@(negedge clk)
  begin
    if (clear)
    begin
      for (i = 0; i < NUM_REG; i = i + 1)
      begin
        GPR_reg[i] <= {WIDTH{1'b0}};
      end
    end
    else if (wen)
    begin
      if (rd == 0)
      begin
        GPR_reg[rd] <= {WIDTH{1'b0}};
      end
      else
      begin
        GPR_reg[rd] <= bus_rd;
      end
    end 
  end

  // 异步读
  assign bus_rs1 = GPR_reg[rs1];
  assign bus_rs2 = GPR_reg[rs2];

  // 调试
  assign data_a0 = GPR_reg[10];


endmodule
