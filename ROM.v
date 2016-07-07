module ROM(Address, Instruction);
    input [31:0] Address;
    output reg [31:0] Instruction;

    always @(*)
        case (Address[9:2])
            8'd0:    Instruction <= 32'h00004820;
			8'd1:    Instruction <= 32'h200a0001;
			8'd2:    Instruction <= 32'h200b0005;
			8'd3:    Instruction <= 32'h0c100007;
			8'd4:    Instruction <= 32'h152bfffe;
			8'd5:    Instruction <= 32'h218c0001;
			8'd6:    Instruction <= 32'h08000000;
			8'd7:    Instruction <= 32'h012a4820;
			8'd8 :    Instruction <= 32'h03e00008;
            default: Instruction <= 32'h00000000;
        endcase

endmodule
