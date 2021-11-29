include irvine32.inc
.data
.code
gcd proc
; input: eax, edx
; output: the greatest common divisor: eax
	push	edx
again:
	cmp		edx, 0
	je		final
	cmp		eax, edx
	jg		swaped
	xchg	eax, edx
swaped:
	sub		eax, edx
	jmp		again
final:
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