`timescale 1 ns / 10 ps
`include "MaxUnit.v"

module MaxPoolSingle(mPoolIn,mPoolOut);

parameter DATA_WIDTH = 16;
parameter InputH = 28;
parameter InputW = 28;
parameter Depth = 1;

input [InputH*InputW*Depth*DATA_WIDTH-1:0] mPoolIn;
output [(InputH/2)*(InputW/2)*Depth*DATA_WIDTH-1:0] mPoolOut;

genvar i,j;

generate 
  for (i=0; i<(InputH); i=i+2) begin
    for (j=0; j<(InputW); j=j+2) begin
    MaxUnit
    #(
     .DATA_WIDTH(DATA_WIDTH)
     )
     MU
    (
      .numA(mPoolIn[(i*InputH+j)*DATA_WIDTH+:DATA_WIDTH]),
      .numB(mPoolIn[(i*InputH+j+1)*DATA_WIDTH+:DATA_WIDTH]),
      .numC(mPoolIn[((i+1)*InputH+j)*DATA_WIDTH+:DATA_WIDTH]),
      .numD(mPoolIn[((i+1)*InputH+j+1)*DATA_WIDTH+:DATA_WIDTH]),
      .MaxOut(mPoolOut[(i/2*InputH/2+j/2)*DATA_WIDTH+:DATA_WIDTH])
      );
    end
  end
endgenerate

endmodule
      