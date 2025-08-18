// traffic_light.v
`timescale 1ns/1ps
module traffic_light #(
    // Phase durations in *ticks* (not clock cycles)
    parameter integer NS_G_TICKS = 5,
    parameter integer NS_Y_TICKS = 2,
    parameter integer EW_G_TICKS = 5,
    parameter integer EW_Y_TICKS = 2
)(
    input  wire clk,
    input  wire rst,   // synchronous active-high
    input  wire tick,  // 1-cycle pulse at tick rate
    output wire ns_g, ns_y, ns_r,
    output wire ew_g, ew_y, ew_r
);

    // ------------------------
    // States (Moore)
    // ------------------------
    reg [1:0] state_present, state_next;

    parameter NS_G = 2'b00; // NS Green, EW Red
    parameter NS_Y = 2'b01; // NS Yellow, EW Red
    parameter EW_G = 2'b10; // EW Green, NS Red
    parameter EW_Y = 2'b11; // EW Yellow, NS Red

    // ------------------------
    // Phase counter (counts ticks within the phase)
    // ------------------------
    function integer max2;
        input integer a, b;
        begin max2 = (a > b) ? a : b; end
    endfunction
    localparam integer MAX_TICKS = max2(max2(NS_G_TICKS, NS_Y_TICKS), max2(EW_G_TICKS, EW_Y_TICKS));
    localparam integer PCW       = (MAX_TICKS <= 1) ? 1 : $clog2(MAX_TICKS);
    reg [PCW-1:0] phase_count;

    // ------------------------
    // State register + phase counter (advance only on tick)
    // ------------------------
    always @(posedge clk) begin
        if (rst) begin
            state_present <= NS_G;
            phase_count   <= {PCW{1'b0}};
        end else if (tick) begin
            // When current phase duration expires, move to next phase and reset phase_count
            if ((state_present == NS_G && phase_count == NS_G_TICKS - 1) ||
                (state_present == NS_Y && phase_count == NS_Y_TICKS - 1) ||
                (state_present == EW_G && phase_count == EW_G_TICKS - 1) ||
                (state_present == EW_Y && phase_count == EW_Y_TICKS - 1)) begin
                state_present <= state_next;
                phase_count   <= {PCW{1'b0}};
            end else begin
                phase_count <= phase_count + {{(PCW-1){1'b0}}, 1'b1};
            end
        end
    end

    // ------------------------
    // Next state logic
    // ------------------------
    always @(*) begin
        case (state_present)
            NS_G: state_next = NS_Y;
            NS_Y: state_next = EW_G;
            EW_G: state_next = EW_Y;
            EW_Y: state_next = NS_G;
            default: state_next = NS_G;
        endcase
    end

    // ------------------------
    // Moore outputs (exactly one of g/y/r per road)
    // ------------------------
    assign ns_g = (state_present == NS_G);
    assign ns_y = (state_present == NS_Y);
    assign ns_r = (state_present == EW_G) || (state_present == EW_Y);

    assign ew_g = (state_present == EW_G);
    assign ew_y = (state_present == EW_Y);
    assign ew_r = (state_present == NS_G) || (state_present == NS_Y);

endmodule
