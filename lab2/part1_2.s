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

.equ HEX_ON, 0x0000007f
.equ HEX_OFF, 0x0000000

HEX_VALUE:
.word 0x0000003f, 0x00000006, 0x0000005b, 0x0000004f, 0x00000066, 0x0000006d, 0x0000007d, 0x00000007, 0x0000007f, 0x0000006f

// push buttons
.equ PB0, 0x00000001
.equ PB1, 0x00000002
.equ PB2, 0x00000004
.equ PB3, 0x00000008

.text

.global _start
_start:
	MOV R0, #0
	MOV R1, #0
	
	PUSH {LR}
	BL HEX_write_ASM
	POP {LR}
	
	B LOOP
	
	B END

LOOP:
	@ endless loop
	
	@ read switches
	PUSH {LR}
	BL read_slider_switches_ASM
	POP {LR}
	
	@ write LEDs
	PUSH {LR}
	BL write_LEDs_ASM
	POP {LR}
	
	@ write HEX
	PUSH {LR}
	BL HEX_write_ASM
	
	POP {LR}
	ADD R1, #1
	
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
@ argument: sum of indices of HEX displays in R0	
HEX_clear_ASM:
	PUSH {R1}
	
	POP {R1}
	BX LR

@ turn ON all segments of HEX displays passed as argument
@ argument: sum of indices of HEX displays in R0
HEX_flood_ASM:


@ writes hexadecimal digit received as argument in HEX display at given index
@ argument: index of HEX display in R0
@ argument: value to display in R1
HEX_write_ASM:
	@ flood HEX4, HEX5
	PUSH {R0, R4-R7}
	LDR R4, =HEX4_MEMORY
	LDR R5, =HEX_ON
	MOV R6, R5
	LSL R5, #8
	ADD R5, R6
	STR R5, [R4]
	
	@ for every digit, load proper value in HEX0_MEMORY
	LDR R6, =HEX0_MEMORY
	MOV R4, #0xFF
	@ rotate value
	MOV R5, #-8
	@ loop counter
	MOV R7, #4
	
HEX_write_loop:
	@ rotate input
	ROR R0, R0, R5
	@ apply mask
	AND R2, R0, R4
	
	PUSH {LR}
	BL write_segment_ASM
	POP {LR}
	
	@ i--
	SUBS R7, #1
	BGT HEX_write_loop
	@ loop ended
	
	POP {R0, R4-R7}
	BX LR
	

@ inner subroutine for HEX_write_ASM
@ loops through every digit 0..<9 to determine what number to output
@ moves the result in R6 and shifts the mask and the result
@ R2: masked input
@ R6: result register (result is value to HEX data register (segments info))
write_segment_ASM:
	PUSH {R4-R6}
	MOV R4, #9
	LDR R5, =HEX_VALUE
	
segment_loop:
	CMP R2, R4
	@ if equal, we have found the number, load it
	BEQ number_found
	@ j--
	SUBS R4, #1
	BGE segment_loop
	
number_found:
	lDR R6, [R5, R4]
	
	POP {R4-R6}
	BX LR

	
@ returns indices of pressed push buttons
read_PB_data_ASM:


@ reads push buttons that have been pressed and released (falling edge)
read_PB_edgecp_ASM:


@ clears the pushbuttons Edgecapture register
PB_clear_edgecp_ASM:


@ receives pushbuttons indices as an argument
@ ??
enable_PB_INT_ASM:


@ receives pushbuttons indices as an argument
@ ??
disable_PB_INT_ASM:



END:
	.end