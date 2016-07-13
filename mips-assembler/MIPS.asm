j Add;
j Output;
NOP
Add:
jal PC;
addiu $t0,$ze,64;
sw $t0,0($ze);
addiu $t0,$ze,121;
sw $t0,4($ze);
addiu $t0,$ze,36;
sw $t0,8($ze);
addiu $t0,$ze,48;
sw $t0,12($ze);
addiu $t0,$ze,25;
sw $t0,16($ze);
addiu $t0,$ze,18;
sw $t0,20($ze);
addiu $t0,$ze,2;
sw $t0,24($ze);
addiu $t0,$ze,120;
sw $t0,28($ze);
addiu $t0,$ze,0;
sw $t0,32($ze);
addiu $t0,$ze,16;
sw $t0,36($ze);
addiu $t0,$ze,8;
sw $t0,40($ze);
addiu $t0,$ze,3;
sw $t0,44($ze);
addiu $t0,$ze,70;
sw $t0,48($ze);
addiu $t0,$ze,33;
sw $t0,52($ze);
addiu $t0,$ze,6;
sw $t0,56($ze);
addiu $t0,$ze,14;
sw $t0,60($ze);
addiu $t0,$ze,0;
addiu $t4,$ze,256;
addiu $t5,$ze,512;
addiu $t6,$ze,1024;
addiu $t7,$ze,2048;
addiu $s5,$ze,256;
lui $t9,16384;
sw $ze,8($t9);
addiu $t0,$ze,-16;
sw $t0,0($t9);
addiu $t1,$ze,-16;
sw $t1,4($t9);
addiu $t2,$ze,3;
sw $t2,8($t9);
Ask1:
lw $s4,32($t9);
andi $s4,$s4,8;
beq $s4,$ze,Ask1;
sw $ze,32($t9);
addiu $a3,$ze,3;
sw $a3,32($t9);
lw $s6,28($t9);
Ask2:
lw $s4,32($t9);
andi $s4,$s4,8;
beq $s4,$ze,Ask2;
sw $ze,32($t9);
addiu $a3,$ze,3;
sw $a3,32($t9);
lw $s7,28($t9);
add $s0,$ze,$s6;
add $s1,$ze,$s7;
sub $s2,$s0,$s1;
gcd:
beq $s0,$ze,Show;
beq $s1,$ze,Show;
beq $s2,$ze,Show;
bgtz $s2,Pos;
sub $s1,$s1,$s0;
sub $s2,$s0,$s1;
j gcd;
Pos:
sub $s0,$s0,$s1;
sub $s2,$s0,$s1;
j gcd;
Show:
and $s0,$s1,$s0;
sw $s0,12($t9);
sw $s0,24($t9);
j Ask1;
PC:
sll $ra,$ra,1;
srl $ra,$ra,1;
jr $ra;
Output:
sw $ze,8($t9);
beq $s5,$t4,Display1;
beq $s5,$t5,Display2;
beq $s5,$t6,Display3;
beq $s5,$t7,Display4;
Display1:
andi $t8,$s6,15;
sll $t8,$t8,2;
lw $t8,0($t8);
add $t8,$t8,$s5;
addiu $s5,$ze,512;
j Display;
Display2:
srl $t8,$s6,4;
sll $t8,$t8,2;
lw $t8,0($t8);
add $t8,$t8,$s5;
addiu $s5,$ze,1024;
j Display;
Display3:
andi $t8,$s7,15;
sll $t8,$t8,2;
lw $t8,0($t8);
add $t8,$t8,$s5;
addiu $s5,$ze,2048;
j Display;
Display4:
srl $t8,$s7,4;
sll $t8,$t8,2;
lw $t8,0($t8);
add $t8,$t8,$s5;
addiu $s5,$ze,256;
j Display;
Display:
sw $t8,20($t9);
addiu $k0,$k0,-4;
addiu $k1,$ze,3;
sw $k1,8($t9);
jr $k0;
END