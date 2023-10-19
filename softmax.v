
module softmax (
    input clk,
    input rst,
    input [numofinput*data_width-1:0] f_fc,
    output wire [data_width-1:0] max_value,
    output wire  [3:0] max_index,
    input start_flag,
    output reg over_flag
  );

  parameter data_width = 16;
  parameter numofinput = 10;

  reg signed [data_width-1:0] max_val,max_val2; // 存储最大值
  reg [3:0] max_idx; // 存储最大值的索引
  reg signed [data_width-1:0] current_value;
  integer i;

  always @(posedge clk or posedge rst)
  begin
    if(rst)
    begin
      max_val = 0;
      max_idx = 0;
      over_flag = 0;
    end
    else if(start_flag)
    begin
      max_val = f_fc[0*data_width+:data_width];
      max_idx = 4'b0000;

      for (i = 1; i < 10; i = i + 1)
      begin
        current_value = f_fc[i*data_width+:data_width];
        if (current_value > max_val)
        begin
          max_val = current_value;
          max_idx = i;
        end
      end

      if(i==10)
        over_flag = 1;
        
    end
  end


  assign max_value = max_val;
  assign max_index = max_idx;

endmodule
