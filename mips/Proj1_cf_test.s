#Recuersive Fib sequesnce
.data
string: .asciiz "Enter a n\n"

.text 

add $sp $zero $zero

#load user n into argument
addi $a0 $zero 10

j Test
halt

Test:

beq $zero $zero Test2
halt

Test2:

jal Fib_Rec

# Print Fib output
add $a0 $zero $v0
addi $v0 $zero 1
syscall

halt

Fib_Rec:
#add user n to s0
add $s0 $zero $a0

#load 2 into t4
add $t4 $zero 2
#compare s0 < 2
slt $t9 $s0 $t4
#branch if t0 >= 2
bne $t9 $zero end

#load n-1 into the first recursion
addi $a0 $s0 -1
#move stack pointer
addi $sp, $sp, -8 
#save return address
sw   $ra, 0($sp)
#save initial n
sw   $s0, 4($sp)

#recurse the first time
jal Fib_Rec
#add return from first recursion to s1
add $s1 $zero $v0

#load the return address back
lw   $ra, 0($sp)
#load the original n back
lw   $s0, 4($sp)
#move stack pointer again
addi $sp, $sp, 8 

#load n-2 into the second recursion
addi $a0 $s0 -2
#move stack pointer
addi $sp, $sp, -12 
#save return address
sw   $ra, 0($sp)
#save initial n
sw   $s0, 4($sp)
#save first return
sw   $s1, 8($sp)

#recurse the second time
jal Fib_Rec
#add return from second recursion to t3 
add $t3 $zero $v0

#load the return address back
lw   $ra, 0($sp)
#load the original n back
lw   $s0, 4($sp)
#load the first return back
lw   $s1, 8($sp)
#move stack pointer again
addi $sp, $sp, 12 

#add recursion from n-1 and n-2
add $s0 $t3 $s1
end:
#return value
add $v0 $zero $s0
jr $ra





