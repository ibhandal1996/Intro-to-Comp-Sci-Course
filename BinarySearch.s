.data 

original_list: .space 100 
sorted_list: .space 100

str0: .asciiz "Enter size of list (between 1 and 25): "
str1: .asciiz "Enter one list element: \n"
str2: .asciiz "Content of list: "
str3: .asciiz "Enter a key to search for: "
strYes: .asciiz "Key found!"
strNo: .asciiz "Key not found!"
space: .asciiz " "
nextLine: .asciiz "\n"


.text 

#This is the main program.
#It first asks user to enter the size of a list.
#It then asks user to input the elements of the list, one at a time.
#It then calls printList to print out content of the list.
#It then calls inSort to perform insertion sort
#It then asks user to enter a search key and calls bSearch on the sorted list.
#It then prints out search result based on return value of bSearch
main: 
	addi $sp, $sp -8
	sw $ra, 0($sp)
	li $v0, 4 
	la $a0, str0 
	syscall 
	li $v0, 5	#Read size of list from user
	syscall
	move $s0, $v0
	move $t0, $0
	la $s1, original_list
loop_in:
	li $v0, 4 
	la $a0, str1 
	syscall 
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	li $v0, 5	#Read elements from user
	syscall
	sw $v0, 0($t1)
	addi $t0, $t0, 1
	bne $t0, $s0, loop_in
	
	li $v0, 4 
	la $a0, str2 
	syscall 
	move $a0, $s1
	move $a1, $s0
	jal printList	#Call print original list
	
	jal inSort	#Call inSort to perform insertion sort in original list
	sw $v0, 4($sp)
	li $v0, 4 
	la $a0, str2 
	syscall 
	lw $a0, 4($sp)
	jal printList	#Print sorted list
	
	li $v0, 4 
	la $a0, str3 
	syscall 
	li $v0, 5	#Read search key from user
	syscall
	move $a2, $v0	#a2 = binary search value
	lw $a0, 4($sp)
	jal bSearch	#Call bSearch to perform binary search
	
	beq $v0, $0, notFound
	li $v0, 4 
	la $a0, strYes 
	syscall 
	j end
	
notFound:
	li $v0, 4 
	la $a0, strNo 
	syscall 
end:
	lw $ra, 0($sp)
	addi $sp, $sp 8
	li $v0, 10 
	syscall
	
	
#printList takes in a list and its size as arguments. 
#It prints all the elements in one line.
printList:
	addi $sp, $sp, -8
	sw $ra, 0($sp)		# save Callee Address
	sw $a0, 4($sp)		# save OG array
	
	move $t0, $a0		# $t0 = array
	move $t1, $a1		# $t1 = size
	move $t2, $0		# $t2 = counter
loop:
	beq $t2, $t1, exitPrint	# if counter equals size, exit print
	
	li $v0, 1		# print val
	lw $a0, 0($t0)
	syscall
	
	li $v0, 4		# print space
	la $a0, space
	syscall
	
	addi $t0, $t0, 4	# next element address
	addi $t2, $t2, 1	# counter + 1
	j loop			# jump back to loop 
exitPrint:
	li $v0, 4		# print next line
	la $a0, nextLine
	syscall
	
	lw $ra, 0($sp)		# load OG content back in regs
	lw $a0, 4($sp)	
	addi $sp, $sp, 8
	jr $ra
	
#inSort takes in a list and it size as arguments. 
#It performs INSERTION sort in ascending order and returns a new sorted list
#You may use the pre-defined sorted_list to store the result
inSort:
	move $t0, $a0 		# $t0 = array
	move $t1, $a1 		# $t1 = size
	li $t2, 1 		# counter = 1
Loop1:
	beq $t2, $t1, exitLoop	# while counter < size 
	move $t3, $t2 		#$t3 = index, index = counter
Loop2:
	move $t0, $a0		# $t0 = array
	sll $t4, $t3, 2		# $t4 = index * 4
	add $t0, $t0, $t4 	# address of array + $t4
	beq $t3, 0, next 	# while index > 0
	lw $t5, 0($t0)		# $t5 = array[index]
	lw $t6, -4($t0)		# $t6 = array[index-1] 
	bge $t5, $t6, next	# if array[index] >= array[index-1], incerement counter
	lw $t7, 0($t0)		# $t7 = array[index]
	sw $t6, 0($t0)		# $t6 = array[index]
	sw $t7, -4($t0)		# $t7 = array[index-1]
	addi $t3, $t3, -1	# counter - 1
	j Loop2

next:
	addi $t2, $t2, 1 	# counter + 1
	j Loop1

exitLoop:
	la $v0, 0($a0)
	addi $s5, $0, 25	
	move $t3, $0		# set $t3 = 0 for later use
	jr $ra

#bSearch takes in a list, its size, and a search key as arguments. https://stackoverflow.com/questions/19212544/sorting-array-in-mips-assembly
#It performs binary search RECURSIVELY to look for the search key.
#It will return a 1 if the key is found, or a 0 otherwise.
#Note: you MUST NOT use iterative approach in this function.
bSearch:
	beq $t3, $0, bInitial	# if $t3 = 0 then go to bInitial
	
	move $t6, $0		#resets $t6
	beq $s5, $0, no_return	#if counter = 0 then search not found
	
	addi $s5, $s5, -1	#subtracts counter by 1
	sll $t2, $s4, 2		#shifts size by 4
	add $t1, $0, $s1	#loads array
	add $t1, $t2, $t1	#shifts the array
	
	lw $t6, ($t1)		#loads array element
	beq $t6, $s2, return	#ends loop if found
	slt $t8, $t6, $s2	#checks if the checked element is greater or less than the value we are looking for
	beq $t8, $0, front	#if slt returns zero we go to the fron hald
	j back			#jumps to back if front is juped to
	jal bSearch
bInitial:
	move $t0, $0		#counter = 0
	move $t1, $0		#t1 = 0
	addi $t3, $0, 1
	sll $t1, $t0, 2		# 0 -> 4
	add $t1, $t1, $s1	#t1 = arr
	add $t6, $0, 1		#t6 = True, used to terminate if no match
	add $s2, $0, $a2	#arg -> s2
	move $v0, $0		#$v0 = 0 for syscall
	add $s4, $s0, $0	
	div $s4, $s4, 2		#size div 2
	j bSearch
front:				#moves to the front half of the array
	addi $s4, $s4, -1
	add $s0, $s4, $0
	j bSearch
back:				#moves to the back half of the array
	addi $s4, $s4, 1
	add $a3, $0, $s4
	j bSearch
return: 			#returns that the search element was found
	add $v0, $0, 1
	jr $ra
no_return:			#return that the search element was not found
	jr $ra

	
	
