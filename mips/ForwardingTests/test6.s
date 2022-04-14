#
# Test Hazard Avoidance of control hazard
#

# data section
.data

# code/instruction section
.text

main:

addi $t0, $0, 2
j exit
addi $t0, $t0, 2
addi $t0, $0, 2

exit:
halt