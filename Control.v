module Control (Instruct,IRQ,PC31,PCSrc,RegDst,RegWr,ALUSrc1,ALUSrc2,ALUFun,Sign,MemWr,MemRd,MemToReg,EXTOp,LUOp);
input [31:0] Instruct;
input IRQ,PC31;
output reg [2:0] PCSrc;
output reg [1:0] RegDst;
output reg [5:0] ALUFun;
output reg [1:0] MemToReg;
output reg RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,LUOp;

always @(*)
begin
	PCSrc = 3'b000;
	RegDst = 2'b00;
	ALUFun = 6'b000000;
	MemToReg = 2'b00;
	RegWr = 0;
	ALUSrc1 = 0;
	ALUSrc2 = 0;
	Sign = 0;
	MemWr = 0;
	MemRd = 0;
	EXTOp = 0;
	LUOp = 0;

	if(!IRQ)
	begin
		case(Instruct[31:26])
			6'b000000:
			begin
				MemWr = 0;
				MemRd = 0;
				case(Instruct[5:0])
					6'b100000://add
					begin
						PCSrc = 3'b000;
						RegDst = 2'b00;
						ALUFun = 6'b000000;
						MemToReg = 2'b00;
						RegWr = 1;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						Sign = 1;
					end
					6'b100001://addu
					begin
						PCSrc = 3'b000;
						RegDst = 2'b00;
						ALUFun = 6'b000000;
						MemToReg = 2'b00;
						RegWr = 1;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						Sign = 0;
					end
					6'b100010://sub
					begin
						PCSrc = 3'b000;
						RegDst = 2'b00;
						ALUFun = 6'b000001;
						MemToReg = 2'b00;
						RegWr = 1;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						Sign = 1;
					end
					6'b100011://subu
					begin
						PCSrc = 3'b000;
						RegDst = 2'b00;
						ALUFun = 6'b000001;
						MemToReg = 2'b00;
						RegWr = 1;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						Sign = 0;
					end
					6'b100100://and
					begin
						PCSrc = 3'b000;
						RegDst = 2'b00;
						ALUFun = 6'b011000;
						MemToReg = 2'b00;
						RegWr = 1;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
					end
					6'b100101://or
					begin
						PCSrc = 3'b000;
						RegDst = 2'b00;
						ALUFun = 6'b011110;
						MemToReg = 2'b00;
						RegWr = 1;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
					end
					6'b100110://xor
					begin
						PCSrc = 3'b000;
						RegDst = 2'b00;
						ALUFun = 6'b010110;
						MemToReg = 2'b00;
						RegWr = 1;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
					end
					6'b100111://nor
					begin
						PCSrc = 3'b000;
						RegDst = 2'b00;
						ALUFun = 6'b010001;
						MemToReg = 2'b00;
						RegWr = 1;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
					end
					6'b000000://sll
					begin
						PCSrc = 3'b000;
						RegDst = 2'b00;
						ALUFun = 6'b100000;
						MemToReg = 2'b00;
						RegWr = 1;
						ALUSrc1 = 1;
						ALUSrc2 = 0;
					end
					6'b000010://srl
					begin
						PCSrc = 3'b000;
						RegDst = 2'b00;
						ALUFun = 6'b100001;
						MemToReg = 2'b00;
						RegWr = 1;
						ALUSrc1 = 1;
						ALUSrc2 = 0;
					end
					6'b000011://sra
					begin
						PCSrc = 3'b000;
						RegDst = 2'b00;
						ALUFun = 6'b100011;
						MemToReg = 2'b00;
						RegWr = 1;
						ALUSrc1 = 1;
						ALUSrc2 = 0;
					end
					6'b101010://slt
					begin
						PCSrc = 3'b000;
						RegDst = 2'b00;
						ALUFun = 6'b110101;
						MemToReg = 2'b00;
						RegWr = 1;
						ALUSrc1 = 0;
						ALUSrc2 = 0;
						Sign = 1;
					end
					6'b001000://jr
					begin
						PCSrc = 3'b011;
						RegWr = 0;
					end
					6'b001001://jalr
					begin
						PCSrc = 3'b011;
						RegDst = 2'b00;
						MemToReg = 2'b10;
						RegWr = 1;
					end
					default:
					begin
						if(!PC31)//exception
						begin
							PCSrc = 3'b101;
							RegDst = 2'b11;
							RegWr = 1;
							MemToReg = 2'b10;
						end
						else//nop
						begin
							PCSrc = 3'b000;
							RegDst = 2'b00;
							ALUFun = 6'b100000;
							MemToReg = 2'b00;
							RegWr = 1;
							ALUSrc1 = 1;
							ALUSrc2 = 0;
						end
					end
				endcase
			end
			6'b000100://beq
			begin
				PCSrc = 3'b001;
				ALUFun = 6'b110011;
				RegWr = 0;
				ALUSrc1 = 0;
				ALUSrc2 = 0;
				Sign = 1;
				MemWr = 0;
				MemRd = 0;
				EXTOp = 1;
			end
			6'b000101://bne
			begin
				PCSrc = 3'b001;
				ALUFun = 6'b110001;
				RegWr = 0;
				ALUSrc1 = 0;
				ALUSrc2 = 0;
				Sign = 1;
				MemWr = 0;
				MemRd = 0;
				EXTOp = 1;
			end
			6'b000110://blez
			begin
				PCSrc = 3'b001;
				ALUFun = 6'b111101;
				RegWr = 0;
				ALUSrc1 = 0;
				ALUSrc2 = 0;
				Sign = 1;
				MemWr = 0;
				MemRd = 0;
				EXTOp = 1;
			end
			6'b000001://bltz
			begin
				PCSrc = 3'b001;
				ALUFun = 6'b110101;
				RegWr = 0;
				ALUSrc1 = 0;
				ALUSrc2 = 0;
				Sign = 1;
				MemWr = 0;
				MemRd = 0;
				EXTOp = 1;
			end
			6'b000111://bgtz
			begin
				PCSrc = 3'b001;
				ALUFun = 6'b111111;
				RegWr = 0;
				ALUSrc1 = 0;
				ALUSrc2 = 0;
				Sign = 1;
				MemWr = 0;
				MemRd = 0;
				EXTOp = 1;
			end
			6'b001000://addi
			begin
				PCSrc = 3'b000;
				RegDst = 2'b01;
				ALUFun = 6'b000000;
				MemToReg = 2'b00;
				RegWr = 1;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				Sign = 1;
				MemWr = 0;
				MemRd = 0;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b001001://addiu
			begin
				PCSrc = 3'b000;
				RegDst = 2'b01;
				ALUFun = 6'b000000;
				MemToReg = 2'b00;
				RegWr = 1;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				Sign = 0;
				MemWr = 0;
				MemRd = 0;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b001100://andi
			begin
				PCSrc = 3'b000;
				RegDst = 2'b01;
				ALUFun = 6'b011000;
				MemToReg = 2'b00;
				RegWr = 1;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				MemWr = 0;
				MemRd = 0;
				EXTOp = 0;
				LUOp = 0;
			end
			6'b001010://slti
			begin
				PCSrc = 3'b000;
				RegDst = 2'b01;
				ALUFun = 6'b110101;
				MemToReg = 2'b00;
				RegWr = 1;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				Sign = 1;
				MemWr = 0;
				MemRd = 0;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b001011://sltiu
			begin
				PCSrc = 3'b000;
				RegDst = 2'b01;
				ALUFun = 6'b110101;
				MemToReg = 2'b00;
				RegWr = 1;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				Sign = 0;
				MemWr = 0;
				MemRd = 0;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b000010://j
			begin
				PCSrc = 3'b010;
				RegWr = 0;
				MemWr = 0;
				MemRd = 0;
			end
			6'b000011://jal
			begin
				PCSrc = 3'b010;
				RegDst = 2'b10;
				MemToReg = 2'b10;
				RegWr = 1;
				MemWr = 0;
				MemRd = 0;
			end
			6'b100011://lw
			begin
				PCSrc = 3'b000;
				RegDst = 2'b01;
				ALUFun = 6'b000000;
				MemToReg = 2'b01;
				RegWr = 1;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				Sign = 1;
				MemWr = 0;
				MemRd = 1;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b101001://sw
			begin
				PCSrc = 3'b000;
				ALUFun = 6'b000000;
				RegWr = 0;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				Sign = 1;
				MemWr = 1;
				MemRd = 0;
				EXTOp = 1;
				LUOp = 0;
			end
			6'b001111://lui
			begin
				PCSrc = 3'b000;
				RegDst = 2'b01;
				ALUFun = 6'b011110;
				MemToReg = 2'b00;
				RegWr = 1;
				ALUSrc1 = 0;
				ALUSrc2 = 1;
				MemWr = 0;
				MemRd = 0;
				LUOp = 1;
			end
			default:
			begin
				if(!PC31)//exception
				begin
					PCSrc = 3'b101;
					RegDst = 2'b11;
					MemToReg = 2'b10;
					RegWr = 1;
					MemWr = 0;
					MemRd = 0;
				end
				else//nop
				begin
					PCSrc = 3'b000;
					RegDst = 2'b00;
					ALUFun = 6'b100000;
					MemToReg = 2'b00;
					RegWr = 1;
					ALUSrc1 = 1;
					ALUSrc2 = 0;
					MemWr = 0;
					MemRd = 0;
				end
			end
		endcase
	end
	else if(!PC31)
	begin
		PCSrc = 3'b100;
		RegDst = 2'b11;
		MemToReg = 2'b10;
		RegWr = 1;
		MemWr = 0;
		MemRd = 0;
	end
end

endmodule
