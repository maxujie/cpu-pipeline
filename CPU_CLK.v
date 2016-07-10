module CPU_CLK (clk_50m, clk);
input clk_50m;
output clk;

reg clk = 0;
reg [31:0] cnt = 0;

parameter N = 1; 

always @ (posedge clk_50m) begin
    if(cnt >= N) begin
        clk = ~clk;
        cnt = 0;
    end
    else begin
        cnt = cnt + 1;
    end
end


endmodule
