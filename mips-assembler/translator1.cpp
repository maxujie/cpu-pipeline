#include <iostream>
#include<stdlib.h>
#include<string>
#include<iomanip>
#include<windows.h>
#include<fstream>
using namespace std; 

string Regnum(string reg);
string Binary(int num);
string Binary1(int num);
string Rinstruction(string s0,string op);
string Iinstruction(string s0,string op,int line);
string Jinstruction(string s0,string op);

int n=0;
string mips[200];
string label[200];
int main()
{
	string s,s1;
	ifstream infile("mips.txt",ios::in);
	ofstream outfile("instruction.txt",ios::out);
	while (true)//mips数组和label数组赋值
	{
		getline(infile,s);
		if (s=="END")
			break;
		int l=s.length();
		if (s[l-1]==58)//冒号
		{
			label[n]=s;
			int l=label[n].length();
			label[n][l-1]=0;//冒号去掉
		}
		else
		{
			mips[n]=s;
			n=n+1;
		}
	}
	int i,j;
	for (j=0;j<n;j++)//对mips数组中每条string输出相应的类型，进入选择RIJ型
	{
		i=0;
		while (mips[j]!="NOP"&&mips[j][i]!=32)
			i=i+1;
		string op=mips[j].substr(0,i);
		if (op=="add"||op=="addu"||op=="sub"||op=="subu"||op=="and"||op=="or"||op=="xor"||op=="nor"||op=="sll"||op=="srl"||op=="sra"||op=="slt"||op=="jr"||op=="jalr"||mips[j]=="NOP")	
			s1=Rinstruction(mips[j],op);
		else if (op=="lui"||op=="addi"||op=="addiu"||op=="andi"||op=="slti"||op=="sltiu"||op=="beq"||op=="bne"||op=="blez"||op=="bgtz"||op=="bltz"||op=="sw"||op=="lw")
			s1=Iinstruction(mips[j],op,j);
		else if (op=="j"||op=="jal")
			s1=Jinstruction(mips[j],op);
		cout<<j<<":data <= 32'b"<<s1<<";     //"<<mips[j]<<endl;
	}
	return 0;
    system("pause");
} 

string Jinstruction(string s0,string op)
{
	string s="00000000000000000000000000000000";
	int i=0,j=0;
	int op_length=op.length();
	int s0_length=s0.length();

	string temp1=s0.substr(op_length+1,s0_length-op_length-1);
	int temp1_length=temp1.length();
	temp1[temp1_length-1]=0;//因为最后一个是分号
	s[4]=49;//j:0x02
	if(op=="jal")s[5]=49;//jal:0x03
	while(i<n&&label[i].compare(temp1)!=0)
		i++;
	string temp2=Binary(i);
	for(j=0;j<16;j++)
		s[j+16]=temp2[j];	
	return s;
}

