include irvine32.inc
.data
	msg0	db	'It is not a prime number', 0
	msg1	db	'It is a prime number', 0
	msg	dd	offset msg0, offset msg1
.code

isPrime proc
	push	ebp
	mov	ebp, esp
	push	0
	pushad
	
	cmp	dword ptr [ebp+8], 1
	je	final
	mov	dword ptr [ebp-4], 1
	mov	esi, 2
again:
	mov	eax, esi
	mov	edx, 0
	mul	esi
	cmp	eax, [ebp+8]
	jg	final
	
	mov	eax, [ebp+8]
	mov	edx, 0
	div	esi
	cmp	edx, 0
	jne	next
	mov	dword ptr [ebp-4], 0
	jmp	final
next:
	inc	esi
	jmp	again
final:
	popad
	pop	eax
	pop	ebp
	ret	4
isPrime endp

main proc
	call	readInt
	push	eax
	call	isPrime
	mov	edx, [msg+eax*4]
	call	writeString
	exit
main endp
end main