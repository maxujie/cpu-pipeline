module uart_receiver (
    clk_50m,
    clk_baud,
    uart_rx,
    rx_status,
    rx_data,
);

output reg [7:0] rx_data = 0;
output reg rx_status;
input uart_rx, clk_50m, clk_baud;

wire sample_signal;  // 有数据传输的时候，在每比特的中心附近产生一个采样信号
sample_signal_gen sample_signal_gen(sample_signal, uart_rx, clk_baud);

reg [7:0] received_data;
reg [3:0] bit_cnt = 0;
wire reset_b = ~rx_status;  // 当 rx_status 是 1 的时候，向上层模块传送数据；
                            // 同时将暂存接收到数据的寄存器清零

always @(posedge sample_signal or negedge reset_b) begin
    if(reset_b == 0) begin  // 向上层模块发送完接收到的数据以后将状态清零
        received_data <= 0;
        bit_cnt <= 0;
    end else begin          // 在采样信号 sample_signal 的上升沿进行采样
        received_data <= {uart_rx, received_data[7:1]};
        bit_cnt <= bit_cnt + 4'b1;
    end
end

always @(posedge clk_50m) begin  // 用 50MHz 的时钟触发
    if (bit_cnt == 4'd8) begin  // 如果已经采到 8 个比特数据，则一次接收结束
        rx_data <= received_data;
        rx_status <= 1'b1;
    end else begin
        rx_data <= rx_data;
        rx_status <= 1'b0;  // rx_status 的长度最多为 50MHz 时钟的一个周期
    end
end

endmodule


module sample_signal_gen(sample_signal, uart_rx, clk_baud);
output reg sample_signal;
input uart_rx, clk_baud;

parameter CLK_PER_BIT = 16;
parameter WAITING_TIME = CLK_PER_BIT / 2;

reg [1:0] state, next_state;
parameter LISTENING = 2'd0,  // 未开始接收数据
          WAITING = 2'd1,    // 输入从 1 变成 0 时需要等待半个比特宽度
          SAMPLING = 2'd2;   // 进行采样

reg [3:0] cnt = 0, next_cnt,
          bit_cnt = 0, next_bit_cnt;
wire next_sample_signal;

always @(*) begin
    case (state)
    LISTENING: begin
        next_state = (uart_rx ? LISTENING : WAITING);  // 如果 uart_rx 保持 1 的
        next_cnt = 4'b0;                               // 话就继续 listen, 出现 0
        next_bit_cnt = 4'b0;                           // 就转入等待半比特状态
    end

    WAITING: begin
        if (cnt < WAITING_TIME - 1) begin  // 等待半个比特
            next_state = WAITING;
            next_cnt = cnt + 4'b1;
        end else begin
            next_state = SAMPLING;  // 等待结束后进入采样状态
            next_cnt = 4'b0;
        end
        next_bit_cnt = 4'b0;
    end

    SAMPLING: begin
        next_state = (bit_cnt == 4'd9 ? LISTENING : SAMPLING);  // 接收结束->回到
                                                                // listening
        if (cnt < CLK_PER_BIT - 1) begin  // cnt 在 0~15 循环
            next_cnt = cnt + 4'b1;
            next_bit_cnt = bit_cnt;
        end else begin
            next_cnt = 4'b0;
            next_bit_cnt = bit_cnt + 4'b1;
        end
    end

    default: begin
        next_state = 0;
        next_cnt = 0;
        next_bit_cnt = 0;
    end
    endcase
end

assign next_sample_signal = (state == SAMPLING &&       // 如果还没有采够 8 bit
                          cnt == CLK_PER_BIT - 4'd2 &&  // 数据的话，在每个比特的
                          bit_cnt < 4'd8);               // 中心处进行采样

always @(posedge clk_baud) begin  // 在 16 倍波特率时钟的上升沿更新状态
    state <= next_state;
    cnt <= next_cnt;
    bit_cnt <= next_bit_cnt;
    sample_signal <= next_sample_signal;
end
endmodule
