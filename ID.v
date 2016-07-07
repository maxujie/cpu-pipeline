module ID (
  input clk,
  input reset_b,

  input [31:0] PC_Plus4,
  input [31:0] Instruction,

  input [4:0] ID_EX_Rt,
  input ID_EX_MemRead,

  input MEM_WB_RegWrite,
  input [4:0] MEM_WB_WriteReg,
  input [31:0] MEM_WB_RegWriteData,

  // TO IF
  output PCSrcJ,
  output PCSrcJR,
  output [31:0] jump_address,
  output [31:0] jr_address,

  output bubble,
  output exception,
  output reg [229:0] ID_EX);

wire [2:0] PCSrc;
wire [1:0] RegDst;
wire RegWrite;
wire ALUSrc1;
wire ALUSrc2;
wire [5:0] ALUFun;
wire Sign;
wire MemWrite;
wire MemRead;
wire [1:0] MemToReg;
wire EXTOp;
wire LUOp;
wire IRQ;
assign IRQ = 1'b0;



Control ControlUnit(
  .Instruct(Instruction),
  .IRQ(IRQ), // TODO
  .PC31(PC_Plus4[31]),
  .PCSrc(PCSrc),  // IF
  .RegDst(RegDst),  // WB
  .RegWr(RegWrite),  // WB
  .ALUSrc1(ALUSrc1),  // EX
  .ALUSrc2(ALUSrc2),  // EX
  .ALUFun(ALUFun),  // EX
  .Sign(Sign),  // EX
  .MemWr(MemWrite),  // MEM
  .MemRd(MemRead),  // MEM
  .MemToReg(MemToReg),  // WB
  .EXTOp(EXTOp),  // ID
  .LUOp(LUOp));  // ID EX WB

wire PCSrcJ;
wire PCSrcJR;
wire Branch;
wire exception;
wire [5:0] OpCode;
wire [4:0] Rs;
wire [4:0] Rt;
wire [4:0] Rd;
wire [4:0] Shamt;
wire [5:0] Funct;
wire [15:0] Imm16;
wire [31:0] Imm32;
wire [31:0] LUData;

assign PCSrcJ = PCSrc == 3'b010 ? 1'b1 : 1'b0;
assign PCSrcJR = PCSrc == 3'b011 ? 1'b1 : 1'b0;
assign Branch = PCSrc == 3'b001 ? 1'b1 : 1'b0;
assign exception = PCSrc == 3'b101 ? 1'b1 : 1'b0;
assign Opcode = Instruction[31:26];
assign Rs = Instruction[25:21];
assign Rt = Instruction[20:16];
assign Rd = Instruction[15:11];
assign Shamt = Instruction[10:6];
assign Funct = Instruction[5:0];
assign Imm16 = Instruction[15:0];
assign Imm32 = EXTOp ? (Imm16[15] == 1'b1 ? {16'hffff, Imm16} : {16'h0000, Imm16}) : {16'h0000, Imm16};
assign LUData = {Imm16[15:0], 16'hffff};


wire [31:0] RsData;
wire [31:0] RtData;

RegFile RF (
  .reset(reset_b),
  .clk(clk),
  .addr1(Rs),
  .data1(RsData),
  .addr2(Rt),
  .data2(RtData),
  .wr(MEM_WB_RegWrite),
  .addr3(MEM_WB_WriteReg),
  .data3(MEM_WB_RegWriteData));

wire [31:0] jump_address;
wire [31:0] branch_address;
wire [31:0] jr_address;

assign jump_address = {PC_Plus4[31:28], Instruction[25:0], 2'b0}; // j, jal
assign branch_address = PC_Plus4 + {Imm32[29:0], 2'b00};
assign jr_address = RsData;  // jalr, jr

wire bubble;

HazardDetection HD(
  .IF_ID_Rs(Rs),
  .IF_ID_Rt(Rt),
  .ID_EX_Rt(ID_EX_Rt),
  .ID_EX_MemRead(ID_EX_MemRead),
  .bubble(bubble));

always @(posedge clk or negedge reset_b) begin
  if (~reset_b) begin
    ID_EX <= 0;
  end
  else begin
    if(~bubble) begin
      ID_EX[31:0] <= RsData[31:0];
      ID_EX[63:32] <= RtData[31:0];
      ID_EX[68:64] <= Rs[4:0];
      ID_EX[73:69] <= Rt[4:0];
      ID_EX[78:74] <= Rd[4:0];
      ID_EX[87:79] <= {ALUSrc1, ALUSrc2, ALUFun[5:0], Sign};  // ALU
      ID_EX[119:88] <= branch_address[31:0]; // EX
      ID_EX[121:120] <= {MemRead, MemWrite};  // MEM
      ID_EX[124:122] <= {MemToReg, RegWrite}; // WB
      ID_EX[157:125] <= {LUOp, LUData[31:0]}; // WB
      ID_EX[189:158] <= PC_Plus4[31:0];  // jal, jalr
      ID_EX[194:190] <= Shamt[4:0];
      ID_EX[226:195] <= Imm32[31:0];
      ID_EX[227] <= Branch;  // EX
      ID_EX[229:228] <= RegDst[1:0];  // WB
    end else ID_EX[229:0] <= 0; // bubble
  end
end


endmodule

module HazardDetection (
  input [4:0] IF_ID_Rs,
  input [4:0] IF_ID_Rt,
  input [4:0] ID_EX_Rt,
  input ID_EX_MemRead,
  output reg bubble
  );

always @(*) begin
  if (ID_EX_MemRead && (IF_ID_Rs == ID_EX_Rt || IF_ID_Rt == ID_EX_Rt))
    bubble = 1'b1;
  else bubble = 1'b0;
end

endmodule
