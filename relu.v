
module relu(
    input clk,
    input rst,
    input signed [nofinputs*DATA_WIDTH-1:0] x,
    output reg [nofinputs*DATA_WIDTH-1:0] x_relu,
    input start_flag,
    output reg over_flag
);
  parameter DATA_WIDTH=16;
  parameter nofinputs=7;// deterimining the no of inputs entering the function


  wire [DATA_WIDTH-1:0]OutputTemp;
  wire [DATA_WIDTH-1:0]x_temp;

  wire Finished;
  integer i,j;

  assign x_temp = x[DATA_WIDTH*i+:DATA_WIDTH];
  assign OutputTemp = (x_temp[15]==0) ? x_temp : 16'h0000; //Relu操作

  always @(posedge clk) begin //计算负数个数
    if(x_temp[15]==1)
    j=j+1;
  end
  always@(posedge clk)
  begin
    // if the external reset =1 then make everything to 0
    if(rst)
    begin
      i=0;
      j=0;
      over_flag=0;
    end
    //checking if the tanh is not finished so continue your operation and low down the reset to continue
    else if(start_flag)
    begin
        x_relu[DATA_WIDTH*i+:DATA_WIDTH]=OutputTemp;
        i=i+1;
      end
      // check if all the inputs are finished then the layer is OK
      if(i==nofinputs)
      begin
        over_flag=1;
      end
    end

endmodule
