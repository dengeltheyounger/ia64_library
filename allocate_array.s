# rdi represents the size of one element
# rsi represents the number of array elements
.section .data
	notpowermsg:
		.asciz "Array element size must be a power of 2.\n"
	invnumbmsg:
		.asciz "The number of array elements must be greater than zero.\n"
.section .text
	.global allocate_array

allocate_array:
	# Preserve array element size by copying into ecx and edx
	leal	(%edi), %ecx
	leal	(%edi), %edx
	# Check to see if element size is 1
	cmp	$1, %edi
	# Skip checking power if so
	jz	check_num_elem
check_pow:
	# check to see if rdi is power of 2
	andl	$1, %ecx
	testl	%ecx, %ecx
	# if not, exit with error
	jne not_power
	# Divide by 2 and check to see if the result is one
	shrl	$1, %ecx
	cmp	$1, %ecx
	# Go back to the beginning of loop if not
	jnz	check_pow
check_num_elem:
	# make sure that the number of array elements is greater than zero
	cmp	$0, %rsi
	jle	inv_numb
curr_add_break:
	# Get the current address break
	leal	(12), %eax
	leal	(0), %edi
	syscall
new_add_break:
	# Multiply rdx by rsi, and then add rax + rdx into rdi
	# The result should contain the new break boundary
	imull	%esi, %edx
	# rdx will act as second return value containing number of bytes allocated
	leaq	(%rax, %rdx), %rdi
	leal	(12), %eax
	syscall
exit:
	# Have rax point to original break
	# rdx will have the number of bytes allocated
	subq	%rdx, %rax
	ret
not_power:
	leaq	(notpowermsg), %rdi
	call	print
	leal	(60), %eax
	leal	(1), %edi
	syscall
inv_numb:
	leaq	(invnumbmsg), %rdi
	call	print
	leal	(60), %eax
	leal	(1), %edi
	
