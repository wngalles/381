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

jal bubble_repeat_until
j exit

bubble_repeat_until:
add $t9, $0, $0 # swapped = $t9, if 1 swapped is true, if 0, swapped is false

addi $v0, $0, 0
addi $s1, $zero, 4 # i
addi $a0, $s0, 0
addi $a1, $s1, 0
j exit