include irvine32.inc
.data
	n	dd 	?
	arr	dd	128 dup(?)
.code

readArray proc
	call	readInt
	push	eax
	pushad
	mov	esi, 1
	mov	ecx, eax
again:
	cmp	esi, ecx
	jg	final
	call	readInt
	mov	[edx+4*esi], eax
	inc	esi
	jmp	again
final:
	popad
	pop	eax
	ret
readArray endp

adjustHeap proc
	push	ebp
	mov	ebp, esp
	pushad
	mov	edx, [ebp+16]
	mov	ecx, [ebp+12]
	mov	esi, [ebp+8]
again:
	mov	ebx, esi
	shl	esi, 1
	cmp	esi, ecx
	jg	next2
	mov	edi, [edx+4*esi]
	cmp	edi, [edx+4*ebx]
	jg	next1
	mov	ebx, esi
next1:
	or	esi, 1
	cmp	esi, ecx
	jg	next2
	mov	edi, [edx+4*esi]
	cmp	edi, [edx+4*ebx]
	jg	next2
	mov	ebx, esi
next2:
	shr	esi, 1
	cmp	ebx, esi
	je	final
	mov	edi, [edx+4*ebx]
	xchg	edi, [edx+4*esi]
	xchg	[edx+4*ebx], edi
	mov	esi, ebx
	jmp	again
final:
	popad
	pop	ebp
	ret	12
adjustHeap endp

makeHeap proc
	push	ebp
	mov	ebp, esp
	pushad
	mov	edx, [ebp+12]
	mov	ecx, [ebp+8]
	shr	ecx, 1
again:
	push	[ebp+12]
	push	[ebp+8]
	push	ecx
	call	adjustHeap
	loop	again
final:
	popad
	pop	ebp
	ret	8
makeHeap endp

popHeap proc
	push	ebp
	mov	ebp, esp
	sub	esp, 4
	pushad
	mov	edx, [ebp+12]
	mov	ecx, [ebp+8]
	mov	eax, [edx+4]
	mov	[ebp-4], eax
	
	mov	eax, [edx+4*ecx]
	mov	[edx+4], eax
	dec	ecx
	push	edx
	push	ecx
	push	1
	call	adjustHeap
final:
	popad
	pop	eax
	pop	ebp
	ret
popHeap endp

main proc
	lea	edx, arr
	call	readArray
	mov	n, eax
	
	push	offset arr
	push	n
	call	makeHeap
	
	mov	ecx, n
again:
	push	offset arr
	push	ecx
	call	popHeap
	call	writeInt
	mov	al, ' '
	call	writeChar
	loop	again
	exit
main endp
end main