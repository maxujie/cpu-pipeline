module baud_rate_gen_test;
reg clk = 0;
always #10 clk = ~clk;

baud_rate_gen baud_rate_gen(clk, clk_baud);

endmodule // baud_rate_gen_test
