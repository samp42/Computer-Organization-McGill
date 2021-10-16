.data
    .equ n, 5 // number to find fibonacci of

.text
.global _start
_start:
    mov a1, #1
    mov a2, #0
    mov v1, #n
    sub v1, v1, #1
    cmp v1, #0
	
loop:
    mov a3, a1
    add a1, a1, a2
    mov a2, a3
    subs v1, v1, #1 @ i-- and update CPSR
    bgt loop

end:
    b end
	
.end

