// tb_traffic_light.v
`timescale 1ns/1ps
module tb_traffic_light;
    // 50 MHz clock for example (20 ns period)
    reg clk, rst, tick;
    wire ns_g, ns_y, ns_r, ew_g, ew_y, ew_r;

    // DUT
    traffic_light dut(
        .clk(clk), .rst(rst), .tick(tick),
        .ns_g(ns_g), .ns_y(ns_y), .ns_r(ns_r),
        .ew_g(ew_g), .ew_y(ew_y), .ew_r(ew_r)
    );

    // Clock generation
    initial clk = 1'b0;
    always #10 clk = ~clk; // 50 MHz

    // Fast simulation tick: one-cycle pulse every N clock cycles
    localparam integer SIM_TICK_N = 20; // -> 1 tick every 20 clk cycles
    reg [31:0] cyc;

    always @(posedge clk) begin
        if (rst) begin
            cyc  <= 0;
            tick <= 1'b0;
        end else begin
            tick <= (cyc == 0);                        // 1-cycle pulse
            cyc  <= (cyc == SIM_TICK_N-1) ? 0 : (cyc + 1);
        end
    end

    // Stimulus
    initial begin
        rst = 1'b1;
        tick = 1'b0;
        cyc  = 0;

        // VCD for GTKWave
        $dumpfile("traffic_light.vcd");
        $dumpvars(0, tb_traffic_light);

        repeat (5) @(posedge clk);
        rst = 1'b0;

        // Run long enough to see several full 5/2/5/2 cycles
        // One full cycle = 14 ticks; here run ~60 ticks
        repeat (60 * SIM_TICK_N) @(posedge clk);

        $finish;
    end
endmodule
