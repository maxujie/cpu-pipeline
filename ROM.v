module ROM (addr,data);
input [31:0] addr;
output [31:0] data;
reg [31:0] data;
localparam ROM_SIZE = 256;
reg [31:0] ROM_DATA[ROM_SIZE-1:0];
always@(*)
	case(addr[9:2])	//Address Must Be Word Aligned.
        0:data <= 32'h3c084000;
		1:data <= 32'h20090007;
		2:data <= 32'had090020;
		3:data <= 32'h200a0005;
		4:data <= 32'had0a0018;
		5:data <= 32'h08100005;
	   default:	data <= 32'h0800_0000;
	endcase
endmodule
