module CPU_Pipeline (
  input clk,
  input reset_b);

wire [] IF_ID;
wire [] ID_EX;
wire [] EX_MEM;
wire [] MEM_WB;

IF IF (
  input clk,
  input reset_b,

  input IF_Flush,
  input IF_Pause,  // bubble

  input [2:0] PCSrc,  // {JR, J, B}
  input [31:0] branch_address,
  input [31:0] jump_address,
  input [31:0] jr_address,

  input intruption,
  input exception,

  output [63:0] IF_ID);

ID ID (
  input clk,
  input reset_b,

  input [31:0] PC_Plus4,
  input [31:0] Instruction,

  input [4:0] IF_ID_Rs,
  input [4:0] IF_ID_Rt,
  // input [4:0] ID_EX_Rt,
  // input ID_EX_MemRead,

  input MEM_WB_RegWrite,
  input [4:0] MEM_WB_WriteReg,
  input [31:0] MEM_WB_RegWriteData,

  // TO IF
  output PCSrcJ,
  output PCSrcJR,
  output [31:0] jump_address,
  output [31:0] jr_address,

  // TO
  output bubble,
  output reg [228:0] ID_EX // TODO
  );


module EX(
  input clk,
  input reset_b,

  input [4:0] ID_EX_Rs,
  input [4:0] ID_EX_Rt,
  input [4:0] ID_EX_Rd,
  input [31:0] ID_EX_RsData,
  input [31:0] ID_EX_RtData,
  input [4:0] Shamt,
  input [31:0] IMM32,

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

  // Forwarding
  input [4:0] EX_MEM_Rd,
  input [4:0] MEM_WB_Rd,
  input [31:0] EX_MEM_RdData,
  input [31:0] MEM_WB_RdData,
  input EX_MEM_RegWrite,
  input MEM_WB_RegWrite,

  output PCSrcB,
  output reg [138:0] EX_MEM);

module MEM (
  input clk,
  input reset_b,

  input [31:0] MemWriteData,
  input [31:0] ALU_S,

  input [4:0] WriteReg,

  input MemRead,
  input MemWrite,

  input RegWrite,
  input [1:0] MemToReg,
  input [31:0] PC_Plus4,
  input LUOp,
  input [31:0] LUData,

  output reg [37:0] MEM_WB);









end module
