# Function prints a given null terminated buffer.
# Argument in rdi is buffer to be printed.

.ifndef	PRINT_H
.set	PRINT_H, 1

.macro	print	buffer=%rdi
	# use a function call instead of a macro
	call	string_length
	leal	(%eax), %edx
	# write syscall
	leal	(1), %eax
	# move buffer to rsi
	leaq	(%rdi), %rsi
	# stdout file descriptor
	leal	(1), %edi
	syscall
.endm
	

.endif
