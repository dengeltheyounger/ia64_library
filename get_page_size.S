# this function attempts to determine page size using mmap and munmap
# there are no arguments for this function
# rax contains the page size in kB
.include	"prologue_epilogue.h"

.section	.text
	.global	get_page_size
	
get_page_size:
		prologue
		# preserve callee saved registers
		pushq	%rbx
		pushq	%r12
		pushq	%r13
		pushq	%r14
		# this will be used to hold the page table size
		leal	(1), %ebx
		# this will contain the address returned by mmap
		xorl	%r12d, %r12d
		# This will hold the result of munmap
		xorl	%r13d, %r13d
		# used for lea
		xorl	%r14d, %r14d
	size_loop:
		# set address to zero. Kernel will choose
		xorl	%edi, %edi
		# twice ebx goes into length
		leaq	(%r14,%rbx,2), %rsi
		# PROT_NONE
		leal	(0x0), %edx
		# MAP_ANONYMOUS | MAP_PRIVATE
		leaq	(0x22), %r10
		# don't care about the file descriptor
		leaq	(-1), %r8
		# no offset from address
		leaq	(0), %r9
		# 9 for mmap syscall
		leal	(9), %eax
		syscall
		# check to see if a valid address was returned
		cmp		$0, %rax
		# indicate that mapping was bad
		jle		map_failed
		# save the address in r12
		leaq	(%rax), %r12
		# store the address in rdi for munmap syscall
		leaq	(%rax), %rdi
		# store address + n in rdi
		addq	%rbx, %rdi
		# length
		leaq	(%rbx), %rsi
		# munmap syscall
		leal	(11), %eax
		syscall
		# result stored in eax, save it in %r13
		leaq	(%rax), %r13
		# put the address back into rdi for munmap syscall
		leaq	(%r12), %rdi
		# twice n is put into rsi for total length allocated
		leaq	(%r14,%rbx,2), %rsi
		# munmap syscall number
		leal	(11), %eax
		syscall
		cmp		$0, %r13
		je		exit
		# multiply rbx by 2
		salq	%rbx
		jmp		size_loop
	exit:
		# return page size
		leaq	(%rbx), %rax
		epilogue
		ret
	map_failed:
		# return -1 to indicate that the mapping failed
		leal	(-1), %eax
		epilogue
		ret
		
		
	
