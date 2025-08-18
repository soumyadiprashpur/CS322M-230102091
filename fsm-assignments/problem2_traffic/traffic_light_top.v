// traffic_light_top.v
`timescale 1ns/1ps
module traffic_light_top #(
    parameter integer CLK_FREQ_HZ = 50_000_000,
    parameter integer TICK_HZ     = 1
)(
    input  wire clk,
    input  wire rst,
    output wire ns_g, ns_y, ns_r,
    output wire ew_g, ew_y, ew_r
);
    wire tick_1hz;

    tick_divider #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ),
        .TICK_HZ(TICK_HZ)
    ) u_div (
        .clk(clk),
        .rst(rst),
        .tick(tick_1hz)
    );

    traffic_light u_tl (
        .clk(clk),
        .rst(rst),
        .tick(tick_1hz),
        .ns_g(ns_g), .ns_y(ns_y), .ns_r(ns_r),
        .ew_g(ew_g), .ew_y(ew_y), .ew_r(ew_r)
    );

endmodule
