.global _start
_start:


        ldr     r3, .colors+8
        str     r3, [sp]
        mov     r3, #120
        mov     r2, #214
        mov     r1, r3
        mov     r0, #106
        bl      draw_rectangle

end: b end

@ TODO: copy VGA driver here.


.colors:
        .word   2911
        .word   65535
        .word   45248

draw_rectangle:
        push    {r4, r5, r6, r7, r8, r9, r10, lr}
        ldr     r7, [sp, #32]
        add     r9, r1, r3
        cmp     r1, r9
        popge   {r4, r5, r6, r7, r8, r9, r10, pc}
        mov     r8, r0
        mov     r5, r1
        add     r6, r0, r2
        b       .line_L2
.line_L5:
        add     r5, r5, #1
        cmp     r5, r9
        popeq   {r4, r5, r6, r7, r8, r9, r10, pc}
.line_L2:
        cmp     r8, r6
        movlt   r4, r8
        bge     .line_L5
.line_L4:
        mov     r2, r7
        mov     r1, r5
        mov     r0, r4
        bl      VGA_draw_point_ASM
        add     r4, r4, #1
        cmp     r4, r6
        bne     .line_L4
        b       .line_L5