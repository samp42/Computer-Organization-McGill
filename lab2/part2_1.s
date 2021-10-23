.data
// counter
.equ LOAD_MEMORY, 0xFFFEC600
.equ COUNTER_MEMORY, 0xFFFEC604
.equ CONTROL_MEMORY, 0xFFFEC608
.equ ISR_MEMORY, 0xFFFEC60C
.equ PRESCALER_VALUE, 0x4

.equ LOAD_VALUE, 0x0000000f

// HEX
.equ HEX0_MEMORY, 0xFF200020
.equ HEX4_MEMORY, 0xFF200030

.equ HEX_ON, 0x0000007f
.equ HEX_OFF, 0x0000000

// LED
.equ LED_MEMORY, 0xFF200000

.equ HEX0, 0x0000003f
.equ HEX1, 0x00000006
.equ HEX2, 0x0000005b
.equ HEX3, 0x0000004f
.equ HEX4, 0x00000066
.equ HEX5, 0x0000006d
.equ HEX6, 0x0000007d
.equ HEX7, 0x00000007
.equ HEX8, 0x0000007f
.equ HEX9, 0x0000006f

.text
.global _start
_start:

	@ count value
	MOV R4, #0
	
	@ control register
	LDR R0, =PRESCALER_VALUE
	@ I bit
	MOV R5, #1
	LSL R5, #2
	@ A bit
	MOV R6, #1
	LSL R6, #1
	ADD R5, R6
	@ E bit
	ADD R5, #1
	@ prescaler
	@ TODO: shift prescaler
	MOV R6, #PRESCALER_VALUE
	LSL R6, #8
	ADD R1, R5, R6
	
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
	LDR R4, =ISR_MEM
	MOV R5, #0x00000001
	STR R5, [R4]
	POP {R4, R5}
	BX LR

@ writes time on HEX displays
HEX_write_ASM:
	
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