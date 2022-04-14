#
# First part of the Lab 3 test program
#

# data section
.data

# code/instruction section
.text
addi  $1,  $0,  1 		# Place “1�? in $1
addi $2, $0, 0x10010000
sw $1, 0($2)
lw $1, 0($2)
add $1, $1, $2
sub $2, $1, $2
addi $1, $1, 5
addi $1, $1, 5
addi $1, $1, 5
addi $1, $1, 5
addi $1, $1, 5
addi $1, $1, 5
addi $2, $1, 5
addi $1, $2, 5
addi $1, $1, 5
addi $2, $1, 5
addi $1, $2, 5
addi $1, $1, 5
addi $2, $1, 5
addi $1, $2, 5
addi $2, $1, 5
addi $1, $2, 5
addi $2, $1, 5
addi $1, $2, 5
sw $1, 0($2)
lw $1, 0($2)
slt $1, $0, $2
sgt $1, $0, $1
sgt $1, $0, $2
sgt $2, $0, $2
sgt $1, $0, $2
sgt $2, $0, $2
addiu $1, $2, 56
addi $2, $0, 0
addi $1, $0, 1
blt $2, $1, hello


hello:
sgt $1, $0, $2
sgt $2, $0, $2
sgt $1, $0, $2
sgt $2, $0, $2
addiu $1, $2, 56

halt
