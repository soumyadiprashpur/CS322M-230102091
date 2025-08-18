`timescale 1ns/1ps

module slave_fsm(
  input  wire       clk,
  input  wire       rst,   // sync active-high reset
  input  wire       req,
  input  wire [7:0] data_in,
  output reg        ack,
  output reg [7:0]  last_byte
);

  reg [1:0] state;
  reg [1:0] ack_cnt;

  localparam S_WAIT_REQ  = 2'd0,
             S_HOLD_ACK  = 2'd1,
             S_DROP_ACK  = 2'd2;

  always @(posedge clk) begin
    if (rst) begin
      state     <= S_WAIT_REQ;
      ack       <= 0;
      ack_cnt   <= 0;
      last_byte <= 8'h00;
    end else begin
      case (state)
        S_WAIT_REQ: begin
          if (req) begin
            last_byte <= data_in;
            ack       <= 1;
            ack_cnt   <= 0;
            state     <= S_HOLD_ACK;
          end
        end

        S_HOLD_ACK: begin
          ack_cnt <= ack_cnt + 1;
          if (ack_cnt == 1) begin  // 2 cycles total
            state <= S_DROP_ACK;
          end
        end

        S_DROP_ACK: begin
          ack <= 0;
          if (!req) state <= S_WAIT_REQ;
        end
      endcase
    end
  end
endmodule
