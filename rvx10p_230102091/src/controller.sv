module controller(
    input  logic [6:0] op,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic memtoreg, memwrite, branch, alusrc, regwrite, jump,
    output logic [3:0] alucontrol
);
    logic [1:0] aluop;

    maindec md(op, memtoreg, memwrite, branch, alusrc, regwrite, jump, aluop);
    aludec ad(funct3, funct7, aluop, alucontrol);
endmodule
