# Argument in rdi is buffer to be printed.
.section .text
	.global print
print:
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
	ret	
