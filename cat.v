// 拼接模块
module cat (
  input wire [numofinput*data_width-1:0] f4_1,
  input wire [numofinput*data_width-1:0] f4_2,
  output wire [2*numofinput*data_width-1:0] f4_cat
);

parameter data_width = 16;
parameter numofinput = 100;
assign f4_cat = {f4_1,f4_2};

endmodule
