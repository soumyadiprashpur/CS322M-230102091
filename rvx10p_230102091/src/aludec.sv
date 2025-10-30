module aludec(
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    input  logic [1:0] aluop,
    output logic [3:0] alucontrol
);
    always_comb begin
        case (aluop)
            2'b00: alucontrol = 4'b0000; // for load/store: add
            2'b01: alucontrol = 4'b0001; // for branch: subtract
            2'b10: begin // R-type
                case ({funct7, funct3})
                    10'b0000000_000: alucontrol = 4'b0000; // ADD
                    10'b0100000_000: alucontrol = 4'b0001; // SUB
                    10'b0000000_111: alucontrol = 4'b0010; // AND
                    10'b0000000_110: alucontrol = 4'b0011; // OR
                    10'b0000000_100: alucontrol = 4'b0100; // XOR
                    10'b0000000_001: alucontrol = 4'b0101; // SLL
                    10'b0000000_101: alucontrol = 4'b0110; // SRL
                    // RVX10 Custom
                    10'b0000001_000: alucontrol = 4'b0111; // MIN
                    10'b0000001_001: alucontrol = 4'b1000; // MAX
                    default: alucontrol = 4'b0000;
                endcase
            end
            2'b11: begin // I-type arithmetic (addi, andi, ori)
                case (funct3)
                    3'b000: alucontrol = 4'b0000; // ADDI
                    3'b111: alucontrol = 4'b0010; // ANDI
                    3'b110: alucontrol = 4'b0011; // ORI
                    default: alucontrol = 4'b0000;
                endcase
            end
            default: alucontrol = 4'b0000;
        endcase
    end
endmodule
