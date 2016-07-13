module uart_sender (
    clk_baud,
    uart_tx,
    tx_status,
    tx_data,
    tx_en
);

input clk_baud, tx_en;
input [7:0] tx_data;
output uart_tx;
output tx_status;

reg uart_tx = 1;
reg [7:0] clk_cnt = 0;
reg [7:0] bit_cnt = 0;
reg [9:0] bit_to_send;

assign tx_status = bit_cnt == 0 ? 1'b1 : 1'b0;

parameter CLK_PER_BIT = 16;

always @ (posedge clk_baud or posedge tx_en) begin
    if (tx_en == 1'b1) begin  // 如果出现发送信号，则准备发送数据
        if (bit_cnt == 0) begin
            clk_cnt = 15;
            bit_cnt = 10;
            bit_to_send = {1'b1, tx_data, 1'b0}; // 移位寄存器，从低位到高位发送
        end
    end
    else if (bit_cnt > 0) begin  // 如果数据还没有发送完
        clk_cnt = clk_cnt + 1;
        if (clk_cnt >= CLK_PER_BIT) begin  // 每 16 个时钟周期发送 1 bit 数据
            uart_tx = bit_to_send[0];
            bit_to_send[8:0] = bit_to_send[9:1];
            bit_cnt = bit_cnt - 1;  // 待发送的 bit 数量减 1
            clk_cnt = 0;
        end
    end
end

endmodule // uart_sender
