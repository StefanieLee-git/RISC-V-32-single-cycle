module ContrGen (
  /* verilator lint_off UNUSED */
  input [6:0] op,
  input [2:0] func3,
  input [6:0] func7,
  /* verilator lint_on UNUSED */
  output reg [2:0] ExtOP,
  output reg RegWr,
  output reg [2:0] Branch,
  output reg MemtoReg,
  output reg MemWr,
  output reg [2:0] MemOP,
  output reg ALUAsrc,
  output reg [1:0] ALUBsrc,
  output reg [3:0] ALUctr
);

  always@(*)
  begin
    ExtOP = 3'b111;
    RegWr = 0;
    Branch = 3'b000;
    MemtoReg = 0;
    MemWr = 0;
    MemOP = 3'b111;
    ALUAsrc = 0;
    ALUBsrc = 2'b11;
    ALUctr = 4'b1111;
    case (op[6:2])
      5'b01101: // lui
      begin
        ExtOP = 3'b001;
        RegWr = 1;
        Branch = 3'b000;
        MemtoReg = 0;
        MemWr = 0;
        MemOP = 3'b111;
        ALUAsrc = 0;
        ALUBsrc = 2'b01;
        ALUctr = 4'b0011;
      end
    
      5'b00101: // auipc
      begin
        ExtOP = 3'b001;
        RegWr = 1;
        Branch = 3'b000;
        MemtoReg = 0;
        MemWr = 0;
        MemOP = 3'b111;
        ALUAsrc = 1;
        ALUBsrc = 2'b01;
        ALUctr = 4'b0000; 
      end

      5'b00100:
      begin
        if (func3 == 3'b000) // addi
        begin
          ExtOP = 3'b000;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b0000; 
        end
        else if (func3 == 3'b010) // stli
        begin
          ExtOP = 3'b000;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0; 
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b0010; 
        end
        else if (func3 == 3'b011) // stliu
        begin
          ExtOP = 3'b000;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b1010; 
        end
        else if (func3 == 3'b100) // xori
        begin
          ExtOP = 3'b000;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b0100; 
        end
        else if (func3 == 3'b110) // ori
        begin
          ExtOP = 3'b000;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b0110; 
        end
        else if (func3 == 3'b111) // andi
        begin
          ExtOP = 3'b000;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b0111; 
        end
        else if (func3 == 3'b001 && func7[5] == 1'b0) // slli
        begin
          ExtOP = 3'b000;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b0001; 
        end
        else if (func3 == 3'b101 && func7[5] == 1'b0) // srli
        begin
          ExtOP = 3'b000;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b0101; 
        end
        else if (func3 == 3'b101 && func7[5] == 1'b1) // srai
        begin
          ExtOP = 3'b000;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b1101; 
        end
      end

      5'b01100:
      begin
        if (func3 == 3'b000 && func7[5] == 1'b0) // add
        begin
          ExtOP = 3'b111;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b00;
          ALUctr = 4'b0000; 
        end
        else if (func3 == 3'b000 && func7[5] == 1'b1) // sub
        begin
          ExtOP = 3'b111;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b00;
          ALUctr = 4'b1000; 
        end
        else if (func3 == 3'b001 && func7[5] == 1'b0) // sll
        begin
          ExtOP = 3'b111;
          RegWr = 1;
          Branch = 0;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b00;
          ALUctr = 4'b0001; 
        end
        else if (func3 == 3'b010 && func7[5] == 1'b0) // slt
        begin
          ExtOP = 3'b111;
          RegWr = 1;
          Branch = 0;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b00;
          ALUctr = 4'b0010; 
        end
        else if (func3 == 3'b011 && func7[5] == 1'b0) // sltu
        begin
          ExtOP = 3'b111;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b00;
          ALUctr = 4'b1010; 
        end
        else if (func3 == 3'b100 && func7[5] == 1'b0) // xor
        begin
          ExtOP = 3'b111;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b00;
          ALUctr = 4'b0100; 
        end
        else if (func3 == 3'b101 && func7[5] == 1'b0) // srl
        begin
          ExtOP = 3'b111;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b00;
          ALUctr = 4'b0101; 
        end
        else if (func3 == 3'b101 && func7[5] == 1'b1) // sra
        begin
          ExtOP = 3'b111;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b00;
          ALUctr = 4'b1101; 
        end
        else if (func3 == 3'b110 && func7[5] == 1'b0) // or
        begin
          ExtOP = 3'b111;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b00;
          ALUctr = 4'b0110; 
        end
        else if (func3 == 3'b111 && func7[5] == 1'b0) // and
        begin
          ExtOP = 3'b111;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b00;
          ALUctr = 4'b0111; 
        end
      end

      5'b11011: // jal
      begin
        ExtOP = 3'b100;
        RegWr = 1;
        Branch = 3'b001;
        MemtoReg = 0;
        MemWr = 0;
        MemOP = 3'b111;
        ALUAsrc = 1;
        ALUBsrc = 2'b10;
        ALUctr = 4'b0000; 
      end

      5'b11001: // jalr
      begin
        if (func3 == 3'b000)
        begin
          ExtOP = 3'b000;
          RegWr = 1;
          Branch = 3'b010;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 1;
          ALUBsrc = 2'b10;
          ALUctr = 4'b0000; 
        end
      end

      5'b11000:
      begin
        if (func3 == 3'b000) // beq
        begin
          ExtOP = 3'b011;
          RegWr = 0;
          Branch = 3'b100;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b00;
          ALUctr = 4'b0010; 
        end
        else if (func3 == 3'b001) // bne
        begin
          ExtOP = 3'b011;
          RegWr = 0;
          Branch = 3'b101;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b00;
          ALUctr = 4'b0010; 
        end
        else if (func3 == 3'b100) // blt
        begin
          ExtOP = 3'b011;
          RegWr = 0;
          Branch = 3'b110;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b00;
          ALUctr = 4'b0010; 
        end
        else if (func3 == 3'b101) // bge
        begin
          ExtOP = 3'b011;
          RegWr = 0;
          Branch = 3'b111;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b00;
          ALUctr = 4'b0010; 
        end
        else if (func3 == 3'b110) // bltu
        begin
          ExtOP = 3'b011;
          RegWr = 0;
          Branch = 3'b110;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b00;
          ALUctr = 4'b1010; 
        end
        else if (func3 == 3'b111) // bgeu
        begin
          ExtOP = 3'b011;
          RegWr = 0;
          Branch = 3'b111;
          MemtoReg = 0;
          MemWr = 0;
          MemOP = 3'b111;
          ALUAsrc = 0;
          ALUBsrc = 2'b00;
          ALUctr = 4'b1010; 
        end
      end

      5'b00000:
      begin
        if (func3 == 3'b000) // lb
        begin
          ExtOP = 3'b000;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 1;
          MemWr = 0;
          MemOP = 3'b000;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b0000; 
        end
        else if (func3 == 3'b001) // lh
        begin
          ExtOP = 3'b000;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 1;
          MemWr = 0;
          MemOP = 3'b001;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b0000; 
        end
        else if (func3 == 3'b010) // lw
        begin
          ExtOP = 3'b000;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 1;
          MemWr = 0;
          MemOP = 3'b010;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b0000; 
        end
        else if (func3 == 3'b100) // lbu
        begin
          ExtOP = 3'b000;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 1;
          MemWr = 0;
          MemOP = 3'b100;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b0000; 
        end
        else if (func3 == 3'b101) // lhu
        begin
          ExtOP = 3'b000;
          RegWr = 1;
          Branch = 3'b000;
          MemtoReg = 1;
          MemWr = 0;
          MemOP = 3'b101;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b0000; 
        end
      end

      5'b01000:
      begin
        if (func3 == 3'b000) // sb
        begin
          ExtOP = 3'b010;
          RegWr = 0;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 1;
          MemOP = 3'b000;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b0000; 
        end
        else if (func3 == 3'b001) // sh
        begin
          ExtOP = 3'b010;
          RegWr = 0;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 1;
          MemOP = 3'b001;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b0000; 
        end
        else if (func3 == 3'b010) // sw
        begin
          ExtOP = 3'b010;
          RegWr = 0;
          Branch = 3'b000;
          MemtoReg = 0;
          MemWr = 1;
          MemOP = 3'b010;
          ALUAsrc = 0;
          ALUBsrc = 2'b01;
          ALUctr = 4'b0000; 
        end
      end
      
      default:
      begin
        ExtOP = 3'b111;
        RegWr = 0;
        Branch = 3'b000;
        MemtoReg = 0;
        MemWr = 0;
        MemOP = 3'b111;
        ALUAsrc = 0;
        ALUBsrc = 2'b11;
        ALUctr = 4'b1111; 
      end
    endcase
  end
  
endmodule