string Iinstruction(string s0,string op,int line)
{
	string s="00000000000000000000000000000000";
	string temp1,temp2;
	int i=0,j=0;
	int l=op.length();
	int l0=s0.length();
	if(op=="addi"||op=="addiu"||op=="andi"||op=="slti"||op=="sltiu"||op=="lui"||op=="lw"||op=="sw")
	{
		if(op=="sw")s[0]=49;
        s[2]=49;
        if(op=="andi"||op=="lui")s[3]=49;
        if(op=="slti"||op=="sltiu"||op=="lui"||op=="sw")s[4]=49;
        if(op=="addiu"||op=="sltiu"||op=="sw"||op=="lui")s[5]=49;
        
        temp1=s0.substr(l+1,3);
        temp2=Regnum(temp1);
        for (i=0;i<5;i++)
        	s[11+i]=temp2[i];
        
        
        if(op!="lui")
        {
        	if(op!="lw"&&op!="sw")
        		temp1=s0.substr(l+5,3);
        	else temp1=s0.substr(l0-5,3);
        	temp2=Regnum(temp1);
        	for (i=0;i<5;i++)
        		s[6+i]=temp2[i];
        }
        
        if(op=="lw"||op=="sw")	
        {
        	if (s0[8]=='(')
        		j=s0[7]-48;
        	else if (s0[9]=='(')
        		j=10*(s0[7]-48)+s0[8]-48;
        	else if (s0[10]=='(')
        		j=100*(s0[7]-48)+10*(s0[8]-48)+s0[9]-48;
        	else if (s0[11]=='(')
        		j=1000*(s0[7]-48)+100*(s0[8]-48)+10*(s0[9]-48)+s0[10]-48;
        	else if (s0[12]=='(')
        		j=10000*(s0[7]-48)+1000*(s0[8]-48)+100*(s0[9]-48)+10*(s0[10]-48)+s0[11]-48;
        	temp2=Binary(j);
        	for (i=0;i<16;i++)
        		s[16+i]=temp2[i];
        }
        else
        {
        	if (s0[l0-3]==44)//l0-3上是逗号imme为一位非负数
        		j=s0[l0-2]-48;
        	else if (s0[l0-4]==44&&s0[l0-3]>47&&s0[l0-3]<58)//l0-4上是逗号，imme是两位非负数
        		j=10*(s0[l0-3]-48)+s0[l0-2]-48;
        	else if (s0[l0-5]==44&&s0[l0-4]>47&&s0[l0-4]<58)//l0-5是逗号，imme是三位非负数
        		j=100*(s0[l0-4]-48)+10*(s0[l0-3]-48)+s0[l0-2]-48;
        	else if (s0[l0-6]==44)//l0-6是逗号，imme是四位非负数
        		j=1000*(s0[l0-5]-48)+100*(s0[l0-4]-48)+10*(s0[l0-3]-48)+s0[l0-2]-48;
        	else if (s0[l0-7]==44)//l0-7是逗号，imme是五位非负数
        		j=10000*(s0[l0-6]-48)+1000*(s0[l0-5]-48)+100*(s0[l0-4]-48)+10*(s0[l0-3]-48)+s0[l0-2]-48;
        	else if (s0[l0-4]==44&&s0[l0-3]=='-')//l0-4是逗号，imme是一位负数
        		j=(-1)*(s0[l0-2]-48);
        	else if (s0[l0-5]==44&&s0[l0-4]=='-')//l0-5是逗号，imme是两位负数
        		j=(-1)*(10*(s0[l0-3]-48)+s0[l0-2]-48);
        	temp2=Binary(j);
        	for (i=0;i<16;i++)
        		s[16+i]=temp2[i];	
        }
	}
	
	else if (op=="beq"||op=="bne"||op=="blez"||op=="bgtz"||op=="bltz")
	{
		if(op!="bltz")s[3]=49;
		if(op=="blez"||op=="bgtz")s[4]=49;
		if(op=="bne"||op=="bgtz"||op=="bltz")s[5]=49;
		temp1=s0.substr(l+1,3);
		temp2=Regnum(temp1);
		for (i=0;i<5;i++)
			s[6+i]=temp2[i];
		
		int l0=s0.length();
		if(op=="beq"||op=="bne")
		{
			temp1=s0.substr(l+5,3);
			temp2=Regnum(temp1);
			for (i=0;i<5;i++)
				s[11+i]=temp2[i];
			temp1=s0.substr(l+9,l0-l-9);//offset带分号
		}
		else temp1=s0.substr(l+5,l0-l-5);
		int l1=temp1.length();
		temp1[l1-1]=0;
		for (i=0;i<n;i++)
		{
			if (label[i].compare(temp1)==0)
				j=i;
		}
		j=j-(line+1);
		temp2=Binary(j);
		for (i=0;i<16;i++)
			s[16+i]=temp2[i];	
	} 
	
	return s;
}

