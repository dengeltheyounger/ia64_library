# This function converts a string to an integer. Up to 64 bits supported.
# rdi contains the buffer to be converted
# rax contains the integer
# rdx contains the old string buffer which may need to be freed
# Note that stoi will not account for any newlines at the end of the string
# It does expect a null terminator, however.

.section .text
	.global stoi
stoi:
	# Get the string length
	call	string_length
	# discount null terminator at the end
	decl	%eax
	# Go to the second to last element of array and store in r9
	leaq	-1(%rax, %rdi), %r9
	# Store digit count in r10
	leal	(%eax), %r10d
	# rdx will contain the digits place
	leal	(1), %edx
	# rcx will contain the digit to be converted
	xorl	%ecx, %ecx
	xorl	%eax, %eax
to_int:
	# Move digit to rcx
	movb	(%r9), %cl
	# See if the remaining digit is a negative sign
	cmp	$'-', %rcx
	je	negate
	# Subtract 48 to convert to integer
	leal	-48(%ecx), %ecx
	# multiply by digits place
	imull	%edx, %ecx
	# Store in rax
	addq	%rcx, %rax
	# clear ecx
	xorl	%ecx, %ecx
check_digit:
	# Decrement digit counter
	decl	%r10d
	# Check to see if we're finished with the digits
	cmp	$0, %r10d
	# Exit if so
	je 	finished
	# Otherwise, move to next digit
	decq	%r9
	# Multiply digits position by 10
	imull	$10, %edx
	# Repeat process
	jmp	to_int
finished:
	leaq	(%r9), %rdx
	ret
negate:
	imulq	$-1, %rax
	jmp	finished
