module hazard_unit(
    input  logic memtoregE,
    input  logic [4:0] rs1D, rs2D, rdE,
    output logic stallF, stallD, flushE
);
    logic lwstall;
    assign lwstall = memtoregE && ((rs1D == rdE) || (rs2D == rdE));
    assign stallF = lwstall;
    assign stallD = lwstall;
    assign flushE = lwstall;
endmodule
