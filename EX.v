module EX(
  input clk,
  input reset_b,

  input [5:0] ID_EX_ALUFun,

  input [4:0] ID_EX_Rs,
  input [4:0] ID_EX_Rt,

  input [31:0] ID_EX_RsData,
  input [31:0] ID_EX_RtData,

  input [4:0] EX_MEM_Rd,
  input [4:0] MEM_WB_Rd,
  input [31:0] EX_MEM_RdData,
  input [31:0] MEM_WB_RdData,


  output reg [] EX_MEM // TODO
  );

  wire [1:0] ForwardA;
  wire [1:0] ForwardB;

  wire [31:0] ALU_A;
  wire [31:0] ALU_B;
  wire [31:0] ALU_Z;
  assign ALU_A = ForwardA == 2'b00 ? ID_EX_RsData : (ForwardA == 2'b10 ? EX_MEM_RdData : MEM_WB_RdData);
  assign ALU_B = ForwardB == 2'b00 ? ID_EX_RtData : (ForwardA == 2'b10 ? EX_MEM_RdData : MEM_WB_RdData);


  Forwarding Forwarding(
    .ID_EX_Rs(ID_EX_Rs),
    .ID_EX_Rt(ID_EX_Rt),
    .EX_MEM_Rd(EX_MEM_Rd),
    .MEM_WB_Rd(MEM_WB_Rd),
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB));

  ALU ALU (
    .A(ALU_A),
    .B(ALU_B),
    .ALUFun(ALUFun),
    .Sign(Sign),
    .Z(Z));

  always @(posedge clk or negedge reset_b) begin
    if (~reset_b) begin
      // TODO
    end
    else begin

    end
  end

endmodule


module Forwarding (
  input [4:0] ID_EX_Rs,
  input [4:0] ID_EX_Rt,
  input [4:0] EX_MEM_Rd,
  input [4:0] MEM_WB_Rd,

  input EX_MEM_RegWrite,
  input MEM_WB_RegWrite,

  output [1:0] ForwardA,
  output [1:0] ForwardB
  );

  reg [1:0] ForwardA;
  reg [1:0] ForwardB;

  always @(*) begin
    if (EX_MEM_RegWrite) begin
      if (ID_EX_Rs == EX_MEM_Rd) ForwardA <= 2'b10;
      else if (ID_EX_Rs == MEM_WB_Rd) ForwardA <= 2'b01;
      else ForwardA <= 2'b01;
    end else ForwardA <= 2'b00;
  end

  always @(*) begin
    if (EX_MEM_RegWrite) begin
      if (ID_EX_Rt == EX_MEM_Rd) ForwardB <= 2'b10;
      else if (ID_EX_Rt == MEM_WB_Rd) ForwardB <= 2'b01;
      else ForwardB <= 2'b01;
    end else ForwardB <= 2'b00;
  end
endmodule
