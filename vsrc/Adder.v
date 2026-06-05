module Adder #(
  parameter WIDTH = 32
)(
  input en,
  input is_signed, // is_signed = 1, A, B有符号数，is_signed = 0, A, B无符号数
  input [WIDTH - 1:0] A,
  input [WIDTH - 1:0] B,
  input cin, // cin = 1, sub; cin = 0, add;
  output reg [WIDTH - 1:0] result,
  output reg carry,
  output reg overflow,
  output reg zero 
);

  wire [WIDTH - 1:0] t_add_cin;
  wire [WIDTH - 1:0] tmp_result;
  wire tmp_carry;
  wire tmp_overflow;
  wire tmp_zero;

  assign t_add_cin = ({WIDTH{cin}} ^ B) + {{(WIDTH - 1){1'b0}},cin};
  assign {tmp_carry, tmp_result} = A + t_add_cin;
  assign tmp_overflow = is_signed ? 
          (A[WIDTH - 1] == t_add_cin[WIDTH - 1]) && (tmp_result[WIDTH - 1] != A[WIDTH - 1]) : 
          (cin ? ~tmp_carry : tmp_carry);
      // if A, B是有符号数，overflow 代表是否溢出
      // if A, B是无符号数，cin = 1, overflow代表是否借位
      //                    cin = 0，overflow代表是否进位

  assign tmp_zero = ~(|tmp_result);

  always@(*)
  begin
    if (en)
    begin
      result = tmp_result;
      carry = tmp_carry;
      overflow = tmp_overflow;
      zero = tmp_zero;
    end
    else
    begin
      result = {WIDTH{1'b0}};
      carry = 1'b0;
      overflow = 1'b0;
      zero = 1'b0;
    end
  end

endmodule
