`timescale 1 ns / 1 ps
`include "top.v"
module top_tb;

  // Parameters

  //Ports
  reg  clk;
  reg  rst;
  reg  start_flag;
  wire  over_flag;
  wire  [3:0] out;

  top  top_inst (
         .clk(clk),
         .rst(rst),
         .start_flag(start_flag),
         .over_flag(over_flag),
         .out(out)
       );

  localparam PERIOD = 20;

  always
    #(PERIOD/2) clk = ~clk;

  initial
  begin
    #0
     clk = 1'b0;
    rst = 1;
    start_flag = 0;
    
    #(PERIOD)
     start_flag = 1;
    rst = 0;

  end

  initial
  begin
    $dumpfile("top.vcd");
    $dumpvars(0,top_tb);
    #(8*1457*PERIOD)
    $displayh(out);
     $finish;
  end
endmodule
