// pixel buffer
.equ PIX_BUFFER, 0xC8000000
.equ PIX_BUFFER_END, 0xC803BE7E
.equ PIX_BUFFER_WIDTH, 319		// x
.equ PIX_BUFFER_HEIGHT, 239		// y

// grid positions [0,8] from left to right, top to bottom
.equ X1, 100
.equ X2, 160
.equ X3, 220
.equ Y1, 80
.equ Y2, 140
.equ Y3, 200

// character buffer
.equ CHAR_BUFFER, 0xC9000000
.equ CHAR_BUFFER_WIDTH, 79		// x
.equ CHAR_BUFFER_HEIGHT, 59		// y

// PS/2
.equ PS2_DATA, 0xFF200100
.equ PS2_CONTROL, 0xFF200104

// colors
.equ WHITE, 0b1111111111111111
.equ BLACK, 0b0000000000000000
.equ GREEN, 0b0000011111100000
.equ RED,	0b1111100000000000
.equ BLUE,	0b0000000000011111

.text
.global _start
_start:
	
	// draw grid
	PUSH {LR}
	BL draw_grid_ASM
	POP {LR}

    // game starts on '0' keyboard input

	// enter game loop
GAME_LOOP:
    // write whose turn it is at top-center

    // wait for player input and display it (X / O)

    // repeat for other player

    // when game over, display result
	B GAME_LOOP
	
GAME_OVER:
	
	B END
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
	
	// loop logic
	SUBS R0, #1 // x--
	LDRLT R0, =PIX_BUFFER_WIDTH
	SUBLTS R1, #1 // y--
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
	
	// loop logic
	SUBS R0, #1 // x--
	LDRLT R0, =CHAR_BUFFER_WIDTH
	SUBLTS R1, #1 // y--
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


@ R0: x coordinate
@ R1: thickness (pixels)
@ R2: color
@ R3: padding
draw_ver_line_ASM:
	PUSH {R1, R4-R6}
	MOV R4, R1
	LSR R4, #1 // thickness / 2
	LDR R6, =PIX_BUFFER_WIDTH

	// x lower limit
	SUB R5, R0, R4
	// x greater limit
	ADD R0, R4

	CMP R0, R6
	// take into account if too close to right edge
	MOVGT R0, R6
	// y
	LDR R1, =PIX_BUFFER_HEIGHT
	SUB R1, R3

	// draw point for [x - (thickness/2) , x + (thickness/2] from top to bottom
VER_LINE_LOOP:
	PUSH {LR}
	BL	VGA_draw_point_ASM
	POP {LR}

	// loop logic
	SUB R1, #1 // y--
	CMP R1, R3 // limit is padding
	// reset y when y < padding
	LDRLT R1, =PIX_BUFFER_HEIGHT
	SUBLT R1, R3 // subtract padding from height
	SUBLT R0, #1 // x--
	CMP R0, R5
	BLT VER_LINE_END
	B VER_LINE_LOOP

VER_LINE_END:
	POP {R1, R4-R6}
    BX LR


@ R0: y coordinate
@ R1: thickness (pixels)
@ R2: color
@ R3: padding
draw_hor_line_ASM:
	PUSH {R1, R4-R6}
	MOV R4, R1
	LSR R4, #1 // thickness / 2
	LDR R6, =PIX_BUFFER_HEIGHT
	// change y to y register (R0 -> R1)
	MOV R1, R0

	// y lower limit
	SUB R5, R1, R4
	// y greater limit
	ADD R1, R4

	CMP R1, R6

	// take into account if too close to bottom edge
	MOVGT R1, R6
	// x
	LDR R0, =PIX_BUFFER_WIDTH
	SUB R0, R3

	// draw point for [y - (thickness/2) , y + (thickness/2] from left to right
HOR_LINE_LOOP:
	PUSH {LR}
	BL	VGA_draw_point_ASM
	POP {LR}

	// loop logic
	SUB R0, #1 // x--
	CMP R0, R3 // limit is padding
	// reset x when x < padding
	LDRLT R0, =PIX_BUFFER_WIDTH
	SUBLT R0, R3 // subtract padding from width
	SUBLT R1, #1 // y--
	CMP R1, R5
	BLT HOR_LINE_END
	B HOR_LINE_LOOP

HOR_LINE_END:
	POP {R1, R4-R6}
    BX LR
	

draw_grid_ASM:
	PUSH {R0-R1, R3}
	// make screen black
	PUSH {LR}
	BL VGA_clear_pixelbuff_ASM
	POP {LR}
	// DRAW GRID (60x60 squares)

	// draw vertical lines
	MOV R0, #70
	MOV R1, #3
	LDR R2, =GREEN
	MOV R3, #10

	PUSH {LR}
	BL draw_ver_line_ASM
	POP {LR}
	
	MOV R0, #130
	PUSH {LR}
	BL draw_ver_line_ASM
	POP {LR}
	
	MOV R0, #190
	PUSH {LR}
	BL draw_ver_line_ASM
	POP {LR}
	
	MOV R0, #250
	PUSH {LR}
	BL draw_ver_line_ASM
	POP {LR}
	
	// draw horizontal lines
	MOV R0, #30
	MOV R1, #38
	LDR R2, =BLACK
	MOV R3, #72
	PUSH {LR}
	BL draw_hor_line_ASM
	POP {LR}
	
	
	MOV R0, #10
	MOV R1, #3
	LDR R2, =GREEN
	MOV R3, #70
	PUSH {LR}
	BL draw_hor_line_ASM
	POP {LR}
	
	MOV R0, #50
	PUSH {LR}
	BL draw_hor_line_ASM
	POP {LR}

	MOV R0, #110
	PUSH {LR}
	BL draw_hor_line_ASM
	POP {LR}
	
	MOV R0, #170
	PUSH {LR}
	BL draw_hor_line_ASM
	POP {LR}
	
	MOV R0, #230
	PUSH {LR}
	BL draw_hor_line_ASM
	POP {LR}
	
	// draw 'X' and 'O' in top section
	
	POP {R0-R1, R3}
	BX LR

@ pattern:
@
@ 011000110
@ 001101100
@ 000111000
@ 001101100
@ 011000110
@
@ R0: x coordinate
@ R1: y coordinate
draw_X_ASM:
    BX LR


@ pattern:
@
@ 000111000
@ 011000110
@ 110000011
@ 011000110
@ 000111000
@
@ R0: x coordinate
@ R1: y coordinate
draw_O_ASM:
    BX LR


@ R0: player (0 (X) / 1 (O))
display_turn_ASM:
    BX LR


@ R0: winner (0: player0 / 1: player1 / 2: draw)
display_result_ASM:
    BX LR


END:
    B END
.end
