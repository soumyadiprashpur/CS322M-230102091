// tick_divider.v
`timescale 1ns/1ps
module tick_divider #(
    parameter integer CLK_FREQ_HZ = 50_000_000, // fast system clock
    parameter integer TICK_HZ     = 1           // desired tick rate
)(
    input  wire clk,    // fast clock
    input  wire rst,    // synchronous active-high reset
    output wire tick    // 1-cycle pulse at TICK_HZ
);
    // Compile-time sanity check (simulation-time message)
    initial begin
        if (TICK_HZ <= 0)             $error("tick_divider: TICK_HZ must be > 0");
        if (CLK_FREQ_HZ <= 0)         $error("tick_divider: CLK_FREQ_HZ must be > 0");
        if (CLK_FREQ_HZ % TICK_HZ)    $error("tick_divider: CLK_FREQ_HZ must be an integer multiple of TICK_HZ");
    end

    localparam integer TERMINAL = CLK_FREQ_HZ / TICK_HZ; // count 0..TERMINAL-1
    localparam integer CTRW     = (TERMINAL <= 1) ? 1 : $clog2(TERMINAL);

    reg [CTRW-1:0] cnt;

    always @(posedge clk) begin
        if (rst) begin
            cnt <= {CTRW{1'b0}};
        end else if (cnt == TERMINAL - 1) begin
            cnt <= {CTRW{1'b0}};
        end else begin
            cnt <= cnt + {{(CTRW-1){1'b0}}, 1'b1};
        end
    end

    // One-cycle pulse on rollover
    assign tick = (cnt == TERMINAL - 1);

endmodule
