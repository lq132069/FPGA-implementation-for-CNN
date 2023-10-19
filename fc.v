`include "fcUnit.v"

module fc (
    input clk,
    input rst,
    input [numofinput*data_width-1:0] i_fc,
    input [numofinput*numofoutput*data_width-1:0] w_fc,
    output [numofoutput*data_width-1:0] f_fc,
    input start_flag,
    output over_flag
  );
  parameter data_width = 16;
  parameter numofinput = 100;
  parameter numofoutput = 10;


  reg inner_rst; //控制fcUnit

  always @(posedge clk or posedge rst)
  begin
    if(rst)
    begin
      inner_rst = 1;
    end
    else if(start_flag)
    begin
      inner_rst = 0;
    end
  end

  genvar n;

  generate
    for (n = 0; n < numofoutput ; n = n + 1)
    begin
      fcUnit
        #(
          .DATA_WIDTH(data_width),
          .numofinput(numofinput)
        ) FU
        (
          .clk(clk),
          .reset(inner_rst),
          .image(i_fc),
          .filter(w_fc[n*numofinput*data_width+:numofinput*data_width]),
          .result(f_fc[n*data_width+:data_width]),
          .over_flag(over_flag)
        );
    end
  endgenerate



endmodule
