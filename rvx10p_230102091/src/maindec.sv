module maindec(
    input  logic [6:0] op,
    output logic memtoreg, memwrite, branch, alusrc, regwrite, jump,
    output logic [1:0] aluop
);
    always_comb begin
        // Default (NOP)
        memtoreg = 0;
        memwrite = 0;
        branch   = 0;
        alusrc   = 0;
        regwrite = 0;
        jump     = 0;
        aluop    = 2'b00;

        case (op)
            7'b0110011: begin // R-type (add, sub, and, or, etc.)
                regwrite = 1;
                aluop = 2'b10;
            end
            7'b0010011: begin // I-type (addi, andi, ori, etc.)
                regwrite = 1;
                alusrc = 1;
                aluop = 2'b11;
            end
            7'b0000011: begin // LW
                memtoreg = 1;
                regwrite = 1;
                alusrc = 1;
                aluop = 2'b00;
            end
            7'b0100011: begin // SW
                memwrite = 1;
                alusrc = 1;
                aluop = 2'b00;
            end
            7'b1100011: begin // BEQ/BNE
                branch = 1;
                aluop = 2'b01;
            end
            7'b1101111: begin // JAL
                jump = 1;
                regwrite = 1;
            end
            default: ; // keep defaults
        endcase
    end
endmodule
