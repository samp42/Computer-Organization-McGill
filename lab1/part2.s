.text
// fx[10][10]
fx:
	.word 183, 207, 128, 30, 109, 0, 14, 52, 15, 210
	.word 228, 76, 48, 82, 179, 194, 22, 168, 58, 116
	.word 228, 217, 180, 181, 243, 65, 24, 127, 216, 118
	.word 64, 210, 138, 104, 80, 137, 212, 196, 150, 139
	.word 155, 154, 36, 254, 218, 65, 3, 11, 91, 95
	.word 219, 10, 45, 193, 204, 196, 25, 177, 188, 170
	.word 189, 241, 102, 237, 251, 223, 10, 24, 171, 71
	.word 0, 4, 81, 158, 59, 232, 155, 217, 181, 19
	.word 25, 12, 80, 244, 227, 101, 250, 103, 68, 46
	.word 136, 152, 144, 2, 97, 250, 47, 58, 214, 51

// kx[5][5]
kx:
	.word 1, 1, 0, -1, -1
	.word 0, 1, 0, -1, 0
	.word 0, 0, 1, 0, 0
	.word 0, -1, 0, 1, 0
	.word -1, -1, 0, 1, 1

// result gx[10][10]
gx: .space 400

// image width
.equ iw, 10
// image height
.equ ih, 10
// kernel width
.equ kw, 5
// kernel height
.equ kh, 5
// kernel width stride
.equ kws, 2
// kernel height stride
.equ khs, 2

.global _start
_start:
	@ loop arguments
	mov a1, #ih
	mov a2, #iw
	mov a3, #kw
	mov a4, #kh
	
	@ y
	mov v1, #0
	@ x
	mov v2, #0
	@ i
	mov v3, #0
	@ j
	mov v4, #0
	
	push {v1-v8, lr}
	@ stack now:
	@ | A1 |
	@ | A2 |
	@ | A3 |
	@ | A4 |
	@ | LR |
	bl y_loop
	
	pop {v1-v8, lr}
	b end
	
y_loop:
	@ 0...ih-1
	cmp v1, a1
	@ >= 0 ? exit
	bxge lr
	@ go to x_loop
	push {lr}
	bl x_loop
	pop {lr}
	
	@ reset 1st nested loop
	mov v2, #0
	add v1, v1, #1 @ y++
	b y_loop
	
x_loop:
	@ 0...iw-1
	cmp v2, a2
	@ >= 0 ? go to y_loop
	bxge lr
	@ callee-save convention
	push {v5}
	@ sum = 0
	mov v5, #0
	
	@ go to i_loop
	push {lr}
	bl i_loop
	pop {lr}
	
	pop {v5}
	
	@ reset 1st nested loop
	mov v3, #0
	add v2, v2, #1 @ x++
	b x_loop
	
i_loop:
	@ 0...kw-1
	cmp v3, a3
	@ >= 0 ? go to x_loop
	bxge lr
	
	@ go to j_loop
	push {lr}
	bl j_loop
	pop {lr}

	@ reset 1st j_loop
	mov v4, #0
	add v3, v3, #1 @ i++
	b i_loop

j_loop:
	@ 0...kh-1
	cmp v4, a4
	@ >0 ? go to i_loop
	bxge lr
	
	@ callee-save convention
	push {v6, v7, v8}
	@ temp1 = x+j - kws
	add v6, v2, v4
	subs v6, v6, #kws
	@ temp1 < 0
	blt else
	cmp v6, #9
	@ temp1 > 9
	bgt else
	
	@ temp2 = y+i - khs
	add v7, v1, v3
	subs v7, v7, #khs
	@ temp2 < 0
	blt else
	cmp v6, #9
	@ temp2 > 9
	bgt else
	
	push {v1, v2}
	@ kx[j][i] = #kx + (j*5 + i) * 4
	mov v1, #kx
	mov v2, #5
	mla v2, v4, v2, v3
	mov v8, #4
	mla v1, v2, v8, v1
	@ v1 contains &k[j][i]
	@ v1 = *(&k[j][i])
	ldr v1, [v1]
	
	
	@ &fx[temp1][temp2] = #fx + (temp1*10 + temp2) * 4
	mov v2, #10
	mla v2, v6, v2, v7
	mov v7, #fx
	mla v2, v2, v8, v7
	
	@ v2 contains &fx[temp1][temp2]
	@ v2 = *(&fx[temp1][temp2])
	ldr v2, [v2]
	
	@ sum += kx[j][i] * fx [temp1][temp2]
	mla v5, v1, v2, v5
		
	pop {v1, v2}
	@ temporarily free up v5
	push {v5}
	@ gx[x][y] = sum
	@ &gx[x][y] = #gx + (x*10 + y) * 4
	mov v5, #10
	mla v8, v2, v5, v1
	mov v5, #4
	mul v8, v8, v5
	mov v5, #gx
	add v8, v8, v5
	
	pop {v5}
	
	str v5, [v8]
	
else:
	pop {v6, v7, v8}
	add v4, v4, #1 @ j++
	b j_loop
	
end:
	b end
.end
