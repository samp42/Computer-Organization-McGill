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
.equ PURPLE,	0b1100000000011111
.equ PINK,		0b1111100000011100
.equ YELLOW,	0b1111111111100000
.equ ORANGE,	0b1111110011000000

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

// strings
// "Please press 0 to start"
// 23 characters, 4 spaces
.equ START_MESSAGE_LENGTH, 23
.equ START_MESSAGE_X, 10
START_MESSAGE:
	.byte 0x50
	.byte 0x6C
	.byte 0x65
	.byte 0x61
	.byte 0x73
	.byte 0x65
	.byte 0x20
	.byte 0x70
	.byte 0x72
	.byte 0x65
	.byte 0x73
	.byte 0x73
	.byte 0x20
	.byte 0x30
	.byte 0x20
	.byte 0x74
	.byte 0x6F
	.byte 0x20
	.byte 0x73
	.byte 0x74
	.byte 0x61
	.byte 0x72
	.byte 0x74
	
// "PLAYER 0 WINS!"
// 14 characters, 2 spaces
.equ WINNING_MESSAGE_LENGTH, 14
.equ WINNING_MESSAGE_X, 10
WINNING_MESSAGE_0:
	.byte 0x50
	.byte 0x4C
	.byte 0x41
	.byte 0x59
	.byte 0x45
	.byte 0x52
	.byte 0x20
	.byte 0x30 // 0
	.byte 0x20
	.byte 0x57
	.byte 0x49
	.byte 0x4E
	.byte 0x53
	.byte 0x21
	
// "PLAYER 1 WINS!"
WINNING_MESSAGE_1:
	.byte 0x50
	.byte 0x4C
	.byte 0x41
	.byte 0x59
	.byte 0x45
	.byte 0x52
	.byte 0x20
	.byte 0x31 // 1
	.byte 0x20
	.byte 0x57
	.byte 0x49
	.byte 0x4E
	.byte 0x53
	.byte 0x21
	
// "Draw... :("
// 10 characters, 1 space
.equ START_MESSAGE_LENGTH, 10
.equ DRAW_MESSAGE_X, 10
DRAW_MESSAGE:
	.byte 0x44
	.byte 0x72
	.byte 0x61
	.byte 0x77
	.byte 0x2E
	.byte 0x2E
	.byte 0x2E
	.byte 0x20
	.byte 0x3A
	.byte 0x28

// X mark
X_ROWS:
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000

// SQUARE mark
SQUARE_ROWS:
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111

// CIRCLE mark
CIRCLE_ROWS:
	.word 0b0000000000000111110000000000000
	.word 0b0000000000011111111100000000000
	.word 0b0000000001111111111111000000000
	.word 0b0000000011111000001111100000000
	.word 0b0000000111110000000111110000000
	.word 0b0000001111100000000011111000000
	.word 0b0000111110000000000000111110000
	.word 0b0001111100000000000000011111000
	.word 0b0011111000000000000000001111100
	.word 0b0011110000000000000000000111100
	.word 0b0111110000000000000000000111110
	.word 0b0111100000000000000000000011110
	.word 0b0111100000000000000000000011110
	.word 0b1111100000000000000000000011111
	.word 0b1111000000000000000000000001111
	.word 0b1111000000000000000000000001111
	.word 0b1111000000000000000000000001111
	.word 0b1111100000000000000000000011111
	.word 0b0111100000000000000000000011110
	.word 0b0111100000000000000000000011110
	.word 0b0111110000000000000000000111110
	.word 0b0011110000000000000000000111100
	.word 0b0011111000000000000000001111100
	.word 0b0001111100000000000000011111000
	.word 0b0000111110000000000000111110000
	.word 0b0000011111000000000001111100000
	.word 0b0000001111100000000011111000000
	.word 0b0000000011111000001111100000000
	.word 0b0000000001111111111111000000000
	.word 0b0000000000111111111110000000000
	.word 0b0000000000000111110000000000000
	
