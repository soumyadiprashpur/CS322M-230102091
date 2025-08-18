`timescale 1ns/1ps

module master_fsm(
  input  wire       clk,
  input  wire       rst,   // sync active-high reset
  input  wire       ack,
  output reg        req,
  output reg [7:0]  data,
  output reg        done
);

  reg [1:0] state;
  reg [1:0] byte_cnt;  // 4-byte burst
  reg [7:0] mem [0:3]; // data to send

  localparam S_IDLE       = 2'd0,
             S_WAIT_ACK   = 2'd1,
             S_WAIT_ACK0  = 2'd2,
             S_DONE       = 2'd3;

  always @(posedge clk) begin
    if (rst) begin
      state    <= S_IDLE;
      req      <= 0;
      done     <= 0;
      byte_cnt <= 0;
      // preload data bytes
      mem[0]   <= 8'hA0;
      mem[1]   <= 8'hA1;
      mem[2]   <= 8'hA2;
      mem[3]   <= 8'hA3;
    end else begin
      done <= 0; // default unless DONE state
      case (state)
        S_IDLE: begin
          req   <= 1;
          data  <= mem[byte_cnt];
          state <= S_WAIT_ACK;
        end

        S_WAIT_ACK: begin
          if (ack) begin
            req   <= 0;
            state <= S_WAIT_ACK0;
          end
        end

        S_WAIT_ACK0: begin
          if (!ack) begin
            byte_cnt <= byte_cnt + 1;
            if (byte_cnt == 2'd3) begin
              state <= S_DONE;
            end else begin
              req   <= 1;
              data  <= mem[byte_cnt+1];
              state <= S_WAIT_ACK;
            end
          end
        end

        S_DONE: begin
          done     <= 1;
          byte_cnt <= 0;
          state    <= S_IDLE;
        end
      endcase
    end
  end
endmodule
