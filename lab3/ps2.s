// pixel buffer
.equ PIX_BUFFER, 0xC8000000
.equ PIX_BUFFER_WIDTH, 319		// x
.equ PIX_BUFFER_HEIGHT, 239		// y

// character buffer
.equ CHAR_BUFFER, 0xC9000000
.equ CHAR_BUFFER_WIDTH, 79		// x
.equ CHAR_BUFFER_HEIGHT, 59		// y

// PS/2
.equ PS2_DATA, 0xFF200100
.equ PS2_CONTROL, 0xFF200104

.text
.global _start
_start:
        bl      input_loop
end:
        b       end

// ------------------------------------------------------------------------------------
// SUBROUTINES
// ------------------------------------------------------------------------------------

@ draws a point of specified color at specfied location
@ R0: x coordinate
@ R1: y coordinate
@ R2: color
VGA_draw_point_ASM:
	PUSH {R0-R1, R4-R5}
	LDR R4, =PIX_BUFFER
	LDR R5, =PIX_BUFFER_END
	LSL R0, #1
	LSL R1, #10
	ADD R0, R1
	ADD R0, R4
	// make sure we are within the buffer
	CMP R0, R4
	BLT SKIP_DRAW
	CMP R0, R5
	BGT SKIP_DRAW
	
	STRH R2, [R0]
	
SKIP_DRAW:
	POP {R0-R1, R4-R5}
	BX LR


@ sets every pixel in pixel buffer to 0 (black screen)
VGA_clear_pixelbuff_ASM:
	PUSH {R0-R2}
	LDR R0, =PIX_BUFFER_WIDTH
	LDR R1, =PIX_BUFFER_HEIGHT
	MOV R2, #0

PIX_BUFFER_CLEAR_LOOP:
	
	PUSH {LR}
	BL	VGA_draw_point_ASM
	POP {LR}
	
	SUBS R0, #1
	LDRLT R0, =PIX_BUFFER_WIDTH
	SUBLTS R1, #1
	LDRLT R1, =PIX_BUFFER_HEIGHT
	BLT PIX_BUFFER_CLEAR_END
	B PIX_BUFFER_CLEAR_LOOP

PIX_BUFFER_CLEAR_END:
	POP {R0-R2}
	BX LR


@ writes character to given location in character buffer
@ R0: x coordinate
@ R1: y coordinate
@ R2: ASCII code of character
VGA_write_char_ASM:
	PUSH {R0-R1, R4}
	LDR R4, =CHAR_BUFFER
	LSL R1, #7
	ADD R0, R1
	ADD R0, R4
	STRB R2, [R0]
	POP {R0-R1, R4}
	BX LR


@ sets every character in character buffer to 0
VGA_clear_charbuff_ASM:
	PUSH {R0-R2}
	LDR R0, =CHAR_BUFFER_WIDTH
	LDR R1, =CHAR_BUFFER_HEIGHT
	MOV R2, #0

CHAR_BUFFER_CLEAR_LOOP:	
	PUSH {LR}
	BL	VGA_write_char_ASM
	POP {LR}
	
	SUBS R0, #1
	LDRLT R0, =CHAR_BUFFER_WIDTH
	SUBLTS R1, #1
	LDRLT R1, =CHAR_BUFFER_HEIGHT
	BLT CHAR_BUFFER_CLEAR_END
	B CHAR_BUFFER_CLEAR_LOOP

CHAR_BUFFER_CLEAR_END:
	POP {R0-R2}
	BX LR


@ stores PS/2 keyboard data at pointer argument if RVALID is valid (1)
@ R0: pointer argument
@ return R0: RVALID
read_PS2_data_ASM:
	PUSH {R4-R5}
	
	LDR R4, =PS2_DATA
	LDR R4, [R4]
	AND R5, R4, #0x8000 // isolate RVALID bit
	LSR R5, #15
	TEQ R5, #1
	BNE EXIT_PS_DATA
	AND R4, #0xff	// isolate last 8 bits (data bits)
	STRB R4, [R0]
	
EXIT_PS_DATA:
	MOV R0, R5
	POP {R4-R5}
	BX LR


// ------------------------------------------------------------------------------------
// SUBROUTINES
// ------------------------------------------------------------------------------------

write_hex_digit:
	push    {r4, lr}
	cmp     r2, #9
	addhi   r2, r2, #55
	addls   r2, r2, #48
	and     r2, r2, #255
	bl      VGA_write_char_ASM
	pop     {r4, pc}
write_byte:
	push    {r4, r5, r6, lr}
	mov     r5, r0
	mov     r6, r1
	mov     r4, r2
	lsr     r2, r2, #4
	bl      write_hex_digit
	and     r2, r4, #15
	mov     r1, r6
	add     r0, r5, #1
	bl      write_hex_digit
	pop     {r4, r5, r6, pc}
input_loop:
	push    {r4, r5, lr}
	sub     sp, sp, #12
	bl      VGA_clear_pixelbuff_ASM
	bl      VGA_clear_charbuff_ASM
	mov     r4, #0
	mov     r5, r4
	b       .input_loop_L9
.input_loop_L13:
	ldrb    r2, [sp, #7]
	mov     r1, r4
	mov     r0, r5
	bl      write_byte
	add     r5, r5, #3
	cmp     r5, #79
	addgt   r4, r4, #1
	movgt   r5, #0
.input_loop_L8:
	cmp     r4, #59
	bgt     .input_loop_L12
.input_loop_L9:
	add     r0, sp, #7
	bl      read_PS2_data_ASM
	cmp     r0, #0
	beq     .input_loop_L8
	b       .input_loop_L13
.input_loop_L12:
	add     sp, sp, #12
	pop     {r4, r5, pc}