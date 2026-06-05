module DataMem #(
    parameter DEPTH = 4096  // 综合用小容量，仿真时由 top.v 覆盖为大容量
) (
    input wire clk,           // 系统时钟
    /* verilator lint_off UNUSED */
    input wire [31:0] addr,   // 字节地址（32位地址可寻址）
    /* verilator lint_on UNUSED */
    input wire [31:0] wdata,  // 写入数据
    input wire [2:0] MemOP,   // 存储器操作类型
    input wire we,            // 写使能
    output reg [31:0] rdata   // 读取数据
);

    localparam ADDR_W = $clog2(DEPTH);

    reg [31:0] mem [0:DEPTH-1];

    // 内部信号
    wire [ADDR_W-1:0] word_addr;  // 字地址
    wire [1:0] byte_offset;       // 字节偏移

    assign word_addr = addr[ADDR_W+1:2];  // 字节地址转换为字地址
    assign byte_offset = addr[1:0];       // 字节地址的低2位作为字节偏移

    // 读取操作 - 在时钟上升沿进行
    always @(posedge clk) begin
        case (MemOP)
            // lw - 字读取
            3'b010: begin
                rdata <= mem[word_addr];
            end

            // lh - 半字读取（带符号扩展）
            3'b001: begin
                case (byte_offset)
                    2'b00: rdata <= {{16{mem[word_addr][15]}}, mem[word_addr][15:0]};
                    2'b10: rdata <= {{16{mem[word_addr][31]}}, mem[word_addr][31:16]};
                    default: rdata <= {{16{mem[word_addr][15]}}, mem[word_addr][15:0]};
                endcase
            end

            // lb - 字节读取（带符号扩展）
            3'b000: begin
                case (byte_offset)
                    2'b00: rdata <= {{24{mem[word_addr][7]}}, mem[word_addr][7:0]};
                    2'b01: rdata <= {{24{mem[word_addr][15]}}, mem[word_addr][15:8]};
                    2'b10: rdata <= {{24{mem[word_addr][23]}}, mem[word_addr][23:16]};
                    2'b11: rdata <= {{24{mem[word_addr][31]}}, mem[word_addr][31:24]};
                endcase
            end

            // lhu - 半字读取（无符号扩展）
            3'b101: begin
                case (byte_offset)
                    2'b00: rdata <= {16'b0, mem[word_addr][15:0]};
                    2'b10: rdata <= {16'b0, mem[word_addr][31:16]};
                    default: rdata <= {16'b0, mem[word_addr][15:0]};
                endcase
            end

            // lbu - 字节读取（无符号扩展）
            3'b100: begin
                case (byte_offset)
                    2'b00: rdata <= {24'b0, mem[word_addr][7:0]};
                    2'b01: rdata <= {24'b0, mem[word_addr][15:8]};
                    2'b10: rdata <= {24'b0, mem[word_addr][23:16]};
                    2'b11: rdata <= {24'b0, mem[word_addr][31:24]};
                endcase
            end

            default: begin
                rdata <= mem[word_addr];
            end
        endcase
    end

    // 写入操作 - 在时钟下降沿进行
    always @(negedge clk) begin
        if (we) begin
            case (MemOP)
                // sw - 字写入
                3'b010: begin
                    mem[word_addr] <= wdata;
                end

                // sh - 半字写入
                3'b001: begin
                    case (byte_offset)
                        2'b00: mem[word_addr][15:0] <= wdata[15:0];
                        2'b10: mem[word_addr][31:16] <= wdata[15:0];
                        default: mem[word_addr][15:0] <= wdata[15:0];
                    endcase
                end

                // sb - 字节写入
                3'b000: begin
                    case (byte_offset)
                        2'b00: mem[word_addr][7:0] <= wdata[7:0];
                        2'b01: mem[word_addr][15:8] <= wdata[7:0];
                        2'b10: mem[word_addr][23:16] <= wdata[7:0];
                        2'b11: mem[word_addr][31:24] <= wdata[7:0];
                    endcase
                end

                default: begin
                    mem[word_addr] <= wdata;
                end
            endcase
        end
    end

`ifdef VERILATOR
    initial begin
        $readmemh("resource/mem_standard.hex", mem);
    end
`endif

endmodule
