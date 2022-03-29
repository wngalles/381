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
jal bubble_for_loop_call

slt $t1, $0, $v0 # t1 = 1 if something has swapped
bne $t1, $0, bubble_repeat_until
j exit

# for loop

# evaluate if swapped
# if swapped, repeat
# if not swapped exit

bubble_for_loop_call:
addi $s3, $ra, 0
j bubble_for_loop

bubble_for_loop:

# if i < n-1: -> for_loop_interior: n++
# call bubble for loop again

# a0 = n-1
# a1 = i
srl $t1, $a1, 2
slt $t1, $t1, $a0 # if i < n-1: for loop interior: otherwise, return
bne $t1, $0, for_loop_interior_call

addi $v0, $v0, 0 # return swapped
addi $ra, $s3, 0
jr $ra

# if it gets through, return $v0

for_loop_interior_call:
addi $a1, $a1, 0 # a1 = i
addi $a0, $a1, -4  # a0 = i-1
add $a1, $a1, $t0 # a1 = $a[n]
add $a0, $a0, $t0 # a0 = $a[n-1]

jal for_loop_interior

addi $s1, $s1, 4 # i++
addi $a0, $s0, 0 # a0 = n-1
addi $a1, $s1, 0 # a1 = i
j bubble_for_loop

for_loop_interior:

# if this pair is out of order, tell them to swap
addi $t8, $ra, 0

addi $s7, $0, 0 # swapped = False

# get pair
lw $t4, 0($a0)
lw $t5, 0($a1)

# swapped = if a > b: swap
sgt $t6, $t4, $t5  # if a0 > a1: t6 = 1
bne $t6, $0, swap

or $v0, $s7, $v0 # return swapped
addi $ra, $t8, 0
jr $ra

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
