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

	@ setup
	
LOOP:
	@ endless loop
	
	@ read switches
	@ R0:switches value
	BL read_slider_switches_ASM
	MOV R4, R0
	
	@ write LEDs
	BL write_LEDs_ASM
	
	@ check for falling edge
	BL read_PB_edgecp_ASM
	MOV R5, R0
	
	@ clear edge capt. register
	BL PB_clear_edgecp_ASM
	
	@ test if SW9==1
	@ if SW9==1, clear (not equal, then skip)
	CMP R4, #0x200
	BLT skip_clear
	
	@ clear all displays
	MOV R0, #0x3f
	BL HEX_clear_ASM
	B goto_loop
	
skip_clear:
	@ check if need to write to HEX
	
	@ if falling edge, write to corresponding HEX display
	MOV R0, R5
	TEQ R0, #0x0
	@ if no falling edge, don't write
	BEQ goto_loop
	
	@ flood HEX4 and HEX5
	LDR R0, =HEX4
	LDR R1, =HEX5
	ADD R0, R1
	BL HEX_flood_ASM
	
	@ R0: index
	@ R1: value
	@ R0: result of read_PB_edgecp_ASM
	MOV R0, R5
	MOV R1, R4
	@ only care about last 4 bits
	AND R1, #0xf
	BL HEX_write_ASM
	
goto_loop:
	B LOOP

// -------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------


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
	@ compare sum with current index
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

@ returns indices of pressed push buttons
@ return: R0
read_PB_data_ASM:
	LDR R0, =PB_MEMORY
	LDR R0, [R0]
	
	BX LR

@ return indices of push buttons that have been pressed and released (falling edge)
@ return: R0
read_PB_edgecp_ASM:
	PUSH {R4-R5}
	PUSH {LR}
	BL read_PB_data_ASM
	POP {LR}
	MVN R4, R0
	
	LDR R5, =PB_EDGCAP_MEMORY
	LDR R5, [R5]
	
	AND R0, R4, R5
	
	POP {R4-R5}
	
	BX LR

@ clears the pushbuttons Edgecapture register
PB_clear_edgecp_ASM:
	PUSH {R4-R5, LR}
	BL read_PB_edgecp_ASM
	
	LDR R4, =PB_EDGCAP_MEMORY
	MOV R5, #0xf
	STR R5, [R4]
	
	POP {R4-R5, LR}
	BX LR

@ enables interrupt function (bit mask to 1)
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