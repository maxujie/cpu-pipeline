module ALUtb;
	reg [31:0]A,B;
	reg [5:0]ALUFun=6'b110011;
	reg Sign=1;
	wire [31:0]S;
	ALU ALUtb1(A, B, ALUFun, Sign, S);
    always begin
		#50 ALUFun=6'b110011;
		#50 ALUFun=6'b110001;
		#50 ALUFun=6'b110101;
		#50 ALUFun=6'b111101;
		#50 ALUFun=6'b111001;
		#50 ALUFun=6'b111111;
	end
		
    always begin
        #300 A=$random;
        B=$random;
    end
endmodule
