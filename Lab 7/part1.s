.global _start
.text

_start:
	la s2, LIST
	addi s10, zero, 0
	addi s11, zero, 0
	
# Write your code here

	addi s1, zero, -1    #so I have -1 to compare to
	addi s3, zero, 1
	lw s4, 0(s2)         #for the first item in list
	
LOOP1: bge s1, s4, END       #used to be beq s4, s1, END so as long as list item is not equal to -1
			     #changed it to bge -1 >= list so as long as list is not -1 or smaller, in case there are -ve but it says only positives.
	
	add s10, s10, s4      #add to final sum
	addi s11, s11, 1      #add 1 for total num in list
	
	slli s5, s3, 2	      #recall this is like saying s3 * 2^2 so we have 1*4=4, 2*4=8. 3*4=12, etc which is adding by 4!
	add s6, s2, s5        #so add location of list by s3 bits
	addi s3, s3, 1
	lw s4, 0(s6) 	      #should be last step bc it is checking the next item in list before adding to know when to stop

	j LOOP1

#only list of positive numbers (dec, hex) always ends with -1
# tested with 0xF, 0xF = 1e (30) and 2
# tested with 1, 2, 3, 5, 0xA = 15 (21) and 5
# tested with 0xF, 0xE, 2 = 1f (31) and 3
# tested with 1, 2, 3, 4, -2, -1 = a (10) and 4 so it stopped at negative numbers

END:
	ebreak
	
.global LIST
.data
LIST:
.word 0xF, 0xF, -1 
