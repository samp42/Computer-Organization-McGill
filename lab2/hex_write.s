HEX_write_ASM:
	PUSH {R4-R11}
	MOV R4, R0
	LDR R5, =HEX5
	LDR R6, =HEX4_MEMORY
	MOV R7, #0 @ loop counter
	MOV R8, #0xffff00ff
	MOV R2, #4
	LDR R3, =HEX0_VAL
	MLA R3, R1, R2, R3
	LDR R3, [R3]
	ROR R3, #24 @ rotate display value left 1 byte
	
write_loop:
	CMP R4, R5
	BLT skip_write_store
	@ save CPSR state for later
	MRS R11, APSR
	
	SUB R4, R5
	LDR R9, [R6]
	AND R9, R8
	MVN R10, R8
	AND R10, R3
	ORR R10, R9
	
	STR R10, [R6]
	
skip_write_store:
	LSR R5, #1 @ divide by 2
	ADD R7, #1 @ i++
	CMP R7, #2 @ after 2 iterations, we go to HEX0 register
	LDREQ R6, =HEX0_MEMORY
	ROR R8, #8 @ rotate mask a byte to the right
	ROR R3, #8 @ rotate value to display
	CMP R5, #1
	BLT write_return
	@ saved CPSR state from first compare in clear_loop
	MSR APSR, R11
	BGE write_loop
	
write_return:
	POP {R4-R11}
	BX LR