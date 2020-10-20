main:
	lui	$a0,0x8000
	jal	first1pos
	jal	printv0
	lui	$a0,0x0001
	jal	first1pos
	jal	printv0
	li	$a0,1
	jal	first1pos
	jal	printv0
	add	$a0,$0,$0
	jal	first1pos
	jal	printv0
	li	$v0,10
	syscall

first1pos:	
	lui	$t0, 0x8000	#these 3 lines are for the mask
	add	$t1, $zero, $zero
	or	$t0, $t0, $t1

loop:	
	and	$t2, $a0, $t0
	bne	$t2, $zero, end
	addi	$t5, $t5, 1
	add	$t6, $zero, 31
	beq	$t6, $t5,end
	srl	$t0, $t0, 1
	slti	$t4, $t5, 32
	beq	$t4, $zero, negone
	j loop
	
end:
	addi	$t0, $zero, 31
	sub	$v0, $t0, $t5
	jr	$ra
	
negone:
	addi	$v0, $zero, -1
	jr $ra

printv0:
	addi	$sp,$sp,-4
	sw	$ra,0($sp)
	add	$a0,$v0,$0
	li	$v0,1
	syscall
	li	$v0,11
	li	$a0,'\n'
	syscall
	lw	$ra,0($sp)
	addi	$sp,$sp,4
	jr	$ra
