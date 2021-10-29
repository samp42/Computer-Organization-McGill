.data
// counter
.equ LOAD_MEMORY, 0xfffec600
.equ COUNTER_MEMORY, 0xfffec604
.equ CONTROL_MEMORY, 0xfffec608
.equ ISR_MEMORY, 0xfffec60c
.equ PRESCALER_VALUE, 0x4

.equ LOAD_VALUE, 0x00000010

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

	@ count value
	MOV R4, #0
	
	@ load register
	LDR R0, =LOAD_VALUE
	
	@ control register
	LDR R1, =PRESCALER_VALUE
	@ prescaler
	LSL R1, #8
	@ I bit
	MOV R5, #1
	LSL R5, #2
	@ A bit
	MOV R6, #1
	LSL R6, #1
	ORR R5, R6
	@ E bit
	ORR R5, #1

	ORR R1, R5
	
	PUSH {LR}
	BL ARM_TIM_config_ASM
	POP {LR}
	
LOOP:
	PUSH {LR}
	BL ARM_TIM_read_INT_ASM
	CMP R0, #0xf
	
	@ if f == 1, increment count value
	ADDGE R4, #1
	POP {LR}
	
	CMP R4, #0xf
	
	@ reset count value when 15
	MOV R4, #0
	MOV R0, R4
	PUSH {LR}
	BL LED_write_ASM
	POP {LR}
	
	B LOOP
	
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

@ turn ON all segments of HEX displays passed as argument
@ R0: sum of indices of HEX displays
HEX_flood_ASM:
	PUSH {LR}
	MOV R1, #0x8
	BL HEX_write_ASM
	POP {LR}
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

@ R0: number
@ R1: position [0-5]
@ will add that number to the current value set in the display register
HEX_add_ASM:
	@ if position is 4 or 5, add to HEX4_MEMORY
	CMP R1, #4
	SUBGE R1, #4
	PUSH {V1}
	MOV V1, #2
	MUL R1, V1
	POP {V1}
	LSL R0, R1
	
	BX LR
	
@ R0: number
LED_write_ASM:
	PUSH {R4}
	LDR R4, =LED_MEMORY
	STR R0, [R4]
	POP {R4}
	BX LR

end:
	b end
.end