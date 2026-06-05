module GenNextPC (
  input PCAsrc,
  input [31:0] imm,
  input PCBsrc,
  input [31:0] bus_rs1,
  input [31:0] nowPC,
  output [31:0] nextPC
);

  wire [31:0] A;
  wire [31:0] B;
  assign A = PCAsrc ? imm : 32'd4;
  assign B = PCBsrc ? bus_rs1 : nowPC;
  
  assign nextPC = A + B; 

endmodule
