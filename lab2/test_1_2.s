.text
.equ HEX0_MEMORY, 0xFF200020
.equ HEX1_MEMORY, 0xFF200024
.equ HEX2_MEMORY, 0xFF200028
.equ HEX3_MEMORY, 0xFF20002c
.equ HEX4_MEMORY, 0xFF200030

.equ HEX_ON, 0x0000007f
.equ HEX_OFF, 0x0000000

.equ HEX0, 0x00000001
.equ HEX1, 0x00000002
.equ HEX2, 0x00000004
.equ HEX3, 0x00000008
.equ HEX4, 0x00000010
.equ HEX5, 0x00000020
.equ HEX6, 0x00000040

.global _start
_start:

	mov R1, #HEX_ON

	ldr R0, =HEX0_MEMORY
	str R1, [R0]
	ldr R0, =HEX1_MEMORY
	str R1, [R0]
	ldr R0, =HEX2_MEMORY
	str R1, [R0]
	ldr R0, =HEX3_MEMORY
	str R1, [R0]
	ldr R0, =HEX4_MEMORY
	str R1, [R0]
	
	b end

end:
	b end
.end
