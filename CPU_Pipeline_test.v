module CPU_Pipeline_test;

reg clk = 0;
reg reset_b = 1;
initial begin
    reset_b = 0;
    #1 reset_b = 1;
    repeat (1000) begin
    #1000 clk <= ~clk;
    end
end

reg [7:0] switch = 8'b11111111;
wire [7:0] led;
wire [11:0] digi;

CPU_Pipeline CPU(clk, reset_b, switch, led, digi, uart_rxd, uart_txd);

endmodule
