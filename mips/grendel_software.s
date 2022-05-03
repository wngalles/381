
#
# Topological sort using an adjacency matrix. Maximum 4 nodes.
# 
# The expected output of this program is that the 1st 4 addresses of the data segment
# are [4,0,3,2]. should take ~2000 cycles in a single cycle procesor.
#
.data
res:
	.word -1-1-1-1
nodes:
        .byte   97 # a
        .byte   98 # b
        .byte   99 # c
        .byte   100 # d

adjacencymatrix:

        .word   6
        .word   0
        .word   0
        .word   3

visited:
	.byte 0 0 0 0

res_idx:
        .word   3
.text

lui $sp, 0x1001
nop
nop
ori $sp, 0x1000
nop
nop
addi $fp, $0, 0
nop
nop
lasw $ra, pump
nop
nop
j main # jump to the starting location
		nop
		nop
pump:
		nop
		nop
        halt
		nop
		nop
		nop
		nop
		nop
		nop
main:
		nop
		nop
        addiu   $sp,$sp,-40 # MAIN
		nop
		nop
        sw      $31,36($sp)
		nop
		nop
        sw      $fp,32($sp)
		nop
		nop
        add     $fp,$sp,$zero
		nop
		nop
        sw      $0,24($fp)
		nop
		nop
        j       main_loop_control
		nop
		nop
        
		nop
		nop
main_loop_body:
		nop
		nop
        lw      $4,24($fp)
		nop
		nop
        lasw      $ra, trucks
		nop
		nop
        j     is_visited
		nop
		nop
        trucks:
		nop
		nop
		nop
		nop
        xori    $2,$2,0x1
		nop
		nop
        andi    $2,$2,0x00ff
		nop
		nop
        beq     $2,$0,kick
		nop
		nop
		nop
		nop
        lw      $4,24($fp)
		nop
		nop
        # addi  $k0, $k0,1# breakpoint
		nop
		nop
        lasw      $ra, billowy
		nop
		nop
        j       topsort
		nop
		nop
        billowy:
		nop
		nop
		nop
		nop
kick:
		nop
		nop
        lw      $2,24($fp)
		nop
		nop
        addiu   $2,$2,1
		nop
		nop
        sw      $2,24($fp)
		nop
		nop
main_loop_control:
		nop
		nop
        lw      $2,24($fp)
		nop
		nop
        slti     $2,$2, 4
		nop
		nop
        beq     $2, $zero, hew # beq, j to simulate bne 
		nop
		nop
        j       main_loop_body
		nop
		nop
        hew:
		nop
		nop
        sw      $0,28($fp)
		nop
		nop
        j       welcome
		nop
		nop
		nop
		nop
wave:
		nop
		nop
        lw      $2,28($fp)
		nop
		nop
        addiu   $2,$2,1
		nop
		nop
        sw      $2,28($fp)
		nop
		nop
welcome:
		nop
		nop
        lw      $2,28($fp)
		nop
		nop
        slti    $2,$2,4
		nop
		nop
        xori    $2,$2,1 # xori 1, beq to simulate bne where val in [0,1]
		nop
		nop
        beq     $2,$0,wave
		nop
		nop
		nop
		nop
        move    $2,$0
		nop
		nop
        move    $sp,$fp
		nop
		nop
        lw      $31,36($sp)
		nop
		nop
        lw      $fp,32($sp)
		nop
		nop
        addiu   $sp,$sp,40
		nop
		nop
        jr       $ra
		nop
		nop
        
		nop
		nop
interest:
		nop
		nop
        lw      $4,24($fp)
		nop
		nop
        lasw      $ra, new
		nop
		nop
        j       is_visited
		nop
		nop
        new:
		nop
		nop
        xori    $2,$2,0x1
		nop
		nop
        andi    $2,$2,0x00ff
		nop
		nop
        beq     $2,$0,tasteful
		nop
		nop
		nop
		nop
        lw      $4,24($fp)
		nop
		nop
        lasw      $ra, partner
		nop
		nop
        j       topsort
		nop
		nop
        partner:
		nop
		nop
		nop
		nop
