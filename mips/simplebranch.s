main:
	ori $s0, $zero 0x1234
	j skip
	nop
	lui $s0 0xffff
	nop
	nop
	ori $s0 0xffff
skip:
	ori $s1 $zero 0x1235
	nop
	nop
	beq $s0 $s1 skip2
	nop
	lui $s0 0xffff
	nop
	nop
	ori $s0 0xffff
skip2:
	jal fun
	nop
	ori $s3 $zero 0x1236
	
	beq $s0, $zero exit
	nop
	ori $s4 $zero 0x1237
	j exit
	nop
fun:
	ori $s2 $zero 0x1238
	jr $ra
	nop
exit:
	halt

