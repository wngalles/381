#
# Test Hazard Avoidance of data dependency
#

# data section
.data

# code/instruction section
.text

main:

addi $t0, $0, 2
addi $t0, $t0, 2
addi $t0, $0, 2

exit:
halt