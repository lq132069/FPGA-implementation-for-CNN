`timescale 100 ns / 10 ps
// `include "processingElement.v"

module fcUnit(clk,reset,image,filter,result,over_flag);

  parameter DATA_WIDTH = 16;
  parameter numofinput = 100; //depth of the filter

  input clk, reset;
  input [numofinput*DATA_WIDTH-1:0] image, filter;

  output [DATA_WIDTH-1:0] result;
  output reg over_flag;

  reg [DATA_WIDTH-1:0] selectedInput1, selectedInput2;

  integer i;


  processingElement PE
                    (
                      .clk(clk),
                      .reset(reset),
                      .floatA(selectedInput1),
                      .floatB(selectedInput2),
                      .result(result)
                    );


  // The convolution is calculated in a sequential process to save hardware
  // The result of the element wise matrix multiplication is finished after (F*F+2) cycles (2 cycles to reset the processing element and F*F cycles to accumulate the result of the F*F multiplications)
  always @ (posedge clk or posedge reset)
  begin
    if (reset == 1'b1)
    begin // reset
      i = 0;
      selectedInput1 = 0;
      selectedInput2 = 0;
      over_flag = 0;
    end
    else if (i>numofinput-1)
    begin // if the convolution is finished but we still wait for other blocks to finsih, send zeros to the conv unit (in case of pipelining)
      selectedInput1 <= 0;
      selectedInput2 <= 0;
      if(i>numofinput)
        over_flag=1;
      i=i+1;

    end
    else
    begin // send one element of the image part and one element of the filter to be multiplied and accumulated
      selectedInput1 <= image[DATA_WIDTH*i+:DATA_WIDTH];
      selectedInput2 <= filter[DATA_WIDTH*i+:DATA_WIDTH];
      i = i + 1;
    end
  end

endmodule