tasteful:
		nop
		nop
        addiu   $2,$fp,28
		nop
		nop
        move    $4,$2
		nop
		nop
        lasw      $ra, badge
		nop
		nop
        j     next_edge
		nop
		nop
        badge:
		nop
		nop
        sw      $2,24($fp)
		nop
		nop
        
		nop
		nop
turkey:
		nop
		nop
        lw      $3,24($fp)
		nop
		nop
        addi      $2, $0, -1
		nop
		nop
        beq     $3,$2,telling # beq, j to simulate bne
		nop
		nop
        j       interest
		nop
		nop
        telling:
		nop
		nop
        lasw      $v0, res_idx
		nop
		nop
        lw      $v0, 0($v0)
		nop
		nop
        addiu   $4,$2,-1
		nop
		nop
        lasw      $3, res_idx
		nop
		nop
        sw      $4, 0($3)
		nop
		nop
        lasw      $4, res
		nop
		nop
        #lui     $3,%hi(res_idx)
		nop
		nop
        #sw      $4,%lo(res_idx)($3)
		nop
		nop
        #lui     $4,%hi(res)
		nop
		nop
        sll     $3,$2,2
		nop
		nop
        srl     $3,$3,1
		nop
		nop
        sra     $3,$3,1
		nop
		nop
        sll     $3,$3,2
		nop
		nop
       
		nop
		nop
        xor     $at, $ra, $2 # does nothing 
		nop
		nop
        nor     $at, $ra, $2 # does nothing 
		nop
		nop
        
		nop
		nop
        lasw      $2, res
		nop
		nop
        andi    $at, $2, 0xffff # -1 will sign extend (according to assembler), but 0xffff won't
		nop
		nop
        addu    $2, $4, $at
		nop
		nop
        addu    $2,$3,$2
		nop
		nop
        lw      $3,48($fp)
		nop
		nop
        sw      $3,0($2)
		nop
		nop
        move    $sp,$fp
		nop
		nop
        lw      $31,44($sp)
		nop
		nop
        lw      $fp,40($sp)
		nop
		nop
        addiu   $sp,$sp,48
		nop
		nop
        jr      $ra
		nop
		nop
   
		nop
		nop
topsort:
		nop
		nop
        addiu   $sp,$sp,-48
		nop
		nop
        sw      $31,44($sp)
		nop
		nop
        sw      $fp,40($sp)
		nop
		nop
        move    $fp,$sp
		nop
		nop
        sw      $4,48($fp)
		nop
		nop
        lw      $4,48($fp)
		nop
		nop
        lasw      $ra, verse
		nop
		nop
        j       mark_visited
		nop
		nop
        verse:
		nop
		nop
		nop
		nop
        addiu   $2,$fp,28
		nop
		nop
        lw      $5,48($fp)
		nop
		nop
        move    $4,$2
		nop
		nop
        lasw      $ra, joyous
		nop
		nop
        j       iterate_edges
		nop
		nop
        joyous:
		nop
		nop
		nop
		nop
        addiu   $2,$fp,28
		nop
		nop
        move    $4,$2
		nop
		nop
        lasw      $ra, whispering
		nop
		nop
        j       next_edge
		nop
		nop
        whispering:
		nop
		nop
		nop
		nop
        sw      $2,24($fp)
		nop
		nop
        j       turkey
		nop
		nop
		nop
		nop
iterate_edges:
		nop
		nop
        addiu   $sp,$sp,-24
		nop
		nop
        sw      $fp,20($sp)
		nop
		nop
        move    $fp,$sp
		nop
		nop
        subu    $at, $fp, $sp
		nop
		nop
        sw      $4,24($fp)
		nop
		nop
        sw      $5,28($fp)
		nop
		nop
        lw      $2,28($fp)
		nop
		nop
        sw      $2,8($fp)
		nop
		nop
        sw      $0,12($fp)
		nop
		nop
        lw      $2,24($fp)
		nop
		nop
        lw      $4,8($fp)
		nop
		nop
        lw      $3,12($fp)
		nop
		nop
        sw      $4,0($2)
		nop
		nop
        sw      $3,4($2)
		nop
		nop
        lw      $2,24($fp)
		nop
		nop
        move    $sp,$fp
		nop
		nop
        lw      $fp,20($sp)
		nop
		nop
        addiu   $sp,$sp,24
		nop
		nop
        jr      $ra
		nop
		nop
        
		nop
		nop