// TRIANGLE mark
TRIANGLE_ROWS:
	.word 0b0000000000000111110000000000000
	.word 0b0000000000000111110000000000000
	.word 0b0000000000011111111100000000000
	.word 0b0000000000111111111110000000000
	.word 0b0000000001111110111111000000000
	.word 0b0000000001111100011111000000000
	.word 0b0000000011111000001111100000000
	.word 0b0000000011111000001111100000000
	.word 0b0000000111110000000111110000000
	.word 0b0000000111110000000111110000000
	.word 0b0000001111100000000011111000000
	.word 0b0000011111000000000001111100000
	.word 0b0000011111000000000001111100000
	.word 0b0000111110000000000000111110000
	.word 0b0000111110000000000000111110000
	.word 0b0001111100000000000000011111000
	.word 0b0001111100000000000000011111000
	.word 0b0001111100000000000000011111000
	.word 0b0011111000000000000000001111100
	.word 0b0011111000000000000000001111100
	.word 0b0011111000000000000000001111100
	.word 0b0111110000000000000000000111110
	.word 0b0111110000000000000000000111110
	.word 0b0111110000000000000000000111110
	.word 0b1111100000000000000000000011111
	.word 0b1111100000000000000000000011111
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111

// SPACE INVADER
SPACE_ROWS:
	.word 0b0000000000000000000000000000000
	.word 0b0000000000000000000000000000000
	.word 0b0000000000000000000000000000000
	.word 0b0000011100000000000000011100000
	.word 0b0000011100000000000000011100000
	.word 0b0000011100000000000000011100000
	.word 0b0000000011100000000011100000000
	.word 0b0000000011100000000011100000000
	.word 0b0000000011100000000011100000000
	.word 0b0000011111111111111111111100000
	.word 0b0000011111111111111111111100000
	.word 0b0000011111111111111111111100000
	.word 0b0011111100011111111100011111100
	.word 0b0011111100011111111100011111100
	.word 0b0011111100011111111100011111100
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111
	.word 0b1100011111111111111111111100011
	.word 0b1100011111111111111111111100011
	.word 0b1100011111111111111111111100011
	.word 0b1100011100000000000000011100011
	.word 0b1100011100000000000000011100011
	.word 0b1100011100000000000000011100011
	.word 0b0000000011111100011111100000000
	.word 0b0000000011111100011111100000000
	.word 0b0000000011111100011111100000000
	.word 0b0000000000000000000000000000000
	.word 0b0000000000000000000000000000000
	.word 0b0000000000000000000000000000000
	.word 0b0000000000000000000000000000000
	
// STONKS
STONKS_ROWS:
	.word 0b1100000000000000000000000000000
	.word 0b1101110111011101010101011100000
	.word 0b1101000010010101110111010000000
	.word 0b1101110010010101110110011100001
	.word 0b1100010010010101110101000100110
	.word 0b1101110010011101010101011100110
	.word 0b1100000000000000000000000001100
	.word 0b1100000000000000000000000001100
	.word 0b1100000000000000000000000011000
	.word 0b1100000000000000000000000011000
	.word 0b1100000000000000000000000110000
	.word 0b1100000000000000000000000110000
	.word 0b1100000000000000000000001100000
	.word 0b1100000000000000000000001100000
	.word 0b1100000000000000000000011000000
	.word 0b1100000000000000000000011000000
	.word 0b1100000000000000000000110000000
	.word 0b1100000000000000110000110000000
	.word 0b1100000000000001101101100000000
	.word 0b1100000001100001101101100000000
	.word 0b1100000011011011000110000000000
	.word 0b1100000011001100000000000000000
	.word 0b1100000110000000000000000000000
	.word 0b1100001100000000000000000000000
	.word 0b1100001100000000000000000000000
	.word 0b1100011000000000000000000000000
	.word 0b1100110000000000000000000000000
	.word 0b1101100000000000000000000000000
	.word 0b1111000000000000000000000000000
	.word 0b1111111111111111111111111111111
	.word 0b1111111111111111111111111111111


