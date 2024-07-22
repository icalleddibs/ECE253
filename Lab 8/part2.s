.global _start
.text

_start:

	la s1, LIST #give a0 the original list address, make it permanent (s)
	addi t0, zero, 0 #outerloop counter
	addi t1, zero, 0 #innerloop counter
	addi t4, zero, 0
	lw t2, 0(s1) #number of items in list
	addi a0, zero, 0 #return value
	
	addi t5, t2, -1 #subtract 1 for N-1 outer loop

# HOW BUBBLE SORT WORKS
# go thru the list once and swap each time. then the last number should be the largest.
# then you go again but you check one less each time
# so have a loop that runs a smaller loop inside of it

LOOP: 	bge t0, t5, END # for i < N-1, i++

	#set a0 to address s1 + t0 (which will be shifted left)
	#addi t6, t0, 1
	#slli t4, t6, 2 #t4 = t0*4 because we actually start words at position 1 not 0
	addi a0, s1, 4 #this contains new word address, send to SWAP

	addi t0, t0, 1
	sub t3, t2, t0 #for SWAP function
	sub t1, t1, t1
	addi t4, zero, 0
	jal SWAP
	beq a0, zero, END #if it did no swaps in the whole run then it's sorted, go to end
	j LOOP #otherwise keep looping

SWAP: 	addi sp, sp -12
	sw ra, 0(sp)
	sw a2, 4(sp)
	sw a3, 8(sp)

SETUP: bge t1, t3, ELSE # for j < N-i, j++
#give the address of a list element in a0
#compare it to the next element in the list
	addi a1, a0, 4 #a0 is address of list, add 4 is the address of next word
	lw a2, 0(a0) #a2 contains the value in first address
	lw a3, 0(a1) #a3 contains the value in second address
	addi t1, t1, 1 #j++
	
	bge a3, a2, THEN #right > left no need to swap go back to swap?
	
	sw a2, 0(a1)
	sw a3, 0(a0)
	
	addi t4, t4, 1 #set this to 1 because we did a swap
	addi a0, a0, 4 #for the next loop
	j SETUP
	
#swap if necessary
#return a0 = 1 if a swap was performed
#return a0 = 0 if a swap was NOT performed

THEN:	
	addi t4, t4, 0 #add 0, theoretically if adding 0 each time then we know no swaps
	addi a0, a0, 4 #for the next loop
	j SETUP

ELSE:	lw ra, 0(sp)
	lw a2, 4(sp)
	lw a3, 8(sp)
	addi sp, sp, 12
	addi a0, zero, 0 #set to 0
	beqz t4, COND
	addi a0, zero, 1 #should go to 1 now
	jr ra #should go back to right after that line in LOOP

COND:	#if 0 then a0 should be 0
	jr ra

END: 
	ebreak

.global LIST
.data
LIST:
.word 10, 1400, 45, 23, 5, 3, 8, 17, 4, 20, 33
