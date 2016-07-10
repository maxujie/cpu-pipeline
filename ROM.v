module ROM(Address, Instruction);
    input [31:0] Address;
    output reg [31:0] Instruction;

    always @(*)
        case (Address[9:2])
            8'd0:    Instruction <= 32'h20080001;
            8'd1:    Instruction <= 32'h00084820;
            8'd2:    Instruction <= 32'h01285020;
            8'd3:    Instruction <= 32'h012a582a;
            8'd4:    Instruction <= 32'h1160fffb;
            8'd5:    Instruction <= 32'h08100005;

            default: Instruction <= 32'h00000000;
        endcase

endmodule
