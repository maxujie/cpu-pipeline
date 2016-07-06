module Baudx16 (sysclk,Baudx16clk);
input sysclk;
output reg Baudx16clk = 0;

reg [7:0] cnt = 0;

always @(posedge sysclk)
begin
	if(cnt==8'd162)
	begin
		cnt <= 8'b0;
		Baudx16clk <= ~Baudx16clk;
	end
	else
		cnt <= cnt+8'b1;
end

endmodule

module Baud (sysclk,Baudclk);
input sysclk;
output  reg Baudclk = 0;

reg [11:0] cnt = 0;

always @(posedge sysclk)
begin
	if(cnt==12'd2603)
	begin
		cnt <= 12'b0;
		Baudclk <= ~Baudclk;
	end
	else
		cnt <= cnt+12'b1;
end

endmodule

module UARTReceiver (UART_RX,Baudx16clk,RX_DATA,RX_STATUS);
input UART_RX,Baudx16clk;
output reg [7:0] RX_DATA;
output reg RX_STATUS;

reg [7:0] cnt;
reg idle = 1;

always @(posedge Baudx16clk)
begin
	cnt = cnt+8'b1;
	if(idle)
	begin
		if(UART_RX==0)
		begin
			cnt = 0;
			idle = 0;
		end
	end
	else
	begin
		case(cnt)
			8'd24:
			RX_DATA[0] = UART_RX;
			8'd40:
			RX_DATA[1] = UART_RX;
			8'd56:
			RX_DATA[2] = UART_RX;
			8'd72:
			RX_DATA[3] = UART_RX;
			8'd88:
			RX_DATA[4] = UART_RX;
			8'd104:
			RX_DATA[5] = UART_RX;
			8'd120:
			RX_DATA[6] = UART_RX;
			8'd136:
			RX_DATA[7] = UART_RX;
			8'd152:
			RX_STATUS = 1;
			8'd153:
			begin
				RX_STATUS = 0;
				idle = 1;
			end
		endcase
	end
end

endmodule

module UARTSender (UART_TX,Baudclk,TX_DATA,TX_EN,TX_STATUS);
input [7:0] TX_DATA;
input Baudclk,TX_EN;
output reg UART_TX;
output reg TX_STATUS = 1'b1;

reg [3:0] cnt;
reg idle;

always @(posedge TX_EN or posedge Baudclk)
begin
	if(TX_EN)
		idle = 1;
	else
	begin
		if(idle)
		begin
			TX_STATUS = 0;
			cnt = 0;
			idle = 0;
		end
		if(~TX_STATUS)
			case(cnt)
				4'd0:
				UART_TX = 0;
				4'd1:
				UART_TX = TX_DATA[0];
				4'd2:
				UART_TX = TX_DATA[1];
				4'd3:
				UART_TX = TX_DATA[2];
				4'd4:
				UART_TX = TX_DATA[3];
				4'd5:
				UART_TX = TX_DATA[4];
				4'd6:
				UART_TX = TX_DATA[5];
				4'd7:
				UART_TX = TX_DATA[6];
				4'd8:
				UART_TX = TX_DATA[7];
				4'd9:
				UART_TX = 1;
				4'd10:
				TX_STATUS = 1'b1;
			endcase
		cnt = cnt+4'b1;
	end
end

endmodule

module UART (UART_RX,UART_TX,sysclk,cpuclk,reset,rd,wr,addr,wdata,rdata,RX_IRQ,TX_IRQ);
input [31:0] addr,wdata;
input UART_RX,sysclk,cpuclk,reset,rd,wr;
output reg [31:0] rdata;
output UART_TX,RX_IRQ,TX_IRQ;

wire [7:0] RX_DATA;
wire TX_STATUS,RX_STATUS,Baudx16clk,Baudclk;
reg [7:0] TX_DATA,UART_RXD,UART_TXD;
reg [4:0] UART_CON;
reg TX_EN,Send,Write;

Baudx16 Baudx16Unit (sysclk,Baudx16clk);

Baud BaudUnit (sysclk,Baudclk);

UARTReceiver UARTReceiverUnit (UART_RX,Baudx16clk,RX_DATA,RX_STATUS);

UARTSender UARTSenderUnit (UART_TX,Baudclk,TX_DATA,TX_EN,TX_STATUS);

always @(*)
begin
	UART_CON[4] = ~TX_STATUS;
	UART_RXD = RX_DATA;
	if(rd)
	begin
		case(addr)
			32'h40000018:
			rdata <= {24'b0,UART_TXD};
			32'h4000001C:
			rdata <= {24'b0,UART_RXD};
			32'h40000020:
			rdata <= {27'b0,UART_CON};
			default:
			rdata <= 32'b0;
		endcase
	end
	else
		rdata <= 32'b0;
end

always @(negedge reset or negedge UART_CON[0] or posedge TX_STATUS)
begin
	if(~reset)
		UART_CON[2] <= 0;
	else if(~UART_CON[0])
		UART_CON[2] <= 0;
	else if(TX_STATUS)
		UART_CON[2] <= 1'b1;
end
always @(negedge reset or negedge UART_CON[1] or posedge RX_STATUS)
begin
	if(~reset)
		UART_CON[3] <= 0;
	else if(~UART_CON[1])
		UART_CON[3] <= 0;
	else if(RX_STATUS)
		UART_CON[3] <= 1'b1;
end

always @(posedge sysclk or posedge Write)
begin
	if(Write)
		Send = 1'b1;
	else if(Send)
	begin
		if(TX_STATUS)
			if(~TX_EN)
			begin
				TX_EN = 1'b1;
				TX_DATA = UART_TXD;
			end
			else
			begin
				TX_EN = 1'b0;
				Send = 0;
			end
	end
end
always @(negedge reset or posedge cpuclk)
begin
	if(~reset)
	begin
		UART_TXD <= 8'b0;
		UART_CON[1:0] <= 2'b11;
	end
	else
	begin
		if(Write)
			Write <= 1'b0;
		if(wr)
		begin
			case(addr)
				32'h40000018:
				begin
					UART_TXD <= wdata[7:0];
					Write <= 1'b1;
				end
				32'h40000020:
				UART_CON[1:0] <= wdata[1:0];
				default:;
			endcase
		end
	end
end

assign RX_IRQ = UART_CON[3]&UART_CON[1];
assign TX_IRQ = UART_CON[2]&UART_CON[0];

endmodule
			
			
			


















