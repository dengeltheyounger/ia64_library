# this function is meant to act as a rudimentary memcpy. It is not
# intended to be optimal.
# the reason I have it as a macro is because I want to avoid the overhead
# of a function call, while also minimizing the code needed to be written
# there is also a non macro version that can be used
# 
# dest (rdi) will contain the address of the destination buffer
# src (rsi) contains the destination buffer
# bytes (rdx) contains the number of bytes to be copied

.include "prologue_epilogue.h"

.section	.text
	.global memory_copy

memory_copy:
	prologue
	leal	(%edx), %ecx
	rep	movsb
	leaq	(%rdi), %rax
	# rep does not reset buffer, therefore negative edx and subtract offset
	# and store address of dest buffer in %rax
	negq	%rdx
	leaq	(%rdi, %rdx), %rax
	epilogue
	ret
