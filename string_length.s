# Argument in rdi is pointed to string buffer to be counted
.section .text
	.global string_length
string_length:
	# rax will store counter
	xorl	%eax, %eax
check_null:
	# Check for null terminator at end
	movzb	(%rdi), %ecx
	cmpb	$0, %cl	
	jz	return_count
	incq	%rdi
	incl	%eax
	jmp	check_null
return_count:
	# reset rdi to its previous location
	subq	%rax, %rdi
	# include null terminator in string length
	incl	%eax
	ret
