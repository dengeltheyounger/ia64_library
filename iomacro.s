# It is intended that this file is included 
# using the .include directive

.section .data
	# Basic expressions for conditional assembly
	CREATE		equ	1
	OVERWRITE	equ	1
	APPEND		equ	1
	O_WRITE		equ	1
	READ		equ	1
	O_READ		equ	1
	DELETE		equ	1
	# syscall symbols
	SYS_READ	equ	0
	SYS_WRITE	equ	1
	SYS_OPEN	equ	2
	SYS_CLOSE	equ	3
	SYS_LSEEK	equ	8
	SYS_CREATE	equ	85
	SYS_UNLINK	equ	87
	# Creation flags
	O_CREAT		equ	00000100q
	O_APPEND	equ	00002000q
	# Access mode
	O_RDONLY	equ	000000q
	O_WRONLY	equ	000001q
	O_RDWR		equ	000002q
	# User permissions
	S_IRUSR		equ	00400q	# User read permission
	S_IWUSR		equ	00200q	# User write permission
	
	NL		equ	0xa
	# File descriptors
	STDIN		equ	0
	STDOUT		equ	1
	STDERR		equ	2
