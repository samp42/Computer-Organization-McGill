.data
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
.equ PINK,		0b1111100000010110
.equ YELLOW,	0b1111111111100000
.equ ORANGE,	0b1111110011000000

// characters
NUMBERS:
	.word 0x34
	.word 0x16
	.word 0x1E
	.word 0x26
	.word 0x25
	.word 0x2E
	.word 0x36
	.word 0x3D
	.word 0x3E
	.word 0x46

// strings
// "Please press 0 to start"
// 23 characters, 4 spaces
.equ START_MESSAGE_LENGTH, 23
.equ START_MESSAGE_X, 28
START_MESSAGE:
	.word 0x50
	.word 0x6C
	.word 0x65
	.word 0x61
	.word 0x73
	.word 0x65
	.word 0x20
	.word 0x70
	.word 0x72
	.word 0x65
	.word 0x73
	.word 0x73
	.word 0x20
	.word 0x30
	.word 0x20
	.word 0x74
	.word 0x6F
	.word 0x20
	.word 0x73
	.word 0x74
	.word 0x61
	.word 0x72
	.word 0x74
	
// "Player 0's turn"
// 15 characters, 2 spaces
.equ PLAYER_0_MESSAGE_LENGTH, 15
.equ PLAYER_0_MESSAGE_X, 33
PLAYER_0_MESSAGE:
	.word 0x50
	.word 0x6C
	.word 0x61
	.word 0x79
	.word 0x65
	.word 0x72
	.word 0x20
	.word 0x30 // 0
	.word 0x27
	.word 0x73
	.word 0x20
	.word 0x74
	.word 0x75
	.word 0x72
	.word 0x6E

// "Player 1's turn"
// 15 characters, 2 spaces
.equ PLAYER_1_MESSAGE_LENGTH, 15
.equ PLAYER_1_MESSAGE_X, 33
PLAYER_1_MESSAGE:
	.word 0x50
	.word 0x6C
	.word 0x61
	.word 0x79
	.word 0x65
	.word 0x72
	.word 0x20
	.word 0x31 // 1
	.word 0x27
	.word 0x73
	.word 0x20
	.word 0x74
	.word 0x75
	.word 0x72
	.word 0x6E

	
// "PLAYER 0 WINS!"
// 14 characters, 2 spaces
.equ WINNING_MESSAGE_LENGTH, 14
.equ WINNING_MESSAGE_X, 33
WINNING_MESSAGE_0:
	.word 0x50
	.word 0x4C
	.word 0x41
	.word 0x59
	.word 0x45
	.word 0x52
	.word 0x20
	.word 0x30 // 0
	.word 0x20
	.word 0x57
	.word 0x49
	.word 0x4E
	.word 0x53
	.word 0x21
	
// "PLAYER 1 WINS!"
WINNING_MESSAGE_1:
	.word 0x50
	.word 0x4C
	.word 0x41
	.word 0x59
	.word 0x45
	.word 0x52
	.word 0x20
	.word 0x31 // 1
	.word 0x20
	.word 0x57
	.word 0x49
	.word 0x4E
	.word 0x53
	.word 0x21
	
// "Draw... :("
// 10 characters, 1 space
.equ DRAW_MESSAGE_LENGTH, 10
.equ DRAW_MESSAGE_X, 10
DRAW_MESSAGE:
	.word 0x44
	.word 0x72
	.word 0x61
	.word 0x77
	.word 0x2E
	.word 0x2E
	.word 0x2E
	.word 0x20
	.word 0x3A
	.word 0x28

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

	// clear char buffer
	PUSH {LR}
	BL VGA_clear_charbuff_ASM
	POP {LR}
	
	// draw grid
	PUSH {LR}
	BL draw_grid_ASM
	POP {LR}
	
	// display start message
	LDR R0, =START_MESSAGE_X
	LDR R1, =START_MESSAGE
	LDR R3, =START_MESSAGE_LENGTH
	
	PUSH {LR}
	BL write_string_ASM
	POP {LR}

    // game starts on '0' keyboard input
WAIT_FOR_START_LOOP:
	PUSH {LR}
	BL get_player_input_ASM
	POP {LR}
	
	CMP R1, #1
	BNE WAIT_FOR_START_LOOP
	
	CMP R0, #0
	BNE WAIT_FOR_START_LOOP
	// if get_player_input_ASM == 0, exit loop and enter GAME_LOOP
	
	// setup player turn (0: player0 / 1: player1)
	MOV R4, #0 // initially X player's turn
	// setup number of plays (to know if there is a draw)
	// also avoids checking for a result before move 5
	MOV R11, #0
	
	// setup player 0 as purple alien monster
	LDR R5, =PURPLE
	LDR R6, =SPACE_ROWS
	
	// setup player 1 as orange bitcoin
	LDR R8, =ORANGE
	LDR R9, =BITCOIN_ROWS


	// enter game loop
