module four_bit_equality_comparator(
    input [3:0] A, B,
    output y
);

    assign y = (A==B);

endmodule