.data
// push buttons
.equ PB_MEMORY, 0xff200050
.equ PB_EDGCAP_MEMORY, 0xff20005c

.text
.global _start
_start:

LOOP:
    BL read_PB_data_ASM
    MOV R1, R0
    BL read_PB_edgecp_ASM
    MOV R2, R0
    BL PB_clear_edgecp_ASM
    B LOOP


@ returns indices of pressed push buttons
@ return: R0
read_PB_data_ASM:
	LDR R0, =PB_MEMORY
	LDR R0, [R0]
	
	BX LR
	
	
@ return indices of push buttons that have been pressed and released (falling edge)
@ return: R0
read_PB_edgecp_ASM:
	LDR R0, =PB_EDGCAP_MEMORY
	LDR R0, [R0]
	
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