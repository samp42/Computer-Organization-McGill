// pixel buffer
.equ PIX_BUFFER, 0xC8000000
.equ PIX_BUFFER_END, 0xC803BE7E
.equ PIX_BUFFER_WIDTH, 319		// x
.equ PIX_BUFFER_HEIGHT, 239		// y

// grid positions [0,8] from left to right, top to bottom
X_COORD: .word 70, 139, 208
Y_COORD: .word 66, 135, 204

// character buffer
.equ CHAR_BUFFER, 0xC9000000
.equ CHAR_BUFFER_WIDTH, 79		// x
.equ CHAR_BUFFER_HEIGHT, 59		// y

// PS/2
.equ PS2_DATA, 0xFF200100
.equ PS2_CONTROL, 0xFF200104

// colors
.equ WHITE, 	0b1111111111111111
.equ BLACK, 	0b0000000000000000
.equ GREEN, 	0b0000011111100000
.equ RED,		0b1111100000000000
.equ BLUE,		0b0000000000011111
.equ PURPLE,	0b1111100000011111
.equ YELLOW,	0b0000011111111111

// characters
.equ ZERO,	0x34
.equ ONE,	0x16
.equ TWO,	0x1E
.equ THREE,	0x26
.equ FOUR,	0x25
.equ FIVE,	0x2E
.equ SIX,	0x36
.equ SEVEN,	0x3D
.equ EIGHT,	0x3E
.equ NINE, 	0x46

// X mark
X_ROWS: .hword 0b011000110, 0b001101100, 0b000111000, 0b001101100, 0b011000110

// O mark
O_ROWS: .hword 0b000111000, 0b011000110, 0b110000011, 0b011000110, 0b000111000

// grid
GRID: .space 36 // bytes for 9 squares: [0,0], [1,0], [2,0], [0,1], [1,1], [2,1], [0,2], [1,2], [2,2]

.text
.global _start
_start:
	
	// draw grid
	PUSH {LR}
	BL draw_grid_ASM
	POP {LR}
	
	PUSH {LR}
	BL draw_X_ASM
	POP {LR}

    // game starts on '0' keyboard input
	
	// setup player turn
	MOV R4, #0 // initially X player's turn

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

// draws a point of specified color at specfied location
// R0: x coordinate
// R1: y coordinate
// R2: color
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


// sets every pixel in pixel buffer to 0 (black screen)
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


// writes character to given location in character buffer
// R0: x coordinate
// R1: y coordinate
// R2: ASCII code of character
VGA_write_char_ASM:
	PUSH {R0-R1, R4}
	LDR R4, =CHAR_BUFFER
	LSL R1, #7
	ADD R0, R1
	ADD R0, R4
	STRB R2, [R0]
	POP {R0-R1, R4}
	BX LR


// sets every character in character buffer to 0
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


// stores PS/2 keyboard data at pointer argument if RVALID is valid (1)
// R0: pointer argument
// return R0: RVALID
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


// R0: x coordinate
// R1: thickness (pixels)
// R2: color
// R3: padding
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


// R0: y coordinate
// R1: thickness (pixels)
// R2: color
// R3: padding
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
	MOV R0, #56
	MOV R1, #3
	LDR R2, =GREEN
	MOV R3, #16
	PUSH {LR}
	BL draw_ver_line_ASM
	POP {LR}
	
	MOV R0, #125
	PUSH {LR}
	BL draw_ver_line_ASM
	POP {LR}
	
	MOV R0, #194
	PUSH {LR}
	BL draw_ver_line_ASM
	POP {LR}
	
	LDR R0, =#263
	PUSH {LR}
	BL draw_ver_line_ASM
	POP {LR}
	
	// draw horizontal lines
	MOV R0, #16
	MOV R1, #3
	LDR R2, =GREEN
	MOV R3, #56
	PUSH {LR}
	BL draw_hor_line_ASM
	POP {LR}

	MOV R0, #85
	PUSH {LR}
	BL draw_hor_line_ASM
	POP {LR}
	
	MOV R0, #154
	PUSH {LR}
	BL draw_hor_line_ASM
	POP {LR}
	
	MOV R0, #223
	PUSH {LR}
	BL draw_hor_line_ASM
	POP {LR}
	
	// draw 'X' and 'O' in top section
	
	POP {R0-R1, R3}
	BX LR
	
	
// validate move
// if valid (case not already used), records the move
// input
// R0: position [0,8]
// R1: move (1: player0 / 2: player1)
// return
// R0: 0/1 no/yes
validate_move_ASM:
	PUSH {R4-R6}
	LDR R4, =GRID
	MOV R5, #4
	MLA R6, R0, R5, R4
	LDR R4, [R6]
	
	// record move if no previous move at that square
	TEQ R4, #0
	STREQ R0, [R6]
	
	POP {R4-R6}
	BX LR

// pattern:
// 9x5
// 011000110
// 001101100
// 000111000
// 001101100
// 011000110
//
// R0: x position [0,2]
// R1: y position [0,2]
// R2: color
draw_X_ASM:
	PUSH {R4-R11}
	// x
	LDR R5, =X_COORD
	MOV R6, #4
	MLA R4, R0, R6, R5
	LDR R4, [R4]
	ADD R0, R4, #4
	
	// y
	ADD R5, #12 // y coordinates 3 words further in memory
	MLA R5, R1, R6, R5
	LDR R5, [R5]
	ADD R1, R5, #2
	MOV R6, R1 // save for later, because need to reset
	
	MOV R7, #8 // width (columns - 1)
	MOV R8, #4 // height (rows - 1)
	LDR R9, =X_ROWS
	LDR R10, [R9]
	
// loop through filter and write pixel if 1
X_LOOP:
	ANDS R11, R10, #0b1 // take last bit and determine if need to write or not
	
	BEQ SKIP_X_WRITE
	
	PUSH {LR}
	BL VGA_draw_point_ASM
	POP {LR}
	
SKIP_X_WRITE:
	SUBS R7, #1 // j--
	SUB R1, #1
	LSR R10, #1
	BGE X_LOOP
	
	// loop logic
	SUBS R8, #1 // i--
	BLT RETURN_X
	SUB R0, #1
	
	ADD R9, #2 // next row of character
	LDR R10, [R9]
	B X_LOOP

RETURN_X:
	POP {R4-R11}
    BX LR


// pattern:
// 9x5
// 000111000
// 011000110
// 110000011
// 011000110
// 000111000
//
// R0: x position [0,2]
// R1: y position [0,2]
// R2: color
draw_O_ASM:

RETURN_O:
    BX LR


// R0: player (1 (X) / 2 (O))
display_turn_ASM:
    BX LR


// checks wether the play is valid (square not filled)
// R0: keyboard input
get_player_input_ASM:
	BX LR


// R0: winner (0: draw / 1: player0 / 2: player1)
display_result_ASM:
    BX LR


END:
    B END
.end
