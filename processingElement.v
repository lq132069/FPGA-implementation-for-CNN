`timescale 100 ns / 10 ps

// `include "floatMult.v"
// `include "floatAdd.v"

module processingElement(clk,reset,floatA,floatB,result);

  parameter DATA_WIDTH = 16;

  input clk, reset;
  input signed [DATA_WIDTH-1:0] floatA, floatB;
  output [DATA_WIDTH-1:0] result;

  reg signed [2*DATA_WIDTH-1:0] multiply;
  reg signed[2*DATA_WIDTH-1:0] accumulate;


  always @(posedge clk or posedge reset)
  begin
    if (reset)
    begin
      multiply<=0;
      accumulate<=0;
    end
    else
    begin
      multiply=floatA*floatB;
      accumulate=multiply+accumulate;
    end
  end
  assign result = accumulate>>8;//[8+DATA_WIDTH-1:8]; //右移8位，因为输入权重数据是8bit定点数据

endmodule
