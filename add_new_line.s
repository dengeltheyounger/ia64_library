# This function adds a new line in the second to last element of the buffer given
# rdi contains the buffer to which a new line is added
# rsi contains the size of the string array
# rax contains the buffer 

.section .text
	.global add_new_line

add_new_line:
	# Go to the second to last element of array
	leaq	-1(%rdi, %rsi), %rax
	# Add new line to element of array
	movb	$'\n', (%rax)
	# Add one minus the size to rcx
	leaq	-1(%rsi), %rcx
	# Go back to beginning of array
	subq	%rcx, %rax
	# rax contains the buffer
	ret
