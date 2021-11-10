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

// colors
.equ WHITE, 0xFFFF
.equ BLACK, 0x0000
.equ GREEN, 0x07E0

.text
.global _start
_start:

    // fill screen with color

    // draw 207x207 px grid

    // game starts on '0' keyboard input

    // enter game loop

GAME_LOOP:
    // write whose turn it is at top-center

    // wait for player input and display it (X / O)

    // repeat for other player

    // when game over, display result

// ------------------------------------------------------------------------------------
// SUBROUTINES
// ------------------------------------------------------------------------------------

@ draws a point of specified color at specfied location
@ R0: x coordinate
@ R1: y coordinate
@ R2: color
VGA_draw_point_ASM:
	PUSH {R0-R1, R4}
	LDR R4, =PIX_BUFFER
	LSL R0, #1
	LSL R1, #10
	ADD R0, R1
	ADD R0, R4
	STRH R2, [R0]
	POP {R0-R1, R4}
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

END:
    B END
.end
