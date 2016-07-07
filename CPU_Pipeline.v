module CPU_Pipeline (
  input clk,
  input reset_b);

wire [63:0] IF_ID;
wire [229:0] ID_EX;
wire [138:0] EX_MEM;
wire [37:0] MEM_WB;

wire PCSrcJR, PCSrcJ, PCSrcB;
wire bubble;
wire [31:0] jump_address;
wire [31:0] jr_address;
wire intruption;
wire exception;

assign intruption = 1'b0;

IF IF (
  .clk(clk),
  .reset_b(reset_b),

  .IF_Flush(IF_Flush),
  .IF_Pause(bubble),  // bubble

  .PCSrc({PCSrcJR, PCSrcJ, PCSrcB}),  // {JR  J  B}
  .branch_address(ID_EX[119:88]),
  .jump_address(jump_address),
  .jr_address(jr_address),

  .intruption(intruption),
  .exception(exception),

  .IF_ID(IF_ID));

ID ID (
  .clk(clk),
  .reset_b(reset_b),

  .PC_Plus4(IF_ID[63:32]),
  .Instruction(IF_ID[31:0]),

  .ID_EX_Rt(ID_EX[73:69]),
  .ID_EX_MemRead(ID_EX[121]),

  .MEM_WB_RegWrite(MEM_WB[37]),
  .MEM_WB_WriteReg(MEM_WB[36:32]),
  .MEM_WB_RegWriteData(MEM_WB[31:0]),

  // TO IF
  .PCSrcJ(PCSrcJ),
  .PCSrcJR(PCSrcJR),
  .jump_address(jump_address),
  .jr_address(jr_address),

  .bubble(bubble),
  .exception(exception),
  .ID_EX(ID_EX)
  );


EX EX(
  .clk(clk),
  .reset_b(reset_b),

  .ID_EX_Rs(ID_EX[68:64]),
  .ID_EX_Rt(ID_EX[73:69]),
  .ID_EX_Rd(ID_EX[78:74]),
  .ID_EX_RsData(ID_EX[31:0]),
  .ID_EX_RtData(ID_EX[63:32]),
  .Shamt(ID_EX[194:190]),
  .Imm32(ID_EX[226:195]),

  .ALUSrc1(ID_EX[87]),
  .ALUSrc2(ID_EX[86]),
  .ALUFun(ID_EX[85:80]),
  .Sign(ID_EX[79]),

  .Branch(ID_EX[227]),

  .MemRead(ID_EX[121]),
  .MemWrite(ID_EX[120]),
  .RegWrite(ID_EX[122]),
  .MemToReg(ID_EX[124:123]),
  .LUOp(ID_EX[157]),
  .LUData(ID_EX[156:125]),
  .PC_Plus4(ID_EX[189:158]),
  .RegDst(ID_EX[229:228]),

  // Forwarding
  .EX_MEM_Rd(EX_MEM[68:64]),
  .MEM_WB_Rd(MEM_WB[36:32]),
  .EX_MEM_RdData(EX_MEM[63:32]),
  .MEM_WB_RdData(MEM_WB[31:0]),
  .EX_MEM_RegWrite(EX_MEM[71]),
  .MEM_WB_RegWrite(MEM_WB[37]),

  .PCSrcB(PCSrcB),
  .EX_MEM(EX_MEM));

MEM MEM (
  .clk(clk),
  .reset_b(reset_b),

  .MemWriteData(EX_MEM[31:0]),
  .ALU_S(EX_MEM[63:32]),

  .WriteReg(EX_MEM[68:64]),

  .MemRead(EX_MEM[69]),
  .MemWrite(EX_MEM[70]),

  .RegWrite(EX_MEM[71]),
  .MemToReg(EX_MEM[73:72]),
  .PC_Plus4(EX_MEM[105:74]),
  .LUOp(EX_MEM[138]),
  .LUData(EX_MEM[137:106]),

  .MEM_WB(MEM_WB));

endmodule
