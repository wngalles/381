#
# Test every instuction with a ton of data/control hazards
#

# data section
.data

# code/instruction section
.text

main:

addi $t0, $0, 2
bne $t0, $0, next
addi $t0, $0, 2

next:
addiu $t0, $t0, 90
andi $t0, $t0, 90
lui $t0, 0x1001
lw $t1, 0($t0)
xori $t2, $t1, 111111
ori $t2, $t2, 10000
slti $t3, $t2, $t1
sw $t3, 0($t0)
beq $t1, $t1, again

again:
j howdy

howdy:
jal func
movn $t1, $t1, $t2
j exit

func:
add $t1, $t1, $t2
addu $t1, $t2, $t3
and $t1, $t2, $t1
nor $t2, $t1, $t3
xor $t2, $t1, $t2
or $t1, $t2, $t3
slt $t5, $t1, $t2
sll $t2, $t1, 5
srl $t2, $t2, 5
sra $t2, $t2, 5
sub $t3, $t2, $t1
subu $t3, $t2, $t1
jr $ra

exit:
halt