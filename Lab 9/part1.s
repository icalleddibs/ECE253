.text
.global _start
_start:
	lui t0 0xFFFF0

WAIT:
	lw t1, 0(t0) #read the control
	andi t1, t1, 0x1 #fast way to check if it's 1, and keep storing as 1
	beqz t1, WAIT #if ready bit is equal to 0 then keep looping
	lw a0 4(t0) #now a0 holds the value from the keyboard (at 0xFFFF0004)
	j DISPLAY
	
DISPLAY:
	lw t2, 8(t0) #the ready bit of transmitter control register
	andi t2, t2, 0x1 #fast way to check if it's 1, and keep storing as 1
	beqz t2, DISPLAY #loop until the transmitter control is 1
	sw a0, 12(t0) #write to transmitter data register
	j WAIT #go back and wait for a pressed key