.text
    n: .word 8 // variable for fibonacci's number to find

.global _start
_start:
	
    mov a1, #0
    mov a2, #1
	mov a3, #1
    ldr a4, n
	
    push {lr}

    bl fib

    pop {lr}

    @ result is in r0 (a1)
    
    b end
	
fib:
	
	@ <= 1 ?
	cmp a4, #1
	addle a2, a2, a3
	ble exit
	
	@ fib(n-1)
	sub a4, a4, #1
	push {lr}
	bl fib
	pop {lr}
	add a1, a1, a2
	
	@ fib(n-2)
	sub a4, a4, #1
	push {lr}
	bl fib
	pop {lr}
	add a1, a1, a2
	
exit:	
    bx lr
	
end:
    b end
.end