string Rinstruction(string s0,string op)
{
	string s="00000000000000000000000000000000";
	string temp1,temp2;
	int i=0,j=0,l=0;
	l=op.length();
	if (op=="add"||op=="addu")
	{
		if(op=="add"||op=="addu"||op=="sub"||op=="subu"||op=="and"||op=="or"||op=="xor"||op=="nor"||op=="slt"||op=="sltu")s[26]=49;
		if(op=="slt"||op=="sltu")s[28]=49;
		if(op=="and"||op=="or"||op=="xor"||op=="nor")s[29]=49;
		if(op=="sub"||op=="subu"||op=="xor"||op=="nor"||op=="slt"||op=="sltu")s[30]=49;
		if(op=="addu"||op=="subu"||op=="or"||op=="nor"||op=="sltu")s[31]=49;
		
		//rd
		temp1=s0.substr(l+1,3);
		temp2=Regnum(temp1);
		for (i=0;i<5;i++)
			s[16+i]=temp2[i];
		
		//rs
		temp1=s0.substr(l+5,3);
		temp2=Regnum(temp1);
		for (i=0;i<5;i++)
			s[6+i]=temp2[i];
		
		//rt
		temp1=s0.substr(l+9,3);
		temp2=Regnum(temp1);
		for (i=0;i<5;i++)
			s[11+i]=temp2[i];
	}
	else if (op=="sll"||op=="srl")
	{
		if(op=="srl"||op=="sra")s[30]=49;
		if(op=="sra")s[31]=49;
		
		temp1=s0.substr(l+1,3);
		temp2=Regnum(temp1);
		for (i=0;i<5;i++)
			s[16+i]=temp2[i];
		
		temp1=s0.substr(l+5,3);
		temp2=Regnum(temp1);
		for (i=0;i<5;i++)
			s[11+i]=temp2[i];
		
		int l0=s0.length();
		if (s0[l0-3]==44)
			j=s0[l0-2]-48;
		else if (s0[l0-4]==44)
			j=10*(s0[l0-3]-48)+s0[l0-2]-48;
		temp2=Binary1(j);
		for (i=0;i<5;i++)
			s[21+i]=temp2[i];	
	}
	
	else if (op=="jr")
	{
		s[28]=49;
		temp1=s0.substr(l+1,3);
		temp2=Regnum(temp1);
		for (i=0;i<5;i++)
			s[6+i]=temp2[i];
	}
	else if (op=="jr"||op=="jalr")
	{
		s[28]=49;
		temp1=s0.substr(l+1,3);
		temp2=Regnum(temp1);
		for (i=0;i<5;i++)
			s[6+i]=temp2[i];
		if(op=="jalr")
		{
			s[31]=49;
			temp1=s0.substr(l+5,3);
			temp2=Regnum(temp1);
			for (i=0;i<5;i++)
				s[16+i]=temp2[i];
		}
	}
	return s;

}
  
string Binary(int num)//十进制正负数转成二进制16位
{
	string s="0000000000000000";
	int i=0;
	int j;
	j=(num<0)?(-num):num;
	while (j!=0)
	{
		s[15-i]=j%2+48;
		j=(j-j%2)/2;
		i=i+1;
	}
	if (num<0)
	{
		for (i=0;i<16;i++)
			if (s[i]==48)
				s[i]=49;
			else if (s[i]==49)
				s[i]=48;
		s[15]=s[15]+1;
		i=15;
		while (s[i]>49)
		{
			s[i]=48;
			s[i-1]=s[i-1]+1;
			i=i-1;
		}
	}
	return s;
}

string Binary1(int num)
{
	string s="00000";
	int i=0;int j=num;
	if (num<0)
		j=-num;
	while (j!=0)
	{
		s[i]=j%2+48;
		j=(j-s[i]+48)/2;
		i=i+1;
	}
	if (num<0)
	{
		for (i=0;i<5;i++)
			if (s[i]==48)
				s[i]=49;
			else if (s[i]==49)
				s[i]=48;
		s[0]=s[0]+1;
		i=0;
		while (s[i]>49)
		{
			s[i]=48;
			s[i+1]=s[i+1]+1;
			i=i+1;
		}
	}
	for (j=0;j<2;j++)
	{
		i=s[j];
		s[j]=s[4-j];
		s[4-j]=i;
	}
	return s;
}

string Regnum(string reg)
{
	return (reg=="$ze"||reg=="$0")?"00000":
	 (reg=="$at")?"00001":
	 (reg=="$v0")?"00010":
	 (reg=="$v1")?"00011":
	 (reg=="$a0")?"00100":
	 (reg=="$a1")?"00101":
	 (reg=="$a2")?"00110":
	 (reg=="$a3")?"00111":
	 (reg=="$t0")?"01000":
	 (reg=="$t1")?"01001":
	 (reg=="$t2")?"01010":
	 (reg=="$t3")?"01011":
	 (reg=="$t4")?"01100":
	 (reg=="$t5")?"01101":
	 (reg=="$t6")?"01110":
	 (reg=="$t7")?"01111":
	 (reg=="$s0")?"10000":
	 (reg=="$s1")?"10001":
	 (reg=="$s2")?"10010":
	 (reg=="$s3")?"10011":
	 (reg=="$s4")?"10100":
	 (reg=="$s5")?"10101":
	 (reg=="$s6")?"10110":
	 (reg=="$s7")?"10111":
	 (reg=="$t8")?"11000":
	 (reg=="$t9")?"11001":
	 (reg=="$k0")?"11010":
	 (reg=="$k1")?"11011":
	 (reg=="$gp")?"11100":
	 (reg=="$sp")?"11101":
	 (reg=="$fp")?"11110":
	 "11111";
}
