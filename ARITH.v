module Arith(
    input wire[31:0] A,
    input wire[31:0] B,
    input wire FT,
    input wire Signed,
    output wire[31:0] S,
    output wire Zero,
    output wire Overflow,
    output wire Negative
);

	assign S=FT?(A+(~B)+1):(A+B);
	assign Zero=(S == 0) & ~Overflow;
	assign Overflow=FT?((Signed?(
        (A[31]&~B[31]&~S[31])|(~A[31]&B[31]&S[31])):
		((~A[31]&B[31])|((A[31]==B[31])&S[31])))):
		(Signed ? ((A[31]&B[31]&~S[31])|(~A[31]&~B[31]&S[31])):
		((A[31]&B[31])|(A[31]&~S[31])|(B[31]&~S[31])));
	assign Negative=FT?( (A[31]^B[31]) ? (Signed?A[31]:B[31]) : S[31]):
	(Signed & ((A[31]^B[31]) ?S[31]:A[31]) );
    
endmodule