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

wire [31:0] MemReadData;

DataMem DataMem(
  .clk(clk),
  .reset(reset_b),
  .rd(MemRead),  // Read
  .wr(MemWrite),  // Write
  .addr(ALU_S),
  .wdata(MemWriteData),
  .rdata(MemReadData));

wire [31:0] RegWriteData;

assign RegWriteData = LUOp ? LUData:
         MemToReg == 2'b00 ? ALU_S :
         MemToReg == 2'b01 ? MemReadData : PC_Plus4;


always @(posedge clk or negedge reset_b) begin
  if (~reset_b) begin
    MEM_WB <= 0;
  end
  else begin
    MEM_WB[31:0] <= RegWriteData[31:0];
    MEM_WB[36:32] <= WriteReg[4:0];
    MEM_WB[37] <= RegWrite;
  end
end

endmodule
