# Kavan Samra
# October 29, 2017


# Data for the program:
.data
welcome_message: .asciiz "Welcome to Conversion \n"
input: .asciiz "Input: "
output: .asciiz "\nOutput: "

.text
main:
	move	 $s0,$a1
	
	lw $s0,($a1) 	#set s0 to contents from input argument
	
	#Display the Welcome Message
	li $v0, 4 	#using syscall 4 (print string)
	la $a0, welcome_message 
	syscall 	# do the syscall.
	
	#Display Input Number	
	li $v0, 4 	#print string syscall 
	la $a0, input	#print "Input: "
	syscall
			#now print input number to console
	la $a0, ($s0)	#s0 contains input value
	syscall
	
	move $t1, $zero		#clear out these two registers, just in case, for later use
	move $t2, $zero
	move $t3, $zero
	move $t4, $zero
	
	#convert ASCII to Decimal 	
	la $t1,($s0) 		#set address of t1 = s0
	lb $s1,($t1) 		#load first byte of $t1 into $s1
	addi $t2, $zero, 10 	#t2 = 10. will be used to multiply by 10
	addi $t3, $zero, 45	#t3 = '-'. Used to check if negative
	addi $s2, $s2, 0
	
	
	end_else:
	while: beq $s1, $zero, end_while	#if t2 contains the null character, exit the while loop
		bne $s1,$t3, else		#if $s1 contains a negative, set a flag, otherwise continue while loop
			addi $t4, $t4, 1	#flag
			addi $t1, $t1, 1	#increment the address pointer by 1 to get the next byte on next run of loop
			lb $s1,($t1)		#load the next character
			b end_else 
			else:
				addi $s1, $s1, -48		#subtract by decimal 48 to get the real decimal value
				mul $s2, $s2, 10
				addu $s2, $s2, $s1		#add to the running sum. $S2 holds final value
				#mul $s2, $s2, $t2		#s2 = s2 * 10
				addi $t1, $t1, 1		#increment the address pointer by 1 to get the next byte on next run of loop
				move $s1, $zero			#clear for the next character
				lb $s1,($t1)			#load the next character
				b while				#continue loop		
	end_while:
	

	bne $t4, 1, positive		#if $t4 is 1...
		negu $s2, $s2		#negate $s2
	positive:			#else, continue with the positive value
	
	######## 		Finished ASCII to Decimal Conversion	################
	
	li $v0, 4	#syscall to print string
	la $a0, ($zero)	#clear just in case of error
	la $a0, output
	syscall
	
	li $v0, 11	#syscall to print char
	la $a0, ($zero)	#clear just in case of error
	
					
	#####################	Convert Decimal to Binary	###################
	
	addi $s5, $zero, 0		#s5 will be the counter for FOR loop
	#addi $s3, $zero, 1	#$s3 will be the bitmask
	lui $s3, 32768		#bitmask 1000000000000000, will use shift right logical
	for: beq $s5, 32, end		#repeat 32 times, one for each bit in a word
		and $s4, $s2, $s3	#bitwise AND
		bnez $s4, if
			la $a0, 48 		#print 0
			syscall
			move $s4, $zero		#clear s4
			srl $s3, $s3, 1		#shift bitmask by one
			addi $s5, $s5, 1	#s5++, increment loop counter by one
			b for			#branch to for		
			
		if:
			la $a0, 49		#print 1
			syscall 
			move $s4, $zero 	#clear s4
			srl $s3, $s3, 1		#shift bitmask by one
			addi $s5, $s5, 1	#s5++, increment loop counter by one
			b for			#branch to for
	end:	
	# EXIT PROGRAM
	li $v0, 10 	# 10 is the exit syscall.
	syscall 	# do the syscall.
