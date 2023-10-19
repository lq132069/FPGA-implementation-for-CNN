`timescale 1 ns / 10 ps
`include "AvgPoolSingle.v"


module AvgPoolMulti(
    input clk,
    input rst,
    input [H*W*D*DATA_WIDTH-1:0] apInput,
    output reg [(H/2)*(W/2)*D*DATA_WIDTH-1:0] apOutput,
    input start_flag,
    output reg over_flag
  );

  parameter DATA_WIDTH = 16;
  parameter D = 6;
  parameter H = 28;
  parameter W = 28;

  reg [H*W*DATA_WIDTH-1:0] apInput_s;
  wire [(H/2)*(W/2)*DATA_WIDTH-1:0] apOutput_s;
  integer counter;


  avgPoolSingle
    #(
      .DATA_WIDTH(DATA_WIDTH),
      .InputH(H),
      .InputW(W)
    ) avgPool
    (
      .aPoolIn(apInput_s),
      .aPoolOut(apOutput_s)
    );

  always @ (posedge clk or posedge rst)
  begin
    if (rst == 1'b1)
    begin
      counter = 0;
      over_flag = 0;
    end
    else if(start_flag)
    begin
      if (counter<D)
      begin
        counter = counter+1;
      end
    end
    if(counter==D)
      over_flag = 1;
  end

  always @ (*)
  begin
    apInput_s = apInput[counter*H*W*DATA_WIDTH+:H*W*DATA_WIDTH];
    apOutput[counter*(H/2)*(W/2)*DATA_WIDTH+:(H/2)*(W/2)*DATA_WIDTH] = apOutput_s;
  end

endmodule
