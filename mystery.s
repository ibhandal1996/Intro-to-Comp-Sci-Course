	.text

main:
	li $a0, 0
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, 1
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, 196
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, -1
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, -452
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, 7
	jal mystery	
	move $a0, $v0	
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall

	li $a0, 3
	jal mystery
	move $a0, $v0
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall

	li 	$v0, 10		
	syscall

putDec: 	
	li 	$s7, 10
	bne 	$a0, $0, checker
zero:			
	li $a0, '0'
	li $v0, 11
	syscall
	jr $ra		
checker:
	slt	$t0, $a0, $0
	beq 	$t0, $0, loop
			
negative: 
	move $t0, $a0
	li 	$a0, '-'
	li 	$v0, 11
	syscall		
	move $a0, $t0
	sub 	$a0, $0, $a0
loopn:
	beq 	$a0, $0, done
	addi 	$sp, $sp, -8
	sw	$ra, 0($sp)
				
	remu 	$t7, $a0, $s7
	divu 	$a0, $a0, $s7
	addi 	$t7, $t7, 48	
	sb	$t7, 4($sp)
	jal loopn
	lw 	$ra, 0($sp)
	lb	$t7, 4($sp)
	move 	$a0, $t7
	li	$v0, 11
	syscall
	addi 	$sp, $sp, 8
	jr $ra
	
done:	
	jr	$ra		
											
			
loop:
	beq 	$a0, $0, done
	addi 	$sp, $sp, -8
	sw	$ra, 0($sp)
				
	remu 	$t7, $a0, $s7
	divu 	$a0, $a0, $s7
	addi 	$t7, $t7, 48	
	sb	$t7, 4($sp)
	jal loop
	lw 	$ra, 0($sp)
	lb	$t7, 4($sp)
	move 	$a0, $t7
	li	$v0, 11
	syscall
	addi 	$sp, $sp, 8
	jr $ra
	
	jr	$ra		
		
		
mystery: 
	li $t0, 2
	sub $a0, $a0, 1
	sllv $t0, $t0, $a0
	sub $t0, $t0, 1
	move $v0, $t0
	jr $ra