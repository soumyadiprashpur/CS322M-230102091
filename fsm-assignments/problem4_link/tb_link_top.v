`timescale 1ns/1ps
module tb_link_top;

  reg clk, rst;
  wire done;

  // DUT
  link_top dut (
    .clk(clk),
    .rst(rst),
    .done(done)
  );

  // Clock generator: 10 ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset generator
  initial begin
    rst = 1;
    #20;         // keep reset high for 20ns
    rst = 0;     // release reset
  end

  // Monitor signals (hierarchical references to FSMs)
  initial begin
    $dumpfile("handshake.vcd");    // for GTKWave
    $dumpvars(0, tb_link_top);

    $display(" Time | clk rst | req ack | data  last  | done");
    $monitor("%4t |  %b   %b  |  %b   %b  |  %h   %h  |  %b",
             $time, clk, rst,
             dut.u_master.req,
             dut.u_slave.ack,
             dut.u_master.data,
             dut.u_slave.last_byte,
             done);

    // Run until done goes high
    wait(done == 1);
    #20;  // observe done pulse
    $finish;
  end

endmodule
