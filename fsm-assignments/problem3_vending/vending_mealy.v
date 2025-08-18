module vending_mealy (
    input clk,
    input reset,          // synchronous active-high reset
    input [1:0] coin,     // 01=5, 10=10, 00=idle (ignore 11)
    output dispense,      // 1-cycle pulse
    output chg5           // 1-cycle pulse when returning 5
);

    // State encoding
    reg [1:0] state_present, state_next;

    parameter s0  = 2'b00;   // total = 0
    parameter s5  = 2'b01;   // total = 5
    parameter s10 = 2'b10;   // total = 10
    parameter s15 = 2'b11;   // total = 15

    // Mealy combinational outputs
    reg dispense_mealy, chg5_mealy;

    // Registered outputs (guaranteed 1 cycle)
    reg dispense_ff = 0, chg5_ff = 0;  

    // State register (synchronous reset)
    always @(posedge clk) begin
        if (reset)
            state_present <= s0;
        else
            state_present <= state_next;
    end

    // Next state + Mealy outputs (combinational)
    always @(*) begin
        // default values
        state_next     = state_present;
        dispense_mealy = 0;
        chg5_mealy     = 0;

        case (state_present)
            s0: begin
                if (coin == 2'b01)       state_next = s5;
                else if (coin == 2'b10)  state_next = s10;
            end

            s5: begin
                if (coin == 2'b01)       state_next = s10;
                else if (coin == 2'b10)  state_next = s15;
            end

            s10: begin
                if (coin == 2'b01)       state_next = s15;
                else if (coin == 2'b10) begin
                    dispense_mealy = 1;   // vend
                    state_next     = s0;  // reset
                end
            end

            s15: begin
                if (coin == 2'b01) begin
                    dispense_mealy = 1;   // vend
                    state_next     = s0;
                end
                else if (coin == 2'b10) begin
                    dispense_mealy = 1;   // vend
                    chg5_mealy     = 1;   // change
                    state_next     = s0;
                end
            end

            default: state_next = s0;
        endcase
    end

    // Register the Mealy outputs -> guarantees 1-cycle pulses
    always @(posedge clk) begin
        if (reset) begin
            dispense_ff <= 0;
            chg5_ff     <= 0;
        end else begin
            dispense_ff <= dispense_mealy;
            chg5_ff     <= chg5_mealy;
        end
    end

    // Continuous assignment for final outputs
    assign dispense = dispense_ff;
    assign chg5     = chg5_ff;

endmodule
