# Program that counts consecutive 1’s.
.global _start
.text
_start:
	la s2, LIST # Load the memory address into s2
	lw s3, 0(s2) #only need the first word bc it's one word
	addi s4, zero, 0 # Register s4 will hold the result
LOOP:
	beqz s3, END # Loop until data contains no more 1’s, it looks at if there are 1s, if there are not then go to END
	srli s2, s3, 1 # Perform SHIFT, followed by AND, makes it divide by 2
	and s3, s3, s2
	addi s4, s4, 1 # Count the string lengths so far
	b LOOP
END:
	ebreak
.global LIST
.data
LIST:
.word 0x103fe00f 


#basically it works because we move it 1 to the right every time logical so the LS fills with 0s
#meaning everything before the 1 will always become 0 due to the "AND"
