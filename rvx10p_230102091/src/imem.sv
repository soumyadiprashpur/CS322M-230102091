module imem(input  logic [7:0]  a,
            output logic [31:0] rd);
    logic [31:0] mem [0:255];

    initial begin
        $readmemh("tests/rvx10_pipeline.hex", mem);
        $display("Instruction memory loaded.");
    end

    assign rd = mem[a];
endmodule
