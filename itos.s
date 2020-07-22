# This function converts an integer to a string. Up to 64 bits supported
# rdi contains the integer to be stringified
# rax contains a pointer to the zeroeth element of string
# rdx contains the number of bytes allocated to provide string
.section .data
	badalloc:
		.asciz "Failed to allocate requested memory\n"
.section .text
	.global itos
itos:
	# function prologue in case stack is used
	push	%rbp	
	movq	%rsp, %rbp
	# Preserve whatever is in rbx
	pushq	%rbx
	# rbx now contains zero which indicates a positive number
	leal	(0), %ebx
	movsx	%edi, %rdi
	cmp	$0, %rdi
	jg	setup
	# if rax is negative, negate it
	negq	%rdi
	# rbx now contains one which indicates a negative number
	leal	(1), %ebx
setup:
	leaq	(%rdi), %rax
	# Set up r8d for use as a counter
	xorl	%r8d, %r8d
	# Divisor is set to 10
	leal	(10), %ecx
get_length:
	# Clear the remainder
	xorl	%edx, %edx
	# Divide %eax by ecx. Quotient in eax, remainder in edx
	divq	%rcx
	incl	%r8d
	cmp	$0, %rax
	jz	prep_alloc
	jmp	get_length
prep_alloc:
	# Preserve the integer to be stringified again
	leaq	(%rdi), %r9
	# Set the size of array element to 1
	leal	(1), %edi
	cmp	$1, %rbx
	jnz	posalloc
negalloc:
	# Allocate enough memory for the negative sign, newline, and null terminator
	leal	2(%r8d), %esi
	# Preserve the memory allocation for later comparison
	leal	2(%r8d), %r8d
	jmp	allocate
posalloc:
	# Allocate enough memory for the newline and null terminator
	leal	1(%r8d), %esi
	# Preserve the memory allocation for later comparison
	leal	1(%r8d), %r8d
allocate:
	call	allocate_array
	# Check to see if the correct number of bytes was allocated
	cmp	%r8d, %edx
	# If not, declare a bad allocation and exit
	jne	bad_alloc
	cmp	$1, %rbx
	jne	prep_conversion
check_neg:
	# Add negative sign to first element of array
	movb	$'-', (%rax)
prep_conversion:
	# Go to the end of the array
	leaq	(%rax,%rdx), %rax
	# Add null terminator to the end
	movb	$0, (%rax)
	# Move to lower position
	decq	%rax
	# Add null terminator as placeholder for newline
	movb	$0, (%rax)
	# Move to lower position
	decq	%rax
	# Save address in r11
	leaq	(%rax), %r11
	# Store the integer to stringified in rax
	leaq	(%r9), %rax
	# Store the dividend in ecx
	# ecx is a scratch register, so we don't trust it to be preserved
	leal	(10), %ecx
convert:
	# zero edx
	xorl	%edx, %edx
	# Divide rax by rcx. Store remainder in string
	divq	%rcx
	addl	$48, %edx
	movb	%dl, (%r11)
	cmp	$0, %eax
	je	final_neg_check
	decq	%r11
	jmp	convert
final_neg_check:
	# Decrement for the - if the value was negative
	cmp	$1, %rbx
	jne	finished
	decq	%r11
finished:
	# Store the string array in rax
	leaq	(%r11), %rax
	# Store the number of bytes allocated in edx
	leal	(%r8d), %edx
exit:
	# Restore rbx
	popq	%rbx
	# function epilogue
	movq	%rbp, %rsp
	popq	%rbp
	ret
bad_alloc:
	# Inform user that a bad allocation was made
	leaq	(badalloc), %rdi
	call	print
	# Exit with error
	leal	(60), %eax
	leal	(1), %edi
	syscall
