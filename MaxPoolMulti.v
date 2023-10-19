`timescale 1 ns / 10 ps
`include "MaxPoolSingle.v"

module MaxPoolMulti(
    input clk,
    input rst,
    input [H*W*D*DATA_WIDTH-1:0] mpInput,
    output reg [(H/2)*(W/2)*D*DATA_WIDTH-1:0] mpOutput,
    input start_flag,
    output reg over_flag
  );

  parameter DATA_WIDTH = 16;
  parameter D = 6;
  parameter H = 28;
  parameter W = 28;

  reg [H*W*DATA_WIDTH-1:0] mpInput_s;
  wire [(H/2)*(W/2)*DATA_WIDTH-1:0] mpOutput_s;
  integer counter;


  MaxPoolSingle
    #(
      .DATA_WIDTH(DATA_WIDTH),
      .InputH(H),
      .InputW(W)
    ) MaxPool
    (
      .mPoolIn(mpInput_s),
      .mPoolOut(mpOutput_s)
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
    mpInput_s = mpInput[counter*H*W*DATA_WIDTH+:H*W*DATA_WIDTH];
    mpOutput[counter*(H/2)*(W/2)*DATA_WIDTH+:(H/2)*(W/2)*DATA_WIDTH] = mpOutput_s;
  end

endmodule
