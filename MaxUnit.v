`timescale 1 ns / 10 ps

module MaxUnit (
    input  signed [DATA_WIDTH-1:0] numA,numB,numC,numD,
    output  [DATA_WIDTH-1:0] MaxOut
  );

  parameter DATA_WIDTH = 16;
  reg signed [DATA_WIDTH-1:0] MaxOut_temp;
  assign MaxOut = MaxOut_temp;
  always @(*)
  begin
    MaxOut_temp = numA; // 假设numA是最大的

    if (numB > MaxOut_temp)
    begin
      MaxOut_temp = numB; // 如果numB比MaxOut大，更新MaxOut
    end

    if (numC > MaxOut_temp)
    begin
      MaxOut_temp = numC; // 如果numC比MaxOut大，更新MaxOut
    end

    if (numD > MaxOut_temp)
    begin
      MaxOut_temp = numD; // 如果numD比MaxOut大，更新MaxOut
    end
  end

endmodule
