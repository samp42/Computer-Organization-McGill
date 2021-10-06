.data
// switch
.equ SW_MEMORY, 0xFF200040

// LEDs
.equ LED_MEMORY, 0xFF200000

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
	
end:
	.end

