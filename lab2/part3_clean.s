.data
// counter
.equ LOAD_MEMORY, 0xfffec600
.equ COUNTER_MEMORY, 0xfffec604
.equ CONTROL_MEMORY, 0xfffec608
.equ ISR_MEMORY, 0xfffec60c
.equ PRESCALER_VALUE, 0x7f
.equ LOAD_VALUE, 0x00003d09

tim_int_flag : .word 0x0

.equ MAX_MS, 0x64// 100 milliseconds (can only see 10th and 100th of seconds)
.equ MAX_S, 0x3c // 60 seconds
.equ MAX_MIN, 0x3c // 60 minutes

// LEDs
.equ LED_MEMORY, 0xff200000

// HEX
.equ HEX0_MEMORY, 0xff200020
.equ HEX4_MEMORY, 0xff200030

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

PB_int_flag : .word 0x0

.section .vectors, "ax"
B _start
B SERVICE_UND       // undefined instruction vector
B SERVICE_SVC       // software interrupt vector
B SERVICE_ABT_INST  // aborted prefetch vector
B SERVICE_ABT_DATA  // aborted data vector
.word 0 // unused vector
B SERVICE_IRQ       // IRQ interrupt vector
B SERVICE_FIQ       // FIQ interrupt vector

.text
.global _start

