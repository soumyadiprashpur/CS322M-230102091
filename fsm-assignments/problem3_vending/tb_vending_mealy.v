`timescale 1ns/1ps
module tb_vending_mealy;

    reg clk, reset;
    reg [1:0] coin;
    wire dispense, chg5;

    // DUT
    vending_mealy dut(
        .clk(clk),
        .reset(reset),
        .coin(coin),
        .dispense(dispense),
        .chg5(chg5)
    );

    // Clock generation: 100MHz (10ns period)
    always #5 clk = ~clk;

    // Task: apply one coin for 1 cycle
    task insert_coin(input [1:0] c);
    begin
        coin = c;
        #10;           // hold for 1 clock
        coin = 2'b00;  // back to idle
        #10;
    end
    endtask

    initial begin
        // waveform dump
        $dumpfile("vending_mealy.vcd");
        $dumpvars(0, tb_vending_mealy);

        // init
        clk = 0; reset = 1; coin = 2'b00;
        #12 reset = 0;

        // ---- Test sequences ----

        // Case 1: 10 + 10 => vend
        insert_coin(2'b10);
        insert_coin(2'b10);

        // Case 2: 5 + 5 + 10 => vend
        insert_coin(2'b01);
        insert_coin(2'b01);
        insert_coin(2'b10);

        // Case 3: 15 (10+5) + 10 => vend + change
        insert_coin(2'b10);
        insert_coin(2'b01);
        insert_coin(2'b10);

        // Case 4: 5+5+5+5 => vend (all 5’s)
        insert_coin(2'b01);
        insert_coin(2'b01);
        insert_coin(2'b01);
        insert_coin(2'b01);

        // Case 5: 10 + 5 + 5 => vend
        insert_coin(2'b10);
        insert_coin(2'b01);
        insert_coin(2'b01);

        // Case 6: 5+5+5+10 => vend + change (25)
        insert_coin(2'b01);
        insert_coin(2'b01);
        insert_coin(2'b01);
        insert_coin(2'b10);

        // Case 7: Two purchases back-to-back
        insert_coin(2'b10);
        insert_coin(2'b10);   // first vend
        insert_coin(2'b01);
        insert_coin(2'b01);
        insert_coin(2'b10);   // second vend

        // Case 8: Random idle cycles between coins
        insert_coin(2'b10);
        #40;                  // wait idle
        insert_coin(2'b10);   // vend after gap

        // finish
        #100 $finish;
    end

endmodule
