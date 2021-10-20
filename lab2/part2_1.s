.data
.equ LOAD_MEM, 0xFFFEC600
.equ COUNTER_MEM, 0xFFFEC604
.equ CONTROL_MEM, 0xFFFEC608
.equ ISR_MEM, 0xFFFEC60C

.equ LOAD_VALUE, 0x0000000f

.text
.global _start
_start:
	
	
	
@ R0: Load value
@ R1: configuration bits in control register
ARM_TIM_config_ASM:
	

@ get F bit
ARM_TIM_read_INT_ASM:
	LDR R0, =ISR_MEM
	LDR R0, [R0]
	BX LR

@ clears F bit to 0
ARM_TIM_clear_INT_ASM:
	PUSH {R4}
	LDR R4, =ISR_MEM
	MOV R5, 0x00000001
	STR R5, [R4]
	BX LR

HEX_write_ASM: