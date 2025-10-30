module riscvpipeline (
    input  logic clk,
    input  logic reset
);
    // Instruction and data memory
    logic [31:0] instr, read_data;
    logic [31:0] pcF;
    logic memwriteM;
    logic [31:0] alu_outM, writedataM;

    // Instantiate datapath and controller
    logic memtoregD, memtoregE, memtoregM, memtoregW;
    logic memwriteD, memwriteE, regwriteD, regwriteE, regwriteM, regwriteW;
    logic alusrcD, alusrcE, branchD, branchE, jumpD, jumpE;
    logic [3:0] alucontrolD, alucontrolE;

    controller c(
        .op(instr[6:0]),
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),
        .memtoreg(memtoregD),
        .memwrite(memwriteD),
        .branch(branchD),
        .alusrc(alusrcD),
        .regwrite(regwriteD),
        .jump(jumpD),
        .alucontrol(alucontrolD)
    );

    datapath dp(
        .clk(clk),
        .reset(reset),
        .memtoregD(memtoregD),
        .memwriteD(memwriteD),
        .branchD(branchD),
        .alusrcD(alusrcD),
        .regwriteD(regwriteD),
        .jumpD(jumpD),
        .alucontrolD(alucontrolD),
        .instr(instr),
        .readdataM(read_data),
        .memwriteM(memwriteM),
        .aluoutM(alu_outM),
        .writedataM(writedataM),
        .pcF(pcF)
    );

    // Instruction Memory (example behavioral)
    imem imem_inst (.a(pcF[9:2]), .rd(instr));

    // Data Memory
    dmem dmem_inst (.clk(clk), .we(memwriteM),
                    .a(alu_outM), .wd(writedataM), .rd(read_data));
endmodule
