#Every instruction
.data
val: .word 0x8, 0x10, 0x12
val2: .word 0xc, 0x12, 0x14
.text

la $t8 val

add $sp $zero $zero

addi $s1 $zero 12
lui $t0 0xFFFF
addiu $s3 $zero 15
addu $t2 $t0 $s1
and $t2 $t2 $t0
andi $s2 $s1 8
sw $t0 0($t8)
lw $t4 0($t8)
nor $t2 $t1 $t0
xor $t2 $t1 $t0
xori $t2 $t1 423
or $t2 $t1 $t0
ori $t2 $t1 543
slt $t2 $t1 $t0
slti $t2 $t1 -1
sll $t2 $t1 16
srl $t2 $t1 16
sra $t2 $t0 25 
sub $t2 $t1 $t0
subu $t2 $t1 $t0

beq $zero $zero Branch1
halt


Branch1:

bne $t0 $zero Branch2

halt

Branch2:

j Jump1

halt

Jump1:


jal JAL1

movn $t1 $t2 $t5
add $t1 $t1 $zero

halt


JAL1:
addi $t6 $zero 5
jr $ra

halt