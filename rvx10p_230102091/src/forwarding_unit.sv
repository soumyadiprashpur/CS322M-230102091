module forwarding_unit(
    input  logic [4:0] rs1E, rs2E, rdM, rdW,
    input  logic regwriteM, regwriteW,
    output logic [1:0] forwardAE, forwardBE
);
    always_comb begin
        forwardAE = 2'b00;
        forwardBE = 2'b00;
        if (regwriteM && (rdM != 0) && (rdM == rs1E)) forwardAE = 2'b10;
        if (regwriteM && (rdM != 0) && (rdM == rs2E)) forwardBE = 2'b10;
        if (regwriteW && (rdW != 0) && (rdW == rs1E)) forwardAE = 2'b01;
        if (regwriteW && (rdW != 0) && (rdW == rs2E)) forwardBE = 2'b01;
    end
endmodule
