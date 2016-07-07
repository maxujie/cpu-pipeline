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

CPU_Pipeline CPU(clk, reset_b);

endmodule
