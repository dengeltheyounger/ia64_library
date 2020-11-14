# Function prints a given null terminated buffer.
# Argument in rdi is buffer to be printed.
# Function returns the number of bytes written.

.include "prologue_epilogue.h"

.section .text
	.global print
print:
	prologue
	# count is stored in rax. Move to rdx
	call	string_length
	leal	(%eax), %edx
	# move write sys call to rax
	leal	(1), %eax
	# move buffer to rsi
	leaq	(%rdi), %rsi
	# store stdout file descriptor in rdi
	leal	(1), %edi
	syscall
	epilogue
	ret	
