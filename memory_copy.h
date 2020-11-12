# this function is meant to act as a rudimentary memcpy. It is not
# intended to be optimal.
# the reason I have it as a macro is because I want to avoid the overhead
# of a function call, while also minimizing the code needed to be written
# there is also a non macro version that can be used
# 
# dest (rdi) will contain the address of the destination buffer
# src (rsi) contains the destination buffer
# bytes (rdx) contains the number of bytes to be copied

# These function as header guards
.ifndef	MEMORY_COPY_H
.set	MEMORY_COPY_H, 1

.macro	memory_copy dest="%rdi", src="%rsi", bytes="%rdx"
	leaq	(\bytes), %rcx
	rep	movsb
	negq	\bytes
	leaq	(\dest,\bytes), %rax
.endm

.endif
