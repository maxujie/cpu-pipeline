module ROM(Address, Instruction);
    input [31:0] Address;
    output reg [31:0] Instruction;

    always @(*)
        case (Address[9:2])
            8'd0:    Instruction <= 32'h20040003;  // addi $a0, $zero, 3
            8'd1:    Instruction <= 32'h0c100003;  // jal sum
            // Loop:
            8'd2:    Instruction <= 32'h1000ffff;  // beq $zero, $zero, Loop
            // sum:
            8'd3:    Instruction <= 32'h23bdfff8;  // addi $sp, $sp, -8
            8'd4:    Instruction <= 32'hafbf0004;  // sw $ra, 4($sp)
            8'd5:    Instruction <= 32'hafa40000;  // sw $a0, 0($sp)
            8'd6:    Instruction <= 32'h28880001;  // slti $t0, $a0, 1
            8'd7:    Instruction <= 32'h11000003;  // beq $t0, $zero, L1
            8'd8:    Instruction <= 32'h00001026;  // xor $v0, $zero, $zero
            8'd9:    Instruction <= 32'h23bd0008;  // addi $sp, $sp, 8
            8'd10:   Instruction <= 32'h03e00008;  // jr $ra
            // L1:
            8'd11:   Instruction <= 32'h2084ffff;  // addi $a0, $a0, -1
            8'd12:   Instruction <= 32'h0c100003;  // jal sum
            8'd13:   Instruction <= 32'h8fa40000;  // lw $a0, 0($sp)
            8'd14:   Instruction <= 32'h8fbf0004;  // lw $ra, 4($sp)
            8'd15:   Instruction <= 32'h23bd0008;  // addi $sp, $sp, 8
            8'd16:   Instruction <= 32'h00821020;  // add $v0, $a0, $v0
            8'd17:   Instruction <= 32'h03e00008;  // jr $ra

            default: Instruction <= 32'h00000000;
        endcase

endmodule
