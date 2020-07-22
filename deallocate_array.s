# rdi contains the zeroeth element of array to be deallocated
# rsi contains the number of bytes allocated
.section .data
	badrequest:
		.asciz "The requested number of bytes to be freed does not match the difference between current program break and desired program break. Error.\n"

.section .text
	.global deallocate_array

deallocate_array:
	# function prologue
	pushq	%rbp
	movq	%rbp, %rsp
	# Save rbx and r12
	pushq	%rbx
	pushq	%r12
	# Store the address in rbx
	leaq	(%rdi), %rbx
	# Store the number of bytes allocated in r12
	leal	(%esi), %r12d
check_boundary:
	# Get current program break
	leal	(0), %edi
	leal	(12), %eax
	syscall
	# get the number of bytes between rdi and current break
	subq	%rbx, %rax
	# Make sure that the number of bytes allocated matches
	# result in rax
	cmp	%r12, %rax
	jnz	bad_request
finish_deallocate:
	# Free  memory
	leaq	(%rcx), %rdi
	leal	(12), %eax
	syscall
	# Restore registers and exit
	popq	%r12
	popq	%rbx
	movq	%rbp, %rsp
	popq	%rbp
	ret
bad_request:
	leaq	(badrequest), %rdi
	call	print
	leal	(60), %eax
	leal	(1), %edi
	syscall
