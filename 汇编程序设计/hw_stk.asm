include irvine32.inc
.data
	msg	db	'Hello World!', 0
.code
hw proc
	push	ebp
	mov	ebp, esp
	pushad
	mov	edx, [ebp+8]
	call	writeString
	popad
	ret	8
hw endp
main proc
	push	offset msg
	call	hw
	exit
main endp
end main