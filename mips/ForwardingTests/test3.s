#
# First part of the Lab 3 test program
#

# data section
.data
list: .word 0, 5, 6, 2, 1
size: .word 5

# code/instruction section
.text

main:

lw $s0, size
addi $s0, $s0, 0
la $t0, list # starting address of list is in $t0

addi $a0, $t0, 0
addi $a1, $t0, 4

jal swap
jal swap
jal swap
jal swap
jal swap
j exit

swap:
# swap items
lw $t4, 0($a0)
lw $t5, 0($a1)
sw $t4, 0($a1)
sw $t5, 0($a0)

# swapped = true
addi $v0, $0, 1
jr $ra

exit:
halt