# rdi will contain the address of in which the permissions are to be changed
# rsi will contain the desired size. It should be zero unless the user desires something other than a page's worth
# rdx will contain the desired permissions

.include	"prologue_epilogue.h"

.section	.text
	.global	change_protections

change_protections:
	prologue
	# save the arguments before making the function call
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	call	get_page_size
	# restore arguments after making function call
	popq	%rdx
	popq	%rsi
	popq	%rdi
	# negate the page size
	negq	%rax
	# and it with rdi in order to align rdi on page boundary
	andq	%rax, %rdi
	cmp		$0, %rsi
	jnz		call_mprotect
	# rax is now positive to reflect length argument
	negq	%rax
	# set the length argument
	leaq	(%rax), %rsi
call_mprotect:
	# syscall 10 for mprotect
	leal	(10), %eax
	syscall
	epilogue
	ret
	
	
	
