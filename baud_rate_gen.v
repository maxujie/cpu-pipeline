module baud_rate_gen (clk_50m, clk_baud);
input clk_50m;
output clk_baud;

reg clk_baud = 0;
reg [7:0] cnt = 0;

parameter N = 163;  // 16 倍波特率

always @ (posedge clk_50m) begin
    if(cnt >= N) begin
        clk_baud = ~clk_baud;
        cnt = 0;
    end
    else begin
        cnt = cnt + 1;
    end
end


endmodule // baud_rate_gen
