.data
// switch
.equ SW_MEMORY, 0xFF200040

// LEDs
.equ LED_MEMORY, 0xFF200000

// hex
.equ HEX0, 0x00000001
.equ HEX1, 0x00000002
.equ HEX2, 0x00000004
.equ HEX3, 0x00000008
.equ HEX4, 0x00000010
.equ HEX5, 0x00000020

// push buttons
.equ PB0, 0x00000001
.equ PB1, 0x00000002
.equ PB2, 0x00000004
.equ PB3, 0x00000008

.text
.global _start
_start:
	
	BL loop
	
	B end

loop:
	@ endless loop
	
	@ read switches
	BL read_slider_switches_ASM
	
	@ write LEDs
	BL write_LEDs_ASM
	
	B loop

@ reads the value of the switches in stores it in R0
read_slider_switches_ASM:
	PUSH {R1}
    LDR R1, =SW_MEMORY
    LDR R0, [R1]
	POP {R1}
    BX LR
	
@ writes the content of R0 into the LEDs' memory
write_LEDs_ASM:
	PUSH {R1}
    LDR R1, =LED_MEMORY
    STR	R0, [R1]
	POP {R1}
    BX LR
	
	
@ turn ON all segments of HEX displays passed as argument
@ argument: sum of indices of HEX displays in R0
HEX_clear_ASM:


@ turn OFF all segments of HEX displays passed as argument
@ argument: sum of indices of HEX displays in R0
HEX_flood_ASM:


@ writes hexadecimal digit received as argument in HEX display at given index
@ argument: index of HEX display in R0
@ argument: value to display in R1
HEX_write_ASM:


	
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



end:
	.end