_start:
    /* Set up stack pointers for IRQ and SVC processor modes */
    MOV        R1, #0b11010010      // interrupts masked, MODE = IRQ
    MSR        CPSR_c, R1           // change to IRQ mode
    LDR        SP, =0xFFFFFFFF - 3  // set IRQ stack to A9 onchip memory
    /* Change to SVC (supervisor) mode with interrupts disabled */
    MOV        R1, #0b11010011      // interrupts masked, MODE = SVC
    MSR        CPSR, R1             // change to supervisor mode
    LDR        SP, =0x3FFFFFFF - 3  // set SVC stack to top of DDR3 memory
    BL     CONFIG_GIC           // configure the ARM GIC
    // To DO: write to the pushbutton KEY interrupt mask register
    // Or, you can call enable_PB_INT_ASM subroutine from previous task
    // to enable interrupt for ARM A9 private timer, use ARM_TIM_config_ASM subroutine
    LDR        R0, =0xFF200050      // pushbutton KEY base address
    MOV        R1, #0xF             // set interrupt mask bits
    STR        R1, [R0, #0x8]       // interrupt mask register (base + 8)
    // enable IRQ interrupts in the processor
    MOV        R0, #0b01010011      // IRQ unmasked, MODE = SVC
    MSR        CPSR_c, R0
IDLE:
    B IDLE // This is where you write your objective task


/*--- Undefined instructions ---------------------------------------- */
SERVICE_UND:
    B SERVICE_UND
/*--- Software interrupts ------------------------------------------- */
SERVICE_SVC:
    B SERVICE_SVC
/*--- Aborted data reads -------------------------------------------- */
SERVICE_ABT_DATA:
    B SERVICE_ABT_DATA
/*--- Aborted instruction fetch ------------------------------------- */
SERVICE_ABT_INST:
    B SERVICE_ABT_INST
/*--- IRQ ----------------------------------------------------------- */
SERVICE_IRQ:
    PUSH {R0-R7, LR}
/* Read the ICCIAR from the CPU Interface */
    LDR R4, =0xFFFEC100
    LDR R5, [R4, #0x0C] // read from ICCIAR

/* To Do: Check which interrupt has occurred (check interrupt IDs)
   Then call the corresponding ISR
   If the ID is not recognized, branch to UNEXPECTED
   See the assembly example provided in the De1-SoC Computer_Manual on page 46 */
 Pushbutton_check:
    CMP R5, #73
UNEXPECTED:
    BNE UNEXPECTED      // if not recognized, stop here
    BL KEY_ISR
EXIT_IRQ:
/* Write to the End of Interrupt Register (ICCEOIR) */
    STR R5, [R4, #0x10] // write to ICCEOIR
    POP {R0-R7, LR}
SUBS PC, LR, #4
/*--- FIQ ----------------------------------------------------------- */
SERVICE_FIQ:
    B SERVICE_FIQ


/*--- Undefined instructions ---------------------------------------- */
SERVICE_UND:
    B SERVICE_UND
/*--- Software interrupts ------------------------------------------- */
SERVICE_SVC:
    B SERVICE_SVC
/*--- Aborted data reads -------------------------------------------- */
SERVICE_ABT_DATA:
    B SERVICE_ABT_DATA
/*--- Aborted instruction fetch ------------------------------------- */
SERVICE_ABT_INST:
    B SERVICE_ABT_INST
/*--- IRQ ----------------------------------------------------------- */
SERVICE_IRQ:
    PUSH {R0-R7, LR}
/* Read the ICCIAR from the CPU Interface */
    LDR R4, =0xFFFEC100
    LDR R5, [R4, #0x0C] // read from ICCIAR

/* Check which interrupt has occurred (check interrupt IDs)
   Then call the corresponding ISR
   If the ID is not recognized, branch to UNEXPECTED
   See the assembly example provided in the De1-SoC Computer_Manual on page 46 */
 Pushbutton_check:
    CMP R5, #73
    BLEQ KEY_ISR

    CMP R5, #29
    BLEQ ARM_TIM_ISR

UNEXPECTED:
    BNE UNEXPECTED      // if not recognized, stop here
    BL KEY_ISR
EXIT_IRQ:
/* Write to the End of Interrupt Register (ICCEOIR) */
    STR R5, [R4, #0x10] // write to ICCEOIR
    POP {R0-R7, LR}
SUBS PC, LR, #4
/*--- FIQ ----------------------------------------------------------- */
SERVICE_FIQ:
    B SERVICE_FIQ


KEY_ISR:
    LDR R0, =0xFF200050    // base address of pushbutton KEY port
    LDR R1, [R0, #0xC]     // read edge capture register
    MOV R2, #0xF
    STR R2, [R0, #0xC]     // clear the interrupt
    LDR R0, =0xFF200020    // based address of HEX display
CHECK_KEY0:
    MOV R3, #0x1
    ANDS R3, R3, R1        // check for KEY0
    BEQ CHECK_KEY1
    MOV R2, #0b00111111
    STR R2, [R0]           // display "0"
    B END_KEY_ISR
CHECK_KEY1:
    MOV R3, #0x2
    ANDS R3, R3, R1        // check for KEY1
    BEQ CHECK_KEY2
    MOV R2, #0b00000110
    STR R2, [R0]           // display "1"
    B END_KEY_ISR
CHECK_KEY2:
    MOV R3, #0x4
    ANDS R3, R3, R1        // check for KEY2
    BEQ IS_KEY3
    MOV R2, #0b01011011
    STR R2, [R0]           // display "2"
    B END_KEY_ISR
IS_KEY3:
    MOV R2, #0b01001111
    STR R2, [R0]           // display "3"
END_KEY_ISR:
    BX LR


ARM_TIM_ISR:
	LDR R0, =ISR_MEMORY
	MOV R1, #1
	LDR R2, =tim_int_flag
	STR R1, [R2]		   // write to PB_int_flag
    MOV R2, #0xF
    STR R2, [R0]     	   // clear the interrupt
	BX LR

	
//--------------------------------------------------------------------
//--------------------------------------------------------------------
//--------------------------------------------------------------------

@ returns indices of pressed push buttons
@ return: R0
read_PB_data_ASM:
	LDR R0, =PB_MEMORY
	LDR R0, [R0]
	BX LR
	

@ enables interrupt function (bit mask to 1)
@ R0: indices of push buttons
enable_PB_INT_ASM:
	PUSH {R4}
	LDR R4, =PB_INT_MEMORY
	STR R0, [R4]
	
	POP {R4}
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


@ disables interrupt function (bit mask to 0)
@ R0: indices of push buttons
disable_PB_INT_ASM:
	PUSH {R4}
	LDR R4, =PB_INT_MEMORY
	SUB R0, R4, R0 @ set corresponding bit to 0
	STR R0, [R4]
	
	POP {R4}
	BX LR
	

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
	LDR R4, =ISR_MEMORY
	MOV R5, #0x00000001
	STR R5, [R4]
	POP {R4, R5}
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
	
	
@ returns the decimal reprensentation of a number (tens and units)
@ input R0: the number
@ return
@ R0: tens
@ R1: units
base_conversion_ASM:
	PUSH {R4}
	MOV R4, #0
add_tens_loop:
	@ if >= 10 (0xa), then add to tens
	CMP R0, #0xa
	ADDGE R4, #1
	SUBGE R0, #0xa
	BGE add_tens_loop
	@ if < 10, this is the units
	MOV R1, R0
	MOV R0, R4
	
	POP {R4}
	BX LR
	
.end