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
	slt	$t0, $a0, $zero		#moves to the end if a0 shows up neg
	bne	$t0, $0, end
	sll	$a0, $a0, 1		#shifts left by one
	addi	$t5, $t5, 1		#we use t5 as a counter
	add	$t6, $zero, 31
	beq	$t6, $t5, end		#a check to see if we moved 31 bits
	slti	$t4, $t5, 32		#a check to see if t5 is 32 or up
	beq	$t4, $zero, negone
	j	first1pos
	
end:
	addi	$t0, $zero, 31
	sub	$v0, $t0, $t5
	jr 	$ra
	
negone:
	addi	$v0, $zero, -1 #-1 = 0
	jr	$ra

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
