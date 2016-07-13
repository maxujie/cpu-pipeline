module ROM (addr,data);
input [31:0] addr;
output [31:0] data;
reg [31:0] data;
localparam ROM_SIZE = 256;
reg [31:0] ROM_DATA[ROM_SIZE-1:0];
always@(*)
	case(addr[9:2])	//Address Must Be Word Aligned.
0:data <= 32'b00001000000000000000000000000011;     //j Add;
1:data <= 32'b00001000000000000000000001010101;     //j Output;
2:data <= 32'b00000000000000000000000000000000;     //NOP
3:data <= 32'b00001100000000000000000001010001;     //jal PC;
4:data <= 32'b00100100000010000000000001000000;     //addiu $t0,$ze,64;
5:data <= 32'b10101100000010000000000000000000;     //sw $t0,0($ze);
6:data <= 32'b00100100000010000000000001111001;     //addiu $t0,$ze,121;
7:data <= 32'b10101100000010000000000000000100;     //sw $t0,4($ze);
8:data <= 32'b00100100000010000000000000100100;     //addiu $t0,$ze,36;
9:data <= 32'b10101100000010000000000000001000;     //sw $t0,8($ze);
10:data <= 32'b00100100000010000000000000110000;     //addiu $t0,$ze,48;
11:data <= 32'b10101100000010000000000000001100;     //sw $t0,12($ze);
12:data <= 32'b00100100000010000000000000011001;     //addiu $t0,$ze,25;
13:data <= 32'b10101100000010000000000000010000;     //sw $t0,16($ze);
14:data <= 32'b00100100000010000000000000010010;     //addiu $t0,$ze,18;
15:data <= 32'b10101100000010000000000000010100;     //sw $t0,20($ze);
16:data <= 32'b00100100000010000000000000000010;     //addiu $t0,$ze,2;
17:data <= 32'b10101100000010000000000000011000;     //sw $t0,24($ze);
18:data <= 32'b00100100000010000000000001111000;     //addiu $t0,$ze,120;
19:data <= 32'b10101100000010000000000000011100;     //sw $t0,28($ze);
20:data <= 32'b00100100000010000000000000000000;     //addiu $t0,$ze,0;
21:data <= 32'b10101100000010000000000000100000;     //sw $t0,32($ze);
22:data <= 32'b00100100000010000000000000010000;     //addiu $t0,$ze,16;
23:data <= 32'b10101100000010000000000000100100;     //sw $t0,36($ze);
24:data <= 32'b00100100000010000000000000001000;     //addiu $t0,$ze,8;
25:data <= 32'b10101100000010000000000000101000;     //sw $t0,40($ze);
26:data <= 32'b00100100000010000000000000000011;     //addiu $t0,$ze,3;
27:data <= 32'b10101100000010000000000000101100;     //sw $t0,44($ze);
28:data <= 32'b00100100000010000000000001000110;     //addiu $t0,$ze,70;
29:data <= 32'b10101100000010000000000000110000;     //sw $t0,48($ze);
30:data <= 32'b00100100000010000000000000100001;     //addiu $t0,$ze,33;
31:data <= 32'b10101100000010000000000000110100;     //sw $t0,52($ze);
32:data <= 32'b00100100000010000000000000000110;     //addiu $t0,$ze,6;
33:data <= 32'b10101100000010000000000000111000;     //sw $t0,56($ze);
34:data <= 32'b00100100000010000000000000001110;     //addiu $t0,$ze,14;
35:data <= 32'b10101100000010000000000000111100;     //sw $t0,60($ze);
36:data <= 32'b00100100000010000000000000000000;     //addiu $t0,$ze,0;
37:data <= 32'b00100100000011000000000100000000;     //addiu $t4,$ze,256;
38:data <= 32'b00100100000011010000001000000000;     //addiu $t5,$ze,512;
39:data <= 32'b00100100000011100000010000000000;     //addiu $t6,$ze,1024;
40:data <= 32'b00100100000011110000100000000000;     //addiu $t7,$ze,2048;
41:data <= 32'b00100100000101010000000100000000;     //addiu $s5,$ze,256;
42:data <= 32'b00111100000110010100000000000000;     //lui $t9,16384;
43:data <= 32'b10101111001000000000000000001000;     //sw $ze,8($t9);
44:data <= 32'b00100100000010001111111111110000;     //addiu $t0,$ze,-16;
45:data <= 32'b10101111001010000000000000000000;     //sw $t0,0($t9);
46:data <= 32'b00100100000010011111111111110000;     //addiu $t1,$ze,-16;
47:data <= 32'b10101111001010010000000000000100;     //sw $t1,4($t9);
48:data <= 32'b00100100000010100000000000000011;     //addiu $t2,$ze,3;
49:data <= 32'b10101111001010100000000000001000;     //sw $t2,8($t9);
50:data <= 32'b10001111001101000000000000100000;     //lw $s4,32($t9);
51:data <= 32'b00110010100101000000000000001000;     //andi $s4,$s4,8;
52:data <= 32'b00010010100000001111111111111101;     //beq $s4,$ze,Ask1;
53:data <= 32'b10101111001000000000000000100000;     //sw $ze,32($t9);
54:data <= 32'b00100100000001110000000000000011;     //addiu $a3,$ze,3;
55:data <= 32'b10101111001001110000000000100000;     //sw $a3,32($t9);
56:data <= 32'b10001111001101100000000000011100;     //lw $s6,28($t9);
57:data <= 32'b10001111001101000000000000100000;     //lw $s4,32($t9);
58:data <= 32'b00110010100101000000000000001000;     //andi $s4,$s4,8;
59:data <= 32'b00010010100000001111111111111101;     //beq $s4,$ze,Ask2;
60:data <= 32'b10101111001000000000000000100000;     //sw $ze,32($t9);
61:data <= 32'b00100100000001110000000000000011;     //addiu $a3,$ze,3;
62:data <= 32'b10101111001001110000000000100000;     //sw $a3,32($t9);
63:data <= 32'b10001111001101110000000000011100;     //lw $s7,28($t9);
64:data <= 32'b00000000000101101000000000100000;     //add $s0,$ze,$s6;
65:data <= 32'b00000000000101111000100000100000;     //add $s1,$ze,$s7;
66:data <= 32'b00000010000100011001000000100010;     //sub $s2,$s0,$s1;
67:data <= 32'b00010010000000000000000000001001;     //beq $s0,$ze,Show;
68:data <= 32'b00010010001000000000000000001000;     //beq $s1,$ze,Show;
69:data <= 32'b00010010010000000000000000000111;     //beq $s2,$ze,Show;
70:data <= 32'b00011110010000000000000000000011;     //bgtz $s2,Pos;
71:data <= 32'b00000010001100001000100000100010;     //sub $s1,$s1,$s0;
72:data <= 32'b00000010000100011001000000100010;     //sub $s2,$s0,$s1;
73:data <= 32'b00001000000000000000000001000011;     //j gcd;
74:data <= 32'b00000010000100011000000000100010;     //sub $s0,$s0,$s1;
75:data <= 32'b00000010000100011001000000100010;     //sub $s2,$s0,$s1;
76:data <= 32'b00001000000000000000000001000011;     //j gcd;
77:data <= 32'b00000010001100001000000000100100;     //and $s0,$s1,$s0;
78:data <= 32'b10101111001100000000000000001100;     //sw $s0,12($t9);
79:data <= 32'b10101111001100000000000000011000;     //sw $s0,24($t9);
80:data <= 32'b00001000000000000000000000110010;     //j Ask1;
81:data <= 32'b00000000000111111111100001000000;     //sll $ra,$ra,1;
82:data <= 32'b00000000000111111111100001000010;     //srl $ra,$ra,1;
83:data <= 32'b00000000000000000000000000000000;     //NOP
84:data <= 32'b00000011111000000000000000001000;     //jr $ra;
85:data <= 32'b10101111001000000000000000001000;     //sw $ze,8($t9);
86:data <= 32'b00010010101011000000000000000011;     //beq $s5,$t4,Display1;
87:data <= 32'b00010010101011010000000000001000;     //beq $s5,$t5,Display2;
88:data <= 32'b00010010101011100000000000001101;     //beq $s5,$t6,Display3;
89:data <= 32'b00010010101011110000000000010010;     //beq $s5,$t7,Display4;
90:data <= 32'b00110010110110000000000000001111;     //andi $t8,$s6,15;
91:data <= 32'b00000000000110001100000010000000;     //sll $t8,$t8,2;
92:data <= 32'b10001111000110000000000000000000;     //lw $t8,0($t8);
93:data <= 32'b00000011000101011100000000100000;     //add $t8,$t8,$s5;
94:data <= 32'b00100100000101010000001000000000;     //addiu $s5,$ze,512;
95:data <= 32'b00001000000000000000000001110010;     //j Display;
96:data <= 32'b00000000000101101100000100000010;     //srl $t8,$s6,4;
97:data <= 32'b00000000000110001100000010000000;     //sll $t8,$t8,2;
98:data <= 32'b10001111000110000000000000000000;     //lw $t8,0($t8);
99:data <= 32'b00000011000101011100000000100000;     //add $t8,$t8,$s5;
100:data <= 32'b00100100000101010000010000000000;     //addiu $s5,$ze,1024;
101:data <= 32'b00001000000000000000000001110010;     //j Display;
102:data <= 32'b00110010111110000000000000001111;     //andi $t8,$s7,15;
103:data <= 32'b00000000000110001100000010000000;     //sll $t8,$t8,2;
104:data <= 32'b10001111000110000000000000000000;     //lw $t8,0($t8);
105:data <= 32'b00000011000101011100000000100000;     //add $t8,$t8,$s5;
106:data <= 32'b00100100000101010000100000000000;     //addiu $s5,$ze,2048;
107:data <= 32'b00001000000000000000000001110010;     //j Display;
108:data <= 32'b00000000000101111100000100000010;     //srl $t8,$s7,4;
109:data <= 32'b00000000000110001100000010000000;     //sll $t8,$t8,2;
110:data <= 32'b10001111000110000000000000000000;     //lw $t8,0($t8);
111:data <= 32'b00000011000101011100000000100000;     //add $t8,$t8,$s5;
112:data <= 32'b00100100000101010000000100000000;     //addiu $s5,$ze,256;
113:data <= 32'b00001000000000000000000001110010;     //j Display;
114:data <= 32'b10101111001110000000000000010100;     //sw $t8,20($t9);
115:data <= 32'b00100111010110101111111111111100;     //addiu $k0,$k0,-4;
116:data <= 32'b00100100000110110000000000000011;     //addiu $k1,$ze,3;
117:data <= 32'b10101111001110110000000000001000;     //sw $k1,8($t9);
118:data <= 32'b00000000000000000000000000000000;     //NOP
119:data <= 32'b00000000000000000000000000000000;     //NOP
120:data <= 32'b00000000000000000000000000000000;     //NOP
121:data <= 32'b00000000000000000000000000000000;     //NOP
122:data <= 32'b00000011010000000000000000001000;     //jr $k0;
	   default:	data <= 32'h0800_0000;
	endcase
endmodule
