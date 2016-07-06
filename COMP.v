module Compare(
    input wire Zero,
    input wire Overflow,
    input wire Negative,
    input wire[2:0] FT,
    output wire S
);
    parameter FT_CMP_EQ  = 3'b001;
    parameter FT_CMP_NEQ = 3'b000;
    parameter FT_CMP_LT  = 3'b010;
    parameter FT_CMP_LEZ = 3'b110;
    parameter FT_CMP_LTZ = 3'b101;
    parameter FT_CMP_GTZ = 3'b111;

    parameter ERROR_OUTPUT = 1'b1;

    assign S = (FT == FT_CMP_EQ) ? Zero : (
        (FT == FT_CMP_NEQ) ? ~Zero : (
            (FT == FT_CMP_LT) ? Negative : (
                (FT == FT_CMP_LEZ) ? (Negative | Zero) : (
                    (FT == FT_CMP_LTZ) ? (Negative) : (
                        (FT == FT_CMP_GTZ) ? (~Negative & ~Zero) :
                            ERROR_OUTPUT
                    )
                )
            )
        )
    );

endmodule