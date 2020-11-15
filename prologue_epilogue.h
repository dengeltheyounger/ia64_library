# This macro defines the function prologue, epilogue, and exit routines

.ifndef	PROLOGUE_EPILOGUE_H
.set	PROLOGUE_EPILOGUE_H, 1

.macro	prologue
	pushq	%rbp
	movq	%rsp, %rbp
.endm

.macro	epilogue
	movq	%rbp, %rsp
	popq	%rbp
.endm

.endif
