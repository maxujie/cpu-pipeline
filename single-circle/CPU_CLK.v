module CPU_CLK (sysclk,clk);
input sysclk;
output clk;

/*
reg [7:0] cnt;

always @(posedge sysclk)
begin
	if(cnt==8'162)
	begin	
		cnt <= 8'b0;
		clk <= ~clk;
	endmodule
*/
	
assign clk = sysclk;

endmodule