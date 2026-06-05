module PC (
  input clk,
  input reset,
  input [31:0] nextPC, 
  output reg [31:0] nowPC
);

  always@(negedge clk)
  begin
    if (reset)
    begin
      nowPC <= 32'b0;
    end
    else
    begin
      nowPC <= nextPC;
    end
  end

endmodule
