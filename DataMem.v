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
wire [31:0] rdata_uart;

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

UART UART(
	.UART_RX(uart_rxd),
	.UART_TX(uart_txd),
	.sysclk(clk_50m),
	.cpuclk(clk),
	.reset(reset),
	.rd(rd),
	.wr(wr),
	.addr(addr),
	.wdata(wdata),
	.rdata(rdata_uart));

wire [31:0] rdata_peri_uart;
assign rdata_peri_uart = (addr[7:0] < 8'h18) ? rdata_peri : rdata_uart;
assign rdata = rd ? (addr[31:10] == 0 ? RAMDATA[addr[9:2]] : rdata_peri_uart):32'b0;





always@(posedge clk) begin
	if(wr && addr[31:2] < RAM_SIZE) RAMDATA[addr[9:2]] <= wdata;
end

endmodule
