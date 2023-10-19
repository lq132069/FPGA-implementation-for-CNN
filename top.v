`timescale 1ns/1ps
`include "convLayerMulti.v"
`include "data_test_ROM.v"
`include "first_img_ROM.v"
`include "conv1_weight_ROM.v"
`include "conv2_weight_ROM.v"
`include "relu.v"
`include "AvgPoolMulti.v"
`include "MaxPoolMulti.v"
`include "conv3_1_weight_ROM.v"
`include "conv3_2_weight_ROM.v"
`include "add.v"
`include "fc_weight_ROM.v"
`include "fc.v"
`include "softmax.v"

module top (
    input clk,
    input rst,
    input start_flag,
    output over_flag,
    output [3:0] out
  );

  parameter data_width = 16;

  /*
  第一层卷积
  */

  wire [1*30*30*data_width-1:0] image;
  wire [2*1*3*3*data_width-1:0] w1;
  wire [2*28*28*data_width-1:0] f1;

  wire conv1_start_flag, conv1_over_flag;
  assign conv1_start_flag = start_flag;

  // 测试数据
  // data_test_ROM  data_test_ROM_inst (
  //                  .clk(clk),
  //                  .rst(rst),
  //                  .start_flag(conv1_start_flag),
  //                  .data(image)
  //                );

  // first_img mnist数据集
  // Shape of the first image data: (900,)
  // Target of the first image data: 6

  first_img_ROM  first_img_ROM_inst (
                   .clk(clk),
                   .rst(rst),
                   .start_flag(conv1_start_flag),
                   .data(image)
                 );

  conv1_weight_ROM  conv1_weight_ROM_inst (
                      .clk(clk),
                      .rst(rst),
                      .start_flag(conv1_start_flag),
                      .data(w1)
                    );

  // 需要28*28*2*1*3*3个操作，但这不代表时钟周期也需要这么多，因为一个时钟周期内有很多操作
  convLayerMulti #(
                   .DATA_WIDTH(data_width),
                   .D(1),
                   .H(30),
                   .W(30),
                   .F(3),
                   .K(2)
                 )
                 convLayerMulti_inst_1
                 (
                   .clk(clk),
                   .reset(rst),
                   .image(image),
                   .filters(w1),
                   .outputConv(f1),
                   .start_flag(conv1_start_flag),
                   .over_flag(conv1_over_flag)
                 );


  wire relu1_start_flag, relu1_over_flag;
  assign relu1_start_flag = conv1_over_flag;

  wire [2*28*28*data_width-1:0] f1_relu;

  // 需要2*28*28个时钟周期，每个时钟周期，依次判断每个数据的正负性
  relu #(
         .DATA_WIDTH(data_width),
         .nofinputs(2*28*28)
       )
       relu_inst_1 (
         .clk(clk),
         .rst(rst),
         .x(f1),
         .x_relu(f1_relu),
         .start_flag(relu1_start_flag),
         .over_flag(relu1_over_flag)
       );

  /*
  第二层卷积
  */

  wire [4*2*5*5*data_width-1:0] w2;
  wire [4*24*24*data_width-1:0] f2;

  wire conv2_start_flag, conv2_over_flag;
  assign conv2_start_flag = relu1_over_flag;

  conv2_weight_ROM  conv2_weight_ROM_inst (
                      .clk(clk),
                      .rst(rst),
                      .start_flag(conv2_start_flag),
                      .data(w2)
                    );

  convLayerMulti #(
                   .DATA_WIDTH(data_width),
                   .D(2),
                   .H(28),
                   .W(28),
                   .F(5),
                   .K(4)
                 )
                 convLayerMulti_inst_2
                 (
                   .clk(clk),
                   .reset(rst),
                   .image(f1),
                   .filters(w2),
                   .outputConv(f2),
                   .start_flag(conv2_start_flag),
                   .over_flag(conv2_over_flag)
                 );

  wire [4*24*24*data_width-1:0] f2_relu;

  wire relu2_start_flag, relu2_over_flag;
  assign relu2_start_flag = conv2_over_flag;
  // 需要4*24*24个时钟周期，每个时钟周期，依次判断每个数据的正负性
  relu #(
         .DATA_WIDTH(data_width),
         .nofinputs(4*24*24)
       )
       relu_inst_2 (
         .clk(clk),
         .rst(rst),
         .x(f2),
         .x_relu(f2_relu),
         .start_flag(relu2_start_flag),
         .over_flag(relu2_over_flag)
       );

  /*
  第三层，池化层，包括最大池化层和平均池化层
  */

  wire [4*12*12*data_width-1:0] f3_avg;

  wire avgpool_start_flag, avgpool_over_flag;
  assign avgpool_start_flag = relu2_over_flag;

  AvgPoolMulti  #(
                  .DATA_WIDTH(data_width),
                  .D(4),
                  .H(24),
                  .W(24)
                )
                AvgPoolMulti_inst (
                  .clk(clk),
                  .rst(rst),
                  .apInput(f2_relu),
                  .apOutput(f3_avg),
                  .start_flag(avgpool_start_flag),
                  .over_flag(avgpool_over_flag)
                );


  wire [4*12*12*data_width-1:0] f3_max;

  wire maxpool_start_flag, maxpool_over_flag;
  assign maxpool_start_flag = relu2_over_flag;

  MaxPoolMulti #(
                 .DATA_WIDTH(data_width),
                 .D(4),
                 .H(24),
                 .W(24)
               )
               MaxPoolMulti_inst (
                 .clk(clk),
                 .rst(rst),
                 .mpInput(f2_relu),
                 .mpOutput(f3_max),
                 .start_flag(maxpool_start_flag),
                 .over_flag(maxpool_over_flag)
               );

  /*
  第四层，卷积层
  */
  // avgPool-->Conv2D

  wire [1*4*3*3*data_width-1:0] w4_1;
  wire [1*10*10*data_width-1:0] f4_1;

  wire conv4_1_start_flag, conv4_1_over_flag;
  assign conv4_1_start_flag = avgpool_over_flag;

  conv3_1_weight_ROM  conv3_1_weight_ROM_inst (
                        .clk(clk),
                        .rst(rst),
                        .start_flag(conv4_1_start_flag),
                        .data(w4_1)
                      );

  convLayerMulti #(
                   .DATA_WIDTH(data_width),
                   .D(4),
                   .H(12),
                   .W(12),
                   .F(3),
                   .K(1)
                 )
                 convLayerMulti_inst_4_1
                 (
                   .clk(clk),
                   .reset(rst),
                   .image(f3_avg),
                   .filters(w4_1),
                   .outputConv(f4_1),
                   .start_flag(conv4_1_start_flag),
                   .over_flag(conv4_1_over_flag)
                 );


  wire relu4_1_start_flag, relu4_1_over_flag;
  assign relu4_1_start_flag = conv4_1_over_flag;

  wire [1*10*10*data_width-1:0] f4_1_relu;

  // 需要1*10*10个时钟周期，每个时钟周期，依次判断每个数据的正负性
  relu #(
         .DATA_WIDTH(data_width),
         .nofinputs(1*10*10)
       )
       relu_inst_4_1 (
         .clk(clk),
         .rst(rst),
         .x(f4_1),
         .x_relu(f4_1_relu),
         .start_flag(relu4_1_start_flag),
         .over_flag(relu4_1_over_flag)
       );


  // maxPool-->Conv2D

  wire [1*4*3*3*data_width-1:0] w4_2;
  wire [1*10*10*data_width-1:0] f4_2;

  wire conv4_2_start_flag, conv4_2_over_flag;
  assign conv4_2_start_flag = maxpool_over_flag;

  conv3_2_weight_ROM  conv3_2_weight_ROM_inst (
                        .clk(clk),
                        .rst(rst),
                        .start_flag(conv4_2_start_flag),
                        .data(w4_2)
                      );

  convLayerMulti #(
                   .DATA_WIDTH(data_width),
                   .D(4),
                   .H(12),
                   .W(12),
                   .F(3),
                   .K(1)
                 )
                 convLayerMulti_inst_4_2
                 (
                   .clk(clk),
                   .reset(rst),
                   .image(f3_max),
                   .filters(w4_2),
                   .outputConv(f4_2),
                   .start_flag(conv4_2_start_flag),
                   .over_flag(conv4_2_over_flag)
                 );


  wire relu4_2_start_flag, relu4_2_over_flag;
  assign relu4_2_start_flag = conv4_2_over_flag;

  wire [1*10*10*data_width-1:0] f4_2_relu;

  // 需要1*10*10个时钟周期，每个时钟周期，依次判断每个数据的正负性
  relu #(
         .DATA_WIDTH(data_width),
         .nofinputs(1*10*10)
       )
       relu_inst_4_2 (
         .clk(clk),
         .rst(rst),
         .x(f4_2),
         .x_relu(f4_2_relu),
         .start_flag(relu4_2_start_flag),
         .over_flag(relu4_2_over_flag)
       );


  /*
  ADD 叠加特征图 f4_add = f4_1_relu + f4_2_relu
  */

  wire [1*10*10*data_width-1:0] f4_add;

  wire f4_add_start_flag, f4_add_over_flag;
  assign f4_add_start_flag = relu4_2_over_flag;

  // add模块不耗费时钟，所以不添加控制信号
  // 后续模块可以用relu4_1_over_flag或relu4_2_over_flag控制
  add #(
        .data_width(data_width),
        .numofinput(1*10*10)
      )
      add_inst_1 (
        .f_1(f4_1_relu),
        .f_2(f4_2_relu),
        .f_add(f4_add)
      );


  /*
   fc层，将100个输入数据与1000个权重数据进行乘法，然后将结果汇总到10个节点中
  */

  wire [100*10*data_width-1:0] w_fc;
  wire [10*data_width-1:0] f_fc;

  wire fc_start_flag, fc_over_flag;
  assign fc_start_flag = relu4_2_over_flag;

  fc_weight_ROM  fc_weight_ROM_inst (
                   .clk(clk),
                   .rst(rst),
                   .start_flag(fc_start_flag),
                   .data(w_fc)
                 );


  fc  #(
        .data_width(data_width),
        .numofinput(100),
        .numofoutput(10)
      )
      fc_inst (
        .clk(clk),
        .rst(rst),
        .i_fc(f4_add),
        .w_fc(w_fc),
        .f_fc(f_fc),
        .start_flag(fc_start_flag),
        .over_flag(fc_over_flag)
      );


  /*
   Softmax层，直接在10个输出结点中找到最大值及其对应的索引
  */

  wire [data_width-1:0] max_value;
  wire  [3:0] max_index;

  wire softmax_start_flag, softmax_over_flag;
  assign softmax_start_flag = fc_over_flag;

  softmax #(
            .data_width(data_width),
            .numofinput(10)
          )
          softmax_inst (
            .clk(clk),
            .rst(rst),
            .f_fc(f_fc),
            .max_value(max_value),
            .max_index(max_index),
            .start_flag(softmax_start_flag),
            .over_flag(softmax_over_flag)
          );

  assign out=max_index;
  assign over_flag = softmax_over_flag;
  
endmodule
