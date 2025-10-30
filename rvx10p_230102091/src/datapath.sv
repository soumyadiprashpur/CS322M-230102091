module datapath(
    input  logic clk, reset,
    input  logic memtoregD, memwriteD, branchD, alusrcD, regwriteD, jumpD,
    input  logic [3:0] alucontrolD,
    input  logic [31:0] instr, readdataM,
    output logic memwriteM,
    output logic [31:0] aluoutM, writedataM, pcF
);
    // --- IF stage ---
    logic [31:0] pcnext, pcplus4;
    logic [31:0] instrD;
    assign pcplus4 = pcF + 4;

    always_ff @(posedge clk or posedge reset)
        if (reset) pcF <= 0;
        else pcF <= pcnext;

    // IF/ID
    always_ff @(posedge clk) instrD <= instr;

    // --- ID stage ---
    logic [31:0] rd1D, rd2D, immD;
    logic [4:0] rs1D, rs2D, rdD;
    assign rs1D = instrD[19:15];
    assign rs2D = instrD[24:20];
    assign rdD  = instrD[11:7];

    regfile rf (.clk(clk), .we3(regwriteD),
                .a1(rs1D), .a2(rs2D), .a3(rdD),
                .wd3(32'b0), // simplified
                .rd1(rd1D), .rd2(rd2D));

    assign immD = {{20{instrD[31]}}, instrD[31:20]}; // simple imm

    // --- EX stage ---
    logic [31:0] srcA, srcB, aluoutE;
    logic zero;
    assign srcA = rd1D;
    assign srcB = (alusrcD) ? immD : rd2D;

    alu alu_inst (.a(srcA), .b(srcB), .alucontrol(alucontrolD), .result(aluoutE), .zero(zero));

    // --- MEM stage ---
    assign aluoutM = aluoutE;
    assign writedataM = rd2D;
    assign memwriteM = memwriteD;

    // --- WB stage (skipped for simplicity) ---
    assign pcnext = pcplus4; // no branch yet
endmodule
