.data
// push buttons
.equ PB_MEMORY, 0xff200060
.equ PB_INT_MEMORY, 0xff200068
.equ PB_EDGCAP_MEMORY, 0xff20006c

.text
.global _start
_start:
	//MOV R0, #0xf
	//BL enable_PB_INT_ASM
	
LOOP:
    BL read_PB_data_ASM
    MOV R1, R0
    BL read_PB_edgecp_ASM
	//BL read_PB_rising_ASM
    MOV R2, R0
    BL PB_clear_edgecp_ASM
    B LOOP



@ enables interrupt function (bit mask to 1)
@ R0: indices of push buttons
enable_PB_INT_ASM:
	PUSH {R4}
	LDR R4, =PB_INT_MEMORY
	STR R0, [R4]
	
	POP {R4}
	BX LR


@ R0: recent value
@ R1: previous value
read_PB_rising_ASM:
	PUSH {R4}
	EORS R4, R0, R1
	@ edge detected if != 0
	@ R1 && R4 ? rising : falling
	ANDNES R0, R4

	POP {R4}
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