// BITCOIN mark
BITCOIN_ROWS:
	.word 0b0000000011100111000000000000000
	.word 0b0000000011100111000000000000000
	.word 0b0000000011100111000000000000000
	.word 0b0000000011100111000000000000000
	.word 0b0000011111111111111000000000000
	.word 0b0000011111111111111100000000000
	.word 0b0000011111111111111110000000000
	.word 0b0000011100000000011110000000000
	.word 0b0000011100000000001111000000000
	.word 0b0000011100000000000111100000000
	.word 0b0000011100000000000011100000000
	.word 0b0000011100000000000011100000000
	.word 0b0000011100000000000111000000000
	.word 0b0000011100000000011111000000000
	.word 0b0000011111111111111110000000000
	.word 0b0000011111111111111100000000000
	.word 0b0000011111111111111110000000000
	.word 0b0000011100000000011111000000000
	.word 0b0000011100000000000111000000000
	.word 0b0000011100000000000011100000000
	.word 0b0000011100000000000011100000000
	.word 0b0000011100000000000111100000000
	.word 0b0000011100000000001111000000000
	.word 0b0000011100000000011111000000000
	.word 0b0000011111111111111110000000000
	.word 0b0000011111111111111100000000000
	.word 0b0000011111111111111000000000000
	.word 0b0000000011100111000000000000000
	.word 0b0000000011100111000000000000000
	.word 0b0000000011100111000000000000000
	.word 0b0000000011100111000000000000000




// grid
GRID: .space 36 // bytes for 9 squares: [0,0], [1,0], [2,0], [0,1], [1,1], [2,1], [0,2], [1,2], [2,2]

// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
// ------------------------ PROGRAM START ------------------------------
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
.text
.global _start
_start:
	
	// draw grid
	PUSH {LR}
	BL draw_grid_ASM
	POP {LR}
	
	// write '0' at (70, 66)
	MOV R0, #0
	MOV R1, #0
	LDR R2, =YELLOW
	LDR R3, =SPACE_ROWS
	PUSH {LR}
	BL draw_mark_ASM
	POP {LR}
	
	MOV R0, #1
	MOV R1, #0
	LDR R2, =ORANGE
	LDR R3, =BITCOIN_ROWS
	PUSH {LR}
	BL draw_mark_ASM
	POP {LR}
	
	MOV R0, #2
	MOV R1, #0
	LDR R2, =GREEN
	LDR R3, =STONKS_ROWS
	PUSH {LR}
	BL draw_mark_ASM
	POP {LR}
	
	MOV R0, #1
	MOV R1, #1
	LDR R2, =PINK
	LDR R3, =X_ROWS
	PUSH {LR}
	BL draw_mark_ASM
	POP {LR}
	
	MOV R0, #2
	MOV R1, #2
	LDR R2, =BLUE
	LDR R3, =SQUARE_ROWS
	PUSH {LR}
	BL draw_mark_ASM
	POP {LR}
	
	MOV R0, #1
	MOV R1, #2
	LDR R2, =RED
	LDR R3, =TRIANGLE_ROWS
	PUSH {LR}
	BL draw_mark_ASM
	POP {LR}
	
	MOV R0, #0
	MOV R1, #2
	LDR R2, =ORANGE
	LDR R3, =CIRCLE_ROWS
	PUSH {LR}
	BL draw_mark_ASM
	POP {LR}
	
	
	PUSH {LR}
	BL write_string_ASM
	POP {LR}

    // game starts on '0' keyboard input
	
	// setup player turn (0: player0 / 1: player1)
	MOV R4, #0 // initially X player's turn
	// setup number of plays (to know if there is a draw)
	// also avoids checking for a result before move 5
	MOV R11, #1


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
	

// writes a message with given length at specified x coordinate (y is hardcoded)
// R0: x coordinate
// R2: message address
// R3: message length
write_string_ASM:
	PUSH {R4}
	
	MOV R0, #3
	MOV R1, #2
	MOV R2, #45
	
	PUSH {LR}
	BL VGA_write_char_ASM
	POP {LR}
	// for(0...message length) { print character, x++}
	POP {R4}
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
// if valid (square not already used), records the move
// input
// R0: position [1,9]
// R1: move (1: player0 / 2: player1)
// return
// R0: 0/1 no/yes
validate_move_ASM:
	PUSH {R4-R6}
	LDR R4, =GRID
	MOV R5, #4
	// use 0-8 instead of 1-9 to fetch list of moves
	SUB R6, R0, #1
	MLA R6, R6, R5, R4
	LDR R4, [R6]
	
	// record move if no previous move at that square
	TEQ R4, #0
	STREQ R0, [R6]
	
	POP {R4-R6}
	BX LR


