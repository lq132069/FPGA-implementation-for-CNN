`timescale 100 ns / 10 ps
`include "convLayerSingle.v"

module convLayerMulti(clk,reset,image,filters,outputConv,start_flag, over_flag);

  parameter DATA_WIDTH = 16;
  parameter D = 1; //Depth of image and filter
  parameter H = 30; //Height of image
  parameter W = 30; //Width of image
  parameter F = 3; //Size of filter
  parameter K = 6; //Number of filters applied
  parameter num_Parall = (K>1)?2:1;
  // 卷积步长stride，在convLayerSingle中设置
  // K应该是偶数，因为并行度是K/num_Parall

  input clk, reset;
  input [D*H*W*DATA_WIDTH-1:0] image;
  input [K*D*F*F*DATA_WIDTH-1:0] filters;
  input start_flag;
  output reg over_flag;
  output reg [K*(H-F+1)*(W-F+1)*DATA_WIDTH-1:0] outputConv; //output of the whole module

  reg [num_Parall*D*F*F*DATA_WIDTH-1:0] inputFilters; //the 2 selected filters that are inputs to the 2 instances of conv layer single filter
  wire [num_Parall*(H-F+1)*(W-F+1)*DATA_WIDTH-1:0] outputSingleLayers; //The output of the 2 instances of conv layer single filter

  reg internalReset; // to control the 2 instances of conv layer single filter

  //filterSet: counter to index and select the 2 filters to be sent to the 2 instances of conv layer single filter
  //counter: counts the clock cycles need for the 2 instances of conv layer single filter to finish the convolution process
  // outputCounter: to connect the output of the 2 instances of conv layer single filter to the output of the whole module
  integer filterSet, counter, outputCounter;

  genvar i;

  generate // we generate 2 instances of conv layer single filter
    for (i = 0; i < num_Parall; i = i + 1)
    begin
      convLayerSingle #(
                        .DATA_WIDTH(DATA_WIDTH),
                        .D(D),
                        .H(H),
                        .W(W),
                        .F(F)
                      ) UUT
                      (
                        .clk(clk),
                        .reset(internalReset),
                        .image(image),
                        .filter(inputFilters[i*D*F*F*DATA_WIDTH+:D*F*F*DATA_WIDTH]),
                        .outputConv(outputSingleLayers[i*(H-F+1)*(W-F+1)*DATA_WIDTH+:(H-F+1)*(W-F+1)*DATA_WIDTH])
                      );
    end
  endgenerate
  wire [7:0] control_num; // 控制filter_set
  assign control_num = (K/num_Parall>0)?(K/num_Parall):K;

  always @ (posedge clk or posedge reset)
  begin
    if (reset == 1'b1)
    begin
      internalReset = 1'b1;
      filterSet = 0;
      counter = 0;
      outputCounter = 0;
      over_flag = 0;
    end
    else if(start_flag)
      begin
        // 防止输入通道数
        // if ((filterSet < K/num_P/arall)|(filterSet==0))
        if(filterSet<control_num)
        begin
          if (counter == ((((H-F+1)*(W-F+1))/((H-F+1)/2))*(D*F*F+3)+1)) //这个2，取决于conLayerSingle
          begin
            // the number of clock cycles need for the 2 instances of
            // conv layer single filter to finish the convolution process on the input filters
            outputCounter = outputCounter + 1;
            counter = 0;
            internalReset = 1'b1;
            filterSet = filterSet + 1;
          end
          else
          begin
            internalReset = 0;
            counter = counter + 1;
          end
        end
        if (filterSet == (control_num-1)&&(counter == ((((H-F+1)*(W-F+1))/((H-F+1)/2))*(D*F*F+3)+1)))
          // 卷积运算结束
        begin
          over_flag = 1;
        end
      end
    end


  always @ (*)
  begin
    // connecting the selected filters with the 2 instances of conv layer single filter
    inputFilters = filters[filterSet*num_Parall*D*F*F*DATA_WIDTH+:num_Parall*D*F*F*DATA_WIDTH];
    // connecting the output of the 2 instances of conv layer single filter with the output of the whole module
    outputConv[outputCounter*num_Parall*(H-F+1)*(W-F+1)*DATA_WIDTH+:num_Parall*(H-F+1)*(W-F+1)*DATA_WIDTH] = outputSingleLayers;
  end

endmodule
