module ID (
  input clk,
  input reset_b,

  input [31:0] PC_Plus4,
  input [31:0] Instruction,

  input [4:0] IF_ID_Rs,
  input [4:0] IF_ID_Rt,
  input [4:0] ID_EX_Rt,
  input ID_EX_MemRead,

  output bubble,
  output reg [] ID_EX // TODO
  );

// Control Control()

  wire bubble;

  HazardDetection HD(
    .IF_ID_Rs(IF_ID_Rs),
    .IF_ID_Rt(IF_ID_Rt),
    .ID_EX_Rt(ID_EX_Rt),
    .ID_EX_MemRead(ID_EX_MemRead),
    .bubble(bubble));

always @(posedge clk or negedge reset_b) begin
  if (~reset_b) begin
    // TODO
  end
  else begin

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
