#
# First part of the Lab 3 test program
#

# data section
.data

# code/instruction section
.text

#j Start

#.text 0x00400080
Start:


addi  $s1,  $0,  1 		# Place “1�? in $1

beq $0 $0 Jump

addi  $2,  $0,  2 
halt

Jump:

addi  $3,  $0,  3



halt
