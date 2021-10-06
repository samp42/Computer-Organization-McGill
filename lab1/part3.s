.text
	.equ size, 5
	arr: .word -1, 23, 0, 12, -7

.global _start
_start:
	mov a1, #size
	sub a1, a1, #1 @ size - 1
	mov v1, #0 @ step
	
	push {a3-a4, v1-v6, lr}
	bl first_loop
	pop {a3-a4, v1-v6, lr}
	
	b end
	
first_loop:
	cmp v1, a1
	bxge lr
	
	push {alr}
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
	add r10, r10, #1
	
	add v2, v2, #1 @ i++
	b second_loop
	
end:
	b end
.end
int size = 5;
int array[] = {-1, 23, 0, 12, -7};
int *ptr = &array[0];

// Bubble sort algorithm
for (int step = 0; step < size - 1; step++) {
  for (int i = 0; i < size - step - 1; i++) {

    // Sorting in ascending order.
    // To sort in descending order, change ">" to "<".
    if (*(ptr + i) > *(ptr + i + 1)) {
      // Swap if the larger element is in a later position.
      int tmp = *(ptr + i);
      *(ptr + i) = *(ptr + i + 1);
      *(ptr + i + 1) = tmp;
    }
  }
}
// Output: Array = {-7,  -1,  0,  12,  23}