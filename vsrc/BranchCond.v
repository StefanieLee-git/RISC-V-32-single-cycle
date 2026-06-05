module BranchCond (
  input [2:0] Branch,
  input Zero,
  input Less,
  output reg PCAsrc,
  output reg PCBsrc
);

  always@(*)
  begin
    case (Branch)
      3'b000: // 非跳转指令
      begin
        PCAsrc = 0;
        PCBsrc = 0;
      end

      3'b001: // 无条件跳转PC目标
      begin
        PCAsrc = 1;
        PCBsrc = 0;
      end

      3'b010: // 无条件跳转寄存器目标
      begin
        PCAsrc = 1;
        PCBsrc = 1;
      end

      3'b100: // 条件分支，等于
      begin
        if (!Zero) // 条件不成立
        begin
          PCAsrc = 0;
          PCBsrc = 0;
        end
        else // 条件成立
        begin
          PCAsrc = 1;
          PCBsrc = 0;
        end
      end

      3'b101: // 条件分支，不等于
      begin
        if (!Zero) // 条件成立
        begin
          PCAsrc = 1;
          PCBsrc = 0;
        end
        else // 条件不成立
        begin
          PCAsrc = 0;
          PCBsrc = 0;
        end
      end

      3'b110: // 条件分支，小于
      begin
        if (!Less) // 条件不成立
        begin
          PCAsrc = 0;
          PCBsrc = 0;
        end
        else // 条件成立
        begin
          PCAsrc = 1;
          PCBsrc = 0;
        end
      end

      3'b111: // 条件分支，大于等于
      begin
        if (!Less) // 条件成立
        begin
          PCAsrc = 1;
          PCBsrc = 0;
        end
        else
        begin
          PCAsrc = 0;
          PCBsrc = 0;
        end
      end

      default:
      begin
        PCAsrc = 0;
        PCBsrc = 0;
      end
    endcase
  end

endmodule
