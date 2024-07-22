.data

#Messages:
msg_1:		.asciz	"Please take a deep breath      "
msg_2:		.asciz	"Please drink some water        "
msg_3: 		.asciz	"Please give your eyes a break  "

#timer related
timeNow:	.word	0xFFFF0018 #current time, timecount
timecmp:	.word	0xFFFF0020 #time for new interrupt, timecmp

# 5000 in hex is 00001388


.text

#display related
.eqv		OUT_CTRL	0xffff0008
.eqv		OUT		0xFFFF000C

main:
	#set time to trigger interrupt to be 5000ms
	la s0, timecmp
	lw s0, 0(s0)
	li s1, 5000 #5000ms because we want 5s intervals
	sw s1, 0(s0)
	#sw zero, 4(s0)
	
	#set the handler address and enable interrupts
	la t0, timer_handler
	csrrw zero, utvec, t0
	csrrsi zero, ustatus, 0x1
	csrrsi zero, uie, 0x10 #hex 16 is 4th bit
	
	la a1, msg_1
	la a2, msg_2
	la a3, msg_3
	addi a4, zero, 0
	addi s2, zero, 31
	
LOOP:
	addi s4, a1, 0 #temporary store of first address to use later
	add s5, s4, a4 #should add by 1, s5 is the new address
	addi a4, a4, 1 #add 1 each time
	lb s3, 0(s5)
	#get the characters, each 2 bytes(?)
	bge s2, a4, WAIT
	j ELSE
	
ELSE:
	beqz a4, LOOP
	j ELSE
	
WAIT:
	li t1, OUT_CTRL
	li t2, OUT
	lw t1, 0(t1)
	#lw t2, 0(t2)
	andi t1, t1, 0x1
	beqz t1, WAIT
	sw s3, 0(t2)
	j LOOP


	
timer_handler:
	#push registers to the stack
	addi sp, sp, -20
	sw t0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw a3, 12(sp)
	sw a4, 16(sp)

	#indicate that 5 seconds have passed
	la t4, timecmp
	lw t4, 0(t4)
	lw t6, 0(t4) #old timecmp value
	lw t0, 4(t4) #upper 32 bits old
	li t5, 5000 #to add in
	add t5, t5, t6 #new timecmp value
	#if old is greater than new there is a carry
	sw t5, 0(t4)
	bge t6, t5, CASE1
	sw t0, 4(t4)

	#pop registers from the stack
	lw t0, 0(sp)
	#trying to cycle to the next one...
	lw a3, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a4, 16(sp)
	addi sp, sp, 20
	addi a4, zero, 0 #set it back to 0
	uret
	
CASE1: #if there is a carry, we need to change upper 32 bits by 1
	addi t0, t0, 1
	sw t0, 4(t4)

	#pop registers from the stack
	lw t0, 0(sp)
	#trying to cycle to the next one...
	lw a3, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a4, 16(sp)
	addi sp, sp, 20
	addi a4, zero, 0 #set it back to 0
	uret
	
