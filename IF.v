module IF(
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
  input uart_wait,

  output reg [63:0] IF_ID);

wire [31:0] PC_Plus4;
wire [31:0] Instruction;


reg [31:0] PC;

assign PC_Plus4 = {(intruption | exception | PC[31]), PC[30:0] + 31'd4};

ROM IM(PC, Instruction);

always @ (posedge clk or negedge reset_b) begin
  if (~reset_b) begin
    PC <= 32'h8000_0000;
    IF_ID <= 0;
  end
  else if(~uart_wait)begin
  if (~IF_Pause) begin  // not bubble
    if (~(intruption | exception) || PC[31] == 1'b1) begin
      case (PCSrc)
        3'b000 : PC <= PC_Plus4;
        3'b001 : PC <= branch_address;
        3'b010 : PC <= jump_address;
        3'b100 : PC <= jr_address; // jr, jalr
        default : PC <= 32'hffff_ffff;  // unexcepted error
      endcase
    end
    else if (intruption) PC <= 32'h8000_0004;
    else if (exception) PC <= 32'h8000_0008;
    else PC <= 32'hffff_ffff;  // if not bubble end
    IF_ID <= IF_Flush ? {PC_Plus4, 32'd0} : {PC_Plus4, Instruction};
  end // end bubble
  end
end



endmodule
