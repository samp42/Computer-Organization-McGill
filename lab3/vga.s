.data
// pixel buffer
.equ PIX_BUFFER, 0xC8000000
.equ PIX_BUFFER_END, 0xC803BE7E
.equ PIX_BUFFER_WIDTH, 319		// x
.equ PIX_BUFFER_HEIGHT, 239		// y

// character buffer
.equ CHAR_BUFFER, 0xC9000000
.equ CHAR_BUFFER_WIDTH, 79		// x
.equ CHAR_BUFFER_HEIGHT, 59		// y

.text
.global _start
_start:
	bl      draw_test_screen
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


// ------------------------------------------------------------------------------------
// SUBROUTINES
// ------------------------------------------------------------------------------------

draw_test_screen:
	push    {r4, r5, r6, r7, r8, r9, r10, lr}
	bl      VGA_clear_pixelbuff_ASM
	bl      VGA_clear_charbuff_ASM
	mov     r6, #0
	ldr     r10, .draw_test_screen_L8
	ldr     r9, .draw_test_screen_L8+4
	ldr     r8, .draw_test_screen_L8+8
	b       .draw_test_screen_L2
.draw_test_screen_L7:
	add     r6, r6, #1
	cmp     r6, #320
	beq     .draw_test_screen_L4
.draw_test_screen_L2:
	smull   r3, r7, r10, r6
	asr     r3, r6, #31
	rsb     r7, r3, r7, asr #2
	lsl     r7, r7, #5
	lsl     r5, r6, #5
	mov     r4, #0
.draw_test_screen_L3:
	smull   r3, r2, r9, r5
	add     r3, r2, r5
	asr     r2, r5, #31
	rsb     r2, r2, r3, asr #9
	orr     r2, r7, r2, lsl #11
	lsl     r3, r4, #5
	smull   r0, r1, r8, r3
	add     r1, r1, r3
	asr     r3, r3, #31
	rsb     r3, r3, r1, asr #7
	orr     r2, r2, r3
	mov     r1, r4
	mov     r0, r6
	bl      VGA_draw_point_ASM
	add     r4, r4, #1
	add     r5, r5, #32
	cmp     r4, #240
	bne     .draw_test_screen_L3
	b       .draw_test_screen_L7
.draw_test_screen_L4:
	mov     r2, #72
	mov     r1, #5
	mov     r0, #20
	bl      VGA_write_char_ASM
	mov     r2, #101
	mov     r1, #5
	mov     r0, #21
	bl      VGA_write_char_ASM
	mov     r2, #108
	mov     r1, #5
	mov     r0, #22
	bl      VGA_write_char_ASM
	mov     r2, #108
	mov     r1, #5
	mov     r0, #23
	bl      VGA_write_char_ASM
	mov     r2, #111
	mov     r1, #5
	mov     r0, #24
	bl      VGA_write_char_ASM
	mov     r2, #32
	mov     r1, #5
	mov     r0, #25
	bl      VGA_write_char_ASM
	mov     r2, #87
	mov     r1, #5
	mov     r0, #26
    bl      VGA_write_char_ASM
	mov     r2, #111
	mov     r1, #5
	mov     r0, #27
	bl      VGA_write_char_ASM
	mov     r2, #114
	mov     r1, #5
	mov     r0, #28
	bl      VGA_write_char_ASM
	mov     r2, #108
	mov     r1, #5
	mov     r0, #29
	bl      VGA_write_char_ASM
	mov     r2, #100
	mov     r1, #5
	mov     r0, #30
	bl      VGA_write_char_ASM
	mov     r2, #33
	mov     r1, #5
	mov     r0, #31
	bl      VGA_write_char_ASM
	pop     {r4, r5, r6, r7, r8, r9, r10, pc}
.draw_test_screen_L8:
	.word   1717986919
	.word   -368140053
	.word   -2004318071
.end
