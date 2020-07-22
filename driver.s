.section .data
	badalloc:
		.asciz "Failed to allocate the correct number of bytes.\n"
.section .text
	.global main
main:
	# Allocate a 7 character char array 
	leal	(1), %edi
	leal	(6), %esi
	# rax holds pointer to allocated array
	# rdx holds the number of bytes allocated
	call	allocate_array
	cmp	$6, %rdx
	jne	bad_alloc
	# Store "hello\n\0" in newly allocated array
	movb	$'H', (%rax)
	incq	%rax
	movb	$'e', (%rax)
	incq	%rax
	movb	$'l', (%rax)
	incq	%rax
	movb	$'l', (%rax)
	incq	%rax
	movb	$'o', (%rax)
	incq	%rax
	movb	$'\n', (%rax)
	incq	%rax
	# Add null terminator
	movb	$0, (%rax)
	# Go back to beginning of array
	subq	%rdx, %rax
	# Load address in rdi
	leaq	(%rax), %rdi
	# print message and exit
	call	print
	leal	(60), %eax
	leal	(0), %edi
	syscall
bad_alloc:
	leaq	(badalloc), %rdi
	call	print
	leal	(60), %eax
	leal	(1), %edi
	syscall
