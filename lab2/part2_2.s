.data
// counter
.equ LOAD_MEMORY, 0xfffec600
.equ COUNTER_MEMORY, 0xfffec604
.equ CONTROL_MEMORY, 0xfffec608
.equ ISR_MEMORY, 0xfffec60c
.equ PRESCALER_VALUE, 0x7f

.equ LOAD_VALUE, 0x00003d09

.equ MAX_MS, 0x64// 100 milliseconds (can only see 10th and 100th of seconds)
.equ MAX_S, 0x3c // 60 seconds
.equ MAX_MIN, 0x3c // 60 minutes

// LEDs
.equ LED_MEMORY, 0xff200000

// HEX
.equ HEX0_MEMORY, 0xff200020
.equ HEX4_MEMORY, 0xff200030

// display index encoding 
.equ HEX0, 0x00000001
.equ HEX1, 0x00000002
.equ HEX2, 0x00000004
.equ HEX3, 0x00000008
.equ HEX4, 0x00000010
.equ HEX5, 0x00000020

HEX0_VAL: .word 0x0000003f
HEX1_VAL: .word 0x00000006
HEX2_VAL: .word 0x0000005b
HEX3_VAL: .word 0x0000004f
HEX4_VAL: .word 0x00000066
HEX5_VAL: .word 0x0000006d
HEX6_VAL: .word 0x0000007d
HEX7_VAL: .word 0x00000007
HEX8_VAL: .word 0x0000007f
HEX9_VAL: .word 0x0000006f
HEXA_VAL: .word 0x00000077
HEXB_VAL: .word 0x0000007c
HEXC_VAL: .word 0x00000039
HEXD_VAL: .word 0x0000005e
HEXE_VAL: .word 0x00000079
HEXF_VAL: .word 0x00000071

.text
.global _start
_start:

	@ ms
	MOV R4, #0
	@ s
	MOV R5, #0
	@ min
	MOV R6, #0
	
	@ constants
	LDR R7, =MAX_MS
	LDR R8, =MAX_S
	LDR R9, =MAX_MIN

	@ load register
	LDR R0, =LOAD_VALUE
	
	@ control register
	LDR R1, =PRESCALER_VALUE
	@ prescaler
	LSL R1, #8
	@ I bit
	@ interrupt required ???
	MOV R7, #1
	LSL R7, #2
	@ A bit
	@ automatic timer restart
	MOV R8, #1
	LSL R8, #1
	ORR R7, R8
	@ E bit
	@ enable by default
	MOV R8, #1
	ORR R7, R8

	ORR R1, R7
	
	BL ARM_TIM_config_ASM
	
LOOP:
	BL ARM_TIM_read_INT_ASM
	@ check if F bit is 1
	TEQ R0, #0x1
	
	BNE skip_increment
	
	@ if F == 1
	@ reset F bit
	
	BL ARM_TIM_clear_INT_ASM
	
	MOV R0, R4
	
	@ divide into tens
	BL base_conversion_ASM
	MOV R8, R0
	
	@ HEX_write_ASM has different arguments
	@ MS
	MOV R0, #0x1
	BL HEX_write_ASM
	
	MOV R0, #0x2
	MOV R1, R8
	BL HEX_write_ASM
	
	@ S
	MOV R0, R5
	
	@ divide into tens
	BL base_conversion_ASM
	MOV R8, R0
	
	MOV R0, #0x4
	BL HEX_write_ASM
	
	MOV R0, #0x8
	MOV R1, R8
	BL HEX_write_ASM
	
	@ MIN
	MOV R0, R6
	
	@ divide into tens
	BL base_conversion_ASM
	MOV R8, R0
	
	MOV R0, #0x10
	BL HEX_write_ASM
	
	MOV R0, #0x20
	MOV R1, R8
	BL HEX_write_ASM
	
	@ increment ms
	ADD R4, #1
	
	LDR R3, =MAX_MS
	CMP R4, R3
	@ reset ms when reaches MAX_MS and increment s
	MOVGE R4, #0
	ADDGE R5, #1

	LDR R3, =MAX_S
	CMP R5, R3
	MOVGE R5, #0
	ADDGE R6, #1
	
skip_increment:
	B LOOP
	
// -----------------------------------------------------------------
// -----------------------------------------------------------------
// -----------------------------------------------------------------

@ R0: Load value
@ R1: configuration bits in control register
ARM_TIM_config_ASM:
	PUSH {R4}
	@ get load value and load it in load register
	LDR R4, =LOAD_MEMORY
	STR R0, [R4]
	@ setup control register
	LDR R4, =CONTROL_MEMORY
	STR R1, [R4]
	POP {R4}
	BX LR


@ get F bit
ARM_TIM_read_INT_ASM:
	LDR R0, =ISR_MEMORY
	LDR R0, [R0]
	BX LR


@ clears F bit to 0
ARM_TIM_clear_INT_ASM:
	PUSH {R4, R5}
	LDR R4, =ISR_MEMORY
	MOV R5, #0x00000001
	STR R5, [R4]
	POP {R4, R5}
	BX LR


@ turn OFF all segments of HEX displays passed as argument
@ R0: sum of indices of HEX displays
HEX_clear_ASM:
	PUSH {R4-R11}
	MOV R4, R0
	LDR R5, =HEX5
	LDR R6, =HEX4_MEMORY
	MOV R7, #0 @ loop counter
	MOV R8, #0xffff00ff
	MOV R2, #4
	
clear_loop:
	CMP R4, R5
	BLT skip_clear_store
	@ save CPSR state for later
	MRS R11, APSR
	MOV R3, #0
	SUB R4, R5
	LDR R9, [R6]
	AND R9, R8
	MVN R10, R8
	AND R10, R3
	ORR R10, R9
	
	STR R10, [R6]
	
skip_clear_store:
	LSR R5, #1 @ divide by 2
	ADD R7, #1 @ i++
	CMP R7, #2 @ after 2 iterations, we go to HEX0 register
	LDREQ R6, =HEX0_MEMORY
	ROR R8, #8 @ rotate mask a byte to the right
	ROR R3, #8 @ rotate value to display
	CMP R5, #1
	BLT clear_return
	@ saved CPSR state from first compare in clear_loop
	MSR APSR, R11
	BGE clear_loop
	
clear_return:
	POP {R4-R11}
	BX LR


@ writes value passed as argument to all the given displays
@ calculates the value to pass to the register based on the hexadecimal passed as input
@ R0: sum of indices of HEX displays
@ R1: hexadecimal value to display
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

	
@ returns the decimal reprensentation of a number (tens and units)
@ input R0: the number
@ return
@ R0: tens
@ R1: units
base_conversion_ASM:
	PUSH {R4}
	MOV R4, #0
add_tens_loop:
	@ if >= 10 (0xa), then add to tens
	CMP R0, #0xa
	ADDGE R4, #1
	SUBGE R0, #0xa
	BGE add_tens_loop
	@ if < 10, this is the units
	MOV R1, R0
	MOV R0, R4
	
	POP {R4}
	BX LR

end:
	b end
.end