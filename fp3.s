	.data
	# This shows you can use a .word and directly encode the value in hex
	# if you so choose
num1:	.word 0x58800000 
num2:	.float 1.0
num3:	.word 0xd8800000
result:	.word 0
string: .asciiz "\n"

	.text
main:
	la $t0, num1
	lwc1 $f2, 0($t0)
	lwc1 $f4, 4($t0)
	la $t1, num3
	lwc1 $f5, 0($t1)

	# Print out the values of the summands

	li $v0, 2
	mov.s $f12, $f2
	syscall

	li $v0, 4
	la $a0, string
	syscall

	li $v0, 2
	mov.s $f12, $f4
	syscall

	li $v0, 4
	la $a0, string
	syscall
	
	li $v0, 2
	mov.s $f12, $f5
	syscall
	
	li $v0, 4
	la $a0, string
	syscall
	
	li $v0, 4
	la $a0, string
	syscall

	# Do the actual addition one way

	add.s $f12, $f2, $f5
	add.s $f12, $f12, $f4

	# At this point, $f12 holds the sum, and $s0 holds the sum which can
	# be read in hexadecimal

	li $v0, 2
	syscall
	li $v0, 4
	la $a0, string
	syscall

	# This jr crashes MARS
	# jr $ra
	
	add.s $f12, $f2, $f4
	add.s $f12, $f12, $f5

	# At this point, $f12 holds the sum, and $s0 holds the sum which can
	# be read in hexadecimal

	li $v0, 2
	syscall
	li $v0, 4
	la $a0, string
	syscall

	# This jr crashes MARS
	# jr $ra