include irvine32.inc
.data
.code

perfectNum proc

	push	esi
	push	ecx
	mov	esi, 1
	mov	ecx, 0
again:
	cmp	esi, eax
	jge	final
	push	eax
	push	edx
	mov	edx, 0
	div	esi
	cmp	edx, 0
	jne	next
	add	ecx, esi
next:
	pop	edx
	pop	eax
	inc	esi
	jmp	again
final:
	cmp	eax, ecx
	je	Yes
	mov	eax, 0
	jmp	endPerfectNum
Yes:
	mov	eax, 1
endPerfectNum:
	pop	ecx
	pop	esi
	ret
perfectNum endp

main proc
	call	readInt
	mov	esi, 2
	mov	ecx, 0
again:
	push	eax
	mov	eax, esi
	call	perfectNum
	cmp	eax, 1
	jne	next
	inc	ecx
next:
	pop	eax
	inc	esi
	cmp	ecx, eax
	jl	again

	dec	esi
	mov	eax, esi
	call	writeInt
	exit
main endp
end main