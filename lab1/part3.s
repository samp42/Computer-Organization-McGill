.text
	.equ size, 5
	arr: .word -1, 23, 0, 12, -7

.global _start
_start:
	mov a1, #size
	sub a1, a1, #1 @ size - 1
	mov v1, #0 @ step
	
	push {lr}
	bl first_loop
	pop {lr}
	
	b end
	
first_loop:
	push {v1-v6}
	cmp v1, a1
	
	popge {v1-v6}
	bxge lr
	
	push {lr}
	bl second_loop
	pop {lr}
	
	mov v2, #0
	add v1, v1, #1 @ step++
	b first_loop

second_loop:
	sub a2, a1, v1
	cmp v2, a2
	bxge lr
	
	@ v3 = (ptr + i) = #arr + (i*4)
	mov v3, #arr
	mov v4, #4
	mla v3, v2, v4, v3
	
	@ v4 = (ptr + i + 1) = v3 + 4
	add v4, v3, #4
	
	ldr v5, [v3]
	ldr v6, [v4]
	
	cmp v6, v5
	@ v5 <= v6 == ok
	bgt no_swap
	
	str v5, [v4]
	str v6, [v3]
	
no_swap:
	add v2, v2, #1 @ i++
	b second_loop
	
end:
	b end
.end
