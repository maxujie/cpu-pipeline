module EX(
  input clk,
  input reset_b,

  input [4:0] Rs,
  input [4:0] Rt,
  input [4:0] Rd,
  input [31:0] RsData,
  input [31:0] RtData,
  input [4:0] Shamt,
  input [31:0] Imm32,

  input ALUSrc1,
  input ALUSrc2,
  input [5:0] ALUFun,
  input Sign,

  input Branch,

  input MemRead,
  input MemWrite,
  input RegWrite,
  input [1:0] MemToReg,
  input LUOp,
  input [31:0] LUData,
  input [31:0] PC_Plus4,
  input [1:0] RegDst,

  input [4:0] EX_MEM_Rd,
  input [4:0] MEM_WB_Rd,
  input [31:0] EX_MEM_RdData,
  input [31:0] MEM_WB_RdData,
  input EX_MEM_RegWrite,
  input MEM_WB_RegWrite,
  input [4:0] MEM_WB_WriteReg,
  input [31:0] MEM_WB_RegWriteData,
  input IRQ_BACKUP,
  input IRQ_RECOVERY,

  output PCSrcB,
  output reg [138:0] EX_MEM);

  reg [138:0] EX_MEM_BACKUP;

  wire [1:0] ForwardA;
  wire [1:0] ForwardB;

  Forwarding Forwarding(
  .ID_EX_Rs(Rs),
  .ID_EX_Rt(Rt),
  .EX_MEM_Rd(EX_MEM_Rd),
  .MEM_WB_Rd(MEM_WB_Rd),
  .EX_MEM_RegWrite(EX_MEM_RegWrite),
  .MEM_WB_RegWrite(MEM_WB_RegWrite),
  .ForwardA(ForwardA),
  .ForwardB(ForwardB));

  wire [31:0] RsDataTrue;
  wire [31:0] RtDataTrue;

  assign RsDataTrue = ForwardA == 2'b00 ? RsData : (ForwardA == 2'b10 ? EX_MEM_RdData : MEM_WB_RdData);
  assign RtDataTrue = ForwardB == 2'b00 ? RtData : (ForwardB == 2'b10 ? EX_MEM_RdData : MEM_WB_RdData);

  wire [31:0] ALU_A;
  wire [31:0] ALU_B;
  wire [31:0] ALU_S;

  assign ALU_A = ALUSrc1 ? {27'b0, Shamt} : RsDataTrue;
  assign ALU_B = ALUSrc2 ? Imm32 : RtDataTrue;

  ALU ALU (
    .A(ALU_A),
    .B(ALU_B),
    .ALUFunc(ALUFun),
    .Signed(Sign),
    .S(ALU_S));

  wire [31:0] MemWriteData;
  wire [4:0] WriteReg;
  assign MemWriteData = RtDataTrue[31:0];
  assign WriteReg = RegDst == 2'b00 ? Rd[4:0] :
  RegDst == 2'b01 ? Rt[4:0] :
  RegDst == 2'b10 ? 5'd31 :
  RegDst == 2'b11 ? 5'd26 : 5'd0;  // Exception

  assign PCSrcB = (Branch && ALU_S[0] == 1'b1) ? 1'b1 : 1'b0;  // branch


  always @(posedge clk or negedge reset_b) begin
    if (~reset_b) begin
      EX_MEM <= 0;
    end
    else if (IRQ_RECOVERY) EX_MEM <= EX_MEM_BACKUP;
    else if (IRQ_BACKUP) begin
        EX_MEM_BACKUP <= EX_MEM;
        EX_MEM[138:0] <= 0;
    end
    else begin
      EX_MEM[31:0] <= MemWriteData;  // MEM
      EX_MEM[63:32] <= ALU_S;  // MEM WB
      EX_MEM[68:64] <= WriteReg;  // WB
      EX_MEM[70:69] <= PCSrcB ? 2'b0 : {MemWrite, MemRead};     // MEM
      EX_MEM[73:71] <= PCSrcB ? 3'b0 : {MemToReg, RegWrite};    // WB
      EX_MEM[105:74] <= PC_Plus4; // jal
      EX_MEM[138:106] <= {LUOp, LUData[31:0]}; // WB
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

  output reg [1:0] ForwardA,
  output reg [1:0] ForwardB
  );

  always @(*) begin
    if (EX_MEM_RegWrite && ID_EX_Rs == EX_MEM_Rd && EX_MEM_Rd != 5'd0) ForwardA <= 2'b10;
    else if (MEM_WB_RegWrite && ID_EX_Rs == MEM_WB_Rd && MEM_WB_Rd != 5'd0) ForwardA <= 2'b01;
    else ForwardA <= 2'b00;
  end

  always @(*) begin
    if (EX_MEM_RegWrite && ID_EX_Rt == EX_MEM_Rd && EX_MEM_Rd != 5'd0) ForwardB <= 2'b10;
    else if (MEM_WB_RegWrite && ID_EX_Rt == MEM_WB_Rd && MEM_WB_Rd != 5'd0) ForwardB <= 2'b01;
    else ForwardB <= 2'b00;
  end
endmodule
