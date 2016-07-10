module UART(
    input clk_50m,
    input reset_b,

    input send,  // control signal from DataMem
    input receive,

    output uart_txd,  // sent
    input [7:0] tx_data,
    input uart_rxd,  // receive
    output reg [7:0] rx_data,

    input tx_interrupt_en,
    input rx_interrupt_en,
    output tx_interrupt_status,
    output rx_interrupt_status,
    output free);

    wire clk_baud;
    baud_rate_gen baud_rate_gen(clk_50m, clk_baud);

    wire rx_status;
    reg receive_done;
    wire [7:0] rx_data_received;
    uart_receiver uart_receiver(clk_50m, clk_baud, uart_rxd, rx_status, rx_data_received);

    wire tx_status;
    wire tx_en;
    assign tx_en = tx_interrupt_en & tx_status & send;
    reg send_done;
    uart_sender uart_sender(clk_baud, uart_txd, tx_status, tx_data, tx_en);

    always @ (posedge rx_status or posedge receive) begin
        if (receive) begin
            receive_done <= 0;
        end else begin
            rx_data <= (receive_done & rx_interrupt_en) ? rx_data : rx_data_received;
            receive_done <= rx_interrupt_en;
        end
    end

    always @ (posedge send or posedge tx_status) begin
        if (send) begin
            send_done <= 0;
        end else begin
            send_done <= tx_interrupt_en;
        end
    end

endmodule
