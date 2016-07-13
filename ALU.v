module ALU(
    input wire[31:0] A,
    input wire[31:0] B,
    input wire[5:0]ALUFunc,
    input wire Signed,
    output wire[31:0] S
);

    parameter ALU_ARITH = 2'b00;			
    parameter ALUFUNC_ADD = 6'b000000;//32'h00
    parameter ALUFUNC_SUB = 6'b000001;//32'h01		

    parameter ALU_LOGIC = 2'b01;
    parameter ALUFUNC_AND = 6'b011000;//32'h18
    parameter ALUFUNC_OR  = 6'b011110;//32'h1e
    parameter ALUFUNC_XOR = 6'b010110;//32'h16
    parameter ALUFUNC_NOR = 6'b010001;//32'h11
    parameter ALUFUNC_A   = 6'b011010;//32'h1a

    parameter ALU_SHIFT = 2'b10;
    parameter ALUFUNC_SLL = 6'b100000;//32'h20
    parameter ALUFUNC_SRL = 6'b100001;//32'h21
    parameter ALUFUNC_SRA = 6'b100011;//32'h23

    parameter ALU_CMP = 2'b11;
    parameter ALUFUNC_EQ  = 6'b110011;//32'h33
    parameter ALUFUNC_NEQ = 6'b110001;//32'h31
    parameter ALUFUNC_LT  = 6'b110101;//32'h35
    parameter ALUFUNC_LEZ = 6'b111101;//32'h3d
    parameter ALUFUNC_LTZ = 6'b111011;//32'h3b
    parameter ALUFUNC_GTZ = 6'b111111;//32'h3f

    wire[31:0] ArithOut;
    wire Zero;
    wire Overflow;
    wire Negative;
    Arith m_arith(A, B, ALUFunc[0], Signed, ArithOut, Zero, Overflow, Negative);
    
    wire CompareOut;
    Compare m_compare(Zero, Overflow, Negative, ALUFunc[3:1], CompareOut);

    wire[31:0] LogicOut;
    Logic m_logic(A, B, ALUFunc[3:0], LogicOut);

    wire[31:0] ShiftOut;
    Shift m_shift(A[4:0], B, ALUFunc[1:0], ShiftOut);

    assign S = (
        (ALUFunc[5:4] == ALU_ARITH) ? ArithOut : (
            (ALUFunc[5:4] == ALU_LOGIC) ? LogicOut : (
                (ALUFunc[5:4] == ALU_SHIFT) ? ShiftOut :
                    { {31{1'b0}}, CompareOut}
            )
        )
    );

endmodule