// draws mark at location
// R0: x position [0,2]
// R1: y position [0,2]
// R2: color
// R3: character address
draw_mark_ASM:
	PUSH {R4-R10}
	// x
	LDR R5, =X_COORD
	MOV R6, #4
	MLA R4, R0, R6, R5
	LDR R4, [R4]
	// RANDOM NUMBERS I DON'T KNOW WHY THIS IS THE WAY IT IS
	// RANDOM NUMBERS I DON'T KNOW WHY THIS IS THE WAY IT IS
	// RANDOM NUMBERS I DON'T KNOW WHY THIS IS THE WAY IT IS
	// RANDOM NUMBERS I DON'T KNOW WHY THIS IS THE WAY IT IS
	// RANDOM NUMBERS I DON'T KNOW WHY THIS IS THE WAY IT IS
	ADD R0, R4, #36 // start at edge of character
	
	// y
	ADD R5, #12 // y coordinates 3 words further in memory, saves a LDR
	MLA R5, R1, R6, R5
	LDR R5, [R5]
	// RANDOM NUMBERS I DON'T KNOW WHY THIS IS THE WAY IT IS
	// RANDOM NUMBERS I DON'T KNOW WHY THIS IS THE WAY IT IS
	// RANDOM NUMBERS I DON'T KNOW WHY THIS IS THE WAY IT IS
	// RANDOM NUMBERS I DON'T KNOW WHY THIS IS THE WAY IT IS
	// RANDOM NUMBERS I DON'T KNOW WHY THIS IS THE WAY IT IS
	ADD R1, R5, #0 // start at edge of character
	MOV R6, R1 // save for later, because need to reset
	
	MOV R7, #30 // width (columns - 1), aka x
	MOV R8, #30 // height (rows - 1), aka y
	MOV R9, R3
	LDR R10, [R9]
	
// loop through filter and write pixel if 1
CHAR_LOOP:
	TST R10, #0b1 // take last bit and determine if need to write or not
	
	BEQ SKIP_CHAR_WRITE
	
	PUSH {LR}
	BL VGA_draw_point_ASM
	POP {LR}
	
SKIP_CHAR_WRITE:
	SUB R1, #1
	LSR R10, #1
	SUBS R7, #1 // y--
	BGE CHAR_LOOP
	// reset y
	MOV R7, #30
	MOV R1, R6
	// go to next row of pixels
	
	
	// loop logic
	SUBS R8, #1 // x--
	BLT RETURN_CHAR
	SUB R0, #1
	
	ADD R9, #4 // next row of character
	LDR R10, [R9]
	B CHAR_LOOP

RETURN_CHAR:
	POP {R4-R10}
    BX LR


// R0: player (1 (X) / 2 (O))
display_turn_ASM:
    BX LR


// checks wether the play is valid (square not filled)
// R0: keyboard input
get_player_input_ASM:
	// 
	BX LR


// checks if there is a draw or if a player won
// return
// R0: result (0: nothing yet / 1: player0 won / 2: player 2 won / 3: draw)
check_result_ASM:
	PUSH {R4-R5}
	LDR R4, =GRID
	LDR R5, [R4]
	
	// check for horizontal line (3 consecutives similar plays)
	// [0,0] == [1,0] == [2,0] || [0,1] == [1,1] == [2,1] || [0,2] == [1,2] == [2,2]
	
	// check for vertical line (3 similar plays at every +3 square)
	// [0,0] == [0,1] == [0,2] || [1,0] == [1,1] == [1,2] || [2,0] == [2,1] == [2,2]
	
	// check for left diagonal
	// [0,0] == [1,1] == [2,2]
	
	
	// check for right diagonal
	// [2,0] == [1,1] == [0,2]
	
	// check for draw
	// have already checked if someone won, so if we reach this case and number of plays is 9,
	// there is a draw
	CMP R11, #9
	MOVEQ R0, #3
	
	// have checked every case, none applies, the game is still on
	MOVNE R0, #0
	
RETURN_RESULT:
	POP {R4-R5}
	BX LR

// R0: winner (0: draw / 1: player0 / 2: player1)
display_result_ASM:
    BX LR
	

// self-explanatory
// input
// R0: x1
// R1: x2
// return
// R0: x1 % x2
modulo_ASM:
	CMP R0, R1
	// if R0 == R1, modulo is 0
	// if R0 < R1, modulo is R0
	MOVEQ R0, #0
	BLE RETURN_MODULO
	
	// else (if R0 > R1), R0 = R0 - R1
	SUB R0, R1
	PUSH {LR}
	BL modulo_ASM
	POP {LR}
	
RETURN_MODULO:
	BX LR
	
	
END:
    B END
.end