next_edge:
		nop
		nop
        addiu   $sp,$sp,-32
		nop
		nop
        sw      $31,28($sp)
		nop
		nop
        sw      $fp,24($sp)
		nop
		nop
        add     $fp,$zero,$sp
		nop
		nop
        sw      $4,32($fp)
		nop
		nop
        j       waggish
		nop
		nop
		nop
		nop
snail:
		nop
		nop
        lw      $2,32($fp)
		nop
		nop
        lw      $3,0($2)
		nop
		nop
        lw      $2,32($fp)
		nop
		nop
        lw      $2,4($2)
		nop
		nop
        move    $5,$2
		nop
		nop
        move    $4,$3
		nop
		nop
        lasw      $ra,induce
		nop
		nop
        j       has_edge
		nop
		nop
        induce:
		nop
		nop
        beq     $2,$0,quarter
		nop
		nop
        lw      $2,32($fp)
		nop
		nop
        lw      $2,4($2)
		nop
		nop
        addiu   $4,$2,1
		nop
		nop
        lw      $3,32($fp)
		nop
		nop
        sw      $4,4($3)
		nop
		nop
        j       cynical
		nop
		nop
		nop
		nop
		nop
		nop
quarter:
		nop
		nop
        lw      $2,32($fp)
		nop
		nop
        lw      $2,4($2)
		nop
		nop
        addiu   $3,$2,1
		nop
		nop
        lw      $2,32($fp)
		nop
		nop
        sw      $3,4($2)
		nop
		nop
		nop
		nop
waggish:
		nop
		nop
        lw      $2,32($fp)
		nop
		nop
        lw      $2,4($2)
		nop
		nop
        slti    $2,$2,4
		nop
		nop
        beq     $2,$zero,mark # beq, j to simulate bne 
		nop
		nop
        j       snail
		nop
		nop
        mark:
		nop
		nop
        addi      $2, $0, -1
		nop
		nop
		nop
		nop
cynical:
		nop
		nop
        move    $sp,$fp
		nop
		nop
        lw      $31,28($sp)
		nop
		nop
        lw      $fp,24($sp)
		nop
		nop
        addiu   $sp,$sp,32
		nop
		nop
        jr      $ra
		nop
		nop
has_edge:
		nop
		nop
        addiu   $sp,$sp,-32
		nop
		nop
        sw      $fp,28($sp)
		nop
		nop
        move    $fp,$sp
		nop
		nop
        sw      $4,32($fp)
		nop
		nop
        sw      $5,36($fp)
		nop
		nop
        lasw      $2,adjacencymatrix
		nop
		nop
        lw      $3,32($fp)
		nop
		nop
        sll     $3,$3,2
		nop
		nop
        addu    $2,$3,$2
		nop
		nop
        lw      $2,0($2)
		nop
		nop
        sw      $2,16($fp)
		nop
		nop
        addi      $2, $0, 1
		nop
		nop
        sw      $2,8($fp)
		nop
		nop
        sw      $0,12($fp)
		nop
		nop
        j       measley
		nop
		nop
		nop
		nop
look:
		nop
		nop
        lw      $2,8($fp)
		nop
		nop
        sll     $2,$2,1
		nop
		nop
        sw      $2,8($fp)
		nop
		nop
        lw      $2,12($fp)
		nop
		nop
        addiu   $2,$2,1
		nop
		nop
        sw      $2,12($fp)
		nop
		nop
