module CPU_CLK (clk_50m, clk);
input clk_50m;
output reg clk = 0;

parameter N = 100;


reg [7:0] cnt = 0;

always @ ( posedge clk_50m ) begin
	if (cnt == N) begin
		cnt <= 0;
		clk <= ~clk;
	end else cnt = cnt + 1;
end

endmodule
