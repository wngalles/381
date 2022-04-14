#
# Test Hazard Avoidance of control hazard with a data hazard
#

# data section
.data

# code/instruction section
.text

main:

addi $t0, $0, 2
bne $t0, $0, exit
addi $t0, $0, 2

exit:
halt