measley:
		nop
		nop
        lw      $3,12($fp)
		nop
		nop
        lw      $2,36($fp)
		nop
		nop
        slt     $2,$3,$2
		nop
		nop
        beq     $2,$0,experience # beq, j to simulate bne 
		nop
		nop
        j       look
		nop
		nop
        experience:
		nop
		nop
        lw      $3,8($fp)
		nop
		nop
        lw      $2,16($fp)
		nop
		nop
        and     $2,$3,$2
		nop
		nop
        slt     $2,$0,$2
		nop
		nop
        andi    $2,$2,0x00ff
		nop
		nop
        move    $sp,$fp
		nop
		nop
        lw      $fp,28($sp)
		nop
		nop
        addiu   $sp,$sp,32
		nop
		nop
        jr      $ra
		nop
		nop
        
		nop
		nop
mark_visited:
		nop
		nop
        addiu   $sp,$sp,-32
		nop
		nop
        sw      $fp,28($sp)
		nop
		nop
        move    $fp,$sp
		nop
		nop
        sw      $4,32($fp)
		nop
		nop
        addi      $2, $0, 1
		nop
		nop
        sw      $2,8($fp)
		nop
		nop
        sw      $0,12($fp)
		nop
		nop
        j       recast
		nop
		nop
		nop
		nop
example:
		nop
		nop
        lw      $2,8($fp)
		nop
		nop
        sll     $2,$2,8
		nop
		nop
        sw      $2,8($fp)
		nop
		nop
        lw      $2,12($fp)
		nop
		nop
        addiu   $2,$2,1
		nop
		nop
        sw      $2,12($fp)
		nop
		nop
recast:
		nop
		nop
        lw      $3,12($fp)
		nop
		nop
        lw      $2,32($fp)
		nop
		nop
        slt     $2,$3,$2
		nop
		nop
        beq     $2,$zero,pat # beq, j to simulate bne
		nop
		nop
        j       example
		nop
		nop
        pat:
		nop
		nop
		nop
		nop
        lasw      $2, visited
		nop
		nop
        sw      $2,16($fp)
		nop
		nop
        lw      $2,16($fp)
		nop
		nop
        lw      $3,0($2)
		nop
		nop
        lw      $2,8($fp)
		nop
		nop
        or      $3,$3,$2
		nop
		nop
        lw      $2,16($fp)
		nop
		nop
        sw      $3,0($2)
		nop
		nop
        move    $sp,$fp
		nop
		nop
        lw      $fp,28($sp)
		nop
		nop
        addiu   $sp,$sp,32
		nop
		nop
        jr      $ra
		nop
		nop
        
		nop
		nop
is_visited:
		nop
		nop
        addiu   $sp,$sp,-32
		nop
		nop
        sw      $fp,28($sp)
		nop
		nop
        move    $fp,$sp
		nop
		nop
        sw      $4,32($fp)
		nop
		nop
        ori     $2,$zero,1
		nop
		nop
        sw      $2,8($fp)
		nop
		nop
        sw      $0,12($fp)
		nop
		nop
        j       evasive
		nop
		nop
		nop
		nop
justify:
		nop
		nop
        lw      $2,8($fp)
		nop
		nop
        sll     $2,$2,8
		nop
		nop
        sw      $2,8($fp)
		nop
		nop
        lw      $2,12($fp)
		nop
		nop
        addiu   $2,$2,1
		nop
		nop
        sw      $2,12($fp)
		nop
		nop
evasive:
		nop
		nop
        lw      $3,12($fp)
		nop
		nop
        lw      $2,32($fp)
		nop
		nop
        slt     $2,$3,$2
		nop
		nop
        beq     $2,$0,representitive # beq, j to simulate bne
		nop
		nop
        j       justify
		nop
		nop
        representitive:
		nop
		nop
		nop
		nop
        lasw      $2,visited
		nop
		nop
        lw      $2,0($2)
		nop
		nop
        sw      $2,16($fp)
		nop
		nop
        lw      $3,16($fp)
		nop
		nop
        lw      $2,8($fp)
		nop
		nop
        and     $2,$3,$2
		nop
		nop
        slt     $2,$0,$2
		nop
		nop
        andi    $2,$2,0x00ff
		nop
		nop
        move    $sp,$fp
		nop
		nop
        lw      $fp,28($sp)
		nop
		nop
        addiu   $sp,$sp,32
		nop
		nop
        jr      $ra
		nop
		nop
