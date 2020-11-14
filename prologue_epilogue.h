# This macro defines the function prologue and epilogue

.ifndef	PROLOGUE_EPILOGUE_H
.set	PROLOGUE_EPILOGUE_H, 1

.macro	prologue
	pushq	%rbp
	movq	%rsp, %rbp
.endm

.macro	epilogue
	movq	%rbp, %rsp
	popq	%rbp
	ret
.endm

.endif
