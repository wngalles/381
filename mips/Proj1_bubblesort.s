#
# First part of the Lab 3 test program
#

# data section
.data
list: .word 2, 7, 3, 5, 9, 1, 6
size: .word 7

# code/instruction section
.text

main:

lw $s0, size
la $t0, list # starting address of list is in $t0
addi $t1, $zero, 0 # address increment
j check_is_sorted


check_is_sorted:
# loop through an array and check if each element is less than the next element
# if all items are in order, branch to end
# otherwise branch to swap_first_out_of_order
addi $t3, $0, 1 # $t3 represents it being "valid"
j check_conditional


check_body:
# $t4 = list[i], $t5 = list[i+1]
# t6 = i
sll $t6, $t1, 2
add $t6, $t6, $t1
lw $t4, 0($t6)

# list[i+1]
lw $t5, 4($t6)

slt $t6, $t4, $t5 # is list[i] < list[i+1]
and $t3, $t3, $t6 # overall validity is anded with current validity
j check_conditional


check_conditional:
# if i < len(list)-1 -> check body, else, confirm sorted
addi $t4, $s0, 1
slt $t2, $t1, $t4
addi $t5, $0, 1
beq $t2, $t5, check_body
j check_confirm_sorted

check_confirm_sorted:
# if $t3 is 1, it is sorted, otherwise, run the loop on swap_first_out_of_order
slt $t4, $t3, $0
bne $t4, $0 swap_first_out_of_order
j exit 

swap_first_out_of_order:
# iterate through the array.
# when an item is less than the next item, swap the current item with the next item.
# continue 


swap_body:
# $t4 = list[i], $t5 = list[i+1]
# t6 = i
sll $t6, $t1, 2
add $t6, $t6, $t1
lw $t4, 0($t6)

# list[i+1]
lw $t5, 4($t6)

slt $t6, $t4, $t5 # is list[i] < list[i+1]

# if $t6 is 0, swap $t4 and $t5 in memory 
beq $t6, $0, swap_regs
j swap_conditional

swap_regs:
lw $t7, 0($t4)
lw $t8, 0($t5)

sw $t8, 0($t4)
sw $t7, 0($t5)
j swap_conditional


swap_conditional:
# if i < len(list)-1 -> check body, else, confirm sorted
addi $t4, $s0, 1
slt $t2, $t1, $t4
addi $t5, $0, 1
beq $t2, $t5, swap_body
j check_is_sorted





exit: