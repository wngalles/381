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
nop
nop
la $t0, list # starting address of list is in $t0
nop
nop

jal bubble_repeat_until
nop
j exit
nop

bubble_repeat_until:

add $t9, $0, $0 # swapped = $t9, if 1 swapped is true, if 0, swapped is false
addi $v0, $0, 0
addi $s1, $zero, 4 # i
addi $a0, $s0, 0
nop
addi $a1, $s1, 0
jal bubble_for_loop_call
nop

slt $t1, $0, $v0 # t1 = 1 if something has swapped
nop
nop
bne $t1, $0, bubble_repeat_until
nop
j exit
nop

# for loop

# evaluate if swapped
# if swapped, repeat
# if not swapped exit

bubble_for_loop_call:
nop
nop
addi $s3, $ra, 0
nop
nop
j bubble_for_loop
nop

bubble_for_loop:

# if i < n-1: -> for_loop_interior: n++
# call bubble for loop again

# a0 = n-1
# a1 = i
srl $t1, $a1, 2
nop
nop
slt $t1, $t1, $a0 # if i < n-1: for loop interior: otherwise, return
nop
nop
bne $t1, $0, for_loop_interior_call
nop

addi $v0, $v0, 0 # return swapped
addi $ra, $s3, 0
nop
nop
jr $ra
nop

# if it gets through, return $v0

for_loop_interior_call:
addi $a1, $a1, 0 # a1 = i
nop
nop
addi $a0, $a1, -4  # a0 = i-1
add $a1, $a1, $t0 # a1 = $a[n]
nop
add $a0, $a0, $t0 # a0 = $a[n-1]
nop
nop

jal for_loop_interior
nop

addi $s1, $s1, 4 # i++
addi $a0, $s0, 0 # a0 = n-1
nop
addi $a1, $s1, 0 # a1 = i
j bubble_for_loop
nop

for_loop_interior:
nop
nop
# if this pair is out of order, tell them to swap
addi $t8, $ra, 0

addi $s7, $0, 0 # swapped = False

# get pair
lw $t4, 0($a0)
lw $t5, 0($a1)
nop
nop
# swapped = if a > b: swap
sgt $t6, $t4, $t5  # if a0 > a1: t6 = 1
nop
nop
bne $t6, $0, swap
nop

or $v0, $s7, $v0 # return swapped
addi $ra, $t8, 0
jr $ra
nop

swap:

# swap items
lw $t4, 0($a0)
lw $t5, 0($a1)
nop
nop
sw $t4, 0($a1)
sw $t5, 0($a0)

# swapped = true
addi $v0, $0, 1
nop
nop
jr $ra
nop

exit:
halt
