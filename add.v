// 拼接模块
module add (
  input wire [numofinput*data_width-1:0] f_1,
  input wire [numofinput*data_width-1:0] f_2,
  output reg [numofinput*data_width-1:0] f_add
);

parameter data_width = 16;
parameter numofinput = 100;
reg signed [data_width-1:0] temp;
integer i;

reg signed [data_width-1:0] val1,val2; // 存储最大值

always @(*)
begin
  for (i = 0; i < numofinput; i = i + 1)
  begin
    val1 = f_1[i*data_width +: data_width];
    val2 = f_2[i*data_width +: data_width];
    temp = val1 + val2;
    f_add[i*data_width +: data_width] = temp;
  end
end

endmodule
