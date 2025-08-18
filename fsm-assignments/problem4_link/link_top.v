`timescale 1ns/1ps

module link_top(
  input  wire clk,
  input  wire rst,
  output wire done
);

  wire       req_sig, ack_sig;
  wire [7:0] data_sig;
  wire [7:0] last_byte_sig; // can probe for TB

  master_fsm u_master (
    .clk(clk),
    .rst(rst),
    .ack(ack_sig),
    .req(req_sig),
    .data(data_sig),
    .done(done)
  );

  slave_fsm u_slave (
    .clk(clk),
    .rst(rst),
    .req(req_sig),
    .data_in(data_sig),
    .ack(ack_sig),
    .last_byte(last_byte_sig)
  );

endmodule
