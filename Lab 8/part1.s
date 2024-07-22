# Program that counts consecutive 1’s.
.global _start
.text
_start:
	#main where you take in each item in list, needs to be a loop
	#within the loop, call ONES
	#store the sum in a0, use the sum to compare to previous
	#then the largest number of 1s should be in s10 final
	
	#within this loop use jal ONES
	
	addi t4, zero, 0
	addi t6, zero, -1
	la s1, LIST #address of start of list
	addi s10, zero, 0 #contains the final answer

LOOP:
  	addi a0, zero, 0 #conntains result of subroutine
  	slli t5, t4, 2 #multiply by 4
	add t2, s1, t5 #update address but keep the original as s1
	lw t3 0(t2) #load word at new address
	addi t4, t4, 1 #add 1 so it will increment  
	beq t3, t6, END #if equal to -1 (or 0xFFFFFFFF) then break
	add a1, s1, zero #copy of perm address to manipulate in loop
	#i did this instead of stack because i use ONES as a loop, and sw gets rewritten each time
	jal ONES
	#after done ONES it will come here where pc is to restart loop for next word
	bge a0, s10, THEN #only if greater change s10
	j LOOP

THEN:
	add s10, zero, a0 #then add a0 as the new value
	j LOOP

ONES: #i did not need to use a stack? did i do something wrong?
	addi sp, sp -8
	sw ra, 0(sp)
	sw a1, 4(sp)
	
SETUP:	beqz t3, ELSE #return to start main loop again
	srli a1, t3, 1 # Perform SHIFT, followed by AND, makes it divide by 2
	and t3, t3, a1
	addi a0, a0, 1 # Count the string lengths so far
	b SETUP
	
ELSE: 	lw ra, 0(sp)
	lw a1, 4(sp)
	addi sp, sp, 8
	jr ra
END:
	ebreak
	
.global LIST
.data
LIST:
.word 0x6FFFFFFF, 10, 8, -1, 0x5
