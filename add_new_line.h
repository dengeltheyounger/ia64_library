# This function adds a new line in the second to last element of the buffer given
# buffer (rdi) contains the buffer to which a new line is added
# size (rsi) contains the size of the string array
# rax contains the buffer 

.ifndef	ADD_NEW_LINE_H
.set	ADD_NEW_LINE_H, 1

.macro	add_new_line	buffer=%rdi, size=%rsi
	# go to second to last element of array
	leaq	-1(\buffer, \size), %rax
	# add one minus the size to rcx
	movb	$'\n', (%rax)
	# go back to beginning of the array
	leaq	-1(\size), %rcx
	# rax contains the reset buffer
	subq	%rcx, %rax
.endm

.endif
