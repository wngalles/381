#
# First part of the Lab 3 test program
#

# data section
.data

# code/instruction section
.text

#j Start

.text 
Start:


addi  $s1,  $0,  1 		# Place “1�? in $1

jal Jump

addi  $2,  $0,  2 
halt

.data
.text 
Jump:

addi  $3,  $0,  3

jr $ra



halt
