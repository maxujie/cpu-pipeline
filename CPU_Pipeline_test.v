module CPU_Pipeline_test;

reg clk = 0;
reg reset_b = 1;
initial begin
    reset_b = 0;
    #1 reset_b = 1;
    repeat (100000) begin
    #1000 clk <= ~clk;
    end
end

reg [7:0] switch = 8'b00000000;
wire [7:0] led;
wire [11:0] digi;
wire [6:0] bcd1, bcd2, bcd3, bcd4;
reg uart_rxd = 1;
wire uart_txd;

CPU_Pipeline CPU(clk, reset_b, switch, led,  bcd1, bcd2, bcd3, bcd4, uart_rxd, uart_txd);



endmodule
