module CPU (reset,sysclk,LED,SWITCH,Digi1,Digi2,Digi3,Digi4,UARX_RX,UARX_TX);
input reset,sysclk,UARX_RX;
input [7:0] SWITCH;
output [7:0] LED;
output [6:0] Digi1,Digi2,Digi3,Digi4;
output UARX_TX;

wire clk;
wire [11:0] digi_in;
wire [31:0] PCAdd4,PCNext,PCIn,PCSrc1,ConBA;
wire [31:0] Instruction;
wire [31:0] DatabusA,DatabusB,DatabusC;
wire [31:0] ALUInputA,ALUInputB,ALUOut;
wire [31:0] RdData,RdData_DataMem,RdData_Periph,RdData_UART;
wire [31:0] ExtImm32,LUOpOutput;
wire [25:0] JT;
wire [15:0] Imm16;
wire [5:0] ALUFun;
wire [4:0] Rd,Rt,Rs,Shamt;
wire [4:0] AddrC;
wire [2:0] PCSrc;
wire [1:0] RegDst,MemtoReg;
wire RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,ExtOp,LUOp;
wire IRQ,IRQ_Timer,IRQ_RX,IRQ_TX;
reg [31:0] PC;

parameter ILLOP = 32'h80000004;
parameter XADR = 32'h80000008;
parameter Ra = 5'd31;
parameter Xp = 5'd26;

CPU_CLK cpuclk(sysclk,clk);

assign PCNext = PC+32'd4;
assign PCAdd4 = {PC[31],PCNext[30:0]};
assign PCSrc1 = (ALUOut[0]==1'b1)?ConBA:PCAdd4;
assign PCIn = (PCSrc==3'b000)? PCAdd4:
				(PCSrc==3'b001)? PCSrc1:
				(PCSrc==3'b010)? {PC[31:28],JT,2'b00}:
				(PCSrc==3'b011)? DatabusA:
				(PCSrc==3'b100)? ILLOP:
				(PCSrc==3'b101)? XADR:PCAdd4;
always @(negedge reset or posedge clk)
begin
	if(~reset)
		PC <= 32'h80000000;
	else
		PC <= PCIn;
end

ROM InsMem(PC,Instruction);

assign JT = Instruction[25:0];
assign Imm16 = Instruction[15:0];
assign Shamt = Instruction[10:6];
assign Rd = Instruction[15:11];
assign Rt = Instruction[20:16];
assign Rs = Instruction[25:21];

Control CtrlUnit(Instruction,IRQ,PC[31],PCSrc,RegDst,RegWr,ALUSrc1,ALUSrc2,ALUFun,Sign,MemWr,MemRd,MemToReg,EXTOp,LUOp);

assign AddrC = (RegDst==2'b00)? Rd:
				(RegDst==2'b01)? Rt:
				(RegDst==2'b10)? Ra:
				(RegDst==2'b11)? Xp:Rt;

RegFile RegUnit (reset,clk,Rs,DatabusA,Rt,DatabusB,RegWr,AddrC,DatabusC);

assign ALUInputA = (ALUSrc1==1'b0)? DatabusA:Shamt;
assign ALUInputB = (ALUSrc2==1'b0)? DatabusB:LUOpOutput;

ALU ALUUnit (ALUInputA,ALUInputB,ALUFun,Sign,ALUOut);

assign LUOpOutput = (LUOp==1'b0)? ExtImm32:{Imm16,16'b0};
assign ExtImm32 = (ExtOp==1'b0)? {16'b0,Imm16}:(Imm16[15]? {16'hffff,Imm16}:{16'h0000,Imm16});
assign ConBA = {ExtImm32[29:0],2'b00}+PCAdd4;

DataMem DataMemUnit (reset,clk,MemRd,MemWr,ALUOut,DatabusB,RdData_DataMem);

Peripheral PeripheralUnit (reset,clk,MemRd,MemWr,ALUOut,DatabusB,RdData_Periph,LED,SWITCH,digi_in,IRQ_Timer);

digitube_scan DigiUnit (digi_in,Digi1,Digi2,Digi3,Digi4);

UART UARTUnit (UARX_RX,UARX_TX,sysclk,clk,reset,MemRd,MemWr,ALUOut,DatabusB,RdData_UART,IRQ_RX,IRQ_TX);

assign RdData = RdData_DataMem|RdData_Periph|RdData_UART;
assign IRQ = IRQ_Timer;
assign DatabusC = (MemToReg==2'b00)? ALUOut:
					(MemToReg==2'b01)? RdData:
					(MemToReg==2'b10)? PCAdd4:32'b0;

endmodule
