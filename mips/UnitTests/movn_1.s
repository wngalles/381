
 .data
.globl main

main: 
 #test if Movn can 
 addi $t1,$t1,1   #used to store a value
 


#test to see if the value of the register changes when rt does not equal zero
#uesd a value to test these registers to see if the value changes.  This test all the 
#edge cases to ensure they change
movn $0,$1, $t1
 movn $1,$2,$t1
 movn $2,$3,$t1
 movn $3,$4,$t1
 movn $4,$5,$t1
 movn $5,$6,$t1
 movn $6,$7,$t1
 movn $7,$8,$t1
 movn $8,$9,$t1
 movn $31,$0, $t1
 
 #end test
 li $v0, 10
 syscall
 halt
