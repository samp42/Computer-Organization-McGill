.text
    n: .word 8 // variable for fibonacci's number to find

.global _start
_start:
	
    mov a1, #0
    mov a3, #0
    mov a2, #1
    ldr a4, n
    sub a4, a4, #1
	
    push {lr}

    bl fib

    pop {lr}

    @ result is in r0 (a1)
    
    b end
	
fib:
    @ compute sum of 2 previous numbers in a1
    add a1, a2, a3
    @ n-2 <- n-1
    mov a3, a2
    @ n-1 <- n
    mov a2, a1
    
    subs a4, a4, #1
    bgt fib
	
    bx lr
	
end:
    b end
.end

