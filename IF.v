module IF(
  input clk,
  input reset_b,

  input IF_Flush,
  input IF_Pause,

  input [3:0] PC_Src,
  input [31:0] branch_address,
  input [31:0] jump_address,
  input [31:0] jr_address,

  input intruption,
  input exception,

  output [63:0] IF_ID);

wire [31:0] PC_Plus4;
wire [31:0] Instruction;


reg [31:0] PC;
reg [63:0] IF_ID;

assign PC_Plus4 = {(intruption | exception | PC[31]), PC[30:0] + 31'd4};

// InstructionMemory IM(PC, Instruction);

always @ (posedge clk or negedge reset_b) begin
  if (~reset_b) begin
    PC <= 32'h8000_0000;
    IF_ID <= 0;
  end
  else begin
  if (~IF_Pause) begin
    if (~(intruption | exception)) begin
      case (PC_Src)
        3'd0 : PC <= PC_Plus4;
        3'd1 : PC <= branch_address;
        3'd2 : PC <= jump_address;
        3'd3 : PC <= jr_address;
        default : PC <= 32'hffff_ffff;  // unexcepted error
      endcase
    end
    else if (intruption) PC <= 32'h8000_0004;
    else if (exception) PC <= 32'h8000_0008;
    else PC <= 32'hffff_ffff;
    IF_ID <= IF_Flush ? {PC_Plus4, 32'd0} : {PC_Plus4, Instruction};
  end
  end
end



endmodule