GAME_LOOP:
    // write whose turn it is at top-center
	CMP R4, #0
	LDREQ R0, =PLAYER_0_MESSAGE_X
	LDRNE R0, =PLAYER_1_MESSAGE_X
	LDREQ R1, =PLAYER_0_MESSAGE
	LDRNE R1, =PLAYER_1_MESSAGE
	LDREQ R3, =PLAYER_0_MESSAGE_LENGTH
	LDRNE R3, =PLAYER_1_MESSAGE_LENGTH
	
	PUSH {LR}
	BL write_string_ASM
	POP {LR}
	
    // wait for player input
PLAYER_INPUT_LOOP:
	// get input
	PUSH {LR}
	BL get_player_input_ASM
	POP {LR}
	
	CMP R1, #1
	BNE PLAYER_INPUT_LOOP
	
	// check if valid move, if not, repeat
	ADD R1, R4, #1
	PUSH {LR}
	BL validate_move_ASM
	POP {LR}
	
	// if move not valid, get other input
	CMP R1, #0
	BEQ PLAYER_INPUT_LOOP
	
	// get move coordinates
	PUSH {LR}
	BL get_move_coordinates_ASM
	POP {LR}
	
	// display move
	CMP R4, #0
	MOVEQ R2, R5
	MOVNE R2, R8
	MOVEQ R3, R6
	MOVNE R3, R9
	
	PUSH {LR}
	BL draw_mark_ASM
	POP {LR}
	
	// update move counter
	ADD R11, #1
	
	CMP R11, #5
	BLT UPDATE_GAME_LOOP
	
	// if at least 5 move played, check if someone has won
	PUSH {LR}
	BL check_result_ASM
	POP {LR}
	
	// check result
	CMP R0, #0
	BNE GAME_OVER
	
	
UPDATE_GAME_LOOP:
	// other player's turn
	EOR R4, #1
	B GAME_LOOP
	
GAME_OVER:
	// display result
	CMP R0, #1 // player 0 won
	LDREQ R0, =WINNING_MESSAGE_X
	LDREQ R1, =WINNING_MESSAGE_0
	LDREQ R3, =WINNING_MESSAGE_LENGTH
	
	CMP R0, #2 // player 1 won
	LDREQ R0, =WINNING_MESSAGE_X
	LDREQ R1, =WINNING_MESSAGE_1
	LDREQ R3, =WINNING_MESSAGE_LENGTH
	
	CMP R0, #3 // draw
	LDREQ R0, =DRAW_MESSAGE_X
	LDREQ R1, =DRAW_MESSAGE
	LDREQ R3, =DRAW_MESSAGE_LENGTH
	
	PUSH {LR}
	BL write_string_ASM
	POP {LR}
	
	// gracefully exit
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
// R1: message address
// R3: message length
write_string_ASM:
	PUSH {R4}
	
	MOV R4, R1
	MOV R1, #1 // hardcoded y
	
	PUSH {LR}
	BL VGA_clear_charbuff_ASM
	POP {LR}
	
	// for(0...message length) { print character, x++}
WRITE_STRING_LOOP:
	LDR R2, [R4], #4
	
	PUSH {LR}
	BL VGA_write_char_ASM
	POP {LR}
	
	ADD R0, #1
	SUBS R3, #1
	BGT WRITE_STRING_LOOP
	
	POP {R4}
	BX LR


// MODIFIED FROM PS2.S !!!!
// stores PS/2 keyboard data at pointer argument if RVALID is valid (1)
// R0: pointer argument
// return
// R0: RVALID
// R1: DATA
read_PS2_data_ASM:
	PUSH {R5}
	
	LDR R1, =PS2_DATA
	LDR R1, [R1]
	AND R5, R1, #0x8000 // isolate RVALID bit
	LSR R5, #15
	TEQ R5, #1
	BNE EXIT_PS_DATA
	AND R1, #0xff	// isolate last 8 bits (data bits)
	STRB R1, [R0]
	
EXIT_PS_DATA:
	MOV R0, R5
	POP {R5}
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
// R1: 0/{move'} 0 if invalid, otherwise returns the move (1/2)
validate_move_ASM:
	PUSH {R4-R6}
	LDR R4, =GRID
	MOV R5, #4
	
	// use 0-8 instead of 1-9 to fetch list of moves
	SUB R6, R0, #1
	MLA R6, R6, R5, R4
	LDR R4, [R6]
	
	// record move if no previous move at that square
	CMP R4, #0
	STREQ R1, [R6]
	
	// there is a move, return 0 (invalid)
	MOVNE R1, #0
	
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
	MOV R1, R5 // start at edge of character
	MOV R6, R1 // save for later because need to reset
	
	MOV R7, #30 // width (columns - 1), aka x
	MOV R8, #30 // height (rows - 1), aka y
	MOV R9, R3
	LDR R10, [R9]
	
