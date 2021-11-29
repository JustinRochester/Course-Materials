include irvine32.inc
.data
.code

gcd proc
; input: eax, edx
; output: eax
	push	edx
	push	ebx
	mov		ebx, edx
again:
	cmp		ebx, 0
	je		final
	mov		edx, 0
	div		ebx
	mov		eax, ebx
	mov		ebx, edx
	jmp		again
final:
	pop		ebx
	pop		edx
	ret
gcd endp

main proc
	call	readInt
	mov		edx, eax
	call	readInt
	call	gcd
	call	writeInt
	exit
main endp
end main