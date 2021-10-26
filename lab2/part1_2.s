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

HEX_VALUE:
.word 0x0000003f, 0x00000006, 0x0000005b, 0x0000004f, 0x00000066, 0x0000006d, 0x0000007d, 0x00000007, 0x0000007f, 0x0000006f, 0x00000077, 0x0000007c, 0x00000039, 0x0000005e, 0x00000079, 0x00000071

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
	MOV R0, #2
	MOV R1, #12
	
	PUSH {LR}
	BL HEX_write_ASM
	POP {LR}
	
LOOP:
	@ endless loop
	
	PUSH {LR}
	BL read_PB_edgecp_ASM
	POP {LR}
	
	@ read switches
	PUSH {LR}
	@BL read_slider_switches_ASM
	POP {LR}
	
	@ write LEDs
	PUSH {LR}
	@BL write_LEDs_ASM
	POP {LR}
	
	@ write HEX
	@PUSH {LR}
	@BL HEX_write_ASM
	
	@POP {LR}
	@ADD R1, #1
	
	@MOV R0, #63
	@BL HEX_clear_ASM
	B LOOP

@ reads the value of the switches in stores it in R0
read_slider_switches_ASM:
	PUSH {R1}
    LDR R1, =SW_MEMORY
    LDR R0, [R1]
	@ SW9 clears all the displays if 1
	CMP R0, #0x200
	PUSH {R0}
	@ write indices of all hex displays in R0
	BLGE HEX_clear_ASM
	POP {R0}
	
	POP {R1}
    BX LR
	
@ writes the content of R0 into the LEDs' memory
write_LEDs_ASM:
	PUSH {R1}
    LDR R1, =LED_MEMORY
    STR	R0, [R1]
	POP {R1}
    BX LR
	
@ turn OFF all segments of HEX displays passed as argument
@ R0: sum of indices of HEX displays
HEX_clear_ASM:
	PUSH {R4-R9}
	MOV R4, R0
	LDR R5, =HEX5
	LDR R6, =HEX_OFF
	LDR R7, =HEX4_MEMORY
	ADD R7, #1
	MOV R8, #0 @ loop counter
	
clear_loop:
	CMP R4, R5
	BLT skip_clear_store
	
	SUB R4, R5
	SUB R7, R8
	STRB R6, [R7]
	
skip_clear_store:
	LSR R5, #1 @ divide by 2
	ADD R8, #1 @ i++
	BGE clear_loop
	
	POP {R4-R9}
	BX LR

@ turn ON all segments of HEX displays passed as argument
@ R0: sum of indices of HEX displays
HEX_flood_ASM:
	PUSH {R4-R9}
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
	
	POP {R4-R9}
	BX LR

@ writes hexadecimal digit received as argument in HEX display at given index
@ R0: index of HEX display
@ R1: value to display
HEX_write_ASM:
	@ flood HEX4, HEX5
	PUSH {R0-R1, LR}
	LDR R0, =HEX4
	LDR R1, =HEX5
	ADD R0, R1

	BL HEX_flood_ASM
	POP {R0-R1, LR}
	
	PUSH {R4-R7}
	LDR R4, =HEX0_MEMORY
	
	@ number to store in HEX memory
	LDR R5, =HEX_VALUE
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
read_PB_data_ASM:
	PUSH {R4}
	LDR R4, =PB_MEMORY
	LDR R0, [R4]
	
	POP {R4}
	BX LR

@ return indices of push buttons that have been pressed and released (falling edge)
read_PB_edgecp_ASM:
	PUSH {R4-R5, LR}
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