# Kavan Samra
# November 13th, 2017

.data
prompt: .asciiz "Enter a positive integer value: "
commas: .asciiz ", "

.text

	li $v0, 4	# syscall 4 to print welcome prompt
	la $a0, prompt	# load prompt into $a0
	syscall		# do the syscall
	
	li $v0, 5	# syscall 5 to read integer
	syscall
	
	move $s0, $v0	# s0 holds the value entered by the user
	
	la $a0, ($s0)	# move the value entered by user into a0 to determine 
			# numOfItems in the array			
	mulu $a0, $a0, 4 # numOfItems = numOfItems * 4
			# This will allocate an array on the heap with numOfItems items, each 
			#  1 word in length
			
	li $v0, 9	# syscall to dynamically allocate memory using the heap
	syscall
	
	la $s1, ($v0)	# s1 will hold the address of the allocated array
	move $t1, $zero	# clear for later use in case they were modified by the syscall
	move $t2, $zero
	move $t3, $zero
	move $t4, $zero
	move $t5, $zero
	move $t6, $zero
	# Now that the array has been allocated, fill each element of the array
	# with the values starting from 2 all the way to n.
	
	# int value = 2;
	# for (int i = 0; i < s0; i++){
	# 	array[i] = value;
	#	value++;
	# }
	addi $t1, $zero, 2	# int value = 2;
	addi $t2, $zero, 0	# int i = 0;
	la $s2, ($s1)		# s2 will hold base pointer to array
	fillArray: beq $t2, $s0, end 	# i < numOfItems
		sw $t1,($s1)	# value placed in array
		addiu $s1, $s1, 4 	#increment array pointer by 4 to move to next word element
		addiu $t1, $t1, 1 # add one to Value
		addiu $t2, $t2, 1 # increment loop counter
		b fillArray
	end:
	move $t1, $zero		#clear because values don't matter anymore
	move $t2, $zero
	
	############################# Sieve Method ########################################
	
	la $s3, ($s2)		# $s3 will also hold base pointer to the array
	lw $t3, ($s3) 		# p = 2
	addu $t6, $zero, $t3	# p = 2, this version will be squared for checking p^2 > n in while loop
	mulu $t3, $t3, 4	# move on aligment with word boundary
	mulu $t5, $t6, $t6 	# p^2 (conditional version) 
	addu $s3, $s3, $t3 	# adjust pointer to start at p^2 (which is 8 here)
	while: bgtu $t5, $s0, done			# branch if p^2 > n
		for: bgeu $s3, $s1, nextP		# loop until s3 >= s1, which points to back of list	(t4, s0)loop from 0 to n - 1 (might have to change to n-2??)
			sw $zero, ($s3)			# modify value at destination to 0 
			addu $s3, $s3, $t3 		# increment pointer to array by p (or 4 * p?)
			b for
		nextP:
		move $t2, $zero	
		addiu $t1, $t1, 4	# offset counter
		la $s3, ($s2)		# set $s3 back to base pointer
		addu $s3, $s3, $t1	# increment base pointer to point to next p value
		if: lw $t3, ($s3)	# make t3 the next p
		bnez $t3, else		#if t3 == 0, check next word 
			addiu $s3, $s3, 4	# check next word
			addiu $t1, $t1, 4
			b if
		else:
		move $t5, $zero
		mulu $t5, $t3, $t3	# p^2 conditional
		mulu $t3, $t3, 4	# p * 4 for correct word boundary
		addi $t2, $t5, -2	# To reach p^2 place, ((p^2 - 2)) * 4)
		mulu $t2, $t2, 4
		la $s3, ($s2)		
		addu $s3, $s3, $t2 	# Start the loop at p^2's place 
		b while	 
	done:
	
	################## PRINT PRIMES ###########################
	li $v0, 1		#syscall to print integer
	move $a0, $zero		#clear incase of error
	addiu $s4, $s4, 2		#int i = 2
	move $a0, $zero			#clear incase of error
	lw $a0, ($s2)
	syscall
	addiu $s2, $s2, 4	#increment pointer to next word
	printNum: beq $s4, $s0, printDone
		move $a0, $zero			#clear incase of error
		li $v0, 4		# syscall to print character. Will be used to print ', '
		la $a0, commas 		# ", "
		syscall
		li $v0, 1			#syscall to print integer
		zero: lw $a0, ($s2) 		#load word at $s2 into $a0 to print
		bnez $a0, continuePrint		#if number = 0, check next value
			addiu $s2, $s2, 4	#increment pointer to next word
			addiu $s4, $s4, 1	#increment loop counter
			bge $s2, $s1 quit	#break out of loop if s2 is equal to end of list
			bge $s4, $s0, quit 
			b zero			# branch back to zero to recheck if a0 == 0
		continuePrint:
		syscall
		addiu $s2, $s2, 4	#increment pointer to get next word
		addiu $s4, $s4, 1	#increment loop counter
		b printNum		
	printDone:
	quit:	
	##### EXIT PROGRAM #####
	li $v0, 10 	# 10 is the exit syscall.
	syscall