// loop through filter and write pixel if 1
MARK_LOOP:
	TST R10, #0b1 // take last bit and determine if need to write or not
	
	BEQ SKIP_MARK_WRITE
	
	PUSH {LR}
	BL VGA_draw_point_ASM
	POP {LR}
	
SKIP_MARK_WRITE:
	SUB R1, #1
	LSR R10, #1
	SUBS R7, #1 // y--
	BGE MARK_LOOP
	// reset y
	MOV R7, #30
	MOV R1, R6
	// go to next row of pixels
	
	
	// loop logic
	SUBS R8, #1 // x--
	BLT RETURN_MARK
	SUB R0, #1
	
	ADD R9, #4 // next row of character
	LDR R10, [R9]
	B MARK_LOOP

RETURN_MARK:
	POP {R4-R10}
    BX LR


// checks wether the play is valid (square not filled)
// also receives '0' when ready to start
// input
// R0: keyboard input
// return
// R0: number [0,9]
// R1: write (0/1), wether it is actually an input
get_player_input_ASM:
	PUSH {R4-R5}
	
	LDR R4, =NUMBERS
	MOV R0, #10 // invalid character
	
	// make code
	PUSH {LR}
	BL read_PS2_data_ASM
	POP {LR}
	
	CMP R0, #1
	// player input not valid somehow
	BNE RETURN_PLAYER_INPUT
	
	// first look for #0xFO (break code)
	//PUSH {LR}
	//BL read_PS2_data_ASM
	//POP {LR}
	
	//CMP R0, #1
	// player input not valid somehow
	//BNE RETURN_PLAYER_INPUT
	
	//CMP R1, #0xF0
	//BNE RETURN_PLAYER_INPUT
	
	//PUSH {LR}
	//BL read_PS2_data_ASM
	//POP {LR}
	
	//CMP R0, #1
	// player input not valid somehow
	//BNE RETURN_PLAYER_INPUT
	
	CMP R1, #0x45
	
	// else check what character it is
	MOV R0, #0
	
	// workaround for '0'
	MOVEQ R1, #1
	BEQ RETURN_PLAYER_INPUT
	
NUM_VERIF_LOOP:
	LDR R5, [R4], #4 // R5 = *[R4++]
	
	// test every input 1 by 1... :(
	CMP R1, R5
	MOVEQ R1, #1
	BEQ RETURN_PLAYER_INPUT
	ADD R0, #1
	
	CMP R0, #10
	BGE STEP_OUT_LOOP
	
	B NUM_VERIF_LOOP

// avoid infinite loop (i.e.: didn't find a character between [0,9]
STEP_OUT_LOOP:
	MOV R1, #0
	
RETURN_PLAYER_INPUT:
	POP {R4-R5}
	BX LR


// checks if there is a draw or if a player won
// return
// R0: result (0: nothing yet / 1: player0 won / 2: player 2 won / 3: draw)
check_result_ASM:
	PUSH {R4-R9}
	LDR R4, =GRID
	MOV R5, #2 // loop counter
	
	// loop for horizontal and vertical lines since there are 3 possibilities for each
