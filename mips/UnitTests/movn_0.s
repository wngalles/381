.data
.text
.globl main

main: 
 

#test to see if the value of the fd stays the same when rs equals zero
#testing the edge values to ensure that they dont change their values when rs equals zero
movn $0, $1,$zero
 movn $2,$3,$zero
 movn $3,$4,$zero
 movn $4,$5,$zero
 movn $5,$6,$zero
 movn $6,$7,$zero
 movn $7,$8,$zero
 movn $8,$9,$zero
 movn $31,$0,$zero
 
 #end test
 li $v0, 10
 syscall
 halt
