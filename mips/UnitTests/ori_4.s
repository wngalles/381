.data
.text
.globl main

main:
    ori $1, $0, 0xFFFF # Verify 0x0000 or with 0xFFFF is 0xFFFF
    ori $2, $1, 0xFFFF # Verify 0xFFFF or with 0xFFFF is 0xFFFF
    ori $3, $2, 0x0000 # Verify 0xFFFF or with 0x0000 is 0xFFFF
    ori $4, $0, 0x0000 # Verify 0x0000 or with 0x0000 is 0x0000
    lui $5, 0xFFFF
    ori $5, $5, 0x0000 # Verify 0xFFFF0000 or with 0x0000 is 0xFFFF0000
    ori $6, $5, 0xFFFF # Verify 0xFFFF0000 or with 0xFFFF is 0xFFFFFFFF

    li $v0, 10
    syscall
    halt
