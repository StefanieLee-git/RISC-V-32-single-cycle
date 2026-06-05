module barrel_shifter ( // 32位, 面积换性能
  input en,
  input [31:0] in_data,
  input [4:0] shift_amount,
  input shift_direction, // 1: 左移，0: 右移
  input shift_type, // 1: 算数，0: 逻辑
  output [31:0] out_data // if shift_direction = 1 && shift_type = 1, out_data = in_data
);

  // 第一级：移位0位 或 1位
  wire [31:0] stage1;
  assign stage1 = shift_amount[0] ? 
      (shift_direction ? 
      (shift_type ? in_data : {in_data[30:0], 1'b0}) : // 保持，逻辑左移1位
      (shift_type ? {in_data[31], in_data[31:1]} : {1'b0, in_data[31:1]})) : // 算数右移1位，逻辑右移1位
      in_data; // 移位0位

  // 第二级：移位0位 或 2位
  wire [31:0] stage2;
  assign stage2 = shift_amount[1] ? 
      (shift_direction ? 
      (shift_type ? stage1 : {stage1[29:0], 2'b0}) : // 保持，逻辑左移2位
      (shift_type ? {{2{stage1[31]}}, stage1[31:2]} : {2'b0, stage1[31:2]})) : // 算数右移2位，逻辑右移2位 
      stage1;

  // 第三级：移位0位 或 4位
  wire [31:0] stage3;
  assign stage3 = shift_amount[2] ? 
      (shift_direction ? 
      (shift_type ? stage2 : {stage2[27:0], 4'b0}) : // 保持，逻辑左移4位
      (shift_type ? {{4{stage2[31]}}, stage2[31:4]}: {4'b0, stage2[31:4]})) : // 算数右移4位，逻辑右移4位
      stage2;

  // 第四级：移位0位 或 8位
  wire [31:0] stage4;
  assign stage4 = shift_amount[3] ? 
      (shift_direction ? 
      (shift_type ? stage3 : {stage3[23:0], 8'b0}) : // 保持，逻辑左移8位
      (shift_type ? {{8{stage3[31]}}, stage3[31:8]}: {8'b0, stage3[31:8]})) : // 算数右移8位，逻辑右移8位
      stage3;

  // 第五级：移位0位 或 16位
  wire [31:0] stage5;
  assign stage5 = shift_amount[4] ? 
      (shift_direction ? 
      (shift_type ? stage4 : {stage4[15:0], 16'b0}) : // 保持，逻辑左移16位
      (shift_type ? {{16{stage4[31]}}, stage4[31:16]}: {16'b0, stage4[31:16]})) : // 算数右移16位，逻辑右移16位
      stage4;

  assign out_data = en ? stage5 : 32'b0;

endmodule
