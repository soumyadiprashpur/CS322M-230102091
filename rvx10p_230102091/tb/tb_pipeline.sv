module tb_pipeline;
    logic clk = 0, reset = 1;
    riscvpipeline dut (.clk(clk), .reset(reset));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_pipeline);
        #20 reset = 0;
        #2000 $finish;
    end
endmodule