CHECK_GRID_LOOP:
	// check for horizontal line (3 consecutives similar plays)
	// [0,0] == [1,0] == [2,0] || [0,1] == [1,1] == [2,1] || [0,2] == [1,2] == [2,2]
	CMP R5, #0
	BNE HOR_1
	LDR R7, [R4] 		// [0,0]
	LDR R8, [R4, #12]	// [1,0]
	LDR R9, [R4, #24]	// [2,0]
	
	CMP R7, R8
	BNE HOR_1
	
	CMP R8, R9
	BNE HOR_1
	
	// line is a win!
	CMP R7, #0
	BEQ HOR_1
	MOVNE R0, R7
	BNE RETURN_RESULT
	
HOR_1:
	CMP R5, #1
	BNE HOR_2
	LDR R7, [R4, #4] 	// [0,1]
	LDR R8, [R4, #16]	// [1,1]
	LDR R9, [R4, #28]	// [2,1]
	
	CMP R7, R8
	BNE HOR_2
	
	CMP R8, R9
	BNE HOR_2
	
	// line is a win!
	CMP R7, #0
	BEQ HOR_2
	MOVNE R0, R7
	BNE RETURN_RESULT
	
HOR_2:
	CMP R5, #2
	BNE VER_0
	LDR R7, [R4, #8] 	// [0,2]
	LDR R8, [R4, #20]	// [1,2]
	LDR R9, [R4, #32]	// [2,2]
	
	CMP R7, R8
	BNE VER_0
	
	CMP R8, R9
	BNE VER_0
	
	// line is a win!
	CMP R7, #0
	BEQ VER_0
	MOVNE R0, R7
	BNE RETURN_RESULT
	
	// check for vertical line (3 similar plays at every +3 square)
	// [0,0] == [0,1] == [0,2] || [1,0] == [1,1] == [1,2] || [2,0] == [2,1] == [2,2]
VER_0:
	CMP R5, #0
	BNE VER_1
	LDR R7, [R4] 		// [0,0]
	LDR R8, [R4, #4]	// [0,1]
	LDR R9, [R4, #8]	// [0,2]
	
	CMP R7, R8
	BNE VER_1
	
	CMP R8, R9
	BNE VER_1
	
	// line is a win!
	CMP R7, #0
	BEQ VER_1
	MOVNE R0, R7
	BNE RETURN_RESULT
	
VER_1:
	CMP R5, #1
	BNE VER_2
	LDR R7, [R4, #12] 	// [1,0]
	LDR R8, [R4, #16]	// [1,1]
	LDR R9, [R4, #20]	// [1,2]
	
	CMP R7, R8
	BNE VER_2
	
	CMP R8, R9
	BNE VER_2
	
	// line is a win!
	CMP R7, #0
	BEQ VER_2
	MOVNE R0, R7
	BNE RETURN_RESULT
	
VER_2:
	CMP R5, #2
	BNE CHECK_GRID_LOOP_UPDATE
	LDR R7, [R4, #24] 	// [2,0]
	LDR R8, [R4, #28]	// [2,1]
	LDR R9, [R4, #32]	// [2,2]
	
	CMP R7, R8
	BNE CHECK_GRID_LOOP_UPDATE
	
	CMP R8, R9
	BNE CHECK_GRID_LOOP_UPDATE
	
	// line is a win!
	CMP R7, #0
	BEQ CHECK_GRID_LOOP_UPDATE
	MOVNE R0, R7
	BNE RETURN_RESULT
	
	
CHECK_GRID_LOOP_UPDATE:
	SUBS R5, #1
	BGE CHECK_GRID_LOOP
	
	// check for left diagonal
	// [0,0] == [1,1] == [2,2]
LEFT_DIAGONAL:
	LDR R7, [R4] 		// [0,0]
	LDR R8, [R4, #16]	// [1,1]
	LDR R9, [R4, #32]	// [2,2]
	
	CMP R7, R8
	BNE RIGHT_DIAGONAL
	
	CMP R8, R9
	BNE RIGHT_DIAGONAL
	
	// left diagonal is a win!
	MOVEQ R0, R7
	BEQ RETURN_RESULT
	
	// check for right diagonal
	// [2,0] == [1,1] == [0,2]
RIGHT_DIAGONAL:
	LDR R7, [R4, #24] 	// [2,0]
	LDR R8, [R4, #16]	// [1,1]
	LDR R9, [R4, #8]	// [0,2]
	
	CMP R7, R8
	BNE DRAW
	
	CMP R8, R9
	BNE DRAW
	
	// left diagonal is a win!
	MOVEQ R0, R7
	BEQ RETURN_RESULT
	
	// check for draw
	// have already checked if someone won, so if we reach this case and number of plays is 9,
	// there is a draw
DRAW:
	CMP R11, #9
	MOVEQ R0, #3
	
	// have checked every case, none applies, the game is still on
	MOVNE R0, #0
	
RETURN_RESULT:
	POP {R4-R9}
	BX LR


// returns x [0,2] and y[0,2] based on move [1,9]
// input
// R0: move [1,9]
// return
// R0: x [0,2]
// R1: y [0,2]
get_move_coordinates_ASM:
	PUSH {R4-R5}
	SUB R0, #1
	MOV R4, R0
	
	// y = move / 3
	MOV R1, #3
	PUSH {LR}
	BL divide_ASM
	POP {LR}
	
	MOV R5, R0
	MOV R0, R4
	
	// x = move % 3
	PUSH {LR}
	BL modulo_ASM
	POP {LR}
	
	MOV R1, R5
	
	POP {R4-R5}
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
	
	
// self-explanatory
// input
// R0: x1
// R1: x2
// return
// R0: x1 / x2
divide_ASM:
	PUSH {R4}
	
	MOV R4, #0

DIVIDE_LOOP:
	CMP R0, R1
	SUBGE R0, R1
	ADDGE R4, #1
	BGE DIVIDE_LOOP
	
	MOV R0, R4
	POP {R4}
	BX LR
	
END:
    B END
.end