# This function computes the power given a base and exponent
# rdi contains the base
# rsi contains the exponent
# rax:rdx contains the computed power
.section .data
	overflowfound:
		.asciz "Overflow detected while computing power.\n"
.section .text
	.global power
power:
	# Check to see if exponent is 0
	cmp	$0, %esi
	# Return 1 if the exponent is zero
	je	zero_exponent
	# Clear edx
	xorl	%edx, %edx
	# load base into eax
	movl	%edi, %eax
	# Decrement esi to account for first power
	decl	%esi
	# Store base in ecx for multiplication
	leal	(%eax), %ecx
compute:
	# Multiply base by rax
	imulq	%rcx
	# Exit if overflow occurs
	jo	overflow_found
	# decrement exponent and check to see if its zero
	decl	%esi
	cmp	$0, %esi
	# Return if it is
	jnz	compute
	ret
zero_exponent:
	# Set eax to 1 and return result
	leal	(1), %eax
	ret
overflow_found:
	# Print overflow error and exit
	leaq	(overflowfound), %rdi
	call	print
	leal	(60), %eax
	leal	(1), %edi
	syscall
