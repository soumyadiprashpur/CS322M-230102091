module alu(
    input  logic [31:0] a, b,
    input  logic [3:0] alucontrol,
    output logic [31:0] result,
    output logic zero
);
    always_comb begin
        case (alucontrol)
            4'b0000: result = a + b;   // ADD
            4'b0001: result = a - b;   // SUB
            4'b0010: result = a & b;   // AND
            4'b0011: result = a | b;   // OR
            4'b0100: result = a ^ b;   // XOR
            4'b0101: result = a << b[4:0]; // SLL
            4'b0110: result = a >> b[4:0]; // SRL
            4'b0111: result = ($signed(a) < $signed(b)) ? a : b; // MIN (RVX10)
            4'b1000: result = (a < b) ? b : a; // MAX (RVX10)
            default: result = 32'b0;
        endcase
        zero = (result == 0);
    end
endmodule
