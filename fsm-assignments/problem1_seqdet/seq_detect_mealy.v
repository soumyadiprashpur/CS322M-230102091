module seq_detect_mealy (
  input  clk,
  input  rst,    // synchronous, active-high
  input  din,    // serial input bit per clock
  output y       // 1-cycle pulse when pattern ...1101 seen
);

  reg [1:0] state_present, state_next;

  // State encoding
  parameter init    = 2'b00;
  parameter got_1   = 2'b01;
  parameter got_11  = 2'b10;
  parameter got_110 = 2'b11;

  // State register (synchronous reset)
  always @ (posedge clk) begin
    if (rst) state_present <= init;       // sync active-high reset
    else     state_present <= state_next; // move to next state
  end

  // Next-state logic
  always @ (*) begin
    case (state_present)
      init:    state_next = din ? got_1   : init;
      got_1:   state_next = din ? got_11  : init;
      got_11:  state_next = din ? got_11  : got_110;
      got_110: state_next = din ? got_1   : init; // detection → fallback to got_1 for overlap
      default: state_next = init; // safety default
    endcase
  end

  // Output logic (Mealy: depends on present state + input)
  assign y = (state_present == got_110) && din;

endmodule
