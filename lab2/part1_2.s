.data
// switch
.equ SW_MEMORY, 0xFF200040
// filter to read only SW3-SW0
.equ SW_digit, 0x0000000f

// LEDs
.equ LED_MEMORY, 0xFF200000

// HEX
.equ HEX0_MEMORY, 0xFF200020
.equ HEX4_MEMORY, 0xFF200030

// display index encoding
.equ HEX0, 0x00000001
.equ HEX1, 0x00000002
.equ HEX2, 0x00000004
.equ HEX3, 0x00000008
.equ HEX4, 0x00000010
.equ HEX5, 0x00000020

.equ HEX_ON, 0x0000007f
.equ HEX_OFF, 0x0000000

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

// push buttons
.equ PB_MEMORY, 0xff200050
.equ PB_INT_MEMORY, 0xff200058
.equ PB_EDGCAP_MEMORY, 0xff20005c

.equ PB0, 0x00000001
.equ PB1, 0x00000002
.equ PB2, 0x00000004
.equ PB3, 0x00000008

.text

.global _start
_start:

	LDR R0, =HEX4_MEMORY
	LDR R1, =HEX0_MEMORY
	MOV R2, #0x0000007f
	
	STR R2, [R0]
	STR R2, [R1]
	
	PUSH {LR}
	MOV R0, #0x11
	BL HEX_clear_ASM
	POP {LR}
	
LOOP:
	@ endless loop
	
	@ read switches
	@ returns switches in R0
	PUSH {LR}
	BL read_slider_switches_ASM
	MOV R1, R0
	MOV R4, R0
	
	POP {LR}
	
	@ write LEDs
	PUSH {LR}
	BL write_LEDs_ASM
	POP {LR}
	
	@ check for falling edge
	PUSH {LR}
	BL read_PB_edgecp_ASM
	ANDS R0, #1 @ mask for PB0
	POP {LR}
	
	@ if falling edge at PB0, write HEX
	BEQ no_write
	PUSH {LR}
	@ R0: index
	@ R1: value
	BL HEX_write_ASM
	POP {LR}

no_write:
	
	@ SW9 == 1 ? clear HEX
	TST R4, #0x200
	PUSHGT {LR}
	MOVGT R0, R4
	BLGT HEX_clear_ASM
	POPGT {LR}
	
	B LOOP

@ reads the value of the switches in stores
@ return: R0
read_slider_switches_ASM:
	PUSH {R1}
    LDR R1, =SW_MEMORY
    LDR R0, [R1]
	
	POP {R1}
    BX LR
	
@ writes into the LEDs' register
@ R0: LED indices
write_LEDs_ASM:
	PUSH {R1}
    LDR R1, =LED_MEMORY
    STR	R0, [R1]
	POP {R1}
    BX LR
	
@ turn OFF all segments of HEX displays passed as argument
@ R0: sum of indices of HEX displays
HEX_clear_ASM:
	PUSH {R4-R11}
	MOV R3, R0
	LDR R4, =HEX_OFF
	LDR R5, =HEX5
	LDR R6, =HEX4_MEMORY
	MOV R7, #0 @ loop counter
	MOV R8, #0x00001100
	
clear_loop:
	CMP R3, R5
	BLT skip_clear_store
	
	SUB R3, R5
	AND R9, R6, R8
	MVN R10, R8
	AND R10, R4
	ORR R10, R9
	
	STR R10, [R6]
	
skip_clear_store:
	LSR R5, #1 @ divide by 2
	ADD R7, #1 @ i++
	CMP R7, #2 @ after to iterations, we go into the HEX first register
	LDREQ R6, =HEX0_MEMORY
	ROR R8, #8 @ rotate mask a byte to the right
	SUB R11, R3, R5
	SUBS R11, #1
	BGE clear_loop
	
	POP {R4-R11}
	BX LR

@ turn ON all segments of HEX displays passed as argument
@ R0: sum of indices of HEX displays
HEX_flood_ASM:
	PUSH {R4-R8}
	MOV R4, R0
	LDR R5, =HEX5
	LDR R6, =HEX_ON
	LDR R7, =HEX4_MEMORY
	ADD R7, #1
	MOV R8, #0 @ loop counter
	
flood_loop:
	CMP R4, R5
	BLT skip_flood_store
	
	SUB R4, R5
	SUB R7, R8
	STRB R6, [R7]
	
skip_flood_store:
	LSR R5, #1 @ divide by 2
	ADD R8, #1 @ i++
	BGE flood_loop
	
	POP {R4-R8}
	BX LR

@ writes hexadecimal digit received as argument in HEX display at given index
@ R0: index of HEX display
@ R1: value to display
HEX_write_ASM:
	@ flood HEX4, HEX5
	@PUSH {R0-R1, LR}
	@LDR R0, =HEX4
	@LDR R1, =HEX5
	@ADD R0, R1

	@BL HEX_flood_ASM
	@POP {R0-R1, LR}
	
	PUSH {R4-R7}
	LDR R4, =HEX0_MEMORY
	
	@ number to store in HEX memory
	LDR R5, =HEX0_VAL
	MOV R6, #4
	MLA R5, R1, R6, R5 @ get to correct number
	LDR R5, [R5]
	MOV R7, #8
	MUL R7, R0, R7
	LSL R5, R7
	
	STR R5, [R4]
	
	POP {R4-R7}
	
	BX LR

@ returns indices of pressed push buttons
@ return: R0
read_PB_data_ASM:
	PUSH {R4}
	LDR R4, =PB_MEMORY
	LDR R0, [R4]
	
	POP {R4}
	BX LR

@ return indices of push buttons that have been pressed and released (falling edge)
@ return: R0
read_PB_edgecp_ASM:
	PUSH {R4-R5}
	PUSH {LR}
	BL read_PB_data_ASM
	MVN R4, R0
	POP {LR}
	
	LDR R5, =PB_EDGCAP_MEMORY
	LDR R5, [R5]
	
	AND R0, R4, R5
	
	POP {R4-R5}
	BX LR

@ clears the pushbuttons Edgecapture register
PB_clear_edgecp_ASM:
	PUSH {R4, LR}
	BL read_PB_edgecp_ASM
	
	LDR R4, =PB_EDGCAP_MEMORY
	STR R0, [R4]
	
	POP {R4, LR}
	BX LR

@ disables interrupt function (bit mask to 1)
@ R0: indices of push buttons
enable_PB_INT_ASM:
	PUSH {R4}
	LDR R4, =PB_INT_MEMORY
	STR R0, [R4]
	
	POP {R4}
	BX LR

@ disables interrupt function (bit mask to 0)
@ R0: indices of push buttons
disable_PB_INT_ASM:
	PUSH {R4}
	LDR R4, =PB_INT_MEMORY
	SUB R0, R4, R0 @ set corresponding bit to 0
	STR R0, [R4]
	
	POP {R4}
	BX LR


END:
	b END
.end