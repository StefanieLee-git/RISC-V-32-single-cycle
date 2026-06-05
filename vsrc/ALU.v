module ALU #(
  parameter WIDTH = 32
)(
  input [3:0] ALUctr,
  input [WIDTH - 1:0] A,
  input [WIDTH - 1:0] B,
  output reg [WIDTH - 1:0] ALUout,
  output Less,
  output Zero
);

  localparam ADD_SUB = 3'b000, 
             SHIFT_L = 3'b001,
             COMPARE = 3'b010,
             M_OUT_B = 3'b011,
                 XOR = 3'b100,
             SHIFT_R = 3'b101,
                  OR = 3'b110,
                 AND = 3'b111;
             
             
  wire carry;
  wire overflow;
  wire zero;
  wire [WIDTH - 1:0] adder_out;

  wire adder_enA;
  assign adder_enA = (ALUctr[2:0] == ADD_SUB);
  wire adder_enC;
  assign adder_enC = (ALUctr[2:0] == COMPARE);
  wire adder_en;
  assign adder_en = adder_enA | adder_enC;

  Adder #(
      .WIDTH(WIDTH)
  ) ALU_adder (
      .en(adder_en),
      .is_signed(adder_enA ? 1'b1 : ALUctr[3]), // 默认运算操作时，有无符号不影响结果的正确信，只看你如何解读结果
      .A(A),
      .B(B),
      .cin(adder_enA ? ALUctr[3] : 1'b1),
      .result(adder_out),
      .carry(carry),
      .overflow(overflow),
      .zero(zero)
  );

  wire less;
  assign less = (ALUctr[3] ? (overflow ^ adder_out[WIDTH - 1]) : (~carry)) & ~zero;
  assign Less = less;
  assign Zero = zero;

  wire [WIDTH - 1:0] cmp_out;
  assign cmp_out = {{(WIDTH - 1){1'b0}}, less};
 
  wire shifter_enL;
  assign shifter_enL = (ALUctr[2:0] == SHIFT_L);
  wire shifter_enR;
  assign shifter_enR = (ALUctr[2:0] == SHIFT_R);
  wire shifter_en;
  assign shifter_en = shifter_enL | shifter_enR;

  wire [WIDTH - 1:0] shifter_out;
  barrel_shifter ALU_shifter (
    .en(shifter_en),
    .in_data(A),
    .shift_amount(B[4:0]),
    .shift_direction(shifter_enL),
    .shift_type(shifter_enL ? 1'b0 : ALUctr[3]),
    .out_data(shifter_out)
  ); 

  wire [WIDTH - 1:0] xor_out;
  assign xor_out = A ^ B;

  wire [WIDTH - 1:0] or_out;
  assign or_out = A | B;

  wire [WIDTH - 1:0] and_out;
  assign and_out = A & B;

  always@(*)
  begin
    case (ALUctr[2:0])
        ADD_SUB: ALUout = adder_out;
        SHIFT_L: ALUout = shifter_out;
        COMPARE: ALUout = cmp_out;
        M_OUT_B: ALUout = B;
            XOR: ALUout = xor_out;
        SHIFT_R: ALUout = shifter_out;
             OR: ALUout = or_out;
            AND: ALUout = and_out;
        default:
            ALUout = {WIDTH{1'b0}};
    endcase
  end

endmodule
