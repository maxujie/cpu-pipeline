module DataMem (
	input reset,
	input clk,
	input rd,
	input wr,
	input [31:0] addr,
	input [31:0] wdata,
	output [31:0] rdata,

	// Peripheral
	input [7:0] switch,
	output [7:0] led,
	output [11:0] digi,
	output irqout,

	// UART
	input clk_50m,
	input uart_rxd,
	output uart_txd);

parameter RAM_SIZE = 256;
parameter RAM_BIT_SIZE = 1024;
reg [31:0] RAMDATA [RAM_SIZE-1:0];

wire [31:0] rdata_peri;

Peripheral Peripheral (
	.reset(reset),
	.clk(clk),
	.rd(rd),
	.wr(wr),
	.addr(addr),
	.wdata(wdata),
	.rdata(rdata_peri),
	.led(led),
	.switch(switch),
	.digi(digi),
	.irqout(irqout));


parameter UART_TXD_ADDR = 32'h40000018;
parameter UART_RXD_ADDR = 32'h4000001C;
parameter UART_CON_ADDR = 32'h40000020;

reg tx_interrupt_en;
reg rx_interrupt_en;
reg [7:0] uart_txd_reg = 0;
reg [7:0] uart_rxd_reg = 0;
wire [7:0] rx_data;

wire send;
wire receive;
wire free;
wire tx_interrupt_status;
wire rx_interrupt_status;

wire [31:0] UART_TXD;
wire [31:0] UART_RXD;
wire [31:0] UART_CON;

assign send = addr == UART_TXD_ADDR;
assign receive = addr == UART_RXD_ADDR;
assign UART_TXD = {24'b0, uart_txd_reg[7:0]};
assign UART_RXD = {24'b0, uart_rxd_reg[7:0]};
assign UART_CON = {27'b0, free, rx_interrupt_status, tx_interrupt_status, rx_interrupt_en, tx_interrupt_en};


UART UART(
    .clk_50m(clk_50m),
    .reset_b(reset),

    .send(send),  // control signal from DataMem
    .receive(receive),

    .uart_txd(uart_txd),  // sent
    .tx_data(uart_txd_reg),
    .uart_rxd(uart_rxd),  // receive
    .rx_data(rx_data),

    .tx_interrupt_en(tx_interrupt_en),
    .rx_interrupt_en(rx_interrupt_en),
    .tx_interrupt_status(tx_interrupt_status),
    .rx_interrupt_status(rx_interrupt_status),
    .free(free));

wire [31:0] rdata_peri_uart;
assign rdata_peri_uart = (addr[7:0] < 8'h18) ? rdata_peri :
						addr == UART_TXD_ADDR ? UART_TXD :
						addr == UART_RXD_ADDR ? UART_RXD :
						addr == UART_CON_ADDR ? UART_CON : 32'b0;
assign rdata = rd ? (addr[31:10] == 0 ? RAMDATA[addr[9:2]] : rdata_peri_uart):32'b0;





always@(posedge clk) begin
	if(wr && addr[31:2] < RAM_SIZE) RAMDATA[addr[9:2]] <= wdata;
	else if (addr == UART_TXD_ADDR) uart_txd_reg[7:0] <= wdata[7:0];
	else if (addr == UART_CON) begin
	  tx_interrupt_en <= wdata[0];
	  rx_interrupt_en <= wdata[1];
	end
end

endmodule
