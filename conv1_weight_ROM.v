/*
该模块首先将coe文件中的数据存储到ROM中。
每给一个地址，会在下个时钟上升沿输出相应的数据
*/

module conv1_weight_ROM (
    input clk,
    input rst,
    input start_flag,
    output reg [address_width*data_width-1:0] data
  );

  parameter address_width = 18; // 设置地址位宽，足够存储54个conv_weight数据
  parameter data_width = 16;    // 设置数据位宽

  reg [data_width-1:0] rom_data [0:address_width-1];

  // 在这里加载数据
  initial
  begin
    $readmemh("data/conv1_weight16.coe", rom_data);
  end


  // 访问ROM并输出数据
  reg [7:0] address; // 内部地址变量
  always @(posedge clk or posedge rst)
  begin
    if (rst)
    begin
      data <= 0; // 在复位时将输出清零
    end
    else if(start_flag)
    begin
      // 从ROM中读取数据并拼接
      data <=
      {
       rom_data[17], rom_data[16],
       rom_data[15], rom_data[14], rom_data[13], rom_data[12],
       rom_data[11], rom_data[10], rom_data[9], rom_data[8],
       rom_data[7], rom_data[6], rom_data[5], rom_data[4],
       rom_data[3], rom_data[2], rom_data[1], rom_data[0]};
    end
  end

endmodule



