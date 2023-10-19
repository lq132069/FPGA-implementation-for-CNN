`timescale 1 ns / 10 ps

module AvgUnit (numA,numB,numC,numD,AvgOut);
  
parameter DATA_WIDTH = 16;

input  signed [DATA_WIDTH-1:0] numA,numB,numC,numD;
output signed [DATA_WIDTH-1:0] AvgOut;

wire signed [2*DATA_WIDTH-1:0] add1result;
wire signed [2*DATA_WIDTH-1:0] add2result;
wire signed [2*DATA_WIDTH-1:0] add3result;


assign add1result = numA + numB;
assign add2result = add1result + numC;
assign add3result = add2result + numD;
assign AvgOut = add3result >> 2; //除以4

endmodule