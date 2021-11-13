.data
// pixel buffer
.equ PIX_BUFFER, 0xC8000000
.equ PIX_BUFFER_WIDTH, 319		// x
.equ PIX_BUFFER_HEIGHT, 239		// y

// character buffer
.equ CHAR_BUFFER, 0xC9000000
.equ CHAR_BUFFER_WIDTH, 79		// x
.equ CHAR_BUFFER_HEIGHT, 59		// y

.text
.global _start
_start:

	ldr     r3, .colors+8
	str     r3, [sp]
	mov     r3, #120
	mov     r2, #214
	mov     r1, r3
	mov     r0, #106
	bl      draw_rectangle

end: b end

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


.colors:
	.word   2911
	.word   65535
	.word   45248

draw_rectangle:
	push    {r4, r5, r6, r7, r8, r9, r10, lr}
	ldr     r7, [sp, #32]
	add     r9, r1, r3
	cmp     r1, r9
	popge   {r4, r5, r6, r7, r8, r9, r10, pc}
	mov     r8, r0
	mov     r5, r1
	add     r6, r0, r2
	b       .line_L2
.line_L5:
	add     r5, r5, #1
	cmp     r5, r9
	popeq   {r4, r5, r6, r7, r8, r9, r10, pc}
.line_L2:
	cmp     r8, r6
	movlt   r4, r8
	bge     .line_L5
.line_L4:
	mov     r2, r7
	mov     r1, r5
	mov     r0, r4
	bl      VGA_draw_point_ASM
	add     r4, r4, #1
	cmp     r4, r6
	bne     .line_L4
	b       .line_L5