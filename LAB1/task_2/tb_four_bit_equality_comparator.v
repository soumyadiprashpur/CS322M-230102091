`timescale 1ns/1ps

module tb_four_bit_equality_comparator;

    reg [3:0] A, B;
    wire y;

    four_bit_equality_comparator uut (
        .A(A),
        .B(B),
        .y(y)
    );

    initial begin
        $dumpfile("four_bit_equality_comparator.vcd");
        $dumpvars(0, tb_four_bit_equality_comparator);

        // equal
        A = 4'b0000; B = 4'b0000; #10;
        A = 4'b1010; B = 4'b1010; #10;
        A = 4'b1111; B = 4'b1111; #10;

        // not equal
        A = 4'b0001; B = 4'b0010; #10;
        A = 4'b0101; B = 4'b0110; #10;
        A = 4'b1110; B = 4'b1101; #10;

        $finish;
    end

endmodule