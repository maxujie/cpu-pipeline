module ROM(Address, Instruction);
    input [31:0] Address;
    output reg [31:0] Instruction;

    always @(*)
        case (Address[9:2])
            8'd0:    Instruction <= 32'h20080001;
            8'd1:    Instruction <= 32'hafa80008;
            8'd2:    Instruction <= 32'h8fa90008;
            8'd3:    Instruction <= 32'h08100003;

            default: Instruction <= 32'h00000000;
        endcase

endmodule
