# Kavan Samra
# November 26th, 2017
.data
	label0: .asciiz "The given key is: "
	label1: .asciiz "\nThe given text is: "
	label2: .asciiz "\nThe encrypted text is: "
	label3: .asciiz "\nThe decrypted text is: "

	encodedText: .space 100
	decodedText: .space 100
.text
	# main
	lw $s0, 0($a1) 		# s0 will hold the ADDRESS of key
	lw $s1, 4($a1)		# s1 will hold the ADDRESS of cleartext
	la $s2, encodedText	# s2 will hold the ADDRESS of encodedText
	la $s3, decodedText	# s3 will hold the ADDRESS of decodedText
	
	li $v0, 4 		# syscall for printString
	la $a0, label0 		# print label0
	syscall
	la $a0, 0($s0) 		# print the key
	syscall
	la $a0, label1		# print label1
	syscall
	la $a0, ($s1)		# print the givenText
	syscall
	move $t0, $zero
	# while loop to calculate lengthKey
	lbu $t0, ($s0)  	# load first char of key in t0;
	ble $t0, 128, doneIf
		addi $t0, $t0, -128
	doneIf:
	move $t1, $zero 	# int lengthKey = 0
	lengthKey: beq $t0, $zero, done0	# branch if char is a null char.
		addi $t1, $t1, 1	# lengthKey = lengthKey + 1;
		addi $s0, $s0, 1	# increment pointer to key by one char
		lbu $t0, ($s0)		# load next char of key
		ble $t0, 128, doneIf2
		addi $t0, $t0, -128
	doneIf2:
		b lengthKey		# recheck conditional
	done0: 
	
	sub $s0, $s0, $t1	# reset pointer to key back to it's base address
		
	#while loop to calculate lengthChar
	lbu $t0, 0($s1) 		#load first char of clearText in t0
	move $t2, $zero			#int lengthChar = 0	
	lengthChar: beq $t0, $zero, done1 	# branch if char is null char
		addi $t2, $t2, 1 	# lengthChar = lengthChar + 1;
		addi $s1, $s1, 1	# increment pointer to clearText by one char
		lbu $t0, ($s1)		# load next char of clearText
		b lengthChar		# recheck conditional
	done1:
	
	sub $s1, $s1, $t2 	# reset pointer to clearText back to it's base address
	jal encode 		#Call encode function
	
	la $a0, label2		# print label2
	syscall
	la $a0, ($s2)		#print encodedText
	syscall
	
	jal decode		# decode text Function
	
	la $a0, label3		#print label3
	syscall
	la $a0, ($s3) 		#print decodedText
	syscall
	
	
	# exit
	li $v0, 10
	syscall
	
.text
# Functions for encoding and decoding the givenText using the key by method of Vigenere Cipher

#Inputs:
# $s0 -> key
# $s1 -> clearText
# $s2 -> encodedText
# $s3 -> decodedText
# $t1 -> lengthKey
# $t2 -> lengthChar

# Outputs: If storing a value to a register is considered an output then my outputs are
# $s2 -> encodedText
# $s3 -> decodedText
encode:
	la $s5, ($ra) 	#store return address to main in s5
	move $t0, $zero			# int i = 0
	move $t4, $zero
	addi $t4, $t4, 128		# const ASCII = 128
	forEncode: bgeu $t0, $t2, done2 #branch if i == lengthChar ORIGINALLY T3, T2, DONE2!!
		remu $t5, $t0, $t1 		# t5 = ( i % lengthKey )		
		addu $s0, $s0, $t5
		lbu $t6, ($s0) 		# t6 = key[i % lengthKey]
		lbu $t7, ($s1) 		# t7 = clearText[i]
		addu $s4, $t7, $t6 	# s3 = (clearText[i] + key[i % lengthKey])
		subu $s0, $s0, $t5	#reset for next iteration
		move $t5, $zero
		remu $t5, $s4, $t4 	# t5 = ((clearText[i] + key[i % lengthKey]) % 128)
		move $s4, $zero		# clear for use on next iteration
		sb $t5, ($s2) 		# encodedText [i] = t5
		addiu $t0, $t0, 1	# int i = i + 1
		addiu $s2, $s2, 1	# increment encodedText pointer to next character
		addiu $s1, $s1, 1	# increment clearText pointer to next character
		b forEncode		   
	done2:
	sub $s1, $s1, $t0 	# reset pointer to clearText to base address
	sub $s2, $s2, $t0 	# reset pointer to encodedText to base address
	addu $s2, $s2, $t2	# move to encodedText[lenghChar]
	sb $zero, ($s2) 	# encodedText[lengthChar] = '\0';
	sub $s2, $s2, $t2 	# reset pointer to encodedText to base address 
	jr $s5			# return to main

decode:
	la $s5, ($ra)
	move $t0, $zero		#int i = 0
	move $s4, $zero 	
	move $t4, $zero
	addi $t4, $t4, 128
	forDecode: bgeu $t0, $t2, doneDecode
		remu $t5, $t0, $t1 	# t5 = (i%lengthKey)
		addu $s0, $s0, $t5 	# key [i%lengthKey]
		lbu $t6, ($s0) 		# t6 = key[i%lengthKey]
		lbu $t7, ($s2) 		# t7 = encodedText[i]
		subu $s4, $t7, $t6 	# s4 = (encodedText[i] - key[i%lengthKey])
		subu $s0, $s0, $t5	#reset for next iteration
		move $t5, $zero
		remu $t5, $s4, $t4 	# t5 = ((encodedText[i] - key[i%lengthKey]) % 128)
		move $s4, $zero		#clear for use on next iteration
		sb $t5, ($s3) 		# decodedText[i] = t5
		addiu $t0, $t0, 1	# i++
		addiu $s3, $s3, 1	# increment decodedText pointer to next character
		addiu $s2, $s2, 1	# increment encodedText pointer to next character
		b forDecode
	doneDecode:
	sub $s3, $s3, $t0
	addu $s3, $s3, $t2 	# move to decodedText[lengthChar]
	sb $zero, ($s3)		# store null character at decodedText[lengthChar]
	subu $s3, $s3, $t2	# move back to base address
	jr $s5			# return to main 
