module MEM (
  input clk,
  input reset_b,

  input EX_MEM_MemRead,
  input EX_MEM_MemWrite,

  input [31:0] EX_MEM_ALU_Z,
  input [31:0] EX_MEM_RdData,

  output reg [] MEM_WB
  );

wire [31:0] MemReadData;

DataMem DataMem(
  .clk(clk),
  .rst(reset_b),
  .rd(EX_MEM_MemRead),  // Read
  .wr(EX_MEM_MemWrite),  // Write
  .addr(EX_MEM_ALU_Z),
  .wdata(EX_MEM_RdData),
  .rdata(MemReadData));


  always @(posedge clk or negedge reset_b) begin
    if (~reset_b) begin
      // TODO
    end
    else begin

    end
  end

endmodule
